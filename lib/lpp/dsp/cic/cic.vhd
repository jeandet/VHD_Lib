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
USE lpp.cic_pkg.ALL;

ENTITY cic IS
  
  GENERIC (
    D_delay_number                   : INTEGER := 2;
    S_stage_number                   : INTEGER := 3;
    R_downsampling_decimation_factor : INTEGER := 16;
    
    b_data_size                      : INTEGER := 16;
    b_grow                           : INTEGER := 5 --
    );

  PORT (
    clk            : IN  STD_LOGIC;
    rstn           : IN  STD_LOGIC;
    run            : IN  STD_LOGIC;
    
    data_in        : IN  STD_LOGIC_VECTOR(b_data_size-1 DOWNTO 0);
    data_in_valid  : IN  STD_LOGIC;

    data_out       : OUT STD_LOGIC_VECTOR(b_data_size-1 DOWNTO 0);
    data_out_valid : OUT STD_LOGIC
    );

END cic;

ARCHITECTURE beh OF cic IS

  TYPE data_vector IS ARRAY (NATURAL RANGE <>) OF STD_LOGIC_VECTOR(b_data_size + b_grow - 1 DOWNTO 0);

  SIGNAL I_data  : data_vector(S_stage_number DOWNTO 0);
  SIGNAL I_valid : STD_LOGIC_VECTOR(S_stage_number DOWNTO 0);

  SIGNAL C_data  : data_vector(S_stage_number DOWNTO 0);
  SIGNAL C_valid : STD_LOGIC_VECTOR(S_stage_number DOWNTO 0);
  
BEGIN  -- beh
  -----------------------------------------------------------------------------
  I_valid(0)                        <= data_in_valid;
  I_data(0)(b_data_size-1 DOWNTO 0) <= data_in;
  all_bit_grow: FOR I IN 0 TO b_grow-1 GENERATE
    I_data(0)(I+b_data_size) <= data_in(b_data_size-1);
  END GENERATE all_bit_grow;
  -----------------------------------------------------------------------------
  all_I: FOR S_i IN 1 TO S_stage_number GENERATE
    I_1: cic_integrator
      GENERIC MAP (
        b_data_size => b_data_size + b_grow)
      PORT MAP (
        clk            => clk,
        rstn           => rstn,
        run            => run,
        
        data_in        => I_data(S_i-1),
        data_in_valid  => I_valid(S_i-1),
        data_out       => I_data(S_i),
        data_out_valid => I_valid(S_i)
        );   
  END GENERATE all_I;
  -----------------------------------------------------------------------------  
  cic_downsampler_1: cic_downsampler
    GENERIC MAP (
      R_downsampling_decimation_factor => R_downsampling_decimation_factor,
      b_data_size                      => b_data_size + b_grow)
    PORT MAP (
      clk            => clk,
      rstn           => rstn,
      run            => run,
      data_in        => I_data(S_stage_number),
      data_in_valid  => I_valid(S_stage_number),
      data_out       => C_data(0),
      data_out_valid => C_valid(0));
  -----------------------------------------------------------------------------
  all_C: FOR S_i IN 1 TO S_stage_number GENERATE
    cic_comb_1: cic_comb
      GENERIC MAP (
        b_data_size    => b_data_size + b_grow,
        D_delay_number => D_delay_number)
      PORT MAP (
        clk            => clk,
        rstn           => rstn,
        run            => run,
        
        data_in        => C_data(S_i-1),
        data_in_valid  => C_valid(S_i-1),
        data_out       => C_data(S_i),
        data_out_valid => C_valid(S_i));
  END GENERATE all_C;
  -----------------------------------------------------------------------------
  data_out       <= C_data(S_stage_number)(b_data_size + b_grow - 1 DOWNTO b_grow);
  data_out_valid <= C_valid(S_stage_number);
  -----------------------------------------------------------------------------
END beh;

