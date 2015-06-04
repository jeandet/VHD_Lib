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
LIBRARY techmap;
USE techmap.gencomp.ALL;
LIBRARY gaisler;
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

ENTITY LFR_em IS
  
  PORT (
    clk100MHz    : IN STD_ULOGIC;
    clk49_152MHz : IN STD_ULOGIC;
    reset        : IN STD_ULOGIC;

    -- TAG --------------------------------------------------------------------
    TAG1           : IN    STD_ULOGIC;  -- DSU rx data   
    TAG3           : OUT   STD_ULOGIC;  -- DSU tx data  
    -- UART APB ---------------------------------------------------------------
    TAG2           : IN    STD_ULOGIC;  -- UART1 rx data 
    TAG4           : OUT   STD_ULOGIC;  -- UART1 tx data   
    -- RAM --------------------------------------------------------------------
    address        : OUT   STD_LOGIC_VECTOR(19 DOWNTO 0);
    data           : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    nSRAM_BE0      : OUT   STD_LOGIC;
    nSRAM_BE1      : OUT   STD_LOGIC;
    nSRAM_BE2      : OUT   STD_LOGIC;
    nSRAM_BE3      : OUT   STD_LOGIC;
    nSRAM_WE       : OUT   STD_LOGIC;
    nSRAM_CE       : OUT   STD_LOGIC;
    nSRAM_OE       : OUT   STD_LOGIC;
    -- SPW --------------------------------------------------------------------
    spw1_din       : IN    STD_LOGIC;
    spw1_sin       : IN    STD_LOGIC;
    spw1_dout      : OUT   STD_LOGIC;
    spw1_sout      : OUT   STD_LOGIC;
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
    HK_SEL         : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
    ---------------------------------------------------------------------------
    TAG8           : OUT   STD_LOGIC;
    led            : OUT   STD_LOGIC_VECTOR(2 DOWNTO 0)
    );

END LFR_em;


ARCHITECTURE beh OF LFR_em IS

--==========================================================================
--  USE_IAP_MEMCTRL allow to use the srctrle-0ws on MINILFR board
--  when enabled, chip enable polarity should be reversed and bank size also
--  MINILFR      -> 1 bank of 4MBytes   -> SRBANKSZ=9
--  LFR EQM & FM -> 2 banks of 2MBytes  -> SRBANKSZ=8
--==========================================================================
  CONSTANT USE_IAP_MEMCTRL : integer := 1;
--==========================================================================

  SIGNAL clk_50_s    : STD_LOGIC := '0';
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
  SIGNAL spw_rxtxclk : STD_ULOGIC;
  SIGNAL spw_rxclkn  : STD_ULOGIC;
  SIGNAL spw_clk     : STD_LOGIC;
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
  SIGNAL observation_reg : STD_LOGIC_VECTOR(31 DOWNTO 0);

  -----------------------------------------------------------------------------
  SIGNAL rstn_25 : STD_LOGIC;
  SIGNAL rstn_24 : STD_LOGIC;

  SIGNAL LFR_soft_rstn : STD_LOGIC;
  SIGNAL LFR_rstn      : STD_LOGIC;

  SIGNAL ADC_smpclk_s : STD_LOGIC;
  ----------------------------------------------------------------------------
  SIGNAL nSRAM_CE_s : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL nSRAM_READY : STD_LOGIC;

BEGIN  -- beh

  -----------------------------------------------------------------------------
  -- CLK
  -----------------------------------------------------------------------------
  rst_domain25 : rstgen PORT MAP (reset, clk_25, '1', rstn_25, OPEN);
  rst_domain24 : rstgen PORT MAP (reset, clk_24, '1', rstn_24, OPEN);

  PROCESS(clk100MHz)
  BEGIN
    IF clk100MHz'EVENT AND clk100MHz = '1' THEN
      clk_50_s <= NOT clk_50_s;
    END IF;
  END PROCESS;

  PROCESS(clk_50_s)
  BEGIN
    IF clk_50_s'EVENT AND clk_50_s = '1' THEN
      clk_25 <= NOT clk_25;
    END IF;
  END PROCESS;

  PROCESS(clk49_152MHz)
  BEGIN
    IF clk49_152MHz'EVENT AND clk49_152MHz = '1' THEN
      clk_24 <= NOT clk_24;
    END IF;
  END PROCESS;

  -----------------------------------------------------------------------------

  PROCESS (clk_25, rstn_25)
  BEGIN  -- PROCESS
    IF rstn_25 = '0' THEN                  -- asynchronous reset (active low)
      led(0) <= '0';
      led(1) <= '0';
      led(2) <= '0';
    ELSIF clk_25'EVENT AND clk_25 = '1' THEN  -- rising clock edge
      led(0) <= '0';
      led(1) <= '1';
      led(2) <= '1';
    END IF;
  END PROCESS;

  --
  leon3_soc_1 : leon3_soc
    GENERIC MAP (
      fabtech         => apa3e,
      memtech         => apa3e,
      padtech         => inferred,
      clktech         => inferred,
      disas           => 0,
      dbguart         => 0,
      pclow           => 2,
      clk_freq        => 25000,
      IS_RADHARD      => 0,
      NB_CPU          => 1,
      ENABLE_FPU      => 1,
      FPU_NETLIST     => 0,
      ENABLE_DSU      => 1,
      ENABLE_AHB_UART => 1,
      ENABLE_APB_UART => 1,
      ENABLE_IRQMP    => 1,
      ENABLE_GPT      => 1,
      NB_AHB_MASTER   => NB_AHB_MASTER,
      NB_AHB_SLAVE    => NB_AHB_SLAVE,
      NB_APB_SLAVE    => NB_APB_SLAVE,
      ADDRESS_SIZE    => 20,
      USES_IAP_MEMCTRLR => USE_IAP_MEMCTRL,
      BYPASS_EDAC_MEMCTRLR => '0',
      SRBANKSZ          => 9)
    PORT MAP (
      clk    => clk_25,
      reset  => rstn_25,
      errorn => OPEN,

      ahbrxd => TAG1,
      ahbtxd => TAG3,
      urxd1  => TAG2,
      utxd1  => TAG4,

      address   => address,
      data      => data,
      nSRAM_BE0 => nSRAM_BE0,
      nSRAM_BE1 => nSRAM_BE1,
      nSRAM_BE2 => nSRAM_BE2,
      nSRAM_BE3 => nSRAM_BE3,
      nSRAM_WE  => nSRAM_WE,
      nSRAM_CE  => nSRAM_CE_s,
      nSRAM_OE  => nSRAM_OE,
      nSRAM_READY => nSRAM_READY,
      SRAM_MBE    => '0',

      apbi_ext   => apbi_ext,
      apbo_ext   => apbo_ext,
      ahbi_s_ext => ahbi_s_ext,
      ahbo_s_ext => ahbo_s_ext,
      ahbi_m_ext => ahbi_m_ext,
      ahbo_m_ext => ahbo_m_ext);

  PROCESS (clk_25, rstn_25)
  BEGIN  -- PROCESS
    IF rstn_25 = '0' THEN               -- asynchronous reset (active low)
      nSRAM_READY <= '1';
    ELSIF clk_25'event AND clk_25 = '1' THEN  -- rising clock edge
      nSRAM_READY <= '1';
    END IF;
  END PROCESS;

  IAP:if USE_IAP_MEMCTRL = 1 GENERATE
    nSRAM_CE <= not nSRAM_CE_s(0);
  END GENERATE;

  NOIAP:if USE_IAP_MEMCTRL = 0 GENERATE
    nSRAM_CE <=  nSRAM_CE_s(0);
  END GENERATE;

-------------------------------------------------------------------------------
-- APB_LFR_TIME_MANAGEMENT ----------------------------------------------------
-------------------------------------------------------------------------------
  apb_lfr_management_1 : apb_lfr_management
    GENERIC MAP (
      tech             => apa3e,
      pindex           => 6,
      paddr            => 6,
      pmask            => 16#fff#,
--      FIRST_DIVISION   => 374,  -- ((49.152/2) /2^16) - 1  = 375 - 1 = 374
      NB_SECOND_DESYNC => 60)  -- 60 secondes of desynchronization before CoarseTime's MSB is Set
    PORT MAP (
      clk25MHz          => clk_25,
      resetn_25MHz      => rstn_25,      --      TODO
--      clk24_576MHz      => clk_24,          -- 49.152MHz/2
--      resetn_24_576MHz  => rstn_24,      --      TODO
   
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

--  SPW_EN <= '1';

  spw_clk     <= clk_50_s;
  spw_rxtxclk <= spw_clk;
  spw_rxclkn  <= NOT spw_rxtxclk;

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
        tech         => apa3e,
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
    tech         => apa3e,
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
    PORT MAP(rstn_25, clk_25, spw_rxclk(0),
             spw_rxclk(1), spw_rxtxclk, spw_rxtxclk,
             ahbi_m_ext, ahbo_m_ext(1), apbi_ext, apbo_ext(5),
             swni, swno);

  swni.tickin      <= '0';
  swni.rmapen      <= '1';
  swni.clkdiv10    <= "00000100";       -- 10 MHz / (4 + 1) = 10 MHz
  swni.tickinraw   <= '0';
  swni.timein      <= (OTHERS => '0');
  swni.dcrstval    <= (OTHERS => '0');
  swni.timerrstval <= (OTHERS => '0');

-------------------------------------------------------------------------------
-- LFR ------------------------------------------------------------------------
-------------------------------------------------------------------------------
  LFR_rstn <= LFR_soft_rstn AND rstn_25;

  lpp_lfr_1 : lpp_lfr
    GENERIC MAP (
      Mem_use                => use_RAM,
      tech                   => inferred,
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
      top_lfr_version        => X"010153",  -- aa.bb.cc version
                                            -- AA : BOARD NUMBER
                                            --      0 => MINI_LFR
                                            --      1 => EM
      DEBUG_FORCE_DATA_DMA  => 0)      
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
      debug_vector    => OPEN,
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

  ADC_OEB_bar_CH <= ADC_OEB_bar_CH_s(7 DOWNTO 0);
  
  ADC_smpclk <= ADC_smpclk_s;
  HK_smpclk  <= ADC_smpclk_s;

  TAG8 <= ADC_smpclk_s;

  -----------------------------------------------------------------------------
  -- HK
  -----------------------------------------------------------------------------
  ADC_OEB_bar_HK <= ADC_OEB_bar_CH_s(8);

END beh;
