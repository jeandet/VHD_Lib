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

LIBRARY techmap;
USE techmap.gencomp.ALL;

LIBRARY lpp;
USE lpp.iir_filter.ALL;
USE lpp.FILTERcfg.ALL;
USE lpp.lpp_lfr_filter_coeff.ALL;
USE lpp.general_purpose.ALL;

ENTITY IIR_CEL_TEST_v3 IS
  PORT (
    rstn : IN STD_LOGIC;
    clk  : IN STD_LOGIC;

    sample_in1_val : IN STD_LOGIC;
    sample_in1     : IN samplT(7 DOWNTO 0, 17 DOWNTO 0);
    sample_in2_val : IN STD_LOGIC;
    sample_in2     : IN samplT(7 DOWNTO 0, 17 DOWNTO 0);

    sample_out1_val : OUT STD_LOGIC;
    sample_out1     : OUT samplT(7 DOWNTO 0, 17 DOWNTO 0);
    sample_out2_val : OUT STD_LOGIC;
    sample_out2     : OUT samplT(7 DOWNTO 0, 17 DOWNTO 0)
    );
END IIR_CEL_TEST_v3;

ARCHITECTURE beh OF IIR_CEL_TEST_v3 IS
  CONSTANT ChanelCount      : INTEGER := 8;
  CONSTANT Coef_SZ          : INTEGER := 9;
  CONSTANT CoefCntPerCel    : INTEGER := 6;
  CONSTANT CoefPerCel       : INTEGER := 5;
  CONSTANT Cels_count       : INTEGER := 5;
  
  SIGNAL coefs_v2           : STD_LOGIC_VECTOR((Coef_SZ*CoefPerCel*Cels_count)-1 DOWNTO 0);


  -----------------------------------------------------------------------------
  CONSTANT CEL_NUMBER           : INTEGER := 5;
  CONSTANT COEFFICIENT_SIZE     : INTEGER := 9;
  CONSTANT POINT_POSITION       : INTEGER := 7;
  CONSTANT COEFFICIENT_PER_CEL  : INTEGER := 5;
  SIGNAL coeff_test : STD_LOGIC_VECTOR((CEL_NUMBER * 5 * COEFFICIENT_SIZE)-1 DOWNTO 0);
  SIGNAL f0_to_f1_sos : COEFF_CEL_ARRAY_REAL(1 TO 5) :=
    (
      (1.0, -1.61171504942096,  1.0, 1.0, -1.68876443778669,  0.908610171614583),
      (1.0, -1.53324505744412,  1.0, 1.0, -1.51088513595779,  0.732564401274351),
      (1.0, -1.30646173160060,  1.0, 1.0, -1.30571711968384,  0.546869268827102),
      (1.0, -0.651038739239370, 1.0, 1.0, -1.08747326287406,  0.358436944718464),
      (1.0,  1.24322747034001,  1.0, 1.0, -0.929530176676438, 0.224862726961691)
    );
  SIGNAL f0_to_f1_gain : COEFF_CEL_REAL :=
    ( 0.566196896119831, 0.474937156750133, 0.347712822970540, 0.200868393871900, 0.0910613125308450, 1.0);

  SUBTYPE COEFFICIENT IS STD_LOGIC_VECTOR(COEFFICIENT_SIZE-1 DOWNTO 0);
  TYPE COEFFICIENT_CEL    IS ARRAY (1 TO 5) OF COEFFICIENT;
  TYPE COEFFICIENT_GLOBAL IS ARRAY (INTEGER RANGE <>) OF COEFFICIENT_CEL;

  SIGNAL coeff_test_2 : COEFFICIENT_GLOBAL(1 TO 5);
  -----------------------------------------------------------------------------
  SIGNAL f_to_f0_sos : COEFF_CEL_ARRAY_REAL(1 TO 5) :=
    (
      (1.0, -1.61171504942096,  1.0, 1.0, -1.68876443778669,  0.908610171614583),
      (1.0, -1.53324505744412,  1.0, 1.0, -1.51088513595779,  0.732564401274351),
      (1.0, -1.30646173160060,  1.0, 1.0, -1.30571711968384,  0.546869268827102),
      (1.0, -0.651038739239370, 1.0, 1.0, -1.08747326287406,  0.358436944718464),
      (1.0,  1.24322747034001,  1.0, 1.0, -0.929530176676438, 0.224862726961691)
    );
  SIGNAL f_to_f0_gain : COEFF_CEL_REAL :=
    ( 0.566196896119831, 0.474937156750133, 0.347712822970540, 0.200868393871900, 0.0910613125308450, 1.0);
  
BEGIN  -- beh

  coeff_test <=
    get_IIR_CEL_FILTER_CONFIG(
      COEFFICIENT_SIZE, POINT_POSITION, CEL_NUMBER,
      f0_to_f1_sos, f0_to_f1_gain);

  all_cel: FOR I IN 0 TO 4 GENERATE
    all_coeff: FOR J IN 0 TO 4 GENERATE
      coeff_test_2(I+1)(J+1) <=
        coeff_test((I*5+J+1)*COEFFICIENT_SIZE-1 DOWNTO (I*5+J)*COEFFICIENT_SIZE);
    END GENERATE all_coeff;
  END GENERATE all_cel;
  
  
  coefs_v2 <= CoefsInitValCst_v2;

  --IIR_CEL_CTRLR_v2_1 : IIR_CEL_CTRLR_v2
  --  GENERIC MAP (
  --    tech         => 0,
  --    Mem_use      => use_CEL,          -- use_RAM
  --    Sample_SZ    => 18,
  --    Coef_SZ      => Coef_SZ,
  --    Coef_Nb      => 25,
  --    Coef_sel_SZ  => 5,
  --    Cels_count   => Cels_count,
  --    ChanelsCount => ChanelCount)
  --  PORT MAP (
  --    rstn           => rstn,
  --    clk            => clk,
  --    virg_pos       => 7,
  --    coefs          => coefs_v2,
  --    sample_in_val  => sample_in_val,
  --    sample_in      => sample_in,
  --    sample_out_val => sample_out_val,
  --    sample_out     => sample_out);

  IIR_CEL_CTRLR_v3_1: IIR_CEL_CTRLR_v3
    GENERIC MAP (
      tech         => 0,
      Mem_use      => use_CEL,
      Sample_SZ    => 18,
      Coef_SZ      => Coef_SZ,
      Coef_Nb      => 25,
      Coef_sel_SZ  => 5,
      Cels_count   => Cels_count,
      ChanelsCount => ChanelCount)
    PORT MAP (
      rstn            => rstn,
      clk             => clk,
      virg_pos        => 7,
      coefs           => coefs_v2,
      sample_in1_val  => sample_in1_val,
      sample_in1      => sample_in1,
      sample_in2_val  => sample_in2_val,
      sample_in2      => sample_in2,
      sample_out1_val => sample_out1_val,
      sample_out1     => sample_out1,
      sample_out2_val => sample_out2_val,
      sample_out2     => sample_out2);

END beh;
