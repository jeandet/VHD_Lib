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
use ieee.math_real.all;
USE ieee.numeric_std.ALL;

LIBRARY lpp;
USE lpp.general_purpose.ALL;
USE lpp.window_function_pkg.ALL;

ENTITY WF_processing IS
  GENERIC (
    SIZE_DATA  : INTEGER := 16;
    SIZE_PARAM : INTEGER := 10;
    NB_POINT_BY_WINDOW : INTEGER := 256    
    );

  PORT (
    clk  : IN STD_LOGIC;
    rstn : IN STD_LOGIC;
    --ctrl
    restart_window : IN STD_LOGIC;
    --data_in
    data_in       : IN STD_LOGIC_VECTOR(SIZE_DATA-1 DOWNTO 0);
    data_in_valid : IN STD_LOGIC;
    --data_out
    data_out       : OUT STD_LOGIC_VECTOR(SIZE_DATA-1 DOWNTO 0);
    data_out_valid : OUT STD_LOGIC;
    
    --window parameter interface
    param_in    : IN STD_LOGIC_VECTOR(SIZE_PARAM-1 DOWNTO 0);
    param_index : OUT INTEGER RANGE 0 TO NB_POINT_BY_WINDOW-1 
    );

END WF_processing;

ARCHITECTURE beh OF WF_processing IS
  CONSTANT NB_BITS_COUNTER : INTEGER := INTEGER(ceil(log2(REAL(NB_POINT_BY_WINDOW))));
  
  SIGNAL data_x_param      : STD_LOGIC_VECTOR(SIZE_DATA + SIZE_PARAM - 1 DOWNTO 0);
  SIGNAL windows_counter_s : STD_LOGIC_VECTOR(NB_BITS_COUNTER-1 DOWNTO 0);
  
BEGIN

  WINDOWS_counter: general_counter
    GENERIC MAP (
      CYCLIC          => '1',
      NB_BITS_COUNTER => NB_BITS_COUNTER,
      RST_VALUE       => 0)
    PORT MAP (
      clk       => clk,
      rstn      => rstn,
      MAX_VALUE => STD_LOGIC_VECTOR(to_unsigned(NB_POINT_BY_WINDOW-1, NB_BITS_COUNTER)),
      set       => restart_window,
      set_value => STD_LOGIC_VECTOR(to_unsigned(0, NB_BITS_COUNTER)),
      add1      => data_in_valid,
      counter   => windows_counter_s);
  
  param_index <= to_integer(UNSIGNED(windows_counter_s));

  WINDOWS_Multiplier : Multiplier
    GENERIC MAP (
      Input_SZ_A => SIZE_DATA,
      Input_SZ_B => SIZE_PARAM)
    PORT MAP (
      clk   => clk,
      reset => rstn,
      
      mult  => data_in_valid,
      OP1   => data_in,
      OP2   => param_in,
      
      RES   => data_x_param);

  data_out <= data_x_param(SIZE_DATA + SIZE_PARAM-1 DOWNTO SIZE_PARAM);

  WINDOWS_REG: SYNC_FF
    GENERIC MAP (
      NB_FF_OF_SYNC => 1)
    PORT MAP (
      clk    => clk,
      rstn   => rstn,
      A      => data_in_valid,
      A_sync => data_out_valid);
  
END beh;
