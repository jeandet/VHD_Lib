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
--                    Mail   : jean-christophe.pellion@lpp.polytechnique.fr
--                             jean-christophe.pellion@easii-ic.com
----------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY lpp;
USE lpp.lpp_ad_conv.ALL;
USE lpp.iir_filter.ALL;
USE lpp.FILTERcfg.ALL;
USE lpp.lpp_memory.ALL;
USE lpp.lpp_waveform_pkg.ALL;
USE lpp.cic_pkg.ALL;
USE lpp.data_type_pkg.ALL;
USE lpp.lpp_lfr_filter_coeff.ALL;

LIBRARY techmap;
USE techmap.gencomp.ALL;

LIBRARY grlib;
USE grlib.amba.ALL;
USE grlib.stdlib.ALL;
USE grlib.devices.ALL;
USE GRLIB.DMA2AHB_Package.ALL;

ENTITY lpp_lfr_filter IS
  GENERIC(
    Mem_use                 : INTEGER := use_RAM
    );
  PORT (
    sample           : IN Samples(7 DOWNTO 0);
    sample_val       : IN STD_LOGIC;
    --
    clk             : IN  STD_LOGIC;
    rstn            : IN  STD_LOGIC;
    --
    data_shaping_SP0 : IN STD_LOGIC;
    data_shaping_SP1 : IN STD_LOGIC;
    data_shaping_R0  : IN STD_LOGIC;
    data_shaping_R1  : IN STD_LOGIC;
    data_shaping_R2  : IN STD_LOGIC;
    --
    sample_f0_val   : OUT STD_LOGIC;
    sample_f1_val   : OUT STD_LOGIC;
    sample_f2_val   : OUT STD_LOGIC;
    sample_f3_val   : OUT STD_LOGIC;
    --
    sample_f0_wdata : OUT STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
    sample_f1_wdata : OUT STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
    sample_f2_wdata : OUT STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
    sample_f3_wdata : OUT STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0)
    );
END lpp_lfr_filter;

ARCHITECTURE tb OF lpp_lfr_filter IS

  COMPONENT Downsampling
    GENERIC (
      ChanelCount : INTEGER;
      SampleSize  : INTEGER;
      DivideParam : INTEGER);
    PORT (
      clk            : IN  STD_LOGIC;
      rstn           : IN  STD_LOGIC;
      sample_in_val  : IN  STD_LOGIC;
      sample_in      : IN  samplT(ChanelCount-1 DOWNTO 0, SampleSize-1 DOWNTO 0);
      sample_out_val : OUT STD_LOGIC;
      sample_out     : OUT samplT(ChanelCount-1 DOWNTO 0, SampleSize-1 DOWNTO 0));
  END COMPONENT;

  -----------------------------------------------------------------------------
  CONSTANT ChanelCount     : INTEGER := 8;

  -----------------------------------------------------------------------------
  SIGNAL   sample_val_delay : STD_LOGIC;
  -----------------------------------------------------------------------------
  CONSTANT Coef_SZ          : INTEGER := 9;
  CONSTANT CoefCntPerCel    : INTEGER := 6;
  CONSTANT CoefPerCel       : INTEGER := 5;
  CONSTANT Cels_count       : INTEGER := 5;

  --SIGNAL coefs                    : STD_LOGIC_VECTOR((Coef_SZ*CoefCntPerCel*Cels_count)-1 DOWNTO 0);
  SIGNAL coefs_v2                 : STD_LOGIC_VECTOR((Coef_SZ*CoefPerCel*Cels_count)-1 DOWNTO 0);
  SIGNAL sample_filter_in         : samplT(ChanelCount-1 DOWNTO 0, 17 DOWNTO 0);
  --SIGNAL sample_filter_out        : samplT(ChanelCount-1 DOWNTO 0, 17 DOWNTO 0);
  --
  SIGNAL sample_filter_v2_out_val : STD_LOGIC;
  SIGNAL sample_filter_v2_out     : samplT(ChanelCount-1 DOWNTO 0, 17 DOWNTO 0);
  -----------------------------------------------------------------------------
  SIGNAL sample_data_shaping_out_val     : STD_LOGIC;
  SIGNAL sample_data_shaping_out         : samplT(ChanelCount-1 DOWNTO 0, 17 DOWNTO 0);
  SIGNAL sample_data_shaping_f0_s        : STD_LOGIC_VECTOR(17 DOWNTO 0);
  SIGNAL sample_data_shaping_f1_s        : STD_LOGIC_VECTOR(17 DOWNTO 0);
  SIGNAL sample_data_shaping_f2_s        : STD_LOGIC_VECTOR(17 DOWNTO 0);
  SIGNAL sample_data_shaping_f1_f0_s     : STD_LOGIC_VECTOR(17 DOWNTO 0);
  SIGNAL sample_data_shaping_f2_f1_s     : STD_LOGIC_VECTOR(17 DOWNTO 0);
  -----------------------------------------------------------------------------
  SIGNAL sample_filter_v2_out_val_s      : STD_LOGIC;
  SIGNAL sample_filter_v2_out_s          : samplT(ChanelCount-1 DOWNTO 0, 15 DOWNTO 0);
  -----------------------------------------------------------------------------
--  SIGNAL sample_f0_val                   : STD_LOGIC;
  SIGNAL sample_f0                       : samplT(ChanelCount-1 DOWNTO 0, 15 DOWNTO 0);
  SIGNAL sample_f0_s                     : sample_vector(5 DOWNTO 0, 15 DOWNTO 0);
  --
--  SIGNAL sample_f1_val                   : STD_LOGIC;
  
  SIGNAL sample_f0_f1_s                  : samplT(5 DOWNTO 0, 17 DOWNTO 0);
  SIGNAL sample_f1_s                     : samplT(5 DOWNTO 0, 17 DOWNTO 0);
  SIGNAL sample_f1                       : samplT(5 DOWNTO 0, 17 DOWNTO 0);
  --
--  SIGNAL sample_f2_val                   : STD_LOGIC;
  SIGNAL sample_f2                       : samplT(5 DOWNTO 0, 15 DOWNTO 0);
  SIGNAL sample_f2_cic_s                 : samplT(5 DOWNTO 0, 15 DOWNTO 0);
  SIGNAL sample_f2_cic                   : sample_vector(5 DOWNTO 0, 15 DOWNTO 0);
  SIGNAL sample_f2_cic_val               : STD_LOGIC;
  
  SIGNAL sample_f3                       : samplT(5 DOWNTO 0, 15 DOWNTO 0);
  SIGNAL sample_f3_cic_s                 : samplT(5 DOWNTO 0, 15 DOWNTO 0);
  SIGNAL sample_f3_cic                   : sample_vector(5 DOWNTO 0, 15 DOWNTO 0);
  SIGNAL sample_f3_cic_val               : STD_LOGIC;

  -----------------------------------------------------------------------------
  --SIGNAL data_f0_in_valid : STD_LOGIC_VECTOR(159 DOWNTO 0) := (OTHERS => '0');
  --SIGNAL data_f1_in_valid : STD_LOGIC_VECTOR(159 DOWNTO 0) := (OTHERS => '0');
  --SIGNAL data_f2_in_valid : STD_LOGIC_VECTOR(159 DOWNTO 0) := (OTHERS => '0');
  --SIGNAL data_f3_in_valid : STD_LOGIC_VECTOR(159 DOWNTO 0) := (OTHERS => '0');
  -----------------------------------------------------------------------------

  SIGNAL sample_f0_wdata_s : STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
  SIGNAL sample_f1_wdata_s : STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
  SIGNAL sample_f2_wdata_s : STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
  SIGNAL sample_f3_wdata_s : STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
  
  SIGNAL sample_f0_val_s : STD_LOGIC;
  SIGNAL sample_f1_val_s : STD_LOGIC;

  -----------------------------------------------------------------------------
  -- CONFIG FILTER IIR f0 to f1
  -----------------------------------------------------------------------------
  CONSTANT f0_to_f1_CEL_NUMBER           : INTEGER := 5;
  CONSTANT f0_to_f1_COEFFICIENT_SIZE     : INTEGER := 10;
  CONSTANT f0_to_f1_POINT_POSITION       : INTEGER := 8;
  
  CONSTANT f0_to_f1_sos : COEFF_CEL_ARRAY_REAL(1 TO 5) :=
    (
      (1.0, -1.61171504942096,  1.0, 1.0, -1.68876443778669,  0.908610171614583),
      (1.0, -1.53324505744412,  1.0, 1.0, -1.51088513595779,  0.732564401274351),
      (1.0, -1.30646173160060,  1.0, 1.0, -1.30571711968384,  0.546869268827102),
      (1.0, -0.651038739239370, 1.0, 1.0, -1.08747326287406,  0.358436944718464),
      (1.0,  1.24322747034001,  1.0, 1.0, -0.929530176676438, 0.224862726961691)
    );
  CONSTANT f0_to_f1_gain : COEFF_CEL_REAL :=
    ( 0.566196896119831, 0.474937156750133, 0.347712822970540, 0.200868393871900, 0.0910613125308450, 1.0);

  CONSTANT coefs_iir_cel_f0_to_f1 : STD_LOGIC_VECTOR((f0_to_f1_CEL_NUMBER*f0_to_f1_COEFFICIENT_SIZE*5)-1 DOWNTO 0)
    :=  get_IIR_CEL_FILTER_CONFIG(
      f0_to_f1_COEFFICIENT_SIZE,
      f0_to_f1_POINT_POSITION,
      f0_to_f1_CEL_NUMBER,
      f0_to_f1_sos,
      f0_to_f1_gain);
  -----------------------------------------------------------------------------

  
BEGIN
  
  -----------------------------------------------------------------------------
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN              -- asynchronous reset (active low)
      sample_val_delay <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
      sample_val_delay <= sample_val;
    END IF;
  END PROCESS;

  -----------------------------------------------------------------------------
  ChanelLoop : FOR i IN 0 TO ChanelCount-1 GENERATE
    SampleLoop : FOR j IN 0 TO 15 GENERATE
      sample_filter_in(i, j) <= sample(i)(j);
    END GENERATE;

    sample_filter_in(i, 16) <= sample(i)(15);
    sample_filter_in(i, 17) <= sample(i)(15);
  END GENERATE;

  coefs_v2 <= CoefsInitValCst_v2;

  IIR_CEL_CTRLR_v2_1 : IIR_CEL_CTRLR_v2
    GENERIC MAP (
      tech         => 0,
      Mem_use      => Mem_use,          -- use_RAM
      Sample_SZ    => 18,
      Coef_SZ      => Coef_SZ,
      Coef_Nb      => 25,
      Coef_sel_SZ  => 5,
      Cels_count   => Cels_count,
      ChanelsCount => ChanelCount)
    PORT MAP (
      rstn           => rstn,
      clk            => clk,
      virg_pos       => 7,
      coefs          => coefs_v2,
      sample_in_val  => sample_val_delay,
      sample_in      => sample_filter_in,
      sample_out_val => sample_filter_v2_out_val,
      sample_out     => sample_filter_v2_out);

  -----------------------------------------------------------------------------
  -- DATA_SHAPING
  ----------------------------------------------------------------------------- 
  all_data_shaping_in_loop : FOR I IN 17 DOWNTO 0 GENERATE
    sample_data_shaping_f0_s(I) <= sample_filter_v2_out(0, I);
    sample_data_shaping_f1_s(I) <= sample_filter_v2_out(1, I);
    sample_data_shaping_f2_s(I) <= sample_filter_v2_out(2, I);
  END GENERATE all_data_shaping_in_loop;

  sample_data_shaping_f1_f0_s <= sample_data_shaping_f1_s - sample_data_shaping_f0_s;
  sample_data_shaping_f2_f1_s <= sample_data_shaping_f2_s - sample_data_shaping_f1_s;

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      sample_data_shaping_out_val <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
      sample_data_shaping_out_val <= sample_filter_v2_out_val;
    END IF;
  END PROCESS;

  SampleLoop_data_shaping : FOR j IN 0 TO 17 GENERATE
    PROCESS (clk, rstn)
    BEGIN
      IF rstn = '0' THEN
        sample_data_shaping_out(0, j) <= '0';
        sample_data_shaping_out(1, j) <= '0';
        sample_data_shaping_out(2, j) <= '0';
        sample_data_shaping_out(3, j) <= '0';
        sample_data_shaping_out(4, j) <= '0';
        sample_data_shaping_out(5, j) <= '0';
        sample_data_shaping_out(6, j) <= '0';
        sample_data_shaping_out(7, j) <= '0';
      ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
        sample_data_shaping_out(0, j) <= sample_filter_v2_out(0, j);
        IF data_shaping_SP0 = '1' THEN
          sample_data_shaping_out(1, j) <= sample_data_shaping_f1_f0_s(j);
        ELSE
          sample_data_shaping_out(1, j) <= sample_filter_v2_out(1, j);
        END IF;
        IF data_shaping_SP1 = '1' THEN
          sample_data_shaping_out(2, j) <= sample_data_shaping_f2_f1_s(j);
        ELSE
          sample_data_shaping_out(2, j) <= sample_filter_v2_out(2, j);
        END IF;
        sample_data_shaping_out(3, j) <= sample_filter_v2_out(3, j);
        sample_data_shaping_out(4, j) <= sample_filter_v2_out(4, j);
        sample_data_shaping_out(5, j) <= sample_filter_v2_out(5, j);
        sample_data_shaping_out(6, j) <= sample_filter_v2_out(6, j);
        sample_data_shaping_out(7, j) <= sample_filter_v2_out(7, j);
      END IF;
    END PROCESS;
  END GENERATE;

  sample_filter_v2_out_val_s <= sample_data_shaping_out_val;
  ChanelLoopOut : FOR i IN 0 TO 7 GENERATE
    SampleLoopOut : FOR j IN 0 TO 15 GENERATE
      sample_filter_v2_out_s(i, j) <= sample_data_shaping_out(i, j);
    END GENERATE;
  END GENERATE;
  -----------------------------------------------------------------------------
  -- F0 -- @24.576 kHz
  -----------------------------------------------------------------------------
  
  Downsampling_f0 : Downsampling
    GENERIC MAP (
      ChanelCount => 8,
      SampleSize  => 16,
      DivideParam => 4)
    PORT MAP (
      clk            => clk,
      rstn           => rstn,
      sample_in_val  => sample_filter_v2_out_val_s,
      sample_in      => sample_filter_v2_out_s,
      sample_out_val => sample_f0_val_s,
      sample_out     => sample_f0);

  sample_f0_val <= sample_f0_val_s;

  all_bit_sample_f0 : FOR I IN 15 DOWNTO 0 GENERATE
    sample_f0_wdata_s(I)      <= sample_f0(0, I);  -- V
    sample_f0_wdata_s(16*1+I) <= sample_f0(1, I) WHEN data_shaping_R0 = '1' ELSE sample_f0(3, I);  -- E1
    sample_f0_wdata_s(16*2+I) <= sample_f0(2, I) WHEN data_shaping_R0 = '1' ELSE sample_f0(4, I);  -- E2
    sample_f0_wdata_s(16*3+I) <= sample_f0(5, I);  -- B1
    sample_f0_wdata_s(16*4+I) <= sample_f0(6, I);  -- B2
    sample_f0_wdata_s(16*5+I) <= sample_f0(7, I);  -- B3
  END GENERATE all_bit_sample_f0;

  -----------------------------------------------------------------------------
  -- F1 -- @4096 Hz
  -----------------------------------------------------------------------------
  
  all_bit_sample_f0_f1 : FOR I IN 15 DOWNTO 0 GENERATE
    sample_f0_f1_s(0,I) <=  sample_f0(0,I);  --V
    sample_f0_f1_s(1,I) <=  sample_f0(1,I) WHEN data_shaping_R1 = '1' ELSE sample_f0(3,I); --E1
    sample_f0_f1_s(2,I) <=  sample_f0(2,I) WHEN data_shaping_R1 = '1' ELSE sample_f0(4,I); --E2
    sample_f0_f1_s(3,I) <=  sample_f0(5,I);  --B1
    sample_f0_f1_s(4,I) <=  sample_f0(6,I);  --B2
    sample_f0_f1_s(5,I) <=  sample_f0(7,I);  --B3
  END GENERATE all_bit_sample_f0_f1;
  all_bit_sample_f0_f1_extended : FOR I IN 17 DOWNTO 16 GENERATE
    sample_f0_f1_s(0,I) <= sample_f0(0,15);
    sample_f0_f1_s(1,I) <= sample_f0(1,15) WHEN data_shaping_R1 = '1' ELSE sample_f0(3,15); --E1
    sample_f0_f1_s(2,I) <= sample_f0(2,15) WHEN data_shaping_R1 = '1' ELSE sample_f0(4,15); --E2
    sample_f0_f1_s(3,I) <= sample_f0(5,15);  --B1
    sample_f0_f1_s(4,I) <= sample_f0(6,15);  --B2
    sample_f0_f1_s(5,I) <= sample_f0(7,15);  --B3
  END GENERATE all_bit_sample_f0_f1_extended;
  
  
  IIR_CEL_f0_to_f1 : IIR_CEL_CTRLR_v2
    GENERIC MAP (
      tech         => 0,
      Mem_use      => Mem_use,          -- use_RAM
      Sample_SZ    => 18,
      Coef_SZ      => f0_to_f1_COEFFICIENT_SIZE,
      Coef_Nb      => f0_to_f1_CEL_NUMBER*5,
      Coef_sel_SZ  => 5,
      Cels_count   => f0_to_f1_CEL_NUMBER,
      ChanelsCount => 6)
    PORT MAP (
      rstn           => rstn,
      clk            => clk,
      virg_pos       => f0_to_f1_POINT_POSITION,
      coefs          => coefs_iir_cel_f0_to_f1,
      
      sample_in_val  => sample_f0_val_s,
      sample_in      => sample_f0_f1_s,
      
      sample_out_val => sample_f1_val_s,
      sample_out     => sample_f1_s);
  
  Downsampling_f1 : Downsampling
    GENERIC MAP (
      ChanelCount => 6,
      SampleSize  => 18,
      DivideParam => 6)
    PORT MAP (
      clk            => clk,
      rstn           => rstn,
      sample_in_val  => sample_f1_val_s,
      sample_in      => sample_f1_s,
      sample_out_val => sample_f1_val,
      sample_out     => sample_f1);  

  all_bit_sample_f1 : FOR I IN 15 DOWNTO 0 GENERATE
    all_channel_sample_f1: FOR J IN 5 DOWNTO 0 GENERATE
      sample_f1_wdata_s(16*J+I) <= sample_f1(J, I); 
    END GENERATE all_channel_sample_f1;
  END GENERATE all_bit_sample_f1;

  -----------------------------------------------------------------------------
  -- F2 -- @256 Hz
  -- F3 -- @16 Hz
  -----------------------------------------------------------------------------
  all_bit_sample_f0_s : FOR I IN 15 DOWNTO 0 GENERATE
    sample_f0_s(0, I) <= sample_f0(0, I);  -- V
    sample_f0_s(1, I) <= sample_f0(1, I);  -- E1
    sample_f0_s(2, I) <= sample_f0(2, I);  -- E2
    sample_f0_s(3, I) <= sample_f0(5, I);  -- B1
    sample_f0_s(4, I) <= sample_f0(6, I);  -- B2
    sample_f0_s(5, I) <= sample_f0(7, I);  -- B3
  END GENERATE all_bit_sample_f0_s;

  
  cic_lfr_1: cic_lfr
    GENERIC MAP (
      tech         => 0,
      use_RAM_nCEL => Mem_use)
    PORT MAP (
      clk                => clk,
      rstn               => rstn,
      run                => '1',
      
      data_in            => sample_f0_s,
      data_in_valid      => sample_f0_val_s,
      
      data_out_16        => sample_f2_cic,
      data_out_16_valid  => sample_f2_cic_val,
      
      data_out_256       => sample_f3_cic,
      data_out_256_valid => sample_f3_cic_val);

  -----------------------------------------------------------------------------
  
  all_bit_sample_f2_cic : FOR I IN 15 DOWNTO 0 GENERATE
    all_channel_sample_f2_cic : FOR J IN 5 DOWNTO 0 GENERATE
      sample_f2_cic_s(J,I) <= sample_f2_cic(J,I);
    END GENERATE all_channel_sample_f2_cic;
  END GENERATE all_bit_sample_f2_cic;
  
  Downsampling_f2 : Downsampling
    GENERIC MAP (
      ChanelCount => 6,
      SampleSize  => 16,
      DivideParam => 6)
    PORT MAP (
      clk            => clk,
      rstn           => rstn,
      sample_in_val  => sample_f2_cic_val ,
      sample_in      => sample_f2_cic_s,
      sample_out_val => sample_f2_val,
      sample_out     => sample_f2);  
  
  all_bit_sample_f2 : FOR I IN 15 DOWNTO 0 GENERATE
    all_channel_sample_f2 : FOR J IN 5 DOWNTO 0 GENERATE
      sample_f2_wdata_s(16*J+I) <= sample_f2(J,I);
    END GENERATE all_channel_sample_f2;
  END GENERATE all_bit_sample_f2;
    
  -----------------------------------------------------------------------------
 
  all_bit_sample_f3_cic : FOR I IN 15 DOWNTO 0 GENERATE
    all_channel_sample_f3_cic : FOR J IN 5 DOWNTO 0 GENERATE
      sample_f3_cic_s(J,I) <= sample_f3_cic(J,I);
    END GENERATE all_channel_sample_f3_cic;
  END GENERATE all_bit_sample_f3_cic;
  
  Downsampling_f3 : Downsampling
    GENERIC MAP (
      ChanelCount => 6,
      SampleSize  => 16,
      DivideParam => 6)
    PORT MAP (
      clk            => clk,
      rstn           => rstn,
      sample_in_val  => sample_f3_cic_val ,
      sample_in      => sample_f3_cic_s,
      sample_out_val => sample_f3_val,
      sample_out     => sample_f3);
  
  all_bit_sample_f3 : FOR I IN 15 DOWNTO 0 GENERATE
    all_channel_sample_f3 : FOR J IN 5 DOWNTO 0 GENERATE
      sample_f3_wdata_s(16*J+I) <= sample_f3(J,I);
    END GENERATE all_channel_sample_f3;
  END GENERATE all_bit_sample_f3; 

  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  sample_f0_wdata <= sample_f0_wdata_s;
  sample_f1_wdata <= sample_f1_wdata_s;
  sample_f2_wdata <= sample_f2_wdata_s;
  sample_f3_wdata <= sample_f3_wdata_s;
  
END tb;
