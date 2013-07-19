-----------------------------------------------------------------------------
--  LEON3 Demonstration design
--  Copyright (C) 2004 Jiri Gaisler, Gaisler Research
------------------------------------------------------------------------------
--  This file is a part of the GRLIB VHDL IP LIBRARY
--  Copyright (C) 2010, Aeroflex Gaisler AB - all rights reserved.
--
-- ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN 
-- ACCORDANCE WITH THE GAISLER LICENSE AGREEMENT AND MUST BE APPROVED 
-- IN ADVANCE IN WRITING. 
------------------------------------------------------------------------------


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
LIBRARY grlib;
USE grlib.amba.ALL;
USE grlib.stdlib.ALL;
USE GRLIB.DMA2AHB_Package.ALL;
LIBRARY techmap;
USE techmap.gencomp.ALL;
LIBRARY gaisler;
USE gaisler.memctrl.ALL;
USE gaisler.leon3.ALL;
USE gaisler.uart.ALL;
USE gaisler.misc.ALL;
--USE gaisler.pci.ALL;
USE gaisler.net.ALL;
USE gaisler.jtag.ALL;
USE gaisler.spacewire.ALL;
LIBRARY esa;
USE esa.memoryctrl.ALL;
--USE esa.pcicomp.ALL;
USE work.config.ALL;
LIBRARY lpp;
USE lpp.lpp_bootloader_pkg.ALL;
use lpp.lpp_lfr_time_management.all;        -- PLE
USE lpp.lpp_dma_pkg.ALL;
USE lpp.lpp_memory.ALL;
USE lpp.lpp_top_lfr_pkg.ALL;

ENTITY leon3mp IS
  GENERIC (
    fabtech : INTEGER := CFG_FABTECH;
    memtech : INTEGER := CFG_MEMTECH;
    padtech : INTEGER := CFG_PADTECH;
    clktech : INTEGER := CFG_CLKTECH;
    ncpu    : INTEGER := CFG_NCPU;
    disas   : INTEGER := CFG_DISAS;     -- Enable disassembly to console
    dbguart : INTEGER := CFG_DUART;     -- Print UART on console
    pclow   : INTEGER := CFG_PCLOW
    );
  PORT (
    resetn  : IN    STD_ULOGIC;
    clk     : IN    STD_ULOGIC;
    pllref  : IN    STD_ULOGIC;
    errorn  : OUT   STD_ULOGIC;
    address : OUT   STD_LOGIC_VECTOR(27 DOWNTO 0);
    data    : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);

    dsutx  : OUT   STD_ULOGIC;          -- DSU tx data
    dsurx  : IN    STD_ULOGIC;          -- DSU rx data
    dsuen  : IN    STD_ULOGIC;
    dsubre : IN    STD_ULOGIC;
    dsuact : OUT   STD_ULOGIC;
    txd1   : OUT   STD_ULOGIC;          -- UART1 tx data
    rxd1   : IN    STD_ULOGIC;          -- UART1 rx data
    txd2   : OUT   STD_ULOGIC;          -- UART2 tx data
    rxd2   : IN    STD_ULOGIC;          -- UART2 rx data
    ramsn  : OUT   STD_LOGIC_VECTOR (4 DOWNTO 0);
    ramoen : OUT   STD_LOGIC_VECTOR (4 DOWNTO 0);
    rwen   : OUT   STD_LOGIC_VECTOR (3 DOWNTO 0);
    oen    : OUT   STD_ULOGIC;
    writen : OUT   STD_ULOGIC;
    read   : OUT   STD_ULOGIC;
    iosn   : OUT   STD_ULOGIC;
    romsn  : OUT   STD_LOGIC_VECTOR (1 DOWNTO 0);
    gpio   : INOUT STD_LOGIC_VECTOR(CFG_GRGPIO_WIDTH-1 DOWNTO 0);  -- I/O port

    emddis  : OUT STD_LOGIC;
    epwrdwn : OUT STD_ULOGIC;
    ereset  : OUT STD_ULOGIC;
    esleep  : OUT STD_ULOGIC;
    epause  : OUT STD_ULOGIC;

    pci_rst     : INOUT STD_LOGIC;      -- PCI bus
    pci_clk     : IN    STD_ULOGIC;
    pci_gnt     : IN    STD_ULOGIC;
    pci_idsel   : IN    STD_ULOGIC;
    pci_lock    : INOUT STD_ULOGIC;
    pci_ad      : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    pci_cbe     : INOUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    pci_frame   : INOUT STD_ULOGIC;
    pci_irdy    : INOUT STD_ULOGIC;
    pci_trdy    : INOUT STD_ULOGIC;
    pci_devsel  : INOUT STD_ULOGIC;
    pci_stop    : INOUT STD_ULOGIC;
    pci_perr    : INOUT STD_ULOGIC;
    pci_par     : INOUT STD_ULOGIC;
    pci_req     : INOUT STD_ULOGIC;
    pci_serr    : INOUT STD_ULOGIC;
    pci_host    : IN    STD_ULOGIC;
    pci_66      : IN    STD_ULOGIC;
    pci_arb_req : IN    STD_LOGIC_VECTOR(0 TO 3);
    pci_arb_gnt : OUT   STD_LOGIC_VECTOR(0 TO 3);

    spw_clk  : IN  STD_ULOGIC;
    spw_rxd  : IN  STD_LOGIC_VECTOR(0 TO 2);
    spw_rxdn : IN  STD_LOGIC_VECTOR(0 TO 2);
    spw_rxs  : IN  STD_LOGIC_VECTOR(0 TO 2);
    spw_rxsn : IN  STD_LOGIC_VECTOR(0 TO 2);
    spw_txd  : OUT STD_LOGIC_VECTOR(0 TO 2);
    spw_txdn : OUT STD_LOGIC_VECTOR(0 TO 2);
    spw_txs  : OUT STD_LOGIC_VECTOR(0 TO 2);
    spw_txsn : OUT STD_LOGIC_VECTOR(0 TO 2);

    ramclk : OUT STD_LOGIC;

    nBWa      : OUT STD_LOGIC;
    nBWb      : OUT STD_LOGIC;
    nBWc      : OUT STD_LOGIC;
    nBWd      : OUT STD_LOGIC;
    nBWE      : OUT STD_LOGIC;
    nADSC     : OUT STD_LOGIC;
    nADSP     : OUT STD_LOGIC;
    nADV      : OUT STD_LOGIC;
    nGW       : OUT STD_LOGIC;
    nCE1      : OUT STD_LOGIC;
    CE2       : OUT STD_LOGIC;
    nCE3      : OUT STD_LOGIC;
    nOE       : OUT STD_LOGIC;
    MODE      : OUT STD_LOGIC;
    SSRAM_CLK : OUT STD_LOGIC;
    ZZ        : OUT STD_LOGIC;

    tck, tms, tdi : IN  STD_ULOGIC;
    tdo           : OUT STD_ULOGIC;
    
    -- waveform picker------
    clk49_152MHz        : in  std_ulogic;
    sdo_adc		: in std_logic_vector(7 downto 0);
    cnv_ch1		: out std_logic;
    sck_ch1		: out std_logic;
    Bias_Fails	        : out std_logic
    

    );
END;

ARCHITECTURE rtl OF leon3mp IS

  CONSTANT blength : INTEGER := 12;

  CONSTANT maxahbmsp : INTEGER := NCPU+CFG_AHB_UART+
                                  CFG_GRETH+CFG_AHB_JTAG+log2x(CFG_PCI);
  CONSTANT maxahbm : INTEGER := (CFG_SPW_NUM*CFG_SPW_EN) + maxahbmsp + 2;  -- +LPP_DMA



  SIGNAL vcc, gnd   : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL memi       : memory_in_type;
  SIGNAL memo       : memory_out_type;
  SIGNAL wpo        : wprot_out_type;
  SIGNAL sdi        : sdctrl_in_type;
  SIGNAL sdo        : sdram_out_type;
  SIGNAL sdo2, sdo3 : sdctrl_out_type;

  SIGNAL apbi  : apb_slv_in_type;
  SIGNAL apbo  : apb_slv_out_vector := (OTHERS => apb_none);
  SIGNAL ahbsi : ahb_slv_in_type;
  SIGNAL ahbso : ahb_slv_out_vector := (OTHERS => ahbs_none);
  SIGNAL ahbmi : ahb_mst_in_type;
  SIGNAL ahbmo : ahb_mst_out_vector := (OTHERS => ahbm_none);

  SIGNAL clkm, rstn, rstraw, pciclk, sdclkl, spw_lclk : STD_ULOGIC;
  SIGNAL cgi                                          : clkgen_in_type;
  SIGNAL cgo                                          : clkgen_out_type;
  SIGNAL u1i, u2i, dui                                : uart_in_type;
  SIGNAL u1o, u2o, duo                                : uart_out_type;

  SIGNAL irqi : irq_in_vector(0 TO NCPU-1);
  SIGNAL irqo : irq_out_vector(0 TO NCPU-1);

  SIGNAL dbgi : l3_debug_in_vector(0 TO NCPU-1);
  SIGNAL dbgo : l3_debug_out_vector(0 TO NCPU-1);

  SIGNAL dsui : dsu_in_type;
  SIGNAL dsuo : dsu_out_type;

 -- SIGNAL pcii : pci_in_type;
--  SIGNAL pcio : pci_out_type;

  SIGNAL ethi, ethi1, ethi2 : eth_in_type;
  SIGNAL etho, etho1, etho2 : eth_out_type;

  SIGNAL gpti : gptimer_in_type;

  SIGNAL gpioi : gpio_in_type;
  SIGNAL gpioo : gpio_out_type;


  SIGNAL lclk, pci_lclk               : STD_ULOGIC := '0';
  SIGNAL pci_arb_req_n, pci_arb_gnt_n : STD_LOGIC_VECTOR(0 TO 3);

  SIGNAL spwi       : grspw_in_type_vector(0 TO 2);
  SIGNAL spwo       : grspw_out_type_vector(0 TO 2);
  SIGNAL spw_rx_clk : STD_ULOGIC;

  ATTRIBUTE sync_set_reset         : STRING;
  ATTRIBUTE sync_set_reset OF rstn : SIGNAL IS "true";

  CONSTANT BOARD_FREQ : INTEGER := 40000;  -- Board frequency in KHz
  CONSTANT CPU_FREQ   : INTEGER := BOARD_FREQ * CFG_CLKMUL / CFG_CLKDIV;
  CONSTANT IOAEN      : INTEGER := CFG_SDCTRL;
  CONSTANT CFG_SDEN   : INTEGER := CFG_SDCTRL + CFG_MCTRL_SDEN;

  CONSTANT sysfreq : INTEGER := (CFG_CLKMUL/CFG_CLKDIV)*40000;

  -----------------------------------------------------------------------------

  SIGNAL fifo_data  : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL fifo_empty : STD_LOGIC;
  SIGNAL fifo_ren   : STD_LOGIC;
  SIGNAL dma_data   : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL dma_empty  : STD_LOGIC;
  SIGNAL dma_ren    : STD_LOGIC;
  SIGNAL header     : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL header_val : STD_LOGIC;
  SIGNAL header_ack : STD_LOGIC;

  SIGNAL lclk2x : STD_ULOGIC;
  SIGNAL clk2x  : STD_ULOGIC;

  CONSTANT boardfreq : INTEGER := 50000;
  
	signal coarse_time	: std_logic_vector(31 downto 0);
	signal fine_time	: std_logic_vector(31 downto 0);
  
BEGIN

----------------------------------------------------------------------
---  Reset and Clock generation  -------------------------------------
----------------------------------------------------------------------
  
  vcc         <= (OTHERS => '1');
  gnd         <= (OTHERS => '0');
  cgi.pllctrl <= "00";
  cgi.pllrst  <= rstraw;

  pllref_pad : clkpad GENERIC MAP (tech => padtech) PORT MAP (pllref, cgi.pllref);

  clk_pad : clkpad GENERIC MAP (tech => padtech) PORT MAP (clk, lclk2x);

  PROCESS(lclk2x)
  BEGIN
    IF lclk2x'EVENT AND lclk2x = '1' THEN
      lclk <= NOT lclk;
    END IF;
  END PROCESS;

  pci_clk_pad : clkpad GENERIC MAP (tech => padtech, level => pci33) PORT MAP (pci_clk, pci_lclk);

  clkgen0 : clkgen                      -- clock generator
    GENERIC MAP (clktech, CFG_CLKMUL, CFG_CLKDIV, CFG_MCTRL_SDEN, CFG_CLK_NOFB, 0, 0, 0, boardfreq, 0, 0, CFG_OCLKDIV)
    PORT MAP (lclk, lclk, clkm, OPEN, clk2x, sdclkl, pciclk, cgi, cgo);
  
  ramclk <= clkm;

  rst0 : rstgen                         -- reset generator
    PORT MAP (resetn, clkm, cgo.clklock, rstn, rstraw);

----------------------------------------------------------------------
---  AHB CONTROLLER --------------------------------------------------
----------------------------------------------------------------------

  ahb0 : ahbctrl                        -- AHB arbiter/multiplexer
    GENERIC MAP (defmast => CFG_DEFMST, split => CFG_SPLIT,
                 rrobin  => CFG_RROBIN, ioaddr => CFG_AHBIO,
                 ioen    => IOAEN, nahbm => maxahbm, nahbs => 8)
    PORT MAP (rstn, clkm, ahbmi, ahbmo, ahbsi, ahbso);

----------------------------------------------------------------------
---  LEON3 processor and DSU -----------------------------------------
----------------------------------------------------------------------

  l3 : IF CFG_LEON3 = 1 GENERATE
    cpu : FOR i IN 0 TO NCPU-1 GENERATE
      u0 : leon3s                       -- LEON3 processor      
        GENERIC MAP (i, fabtech, memtech, CFG_NWIN, CFG_DSU, CFG_FPU, CFG_V8,
                     0, CFG_MAC, pclow, 0, CFG_NWP, CFG_ICEN, CFG_IREPL, CFG_ISETS, CFG_ILINE,
                     CFG_ISETSZ, CFG_ILOCK, CFG_DCEN, CFG_DREPL, CFG_DSETS, CFG_DLINE, CFG_DSETSZ,
                     CFG_DLOCK, CFG_DSNOOP, CFG_ILRAMEN, CFG_ILRAMSZ, CFG_ILRAMADDR, CFG_DLRAMEN,
                     CFG_DLRAMSZ, CFG_DLRAMADDR, CFG_MMUEN, CFG_ITLBNUM, CFG_DTLBNUM, CFG_TLB_TYPE, CFG_TLB_REP,
                     CFG_LDDEL, disas, CFG_ITBSZ, CFG_PWD, CFG_SVT, CFG_RSTADDR, NCPU-1, CFG_DFIXED)
        PORT MAP (clkm, rstn, ahbmi, ahbmo(i), ahbsi, ahbso,
                  irqi(i), irqo(i), dbgi(i), dbgo(i));
    END GENERATE;
    errorn_pad : odpad GENERIC MAP (tech => padtech) PORT MAP (errorn, dbgo(0).error);


    dsugen : IF CFG_DSU = 1 GENERATE
      dsu0 : dsu3                       -- LEON3 Debug Support Unit
        GENERIC MAP (hindex => 2, haddr => 16#900#, hmask => 16#F00#,
                     ncpu   => NCPU, tbits => 30, tech => memtech, irq => 0, kbytes => CFG_ATBSZ)
        PORT MAP (rstn, clkm, ahbmi, ahbsi, ahbso(2), dbgo, dbgi, dsui, dsuo);
      dsuen_pad  : inpad GENERIC MAP (tech  => padtech) PORT MAP (dsuen, dsui.enable);
      dsubre_pad : inpad GENERIC MAP (tech  => padtech) PORT MAP (dsubre, dsui.break);
      dsuact_pad : outpad GENERIC MAP (tech => padtech) PORT MAP (dsuact, dsuo.active);
    END GENERATE;
  END GENERATE;

  nodsu : IF CFG_DSU = 0 GENERATE
    ahbso(2) <= ahbs_none; dsuo.tstop <= '0'; dsuo.active <= '0';
  END GENERATE;

  dcomgen : IF CFG_AHB_UART = 1 GENERATE
    dcom0 : ahbuart                     -- Debug UART
      GENERIC MAP (hindex => NCPU, pindex => 7, paddr => 7)
      PORT MAP (rstn, clkm, dui, duo, apbi, apbo(7), ahbmi, ahbmo(NCPU));
    dsurx_pad : inpad GENERIC MAP (tech  => padtech) PORT MAP (dsurx, dui.rxd);
    dsutx_pad : outpad GENERIC MAP (tech => padtech) PORT MAP (dsutx, duo.txd);
  END GENERATE;
  nouah : IF CFG_AHB_UART = 0 GENERATE apbo(7) <= apb_none; END GENERATE;

  ahbjtaggen0 : IF CFG_AHB_JTAG = 1 GENERATE
    ahbjtag0 : ahbjtag GENERIC MAP(tech => fabtech, hindex => NCPU+CFG_AHB_UART)
      PORT MAP(rstn, clkm, tck, tms, tdi, tdo, ahbmi, ahbmo(NCPU+CFG_AHB_UART),
               OPEN, OPEN, OPEN, OPEN, OPEN, OPEN, OPEN, gnd(0));
  END GENERATE;

----------------------------------------------------------------------
---  Memory controllers ----------------------------------------------
----------------------------------------------------------------------
-- LEON2 memory controller
  sr1 : mctrl
    GENERIC MAP (
      hindex    => 0,
      pindex    => 0,
      romaddr   => 16#000#,
      rommask   => 16#E00#,
      ioaddr    => 16#200#,
      iomask    => 16#E00#,
      ramaddr   => 16#400#,
      rammask   => 16#C00#,
      paddr     => 0,
      pmask     => 16#fff#,
      wprot     => 0,
      invclk    => 0,
      fast      => 0,
      romasel   => 28,
      sdrasel   => 29,
      srbanks   => 4,
      ram8      => 0,
      ram16     => 0,
      sden      => 0,
      sepbus    => 0,
      sdbits    => 32,
      sdlsb     => 2,                   -- set to 12 for the GE-HPE board
      oepol     => 0,
      syncrst   => 0,
      pageburst => 0,
      scantest  => 0,
      mobile    => 0
      )
    PORT MAP (
      rst   => rstn,
      clk   => clkm,
      memi  => memi,
      memo  => memo,
      ahbsi => ahbsi,
      ahbso => ahbso(0),
      apbi  => apbi,
      apbo  => apbo(0),
      wpo   => wpo,
      sdo   => sdo
      );


  memi.brdyn  <= '1'; memi.bexcn <= '1';
  memi.writen <= '1'; memi.wrn <= "1111"; memi.bwidth <= "10";

  mgpads : IF (CFG_SRCTRL = 1) OR (CFG_MCTRL_LEON2 = 1) GENERATE  -- prom/sram pads
    addr_pad : outpadv GENERIC MAP (width => 28, tech => padtech) PORT MAP (address, memo.address(27 DOWNTO 0));
    rams_pad : outpadv GENERIC MAP (width => 5, tech => padtech) PORT MAP (ramsn, memo.ramsn(4 DOWNTO 0));
    roms_pad : outpadv GENERIC MAP (width => 2, tech => padtech) PORT MAP (romsn, memo.romsn(1 DOWNTO 0));
    oen_pad  : outpad GENERIC MAP (tech   => padtech) PORT MAP (oen, memo.oen);
    rwen_pad : outpadv GENERIC MAP (width => 4, tech => padtech) PORT MAP (rwen, memo.wrn);
    roen_pad : outpadv GENERIC MAP (width => 5, tech => padtech) PORT MAP (ramoen, memo.ramoen(4 DOWNTO 0));
    wri_pad  : outpad GENERIC MAP (tech   => padtech) PORT MAP (writen, memo.writen);
    read_pad : outpad GENERIC MAP (tech   => padtech) PORT MAP (read, memo.read);
    iosn_pad : outpad GENERIC MAP (tech   => padtech) PORT MAP (iosn, memo.iosn);

    bdr : FOR i IN 0 TO 3 GENERATE
      data_pad : iopadv GENERIC MAP (tech => padtech, width => 8)
        PORT MAP (data(31-i*8 DOWNTO 24-i*8), memo.data(31-i*8 DOWNTO 24-i*8),
                  memo.bdrive(i), memi.data(31-i*8 DOWNTO 24-i*8));
    END GENERATE;

  END GENERATE;

  SSRAM_0 : ssram_plugin
    GENERIC MAP (tech => padtech)
    PORT MAP (lclk2x, memo, SSRAM_CLK,
              nBWa, nBWb, nBWc, nBWd, nBWE, nADSC, nADSP, nADV, nGW, nCE1, CE2, nCE3, nOE, MODE, ZZ);



----------------------------------------------------------------------
---  APB Bridge and various periherals -------------------------------
----------------------------------------------------------------------

  apb0 : apbctrl                        -- AHB/APB bridge
    GENERIC MAP (hindex => 1, haddr => CFG_APBADDR)
    PORT MAP (rstn, clkm, ahbsi, ahbso(1), apbi, apbo);

  ua1 : IF CFG_UART1_ENABLE /= 0 GENERATE
    uart1 : apbuart                     -- UART 1
      GENERIC MAP (pindex   => 1, paddr => 1, pirq => 2, console => dbguart,
                   fifosize => CFG_UART1_FIFO)
      PORT MAP (rstn, clkm, apbi, apbo(1), u1i, u1o);
    u1i.rxd <= rxd1; u1i.ctsn <= '0'; u1i.extclk <= '0'; txd1 <= u1o.txd;
  END GENERATE;
  noua0 : IF CFG_UART1_ENABLE = 0 GENERATE apbo(1) <= apb_none; END GENERATE;

  ua2 : IF CFG_UART2_ENABLE /= 0 GENERATE
    uart2 : apbuart                     -- UART 2
      GENERIC MAP (pindex => 9, paddr => 9, pirq => 3, fifosize => CFG_UART2_FIFO)
      PORT MAP (rstn, clkm, apbi, apbo(9), u2i, u2o);
    u2i.rxd <= rxd2; u2i.ctsn <= '0'; u2i.extclk <= '0'; txd2 <= u2o.txd;
  END GENERATE;
  noua1 : IF CFG_UART2_ENABLE = 0 GENERATE apbo(9) <= apb_none; END GENERATE;

  irqctrl : IF CFG_IRQ3_ENABLE /= 0 GENERATE
    irqctrl0 : irqmp                    -- interrupt controller
      GENERIC MAP (pindex => 2, paddr => 2, ncpu => NCPU)
      PORT MAP (rstn, clkm, apbi, apbo(2), irqo, irqi);
  END GENERATE;
  irq3 : IF CFG_IRQ3_ENABLE = 0 GENERATE
    x : FOR i IN 0 TO NCPU-1 GENERATE
      irqi(i).irl <= "0000";
    END GENERATE;
    apbo(2) <= apb_none;
  END GENERATE;

  gpt : IF CFG_GPT_ENABLE /= 0 GENERATE
    timer0 : gptimer                    -- timer unit
      GENERIC MAP (pindex => 3, paddr => 3, pirq => CFG_GPT_IRQ,
                   sepirq => CFG_GPT_SEPIRQ, sbits => CFG_GPT_SW, ntimers => CFG_GPT_NTIM,
                   nbits  => CFG_GPT_TW, wdog => CFG_GPT_WDOG)
      PORT MAP (rstn, clkm, apbi, apbo(3), gpti, OPEN);
    gpti.dhalt <= dsuo.tstop; gpti.extclk <= '0';
  END GENERATE;
  notim : IF CFG_GPT_ENABLE = 0 GENERATE apbo(3) <= apb_none; END GENERATE;

  gpio0 : IF CFG_GRGPIO_ENABLE /= 0 GENERATE  -- GR GPIO unit
    grgpio0 : grgpio
      GENERIC MAP(pindex => 11, paddr => 11, imask => CFG_GRGPIO_IMASK,
                  nbits  => CFG_GRGPIO_WIDTH)
      PORT MAP(rstn, clkm, apbi, apbo(11), gpioi, gpioo);

    pio_pads : FOR i IN 0 TO CFG_GRGPIO_WIDTH-1 GENERATE
      pio_pad : iopad GENERIC MAP (tech => padtech)
        PORT MAP (gpio(i), gpioo.dout(i), gpioo.oen(i), gpioi.din(i));
    END GENERATE;
  END GENERATE;

-----------------------------------------------------------------------
---  PCI   ------------------------------------------------------------
-----------------------------------------------------------------------

  --pp : IF CFG_PCI /= 0 GENERATE

  --  pci_gr0 : IF CFG_PCI = 1 GENERATE   -- simple target-only
  --    pci0 : pci_target GENERIC MAP (hindex    => NCPU+CFG_AHB_UART+CFG_AHB_JTAG,
  --                                   device_id => CFG_PCIDID, vendor_id => CFG_PCIVID)
  --      PORT MAP (rstn, clkm, pciclk, pcii, pcio, ahbmi, ahbmo(NCPU+CFG_AHB_UART+CFG_AHB_JTAG));
  --  END GENERATE;

  --  pci_mtf0 : IF CFG_PCI = 2 GENERATE  -- master/target with fifo
  --    pci0 : pci_mtf GENERIC MAP (memtech   => memtech, hmstndx => NCPU+CFG_AHB_UART+CFG_AHB_JTAG,
  --                                fifodepth => log2(CFG_PCIDEPTH), device_id => CFG_PCIDID, vendor_id => CFG_PCIVID,
  --                                hslvndx   => 4, pindex => 4, paddr => 4, haddr => 16#E00#,
  --                                ioaddr    => 16#400#, nsync => 2, hostrst => 1)
  --      PORT MAP (rstn, clkm, pciclk, pcii, pcio, apbi, apbo(4),
  --                ahbmi, ahbmo(NCPU+CFG_AHB_UART+CFG_AHB_JTAG), ahbsi, ahbso(4));
  --  END GENERATE;

  --  pci_mtf1 : IF CFG_PCI = 3 GENERATE  -- master/target with fifo and DMA
  --    dma : pcidma GENERIC MAP (memtech   => memtech, dmstndx => NCPU+CFG_AHB_UART+CFG_AHB_JTAG+1,
  --                              dapbndx   => 5, dapbaddr => 5, blength => blength, mstndx => NCPU+CFG_AHB_UART+CFG_AHB_JTAG,
  --                              fifodepth => log2(CFG_PCIDEPTH), device_id => CFG_PCIDID, vendor_id => CFG_PCIVID,
  --                              slvndx    => 4, apbndx => 4, apbaddr => 4, haddr => 16#E00#, ioaddr => 16#800#,
  --                              nsync     => 2, hostrst => 1)
  --      PORT MAP (rstn, clkm, pciclk, pcii, pcio, apbo(5), ahbmo(NCPU+CFG_AHB_UART+CFG_AHB_JTAG+1),
  --                apbi, apbo(4), ahbmi, ahbmo(NCPU+CFG_AHB_UART+CFG_AHB_JTAG), ahbsi, ahbso(4));
  --  END GENERATE;

  --  pci_trc0 : IF CFG_PCITBUFEN /= 0 GENERATE  -- PCI trace buffer
  --    pt0 : pcitrace GENERIC MAP (depth   => (6 + log2(CFG_PCITBUF/256)),
  --                                memtech => memtech, pindex => 8, paddr => 16#100#, pmask => 16#f00#)
  --      PORT MAP (rstn, clkm, pciclk, pcii, apbi, apbo(8));
  --  END GENERATE;

  --  pcia0 : IF CFG_PCI_ARB = 1 GENERATE  -- PCI arbiter
  --    pciarb0 : pciarb GENERIC MAP (pindex => 10, paddr => 10,
  --                                  apb_en => CFG_PCI_ARBAPB)
  --      PORT MAP (clk    => pciclk, rst_n => pcii.rst,
  --                req_n  => pci_arb_req_n, frame_n => pcii.frame,
  --                gnt_n  => pci_arb_gnt_n, pclk => clkm,
  --                prst_n => rstn, apbi => apbi, apbo => apbo(10)
  --                );
  --    pgnt_pad : outpadv GENERIC MAP (tech => padtech, width => 4)
  --      PORT MAP (pci_arb_gnt, pci_arb_gnt_n);
  --    preq_pad : inpadv GENERIC MAP (tech => padtech, width => 4)
  --      PORT MAP (pci_arb_req, pci_arb_req_n);
  --  END GENERATE;

  --  pcipads0 : pcipads GENERIC MAP (padtech => padtech)  -- PCI pads
  --    PORT MAP (pci_rst, pci_gnt, pci_idsel, pci_lock, pci_ad, pci_cbe,
  --              pci_frame, pci_irdy, pci_trdy, pci_devsel, pci_stop, pci_perr,
  --              pci_par, pci_req, pci_serr, pci_host, pci_66, pcii, pcio);

  --END GENERATE;

--  nop1  : IF CFG_PCI                            <= 1 GENERATE apbo(4) <= apb_none; END GENERATE;
--  nop2  : IF CFG_PCI                            <= 2 GENERATE apbo(5) <= apb_none; END GENERATE;
  nop3  : IF CFG_PCI                            <= 1 GENERATE ahbso(4) <= ahbs_none; END GENERATE;
  notrc : IF CFG_PCITBUFEN = 0 GENERATE apbo(8) <= apb_none; END GENERATE;
  noarb : IF CFG_PCI_ARB = 0 GENERATE apbo(10)  <= apb_none; END GENERATE;
   pci_rst     <=  '0';
    pci_lock     <=  '0';
    pci_ad      <= (OTHERS => '0');
    pci_cbe     <= (OTHERS => '0');
    pci_frame   <=  '0';
    pci_irdy    <=  '0';
    pci_trdy    <=  '0';
    pci_devsel  <=  '0';
    pci_stop    <=  '0';
    pci_perr    <=  '0';
    pci_par     <=  '0';
    pci_req     <=  '0';
    pci_serr    <=  '0';
    pci_arb_gnt <= (OTHERS => '0');


--  ahbso(6) <= ahbs_none;

-----------------------------------------------------------------------
---  AHB RAM ----------------------------------------------------------
-----------------------------------------------------------------------

  ocram : IF CFG_AHBRAMEN = 1 GENERATE
    ahbram0 : ahbram GENERIC MAP (hindex => 7, haddr => CFG_AHBRADDR,
                                  tech   => CFG_MEMTECH, kbytes => CFG_AHBRSZ)
      PORT MAP (rstn, clkm, ahbsi, ahbso(7));
  END GENERATE;
  nram : IF CFG_AHBRAMEN = 0 GENERATE ahbso(7) <= ahbs_none; END GENERATE;

-----------------------------------------------------------------------
---  SPACEWIRE  -------------------------------------------------------
-----------------------------------------------------------------------
  --This template does NOT currently support grspw2 so only use grspw1 
  spw : IF CFG_SPW_EN > 0 GENERATE
    spw_rx_clk <= '0';
    spw_clk_pad : clkpad GENERIC MAP (tech => padtech) PORT MAP (spw_clk, spw_lclk);
    swloop      : FOR i IN 0 TO CFG_SPW_NUM-1 GENERATE
      sw0 : grspwm GENERIC MAP(tech         => memtech, netlist => CFG_SPW_NETLIST,
                               hindex       => maxahbmsp+i, pindex => 12+i, paddr => 12+i, pirq => 10+i,
                               sysfreq      => sysfreq, nsync => 1, rmap => 0, ports => 1, dmachan => 1,
                               fifosize1    => CFG_SPW_AHBFIFO, fifosize2 => CFG_SPW_RXFIFO,
                               rxclkbuftype => 1, spwcore => CFG_SPW_GRSPW)
        PORT MAP(resetn, clkm, spw_rx_clk, spw_rx_clk, spw_lclk, spw_lclk,
                 ahbmi, ahbmo(maxahbmsp+i),
                 apbi, apbo(12+i), spwi(i), spwo(i));
      spwi(i).tickin   <= '0'; spwi(i).rmapen <= '1';
      spwi(i).clkdiv10 <= conv_std_logic_vector(sysfreq/10000-1, 8);
      spw_rxd_pad : inpad_ds GENERIC MAP (padtech, lvds, x25v)
        PORT MAP (spw_rxd(i), spw_rxdn(i), spwi(i).d(0));
      spw_rxs_pad : inpad_ds GENERIC MAP (padtech, lvds, x25v)
        PORT MAP (spw_rxs(i), spw_rxsn(i), spwi(i).s(0));
      spw_txd_pad : outpad_ds GENERIC MAP (padtech, lvds, x25v)
        PORT MAP (spw_txd(i), spw_txdn(i), spwo(i).d(0), gnd(0));
      spw_txs_pad : outpad_ds GENERIC MAP (padtech, lvds, x25v)
        PORT MAP (spw_txs(i), spw_txsn(i), spwo(i).s(0), gnd(0));
    END GENERATE;
  END GENERATE;
  no_spw: IF CFG_SPW_EN = 0 GENERATE
    spw_txd  <= (OTHERS => '0');
    spw_txdn <= (OTHERS => '0');
    spw_txs  <= (OTHERS => '0');
    spw_txsn <= (OTHERS => '0');
  END GENERATE no_spw;



-------------------------------------------------------------------------------
-- BOOT MEMORY AND REGISTER
-------------------------------------------------------------------------------

  lpp_bootloader_1 : lpp_bootloader
    GENERIC MAP (
      pindex => 13,
      paddr  => 13,
      pmask  => 16#fff#,

      hindex => 6,
      haddr  => 16#900#,
      hmask  => 16#F00#)
    PORT MAP (
      HCLK    => clkm,
      HRESETn => resetn,
      apbi    => apbi,
      apbo    => apbo(13),
      ahbsi   => ahbsi,
      ahbso   => ahbso(6));


-------------------------------------------------------------------------------
-- AHB DMA
-------------------------------------------------------------------------------

  --lpp_dma_1 : lpp_dma
  --  GENERIC MAP (
  --    tech   => fabtech,
  --    hindex => 2,
  --    pindex => 14,
  --    paddr  => 14,
  --    pmask  => 16#fff#,
  --    pirq   => 0)
  --  PORT MAP (
  --    HCLK           => clkm,
  --    HRESETn        => resetn,
  --    apbi           => apbi,
  --    apbo           => apbo(14),
  --    AHB_Master_In  => ahbmi,
  --    AHB_Master_Out => ahbmo(2),
  --    fifo_data      => fifo_data,      --dma_data,
  --    fifo_empty     => fifo_empty,     --dma_empty,
  --    fifo_ren       => fifo_ren,       --dma_ren,
  --    header         => header,
  --    header_val     => header_val,
  --    header_ack     => header_ack);

  --fifo_test_dma_1 : fifo_test_dma
  --  GENERIC MAP (
  --    tech   => fabtech,
  --    pindex => 15,
  --    paddr  => 15,
  --    pmask  => 16#fff#)
  --  PORT MAP (
  --    HCLK       => clkm,
  --    HRESETn    => resetn,
  --    apbi       => apbi,
  --    apbo       => apbo(15),
  --    fifo_data  => fifo_data,
  --    fifo_empty => fifo_empty,
  --    fifo_ren   => fifo_ren,
  --    header     => header,
  --    header_val => header_val,
  --    header_ack => header_ack);
  
--------------------------
-- APB_LFR_TIME_MANAGEMENT
--------------------------
    lfrtimemanagement_0 : apb_lfr_time_management
	generic map(
          pindex => 15,
          paddr => 15,
          pmask => 16#fff#,
          masterclk => 25000000,
          timeclk => 49152000,
          finetimeclk => 65536, 
          pirq => 12) -- the IP uses 2 consecutive IRQ lines
	port map(
          clkm,
          clk49_152MHz,
          rstn,
          '0',
          apbi,
          apbo(15),
          coarse_time,
          fine_time);

------------------
-- WAVEFORM PICKER
------------------	
  waveform_picker0 : lpp_top_lfr_wf_picker
    GENERIC MAP(
      hindex                  => 3,
      pindex                  => 14,
      paddr                   => 14,
      pmask                   => 16#fff#,
      pirq                    => 15,
      tech                    => CFG_FABTECH,
      nb_burst_available_size => 11,  -- size of the register holding the nb of burst
      nb_snapshot_param_size  => 11,  -- size of the register holding the snapshots size
      delta_snapshot_size     => 16,    -- snapshots period
      delta_f2_f0_size        => 10,  -- initialize the counter when the f2 snapshot starts 
      delta_f2_f1_size        => 10  -- nb f0 ticks before starting the f1 snapshot
      )
    PORT MAP(
      -- ADS7886
      cnv_run         => '1',           -- stop the sampling request
      cnv             => cnv_ch1,
      sck             => sck_ch1,
      sdo             => sdo_adc,
      --
      cnv_clk         => clk49_152MHz,
      cnv_rstn        => rstn,
      -- AMBA AHB system signals
      HCLK            => clkm,
      HRESETn         => rstn,
      -- AMBA APB Slave Interface
      apbi            => apbi,
      apbo            => apbo(14),
      -- AMBA AHB Master Interface
      AHB_Master_In   => ahbmi,
      AHB_Master_Out  => ahbmo(3),
      --
      coarse_time_0   => coarse_time(0),  -- bit 0 of the coarse time
      -- 
      data_shaping_BW => Bias_Fails
      );

-----------------------------------------------------------------------
---  Boot message  ----------------------------------------------------
-----------------------------------------------------------------------

-- pragma translate_off
  x : report_version
    GENERIC MAP (
      msg1 => "LEON3 MP Demonstration design",
      msg2 => "GRLIB Version " & tost(LIBVHDL_VERSION/1000) & "." & tost((LIBVHDL_VERSION MOD 1000)/100)
      & "." & tost(LIBVHDL_VERSION MOD 100) & ", build " & tost(LIBVHDL_BUILD),
      msg3 => "Target technology: " & tech_table(fabtech) & ",  memory library: " & tech_table(memtech),
      mdel => 1
      );
-- pragma translate_on
END;
