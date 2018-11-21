

library ieee;
use ieee.std_logic_1164.all;
USE IEEE.NUMERIC_STD.ALL;
library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;
library techmap;
use techmap.gencomp.all;
use techmap.allclkgen.all;
library gaisler;
use gaisler.memctrl.all;
use gaisler.leon3.all;
use gaisler.uart.all;
use gaisler.misc.all;
use gaisler.spi.all;
--pragma translate_off
use gaisler.sim.all;
--pragma translate_on
library opencores;
use opencores.spwpkg.all;
use opencores.spwambapkg.all;

use work.config.all;

library unisim;
use unisim.vcomponents.all;

entity leon3mp is
  generic (
    fabtech  : integer := CFG_FABTECH;
    memtech  : integer := CFG_MEMTECH;
    padtech  : integer := CFG_PADTECH;
    clktech  : integer := CFG_CLKTECH;
    disas    : integer := CFG_DISAS;     -- Enable disassembly to console
    dbguart  : integer := CFG_DUART;     -- Print UART on console
    pclow    : integer := CFG_PCLOW
    );
  port (
    CLK50  : in std_logic;
    LEDS   : inout std_logic_vector(7 downto 0);
    SW     : in std_logic_vector(4 downto 1);
    dram_addr : out std_logic_vector(12 downto 0);
    dram_ba_0	: out std_logic;
    dram_ba_1	: out std_logic;
    dram_dq	: inout std_logic_vector(15 downto 0);

    dram_clk  	: out std_logic;
    dram_cke  	: out std_logic;
    dram_cs_n  	: out std_logic;
    dram_we_n  	: out std_logic;        	-- sdram write enable
    dram_ras_n  : out std_logic;               	-- sdram ras
    dram_cas_n  : out std_logic;               	-- sdram cas
    dram_ldqm	  : out std_logic;		-- sdram ldqm
    dram_udqm	  : out std_logic;		-- sdram udqm
    uart_txd  	: out std_logic;		-- DSU tx data
    uart_rxd  	: in  std_logic;		-- DSU rx data

    spw_rxdp      : in  std_logic;
    spw_rxdn      : in  std_logic;
    spw_rxsp      : in  std_logic;
    spw_rxsn      : in  std_logic;
    spw_txdp      : out std_logic;
    spw_txdn      : out std_logic;
    spw_txsp      : out std_logic;
    spw_txsn      : out std_logic;

    lesia_gen     : in std_logic;
    GPS_PPS_in    : in std_logic;

    LCD_TXD       : in std_logic;
    LCD_RXD       : out std_logic;

    spi_c         : out std_ulogic;
    spi_d         : out std_ulogic;
    spi_q         : in std_ulogic;
    spi_sn        : out std_ulogic;
    spi_wpn       : out std_ulogic;
    spi_hodln     : out std_ulogic
    );
end;

architecture rtl of leon3mp is
  signal resetn : std_logic;
  signal clkm, rstn, rstraw, rst : std_logic;
  signal clkm_inv : std_logic := '0';

  signal cptr :  std_logic_vector(29 downto 0);
  constant BOARD_FREQ : integer := 25000;                                -- CLK input frequency in KHz
  constant CPU_FREQ   : integer := BOARD_FREQ * CFG_CLKMUL / CFG_CLKDIV;  -- cpu frequency in KHz
  signal sdi   : sdctrl_in_type;
  signal sdo   : sdctrl_out_type;

--AMBA bus standard interface signals--
  signal apbi  : apb_slv_in_type;
  signal apbo  : apb_slv_out_vector := (others => apb_none);
  signal ahbsi : ahb_slv_in_type;
  signal ahbso : ahb_slv_out_vector := (others => ahbs_none);
  signal ahbmi : ahb_mst_in_type;
  signal ahbmo : ahb_mst_out_vector := (others => ahbm_none);

  signal cgi : clkgen_in_type;
  signal cgo : clkgen_out_type;

  signal dui : uart_in_type;
  signal duo : uart_out_type;

  signal irqi : irq_in_vector(0 to CFG_NCPU-1);
  signal irqo : irq_out_vector(0 to CFG_NCPU-1);

  signal dbgi : l3_debug_in_vector(0 to CFG_NCPU-1);
  signal dbgo : l3_debug_out_vector(0 to CFG_NCPU-1);

  signal dsui : dsu_in_type;
  signal dsuo : dsu_out_type;


  signal gpti : gptimer_in_type;
  signal gpto : gptimer_out_type;

  signal gpioi_0 : gpio_in_type;
  signal gpioo_0 : gpio_out_type;

  SIGNAL   apbuarti   : uart_in_type;
  SIGNAL   apbuarto   : uart_out_type;

  signal dsubren : std_logic :='0';

  signal spw_di: std_logic;
  signal spw_si: std_logic;
  signal spw_do: std_logic;
  signal spw_so: std_logic;
  signal spw_tick_in: std_logic;
  signal spw_tick_out: std_logic;

  -- SPIMCTRL signals
signal spmi1 : spimctrl_in_type;
signal spmo1 : spimctrl_out_type;

  component sdctrl16
  generic (
    hindex  : integer := 0;
    haddr   : integer := 0;
    hmask   : integer := 16#f00#;
    ioaddr  : integer := 16#000#;
    iomask  : integer := 16#fff#;
    wprot   : integer := 0;
    invclk  : integer := 0;
    fast    : integer := 0;
    pwron   : integer := 0;
    sdbits  : integer := 16;
    oepol   : integer := 0;
    pageburst : integer := 0;
    mobile  : integer := 0
  );
  port (
    rst     : in  std_ulogic;
    clk     : in  std_ulogic;
    ahbsi   : in  ahb_slv_in_type;
    ahbso   : out ahb_slv_out_type;
    sdi     : in  sdctrl_in_type;
    sdo     : out sdctrl_out_type
  );
end component;

begin
  resetn <= SW(1);

  clk_pad : clkpad generic map (tech => padtech) port map (CLK50, clkm);
  clkm_inv <= not clkm;

  resetn_pad : inpad generic map (tech => padtech) port map (resetn, rst);
  rst0 : rstgen			-- reset generator (reset is active LOW)
    port map (rst, clkm, '1', rstn, rstraw);


----------------------------------------------------------------------
---  AHB CONTROLLER --------------------------------------------------
----------------------------------------------------------------------

  ahb0 : ahbctrl 		-- AHB arbiter/multiplexer
  generic map (defmast => CFG_DEFMST, split => CFG_SPLIT,
	rrobin => CFG_RROBIN, ioaddr => CFG_AHBIO,
	nahbm => CFG_NCPU+CFG_AHB_UART+1, nahbs => 8)

  port map (rstn, clkm, ahbmi, ahbmo, ahbsi, ahbso);

----------------------------------------------------------------------
-----  LEON3 processor and DSU ---------------------------------------
----------------------------------------------------------------------

  cpu : for i in 0 to CFG_NCPU-1 generate
    nosh : if CFG_GRFPUSH = 0 generate
      u0 : leon3s 		-- LEON3 processor
      generic map (i, fabtech, memtech, CFG_NWIN, CFG_DSU, CFG_FPU*(1-CFG_GRFPUSH), CFG_V8,
	0, CFG_MAC, pclow, CFG_NOTAG, CFG_NWP, CFG_ICEN, CFG_IREPL, CFG_ISETS, CFG_ILINE,
	CFG_ISETSZ, CFG_ILOCK, CFG_DCEN, CFG_DREPL, CFG_DSETS, CFG_DLINE, CFG_DSETSZ,
	CFG_DLOCK, CFG_DSNOOP, CFG_ILRAMEN, CFG_ILRAMSZ, CFG_ILRAMADDR, CFG_DLRAMEN,
        CFG_DLRAMSZ, CFG_DLRAMADDR, CFG_MMUEN, CFG_ITLBNUM, CFG_DTLBNUM, CFG_TLB_TYPE, CFG_TLB_REP,
        CFG_LDDEL, disas, CFG_ITBSZ, CFG_PWD, CFG_SVT, CFG_RSTADDR, CFG_NCPU-1,
	0, 0, CFG_MMU_PAGE, CFG_BP, CFG_NP_ASI, CFG_WRPSR)
      port map (clkm, rstn, ahbmi, ahbmo(i), ahbsi, ahbso,
    		irqi(i), irqo(i), dbgi(i), dbgo(i));
    end generate;
  end generate;

  --ledr[0] lit when leon 3 debugvector signals error
  dsugen : if CFG_DSU = 1 generate
    dsu0 : dsu3			-- LEON3 Debug Support Unit (slave)
    generic map (hindex => 2, haddr => 16#900#, hmask => 16#F00#,
       ncpu => CFG_NCPU, tbits => 30, tech => memtech, irq => 0, kbytes => CFG_ATBSZ)
    port map (rstn, clkm, ahbmi, ahbsi, ahbso(2), dbgo, dbgi, dsui, dsuo);
    dsui.enable <= '1';

  end generate;
  nodsu : if CFG_DSU = 0 generate
    ahbso(2) <= ahbs_none; dsuo.tstop <= '0'; dsuo.active <= '0'; --no timer freeze, no light.
  end generate;

  dcomgen : if CFG_AHB_UART = 1 generate
    dcom0: ahbuart		-- Debug UART
    generic map (hindex => CFG_NCPU, pindex => 7, paddr => 7)
    port map (rstn, clkm, dui, duo, apbi, apbo(7), ahbmi, ahbmo(CFG_NCPU));
  end generate;
  uart_txd <= duo.txd;
  dui.rxd <= uart_rxd;


----------------------------------------------------------------------
---  Memory controllers ----------------------------------------------
----------------------------------------------------------------------


    sdc : sdctrl16 generic map (hindex => 3, haddr => 16#400#, hmask => 16#FE0#, -- hmask => 16#C00#,
	      ioaddr => 1, fast => 0, pwron => 0, invclk => 0,
	      sdbits => 16, pageburst => 2)
      port map (rstn, clkm, ahbsi, ahbso(3), sdi, sdo);
      sa_pad : outpadv generic map (width => 13, tech => padtech)
	   port map (dram_addr, sdo.address(14 downto 2));
      ba0_pad : outpad generic map (tech => padtech)
	   port map (dram_ba_0, sdo.address(15));
      ba1_pad : outpad generic map (tech => padtech)
	   port map (dram_ba_1, sdo.address(16));
      sd_pad : iopadvv generic map (width => 16, tech => padtech)
	   port map (dram_dq(15 downto 0), sdo.data(15 downto 0), sdo.vbdrive(15 downto 0), sdi.data(15 downto 0));
      sdcke_pad : outpad generic map (tech => padtech)
	   port map (dram_cke, sdo.sdcke(0));
      sdwen_pad : outpad generic map (tech => padtech)
	   port map (dram_we_n, sdo.sdwen);
      sdcsn_pad : outpad generic map (tech => padtech)
	   port map (dram_cs_n, sdo.sdcsn(0));
      sdras_pad : outpad generic map (tech => padtech)
	   port map (dram_ras_n, sdo.rasn);
      sdcas_pad : outpad generic map (tech => padtech)
	   port map (dram_cas_n, sdo.casn);
      sdldqm_pad : outpad generic map (tech => padtech)
	   port map (dram_ldqm, sdo.dqm(0) );
      sdudqm_pad : outpad generic map (tech => padtech)
	   port map (dram_udqm, sdo.dqm(1));
      dram_clk_pad : outpad generic map (tech => padtech)
	   port map (dram_clk, clkm_inv);



	   -- SPMCTRL core, configured for use with generic SPI Flash memory with read
    -- command 0x0B and a dummy byte following the address.
    spimctrl1 : spimctrl
      generic map (hindex => 4, hirq => 4, faddr => 16#000#, fmask => 16#fff#,
        ioaddr => 16#200#, iomask => 16#fff#, spliten => CFG_SPLIT,
        sdcard => 0, readcmd => 16#0B#, dummybyte => 1, dualoutput => 0,
        scaler => 1, altscaler => 1)
      port map (rstn, clkm, ahbsi, ahbso(4), spmi1, spmo1);

    spi_miso_pad : inpad generic map (tech => padtech)
      port map (spi_q, spmi1.miso);
    spi_mosi_pad : outpad generic map (tech => padtech)
      port map (spi_d, spmo1.mosi);
    spi_sck_pad : outpad generic map (tech => padtech)
      port map (spi_c, spmo1.sck);
    spi_slvsel0_pad : outpad generic map (tech => padtech)
      port map (spi_sn, spmo1.csn);
    spi_wpn_pad : outpad generic map (tech => padtech)
      port map (spi_wpn, '1');
    spi_holdn_pad : outpad generic map (tech => padtech)
      port map (spi_hodln, '1');

----------------------------------------------------------------------
---  APB Bridge and various periherals -------------------------------
----------------------------------------------------------------------

  apb0 : apbctrl				-- AHB/APB bridge
  generic map (hindex => 1, haddr => CFG_APBADDR)
  port map (rstn, clkm, ahbsi, ahbso(1), apbi, apbo );

----------------------------------------------------------------------------------------

    irqctrl : if CFG_IRQ3_ENABLE /= 0 generate
    irqctrl0 : irqmp			-- interrupt controller
    generic map (pindex => 2, paddr => 2, ncpu => CFG_NCPU)
    port map (rstn, clkm, apbi, apbo(2), irqo, irqi);
  end generate;
  irq3 : if CFG_IRQ3_ENABLE = 0 generate
    x : for i in 0 to CFG_NCPU-1 generate irqi(i).irl <= "0000"; end generate;
    apbo(2) <= apb_none;
  end generate;

  --Timer unit, generates interrupts when a timer underflow.
  gpt : if CFG_GPT_ENABLE /= 0 generate
    timer0 : gptimer 			-- timer unit
    generic map (pindex => 3, paddr => 3, pirq => CFG_GPT_IRQ,
	sepirq => CFG_GPT_SEPIRQ, sbits => CFG_GPT_SW, ntimers => CFG_GPT_NTIM,
	nbits => CFG_GPT_TW)
    port map (rstn, clkm, apbi, apbo(3), gpti, gpto);
    gpti <= gpti_dhalt_drive(dsuo.tstop);
  end generate;
  notim : if CFG_GPT_ENABLE = 0 generate apbo(3) <= apb_none; end generate;

    gpio0 : if CFG_GRGPIO_ENABLE /= 0 generate     -- GR GPIO0 unit
    grgpio0: grgpio
      generic map( pindex => 9, paddr => 9, imask => CFG_GRGPIO_IMASK, nbits => 8)
      port map( rstn, clkm, apbi, apbo(9), gpioi_0, gpioo_0);
      pio_pads : for i in 0 to 7 generate
        pio_pad : iopad generic map (tech => padtech)
            port map (LEDS(i), gpioo_0.dout(i), gpioo_0.oen(i), gpioi_0.din(i));
      end generate;
  end generate;
  nogpio0: if CFG_GRGPIO_ENABLE = 0 generate apbo(9) <= apb_none; end generate;

----------------------------------------------------------------------
---  APB UART  -------------------------------------------------------
----------------------------------------------------------------------
  ua1 : IF CFG_UART1_ENABLE /= 0 GENERATE
    uart1 : apbuart                     -- UART 1
      GENERIC MAP (pindex   => 1, paddr => 1, pirq => 2, console => dbguart,
                   fifosize => CFG_UART1_FIFO)
      PORT MAP (rstn, clkm, apbi, apbo(1), apbuarti, apbuarto);
    apbuarti.rxd    <= LCD_TXD;
    apbuarti.extclk <= '0';
    LCD_RXD           <= apbuarto.txd;
    apbuarti.ctsn   <= '0';
  END GENERATE;
  noua0 : IF CFG_UART1_ENABLE = 0 GENERATE apbo(1) <= apb_none; END GENERATE;


-----------------------------------------------------------------------
---  SpaceWire Light --------------------------------------------------
-----------------------------------------------------------------------

   spw0: spwamba
      generic map (
         tech        => memtech,
         hindex      => 2,
         pindex      => 10,
         paddr       => 10,
         pirq        => 10,
         sysfreq     => 50.0e6,
         txclkfreq   => 10.0e6,
         rximpl      => impl_generic,
         rxchunk     => 1,
         tximpl      => impl_generic,
         timecodegen => true,
         rxfifosize  => 11,
         txfifosize  => 11,
         desctablesize => 10,
         maxburst    => 3 )
      port map (
         clk     => clkm,
         rxclk   => clkm,
         txclk   => clkm,
         rstn    => rstn,
         apbi    => apbi,
         apbo    => apbo(10),
         ahbi    => ahbmi,
         ahbo    => ahbmo(2),
         tick_in => spw_tick_in,
         tick_out => spw_tick_out,
         spw_di  => spw_di,
         spw_si  => spw_si,
         spw_do  => spw_do,
         spw_so  => spw_so );

   spw_tick_in <= gpto.tick(2) when CFG_GPT_ENABLE /= 0 else '0';

   spw_rxd_pad: inpad_ds
      generic map (padtech, lvds, x33v)
      port map (spw_rxdp, spw_rxdn, spw_di);
   spw_rxs_pad: inpad_ds
      generic map (padtech, lvds, x33v)
      port map (spw_rxsp, spw_rxsn, spw_si);
   -- spw_txd_pad: outpad_ds
   --    generic map (padtech, lvds, x33v)
   --    port map (spw_txdp, spw_txdn, spw_do, '0');
   -- spw_txs_pad: outpad_ds
   --    generic map (padtech, lvds, x33v)
   --    port map (spw_txsp, spw_txsn, spw_so, '0');


spw_txdp_pad : outpad generic map (tech => padtech)
	   port map (spw_txdp, spw_do);
spw_txdn_pad : outpad generic map (tech => padtech)
	   port map (spw_txdn, not spw_do);

spw_txsp_pad : outpad generic map (tech => padtech)
	   port map (spw_txsp, spw_so);
spw_txsn_pad : outpad generic map (tech => padtech)
	   port map (spw_txsn, not spw_so);



 apb_counter: entity work.APB_counter
  generic map(
    pindex   => 4,
    paddr    => 4
    )
  port map(
    rstn   => rstn,
    clk    => clkm,
    apbi   => apbi,
    apbo   => apbo(4),

    GPS_PPS     => GPS_PPS_in,
    SPW_Tickout => spw_tick_out,
    gene_in     => lesia_gen
    );

end rtl;

