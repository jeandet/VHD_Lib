----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:16:12 03/29/2011 
-- Design Name: 
-- Module Name:    top - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
library gaisler;
use gaisler.memctrl.all;
use gaisler.uart.all;
use gaisler.misc.all;
use gaisler.leon3.all;
library esa;
use esa.memoryctrl.all;
use work.config.all;
library techmap;
use techmap.gencomp.all;
use techmap.allclkgen.all;
library lpp;
use lpp.lpp_amba.all;
use lpp.lpp_memory.all;
use lpp.lpp_usb.all;

entity top is
	generic (
		fabtech : integer := CFG_FABTECH;
		memtech : integer := CFG_MEMTECH;
		padtech : integer := CFG_PADTECH;
		clktech : integer := CFG_CLKTECH;
		disas   : integer := CFG_DISAS;     -- Enable disassembly to console
		dbguart : integer := CFG_DUART;     -- Print UART on console
		pclow   : integer := CFG_PCLOW);
	Port (
        clk50MHz	: in  STD_LOGIC;
		reset		: in  STD_LOGIC;
		
        data	: inout std_logic_vector(31 downto 0);
        ramben 	: out std_logic_vector (3 downto 0);
        address : out std_logic_vector(18 downto 0);        
        ramsn  	: out std_logic;
        romsn  	: out std_logic;
        iosn  	: out std_logic;
        rwen   	: out std_logic;
        oen    	: out std_ulogic;
        ramoen 	: out std_logic;
        writen 	: out std_ulogic;
        gpio    : inout std_logic_vector(6 downto 0);
        
        sram_adv    : out std_logic;
        sram_pwrdwn : out std_logic;
        sram_gwen   : out std_logic;
        sram_adsc   : out std_logic;
        sram_adsp   : out std_logic;
        ramclk 	    : out std_logic;
        
        led         : out std_logic_vector(5 downto 0);
	ahbrxd	    : in std_ulogic;
	ahbtxd	    : out std_ulogic
	);
end top;

architecture Behavioral of top is

--Clk & Rst géné
signal vcc		: std_logic_vector(4 downto 0);
signal gnd   	: std_logic_vector(4 downto 0);
signal clkm		: std_ulogic;
signal lclk		: std_ulogic;
signal rstn		: std_ulogic;
signal clk2x	: std_ulogic;
signal rstraw	: std_logic;
signal rstneg	: std_logic;
signal lock 	: std_logic;
signal cgi		: clkgen_in_type;
signal cgo		: clkgen_out_type;
--- AHB / APB
signal apbi		:	apb_slv_in_type;
signal apbo		:	apb_slv_out_vector := (others => apb_none);
signal ahbsi	:	ahb_slv_in_type;
signal ahbso	:	ahb_slv_out_vector := (others => ahbs_none);
signal ahbmi	:	ahb_mst_in_type;
signal ahbmo	:	ahb_mst_out_vector := (others => ahbm_none);
-- AHBUART
signal ahbuarti:	uart_in_type;
signal ahbuarto:	uart_out_type;
signal apbuarti:	uart_in_type;
signal apbuarto:	uart_out_type;
signal rxd2		:	std_ulogic;
signal rxd1		:	std_ulogic;
signal txd1		:	std_ulogic;
--MEM CTRLR
signal memi  : memory_in_type;
signal memo  : memory_out_type;
signal wpo   : wprot_out_type;
signal sdi   : sdctrl_in_type;
signal sdo   : sdram_out_type;
--IRQ
signal irqi : irq_in_vector(0 to CFG_NCPU-1);
signal irqo : irq_out_vector(0 to CFG_NCPU-1);
--Timer
signal gpti : gptimer_in_type;
signal gpto : gptimer_out_type;
signal dsui : dsu_in_type;
signal dsuo : dsu_out_type;
--GPIO
signal gpioi : gpio_in_type;
signal gpioo : gpio_out_type; 

constant BOARD_FREQ : integer := 50000;   -- input frequency in KHz

component CLKINT
port( A : in    std_logic := 'U';
      Y : out   std_logic);
end component;

begin

  sram_pwrdwn <= '0';
  sram_gwen  <= '1';
  sram_adsc <= '0';
  sram_adsp <= '1';

----------------------------------------------------------------------
---  Reset and Clock generation  -------------------------------------
----------------------------------------------------------------------
  vcc <= (others => '1'); gnd <= (others => '0');
  cgi.pllctrl <= "00"; cgi.pllrst <= rstraw;
  rstneg <=  reset;
	
  rst0 : rstgen port map (rstneg, clkm, lock, rstn, rstraw);
  lock <= cgo.clklock;
  
  --clk_pad : clkpad generic map (tech => padtech) port map (clk50MHz, lclk); 
  clk_pad : CLKINT port map (clk50MHz, lclk); 

  clkgen0 : clkgen  		-- clock generator MUL 4, DIV 5
  generic map (fabtech, CFG_CLKMUL, CFG_CLKDIV, 0, 0, 0, 0, 0, BOARD_FREQ, 0)
  port map (lclk, gnd(0), clkm, open, open, open, open, cgi, cgo, open, open, clk2x);

  ramclk <= clkm;
  
-------------------------------
--- AHB CONTROLLER ------------
-------------------------------
ahb0 : ahbctrl -- AHB arbiter/multiplexer
	generic map (defmast => CFG_DEFMST, split => CFG_SPLIT,
	rrobin => CFG_RROBIN, ioaddr => CFG_AHBIO, ioen => 1,
	nahbm => CFG_NCPU+CFG_AHB_UART,
	nahbs => 2)
	port map (rstn, clkm, ahbmi, ahbmo, ahbsi, ahbso);

	
-------------------------------	
--- AHBUART -------------------
-------------------------------
dcom0 : ahbuart -- AMBA AHB Serial Debug Interface
	generic map (hindex => CFG_NCPU, pindex => 4, paddr => 4)
	port map (rstn, clkm, ahbuarti, ahbuarto, apbi, apbo(4), ahbmi, ahbmo(CFG_NCPU));
dsurx_pad : inpad generic map (tech  => padtech) port map (ahbrxd, rxd2);
dsutx_pad : outpad generic map (tech => padtech) port map (ahbtxd, ahbuarto.txd);
ahbuarti.rxd <= rxd2;



----------------------------------------------------------------------
---  Memory controllers ----------------------------------------------
----------------------------------------------------------------------
  mctrl2 : if (CFG_MCTRL_LEON2 = 1) and (CFG_SSCTRL = 0) generate 	-- LEON2 memory controller
    sr1 : mctrl generic map (hindex => 0, pindex => 0, paddr => 0, 
	srbanks => 2, sden => CFG_MCTRL_SDEN, ram8 => CFG_MCTRL_RAM8BIT,
	ram16 => CFG_MCTRL_RAM16BIT, invclk => CFG_MCTRL_INVCLK)
    port map (rstn, clkm, memi, memo, ahbsi, ahbso(0), apbi, apbo(0), wpo, sdo);
    sram_adv <= '1';
    ramben_pads : for i in 0 to 3 generate
      x : outpad generic map (tech => padtech) 
	port map (ramben(i), memo.mben(3-i));
    end generate;
  end generate;

  mempads : if (CFG_MCTRL_LEON2 = 1) or (CFG_SSCTRL = 1) generate 	-- LEON2 memory controller
    addr_pad : outpadv generic map (width => 19, tech => padtech) 
	port map (address, memo.address(20 downto 2)); 
    rams_pad : outpad generic map (tech => padtech) 
	port map (ramsn, memo.ramsn(0)); 
    roms_pad : outpad generic map (tech => padtech) 
	port map (romsn, memo.romsn(0)); 
    iosn_pad : outpad generic map (tech => padtech) 
	port map (iosn, memo.iosn); 
    oen_pad  : outpad generic map (tech => padtech) 
	port map (oen, memo.oen);
    rwen_pad : outpad generic map (tech => padtech) 
	port map (rwen, memo.writen); 
    roen_pad : outpad generic map (tech => padtech) 
	port map (ramoen, memo.ramoen(0));
    wri_pad  : outpad generic map (tech => padtech) 
	port map (writen, memo.writen);

    bdr : for i in 0 to 3 generate
      data_pad : iopadv generic map (tech => padtech, width => 8)
      port map (data(31-i*8 downto 24-i*8), memo.data(31-i*8 downto 24-i*8),
	memo.bdrive(i), memi.data(31-i*8 downto 24-i*8));
    end generate;

  end generate;

  memi.brdyn <= '1'; memi.bexcn <= '1';
  memi.writen <= '1'; memi.wrn <= "1111"; memi.bwidth <= "10";


----------------------------------------------------------------------
---  IRQ -------------------------------------------------------------
----------------------------------------------------------------------
 irqctrl : if CFG_IRQ3_ENABLE /= 0 generate
    irqctrl0 : irqmp			-- interrupt controller
    generic map (pindex => 2, paddr => 2, ncpu => CFG_NCPU)
    port map (rstn, clkm, apbi, apbo(2), irqo, irqi);
  end generate;
  irq3 : if CFG_IRQ3_ENABLE = 0 generate
    x : for i in 0 to CFG_NCPU-1 generate
      irqi(i).irl <= "0000";
    end generate;
    apbo(2) <= apb_none;
  end generate;


----------------------------------------------------------------------
---  APB/AHB Bridge and various periherals ---------------------------
----------------------------------------------------------------------
    apb0 : apbctrl				-- AHB/APB bridge
  generic map (hindex => 1, haddr => CFG_APBADDR)
  port map (rstn, clkm, ahbsi, ahbso(1), apbi, apbo );


   gpt : if CFG_GPT_ENABLE /= 0 generate
    timer0 : gptimer 			-- timer unit
    generic map (pindex => 3, paddr => 3, pirq => CFG_GPT_IRQ, 
	sepirq => CFG_GPT_SEPIRQ, sbits => CFG_GPT_SW, ntimers => CFG_GPT_NTIM, 
	nbits => CFG_GPT_TW)
    port map (rstn, clkm, apbi, apbo(3), gpti, gpto);
    gpti.dhalt <= dsuo.tstop; gpti.extclk <= '0';
    led(4) <= gpto.wdog;
  end generate;
  notim : if CFG_GPT_ENABLE = 0 generate apbo(3) <= apb_none; end generate;


    gpio0 : if CFG_GRGPIO_ENABLE /= 0 generate     -- GR GPIO unit
    grgpio0: grgpio
      generic map( pindex => 11, paddr => 11, imask => CFG_GRGPIO_IMASK, nbits => 7)
      port map( rstn, clkm, apbi, apbo(11), gpioi, gpioo);

      pio_pads : for i in 0 to 6 generate
        pio_pad : iopad generic map (tech => padtech)
            port map (gpio(i), gpioo.dout(i), gpioo.oen(i), gpioi.din(i));
      end generate;
   end generate;

end Behavioral;