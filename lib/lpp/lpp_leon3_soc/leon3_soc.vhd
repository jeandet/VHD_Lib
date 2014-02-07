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
LIBRARY lpp;
USE lpp.lpp_memory.ALL;
USE lpp.lpp_ad_conv.ALL;
USE lpp.lpp_lfr_pkg.ALL;
USE lpp.iir_filter.ALL;
USE lpp.general_purpose.ALL;
USE lpp.lpp_lfr_time_management.ALL;
USE lpp.lpp_leon3_soc_pkg.ALL;

ENTITY leon3_soc IS
  GENERIC (
    fabtech : INTEGER := apa3e;
    memtech : INTEGER := apa3e;
    padtech : INTEGER := inferred;
    clktech : INTEGER := inferred;
    disas   : INTEGER := 0;     -- Enable disassembly to console
    dbguart : INTEGER := 0;     -- Print UART on console
    pclow   : INTEGER := 2;
    --
    clk_freq : INTEGER := 25000;       --kHz
    --
    NB_CPU      : INTEGER := 1;
    ENABLE_FPU  : INTEGER := 1;
    FPU_NETLIST : INTEGER := 1;
    ENABLE_DSU : INTEGER := 1;
    ENABLE_AHB_UART : INTEGER := 1;
    ENABLE_APB_UART : INTEGER := 1;
    ENABLE_IRQMP : INTEGER := 1;
    ENABLE_GPT : INTEGER := 1;
    --
    NB_AHB_MASTER : INTEGER := 0;
    NB_AHB_SLAVE  : INTEGER := 0;
    NB_APB_SLAVE  : INTEGER := 0
    );
  PORT (
    clk    : IN STD_ULOGIC;
    reset  : IN STD_ULOGIC;

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

    -- APB --------------------------------------------------------------------
    apbi_ext    : OUT apb_slv_in_type;
    apbo_ext    : IN  soc_apb_slv_out_vector(NB_APB_SLAVE-1+5  DOWNTO 5);
    -- AHB_Slave --------------------------------------------------------------
    ahbi_s_ext  : OUT ahb_slv_in_type;
    ahbo_s_ext  : IN  soc_ahb_slv_out_vector(NB_AHB_SLAVE-1+3  DOWNTO 3);
    -- AHB_Master -------------------------------------------------------------
    ahbi_m_ext  : OUT AHB_Mst_In_Type;
    ahbo_m_ext  : IN  soc_ahb_mst_out_vector(NB_AHB_MASTER-1+NB_CPU DOWNTO NB_CPU)
    
    );
END;

ARCHITECTURE Behavioral OF leon3_soc IS

  -----------------------------------------------------------------------------
  -- CONFIG -------------------------------------------------------------------
  -----------------------------------------------------------------------------

  -- Clock generator
  constant CFG_CLKMUL : integer := (1);
  constant CFG_CLKDIV : integer := (1); -- divide 50MHz by 2 to get 25MHz
  constant CFG_OCLKDIV : integer := (1);
  constant CFG_CLK_NOFB : integer := 0;
  -- LEON3 processor core
  constant CFG_LEON3 : integer := 1;
  constant CFG_NCPU  : integer := NB_CPU;
  constant CFG_NWIN  : integer := (8); -- to be compatible with BCC and RCC
  constant CFG_V8    : integer := 0;
  constant CFG_MAC   : integer := 0;
  constant CFG_SVT    : integer := 0;
  constant CFG_RSTADDR : integer := 16#00000#;
  constant CFG_LDDEL : integer := (1);
  constant CFG_NWP : integer := (0);
  constant CFG_PWD : integer := 1*2;
  constant CFG_FPU : integer := ENABLE_FPU *(8 + 16 * FPU_NETLIST);
  -- 1*(8 + 16 * 0) => grfpu-light
  -- 1*(8 + 16 * 1) => netlist
  -- 0*(8 + 16 * 0) => No FPU
  -- 0*(8 + 16 * 1) => No FPU;
  constant CFG_ICEN : integer := 1;
  constant CFG_ISETS : integer := 1;
  constant CFG_ISETSZ : integer := 4;
  constant CFG_ILINE : integer := 4;
  constant CFG_IREPL : integer := 0;
  constant CFG_ILOCK : integer := 0;
  constant CFG_ILRAMEN : integer := 0;
  constant CFG_ILRAMADDR: integer := 16#8E#;
  constant CFG_ILRAMSZ : integer := 1;
  constant CFG_DCEN : integer := 1;
  constant CFG_DSETS : integer := 1;
  constant CFG_DSETSZ : integer := 4;
  constant CFG_DLINE : integer := 4;
  constant CFG_DREPL : integer := 0;
  constant CFG_DLOCK : integer := 0;
  constant CFG_DSNOOP : integer := 0 + 0 + 4*0;
  constant CFG_DLRAMEN : integer := 0;
  constant CFG_DLRAMADDR: integer := 16#8F#;
  constant CFG_DLRAMSZ : integer := 1;
  constant CFG_MMUEN : integer := 0;
  constant CFG_ITLBNUM : integer := 2;
  constant CFG_DTLBNUM : integer := 2;
  constant CFG_TLB_TYPE : integer := 1 + 0*2;
  constant CFG_TLB_REP : integer := 1;
  
  constant CFG_DSU : integer := ENABLE_DSU;
  constant CFG_ITBSZ : integer := 0;
  constant CFG_ATBSZ : integer := 0;

  -- AMBA settings
  constant CFG_DEFMST : integer := (0);
  constant CFG_RROBIN : integer := 1;
  constant CFG_SPLIT : integer := 0;
  constant CFG_AHBIO : integer := 16#FFF#;
  constant CFG_APBADDR : integer := 16#800#;

  -- DSU UART
  constant CFG_AHB_UART : integer := ENABLE_AHB_UART;

  -- LEON2 memory controller
  constant CFG_MCTRL_SDEN : integer := 0;
  
  -- UART 1
  constant CFG_UART1_ENABLE : integer := ENABLE_APB_UART;
  constant CFG_UART1_FIFO : integer := 1;

  -- LEON3 interrupt controller
  constant CFG_IRQ3_ENABLE : integer := ENABLE_IRQMP;

  -- Modular timer
  constant CFG_GPT_ENABLE : integer := ENABLE_GPT;
  constant CFG_GPT_NTIM : integer := (2);
  constant CFG_GPT_SW : integer := (8);
  constant CFG_GPT_TW : integer := (32);
  constant CFG_GPT_IRQ : integer := (8);
  constant CFG_GPT_SEPIRQ : integer := 1;
  constant CFG_GPT_WDOGEN : integer := 0;
  constant CFG_GPT_WDOG : integer := 16#0#;
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- SIGNALs
  -----------------------------------------------------------------------------
  CONSTANT maxahbmsp : INTEGER := CFG_NCPU + CFG_AHB_UART + NB_AHB_MASTER;
  -- CLK & RST --
  SIGNAL clk2x      : STD_ULOGIC;
  SIGNAL clkmn       : STD_ULOGIC;
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
  --IRQ
  SIGNAL irqi       : irq_in_vector(0 TO CFG_NCPU-1);
  SIGNAL irqo       : irq_out_vector(0 TO CFG_NCPU-1);
  --Timer
  SIGNAL gpti       : gptimer_in_type;
  SIGNAL gpto       : gptimer_out_type;
  --DSU
  SIGNAL dbgi       : l3_debug_in_vector(0 TO CFG_NCPU-1);
  SIGNAL dbgo       : l3_debug_out_vector(0 TO CFG_NCPU-1);
  SIGNAL dsui       : dsu_in_type;
  SIGNAL dsuo       : dsu_out_type;
  -----------------------------------------------------------------------------
  
  SIGNAL nSRAM_CE_s  : STD_LOGIC;
BEGIN


----------------------------------------------------------------------
---  Reset and Clock generation  -------------------------------------
----------------------------------------------------------------------
  
  cgi.pllctrl <= "00";
  cgi.pllrst  <= rstraw;

  rst0 : rstgen PORT MAP (reset, clkm, cgo.clklock, rstn, rstraw);

  clkgen0 : clkgen                      -- clock generator
    GENERIC MAP (clktech, CFG_CLKMUL, CFG_CLKDIV, CFG_MCTRL_SDEN,
                 CFG_CLK_NOFB, 0, 0, 0, clk_freq, 0, 0, CFG_OCLKDIV)
    PORT MAP (clk, clk, clkm, clkmn, clk2x, sdclkl, pciclk, cgi, cgo);

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
    END GENERATE;
  END GENERATE;

  nodsu : IF CFG_DSU = 0 GENERATE
    ahbso(2) <= ahbs_none;
    dsuo.tstop <= '0';
    dsuo.active <= '0';
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
  nSRAM_CE_s <= NOT(memo.ramsn(0));
  rams_pad : outpad GENERIC MAP (tech => padtech) PORT MAP (nSRAM_CE, nSRAM_CE_s);
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
                 ioen    => 0, nahbm => maxahbmsp, nahbs => 8)
    PORT MAP (rstn, clkm, ahbmi, ahbmo, ahbsi, ahbso);

----------------------------------------------------------------------
---  AHB UART  -------------------------------------------------------
----------------------------------------------------------------------
  dcomgen : IF CFG_AHB_UART = 1 GENERATE
    dcom0 : ahbuart
      GENERIC MAP (hindex => maxahbmsp-1, pindex => 4, paddr => 4)
      PORT MAP (rstn, clkm, ahbuarti, ahbuarto, apbi, apbo(4), ahbmi, ahbmo(maxahbmsp-1));
    dsurx_pad : inpad GENERIC MAP (tech  => padtech) PORT MAP (ahbrxd, ahbuarti.rxd);
    dsutx_pad : outpad GENERIC MAP (tech => padtech) PORT MAP (ahbtxd, ahbuarto.txd);
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
-- AMBA BUS -------------------------------------------------------------------
-------------------------------------------------------------------------------

  -- APB --------------------------------------------------------------------
  apbi_ext   <= apbi;
  all_apb: FOR I IN 0 TO NB_APB_SLAVE-1 GENERATE
    max_16_apb: IF I + 5 < 16 GENERATE
      apbo(I+5)<= apbo_ext(I+5);
    END GENERATE max_16_apb;
  END GENERATE all_apb;
  -- AHB_Slave --------------------------------------------------------------
  ahbi_s_ext <= ahbsi;
  all_ahbs: FOR I IN 0 TO NB_AHB_SLAVE-1 GENERATE
    max_16_ahbs: IF I + 3 < 16 GENERATE
      ahbso(I+3) <= ahbo_s_ext(I+3);
    END GENERATE max_16_ahbs;
  END GENERATE all_ahbs;
  -- AHB_Master -------------------------------------------------------------
  ahbi_m_ext <= ahbmi;
  all_ahbm: FOR I IN 0 TO NB_AHB_MASTER-1 GENERATE
    max_16_ahbm: IF I + CFG_NCPU + CFG_AHB_UART < 16 GENERATE
      ahbmo(I + CFG_NCPU) <= ahbo_m_ext(I+CFG_NCPU);
    END GENERATE max_16_ahbm;
  END GENERATE all_ahbm;

  

END Behavioral;
