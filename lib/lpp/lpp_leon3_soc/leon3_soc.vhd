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
USE lpp.lpp_leon3_soc_pkg.ALL;
LIBRARY iap;
USE iap.memctrl.ALL;


ENTITY leon3_soc IS
  GENERIC (
    fabtech           : INTEGER := apa3e;
    memtech           : INTEGER := apa3e;
    padtech           : INTEGER := inferred;
    clktech           : INTEGER := inferred;
    disas             : INTEGER := 0;      -- Enable disassembly to console
    dbguart           : INTEGER := 0;      -- Print UART on console
    pclow             : INTEGER := 2;
    --
    clk_freq          : INTEGER := 25000;  --kHz
    --
    IS_RADHARD        : INTEGER := 0;
    --
    NB_CPU            : INTEGER := 1;
    ENABLE_FPU        : INTEGER := 1;
    FPU_NETLIST       : INTEGER := 1;
    ENABLE_DSU        : INTEGER := 1;
    ENABLE_AHB_UART   : INTEGER := 1;
    ENABLE_APB_UART   : INTEGER := 1;
    ENABLE_IRQMP      : INTEGER := 1;
    ENABLE_GPT        : INTEGER := 1;
    --
    NB_AHB_MASTER     : INTEGER := 1;
    NB_AHB_SLAVE      : INTEGER := 1;
    NB_APB_SLAVE      : INTEGER := 1;
    --
    ADDRESS_SIZE      : INTEGER := 20;
    USES_IAP_MEMCTRLR : INTEGER := 0;
    BYPASS_EDAC_MEMCTRLR : STD_LOGIC := '0';
    SRBANKSZ          : INTEGER := 8

    );
  PORT (
    clk   : IN STD_ULOGIC;
    reset : IN STD_ULOGIC;

    errorn : OUT STD_ULOGIC;

    -- UART AHB ---------------------------------------------------------------
    ahbrxd : IN  STD_ULOGIC;            -- DSU rx data  
    ahbtxd : OUT STD_ULOGIC;            -- DSU tx data

    -- UART APB ---------------------------------------------------------------
    urxd1 : IN  STD_ULOGIC;             -- UART1 rx data
    utxd1 : OUT STD_ULOGIC;             -- UART1 tx data    

    -- RAM --------------------------------------------------------------------
    address     : OUT   STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0);
    data        : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    nSRAM_BE0   : OUT   STD_LOGIC;
    nSRAM_BE1   : OUT   STD_LOGIC;
    nSRAM_BE2   : OUT   STD_LOGIC;
    nSRAM_BE3   : OUT   STD_LOGIC;
    nSRAM_WE    : OUT   STD_LOGIC;
    nSRAM_CE    : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
    nSRAM_OE    : OUT   STD_LOGIC;
    nSRAM_READY : IN    STD_LOGIC;
    SRAM_MBE    : INOUT STD_LOGIC;
    -- APB --------------------------------------------------------------------
    apbi_ext    : OUT   apb_slv_in_type;
    apbo_ext    : IN    soc_apb_slv_out_vector(NB_APB_SLAVE-1+5 DOWNTO 5);
    -- AHB_Slave --------------------------------------------------------------
    ahbi_s_ext  : OUT   ahb_slv_in_type;
    ahbo_s_ext  : IN    soc_ahb_slv_out_vector(NB_AHB_SLAVE-1+3 DOWNTO 3);
    -- AHB_Master -------------------------------------------------------------
    ahbi_m_ext  : OUT   AHB_Mst_In_Type;
    ahbo_m_ext  : IN    soc_ahb_mst_out_vector(NB_AHB_MASTER-1+NB_CPU DOWNTO NB_CPU)

    );
END;

ARCHITECTURE Behavioral OF leon3_soc IS

  -----------------------------------------------------------------------------
  -- CONFIG -------------------------------------------------------------------
  -----------------------------------------------------------------------------

  -- Clock generator
  CONSTANT CFG_CLKMUL    : INTEGER := (1);
  CONSTANT CFG_CLKDIV    : INTEGER := (1);  -- divide 50MHz by 2 to get 25MHz
  CONSTANT CFG_OCLKDIV   : INTEGER := (1);
  CONSTANT CFG_CLK_NOFB  : INTEGER := 0;
  -- LEON3 processor core
  CONSTANT CFG_LEON3     : INTEGER := 1;
  CONSTANT CFG_NCPU      : INTEGER := NB_CPU;
  CONSTANT CFG_NWIN      : INTEGER := (8);  -- to be compatible with BCC and RCC
  CONSTANT CFG_V8        : INTEGER := 0;
  CONSTANT CFG_MAC       : INTEGER := 0;
  CONSTANT CFG_SVT       : INTEGER := 0;
  CONSTANT CFG_RSTADDR   : INTEGER := 16#00000#;
  CONSTANT CFG_LDDEL     : INTEGER := (1);
  CONSTANT CFG_NWP       : INTEGER := (0);
  CONSTANT CFG_PWD       : INTEGER := 1*2;
  CONSTANT CFG_FPU       : INTEGER := ENABLE_FPU *(8 + 16 * FPU_NETLIST);
  -- 1*(8 + 16 * 0) => grfpu-light
  -- 1*(8 + 16 * 1) => netlist
  -- 0*(8 + 16 * 0) => No FPU
  -- 0*(8 + 16 * 1) => No FPU;
  CONSTANT CFG_ICEN      : INTEGER := 1;
  CONSTANT CFG_ISETS     : INTEGER := 1;
  CONSTANT CFG_ISETSZ    : INTEGER := 4;
  CONSTANT CFG_ILINE     : INTEGER := 4;
  CONSTANT CFG_IREPL     : INTEGER := 0;
  CONSTANT CFG_ILOCK     : INTEGER := 0;
  CONSTANT CFG_ILRAMEN   : INTEGER := 0;
  CONSTANT CFG_ILRAMADDR : INTEGER := 16#8E#;
  CONSTANT CFG_ILRAMSZ   : INTEGER := 1;
  CONSTANT CFG_DCEN      : INTEGER := 1;
  CONSTANT CFG_DSETS     : INTEGER := 1;
  CONSTANT CFG_DSETSZ    : INTEGER := 4;
  CONSTANT CFG_DLINE     : INTEGER := 4;
  CONSTANT CFG_DREPL     : INTEGER := 0;
  CONSTANT CFG_DLOCK     : INTEGER := 0;
  CONSTANT CFG_DSNOOP    : INTEGER := 0 + 0 + 4*0;
  CONSTANT CFG_DLRAMEN   : INTEGER := 0;
  CONSTANT CFG_DLRAMADDR : INTEGER := 16#8F#;
  CONSTANT CFG_DLRAMSZ   : INTEGER := 1;
  CONSTANT CFG_MMUEN     : INTEGER := 0;
  CONSTANT CFG_ITLBNUM   : INTEGER := 2;
  CONSTANT CFG_DTLBNUM   : INTEGER := 2;
  CONSTANT CFG_TLB_TYPE  : INTEGER := 1 + 0*2;
  CONSTANT CFG_TLB_REP   : INTEGER := 1;

  CONSTANT CFG_DSU   : INTEGER := ENABLE_DSU;
  CONSTANT CFG_ITBSZ : INTEGER := 0;
  CONSTANT CFG_ATBSZ : INTEGER := 0;

  -- AMBA settings
  CONSTANT CFG_DEFMST  : INTEGER := (0);
  CONSTANT CFG_RROBIN  : INTEGER := 1;
  CONSTANT CFG_SPLIT   : INTEGER := 0;
  CONSTANT CFG_AHBIO   : INTEGER := 16#FFF#;
  CONSTANT CFG_APBADDR : INTEGER := 16#800#;

  -- DSU UART
  CONSTANT CFG_AHB_UART : INTEGER := ENABLE_AHB_UART;

  -- LEON2 memory controller
  CONSTANT CFG_MCTRL_SDEN : INTEGER := 0;

  -- UART 1
  CONSTANT CFG_UART1_ENABLE : INTEGER := ENABLE_APB_UART;
  CONSTANT CFG_UART1_FIFO   : INTEGER := 1;

  -- LEON3 interrupt controller
  CONSTANT CFG_IRQ3_ENABLE : INTEGER := ENABLE_IRQMP;

  -- Modular timer
  CONSTANT CFG_GPT_ENABLE : INTEGER := ENABLE_GPT;
  CONSTANT CFG_GPT_NTIM   : INTEGER := (2);
  CONSTANT CFG_GPT_SW     : INTEGER := (8);
  CONSTANT CFG_GPT_TW     : INTEGER := (32);
  CONSTANT CFG_GPT_IRQ    : INTEGER := (8);
  CONSTANT CFG_GPT_SEPIRQ : INTEGER := 1;
  CONSTANT CFG_GPT_WDOGEN : INTEGER := 0;
  CONSTANT CFG_GPT_WDOG   : INTEGER := 16#0#;
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- SIGNALs
  -----------------------------------------------------------------------------
  CONSTANT maxahbmsp  : INTEGER            := CFG_NCPU + CFG_AHB_UART + NB_AHB_MASTER;
  -- CLK & RST --
  SIGNAL   clk2x      : STD_ULOGIC;
  SIGNAL   clkmn      : STD_ULOGIC;
  SIGNAL   clkm       : STD_ULOGIC;
  SIGNAL   rstn       : STD_ULOGIC;
  SIGNAL   rstraw     : STD_ULOGIC;
  SIGNAL   pciclk     : STD_ULOGIC;
  SIGNAL   sdclkl     : STD_ULOGIC;
  SIGNAL   cgi        : clkgen_in_type;
  SIGNAL   cgo        : clkgen_out_type;
  --- AHB / APB
  SIGNAL   apbi       : apb_slv_in_type;
  SIGNAL   apbo       : apb_slv_out_vector := (OTHERS => apb_none);
  SIGNAL   ahbsi      : ahb_slv_in_type;
  SIGNAL   ahbso      : ahb_slv_out_vector := (OTHERS => ahbs_none);
  SIGNAL   ahbmi      : ahb_mst_in_type;
  SIGNAL   ahbmo      : ahb_mst_out_vector := (OTHERS => ahbm_none);
  --UART
  SIGNAL   ahbuarti   : uart_in_type;
  SIGNAL   ahbuarto   : uart_out_type;
  SIGNAL   apbuarti   : uart_in_type;
  SIGNAL   apbuarto   : uart_out_type;
  --MEM CTRLR
  SIGNAL   memi       : memory_in_type;
  SIGNAL   memo       : memory_out_type;
  SIGNAL   wpo        : wprot_out_type;
  SIGNAL   sdo        : sdram_out_type;
  SIGNAL   mbe        : STD_LOGIC;      -- enable memory programming
  SIGNAL   mbe_drive  : STD_LOGIC;      -- drive the MBE memory signal
  SIGNAL   nSRAM_CE_s : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL   nSRAM_OE_s : STD_LOGIC;
  --IRQ
  SIGNAL   irqi       : irq_in_vector(0 TO CFG_NCPU-1);
  SIGNAL   irqo       : irq_out_vector(0 TO CFG_NCPU-1);
  --Timer
  SIGNAL   gpti       : gptimer_in_type;
  SIGNAL   gpto       : gptimer_out_type;
  --DSU
  SIGNAL   dbgi       : l3_debug_in_vector(0 TO CFG_NCPU-1);
  SIGNAL   dbgo       : l3_debug_out_vector(0 TO CFG_NCPU-1);
  SIGNAL   dsui       : dsu_in_type;
  SIGNAL   dsuo       : dsu_out_type;
  -----------------------------------------------------------------------------
  

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
      leon3_non_radhard : IF IS_RADHARD = 0 GENERATE
        u0 : ENTITY gaisler.leon3s                       -- LEON3 processor      
          GENERIC MAP (i, fabtech, memtech, CFG_NWIN, CFG_DSU, CFG_FPU, CFG_V8,
                       0, CFG_MAC, pclow, 0, CFG_NWP, CFG_ICEN, CFG_IREPL, CFG_ISETS, CFG_ILINE,
                       CFG_ISETSZ, CFG_ILOCK, CFG_DCEN, CFG_DREPL, CFG_DSETS, CFG_DLINE, CFG_DSETSZ,
                       CFG_DLOCK, CFG_DSNOOP, CFG_ILRAMEN, CFG_ILRAMSZ, CFG_ILRAMADDR, CFG_DLRAMEN,
                       CFG_DLRAMSZ, CFG_DLRAMADDR, CFG_MMUEN, CFG_ITLBNUM, CFG_DTLBNUM, CFG_TLB_TYPE, CFG_TLB_REP,
                       CFG_LDDEL, disas, CFG_ITBSZ, CFG_PWD, CFG_SVT, CFG_RSTADDR, CFG_NCPU-1)
          PORT MAP (clkm, rstn, ahbmi, ahbmo(i), ahbsi, ahbso,
                    irqi(i), irqo(i), dbgi(i), dbgo(i));
      END GENERATE leon3_non_radhard;
      
      leon3_radhard_i : IF IS_RADHARD = 1 GENERATE
        cpu : ENTITY gaisler.leon3ft
          GENERIC MAP (
            HINDEX     => i,  --: integer;             --CPU_HINDEX,
            FABTECH    => fabtech,        --CFG_TECH,
            MEMTECH    => memtech,        --CFG_TECH,
            NWINDOWS   => CFG_NWIN,       --CFG_NWIN,
            DSU        => CFG_DSU,        --condSel (HAS_DEBUG, 1, 0),
            FPU        => CFG_FPU,        --CFG_FPU,
            V8         => CFG_V8,         --CFG_V8,
            CP         => 0,              --CFG_CP,
            MAC        => CFG_MAC,        --CFG_MAC,
            PCLOW      => pclow,          --CFG_PCLOW,
            NOTAG      => 0,              --CFG_NOTAG,             
            NWP        => CFG_NWP,        --CFG_NWP,
            ICEN       => CFG_ICEN,       --CFG_ICEN,
            IREPL      => CFG_IREPL,      --CFG_IREPL,
            ISETS      => CFG_ISETS,      --CFG_ISETS,
            ILINESIZE  => CFG_ILINE,      --CFG_ILINE,
            ISETSIZE   => CFG_ISETSZ,     --CFG_ISETSZ,
            ISETLOCK   => CFG_ILOCK,      --CFG_ILOCK,
            DCEN       => CFG_DCEN,       --CFG_DCEN,
            DREPL      => CFG_DREPL,      --CFG_DREPL,
            DSETS      => CFG_DSETS,      --CFG_DSETS,
            DLINESIZE  => CFG_DLINE,      --CFG_DLINE,
            DSETSIZE   => CFG_DSETSZ,     --CFG_DSETSZ,
            DSETLOCK   => CFG_DLOCK,      --CFG_DLOCK,
            DSNOOP     => CFG_DSNOOP,     --CFG_DSNOOP,
            ILRAM      => CFG_ILRAMEN,    --CFG_ILRAMEN,
            ILRAMSIZE  => CFG_ILRAMSZ,    --CFG_ILRAMSZ,
            ILRAMSTART => CFG_ILRAMADDR,  --CFG_ILRAMADDR,
            DLRAM      => CFG_DLRAMEN,    --CFG_DLRAMEN,
            DLRAMSIZE  => CFG_DLRAMSZ,    --CFG_DLRAMSZ,
            DLRAMSTART => CFG_DLRAMADDR,  --CFG_DLRAMADDR,
            MMUEN      => CFG_MMUEN,      --CFG_MMUEN,
            ITLBNUM    => CFG_ITLBNUM,    --CFG_ITLBNUM,
            DTLBNUM    => CFG_DTLBNUM,    --CFG_DTLBNUM,
            TLB_TYPE   => CFG_TLB_TYPE,   --CFG_TLB_TYPE,
            TLB_REP    => CFG_TLB_REP,    --CFG_TLB_REP,
            LDDEL      => CFG_LDDEL,      --CFG_LDDEL,
            DISAS      => disas,          --condSel (SIM_ENABLED, 1, 0),
            TBUF       => CFG_ITBSZ,      --CFG_ITBSZ,
            PWD        => CFG_PWD,        --CFG_PWD,
            SVT        => CFG_SVT,        --CFG_SVT,
            RSTADDR    => CFG_RSTADDR,    --CFG_RSTADDR,
            SMP        => CFG_NCPU-1,     --CFG_NCPU-1,
            IUFT       => 2,  --: integer range 0 to 4;--CFG_IUFT_EN,
            FPFT       => 1,  --: integer range 0 to 4;--CFG_FPUFT_EN,
            CMFT       => 1,  --: integer range 0 to 1;--CFG_CACHE_FT_EN,
            IUINJ      => 0,  --: integer;             --CFG_RF_ERRINJ,
            CEINJ      => 0,  --: integer range 0 to 3;--CFG_CACHE_ERRINJ,
            CACHED     => 0,  --: integer;             --CFG_DFIXED,
            NETLIST    => 0,  --: integer;             --CFG_LEON3_NETLIST,            
            SCANTEST   => 0,  --: integer;             --CFG_SCANTEST,
            MMUPGSZ    => 0,  --: integer range 0 to 5;--CFG_MMU_PAGE,
            BP         => 1)              --CFG_BP
          PORT MAP (                      --
            rstn  => rstn,                --rst_n,
            clk   => clkm,                --clk,
            ahbi  => ahbmi,               --ahbmi,
            ahbo  => ahbmo(i),             --ahbmo(CPU_HINDEX),
            ahbsi => ahbsi,               --ahbsi,
            ahbso => ahbso,               --ahbso,
            irqi  => irqi(i),             --irqi(CPU_HINDEX),
            irqo  => irqo(i),             --irqo(CPU_HINDEX),
            dbgi  => dbgi(i),             --dbgi(CPU_HINDEX),
            dbgo  => dbgo(i),             --dbgo(CPU_HINDEX),
            gclk  => clkm                 --clk
            );      
      END GENERATE leon3_radhard_i;

    END GENERATE;
    errorn_pad : outpad GENERIC MAP (tech => padtech) PORT MAP (errorn, dbgo(0).error);

    dsugen : IF CFG_DSU = 1 GENERATE
      dsu0 : dsu3                       -- LEON3 Debug Support Unit
        GENERIC MAP (hindex => 0,       --      TODO : hindex => 2
                     haddr => 16#900#, hmask => 16#F00#,
                     ncpu   => CFG_NCPU, tbits => 30, tech => memtech,
                     irq => 0, kbytes => CFG_ATBSZ)
        PORT MAP (rstn, clkm, ahbmi, ahbsi, ahbso(0),--      TODO :ahbso(2)
                  dbgo, dbgi, dsui, dsuo);
      dsui.enable <= '1';
      dsui.break  <= '0';
    END GENERATE;
  END GENERATE;

  nodsu : IF CFG_DSU = 0 GENERATE
    ahbso(2)    <= ahbs_none;
    dsuo.tstop  <= '0';
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
  ESAMEMCT : IF USES_IAP_MEMCTRLR = 0 GENERATE
    memctrlr : mctrl GENERIC MAP (
      hindex  => 0,
      pindex  => 0,
      paddr   => 0,
      srbanks => 1
      )
      PORT MAP (rstn, clkm, memi, memo, ahbsi, ahbso(0), apbi, apbo(0), wpo, sdo);
    memi.bexcn <= '1';
    memi.brdyn <= '1';

    nSRAM_CE_s <= NOT (memo.ramsn(1 DOWNTO 0));
    nSRAM_OE_s <= memo.ramoen(0);
  END GENERATE;

  IAPMEMCT : IF USES_IAP_MEMCTRLR = 1 GENERATE
    memctrlr : srctrle_0ws
      GENERIC MAP(
        hindex   => 2,                  -- TODO : hindex   => 0
        pindex   => 0,
        paddr    => 0,
        srbanks  => 2,
        banksz   => SRBANKSZ,                  --512k * 32
        rmw      => 1,
        --Aeroflex memory generics:
        mbpbusy  => BYPASS_EDAC_MEMCTRLR,
        mprog    => 1,          -- program memory by default values after reset
        mpsrate  => 15,                 -- default scrub rate period
        mpb2s    => 14,                  -- default busy to scrub delay
        mpapb    => 1,                  -- instantiate apb register
        mchipcnt => 2,
        mpenall  => 1  -- when 0 program only E1 chip, else program all dies
        )
      PORT MAP (
        rst       => rstn,
        clk       => clkm,
        ahbsi     => ahbsi,
        ahbso     => ahbso(2),          -- TODO :ahbso(0),
        apbi      => apbi,
        apbo      => apbo(0),
        sri       => memi,
        sro       => memo,
        --Aeroflex memory signals:
        ucerr     => OPEN,              -- uncorrectable error signal
        mbe       => mbe,               -- enable memory programming
        mbe_drive => mbe_drive          -- drive the MBE memory signal
        );

    memi.brdyn <= nSRAM_READY;

    mbe_pad : iopad
      GENERIC MAP(tech => padtech, oepol => USES_IAP_MEMCTRLR)
      PORT MAP(pad => SRAM_MBE,
               i   => mbe,
               en  => mbe_drive,
               o   => memi.bexcn);

    nSRAM_CE_s <= (memo.ramsn(1 DOWNTO 0));
    nSRAM_OE_s <= memo.oen;
    
  END GENERATE;


  memi.writen <= '1';
  memi.wrn    <= "1111";
  memi.bwidth <= "10";

  bdr : FOR i IN 0 TO 3 GENERATE
    data_pad : iopadv GENERIC MAP (tech => padtech, width => 8, oepol => USES_IAP_MEMCTRLR)
      PORT MAP (
        data(31-i*8 DOWNTO 24-i*8),
        memo.data(31-i*8 DOWNTO 24-i*8),
        memo.bdrive(i),
        memi.data(31-i*8 DOWNTO 24-i*8));
  END GENERATE;

  addr_pad : outpadv GENERIC MAP (width => ADDRESS_SIZE, tech => padtech)
    PORT MAP (address, memo.address(ADDRESS_SIZE+1 DOWNTO 2));
  rams_pad : outpadv GENERIC MAP (tech => padtech, width => 2) PORT MAP (nSRAM_CE, nSRAM_CE_s);
  oen_pad  : outpad GENERIC MAP (tech  => padtech) PORT MAP (nSRAM_OE, nSRAM_OE_s);
  nBWE_pad : outpad GENERIC MAP (tech  => padtech) PORT MAP (nSRAM_WE, memo.writen);
  nBWa_pad : outpad GENERIC MAP (tech  => padtech) PORT MAP (nSRAM_BE0, memo.mben(3));
  nBWb_pad : outpad GENERIC MAP (tech  => padtech) PORT MAP (nSRAM_BE1, memo.mben(2));
  nBWc_pad : outpad GENERIC MAP (tech  => padtech) PORT MAP (nSRAM_BE2, memo.mben(1));
  nBWd_pad : outpad GENERIC MAP (tech  => padtech) PORT MAP (nSRAM_BE3, memo.mben(0));



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
  apbi_ext <= apbi;
  all_apb : FOR I IN 0 TO NB_APB_SLAVE-1 GENERATE
    max_16_apb : IF I + 5 < 16 GENERATE
      apbo(I+5) <= apbo_ext(I+5);
    END GENERATE max_16_apb;
  END GENERATE all_apb;
  -- AHB_Slave --------------------------------------------------------------
  ahbi_s_ext <= ahbsi;
  all_ahbs : FOR I IN 0 TO NB_AHB_SLAVE-1 GENERATE
    max_16_ahbs : IF I + 3 < 16 GENERATE
      ahbso(I+3) <= ahbo_s_ext(I+3);
    END GENERATE max_16_ahbs;
  END GENERATE all_ahbs;
  -- AHB_Master -------------------------------------------------------------
  ahbi_m_ext <= ahbmi;
  all_ahbm : FOR I IN 0 TO NB_AHB_MASTER-1 GENERATE
    max_16_ahbm : IF I + CFG_NCPU + CFG_AHB_UART < 16 GENERATE
      ahbmo(I + CFG_NCPU) <= ahbo_m_ext(I+CFG_NCPU);
    END GENERATE max_16_ahbm;
  END GENERATE all_ahbm;

  

END Behavioral;
