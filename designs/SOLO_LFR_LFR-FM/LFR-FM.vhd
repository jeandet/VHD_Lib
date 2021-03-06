------------------------------------------------------------------------------
--  This file is a part of the LPP VHDL IP LIBRARY
--  Copyright (C) 2009 - 2010, Laboratory of Plasmas Physic - CNRS
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 3 of the License, or
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
-------------------------------------------------------------------------------
--                    Author : Jean-christophe Pellion
--                     Mail : jean-christophe.pellion@lpp.polytechnique.fr
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_1164.ALL;
LIBRARY grlib;
USE grlib.amba.ALL;
USE grlib.stdlib.ALL;
library axcelerator;
LIBRARY techmap;
USE techmap.gencomp.ALL;
USE techmap.axcomp.ALL;

LIBRARY gaisler;
USE gaisler.sim.ALL;
USE gaisler.memctrl.ALL;
USE gaisler.leon3.ALL;
USE gaisler.uart.ALL;
USE gaisler.misc.ALL;
USE gaisler.spacewire.ALL;
LIBRARY esa;
USE esa.memoryctrl.ALL;
LIBRARY lpp;
USE lpp.lpp_memory.ALL;
USE lpp.lpp_ad_conv.ALL;
USE lpp.lpp_lfr_pkg.ALL;  -- contains lpp_lfr, not in the 206 rev of the VHD_Lib
USE lpp.lpp_top_lfr_pkg.ALL;            -- contains top_wf_picker
USE lpp.iir_filter.ALL;
USE lpp.general_purpose.ALL;
USE lpp.lpp_lfr_management.ALL;
USE lpp.lpp_leon3_soc_pkg.ALL;



ENTITY LFR_FM IS
  GENERIC (
    Mem_use                : INTEGER := use_RAM;
    USE_BOOTLOADER         : INTEGER := 0;
    USE_ADCDRIVER          : INTEGER := 1;
    tech                   : INTEGER := inferred;
    tech_leon              : INTEGER := inferred;
    DEBUG_FORCE_DATA_DMA   : INTEGER := 0;
    USE_DEBUG_VECTOR       : INTEGER := 0
    );
  
  PORT (
    clk50MHz    : IN STD_ULOGIC;
    clk49_152MHz : IN STD_ULOGIC;
    reset        : IN STD_ULOGIC;

    TAG          : INOUT STD_LOGIC_VECTOR(9 DOWNTO 1);
    
    -- TAG --------------------------------------------------------------------
    --TAG1           : IN    STD_ULOGIC;  -- DSU rx data   
    --TAG3           : OUT   STD_ULOGIC;  -- DSU tx data  
    -- UART APB ---------------------------------------------------------------
    --TAG2           : IN    STD_ULOGIC;  -- UART1 rx data 
    --TAG4           : OUT   STD_ULOGIC;  -- UART1 tx data   
    -- RAM --------------------------------------------------------------------
    address        : OUT   STD_LOGIC_VECTOR(18 DOWNTO 0);
    data           : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    
    nSRAM_MBE      : INOUT   STD_LOGIC;   -- new
    nSRAM_E1       : OUT   STD_LOGIC;   -- new
    nSRAM_E2       : OUT   STD_LOGIC;   -- new
--    nSRAM_SCRUB    : OUT   STD_LOGIC;   -- new
    nSRAM_W        : OUT   STD_LOGIC;   -- new
    nSRAM_G        : OUT   STD_LOGIC;   -- new
    nSRAM_BUSY     : IN   STD_LOGIC;   -- new
    -- SPW --------------------------------------------------------------------
    spw1_en        : OUT   STD_LOGIC;   -- new
    spw1_din       : IN    STD_LOGIC;
    spw1_sin       : IN    STD_LOGIC;
    spw1_dout      : OUT   STD_LOGIC;
    spw1_sout      : OUT   STD_LOGIC;
    spw2_en        : OUT   STD_LOGIC;   -- new
    spw2_din       : IN    STD_LOGIC;
    spw2_sin       : IN    STD_LOGIC;
    spw2_dout      : OUT   STD_LOGIC;
    spw2_sout      : OUT   STD_LOGIC;
    -- ADC --------------------------------------------------------------------
    bias_fail_sw   : OUT   STD_LOGIC;
    ADC_OEB_bar_CH : OUT   STD_LOGIC_VECTOR(7 DOWNTO 0);
    ADC_smpclk     : OUT   STD_LOGIC;
    ADC_data       : IN    STD_LOGIC_VECTOR(13 DOWNTO 0);
    -- DAC --------------------------------------------------------------------
    DAC_SDO    : OUT STD_LOGIC;
    DAC_SCK    : OUT STD_LOGIC;
    DAC_SYNC   : OUT STD_LOGIC;
    DAC_CAL_EN : OUT STD_LOGIC;
    -- HK ---------------------------------------------------------------------
    HK_smpclk      : OUT   STD_LOGIC;
    ADC_OEB_bar_HK : OUT   STD_LOGIC;
    HK_SEL         : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0)
    );

END LFR_FM;


ARCHITECTURE beh OF LFR_FM IS
  
  SIGNAL clk_25_int  : STD_LOGIC := '0';
  SIGNAL clk_25      : STD_LOGIC := '0';
  SIGNAL clk_24      : STD_LOGIC := '0';
  -----------------------------------------------------------------------------
  SIGNAL coarse_time : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL fine_time   : STD_LOGIC_VECTOR(15 DOWNTO 0);

  -- CONSTANTS
  CONSTANT CFG_PADTECH   : INTEGER := inferred;
  CONSTANT NB_APB_SLAVE  : INTEGER := 11;  -- 3 = grspw + waveform picker + time manager, 11 allows pindex = f
  CONSTANT NB_AHB_SLAVE  : INTEGER := 1;
  CONSTANT NB_AHB_MASTER : INTEGER := 2;   -- 2 = grspw + waveform picker

  SIGNAL apbi_ext   : apb_slv_in_type;
  SIGNAL apbo_ext   : soc_apb_slv_out_vector(NB_APB_SLAVE-1+5 DOWNTO 5)  := (OTHERS => apb_none);
  SIGNAL ahbi_s_ext : ahb_slv_in_type;
  SIGNAL ahbo_s_ext : soc_ahb_slv_out_vector(NB_AHB_SLAVE-1+3 DOWNTO 3)  := (OTHERS => ahbs_none);
  SIGNAL ahbi_m_ext : AHB_Mst_In_Type;
  SIGNAL ahbo_m_ext : soc_ahb_mst_out_vector(NB_AHB_MASTER-1+1 DOWNTO 1) := (OTHERS => ahbm_none);

-- Spacewire signals
  SIGNAL dtmp        : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL stmp        : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL spw_rxclk   : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL swni        : grspw_in_type;
  SIGNAL swno        : grspw_out_type;

--GPIO
  SIGNAL gpioi : gpio_in_type;
  SIGNAL gpioo : gpio_out_type;

-- AD Converter ADS7886
  SIGNAL sample      : Samples14v(8 DOWNTO 0);
  SIGNAL sample_s    : Samples(8 DOWNTO 0);
  SIGNAL sample_val  : STD_LOGIC;
  SIGNAL  ADC_OEB_bar_CH_s : STD_LOGIC_VECTOR(8 DOWNTO 0);
  
  -----------------------------------------------------------------------------
  SIGNAL LFR_rstn_int  : STD_LOGIC := '0';
  SIGNAL rstn_25_int  : STD_LOGIC := '0';
  SIGNAL rstn_25 : STD_LOGIC;
  SIGNAL rstn_24 : STD_LOGIC;

  SIGNAL LFR_soft_rstn : STD_LOGIC;
  SIGNAL LFR_rstn      : STD_LOGIC;

  SIGNAL ADC_smpclk_s : STD_LOGIC;

  SIGNAL nSRAM_CE : STD_LOGIC_VECTOR(1 DOWNTO 0);
  
  SIGNAL clk50MHz_int : STD_LOGIC := '0';

  --component clkint port(A : in std_ulogic; Y :out std_ulogic); end component;
  --component hclkint port(A : in std_ulogic; Y :out std_ulogic); end component;

  SIGNAL rstn_50 : STD_LOGIC;
  SIGNAL clk_lock : STD_LOGIC;
  SIGNAL clk_busy_counter : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL nSRAM_BUSY_reg : STD_LOGIC;

  SIGNAL debug_vector : STD_LOGIC_VECTOR(11 DOWNTO 0);
  SIGNAL     ahbrxd: STD_LOGIC;
  SIGNAL     ahbtxd: STD_LOGIC;
  SIGNAL     urxd1 : STD_LOGIC;
  SIGNAL     utxd1 : STD_LOGIC;
BEGIN  -- beh

  -----------------------------------------------------------------------------
  -- CLK_LOCK
  -----------------------------------------------------------------------------
  rst_gen_global : rstgen PORT MAP (reset, clk50MHz, '1', rstn_50, OPEN);

  PROCESS (clk50MHz_int, rstn_50)
  BEGIN  -- PROCESS
    IF rstn_50 = '0' THEN         -- asynchronous reset (active low)
      clk_lock <= '0';
      clk_busy_counter <= (OTHERS => '0');
      nSRAM_BUSY_reg <= '0';
    ELSIF clk50MHz_int'event AND clk50MHz_int = '1' THEN  -- rising clock edge
      nSRAM_BUSY_reg <= nSRAM_BUSY;
      IF nSRAM_BUSY_reg = '1' AND nSRAM_BUSY = '0' THEN
        IF clk_busy_counter = "1111"  THEN
          clk_lock <= '1';
        ELSE
          clk_busy_counter <= STD_LOGIC_VECTOR(to_unsigned(to_integer(UNSIGNED(clk_busy_counter))+1,4));
        END IF;
      END IF;
    END IF;
  END PROCESS;
  
  -----------------------------------------------------------------------------
  -- CLK
  -----------------------------------------------------------------------------
  rst_domain25 : rstgen PORT MAP (reset, clk_25, clk_lock, rstn_25_int, OPEN);
  rst_domain24 : rstgen PORT MAP (reset, clk_24, clk_lock, rstn_24, OPEN);
  
  rstn_pad_25 : clkint port map (A => rstn_25_int, Y => rstn_25 ); 

  --clk_pad : clkint  port map (A => clk50MHz, Y => clk50MHz_int ); 
  clk50MHz_int <= clk50MHz;

  PROCESS(clk50MHz_int)
  BEGIN
    IF clk50MHz_int'EVENT AND clk50MHz_int = '1' THEN
      clk_25_int <= NOT clk_25_int;
      --clk_25 <= NOT clk_25;
    END IF;
  END PROCESS;
  clk_pad_25 : hclkint port map (A => clk_25_int, Y => clk_25 ); 

  PROCESS(clk49_152MHz)
  BEGIN
    IF clk49_152MHz'EVENT AND clk49_152MHz = '1' THEN
      clk_24 <= NOT clk_24;
    END IF;
  END PROCESS;
--  clk_49 <= clk49_152MHz;

  -----------------------------------------------------------------------------
  leon3_soc_1 : leon3_soc
    GENERIC MAP (
      fabtech         => axcel,--inferred,--axdsp,
      memtech         => axcel,--inferred,--tech_leon,
      padtech         => axcel,--inferred,
      clktech         => axcel,--inferred,
      disas           => 0,
      dbguart         => 0,
      pclow           => 2,
      clk_freq        => 25000,
      IS_RADHARD      => 1,
      NB_CPU          => 1,
      ENABLE_FPU      => 1,
      FPU_NETLIST     => 0,
      ENABLE_DSU      => 1,
      ENABLE_AHB_UART => 0,
      ENABLE_APB_UART => 1,
      ENABLE_IRQMP    => 1,
      ENABLE_GPT      => 1,
      NB_AHB_MASTER   => NB_AHB_MASTER,
      NB_AHB_SLAVE    => NB_AHB_SLAVE,
      NB_APB_SLAVE    => NB_APB_SLAVE,
      ADDRESS_SIZE    => 19,
      USES_IAP_MEMCTRLR => 1,
      USES_MBE_PIN      => 1,
      BYPASS_EDAC_MEMCTRLR => '0',
      SRBANKSZ          => 8)
    PORT MAP (
      clk    => clk_25,
      reset  => rstn_25,
      errorn => OPEN,

      ahbrxd => ahbrxd,                   -- INPUT
      ahbtxd => ahbtxd,                   -- OUTPUT
      urxd1  => urxd1,                   -- INPUT
      utxd1  => utxd1,                   -- OUTPUT

      address   => address,
      data      => data,
      nSRAM_BE0 => OPEN,
      nSRAM_BE1 => OPEN,
      nSRAM_BE2 => OPEN,
      nSRAM_BE3 => OPEN,
      nSRAM_WE  => nSRAM_W,
      nSRAM_CE  => nSRAM_CE,
      nSRAM_OE  => nSRAM_G,
      nSRAM_READY => nSRAM_BUSY,
      SRAM_MBE    => nSRAM_MBE,

      apbi_ext   => apbi_ext,
      apbo_ext   => apbo_ext,
      ahbi_s_ext => ahbi_s_ext,
      ahbo_s_ext => ahbo_s_ext,
      ahbi_m_ext => ahbi_m_ext,
      ahbo_m_ext => ahbo_m_ext);


  nSRAM_E1 <= nSRAM_CE(0);
  nSRAM_E2 <= nSRAM_CE(1);

-------------------------------------------------------------------------------
-- APB_LFR_TIME_MANAGEMENT ----------------------------------------------------
-------------------------------------------------------------------------------
  apb_lfr_management_1 : apb_lfr_management
    GENERIC MAP (
      tech             => tech,
      pindex           => 6,
      paddr            => 6,
      pmask            => 16#fff#,
      --FIRST_DIVISION   => 374,  -- ((49.152/2) /2^16) - 1  = 375 - 1 = 374
      NB_SECOND_DESYNC => 60)  -- 60 secondes of desynchronization before CoarseTime's MSB is Set
    PORT MAP (
      clk25MHz          => clk_25,
      resetn_25MHz      => rstn_25,      --      TODO
      --clk24_576MHz      => clk_24,          -- 49.152MHz/2
      --resetn_24_576MHz  => rstn_24,      --      TODO
      
      grspw_tick    => swno.tickout,
      apbi          => apbi_ext,
      apbo          => apbo_ext(6),
      
      HK_sample     => sample_s(8),
      HK_val        => sample_val,
      HK_sel        => HK_SEL, 
      
      DAC_SDO           => DAC_SDO,
      DAC_SCK            => DAC_SCK,
      DAC_SYNC          => DAC_SYNC,
      DAC_CAL_EN        => DAC_CAL_EN,     

      coarse_time   => coarse_time,
      fine_time     => fine_time,
      LFR_soft_rstn => LFR_soft_rstn
      );

-----------------------------------------------------------------------
---  SpaceWire --------------------------------------------------------
-----------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- \/\/\/\/ TODO : spacewire enable should be controled by the SPW IP \/\/\/\/
  ------------------------------------------------------------------------------
  spw1_en   <= '1';
  spw2_en   <= '1';
  ------------------------------------------------------------------------------
  -- /\/\/\/\ --------------------------------------------------------- /\/\/\/\
  ------------------------------------------------------------------------------
  
  --spw_clk     <= clk50MHz;
  --spw_rxtxclk <= spw_clk;
  --spw_rxclkn  <= NOT spw_rxtxclk;

  -- PADS for SPW1
  spw1_rxd_pad : inpad GENERIC MAP (tech => inferred)
    PORT MAP (spw1_din, dtmp(0));
  spw1_rxs_pad : inpad GENERIC MAP (tech => inferred)
    PORT MAP (spw1_sin, stmp(0));
  spw1_txd_pad : outpad GENERIC MAP (tech => inferred)
    PORT MAP (spw1_dout, swno.d(0));
  spw1_txs_pad : outpad GENERIC MAP (tech => inferred)
    PORT MAP (spw1_sout, swno.s(0));
  -- PADS FOR SPW2
  spw2_rxd_pad : inpad GENERIC MAP (tech => inferred)  -- bad naming of the MINI-LFR /!\
    PORT MAP (spw2_din, dtmp(1));
  spw2_rxs_pad : inpad GENERIC MAP (tech => inferred)  -- bad naming of the MINI-LFR /!\
    PORT MAP (spw2_sin, stmp(1));
  spw2_txd_pad : outpad GENERIC MAP (tech => inferred)
    PORT MAP (spw2_dout, swno.d(1));
  spw2_txs_pad : outpad GENERIC MAP (tech => inferred)
    PORT MAP (spw2_sout, swno.s(1));

  -- GRSPW PHY
  --spw1_input: if CFG_SPW_GRSPW = 1 generate
  spw_inputloop : FOR j IN 0 TO 1 GENERATE
    spw_phy0 : grspw_phy
      GENERIC MAP(
        tech         => axcel,-- inferred,--axdsp,--tech_leon,
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
  sw0 : grspwm GENERIC MAP(
    tech         => axcel,--inferred,--axdsp,--tech_leon,
    hindex       => 1,
    pindex       => 5,
    paddr        => 5,
    pirq         => 11,
    sysfreq      => 25000,              -- CPU_FREQ
    rmap         => 1,
    rmapcrc      => 1,
    fifosize1    => 16,
    fifosize2    => 16,
    rxclkbuftype => 1,
    rxunaligned  => 0,
    rmapbufs     => 4,
    ft           => 1,
    netlist      => 0,
    ports        => 2,
    --dmachan => CFG_SPW_DMACHAN, -- not used byt the spw core 1
    memtech      => axcel,--inferred,--tech_leon,
    destkey      => 2,
    spwcore      => 1
    --input_type => CFG_SPW_INPUT, -- not used byt the spw core 1
    --output_type => CFG_SPW_OUTPUT,  -- not used byt the spw core 1
    --rxtx_sameclk => CFG_SPW_RTSAME -- not used byt the spw core 1
    )
    PORT MAP(rstn_25, clk_25, spw_rxclk(0),
             spw_rxclk(1),
             clk50MHz_int,
             clk50MHz_int,
--             spw_rxtxclk, spw_rxtxclk, spw_rxtxclk, spw_rxtxclk,
             ahbi_m_ext, ahbo_m_ext(1), apbi_ext, apbo_ext(5),
             swni, swno);

  swni.tickin      <= '0';
  swni.rmapen      <= '1';
  swni.clkdiv10    <= "00000100";       -- 50 MHz / (4 + 1) = 10 MHz
  swni.tickinraw   <= '0';
  swni.timein      <= (OTHERS => '0');
  swni.dcrstval    <= (OTHERS => '0');
  swni.timerrstval <= (OTHERS => '0');

-------------------------------------------------------------------------------
-- LFR ------------------------------------------------------------------------
-------------------------------------------------------------------------------
  --rst_domain25_lfr : rstgen PORT MAP (LFR_soft_rstn, clk_25, clk_lock, LFR_rstn, OPEN);
  LFR_rstn_int <= LFR_soft_rstn AND rstn_25_int;
  
  rstn_pad_lfr : clkint port map (A => LFR_rstn_int, Y => LFR_rstn ); 

  lpp_lfr_1 : lpp_lfr
    GENERIC MAP (
      Mem_use                => Mem_use,
      tech                   => inferred,--tech,
      nb_data_by_buffer_size => 32,
      --nb_word_by_buffer_size => 30,
      nb_snapshot_param_size => 32,
      delta_vector_size      => 32,
      delta_vector_size_f0_2 => 7,          -- log2(96)
      pindex                 => 15,
      paddr                  => 15,
      pmask                  => 16#fff#,
      pirq_ms                => 6,
      pirq_wfp               => 14,
      hindex                 => 2,
      top_lfr_version        => LPP_LFR_BOARD_LFR_FM & X"015B",
      DEBUG_FORCE_DATA_DMA        => DEBUG_FORCE_DATA_DMA,
      RTL_DESIGN_LIGHT            =>0,
      WINDOWS_HAANNING_PARAM_SIZE => 15,
      DATA_SHAPING_SATURATION     => 1)
    PORT MAP (
      clk             => clk_25,
      rstn            => LFR_rstn,
      sample_B        => sample_s(2 DOWNTO 0),
      sample_E        => sample_s(7 DOWNTO 3),
      sample_val      => sample_val,
      apbi            => apbi_ext,
      apbo            => apbo_ext(15),
      ahbi            => ahbi_m_ext,
      ahbo            => ahbo_m_ext(2),
      coarse_time     => coarse_time,
      fine_time       => fine_time,
      data_shaping_BW => bias_fail_sw,
      debug_vector    => debug_vector,
      debug_vector_ms => OPEN);     --,
  --observation_vector_0 => OPEN,
  --observation_vector_1 => OPEN,
  --observation_reg => observation_reg);


  all_sample : FOR I IN 7 DOWNTO 0 GENERATE
    sample_s(I) <= sample(I) & '0' & '0';
  END GENERATE all_sample;
  sample_s(8) <= sample(8)(13) & sample(8)(13) & sample(8);

  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  USE_ADCDRIVER_true: IF USE_ADCDRIVER = 1 GENERATE
    top_ad_conv_RHF1401_withFilter_1 : top_ad_conv_RHF1401_withFilter
      GENERIC MAP (
        ChanelCount     => 9,
        ncycle_cnv_high => 12,
        ncycle_cnv      => 25,
        FILTER_ENABLED  => 16#FF#)
      PORT MAP (
        cnv_clk    => clk_24,
        cnv_rstn   => rstn_24,
        cnv        => ADC_smpclk_s,
        clk        => clk_25,
        rstn       => rstn_25,
        ADC_data   => ADC_data,
        ADC_nOE    => ADC_OEB_bar_CH_s,
        sample     => sample,
        sample_val => sample_val);    
    
  END GENERATE USE_ADCDRIVER_true;
  
  USE_ADCDRIVER_false: IF USE_ADCDRIVER = 0 GENERATE
    top_ad_conv_RHF1401_withFilter_1 : top_ad_conv_RHF1401_withFilter
      GENERIC MAP (
        ChanelCount     => 9,
        ncycle_cnv_high => 25,
        ncycle_cnv      => 50,
        FILTER_ENABLED  => 16#FF#)
      PORT MAP (
        cnv_clk    => clk_24,
        cnv_rstn   => rstn_24,
        cnv        => ADC_smpclk_s,
        clk        => clk_25,
        rstn       => rstn_25,
        ADC_data   => ADC_data,
        ADC_nOE    => OPEN,
        sample     => OPEN,
        sample_val => sample_val);
    
    ADC_OEB_bar_CH_s(8 DOWNTO 0) <= (OTHERS => '1');

    all_sample: FOR I IN 8 DOWNTO 0 GENERATE
      ramp_generator_1: ramp_generator
        GENERIC MAP (
          DATA_SIZE           => 14,
          VALUE_UNSIGNED_INIT => 2**I,
          VALUE_UNSIGNED_INCR => 0,
          VALUE_UNSIGNED_MASK => 16#3FFF#)
        PORT MAP (
          clk         => clk_25,
          rstn        => rstn_25,
          new_data    => sample_val,
          output_data => sample(I) );
    END GENERATE all_sample;
    
    
  END GENERATE USE_ADCDRIVER_false;
  
  

  
  ADC_OEB_bar_CH <= ADC_OEB_bar_CH_s(7 DOWNTO 0);
  
  ADC_smpclk <= ADC_smpclk_s;
  HK_smpclk  <= ADC_smpclk_s;


  -----------------------------------------------------------------------------
  -- HK
  -----------------------------------------------------------------------------
  ADC_OEB_bar_HK <= ADC_OEB_bar_CH_s(8);

  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  --inst_bootloader: IF USE_BOOTLOADER = 1 GENERATE
  --  lpp_bootloader_1: lpp_bootloader
  --    GENERIC MAP (
  --      pindex => 13,
  --      paddr  => 13,
  --      pmask  => 16#fff#,
  --      hindex => 3,
  --      haddr  => 0,
  --      hmask  => 16#fff#)
  --    PORT MAP (
  --      HCLK    => clk_25,
  --      HRESETn => rstn_25,
  --      apbi    => apbi_ext,
  --      apbo    => apbo_ext(13),
  --      ahbsi   => ahbi_s_ext,
  --      ahbso   => ahbo_s_ext(3));
  --END GENERATE inst_bootloader;

  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  USE_DEBUG_VECTOR_IF: IF USE_DEBUG_VECTOR = 1 GENERATE
    PROCESS (clk_25, rstn_25)
    BEGIN  -- PROCESS
      IF rstn_25 = '0' THEN             -- asynchronous reset (active low)
        TAG <= (OTHERS => '0');
      ELSIF clk_25'event AND clk_25 = '1' THEN  -- rising clock edge
        TAG <= debug_vector(8 DOWNTO 2) & nSRAM_BUSY & debug_vector(0);
      END IF;
    END PROCESS;
    
    
  END GENERATE USE_DEBUG_VECTOR_IF;

  USE_DEBUG_VECTOR_IF2: IF USE_DEBUG_VECTOR = 0 GENERATE
    --ahbrxd <= TAG(1); -- AHB UART
    --TAG(3) <= ahbtxd;
    
    urxd1  <= TAG(2); -- APB UART
    TAG(4) <= utxd1;
    --TAG(8) <= nSRAM_BUSY;
  END GENERATE USE_DEBUG_VECTOR_IF2;
  
END beh;
