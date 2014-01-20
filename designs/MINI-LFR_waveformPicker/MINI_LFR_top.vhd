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
USE lpp.lpp_lfr_pkg.ALL;
USE lpp.iir_filter.ALL;
USE lpp.general_purpose.ALL;
USE lpp.lpp_lfr_time_management.ALL;
USE lpp.lpp_leon3_soc_pkg.ALL;
USE lpp.lpp_debug_lfr_pkg.ALL;

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
  -----------------------------------------------------------------------------
  SIGNAL coarse_time : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL fine_time   : STD_LOGIC_VECTOR(15 DOWNTO 0);
  --
  SIGNAL errorn      : STD_LOGIC;
  -- UART AHB ---------------------------------------------------------------
  SIGNAL ahbrxd      : STD_ULOGIC;      -- DSU rx data  
  SIGNAL ahbtxd      : STD_ULOGIC;      -- DSU tx data

  -- UART APB ---------------------------------------------------------------
  SIGNAL   urxd1         : STD_ULOGIC;  -- UART1 rx data
  SIGNAL   utxd1         : STD_ULOGIC;  -- UART1 tx data
                                        --
  SIGNAL   I00_s         : STD_LOGIC;
  --
  CONSTANT NB_APB_SLAVE  : INTEGER := 4;  -- previous value 1, 3 takes the waveform picker and the time manager into account
  CONSTANT NB_AHB_SLAVE  : INTEGER := 1;
  CONSTANT NB_AHB_MASTER : INTEGER := 2;  -- previous value 1, 2 takes the waveform picker into account

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
--  SIGNAL clkmn                : STD_ULOGIC;
--  SIGNAL txclk                : STD_ULOGIC;

-- AD Converter RHF1401
  SIGNAL sample             : Samples14v(7 DOWNTO 0);
  SIGNAL sample_val         : STD_LOGIC;
  -- ADC --------------------------------------------------------------------
  SIGNAL ADC_OEB_bar_CH_sig : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL ADC_smpclk_sig     : STD_LOGIC;
  SIGNAL ADC_data_sig       : STD_LOGIC_VECTOR(13 DOWNTO 0);

  SIGNAL bias_fail_sw_sig : STD_LOGIC;
  -----------------------------------------------------------------------------
  SIGNAL sample_val_s : STD_LOGIC;
  SIGNAL sample_val_s2 : STD_LOGIC;
BEGIN  -- beh

  -----------------------------------------------------------------------------
  -- CLK
  -----------------------------------------------------------------------------

  PROCESS(clk_50)
  BEGIN
    IF clk_50'EVENT AND clk_50 = '1' THEN
      clk_50_s <= NOT clk_50_s;
    END IF;
  END PROCESS;

  PROCESS(clk_50_s)
  BEGIN
    IF clk_50_s'EVENT AND clk_50_s = '1' THEN
      clk_25 <= NOT clk_25;
    END IF;
  END PROCESS;

  -----------------------------------------------------------------------------

  PROCESS (clk_25, reset)
  BEGIN  -- PROCESS
    IF reset = '0' THEN                 -- asynchronous reset (active low)
      LED0 <= '0';
      LED1 <= '0';
      LED2 <= '0';
      IO0  <= '0';
      --IO1  <= '0';
      IO2  <= '1';
      IO3  <= '0';
      IO4  <= '0';
      IO5  <= '0';
      IO6  <= '0';
      IO7  <= '0';
      IO8  <= '0';
      IO9  <= '0';
      IO10 <= '0';
      IO11 <= '0';
    ELSIF clk_25'EVENT AND clk_25 = '1' THEN  -- rising clock edge
      LED0 <= '0';
      LED1 <= '1';
      LED2 <= BP0;
      IO0  <= '1';
      --IO1  <= '1';
      IO2  <= SPW_NOM_DIN OR SPW_NOM_SIN OR SPW_RED_DIN OR SPW_RED_SIN OR BP1 OR nDTR2 OR nRTS2 OR nRTS1;
      IO3  <= ADC_SDO(0) OR ADC_SDO(1) OR ADC_SDO(2) OR ADC_SDO(3) OR ADC_SDO(4) OR ADC_SDO(5) OR ADC_SDO(6) OR ADC_SDO(7);
      IO4  <= sample_val;
      IO5  <= ahbi_m_ext.HREADY;
      IO6  <= ahbi_m_ext.HRESP(0);
      IO7  <= ahbi_m_ext.HRESP(1);
      IO8  <= ahbi_m_ext.HGRANT(2);
      IO9  <= ahbo_m_ext(2).HLOCK;
      IO10 <= ahbo_m_ext(2).HBUSREQ;
      IO11 <= sample_val_s2;
    END IF;
  END PROCESS;

  --PROCESS (clk_49, reset)
  --BEGIN  -- PROCESS
  --  IF reset = '0' THEN                 -- asynchronous reset (active low)
  --    I00_s <= '0';
  --  ELSIF clk_49'EVENT AND clk_49 = '1' THEN  -- rising clock edge
  --    I00_s <= NOT I00_s;
  --  END IF;
  --END PROCESS;
  --IO0 <= I00_s;

  --UARTs
  nCTS1 <= '1';
  nCTS2 <= '1';
  nDCD2 <= '1';

  --EXT CONNECTOR

  --SPACE WIRE

  ADC_nCS <= '0';
  ADC_CLK <= '0';


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
      ENABLE_FPU      => 0,
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
      reset     => reset,
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
      nSRAM_CE  => SRAM_CE,
      nSRAM_OE  => SRAM_nOE,

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
      pindex => 7,
      paddr  => 7,
      pmask  => 16#fff#,
      pirq   => 12)
    PORT MAP (
      clk25MHz     => clk_25,
      clk49_152MHz => clk_49,
      resetn       => reset,
      grspw_tick   => swno.tickout,
      apbi         => apbi_ext,
      apbo         => apbo_ext(7),
      coarse_time  => coarse_time,
      fine_time    => fine_time);

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
    PORT MAP(reset, clk_25, spw_rxclk(0),
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
      pindex                 => 6,
      paddr                  => 6,
      pmask                  => 16#fff#,
      pirq_ms                => 6,
      pirq_wfp               => 14,
      hindex                 => 2,
      top_lfr_version        => X"00000009")
    PORT MAP (
      clk             => clk_25,
      rstn            => reset,
      sample_B        => sample(2 DOWNTO 0),
      sample_E        => sample(7 DOWNTO 3),
      sample_val      => sample_val,
      apbi            => apbi_ext,
      apbo            => apbo_ext(6),
      ahbi            => ahbi_m_ext,
      ahbo            => ahbo_m_ext(2),
      coarse_time     => coarse_time,
      fine_time       => fine_time,
      data_shaping_BW => bias_fail_sw_sig);

  top_ad_conv_RHF1401_1 : top_ad_conv_RHF1401
    GENERIC MAP (
      ChanelCount     => 8,
      ncycle_cnv_high => 79,
      ncycle_cnv      => 500)
    PORT MAP (
      cnv_clk    => clk_49,
      cnv_rstn   => reset,
      cnv        => ADC_smpclk_sig,
      clk        => clk_25,
      rstn       => reset,
      ADC_data   => ADC_data_sig,
      ADC_nOE    => ADC_OEB_bar_CH_sig,
      sample     => OPEN,
      sample_val => sample_val);--OPEN );--

  ADC_data_sig <= (OTHERS => '1');

  lpp_debug_lfr_1 : lpp_debug_lfr
    GENERIC MAP (
      pindex => 8,
      paddr  => 8,
      pmask  => 16#fff#)
    PORT MAP (
      HCLK     => clk_25,
      HRESETn  => reset,
      apbi     => apbi_ext,
      apbo     => apbo_ext(8),
      sample_B => sample(2 DOWNTO 0),
      sample_E => sample(7 DOWNTO 3));

  PROCESS (clk_25, reset)
  BEGIN  -- PROCESS
    IF reset = '0' THEN                 -- asynchronous reset (active low)
      sample_val_s2 <= '0';
      sample_val_s  <= '0';
      --sample_val    <= '0';
    ELSIF clk_25'EVENT AND clk_25 = '1' THEN  -- rising clock edge
      sample_val_s  <= IO1;
      sample_val_s2 <= sample_val_s;
      --sample_val    <= (NOT sample_val_s2) AND sample_val_s;
    END IF;
  END PROCESS;

  
  
END beh;
