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

LIBRARY lpp;
USE lpp.data_type_pkg.ALL;

PACKAGE cic_pkg IS

  -----------------------------------------------------------------------------
  COMPONENT cic
    GENERIC (
      D_delay_number                   : INTEGER;
      S_stage_number                   : INTEGER;
      R_downsampling_decimation_factor : INTEGER;
      b_data_size                      : INTEGER;
      b_grow                           : INTEGER);
    PORT (
      clk            : IN  STD_LOGIC;
      rstn           : IN  STD_LOGIC;
      run            : IN  STD_LOGIC;
      data_in        : IN  STD_LOGIC_VECTOR(b_data_size-1 DOWNTO 0);
      data_in_valid  : IN  STD_LOGIC;
      data_out       : OUT STD_LOGIC_VECTOR(b_data_size-1 DOWNTO 0);
      data_out_valid : OUT STD_LOGIC);
  END COMPONENT;
  -----------------------------------------------------------------------------
  COMPONENT cic_integrator
    GENERIC (
      b_data_size : INTEGER);
    PORT (
      clk            : IN  STD_LOGIC;
      rstn           : IN  STD_LOGIC;
      run            : IN  STD_LOGIC;
      data_in        : IN  STD_LOGIC_VECTOR(b_data_size-1 DOWNTO 0);
      data_in_valid  : IN  STD_LOGIC;
      data_out       : OUT STD_LOGIC_VECTOR(b_data_size-1 DOWNTO 0);
      data_out_valid : OUT STD_LOGIC);
  END COMPONENT;

  COMPONENT cic_downsampler
    GENERIC (
      R_downsampling_decimation_factor : INTEGER;
      b_data_size                      : INTEGER);
    PORT (
      clk            : IN  STD_LOGIC;
      rstn           : IN  STD_LOGIC;
      run            : IN  STD_LOGIC;
      data_in        : IN  STD_LOGIC_VECTOR(b_data_size-1 DOWNTO 0);
      data_in_valid  : IN  STD_LOGIC;
      data_out       : OUT STD_LOGIC_VECTOR(b_data_size-1 DOWNTO 0);
      data_out_valid : OUT STD_LOGIC);
  END COMPONENT;

  COMPONENT cic_comb
    GENERIC (
      b_data_size    : INTEGER;
      D_delay_number : INTEGER);
    PORT (
      clk            : IN  STD_LOGIC;
      rstn           : IN  STD_LOGIC;
      run            : IN  STD_LOGIC;
      data_in        : IN  STD_LOGIC_VECTOR(b_data_size-1 DOWNTO 0);
      data_in_valid  : IN  STD_LOGIC;
      data_out       : OUT STD_LOGIC_VECTOR(b_data_size-1 DOWNTO 0);
      data_out_valid : OUT STD_LOGIC);
  END COMPONENT;
  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  COMPONENT cic_lfr
    GENERIC (
      tech         : INTEGER;
      use_RAM_nCEL : INTEGER);
    PORT (
      clk                : IN  STD_LOGIC;
      rstn               : IN  STD_LOGIC;
      run                : IN  STD_LOGIC;
      data_in            : IN  sample_vector(5 DOWNTO 0, 15 DOWNTO 0);
      data_in_valid      : IN  STD_LOGIC;
      data_out_16        : OUT sample_vector(5 DOWNTO 0, 15 DOWNTO 0);
      data_out_16_valid  : OUT STD_LOGIC;
      data_out_256       : OUT sample_vector(5 DOWNTO 0, 15 DOWNTO 0);
      data_out_256_valid : OUT STD_LOGIC);
  END COMPONENT;

  COMPONENT cic_lfr_control
    PORT (
      clk                : IN  STD_LOGIC;
      rstn               : IN  STD_LOGIC;
      run                : IN  STD_LOGIC;
      data_in_valid      : IN  STD_LOGIC;
      data_out_16_valid  : OUT STD_LOGIC;
      data_out_256_valid : OUT STD_LOGIC;
      OPERATION          : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
  END COMPONENT;

  COMPONENT cic_lfr_add_sub
    PORT (
      clk            : IN  STD_LOGIC;
      rstn           : IN  STD_LOGIC;
      run            : IN  STD_LOGIC;
      OP             : IN  STD_LOGIC_VECTOR( 1 DOWNTO 0);
      data_in_A      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
      data_in_B      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
      data_in_Carry  : IN  STD_LOGIC;
      data_out       : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      data_out_Carry : OUT STD_LOGIC);
  END COMPONENT;

  COMPONENT cic_lfr_address_gen
    PORT (
      clk        : IN  STD_LOGIC;
      rstn       : IN  STD_LOGIC;
      run        : IN  STD_LOGIC;
      addr_base  : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      addr_init  : IN STD_LOGIC;
      addr_add_1 : IN STD_LOGIC;
      addr       : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
  END COMPONENT;

  
  -----------------------------------------------------------------------------
END cic_pkg;
