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
USE lpp.lpp_lfr_pkg.ALL;      -- contains lpp_lfr, not in the 206 rev of the VHD_Lib
USE lpp.lpp_top_lfr_pkg.ALL;            -- contains top_wf_picker
USE lpp.iir_filter.ALL;
USE lpp.general_purpose.ALL;
USE lpp.lpp_lfr_time_management.ALL;
USE lpp.lpp_leon3_soc_pkg.ALL;

ENTITY LFR_em IS
  
  PORT (
    clk100MHz    : IN STD_ULOGIC;                       
    clk49_152MHz : IN STD_ULOGIC;                       
    reset        : IN STD_ULOGIC;
                      
    -- TAG --------------------------------------------------------------------
    TAG1 : IN  STD_ULOGIC;            -- DSU rx data   
    TAG3 : OUT STD_ULOGIC;            -- DSU tx data  
    -- UART APB ---------------------------------------------------------------
    TAG2 : IN  STD_ULOGIC;            -- UART1 rx data 
    TAG4 : OUT STD_ULOGIC;            -- UART1 tx data   
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
    spw1_din  : IN  STD_LOGIC;                                  
    spw1_sin  : IN  STD_LOGIC;                                  
    spw1_dout : OUT STD_LOGIC;                                  
    spw1_sout : OUT STD_LOGIC;                           
    spw2_din  : IN  STD_LOGIC;                             
    spw2_sin  : IN  STD_LOGIC;                             
    spw2_dout : OUT STD_LOGIC;                             
    spw2_sout : OUT STD_LOGIC;                           
    -- ADC --------------------------------------------------------------------
    bias_fail_sw   : OUT STD_LOGIC;                     
    ADC_OEB_bar_CH : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    ADC_smpclk     : OUT STD_LOGIC;
    ADC_data       : IN  STD_LOGIC_VECTOR(13 DOWNTO 0);
    ---------------------------------------------------------------------------
    TAG8 : OUT STD_LOGIC;
    led : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)  
    );

END LFR_em;


ARCHITECTURE beh OF LFR_em IS
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
  SIGNAL sample      : Samples14v(7 DOWNTO 0);
  SIGNAL sample_s    : Samples(7 DOWNTO 0);
  SIGNAL sample_val  : STD_LOGIC;
  SIGNAL ADC_nCS_sig : STD_LOGIC;
  SIGNAL ADC_CLK_sig : STD_LOGIC;
  SIGNAL ADC_SDO_sig : STD_LOGIC_VECTOR(7 DOWNTO 0);
  
  -----------------------------------------------------------------------------
  SIGNAL observation_reg : STD_LOGIC_VECTOR(31 DOWNTO 0);

  -----------------------------------------------------------------------------
  SIGNAL rstn : STD_LOGIC;

  SIGNAL ADC_smpclk_s : STD_LOGIC;

BEGIN  -- beh

  -----------------------------------------------------------------------------
  -- CLK
  -----------------------------------------------------------------------------
  rst0 : rstgen PORT MAP (reset, clk_25, '1', rstn, OPEN);

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

  PROCESS (clk_25, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                 -- asynchronous reset (active low)
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
      NB_APB_SLAVE    => NB_APB_SLAVE)
    PORT MAP (
      clk       => clk_25,
      reset     => rstn,
      errorn    => OPEN,

      ahbrxd    => TAG1,
      ahbtxd    => TAG3,
      urxd1     => TAG2,
      utxd1     => TAG4,
      
      address   => address,
      data      => data,
      nSRAM_BE0 => nSRAM_BE0,
      nSRAM_BE1 => nSRAM_BE1,
      nSRAM_BE2 => nSRAM_BE2,
      nSRAM_BE3 => nSRAM_BE3,
      nSRAM_WE  => nSRAM_WE,
      nSRAM_CE  => nSRAM_CE,
      nSRAM_OE  => nSRAM_OE,

      apbi_ext   => apbi_ext,
      apbo_ext   => apbo_ext,
      ahbi_s_ext => ahbi_s_ext,
      ahbo_s_ext => ahbo_s_ext,
      ahbi_m_ext => ahbi_m_ext,
      ahbo_m_ext => ahbo_m_ext);


-------------------------------------------------------------------------------
-- APB_LFR_TIME_MANAGEMENT ----------------------------------------------------
-------------------------------------------------------------------------------
  apb_lfr_time_management_1 : apb_lfr_time_management
    GENERIC MAP (
      pindex => 6,
      paddr  => 6,
      pmask  => 16#fff#,
      FIRST_DIVISION   => 374, -- ((49.152/2) /2^16) - 1  = 375 - 1 = 374
      NB_SECOND_DESYNC => 60)  -- 60 secondes of desynchronization before CoarseTime's MSB is Set
    PORT MAP (
      clk25MHz     => clk_25,
      clk24_576MHz => clk_24,           -- 49.152MHz/2
      resetn       => rstn,
      grspw_tick   => swno.tickout,
      apbi         => apbi_ext,
      apbo         => apbo_ext(6),
      coarse_time  => coarse_time,
      fine_time    => fine_time);

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
    PORT MAP(rstn, clk_25, spw_rxclk(0),
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
  lpp_lfr_1 : lpp_lfr
    GENERIC MAP (
      Mem_use                => use_RAM,
      nb_data_by_buffer_size => 32,
      nb_word_by_buffer_size => 30,
      nb_snapshot_param_size => 32,
      delta_vector_size      => 32,
      delta_vector_size_f0_2 => 7,      -- log2(96)
      pindex                 => 15,
      paddr                  => 15,
      pmask                  => 16#fff#,
      pirq_ms                => 6,
      pirq_wfp               => 14,
      hindex                 => 2,
      top_lfr_version        => X"01011A")  -- aa.bb.cc version
                                            -- AA : BOARD NUMBER
                                            --      0 => MINI_LFR
                                            --      1 => EM
    PORT MAP (
      clk             => clk_25,
      rstn            => rstn,
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
      observation_vector_0 => OPEN,
      observation_vector_1 => OPEN,
      observation_reg => observation_reg);


  all_sample: FOR I IN 7 DOWNTO 0 GENERATE
    sample_s(I) <= sample(I) & '0' & '0';
  END GENERATE all_sample;
  
  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  top_ad_conv_RHF1401_withFilter_1: top_ad_conv_RHF1401_withFilter
    GENERIC MAP (
      ChanelCount     => 8,
      ncycle_cnv_high => 13,
      ncycle_cnv      => 25)
    PORT MAP (
      cnv_clk    => clk_24,         
      cnv_rstn   => rstn,           
      cnv        => ADC_smpclk_s,   
      clk        => clk_25,         
      rstn       => rstn,           
      ADC_data   => ADC_data,       
      ADC_nOE    => ADC_OEB_bar_CH, 
      sample     => sample,         
      sample_val => sample_val);    



  
  --top_ad_conv_RHF1401_1 : top_ad_conv_RHF1401
  --  GENERIC MAP (
  --    ChanelCount     => 8,
  --    ncycle_cnv_high => 40,            -- TODO : 79
  --    ncycle_cnv      => 250)           -- TODO : 500
  --  PORT MAP (
  --    cnv_clk    => clk_24,             -- TODO : 49.152
  --    cnv_rstn   => rstn,               -- ok
  --    cnv        => ADC_smpclk_s,         -- ok
  --    clk        => clk_25,             -- ok
  --    rstn       => rstn,               -- ok
  --    ADC_data   => ADC_data,           -- ok
  --    ADC_nOE    => ADC_OEB_bar_CH,     -- ok
  --    sample     => sample,             -- ok
  --    sample_val => sample_val);        -- ok
  
  ADC_smpclk <= ADC_smpclk_s;
  
  TAG8 <= ADC_smpclk_s;

END beh;
