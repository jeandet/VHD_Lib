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


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
LIBRARY grlib;
USE grlib.amba.ALL;
USE grlib.stdlib.ALL;
LIBRARY techmap;
USE techmap.gencomp.ALL;
LIBRARY gaisler;
USE gaisler.memctrl.ALL;
USE gaisler.leon3.ALL;
USE gaisler.uart.ALL;
USE gaisler.misc.ALL;
USE gaisler.spacewire.ALL;              -- PLE
LIBRARY esa;
USE esa.memoryctrl.ALL;
USE work.config.ALL;
LIBRARY lpp;
USE lpp.lpp_memory.ALL;
USE lpp.lpp_ad_conv.ALL;
USE lpp.lpp_lfr_pkg.ALL;
USE lpp.iir_filter.ALL;
USE lpp.general_purpose.ALL;
USE lpp.lpp_lfr_time_management.ALL;

ENTITY leon3mp IS
  GENERIC (
    fabtech : INTEGER := CFG_FABTECH;
    memtech : INTEGER := CFG_MEMTECH;
    padtech : INTEGER := CFG_PADTECH;
    clktech : INTEGER := CFG_CLKTECH;
    disas   : INTEGER := CFG_DISAS;     -- Enable disassembly to console
    dbguart : INTEGER := CFG_DUART;     -- Print UART on console
    pclow   : INTEGER := CFG_PCLOW
    );
  PORT (
    clk100MHz    : IN STD_ULOGIC;
    clk49_152MHz : IN STD_ULOGIC;
    reset        : IN STD_ULOGIC;

    errorn : OUT STD_ULOGIC;

    -- UART AHB ---------------------------------------------------------------
    ahbrxd : IN  STD_ULOGIC;            -- DSU rx data  
    ahbtxd : OUT STD_ULOGIC;            -- DSU tx data

    -- UART APB ---------------------------------------------------------------
    urxd1 : IN  STD_ULOGIC;             -- UART1 rx data
    utxd1 : OUT STD_ULOGIC;             -- UART1 tx data    

    -- RAM --------------------------------------------------------------------
    address   : OUT   STD_LOGIC_VECTOR(19 DOWNTO 0);
    data      : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    nSRAM_BE0 : OUT   STD_LOGIC;
    nSRAM_BE1 : OUT   STD_LOGIC;
    nSRAM_BE2 : OUT   STD_LOGIC;
    nSRAM_BE3 : OUT   STD_LOGIC;
    nSRAM_WE  : OUT   STD_LOGIC;
    nSRAM_CE  : OUT   STD_LOGIC;
    nSRAM_OE  : OUT   STD_LOGIC;

    -- SPW --------------------------------------------------------------------
    spw1_din  : IN  STD_LOGIC;          -- PLE
    spw1_sin  : IN  STD_LOGIC;          -- PLE
    spw1_dout : OUT STD_LOGIC;          -- PLE
    spw1_sout : OUT STD_LOGIC;          -- PLE

    spw2_din  : IN  STD_LOGIC;  -- JCPE --TODO
    spw2_sin  : IN  STD_LOGIC;  -- JCPE --TODO
    spw2_dout : OUT STD_LOGIC;  -- JCPE --TODO
    spw2_sout : OUT STD_LOGIC;  -- JCPE --TODO

    -- ADC --------------------------------------------------------------------
    bias_fail_sw   : OUT STD_LOGIC;
    ADC_OEB_bar_CH : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    ADC_smpclk     : OUT STD_LOGIC;
    ADC_data       : IN  STD_LOGIC_VECTOR(13 DOWNTO 0);

    ---------------------------------------------------------------------------
    led : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END;

ARCHITECTURE Behavioral OF leon3mp IS

--constant maxahbmsp : integer := CFG_NCPU+CFG_AHB_UART+
--      CFG_GRETH+CFG_AHB_JTAG;
  CONSTANT maxahbmsp : INTEGER := CFG_NCPU+
                                  CFG_AHB_UART
                                  +2;
  -- 1 is for the SpaceWire module grspw, which is a master
  -- 1 is for the LFR
  
  CONSTANT maxahbm : INTEGER := maxahbmsp;

--Clk & Rst géné
  SIGNAL vcc        : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL gnd        : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL resetnl    : STD_ULOGIC;
  SIGNAL clk2x      : STD_ULOGIC;
  SIGNAL lclk2x     : STD_ULOGIC;
  SIGNAL lclk25MHz  : STD_ULOGIC;
  SIGNAL lclk50MHz  : STD_ULOGIC;
  SIGNAL lclk100MHz : STD_ULOGIC;
  SIGNAL clkm       : STD_ULOGIC;
  SIGNAL rstn       : STD_ULOGIC;
  SIGNAL rstraw     : STD_ULOGIC;
  SIGNAL pciclk     : STD_ULOGIC;
  SIGNAL sdclkl     : STD_ULOGIC;
  SIGNAL cgi        : clkgen_in_type;
  SIGNAL cgo        : clkgen_out_type;
--- AHB / APB
  SIGNAL apbi       : apb_slv_in_type;
  SIGNAL apbo       : apb_slv_out_vector := (OTHERS => apb_none);
  SIGNAL ahbsi      : ahb_slv_in_type;
  SIGNAL ahbso      : ahb_slv_out_vector := (OTHERS => ahbs_none);
  SIGNAL ahbmi      : ahb_mst_in_type;
  SIGNAL ahbmo      : ahb_mst_out_vector := (OTHERS => ahbm_none);
--UART
  SIGNAL ahbuarti   : uart_in_type;
  SIGNAL ahbuarto   : uart_out_type;
  SIGNAL apbuarti   : uart_in_type;
  SIGNAL apbuarto   : uart_out_type;
--MEM CTRLR
  SIGNAL memi       : memory_in_type;
  SIGNAL memo       : memory_out_type;
  SIGNAL wpo        : wprot_out_type;
  SIGNAL sdo        : sdram_out_type;
  SIGNAL ramcs      : STD_ULOGIC;
--IRQ
  SIGNAL irqi       : irq_in_vector(0 TO CFG_NCPU-1);
  SIGNAL irqo       : irq_out_vector(0 TO CFG_NCPU-1);
--Timer
  SIGNAL gpti       : gptimer_in_type;
  SIGNAL gpto       : gptimer_out_type;
--GPIO
  SIGNAL gpioi      : gpio_in_type;
  SIGNAL gpioo      : gpio_out_type;
--DSU
  SIGNAL dbgi       : l3_debug_in_vector(0 TO CFG_NCPU-1);
  SIGNAL dbgo       : l3_debug_out_vector(0 TO CFG_NCPU-1);
  SIGNAL dsui       : dsu_in_type;
  SIGNAL dsuo       : dsu_out_type;

---------------------------------------------------------------------
---  AJOUT TEST ------------------------Signaux----------------------
---------------------------------------------------------------------

---------------------------------------------------------------------
  CONSTANT IOAEN     : INTEGER := CFG_CAN;
  CONSTANT boardfreq : INTEGER := 25000;  -- the board frequency (lclk) is 50 MHz

-- time management signal
  SIGNAL coarse_time : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL fine_time   : STD_LOGIC_VECTOR(15 DOWNTO 0);

-- Spacewire signals
  SIGNAL dtmp        : STD_LOGIC_VECTOR(1 DOWNTO 0);  -- PLE
  SIGNAL stmp        : STD_LOGIC_VECTOR(1 DOWNTO 0);  -- PLE
  SIGNAL spw_rxclk   : STD_LOGIC_VECTOR(1 DOWNTO 0);  -- PLE
  SIGNAL spw_rxtxclk : STD_ULOGIC;
  SIGNAL spw_rxclkn  : STD_ULOGIC;
  SIGNAL spw_clk     : STD_LOGIC;
  SIGNAL swni        : grspw_in_type;                 -- PLE
  SIGNAL swno        : grspw_out_type;                -- PLE
  SIGNAL clkmn       : STD_ULOGIC;                    -- PLE
  SIGNAL txclk       : STD_ULOGIC;                    -- PLE 2013 02 14

-- AD Converter RHF1401
  SIGNAL sample           : Samples14v(7 DOWNTO 0);
  SIGNAL sample_val       : STD_LOGIC;
  -----------------------------------------------------------------------------
  SIGNAL ADC_OEB_bar_CH_s : STD_LOGIC_VECTOR(7 DOWNTO 0);
  -----------------------------------------------------------------------------
  SIGNAL  debug_f0_data       : STD_LOGIC_VECTOR(95 DOWNTO 0);
  SIGNAL  debug_f0_data_valid : STD_LOGIC;
  SIGNAL  debug_f1_data       : STD_LOGIC_VECTOR(95 DOWNTO 0);
  SIGNAL  debug_f1_data_valid : STD_LOGIC;
  SIGNAL  debug_f2_data       : STD_LOGIC_VECTOR(95 DOWNTO 0);
  SIGNAL  debug_f2_data_valid : STD_LOGIC;
  SIGNAL  debug_f3_data       : STD_LOGIC_VECTOR(95 DOWNTO 0);
  SIGNAL  debug_f3_data_valid : STD_LOGIC;

BEGIN


----------------------------------------------------------------------
---  Reset and Clock generation  -------------------------------------
----------------------------------------------------------------------
  
  vcc         <= (OTHERS => '1'); gnd <= (OTHERS => '0');
  cgi.pllctrl <= "00"; cgi.pllrst <= rstraw;

  rst0 : rstgen PORT MAP (reset, clkm, cgo.clklock, rstn, rstraw);


  clk_pad : clkpad GENERIC MAP (tech => padtech) PORT MAP (clk100MHz, lclk100MHz);

  clkgen0 : clkgen                      -- clock generator
    GENERIC MAP (clktech, CFG_CLKMUL, CFG_CLKDIV, CFG_MCTRL_SDEN,
                 CFG_CLK_NOFB, 0, 0, 0, boardfreq, 0, 0, CFG_OCLKDIV)
    PORT MAP (lclk25MHz, lclk25MHz, clkm, clkmn, clk2x, sdclkl, pciclk, cgi, cgo);

  PROCESS(lclk100MHz)
  BEGIN
    IF lclk100MHz'EVENT AND lclk100MHz = '1' THEN
      lclk50MHz <= NOT lclk50MHz;
    END IF;
  END PROCESS;

  PROCESS(lclk50MHz)
  BEGIN
    IF lclk50MHz'EVENT AND lclk50MHz = '1' THEN
      lclk25MHz <= NOT lclk25MHz;
    END IF;
  END PROCESS;

  lclk2x  <= lclk50MHz;
  spw_clk <= lclk50MHz;

----------------------------------------------------------------------
---  LEON3 processor / DSU / IRQ  ------------------------------------
----------------------------------------------------------------------

  l3 : IF CFG_LEON3 = 1 GENERATE
    cpu : FOR i IN 0 TO CFG_NCPU-1 GENERATE
      u0 : leon3s                       -- LEON3 processor      
        GENERIC MAP (i, fabtech, memtech, CFG_NWIN, CFG_DSU, CFG_FPU, CFG_V8,
                     0, CFG_MAC, pclow, 0, CFG_NWP, CFG_ICEN, CFG_IREPL, CFG_ISETS, CFG_ILINE,
                     CFG_ISETSZ, CFG_ILOCK, CFG_DCEN, CFG_DREPL, CFG_DSETS, CFG_DLINE, CFG_DSETSZ,
                     CFG_DLOCK, CFG_DSNOOP, CFG_ILRAMEN, CFG_ILRAMSZ, CFG_ILRAMADDR, CFG_DLRAMEN,
                     CFG_DLRAMSZ, CFG_DLRAMADDR, CFG_MMUEN, CFG_ITLBNUM, CFG_DTLBNUM, CFG_TLB_TYPE, CFG_TLB_REP,
                     CFG_LDDEL, disas, CFG_ITBSZ, CFG_PWD, CFG_SVT, CFG_RSTADDR, CFG_NCPU-1)
        PORT MAP (clkm, rstn, ahbmi, ahbmo(i), ahbsi, ahbso,
                  irqi(i), irqo(i), dbgi(i), dbgo(i));
    END GENERATE;
    errorn_pad : outpad GENERIC MAP (tech => padtech) PORT MAP (errorn, dbgo(0).error);

    dsugen : IF CFG_DSU = 1 GENERATE
      dsu0 : dsu3                       -- LEON3 Debug Support Unit
        GENERIC MAP (hindex => 2, haddr => 16#900#, hmask => 16#F00#,
                     ncpu   => CFG_NCPU, tbits => 30, tech => memtech, irq => 0, kbytes => CFG_ATBSZ)
        PORT MAP (rstn, clkm, ahbmi, ahbsi, ahbso(2), dbgo, dbgi, dsui, dsuo);
      dsui.enable <= '1';
      dsui.break  <= '0';
      led(2)      <= dsuo.active;
    END GENERATE;
  END GENERATE;

  nodsu : IF CFG_DSU = 0 GENERATE
    ahbso(2) <= ahbs_none; dsuo.tstop <= '0'; dsuo.active <= '0';
  END GENERATE;

  irqctrl : IF CFG_IRQ3_ENABLE /= 0 GENERATE
    irqctrl0 : irqmp                    -- interrupt controller
      GENERIC MAP (pindex => 2, paddr => 2, ncpu => CFG_NCPU)
      PORT MAP (rstn, clkm, apbi, apbo(2), irqo, irqi);
  END GENERATE;
  irq3 : IF CFG_IRQ3_ENABLE = 0 GENERATE
    x : FOR i IN 0 TO CFG_NCPU-1 GENERATE
      irqi(i).irl <= "0000";
    END GENERATE;
    apbo(2) <= apb_none;
  END GENERATE;

----------------------------------------------------------------------
---  Memory controllers  ---------------------------------------------
----------------------------------------------------------------------
  memctrlr : mctrl GENERIC MAP (
    hindex  => 0,
    pindex  => 0,
    paddr   => 0,
    srbanks => 1
    )
    PORT MAP (rstn, clkm, memi, memo, ahbsi, ahbso(0), apbi, apbo(0), wpo, sdo);

  memi.brdyn  <= '1';
  memi.bexcn  <= '1';
  memi.writen <= '1';
  memi.wrn    <= "1111";
  memi.bwidth <= "10";

  bdr : FOR i IN 0 TO 3 GENERATE
    data_pad : iopadv GENERIC MAP (tech => padtech, width => 8)
      PORT MAP (
        data(31-i*8 DOWNTO 24-i*8),
        memo.data(31-i*8 DOWNTO 24-i*8),
        memo.bdrive(i),
        memi.data(31-i*8 DOWNTO 24-i*8));
  END GENERATE;

  addr_pad : outpadv GENERIC MAP (width => 20, tech => padtech)
    PORT MAP (address, memo.address(21 DOWNTO 2));
  
  rams_pad : outpad GENERIC MAP (tech => padtech) PORT MAP (nSRAM_CE, NOT(memo.ramsn(0)));
  oen_pad  : outpad GENERIC MAP (tech => padtech) PORT MAP (nSRAM_OE, memo.ramoen(0));
  nBWE_pad : outpad GENERIC MAP (tech => padtech) PORT MAP (nSRAM_WE, memo.writen);
  nBWa_pad : outpad GENERIC MAP (tech => padtech) PORT MAP (nSRAM_BE0, memo.mben(3));
  nBWb_pad : outpad GENERIC MAP (tech => padtech) PORT MAP (nSRAM_BE1, memo.mben(2));
  nBWc_pad : outpad GENERIC MAP (tech => padtech) PORT MAP (nSRAM_BE2, memo.mben(1));
  nBWd_pad : outpad GENERIC MAP (tech => padtech) PORT MAP (nSRAM_BE3, memo.mben(0));

----------------------------------------------------------------------
---  AHB CONTROLLER  -------------------------------------------------
----------------------------------------------------------------------
  ahb0 : ahbctrl                        -- AHB arbiter/multiplexer
    GENERIC MAP (defmast => CFG_DEFMST, split => CFG_SPLIT,
                 rrobin  => CFG_RROBIN, ioaddr => CFG_AHBIO,
                 ioen    => IOAEN, nahbm => maxahbm, nahbs => 8)
    PORT MAP (rstn, clkm, ahbmi, ahbmo, ahbsi, ahbso);

----------------------------------------------------------------------
---  AHB UART  -------------------------------------------------------
----------------------------------------------------------------------
  dcomgen : IF CFG_AHB_UART = 1 GENERATE
    dcom0 : ahbuart
      GENERIC MAP (hindex => 3, pindex => 4, paddr => 4)
      PORT MAP (rstn, clkm, ahbuarti, ahbuarto, apbi, apbo(4), ahbmi, ahbmo(3));
    dsurx_pad : inpad GENERIC MAP (tech  => padtech) PORT MAP (ahbrxd, ahbuarti.rxd);
    dsutx_pad : outpad GENERIC MAP (tech => padtech) PORT MAP (ahbtxd, ahbuarto.txd);
    led(0) <= NOT ahbuarti.rxd;
    led(1) <= NOT ahbuarto.txd;
  END GENERATE;
  nouah : IF CFG_AHB_UART = 0 GENERATE apbo(4) <= apb_none; END GENERATE;

----------------------------------------------------------------------
---  APB Bridge  -----------------------------------------------------
----------------------------------------------------------------------
  apb0 : apbctrl                        -- AHB/APB bridge
    GENERIC MAP (hindex => 1, haddr => CFG_APBADDR)
    PORT MAP (rstn, clkm, ahbsi, ahbso(1), apbi, apbo);

----------------------------------------------------------------------
---  GPT Timer  ------------------------------------------------------
----------------------------------------------------------------------
  gpt : IF CFG_GPT_ENABLE /= 0 GENERATE
    timer0 : gptimer                    -- timer unit
      GENERIC MAP (pindex => 3, paddr => 3, pirq => CFG_GPT_IRQ,
                   sepirq => CFG_GPT_SEPIRQ, sbits => CFG_GPT_SW, ntimers => CFG_GPT_NTIM,
                   nbits  => CFG_GPT_TW)
      PORT MAP (rstn, clkm, apbi, apbo(3), gpti, gpto);
    gpti.dhalt  <= dsuo.tstop;
    gpti.extclk <= '0';
  END GENERATE;
  notim : IF CFG_GPT_ENABLE = 0 GENERATE apbo(3) <= apb_none; END GENERATE;


----------------------------------------------------------------------
---  APB UART  -------------------------------------------------------
----------------------------------------------------------------------
  ua1 : IF CFG_UART1_ENABLE /= 0 GENERATE
    uart1 : apbuart                     -- UART 1
      GENERIC MAP (pindex   => 1, paddr => 1, pirq => 2, console => dbguart,
                   fifosize => CFG_UART1_FIFO)
      PORT MAP (rstn, clkm, apbi, apbo(1), apbuarti, apbuarto);
    apbuarti.rxd    <= urxd1;
    apbuarti.extclk <= '0';
    utxd1           <= apbuarto.txd;
    apbuarti.ctsn   <= '0';
  END GENERATE;
  noua0 : IF CFG_UART1_ENABLE = 0 GENERATE apbo(1) <= apb_none; END GENERATE;

-------------------------------------------------------------------------------
-- APB_LFR_TIME_MANAGEMENT ----------------------------------------------------
-------------------------------------------------------------------------------
  apb_lfr_time_management_1: apb_lfr_time_management
    GENERIC MAP (
      pindex => 6,
      paddr  => 6,
      pmask  => 16#fff#,
      pirq   => 12)
    PORT MAP (
      clk25MHz     => clkm,
      clk49_152MHz => clk49_152MHz,
      resetn       => rstn,
      grspw_tick   => swno.tickout,
      apbi         => apbi,
      apbo         => apbo(6),
      coarse_time  => coarse_time,
      fine_time    => fine_time);

-----------------------------------------------------------------------
---  SpaceWire --------------------------------------------------------
-----------------------------------------------------------------------

  spw_rxtxclk <= spw_clk;
  spw_rxclkn  <= NOT spw_rxtxclk;

  -- PADS for SPW1
  spw1_rxd_pad : inpad GENERIC MAP (tech => padtech)
    PORT MAP (spw1_din, dtmp(0));
  spw1_rxs_pad : inpad GENERIC MAP (tech => padtech)
    PORT MAP (spw1_sin, stmp(0));
  spw1_txd_pad : outpad GENERIC MAP (tech => padtech)
    PORT MAP (spw1_dout, swno.d(0));
  spw1_txs_pad : outpad GENERIC MAP (tech => padtech)
    PORT MAP (spw1_sout, swno.s(0));
  -- PADS FOR SPW2
  spw2_rxd_pad : inpad GENERIC MAP (tech => padtech)
    PORT MAP (spw2_din, dtmp(1));
  spw2_rxs_pad : inpad GENERIC MAP (tech => padtech)
    PORT MAP (spw2_sin, stmp(1));
  spw2_txd_pad : outpad GENERIC MAP (tech => padtech)
    PORT MAP (spw2_dout, swno.d(1));
  spw2_txs_pad : outpad GENERIC MAP (tech => padtech)
    PORT MAP (spw2_sout, swno.s(1));

  -- GRSPW PHY
  --spw1_input: if CFG_SPW_GRSPW = 1 generate
  spw_inputloop : FOR j IN 0 TO 1 GENERATE
    spw_phy0 : grspw_phy
      GENERIC MAP(
        tech         => fabtech,
        rxclkbuftype => 1,
        scantest     => 0)
      PORT MAP(
        rxrst    => swno.rxrst,
        di       => dtmp(j),
        si       => stmp(j),
        rxclko   => spw_rxclk(j),
        do       => swni.d(j),
        ndo      => swni.nd(j*5+4 DOWNTO j*5),
        dconnect => swni.dconnect(j*2+1 DOWNTO j*2));
  END GENERATE spw_inputloop;

  -- SPW core
  sw0 : grspwm
    GENERIC MAP(
      tech         => apa3e,
      hindex       => 1,
      pindex       => 5,
      paddr        => 5,
      pirq         => 11,
      sysfreq      => 25000,            -- CPU_FREQ
      rmap         => 1,
      rmapcrc      => 1,
      fifosize1    => 16,
      fifosize2    => 16,
      rxclkbuftype => 1,
      rxunaligned  => 0,
      rmapbufs     => 4,
      ft           => 0,
      netlist      => 0,
      ports        => 2,
      --dmachan => CFG_SPW_DMACHAN, -- not used byt the spw core 1
      memtech      => apa3e,
      destkey      => 2,
      spwcore      => 1
      --input_type => CFG_SPW_INPUT, -- not used byt the spw core 1
      --output_type => CFG_SPW_OUTPUT,  -- not used byt the spw core 1
      --rxtx_sameclk => CFG_SPW_RTSAME -- not used byt the spw core 1
      )
    PORT MAP(rstn, clkm, spw_rxclk(0),
             spw_rxclk(1), spw_rxtxclk, spw_rxtxclk,
             ahbmi, ahbmo(1), apbi, apbo(5),
             swni, swno);

  swni.tickin      <= '0';
  swni.rmapen      <= '1';
  swni.clkdiv10    <= "00000100";       -- 50 MHz / (4 + 1) = 10 MHz
  swni.tickinraw   <= '0';
  swni.timein      <= (OTHERS => '0');
  swni.dcrstval    <= (OTHERS => '0');
  swni.timerrstval <= (OTHERS => '0');

-------------------------------------------------------------------------------
-- LFR
-------------------------------------------------------------------------------
  lpp_lfr_1 : lpp_lfr
    GENERIC MAP (
      Mem_use                 => use_RAM,
      nb_data_by_buffer_size  => 32,
      nb_word_by_buffer_size  => 30,
      nb_snapshot_param_size  => 32,
      delta_vector_size       => 32,
      delta_vector_size_f0_2  =>  7,    -- log2(96)
      pindex                  => 15,
      paddr                   => 15,
      pmask                   => 16#fff#,
      pirq_ms                 => 6,
      pirq_wfp                => 14,
      hindex                  => 2,
      top_lfr_version         => X"00000008")
    PORT MAP (
      clk               => clkm,
      rstn              => rstn,
      sample_B          => sample(2 DOWNTO 0),
      sample_E          => sample(7 DOWNTO 3),
      sample_val        => sample_val,
      apbi              => apbi,
      apbo              => apbo(15),
      ahbi              => ahbmi,
      ahbo              => ahbmo(2),
      coarse_time       => coarse_time,
      fine_time         => fine_time,
      data_shaping_BW   => bias_fail_sw,

      -------------------------------------------------------------------------
      debug_f0_data        => debug_f0_data      ,  
      debug_f0_data_valid  => debug_f0_data_valid,     
      debug_f1_data        => debug_f1_data      ,     
      debug_f1_data_valid  => debug_f1_data_valid,     
      debug_f2_data        => debug_f2_data      ,     
      debug_f2_data_valid  => debug_f2_data_valid,     
      debug_f3_data        => debug_f3_data      ,     
      debug_f3_data_valid  => debug_f3_data_valid
      );

  top_ad_conv_RHF1401_1 : top_ad_conv_RHF1401
    GENERIC MAP (
      ChanelCount     => 8,
      ncycle_cnv_high => 79,
      ncycle_cnv      => 500)
    PORT MAP (
      cnv_clk    => clk49_152MHz,
      cnv_rstn   => rstn,
      cnv        => ADC_smpclk,
      clk        => clkm,
      rstn       => rstn,
      ADC_data   => ADC_data,
      ADC_nOE    => ADC_OEB_bar_CH,
      sample     => sample,
      sample_val => sample_val);

END Behavioral;
