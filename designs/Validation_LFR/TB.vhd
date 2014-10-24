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
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY lpp;
USE lpp.lpp_ad_conv.ALL;
USE lpp.iir_filter.ALL;
USE lpp.FILTERcfg.ALL;
USE lpp.lpp_memory.ALL;
USE lpp.lpp_waveform_pkg.ALL;
USE lpp.lpp_dma_pkg.ALL;
USE lpp.lpp_top_lfr_pkg.ALL;
USE lpp.lpp_lfr_pkg.ALL;
USE lpp.general_purpose.ALL;
USE lpp.lpp_lfr_pkg.ALL;
USE lpp.lpp_memory.ALL;
USE lpp.iir_filter.ALL;
USE lpp.spectral_matrix_package.ALL;
USE lpp.lpp_fft.ALL;
USE lpp.fft_components.ALL;
USE lpp.CY7C1061DV33_pkg.ALL;
USE lpp.testbench_package.ALL;


LIBRARY grlib;
USE grlib.amba.ALL;
USE grlib.stdlib.ALL;
USE grlib.devices.ALL;
USE GRLIB.DMA2AHB_Package.ALL;

LIBRARY gaisler;
USE gaisler.memctrl.ALL;
USE gaisler.misc.ALL;

LIBRARY techmap;
USE techmap.gencomp.ALL;

LIBRARY esa;
USE esa.memoryctrl.ALL;


ENTITY TB IS
END TB;


ARCHITECTURE beh OF TB IS
  CONSTANT INDEX_LFR                             : INTEGER                       := 15;
  CONSTANT ADDR_LFR                              : INTEGER                       := 15;
  -- REG MS
  CONSTANT ADDR_SPECTRAL_MATRIX_CONFIG           : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F00";
  CONSTANT ADDR_SPECTRAL_MATRIX_STATUS           : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F04";
  CONSTANT ADDR_SPECTRAL_MATRIX_ADDR_MATRIX_F0_0 : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F08";
  CONSTANT ADDR_SPECTRAL_MATRIX_ADDR_MATRIX_F0_1 : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F0C";

  CONSTANT ADDR_SPECTRAL_MATRIX_ADDR_MATRIX_F1_0 : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F10";
  CONSTANT ADDR_SPECTRAL_MATRIX_ADDR_MATRIX_F1_1 : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F14";
  CONSTANT ADDR_SPECTRAL_MATRIX_ADDR_MATRIX_F2_0 : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F18";
  CONSTANT ADDR_SPECTRAL_MATRIX_ADDR_MATRIX_F2_1 : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F1C";

  CONSTANT ADDR_SPECTRAL_MATRIX_COARSE_TIME_F0_0 : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F20";
  CONSTANT ADDR_SPECTRAL_MATRIX_FINE_TIME_F0_0   : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F24";
  CONSTANT ADDR_SPECTRAL_MATRIX_COARSE_TIME_F0_1 : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F28";
  CONSTANT ADDR_SPECTRAL_MATRIX_FINE_TIME_F0_1   : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F2C";

  CONSTANT ADDR_SPECTRAL_MATRIX_COARSE_TIME_F1_0 : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F30";
  CONSTANT ADDR_SPECTRAL_MATRIX_FINE_TIME_F1_0   : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F34";
  CONSTANT ADDR_SPECTRAL_MATRIX_COARSE_TIME_F1_1 : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F38";
  CONSTANT ADDR_SPECTRAL_MATRIX_FINE_TIME_F1_1   : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F3C";

  CONSTANT ADDR_SPECTRAL_MATRIX_COARSE_TIME_F2_0 : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F40";
  CONSTANT ADDR_SPECTRAL_MATRIX_FINE_TIME_F2_0   : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F44";
  CONSTANT ADDR_SPECTRAL_MATRIX_COARSE_TIME_F2_1 : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F48";
  CONSTANT ADDR_SPECTRAL_MATRIX_FINE_TIME_F2_1   : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F4C";
  
  CONSTANT ADDR_SPECTRAL_MATRIX_LENGTH_MATRIX    : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F50";
  -- REG WAVEFORM
  CONSTANT ADDR_WAVEFORM_PICKER_DATASHAPING  : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F54";
  CONSTANT ADDR_WAVEFORM_PICKER_CONTROL      : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F58";
  CONSTANT ADDR_WAVEFORM_PICKER_ADDRESS_F0_0 : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F5C";

  CONSTANT ADDR_WAVEFORM_PICKER_ADDRESS_F0_1 : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F60";
  CONSTANT ADDR_WAVEFORM_PICKER_ADDRESS_F1_0 : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F64";
  CONSTANT ADDR_WAVEFORM_PICKER_ADDRESS_F1_1 : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F68";
  CONSTANT ADDR_WAVEFORM_PICKER_ADDRESS_F2_0 : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F6C";
  
  CONSTANT ADDR_WAVEFORM_PICKER_ADDRESS_F2_1 : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F70";
  CONSTANT ADDR_WAVEFORM_PICKER_ADDRESS_F3_0 : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F74";
  CONSTANT ADDR_WAVEFORM_PICKER_ADDRESS_F3_1 : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F78";
  CONSTANT ADDR_WAVEFORM_PICKER_STATUS       : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F7C";
  
  CONSTANT ADDR_WAVEFORM_PICKER_DELTASNAPSHOT : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F80";
  CONSTANT ADDR_WAVEFORM_PICKER_DELTA_F0      : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F84";
  CONSTANT ADDR_WAVEFORM_PICKER_DELTA_F0_2    : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F88";
  CONSTANT ADDR_WAVEFORM_PICKER_DELTA_F1      : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F8C";

  CONSTANT ADDR_WAVEFORM_PICKER_DELTA_F2          : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F90";
  CONSTANT ADDR_WAVEFORM_PICKER_NB_DATA_IN_BUFFER : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F94";
  CONSTANT ADDR_WAVEFORM_PICKER_NBSNAPSHOT        : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F98";
  CONSTANT ADDR_WAVEFORM_PICKER_START_DATE        : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F9C";

  CONSTANT ADDR_WAVEFORM_PICKER_COARSE_TIME_F0_0 : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000FA0";
  CONSTANT ADDR_WAVEFORM_PICKER_FINE_TIME_F0_0   : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000FA4";
  CONSTANT ADDR_WAVEFORM_PICKER_COARSE_TIME_F0_1 : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000FA8";
  CONSTANT ADDR_WAVEFORM_PICKER_FINE_TIME_F0_1   : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000FAC";

  CONSTANT ADDR_WAVEFORM_PICKER_COARSE_TIME_F1_0 : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000FB0";
  CONSTANT ADDR_WAVEFORM_PICKER_FINE_TIME_F1_0   : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000FB4";
  CONSTANT ADDR_WAVEFORM_PICKER_COARSE_TIME_F1_1 : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000FB8";
  CONSTANT ADDR_WAVEFORM_PICKER_FINE_TIME_F1_1   : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000FBC";

  CONSTANT ADDR_WAVEFORM_PICKER_COARSE_TIME_F2_0 : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000FC0";
  CONSTANT ADDR_WAVEFORM_PICKER_FINE_TIME_F2_0   : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000FC4";
  CONSTANT ADDR_WAVEFORM_PICKER_COARSE_TIME_F2_1 : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000FC8";
  CONSTANT ADDR_WAVEFORM_PICKER_FINE_TIME_F2_1   : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000FCC";

  CONSTANT ADDR_WAVEFORM_PICKER_COARSE_TIME_F3_0 : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000FD0";
  CONSTANT ADDR_WAVEFORM_PICKER_FINE_TIME_F3_0   : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000FD4";
  CONSTANT ADDR_WAVEFORM_PICKER_COARSE_TIME_F3_1 : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000FD8";
  CONSTANT ADDR_WAVEFORM_PICKER_FINE_TIME_F3_1   : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000FDC";

  CONSTANT ADDR_WAVEFORM_PICKER_LENGTH_BUFFER : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000FE0";
  
  -- RAM ADDRESS
  CONSTANT AHB_RAM_ADDR_0                         : INTEGER                       := 16#000#;
  CONSTANT AHB_RAM_ADDR_1                         : INTEGER                       := 16#200#;
  CONSTANT AHB_RAM_ADDR_2                         : INTEGER                       := 16#300#;
  CONSTANT AHB_RAM_ADDR_3                         : INTEGER                       := 16#400#;


  -- Common signal
  SIGNAL clk49_152MHz : STD_LOGIC := '0';
  SIGNAL clk25MHz     : STD_LOGIC := '0';
  SIGNAL rstn         : STD_LOGIC := '0';

  -- ADC interface
  SIGNAL ADC_OEB_bar_CH : STD_LOGIC_VECTOR(7 DOWNTO 0);   -- OUT
  SIGNAL ADC_smpclk     : STD_LOGIC;                      -- OUT
  SIGNAL ADC_data       : STD_LOGIC_VECTOR(13 DOWNTO 0);  -- IN

  -- AD Converter RHF1401
  SIGNAL sample     : Samples14v(7 DOWNTO 0);
  SIGNAL sample_s   : Samples(7 DOWNTO 0);
  SIGNAL sample_val : STD_LOGIC;

  -- AHB/APB SIGNAL
  SIGNAL apbi  : apb_slv_in_type;
  SIGNAL apbo  : apb_slv_out_vector := (OTHERS => apb_none);
  SIGNAL ahbsi : ahb_slv_in_type;
  SIGNAL ahbso : ahb_slv_out_vector := (OTHERS => ahbs_none);
  SIGNAL ahbmi : ahb_mst_in_type;
  SIGNAL ahbmo : ahb_mst_out_vector := (OTHERS => ahbm_none);

  SIGNAL bias_fail_bw : STD_LOGIC;

  -----------------------------------------------------------------------------
  -- LPP_WAVEFORM
  -----------------------------------------------------------------------------
  CONSTANT data_size               : INTEGER := 96;
  CONSTANT nb_burst_available_size : INTEGER := 50;
  CONSTANT nb_snapshot_param_size  : INTEGER := 2;
  CONSTANT delta_vector_size       : INTEGER := 2;
  CONSTANT delta_vector_size_f0_2  : INTEGER := 2;

  SIGNAL reg_run                      : STD_LOGIC;
  SIGNAL reg_start_date               : STD_LOGIC_VECTOR(30 DOWNTO 0);
  SIGNAL reg_delta_snapshot           : STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
  SIGNAL reg_delta_f0                 : STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
  SIGNAL reg_delta_f0_2               : STD_LOGIC_VECTOR(delta_vector_size_f0_2-1 DOWNTO 0);
  SIGNAL reg_delta_f1                 : STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
  SIGNAL reg_delta_f2                 : STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
  SIGNAL enable_f0                    : STD_LOGIC;
  SIGNAL enable_f1                    : STD_LOGIC;
  SIGNAL enable_f2                    : STD_LOGIC;
  SIGNAL enable_f3                    : STD_LOGIC;
  SIGNAL burst_f0                     : STD_LOGIC;
  SIGNAL burst_f1                     : STD_LOGIC;
  SIGNAL burst_f2                     : STD_LOGIC;
  SIGNAL nb_data_by_buffer            : STD_LOGIC_VECTOR(nb_burst_available_size-1 DOWNTO 0);
  SIGNAL nb_snapshot_param            : STD_LOGIC_VECTOR(nb_snapshot_param_size-1 DOWNTO 0);
  SIGNAL status_full                  : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL status_full_ack              : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL status_full_err              : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL status_new_err               : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL coarse_time                  : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL fine_time                    : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL addr_data_f0                 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_f0_in_valid             : STD_LOGIC;
  SIGNAL data_f0_in                   : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
  SIGNAL addr_data_f1                 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_f1_in_valid             : STD_LOGIC;
  SIGNAL data_f1_in                   : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
  SIGNAL addr_data_f2                 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_f2_in_valid             : STD_LOGIC;
  SIGNAL data_f2_in                   : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
  SIGNAL addr_data_f3                 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_f3_in_valid             : STD_LOGIC;
  SIGNAL data_f3_in                   : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
  SIGNAL data_f0_addr_out             : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_f0_data_out             : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_f0_data_out_valid       : STD_LOGIC;
  SIGNAL data_f0_data_out_valid_burst : STD_LOGIC;
  SIGNAL data_f0_data_out_ack         : STD_LOGIC;
  SIGNAL data_f1_addr_out             : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_f1_data_out             : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_f1_data_out_valid       : STD_LOGIC;
  SIGNAL data_f1_data_out_valid_burst : STD_LOGIC;
  SIGNAL data_f1_data_out_ack         : STD_LOGIC;
  SIGNAL data_f2_addr_out             : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_f2_data_out             : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_f2_data_out_valid       : STD_LOGIC;
  SIGNAL data_f2_data_out_valid_burst : STD_LOGIC;
  SIGNAL data_f2_data_out_ack         : STD_LOGIC;
  SIGNAL data_f3_addr_out             : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_f3_data_out             : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_f3_data_out_valid       : STD_LOGIC;
  SIGNAL data_f3_data_out_valid_burst : STD_LOGIC;
  SIGNAL data_f3_data_out_ack         : STD_LOGIC;

  --MEM CTRLR
  SIGNAL memi : memory_in_type;
  SIGNAL memo : memory_out_type;
  SIGNAL wpo  : wprot_out_type;
  SIGNAL sdo  : sdram_out_type;

  SIGNAL address   : STD_LOGIC_VECTOR(19 DOWNTO 0) := "00000000000000000000";
  SIGNAL data      : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL nSRAM_BE0 : STD_LOGIC;
  SIGNAL nSRAM_BE1 : STD_LOGIC;
  SIGNAL nSRAM_BE2 : STD_LOGIC;
  SIGNAL nSRAM_BE3 : STD_LOGIC;
  SIGNAL nSRAM_WE  : STD_LOGIC;
  SIGNAL nSRAM_CE  : STD_LOGIC;
  SIGNAL nSRAM_OE  : STD_LOGIC;

  CONSTANT padtech     : INTEGER := inferred;
  SIGNAL   not_ramsn_0 : STD_LOGIC;

  -----------------------------------------------------------------------------
  SIGNAL   status                     : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL   read_buffer                : STD_LOGIC;
  -----------------------------------------------------------------------------
  SIGNAL   run_test_waveform_picker   : STD_LOGIC := '1';
  SIGNAL   state_read_buffer_on_going : STD_LOGIC;
  CONSTANT hindex                     : INTEGER   := 1;
  SIGNAL   time_mem_f0                : STD_LOGIC_VECTOR(63 DOWNTO 0);
  SIGNAL   time_mem_f1                : STD_LOGIC_VECTOR(63 DOWNTO 0);
  SIGNAL   time_mem_f2                : STD_LOGIC_VECTOR(63 DOWNTO 0);
  SIGNAL   time_mem_f3                : STD_LOGIC_VECTOR(63 DOWNTO 0);

  SIGNAL data_mem_f0 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_mem_f1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_mem_f2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_mem_f3 : STD_LOGIC_VECTOR(31 DOWNTO 0);

  SIGNAL data_0_f1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL data_0_f2 : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL data_0_f0 : STD_LOGIC_VECTOR(15 DOWNTO 0);

  SIGNAL data_1_f1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL data_1_f2 : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL data_1_f0 : STD_LOGIC_VECTOR(15 DOWNTO 0);

  SIGNAL data_2_f1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL data_2_f2 : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL data_2_f0 : STD_LOGIC_VECTOR(15 DOWNTO 0);

  SIGNAL data_3_f1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL data_3_f2 : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL data_3_f0 : STD_LOGIC_VECTOR(15 DOWNTO 0);

  SIGNAL data_4_f1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL data_4_f2 : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL data_4_f0 : STD_LOGIC_VECTOR(15 DOWNTO 0);

  SIGNAL data_5_f1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL data_5_f2 : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL data_5_f0 : STD_LOGIC_VECTOR(15 DOWNTO 0);
  -----------------------------------------------------------------------------

  SIGNAL current_data : INTEGER;
  SIGNAL LIMIT_DATA   : INTEGER := 64;

  SIGNAL read_buffer_temp   : STD_LOGIC;
  SIGNAL read_buffer_temp_2 : STD_LOGIC;
  
  
BEGIN

  -----------------------------------------------------------------------------
  
  clk49_152MHz <= NOT clk49_152MHz AFTER 10173 ps;  -- 49.152/2 MHz
  clk25MHz     <= NOT clk25MHz     AFTER 5 ns;      -- 100 MHz

  -----------------------------------------------------------------------------

  MODULE_RHF1401 : FOR I IN 0 TO 7 GENERATE
    TestModule_RHF1401_1 : TestModule_RHF1401
      GENERIC MAP (
        freq      => 24*(I+1),
        amplitude => 8000/(I+1),
        impulsion => 0)
      PORT MAP (
        ADC_smpclk  => ADC_smpclk,
        ADC_OEB_bar => ADC_OEB_bar_CH(I),
        ADC_data    => ADC_data);
  END GENERATE MODULE_RHF1401;

  -----------------------------------------------------------------------------

  top_ad_conv_RHF1401_1 : top_ad_conv_RHF1401
    GENERIC MAP (
      ChanelCount     => 8,
      ncycle_cnv_high => 79,
      ncycle_cnv      => 500)
    PORT MAP (
      cnv_clk    => clk49_152MHz,
      cnv_rstn   => rstn,
      cnv        => ADC_smpclk,
      clk        => clk25MHz,
      rstn       => rstn,
      ADC_data   => ADC_data,
      ADC_nOE    => ADC_OEB_bar_CH,
      sample     => sample,
      sample_val => sample_val);
  -----------------------------------------------------------------------------


  all_sample : FOR I IN 7 DOWNTO 0 GENERATE
    sample_s(I) <= sample(I) & '0' & '0';
  END GENERATE all_sample;
  -----------------------------------------------------------------------------

  lpp_lfr_1 : lpp_lfr
    GENERIC MAP (
      Mem_use                => use_CEL,  -- use_RAM
      nb_data_by_buffer_size => 32,
--      nb_word_by_buffer_size => 30,
      nb_snapshot_param_size => 32,
      delta_vector_size      => 32,
      delta_vector_size_f0_2 => 32,
      pindex                 => INDEX_LFR,
      paddr                  => ADDR_LFR,
      pmask                  => 16#fff#,
      pirq_ms                => 6,
      pirq_wfp               => 14,
      hindex                 => 0,
      top_lfr_version        => X"000001")
    PORT MAP (
      clk             => clk25MHz,
      rstn            => rstn,
      sample_B        => sample_s(2 DOWNTO 0),
      sample_E        => sample_s(7 DOWNTO 3),
      sample_val      => sample_val,
      apbi            => apbi,
      apbo            => apbo(15),
      ahbi            => ahbmi,
      ahbo            => ahbmo(0),
      coarse_time     => coarse_time,
      fine_time       => fine_time,
      data_shaping_BW => bias_fail_bw);

  -----------------------------------------------------------------------------
  ---  AHB CONTROLLER  -------------------------------------------------
  ahb0 : ahbctrl                        -- AHB arbiter/multiplexer
    GENERIC MAP (defmast => 0, split => 0,
                 rrobin  => 1, ioaddr => 16#FFF#,
                 ioen    => 0, nahbm => 2, nahbs => 1)
    PORT MAP (rstn, clk25MHz, ahbmi, ahbmo, ahbsi, ahbso);



  ---  AHB RAM ----------------------------------------------------------
  --ahbram0 : ahbram
  --  GENERIC MAP (hindex => 0, haddr => AHB_RAM_ADDR_0, tech => inferred, kbytes => 1, pipe => 0)
  --  PORT MAP (rstn, clk25MHz, ahbsi, ahbso(0));
  --ahbram1 : ahbram
  --  GENERIC MAP (hindex => 1, haddr => AHB_RAM_ADDR_1, tech => inferred, kbytes => 1, pipe => 0)
  --  PORT MAP (rstn, clk25MHz, ahbsi, ahbso(1));
  --ahbram2 : ahbram
  --  GENERIC MAP (hindex => 2, haddr => AHB_RAM_ADDR_2, tech => inferred, kbytes => 1, pipe => 0)
  --  PORT MAP (rstn, clk25MHz, ahbsi, ahbso(2));
  --ahbram3 : ahbram
  --  GENERIC MAP (hindex => 3, haddr => AHB_RAM_ADDR_3, tech => inferred, kbytes => 1, pipe => 0)
  --  PORT MAP (rstn, clk25MHz, ahbsi, ahbso(3));

  -----------------------------------------------------------------------------
  ----------------------------------------------------------------------
  ---  Memory controllers  ---------------------------------------------
  ----------------------------------------------------------------------
  memctrlr : mctrl GENERIC MAP (
    hindex  => 0,
    pindex  => 0,
    paddr   => 0,
    srbanks => 1
    )
    PORT MAP (rstn, clk25MHz, memi, memo, ahbsi, ahbso(0), apbi, apbo(0), wpo, sdo);

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

  not_ramsn_0 <= NOT(memo.ramsn(0));

  rams_pad : outpad GENERIC MAP (tech => padtech) PORT MAP (nSRAM_CE, not_ramsn_0);
  oen_pad  : outpad GENERIC MAP (tech => padtech) PORT MAP (nSRAM_OE, memo.ramoen(0));
  nBWE_pad : outpad GENERIC MAP (tech => padtech) PORT MAP (nSRAM_WE, memo.writen);
  nBWa_pad : outpad GENERIC MAP (tech => padtech) PORT MAP (nSRAM_BE0, memo.mben(3));
  nBWb_pad : outpad GENERIC MAP (tech => padtech) PORT MAP (nSRAM_BE1, memo.mben(2));
  nBWc_pad : outpad GENERIC MAP (tech => padtech) PORT MAP (nSRAM_BE2, memo.mben(1));
  nBWd_pad : outpad GENERIC MAP (tech => padtech) PORT MAP (nSRAM_BE3, memo.mben(0));

  async_1Mx16_0 : CY7C1061DV33
    GENERIC MAP (
      ADDR_BITS       => 20,
      DATA_BITS       => 16,
      depth           => 1048576,
      MEM_ARRAY_DEBUG => 32,
      TimingInfo      => true,
      TimingChecks    => '1')
    PORT MAP (
      CE1_b => '0',
      CE2   => nSRAM_CE,
      WE_b  => nSRAM_WE,
      OE_b  => nSRAM_OE,
      BHE_b => nSRAM_BE1,
      BLE_b => nSRAM_BE0,
      A     => address,
      DQ    => data(15 DOWNTO 0));

  async_1Mx16_1 : CY7C1061DV33
    GENERIC MAP (
      ADDR_BITS       => 20,
      DATA_BITS       => 16,
      depth           => 1048576,
      MEM_ARRAY_DEBUG => 32,
      TimingInfo      => true,
      TimingChecks    => '1')
    PORT MAP (
      CE1_b => '0',
      CE2   => nSRAM_CE,
      WE_b  => nSRAM_WE,
      OE_b  => nSRAM_OE,
      BHE_b => nSRAM_BE3,
      BLE_b => nSRAM_BE2,
      A     => address,
      DQ    => data(31 DOWNTO 16));


  -----------------------------------------------------------------------------

  WaveGen_Proc : PROCESS
  BEGIN

    -- insert signal assignments here
    WAIT UNTIL clk25MHz = '1';
    rstn          <= '0';
    apbi.psel(15) <= '0';
    apbi.pwrite   <= '0';
    apbi.penable  <= '0';
    apbi.paddr    <= (OTHERS => '0');
    apbi.pwdata   <= (OTHERS => '0');
    fine_time     <= (OTHERS => '0');
    coarse_time   <= (OTHERS => '0');
    WAIT UNTIL clk25MHz = '1';
--    ahbmi.HGRANT(2) <= '1';
--    ahbmi.HREADY    <= '1';
--    ahbmi.HRESP     <= HRESP_OKAY;

    WAIT UNTIL clk25MHz = '1';
    WAIT UNTIL clk25MHz = '1';
    rstn <= '1';
    WAIT UNTIL clk25MHz = '1';
    ---------------------------------------------------------------------------
    -- spectral matrix configuration
    ---------------------------------------------------------------------------
    APB_WRITE(clk25MHz, INDEX_LFR, apbi, ADDR_SPECTRAL_MATRIX_CONFIG,            X"00000000");
    
    APB_WRITE(clk25MHz, INDEX_LFR, apbi, ADDR_SPECTRAL_MATRIX_ADDR_MATRIX_F0_0 , X"40000000");
    APB_WRITE(clk25MHz, INDEX_LFR, apbi, ADDR_SPECTRAL_MATRIX_ADDR_MATRIX_F0_1 , X"40001000");
    APB_WRITE(clk25MHz, INDEX_LFR, apbi, ADDR_SPECTRAL_MATRIX_ADDR_MATRIX_F1_0 , X"40002000");
    APB_WRITE(clk25MHz, INDEX_LFR, apbi, ADDR_SPECTRAL_MATRIX_ADDR_MATRIX_F1_1 , X"40003000");
    APB_WRITE(clk25MHz, INDEX_LFR, apbi, ADDR_SPECTRAL_MATRIX_ADDR_MATRIX_F2_0 , X"40004000");
    APB_WRITE(clk25MHz, INDEX_LFR, apbi, ADDR_SPECTRAL_MATRIX_ADDR_MATRIX_F2_1 , X"40005000");    
    APB_WRITE(clk25MHz, INDEX_LFR, apbi, ADDR_SPECTRAL_MATRIX_LENGTH_MATRIX,     X"000000C8");
    APB_WRITE(clk25MHz, INDEX_LFR, apbi, ADDR_SPECTRAL_MATRIX_STATUS,            X"00000000");
    
    APB_WRITE(clk25MHz, INDEX_LFR, apbi, ADDR_SPECTRAL_MATRIX_CONFIG,            X"00000007");
    
    ---------------------------------------------------------------------------
    -- waveform picker configuration
    ---------------------------------------------------------------------------
    APB_WRITE(clk25MHz, INDEX_LFR, apbi, ADDR_WAVEFORM_PICKER_ADDRESS_F0_0 , X"40020000");
    APB_WRITE(clk25MHz, INDEX_LFR, apbi, ADDR_WAVEFORM_PICKER_ADDRESS_F0_1 , X"40020000");
    APB_WRITE(clk25MHz, INDEX_LFR, apbi, ADDR_WAVEFORM_PICKER_ADDRESS_F1_0 , X"40030000");
    APB_WRITE(clk25MHz, INDEX_LFR, apbi, ADDR_WAVEFORM_PICKER_ADDRESS_F1_1 , X"40030000");
    APB_WRITE(clk25MHz, INDEX_LFR, apbi, ADDR_WAVEFORM_PICKER_ADDRESS_F2_0 , X"40040000");
    APB_WRITE(clk25MHz, INDEX_LFR, apbi, ADDR_WAVEFORM_PICKER_ADDRESS_F2_1 , X"40040000");
    APB_WRITE(clk25MHz, INDEX_LFR, apbi, ADDR_WAVEFORM_PICKER_ADDRESS_F3_0 , X"40060000");
    APB_WRITE(clk25MHz, INDEX_LFR, apbi, ADDR_WAVEFORM_PICKER_ADDRESS_F3_1 , X"40060000");

    APB_WRITE(clk25MHz, INDEX_LFR, apbi, ADDR_WAVEFORM_PICKER_DELTASNAPSHOT, X"00000020");  --"00000020"
    APB_WRITE(clk25MHz, INDEX_LFR, apbi, ADDR_WAVEFORM_PICKER_DELTA_F0 , X"00000019");  --"00000019"
    APB_WRITE(clk25MHz, INDEX_LFR, apbi, ADDR_WAVEFORM_PICKER_DELTA_F0_2 , X"00000007");  --"00000007"
    APB_WRITE(clk25MHz, INDEX_LFR, apbi, ADDR_WAVEFORM_PICKER_DELTA_F1 , X"00000019");  --"00000019"
    APB_WRITE(clk25MHz, INDEX_LFR, apbi, ADDR_WAVEFORM_PICKER_DELTA_F2 , X"00000001");  --"00000001"

    APB_WRITE(clk25MHz, INDEX_LFR, apbi, ADDR_WAVEFORM_PICKER_NB_DATA_IN_BUFFER , X"00000010");  -- X"00000010"
    -- 
    APB_WRITE(clk25MHz, INDEX_LFR, apbi, ADDR_WAVEFORM_PICKER_NBSNAPSHOT , X"00000010");
    APB_WRITE(clk25MHz, INDEX_LFR, apbi, ADDR_WAVEFORM_PICKER_START_DATE , X"00000001");

    APB_WRITE(clk25MHz, INDEX_LFR, apbi, ADDR_WAVEFORM_PICKER_LENGTH_BUFFER , X"00000003");

    
    APB_WRITE(clk25MHz, INDEX_LFR, apbi, ADDR_WAVEFORM_PICKER_CONTROL, X"00000080");
    WAIT UNTIL clk25MHz = '1';
    ---------------------------------------------------------------------------
    -- CONFIGURATION STEP
    APB_WRITE(clk25MHz, INDEX_LFR, apbi, ADDR_WAVEFORM_PICKER_ADDRESS_F0_0 , X"40020000");
    APB_WRITE(clk25MHz, INDEX_LFR, apbi, ADDR_WAVEFORM_PICKER_ADDRESS_F0_1 , X"40020000");
    APB_WRITE(clk25MHz, INDEX_LFR, apbi, ADDR_WAVEFORM_PICKER_ADDRESS_F1_0 , X"40030000");
    APB_WRITE(clk25MHz, INDEX_LFR, apbi, ADDR_WAVEFORM_PICKER_ADDRESS_F1_1 , X"40030000");
    APB_WRITE(clk25MHz, INDEX_LFR, apbi, ADDR_WAVEFORM_PICKER_ADDRESS_F2_0 , X"40040000");
    APB_WRITE(clk25MHz, INDEX_LFR, apbi, ADDR_WAVEFORM_PICKER_ADDRESS_F2_1 , X"40040000");
    APB_WRITE(clk25MHz, INDEX_LFR, apbi, ADDR_WAVEFORM_PICKER_ADDRESS_F3_0 , X"40060000");
    APB_WRITE(clk25MHz, INDEX_LFR, apbi, ADDR_WAVEFORM_PICKER_ADDRESS_F3_1 , X"40060000");

    WAIT UNTIL clk25MHz = '1';
    WAIT UNTIL clk25MHz = '1';


    APB_WRITE(clk25MHz, INDEX_LFR, apbi, ADDR_WAVEFORM_PICKER_CONTROL, X"00000097");
    WAIT UNTIL clk25MHz = '1';
    WAIT UNTIL clk25MHz = '1';
    WAIT UNTIL clk25MHz = '1';
    WAIT UNTIL clk25MHz = '1';
    WAIT UNTIL clk25MHz = '1';
    WAIT UNTIL clk25MHz = '1';
    WAIT FOR 1 us;
    coarse_time <= X"00000001";
    ---------------------------------------------------------------------------
    -- RUN STEP
    WAIT FOR 200 ms;
    APB_WRITE(clk25MHz, INDEX_LFR, apbi, ADDR_WAVEFORM_PICKER_CONTROL, X"00000000");
    APB_WRITE(clk25MHz, INDEX_LFR, apbi, ADDR_WAVEFORM_PICKER_START_DATE, X"00000010");
    WAIT FOR 10 us;
    WAIT UNTIL clk25MHz = '1';
    WAIT UNTIL clk25MHz = '1';
    APB_WRITE(clk25MHz, INDEX_LFR, apbi, ADDR_WAVEFORM_PICKER_CONTROL, X"000000FF");
    WAIT UNTIL clk25MHz = '1';
    coarse_time <= X"00000010";
    WAIT FOR 100 ms;
    APB_WRITE(clk25MHz, INDEX_LFR, apbi, ADDR_WAVEFORM_PICKER_CONTROL, X"00000000");
    WAIT FOR 10 us;
    APB_WRITE(clk25MHz, INDEX_LFR, apbi, ADDR_WAVEFORM_PICKER_CONTROL, X"000000AF");
    WAIT FOR 200 ms;
    REPORT "*** END simulation ***" SEVERITY failure;


    WAIT;

  END PROCESS WaveGen_Proc;
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- IRQ
  -----------------------------------------------------------------------------
  PROCESS (clk25MHz, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)

    ELSIF clk25MHz'EVENT AND clk25MHz = '1' THEN  -- rising clock edge

    END IF;
  END PROCESS;
  -----------------------------------------------------------------------------

END beh;

