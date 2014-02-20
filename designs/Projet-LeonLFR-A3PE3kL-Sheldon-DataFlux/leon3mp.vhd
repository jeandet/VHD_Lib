-----------------------------------------------------------------------------
--  LEON3 Demonstration design
--  Copyright (C) 2004 Jiri Gaisler, Gaisler Research
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
library techmap;
use techmap.gencomp.all;
library gaisler;
use gaisler.memctrl.all;
use gaisler.leon3.all;
use gaisler.uart.all;
use gaisler.misc.all;
library esa;
use esa.memoryctrl.all;
use work.config.all;
library lpp;
use lpp.lpp_amba.all;
use lpp.lpp_memory.all;
use lpp.lpp_uart.all;
use lpp.lpp_matrix.all;
use lpp.lpp_delay.all;
use lpp.lpp_fft.all;
use lpp.fft_components.all;
use lpp.lpp_ad_conv.all;
use lpp.iir_filter.all;
use lpp.general_purpose.all;
use lpp.Filtercfg.all;
use lpp.lpp_cna.all;
use lpp.lpp_demux.all;
use lpp.lpp_Header.all;
use lpp.lpp_dma_pkg.all;
use lpp.lpp_top_lfr_pkg.all;

entity leon3mp is
  generic (
    fabtech   : integer := CFG_FABTECH;
    memtech   : integer := CFG_MEMTECH;
    padtech   : integer := CFG_PADTECH;
    clktech   : integer := CFG_CLKTECH;
    disas     : integer := CFG_DISAS;	-- Enable disassembly to console
    dbguart   : integer := CFG_DUART;	-- Print UART on console
    pclow     : integer := CFG_PCLOW
  );
  port (
    clk50MHz    : in  std_ulogic;
    reset	    : in  std_ulogic;
    ramclk 	    : out std_logic;    

    ahbrxd  : in  std_ulogic;  			-- DSU rx data  
    ahbtxd  : out std_ulogic; 			-- DSU tx data
    dsubre  : in std_ulogic;
    dsuact  : out std_ulogic;
    urxd1  : in  std_ulogic;  			-- UART1 rx data
    utxd1  : out std_ulogic; 			-- UART1 tx data
    errorn	: out std_ulogic;     

    address : out std_logic_vector(18 downto 0);
    data	: inout std_logic_vector(31 downto 0);
    gpio    : inout std_logic_vector(6 downto 0); 	-- I/O port    

    nBWa        : out std_logic;
    nBWb        : out std_logic;
    nBWc        : out std_logic;
    nBWd        : out std_logic;
    nBWE        : out std_logic;
    nADSC       : out std_logic;
    nADSP       : out std_logic;
    nADV        : out std_logic;
    nGW         : out std_logic;
    nCE1        : out std_logic;
    CE2         : out std_logic;
    nCE3        : out std_logic;
    nOE         : out std_logic;		
    MODE        : out std_logic;        
    SSRAM_CLK   : out std_logic;
    ZZ          : out std_logic;
---------------------------------------------------------------------
---  AJOUT TEST ------------------------In/Out-----------------------
---------------------------------------------------------------------
-- ACQ
    CNV_CH1     : OUT STD_LOGIC;
    SCK_CH1     : OUT STD_LOGIC;
    SDO_CH1     : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
    Bias_Fails  : out std_logic;
-- DAC
    DAC_EN      : out std_logic;
    DAC_SYNC    : out std_logic;
    DAC_SCLK    : out std_logic;
    DAC_DATA    : out std_logic;
-- UART 
    UART_RXD    : in std_logic;
    UART_TXD    : out std_logic;
-- DEBUG
    SPW1_EN     : out std_logic;
    SPW2_EN     : out std_logic;
    testspw1S   : out std_logic;
    testspw1D   : out std_logic;
    testled0    : out std_logic;
    testled1    : out std_logic;
---------------------------------------------------------------------    
    led     : out std_logic_vector(1 downto 0)
	);
end;

architecture Behavioral of leon3mp is

constant maxahbmsp : integer := CFG_NCPU+CFG_AHB_UART+
	CFG_GRETH+CFG_AHB_JTAG;
constant maxahbm : integer := maxahbmsp;

--Clk & Rst géné
signal vcc      : std_logic_vector(4 downto 0);
signal gnd      : std_logic_vector(4 downto 0);
signal resetnl  : std_ulogic;
signal clk2x    : std_ulogic;
signal lclk     : std_ulogic;
signal lclk2x   : std_ulogic;
signal clkm     : std_ulogic;
signal rstn     : std_ulogic;
signal rstraw   : std_ulogic;
signal pciclk   : std_ulogic;
signal sdclkl   : std_ulogic;
signal cgi      : clkgen_in_type;
signal cgo      : clkgen_out_type;
--- AHB / APB
signal apbi     : apb_slv_in_type;
signal apbo     : apb_slv_out_vector := (others => apb_none);
signal ahbsi    : ahb_slv_in_type;
signal ahbso    : ahb_slv_out_vector := (others => ahbs_none);
signal ahbmi    : ahb_mst_in_type;
signal ahbmo    : ahb_mst_out_vector := (others => ahbm_none);
--UART
signal ahbuarti : uart_in_type;
signal ahbuarto : uart_out_type;
signal apbuarti : uart_in_type;
signal apbuarto : uart_out_type;
--MEM CTRLR
signal memi     : memory_in_type;
signal memo     : memory_out_type;
signal wpo      : wprot_out_type;
signal sdo      : sdram_out_type;
--IRQ
signal irqi     : irq_in_vector(0 to CFG_NCPU-1);
signal irqo     : irq_out_vector(0 to CFG_NCPU-1);
--Timer
signal gpti     : gptimer_in_type;
signal gpto     : gptimer_out_type;
--GPIO
signal gpioi    : gpio_in_type;
signal gpioo    : gpio_out_type;
--DSU
signal dbgi     : l3_debug_in_vector(0 to CFG_NCPU-1);
signal dbgo     : l3_debug_out_vector(0 to CFG_NCPU-1);
signal dsui     : dsu_in_type;
signal dsuo     : dsu_out_type; 

---------------------------------------------------------------------
---  AJOUT TEST ------------------------Signaux----------------------
---------------------------------------------------------------------

-- ACQ
signal ACQ_WenF0   : STD_LOGIC_VECTOR(4 DOWNTO 0);
signal ACQ_DataF0  : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
signal ACQ_WenF1   : STD_LOGIC_VECTOR(4 DOWNTO 0);
signal ACQ_DataF1  : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
signal ACQ_WenF3   : STD_LOGIC_VECTOR(4 DOWNTO 0);
signal ACQ_DataF3  : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);

signal FifoF0_Empty     : std_logic_vector(4 downto 0);
signal FifoF0_Data      : std_logic_vector(79 downto 0);
signal FifoF1_Empty     : std_logic_vector(4 downto 0);
signal FifoF1_Data      : std_logic_vector(79 downto 0);
signal FifoF3_Empty     : std_logic_vector(4 downto 0);
signal FifoF3_Data      : std_logic_vector(79 downto 0);

-- MATRICE SPECTRALE
signal SM_FlagError : std_logic;
signal SM_Wen       : std_logic;
signal SM_Read      : std_logic_vector(4 downto 0);
signal SM_Write     : std_logic_vector(1 downto 0);
signal SM_ReUse     : std_logic_vector(4 downto 0);
signal SM_Param     : std_logic_vector(3 downto 0);
signal SM_Data      : std_logic_vector(63 downto 0);

signal FifoINT_Full     : std_logic_vector(4 downto 0);
signal FifoINT_Data     : std_logic_vector(79 downto 0);

-- FFT
signal DMUX_Read     : std_logic_vector(14 downto 0);
signal DMUX_Empty    : std_logic_vector(4 downto 0);
signal DMUX_Data     : std_logic_vector(79 downto 0);
signal DMUX_WorkFreq : std_logic_vector(1 downto 0);

signal FFT_Load        : std_logic;
signal FFT_Read        : std_logic_vector(4 downto 0);
signal FFT_Write       : std_logic_vector(4 downto 0);
signal FFT_ReUse       : std_logic_vector(4 downto 0);
signal FFT_Data        : std_logic_vector(79 downto 0);

signal FifoOUT_Full     : std_logic_vector(1 downto 0);
signal FifoOUT_Empty    : std_logic_vector(1 downto 0);
signal FifoOUT_Data     : std_logic_vector(63 downto 0);

--DMA
signal DMA_Read : std_logic;
signal DMA_ack  : std_logic;

-- Header
signal Head_Read    : std_logic_vector(1 downto 0);
signal Head_Data    : std_logic_vector(31 downto 0);
signal Head_Empty   : std_logic;
signal Head_Header  : std_logic_vector(31 DOWNTO 0);
signal Head_Valid   : std_logic;
signal Head_Val     : std_logic;

--DAC CAL
signal FIFOcal_Data : std_logic_vector(15 downto 0);
signal DAC_Readn    : std_logic;
signal DAC_ReadnV   : std_logic_vector(0 downto 0);
signal clkvar       : std_logic;

--TEST DEMI-FIFO
signal Bwr        : std_logic_vector(0 downto 0);
signal Bre        : std_logic_vector(0 downto 0);
signal DataTMP    : std_logic_vector(15 downto 0);
signal FullUp     : std_logic_vector(0 downto 0);
signal EmptyUp    : std_logic_vector(0 downto 0);
signal FullDown   : std_logic_vector(0 downto 0);
signal EmptyDown  : std_logic_vector(0 downto 0);
---------------------------------------------------------------------

constant IOAEN  : integer := CFG_CAN;
constant boardfreq : integer := 50000;

begin

---------------------------------------------------------------------
---  AJOUT TEST -------------------------------------IPs-------------
---------------------------------------------------------------------

-- apbo not free : 0 1 2 3 _ 7 _ 11
-- 4 - UART
-- 5 - FIFO CAL
-- 6 - DAC CAL
-- 8 - DMA

SPW1_EN     <= '1';
SPW2_EN     <= '0'; -- not SPW1_EN
testspw1S   <= clkvar;
testspw1D   <= DAC_SCLK;
testled0    <= DAC_DATA;
testled1    <= DAC_SYNC;

--- ACQ -------------------------------------------------------------

    ACQ0 : lpp_top_acq
        port map('1',CNV_CH1,SCK_CH1,SDO_CH1,clk50MHz,rstn,clkm,rstn,ACQ_WenF0,ACQ_DataF0,ACQ_WenF1,ACQ_DataF1,open,open,ACQ_WenF3,ACQ_DataF3);

Bias_Fails <= '0';

    Memf0 : lppFIFOxN
        generic map(Data_sz => 16, Addr_sz => 9, FifoCnt => 5, Enable_ReUse => '0')
        port map(rstn,clkm,clkm,(others => '0'),ACQ_WenF0,DMUX_Read(4 downto 0),ACQ_DataF0,FifoF0_Data,open,FifoF0_Empty);
    
    Memf1 : lppFIFOxN
        generic map(Data_sz => 16, Addr_sz => 8, FifoCnt => 5, Enable_ReUse => '0')
        port map(rstn,clkm,clkm,(others => '0'),ACQ_WenF1,DMUX_Read(9 downto 5),ACQ_DataF1,FifoF1_Data,open,FifoF1_Empty);
    
    Memf3 : lppFIFOxN
        generic map(Data_sz => 16, Addr_sz => 8, FifoCnt => 5, Enable_ReUse => '0')
        port map(rstn,clkm,clkm,(others => '0'),ACQ_WenF3,DMUX_Read(14 downto 10),ACQ_DataF3,FifoF3_Data,open,FifoF3_Empty);

--- FFT ------------------------------------------------------------------

    DMUX0 : DEMUX
        generic map(Data_sz => 16)
        port map(clkm,rstn,FFT_Read,FFT_Load,FifoF0_Empty,FifoF1_Empty,FifoF3_Empty,FifoF0_Data,FifoF1_Data,FifoF3_Data,DMUX_WorkFreq,DMUX_Read,DMUX_Empty,DMUX_Data);

    FFT0 : FFT
        generic map(Data_sz => 16,NbData => 256)
        port map(clkm,rstn,DMUX_Empty,DMUX_Data,FifoINT_Full,FFT_Load,FFT_Read,FFT_Write,FFT_ReUse,FFT_Data);

    MemInt : lppFIFOxN
        generic map(Data_sz => 16, Addr_sz => 8, FifoCnt => 5, Enable_ReUse => '1')
        port map(rstn,clkm,clkm,SM_ReUse,FFT_Write,SM_Read,FFT_Data,FifoINT_Data,FifoINT_Full,open);

----- MATRICE SPECTRALE ---------------------5 FIFO Input---------------

    SM0 : MatriceSpectrale
        generic map(Input_SZ => 16,Result_SZ => 32)
        port map(clkm,rstn,FifoINT_Full,FFT_ReUse,Head_Valid,FifoINT_Data,DMA_ack,SM_Wen,SM_FlagError,SM_Param,SM_Write,SM_Read,SM_ReUse,SM_Data);

    MemOut : APB_FIFO
        generic map (pindex => 8, paddr => 8, FifoCnt => 2, Data_sz => 32, Addr_sz => 8, Enable_ReUse => '0', R => 1, W => 0)
        port map (clkm,rstn,clkm,clkm,(others => '0'),(others => '1'),SM_Write,open,FifoOUT_Full,open,SM_Data,open,open,apbi,apbo(8));

DMA_ack <= '1';
Head_Valid <= '1';


--    MemOut : lppFIFOxN
--        generic map(Data_sz => 32, Addr_sz => 8, FifoCnt => 2, Enable_ReUse => '0')
--        port map(rstn,clkm,clkm,(others => '0'),SM_Write,Head_Read,SM_Data,FifoOUT_Data,FifoOUT_Full,FifoOUT_Empty);
--
------- DMA -------------------------------------------------------------
--
--    DMA0 : lpp_dma
--        generic map(hindex => 2,pindex => 8, paddr => 8,pirq => 14, pmask =>16#fff#,tech => CFG_FABTECH)
--        port map(clkm,rstn,apbi,apbo(8),ahbmi,ahbmo(2),Head_Data,Head_Empty,DMA_Read,Head_Header,Head_Val,DMA_ack);
--
------- Header ----------------------------------------------------------
--
--    Head0 : HeaderBuilder
--        generic map(Data_sz => 32)
--        port map(clkm,rstn,SM_Param,DMUX_WorkFreq,SM_Wen,Head_Valid,FifoOUT_Data,FifoOUT_Empty,Head_Read,Head_Data,Head_Empty,DMA_Read,Head_Header,Head_Val,DMA_ack);
--
--- DAC CAL -------------------------------------------------------------

    MemCal : APB_FIFO
        generic map (pindex => 5, paddr => 5, FifoCnt => 1, Data_sz => 16, Addr_sz => 8, Enable_ReUse => '1', R => 0, W => 1)
        port map (clkm,rstn,clkm,clkm,(others => '0'),DAC_ReadnV,(others => '1'),open,open,FIFOcal_Data,(others => '0'),open,open,apbi,apbo(5));

DAC_ReadnV(0) <= DAC_Readn;

    CAL0 : APB_DAC
        generic map (pindex => 6, paddr => 6, Nmax => 7)
        port map(clkm,rstn,apbi,apbo(6),FIFOcal_Data,DAC_EN,DAC_Readn,DAC_SYNC,DAC_SCLK,clkvar,DAC_DATA);

--- UART -------------------------------------------------------------

    COM0 : APB_UART
        generic map (pindex => 4, paddr => 4)
        port map (clkm,rstn,apbi,apbo(4),UART_TXD,UART_RXD);

--- FIFO -------------------------------------------------------------

--    Memtest : APB_FIFO
--        generic map (pindex => 6, paddr => 6, FifoCnt => 5, Data_sz => 16, Addr_sz => 8, Enable_ReUse => '1', R => 1, W => 1)
--        port map (clkm,rstn,clkm,clkm,(others => '0'),(others => '1'),(others => '1'),open,open,open,(others => '0'),open,open,apbi,apbo(6));

--***************************************TEST DEMI-FIFO********************************************************************************
--    MemIn : APB_FIFO
--        generic map (pindex => 6, paddr => 6, FifoCnt => 1, Data_sz => 16, Addr_sz => 8, Enable_ReUse => '1', R => 0, W => 1)
--        port map (clkm,rstn,clkm,clkm,(others => '0'),Bre,(others => '1'),EmptyUp,FullUp,DataTMP,(others => '0'),open,open,apbi,apbo(6));
--   
--    Pont : Bridge
--        port map(clkm,rstn,EmptyUp(0),FullDown(0),Bwr(0),Bre(0));
--
--    MemOut : APB_FIFO
--        generic map (pindex => 9, paddr => 9, FifoCnt => 1, Data_sz => 16, Addr_sz => 8, Enable_ReUse => '0', R => 1, W => 0)
--        port map (clkm,rstn,clkm,clkm,(others => '0'),(others => '1'),Bwr,EmptyDown,FullDown,open,DataTMP,open,open,apbi,apbo(9));
--*************************************************************************************************************************************

----------------------------------------------------------------------
---  Reset and Clock generation  -------------------------------------
----------------------------------------------------------------------
  
  vcc <= (others => '1'); gnd <= (others => '0');
  cgi.pllctrl <= "00"; cgi.pllrst <= rstraw;
	
  rst0 : rstgen port map (reset, clkm, cgo.clklock, rstn, rstraw);

  
  clk_pad : clkpad generic map (tech => padtech) port map (clk50MHz, lclk2x); 

  clkgen0 : clkgen  		-- clock generator
    generic map (clktech, CFG_CLKMUL, CFG_CLKDIV, CFG_MCTRL_SDEN, 
	CFG_CLK_NOFB, 0, 0, 0, boardfreq, 0, 0, CFG_OCLKDIV)
    port map (lclk, lclk, clkm, open, clk2x, sdclkl, pciclk, cgi, cgo);
    
    ramclk  <=  clkm;
process(lclk2x)
begin
    if lclk2x'event and lclk2x = '1' then
        lclk <= not lclk;
    end if;
end process;

----------------------------------------------------------------------
---  LEON3 processor / DSU / IRQ  ------------------------------------
----------------------------------------------------------------------

  l3 : if CFG_LEON3 = 1 generate
    cpu : for i in 0 to CFG_NCPU-1 generate
      u0 : leon3s			-- LEON3 processor      
      generic map (i, fabtech, memtech, CFG_NWIN, CFG_DSU, CFG_FPU, CFG_V8, 
  	0, CFG_MAC, pclow, 0, CFG_NWP, CFG_ICEN, CFG_IREPL, CFG_ISETS, CFG_ILINE, 
  	CFG_ISETSZ, CFG_ILOCK, CFG_DCEN, CFG_DREPL, CFG_DSETS, CFG_DLINE, CFG_DSETSZ,
  	CFG_DLOCK, CFG_DSNOOP, CFG_ILRAMEN, CFG_ILRAMSZ, CFG_ILRAMADDR, CFG_DLRAMEN,
          CFG_DLRAMSZ, CFG_DLRAMADDR, CFG_MMUEN, CFG_ITLBNUM, CFG_DTLBNUM, CFG_TLB_TYPE, CFG_TLB_REP, 
          CFG_LDDEL, disas, CFG_ITBSZ, CFG_PWD, CFG_SVT, CFG_RSTADDR, CFG_NCPU-1)
      port map (clkm, rstn, ahbmi, ahbmo(i), ahbsi, ahbso, 
      		irqi(i), irqo(i), dbgi(i), dbgo(i));
    end generate;
    errorn_pad : outpad generic map (tech => padtech) port map (errorn, dbgo(0).error);
    
    dsugen : if CFG_DSU = 1 generate
      dsu0 : dsu3			-- LEON3 Debug Support Unit
      generic map (hindex => 2, haddr => 16#900#, hmask => 16#F00#, 
         ncpu => CFG_NCPU, tbits => 30, tech => memtech, irq => 0, kbytes => CFG_ATBSZ)
      port map (rstn, clkm, ahbmi, ahbsi, ahbso(2), dbgo, dbgi, dsui, dsuo);
--      dsuen_pad : inpad generic map (tech => padtech) port map (dsuen, dsui.enable); 
	dsui.enable <= '1';
      dsubre_pad : inpad generic map (tech => padtech) port map (dsubre, dsui.break); 
      dsuact_pad : outpad generic map (tech => padtech) port map (dsuact, dsuo.active);
    end generate;
  end generate;

  nodsu : if CFG_DSU = 0 generate
    ahbso(2) <= ahbs_none; dsuo.tstop <= '0'; dsuo.active <= '0';
  end generate;

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
---  Memory controllers  ---------------------------------------------
----------------------------------------------------------------------

    memctrlr : mctrl generic map (hindex => 0,pindex   => 0, paddr    => 0)
        port map (rstn, clkm, memi, memo, ahbsi, ahbso(0),apbi,apbo(0),wpo, sdo);

    memi.brdyn <= '1'; memi.bexcn <= '1';
    memi.writen <= '1'; memi.wrn <= "1111"; memi.bwidth <= "10";

    bdr : for i in 0 to 3 generate
      data_pad : iopadv generic map (tech => padtech, width => 8)
      port map (data(31-i*8 downto 24-i*8), memo.data(31-i*8 downto 24-i*8),
    memo.bdrive(i), memi.data(31-i*8 downto 24-i*8));
    end generate;


    addr_pad : outpadv generic map (width => 19, tech => padtech) 
    	port map (address, memo.address(20 downto 2));


    SSRAM_0:entity ssram_plugin
        generic map (tech => padtech)
        port map
        (lclk2x,memo,SSRAM_CLK,nBWa,nBWb,nBWc,nBWd,nBWE,nADSC,nADSP,nADV,nGW,nCE1,CE2,nCE3,nOE,MODE,ZZ);

----------------------------------------------------------------------
---  AHB CONTROLLER  -------------------------------------------------
----------------------------------------------------------------------

  ahb0 : ahbctrl 		-- AHB arbiter/multiplexer
  generic map (defmast => CFG_DEFMST, split => CFG_SPLIT, 
	rrobin => CFG_RROBIN, ioaddr => CFG_AHBIO,
	ioen => IOAEN, nahbm => maxahbm, nahbs => 8)
  port map (rstn, clkm, ahbmi, ahbmo, ahbsi, ahbso);

----------------------------------------------------------------------
---  AHB UART  -------------------------------------------------------
----------------------------------------------------------------------

  dcomgen : if CFG_AHB_UART = 1 generate
    dcom0: ahbuart		-- Debug UART
    generic map (hindex => CFG_NCPU, pindex => 7, paddr => 7)
    port map (rstn, clkm, ahbuarti, ahbuarto, apbi, apbo(7), ahbmi, ahbmo(CFG_NCPU));
    dsurx_pad : inpad generic map (tech => padtech) port map (ahbrxd, ahbuarti.rxd); 
    dsutx_pad : outpad generic map (tech => padtech) port map (ahbtxd, ahbuarto.txd);
--    led(0) <= not ahbuarti.rxd; led(1) <= not ahbuarto.txd;
  end generate;
  nouah : if CFG_AHB_UART = 0 generate apbo(7) <= apb_none; end generate;

----------------------------------------------------------------------
---  APB Bridge  -----------------------------------------------------
----------------------------------------------------------------------

  apb0 : apbctrl				-- AHB/APB bridge
  generic map (hindex => 1, haddr => CFG_APBADDR)
  port map (rstn, clkm, ahbsi, ahbso(1), apbi, apbo );

----------------------------------------------------------------------
---  GPT Timer  ------------------------------------------------------
----------------------------------------------------------------------

  gpt : if CFG_GPT_ENABLE /= 0 generate
    timer0 : gptimer 			-- timer unit
    generic map (pindex => 3, paddr => 3, pirq => CFG_GPT_IRQ,
	sepirq => CFG_GPT_SEPIRQ, sbits => CFG_GPT_SW, ntimers => CFG_GPT_NTIM, 
	nbits => CFG_GPT_TW)
    port map (rstn, clkm, apbi, apbo(3), gpti, gpto);
    gpti.dhalt <= dsuo.tstop; gpti.extclk <= '0';
--    led(4) <= gpto.wdog;
  end generate;
  notim : if CFG_GPT_ENABLE = 0 generate apbo(3) <= apb_none; end generate;


----------------------------------------------------------------------
---  APB UART  -------------------------------------------------------
----------------------------------------------------------------------

  ua1 : if CFG_UART1_ENABLE /= 0 generate
    uart1 : apbuart			-- UART 1
    generic map (pindex => 1, paddr => 1,  pirq => 2, console => dbguart,
	fifosize => CFG_UART1_FIFO)
    port map (rstn, clkm, apbi, apbo(1), ahbuarti, apbuarto);
    apbuarti.rxd <= urxd1; apbuarti.extclk <= '0'; utxd1 <= apbuarto.txd;
    apbuarti.ctsn <= '0'; --rtsn1 <= apbuarto.rtsn;
--   led(0) <= not apbuarti.rxd; led(1) <= not apbuarto.txd;
  end generate;
  noua0 : if CFG_UART1_ENABLE = 0 generate apbo(1) <= apb_none; end generate;

----------------------------------------------------------------------
---  GPIO  -----------------------------------------------------------
----------------------------------------------------------------------
led(0) <= gpio(0); led(1) <= gpio(1);

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