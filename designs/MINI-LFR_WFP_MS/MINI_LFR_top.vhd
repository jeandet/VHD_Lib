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

ENTITY MINI_LFR_top IS
  
  PORT (
    clk_50 : IN  STD_LOGIC;
    clk_49 : IN  STD_LOGIC;
    reset  : IN  STD_LOGIC;
    --BPs
    BP0    : IN  STD_LOGIC;
    BP1    : IN  STD_LOGIC;
    --LEDs
    LED0   : OUT STD_LOGIC;
    LED1   : OUT STD_LOGIC;
    LED2   : OUT STD_LOGIC;
    --UARTs
    TXD1   : IN  STD_LOGIC;
    RXD1   : OUT STD_LOGIC;
    nCTS1  : OUT STD_LOGIC;
    nRTS1  : IN  STD_LOGIC;

    TXD2  : IN  STD_LOGIC;
    RXD2  : OUT STD_LOGIC;
    nCTS2 : OUT STD_LOGIC;
    nDTR2 : IN  STD_LOGIC;
    nRTS2 : IN  STD_LOGIC;
    nDCD2 : OUT STD_LOGIC;

    --EXT CONNECTOR
    IO0  : INOUT STD_LOGIC;
    IO1  : INOUT STD_LOGIC;
    IO2  : INOUT STD_LOGIC;
    IO3  : INOUT STD_LOGIC;
    IO4  : INOUT STD_LOGIC;
    IO5  : INOUT STD_LOGIC;
    IO6  : INOUT STD_LOGIC;
    IO7  : INOUT STD_LOGIC;
    IO8  : INOUT STD_LOGIC;
    IO9  : INOUT STD_LOGIC;
    IO10 : INOUT STD_LOGIC;
    IO11 : INOUT STD_LOGIC;

    --SPACE WIRE
    SPW_EN       : OUT STD_LOGIC;       -- 0 => off
    SPW_NOM_DIN  : IN  STD_LOGIC;       -- NOMINAL LINK
    SPW_NOM_SIN  : IN  STD_LOGIC;
    SPW_NOM_DOUT : OUT STD_LOGIC;
    SPW_NOM_SOUT : OUT STD_LOGIC;
    SPW_RED_DIN  : IN  STD_LOGIC;       -- REDUNDANT LINK 
    SPW_RED_SIN  : IN  STD_LOGIC;
    SPW_RED_DOUT : OUT STD_LOGIC;
    SPW_RED_SOUT : OUT STD_LOGIC;
    -- MINI LFR ADC INPUTS
    ADC_nCS      : OUT STD_LOGIC;
    ADC_CLK      : OUT STD_LOGIC;
    ADC_SDO      : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);

    -- SRAM
    SRAM_nWE : OUT   STD_LOGIC;
    SRAM_CE  : OUT   STD_LOGIC;
    SRAM_nOE : OUT   STD_LOGIC;
    SRAM_nBE : OUT   STD_LOGIC_VECTOR(3 DOWNTO 0);
    SRAM_A   : OUT   STD_LOGIC_VECTOR(19 DOWNTO 0);
    SRAM_DQ  : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );

END MINI_LFR_top;


ARCHITECTURE beh OF MINI_LFR_top IS
  SIGNAL clk_50_s    : STD_LOGIC := '0';
  SIGNAL clk_25      : STD_LOGIC := '0';
  SIGNAL clk_24      : STD_LOGIC := '0';
  -----------------------------------------------------------------------------
  SIGNAL coarse_time : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL fine_time   : STD_LOGIC_VECTOR(15 DOWNTO 0);
  --
  SIGNAL errorn      : STD_LOGIC;
  -- UART AHB ---------------------------------------------------------------
--  SIGNAL ahbrxd      : STD_ULOGIC;      -- DSU rx data  
--  SIGNAL ahbtxd      : STD_ULOGIC;      -- DSU tx data

  -- UART APB ---------------------------------------------------------------
--  SIGNAL urxd1 : STD_ULOGIC;            -- UART1 rx data
--  SIGNAL utxd1 : STD_ULOGIC;            -- UART1 tx data
  --
  SIGNAL I00_s : STD_LOGIC;

  -- CONSTANTS
  CONSTANT CFG_PADTECH   : INTEGER := inferred;
  --
  CONSTANT NB_APB_SLAVE  : INTEGER := 11;  -- 3 = grspw + waveform picker + time manager, 11 allows pindex = f
  CONSTANT NB_AHB_SLAVE  : INTEGER := 1;
  CONSTANT NB_AHB_MASTER : INTEGER := 2;   -- 2 = grspw + waveform picker

  SIGNAL apbi_ext   : apb_slv_in_type;
  SIGNAL apbo_ext   : soc_apb_slv_out_vector(NB_APB_SLAVE-1+5 DOWNTO 5);  --  := (OTHERS => apb_none);
  SIGNAL ahbi_s_ext : ahb_slv_in_type;
  SIGNAL ahbo_s_ext : soc_ahb_slv_out_vector(NB_AHB_SLAVE-1+3 DOWNTO 3);  --  := (OTHERS => ahbs_none);
  SIGNAL ahbi_m_ext : AHB_Mst_In_Type;
  SIGNAL ahbo_m_ext : soc_ahb_mst_out_vector(NB_AHB_MASTER-1+1 DOWNTO 1);  -- := (OTHERS => ahbm_none);

-- Spacewire signals
  SIGNAL dtmp        : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL stmp        : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL spw_rxclk   : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL spw_rxtxclk : STD_ULOGIC;
  SIGNAL spw_rxclkn  : STD_ULOGIC;
  SIGNAL spw_clk     : STD_LOGIC;
  SIGNAL swni        : grspw_in_type;
  SIGNAL swno        : grspw_out_type;
--  SIGNAL clkmn                : STD_ULOGIC;
--  SIGNAL txclk                : STD_ULOGIC;

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

  SIGNAL bias_fail_sw_sig : STD_LOGIC;

  SIGNAL observation_reg      : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL observation_vector_0 : STD_LOGIC_VECTOR(11 DOWNTO 0);
  SIGNAL observation_vector_1 : STD_LOGIC_VECTOR(11 DOWNTO 0);
  -----------------------------------------------------------------------------

  SIGNAL LFR_soft_rstn : STD_LOGIC;
  SIGNAL LFR_rstn      : STD_LOGIC;


  SIGNAL rstn_25    : STD_LOGIC;
  SIGNAL rstn_25_d1 : STD_LOGIC;
  SIGNAL rstn_25_d2 : STD_LOGIC;
  SIGNAL rstn_25_d3 : STD_LOGIC;

  SIGNAL rstn_50    : STD_LOGIC;
  SIGNAL rstn_50_d1 : STD_LOGIC;
  SIGNAL rstn_50_d2 : STD_LOGIC;
  SIGNAL rstn_50_d3 : STD_LOGIC;

  SIGNAL lfr_debug_vector    : STD_LOGIC_VECTOR(11 DOWNTO 0);
  SIGNAL lfr_debug_vector_ms : STD_LOGIC_VECTOR(11 DOWNTO 0);

  --
  SIGNAL SRAM_CE_s : STD_LOGIC_VECTOR(1 DOWNTO 0);

  --
  SIGNAL sample_hk : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL HK_SEL    : STD_LOGIC_VECTOR( 1 DOWNTO 0);
  
BEGIN  -- beh

  -----------------------------------------------------------------------------
  -- CLK
  -----------------------------------------------------------------------------

  --PROCESS(clk_50)
  --BEGIN
  --  IF clk_50'EVENT AND clk_50 = '1' THEN
  --    clk_50_s <= NOT clk_50_s;
  --  END IF;
  --END PROCESS;

  --PROCESS(clk_50_s)
  --BEGIN
  --  IF clk_50_s'EVENT AND clk_50_s = '1' THEN
  --    clk_25 <= NOT clk_25;
  --  END IF;
  --END PROCESS;

  --PROCESS(clk_49)
  --BEGIN
  --  IF clk_49'EVENT AND clk_49 = '1' THEN
  --    clk_24 <= NOT clk_24;
  --  END IF;
  --END PROCESS;

  --PROCESS(clk_25)
  --BEGIN
  --  IF clk_25'EVENT AND clk_25 = '1' THEN
  --    rstn_25 <= reset;
  --  END IF;
  --END PROCESS;

  PROCESS (clk_50, reset)
  BEGIN  -- PROCESS
    IF reset = '0' THEN                 -- asynchronous reset (active low)
      clk_50_s   <= '0';
      rstn_50    <= '0';
      rstn_50_d1 <= '0';
      rstn_50_d2 <= '0';
      rstn_50_d3 <= '0';
      
    ELSIF clk_50'EVENT AND clk_50 = '1' THEN  -- rising clock edge
      clk_50_s   <= NOT clk_50_s;
      rstn_50_d1 <= '1';
      rstn_50_d2 <= rstn_50_d1;
      rstn_50_d3 <= rstn_50_d2;
      rstn_50    <= rstn_50_d3;
    END IF;
  END PROCESS;

  PROCESS (clk_50_s, rstn_50)
  BEGIN  -- PROCESS
    IF rstn_50 = '0' THEN               -- asynchronous reset (active low)
      clk_25     <= '0';
      rstn_25    <= '0';
      rstn_25_d1 <= '0';
      rstn_25_d2 <= '0';
      rstn_25_d3 <= '0';
    ELSIF clk_50_s'EVENT AND clk_50_s = '1' THEN  -- rising clock edge
      clk_25     <= NOT clk_25;
      rstn_25_d1 <= '1';
      rstn_25_d2 <= rstn_25_d1;
      rstn_25_d3 <= rstn_25_d2;
      rstn_25    <= rstn_25_d3;
    END IF;
  END PROCESS;

  PROCESS (clk_49, reset)
  BEGIN  -- PROCESS
    IF reset = '0' THEN                 -- asynchronous reset (active low)
      clk_24 <= '0';
    ELSIF clk_49'EVENT AND clk_49 = '1' THEN  -- rising clock edge
      clk_24 <= NOT clk_24;
    END IF;
  END PROCESS;

  -----------------------------------------------------------------------------

  PROCESS (clk_25, rstn_25)
  BEGIN  -- PROCESS
    IF rstn_25 = '0' THEN               -- asynchronous reset (active low)
      LED0 <= '0';
      LED1 <= '0';
      LED2 <= '0';
      --IO1  <= '0';
      --IO2  <= '1';  
      --IO3  <= '0';
      --IO4  <= '0';
      --IO5  <= '0';
      --IO6  <= '0';
      --IO7  <= '0';
      --IO8  <= '0';
      --IO9  <= '0';
      --IO10 <= '0';
      --IO11 <= '0';
    ELSIF clk_25'EVENT AND clk_25 = '1' THEN  -- rising clock edge
      LED0 <= '0';
      LED1 <= '1';
      LED2 <= BP0 OR BP1 OR nDTR2 OR nRTS2 OR nRTS1;
      --IO1  <= '1';
      --IO2  <= SPW_NOM_DIN OR SPW_NOM_SIN OR SPW_RED_DIN OR SPW_RED_SIN;  
      --IO3  <= ADC_SDO(0);
      --IO4  <= ADC_SDO(1);
      --IO5  <= ADC_SDO(2);
      --IO6  <= ADC_SDO(3);
      --IO7  <= ADC_SDO(4);
      --IO8  <= ADC_SDO(5);
      --IO9  <= ADC_SDO(6);
      --IO10 <= ADC_SDO(7);
      --IO11 <= BP1 OR nDTR2 OR nRTS2 OR nRTS1;
    END IF;
  END PROCESS;

  PROCESS (clk_24, rstn_25)
  BEGIN  -- PROCESS
    IF rstn_25 = '0' THEN               -- asynchronous reset (active low)
      I00_s <= '0';
    ELSIF clk_24'EVENT AND clk_24 = '1' THEN  -- rising clock edge
      I00_s <= NOT I00_s;
    END IF;
  END PROCESS;
--  IO0 <= I00_s;

  --UARTs
  nCTS1 <= '1';
  nCTS2 <= '1';
  nDCD2 <= '1';

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
      USES_IAP_MEMCTRLR => 0)
    PORT MAP (
      clk       => clk_25,
      reset     => rstn_25,
      errorn    => errorn,
      ahbrxd    => TXD1,
      ahbtxd    => RXD1,
      urxd1     => TXD2,
      utxd1     => RXD2,
      address   => SRAM_A,
      data      => SRAM_DQ,
      nSRAM_BE0 => SRAM_nBE(0),
      nSRAM_BE1 => SRAM_nBE(1),
      nSRAM_BE2 => SRAM_nBE(2),
      nSRAM_BE3 => SRAM_nBE(3),
      nSRAM_WE  => SRAM_nWE,
      nSRAM_CE  => SRAM_CE_s,
      nSRAM_OE  => SRAM_nOE,
      nSRAM_READY => '0',
      SRAM_MBE    => OPEN,
      apbi_ext   => apbi_ext,
      apbo_ext   => apbo_ext,
      ahbi_s_ext => ahbi_s_ext,
      ahbo_s_ext => ahbo_s_ext,
      ahbi_m_ext => ahbi_m_ext,
      ahbo_m_ext => ahbo_m_ext);

  SRAM_CE <= SRAM_CE_s(0);
-------------------------------------------------------------------------------
-- APB_LFR_MANAGEMENT ---------------------------------------------------------
-------------------------------------------------------------------------------
  apb_lfr_management_1 : apb_lfr_management
    GENERIC MAP (
      tech             => apa3e,
      pindex           => 6,
      paddr            => 6,
      pmask            => 16#fff#,
      FIRST_DIVISION   => 374,  -- ((49.152/2) /2^16) - 1  = 375 - 1 = 374
      NB_SECOND_DESYNC => 60)  -- 60 secondes of desynchronization before CoarseTime's MSB is Set
    PORT MAP (
      clk25MHz      => clk_25,
      clk24_576MHz  => clk_24,          -- 49.152MHz/2
      resetn        => rstn_25,
      grspw_tick    => swno.tickout,
      apbi          => apbi_ext,
      apbo          => apbo_ext(6),
      HK_sample     => sample_hk,
      HK_val        => sample_val,
      HK_sel        => HK_SEL,
      DAC_SDO       => OPEN,
      DAC_SCK       => OPEN,
      DAC_SYNC      => OPEN,
      DAC_CAL_EN    => OPEN,
      coarse_time   => coarse_time,
      fine_time     => fine_time,
      LFR_soft_rstn => LFR_soft_rstn
      );

-----------------------------------------------------------------------
---  SpaceWire --------------------------------------------------------
-----------------------------------------------------------------------

  SPW_EN <= '1';

  spw_clk     <= clk_50_s;
  spw_rxtxclk <= spw_clk;
  spw_rxclkn  <= NOT spw_rxtxclk;

  -- PADS for SPW1
  spw1_rxd_pad : inpad GENERIC MAP (tech => inferred)
    PORT MAP (SPW_NOM_DIN, dtmp(0));
  spw1_rxs_pad : inpad GENERIC MAP (tech => inferred)
    PORT MAP (SPW_NOM_SIN, stmp(0));
  spw1_txd_pad : outpad GENERIC MAP (tech => inferred)
    PORT MAP (SPW_NOM_DOUT, swno.d(0));
  spw1_txs_pad : outpad GENERIC MAP (tech => inferred)
    PORT MAP (SPW_NOM_SOUT, swno.s(0));
  -- PADS FOR SPW2
  spw2_rxd_pad : inpad GENERIC MAP (tech => inferred)  -- bad naming of the MINI-LFR /!\
    PORT MAP (SPW_RED_SIN, dtmp(1));
  spw2_rxs_pad : inpad GENERIC MAP (tech => inferred)  -- bad naming of the MINI-LFR /!\
    PORT MAP (SPW_RED_DIN, stmp(1));
  spw2_txd_pad : outpad GENERIC MAP (tech => inferred)
    PORT MAP (SPW_RED_DOUT, swno.d(1));
  spw2_txs_pad : outpad GENERIC MAP (tech => inferred)
    PORT MAP (SPW_RED_SOUT, swno.s(1));

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

  swni.rmapnodeaddr <= (OTHERS => '0');

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
  --LFR_rstn <= rstn_25;

  lpp_lfr_1 : lpp_lfr
    GENERIC MAP (
      Mem_use                => use_RAM,
      nb_data_by_buffer_size => 32,
      nb_snapshot_param_size => 32,
      delta_vector_size      => 32,
      delta_vector_size_f0_2 => 7,          -- log2(96)
      pindex                 => 15,
      paddr                  => 15,
      pmask                  => 16#fff#,
      pirq_ms                => 6,
      pirq_wfp               => 14,
      hindex                 => 2,
      top_lfr_version        => X"000142")  -- aa.bb.cc version
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
      data_shaping_BW => bias_fail_sw_sig,
      debug_vector    => lfr_debug_vector,
      debug_vector_ms => lfr_debug_vector_ms
      );

  observation_reg(11 DOWNTO 0)      <= lfr_debug_vector;
  observation_reg(31 DOWNTO 12)     <= (OTHERS => '0');
  observation_vector_0(11 DOWNTO 0) <= lfr_debug_vector;
  observation_vector_1(11 DOWNTO 0) <= lfr_debug_vector;
  IO0                               <= rstn_25;
  IO1                               <= lfr_debug_vector_ms(0);  -- LFR MS FFT data_valid
  IO2                               <= lfr_debug_vector_ms(0);  -- LFR MS FFT ready
  IO3                               <= lfr_debug_vector(0);  -- LFR APBREG error_buffer_full
  IO4                               <= lfr_debug_vector(1);  -- LFR APBREG reg_sp.status_error_buffer_full
  IO5                               <= lfr_debug_vector(8);  -- LFR APBREG  ready_matrix_f2
  IO6                               <= lfr_debug_vector(9);  -- LFR APBREG reg0_ready_matrix_f2
  IO7                               <= lfr_debug_vector(10);  -- LFR APBREG reg0_ready_matrix_f2

  all_sample : FOR I IN 7 DOWNTO 0 GENERATE
    sample_s(I) <= sample(I)(11 DOWNTO 0) & '0' & '0' & '0' & '0';
  END GENERATE all_sample;

  top_ad_conv_ADS7886_v2_1 : top_ad_conv_ADS7886_v2
    GENERIC MAP(
      ChannelCount    => 8,
      SampleNbBits    => 14,
      ncycle_cnv_high => 40,  -- at least 32 cycles at 25 MHz, 32 * 49.152 / 25 /2 = 31.5
      ncycle_cnv      => 249)           -- 49 152 000 / 98304 /2
    PORT MAP (
      -- CONV
      cnv_clk    => clk_24,
      cnv_rstn   => rstn_25,
      cnv        => ADC_nCS_sig,
      -- DATA
      clk        => clk_25,
      rstn       => rstn_25,
      sck        => ADC_CLK_sig,
      sdo        => ADC_SDO_sig,
      -- SAMPLE
      sample     => sample,
      sample_val => sample_val);

  --IO10 <= ADC_SDO_sig(5);
  --IO9  <= ADC_SDO_sig(4);
  --IO8  <= ADC_SDO_sig(3);

  ADC_nCS     <= ADC_nCS_sig;
  ADC_CLK     <= ADC_CLK_sig;
  ADC_SDO_sig <= ADC_SDO;

  sample_hk <= "0001000100010001" WHEN HK_SEL = "00" ELSE
               "0010001000100010" WHEN HK_SEL = "01" ELSE
               "0100010001000100" WHEN HK_SEL = "10" ELSE
               (OTHERS => '0');
  

----------------------------------------------------------------------
---  GPIO  -----------------------------------------------------------
----------------------------------------------------------------------

  grgpio0 : grgpio
    GENERIC MAP(pindex => 11, paddr => 11, imask => 16#0000#, nbits => 8)
    PORT MAP(rstn_25, clk_25, apbi_ext, apbo_ext(11), gpioi, gpioo);
  
  gpioi.sig_en <= (OTHERS => '0');
  gpioi.sig_in <= (OTHERS => '0');
  gpioi.din    <= (OTHERS => '0');
  --pio_pad_0 : iopad
  --  GENERIC MAP (tech => CFG_PADTECH)
  --  PORT MAP (IO0, gpioo.dout(0), gpioo.oen(0), gpioi.din(0));
  --pio_pad_1 : iopad
  --  GENERIC MAP (tech => CFG_PADTECH)
  --  PORT MAP (IO1, gpioo.dout(1), gpioo.oen(1), gpioi.din(1));
  --pio_pad_2 : iopad
  --  GENERIC MAP (tech => CFG_PADTECH)
  --  PORT MAP (IO2, gpioo.dout(2), gpioo.oen(2), gpioi.din(2));
  --pio_pad_3 : iopad
  --  GENERIC MAP (tech => CFG_PADTECH)
  --  PORT MAP (IO3, gpioo.dout(3), gpioo.oen(3), gpioi.din(3));
  --pio_pad_4 : iopad
  --  GENERIC MAP (tech => CFG_PADTECH)
  --  PORT MAP (IO4, gpioo.dout(4), gpioo.oen(4), gpioi.din(4));
  --pio_pad_5 : iopad
  --  GENERIC MAP (tech => CFG_PADTECH)
  --  PORT MAP (IO5, gpioo.dout(5), gpioo.oen(5), gpioi.din(5));
  --pio_pad_6 : iopad
  --  GENERIC MAP (tech => CFG_PADTECH)
  --  PORT MAP (IO6, gpioo.dout(6), gpioo.oen(6), gpioi.din(6));
  --pio_pad_7 : iopad
  --  GENERIC MAP (tech => CFG_PADTECH)
  --  PORT MAP (IO7, gpioo.dout(7), gpioo.oen(7), gpioi.din(7));

  PROCESS (clk_25, rstn_25)
  BEGIN  -- PROCESS
    IF rstn_25 = '0' THEN               -- asynchronous reset (active low)
      --    --IO0  <= '0';
      --    IO1  <= '0';
      --    IO2  <= '0';  
      --    IO3  <= '0';
      --    IO4  <= '0';
      --    IO5  <= '0';
      --    IO6  <= '0';
      --    IO7  <= '0';
      IO8  <= '0';
      IO9  <= '0';
      IO10 <= '0';
      IO11 <= '0';
    ELSIF clk_25'EVENT AND clk_25 = '1' THEN  -- rising clock edge
      CASE gpioo.dout(2 DOWNTO 0) IS
        WHEN "011" =>
          --        --IO0  <= observation_reg(0 );
          --        IO1  <= observation_reg(1 );
          --        IO2  <= observation_reg(2 );  
          --        IO3  <= observation_reg(3 );
          --        IO4  <= observation_reg(4 );
          --        IO5  <= observation_reg(5 );
          --        IO6  <= observation_reg(6 );
          --        IO7  <= observation_reg(7 );
          IO8  <= observation_reg(8);
          IO9  <= observation_reg(9);
          IO10 <= observation_reg(10);
          IO11 <= observation_reg(11);
        WHEN "001" =>
          --        --IO0  <= observation_reg(0  + 12);
          --        IO1  <= observation_reg(1  + 12);
          --        IO2  <= observation_reg(2  + 12);  
          --        IO3  <= observation_reg(3  + 12);
          --        IO4  <= observation_reg(4  + 12);
          --        IO5  <= observation_reg(5  + 12);
          --        IO6  <= observation_reg(6  + 12);
          --        IO7  <= observation_reg(7  + 12);
          IO8  <= observation_reg(8 + 12);
          IO9  <= observation_reg(9 + 12);
          IO10 <= observation_reg(10 + 12);
          IO11 <= observation_reg(11 + 12);
        WHEN "010" =>
          --        --IO0  <= observation_reg(0  + 12 + 12);
          --        IO1  <= observation_reg(1  + 12 + 12);
          --        IO2  <= observation_reg(2  + 12 + 12);  
          --        IO3  <= observation_reg(3  + 12 + 12);
          --        IO4  <= observation_reg(4  + 12 + 12);
          --        IO5  <= observation_reg(5  + 12 + 12);
          --        IO6  <= observation_reg(6  + 12 + 12);
          --        IO7  <= observation_reg(7  + 12 + 12);
          IO8  <= '0';
          IO9  <= '0';
          IO10 <= '0';
          IO11 <= '0';
        WHEN "000" =>
          --        --IO0  <= observation_vector_0(0 );
          --        IO1  <= observation_vector_0(1 );
          --        IO2  <= observation_vector_0(2 );  
          --        IO3  <= observation_vector_0(3 );
          --        IO4  <= observation_vector_0(4 );
          --        IO5  <= observation_vector_0(5 );
          --        IO6  <= observation_vector_0(6 );
          --        IO7  <= observation_vector_0(7 );
          IO8  <= observation_vector_0(8);
          IO9  <= observation_vector_0(9);
          IO10 <= observation_vector_0(10);
          IO11 <= observation_vector_0(11);
        WHEN "100" =>
          --        --IO0  <= observation_vector_1(0 );
          --        IO1  <= observation_vector_1(1 );
          --        IO2  <= observation_vector_1(2 );  
          --        IO3  <= observation_vector_1(3 );
          --        IO4  <= observation_vector_1(4 );
          --        IO5  <= observation_vector_1(5 );
          --        IO6  <= observation_vector_1(6 );
          --        IO7  <= observation_vector_1(7 );
          IO8  <= observation_vector_1(8);
          IO9  <= observation_vector_1(9);
          IO10 <= observation_vector_1(10);
          IO11 <= observation_vector_1(11);
        WHEN OTHERS => NULL;
      END CASE;
      
    END IF;
  END PROCESS;
  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  all_apbo_ext : FOR I IN NB_APB_SLAVE-1+5 DOWNTO 5 GENERATE
    apbo_ext_not_used : IF I /= 5 AND I /= 6 AND I /= 11 AND I /= 15 GENERATE
      apbo_ext(I) <= apb_none;
    END GENERATE apbo_ext_not_used;
  END GENERATE all_apbo_ext;


  all_ahbo_ext : FOR I IN NB_AHB_SLAVE-1+3 DOWNTO 3 GENERATE
    ahbo_s_ext(I) <= ahbs_none;
  END GENERATE all_ahbo_ext;

  all_ahbo_m_ext : FOR I IN NB_AHB_MASTER-1+1 DOWNTO 1 GENERATE
    ahbo_m_ext_not_used : IF I /= 1 AND I /= 2 GENERATE
      ahbo_m_ext(I) <= ahbm_none;
    END GENERATE ahbo_m_ext_not_used;
  END GENERATE all_ahbo_m_ext;

END beh;
