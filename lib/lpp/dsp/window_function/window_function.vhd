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
USE lpp.general_purpose.ALL;
USE lpp.window_function_pkg.ALL;
USE lpp.data_type_pkg.ALL;

ENTITY window_function IS
  GENERIC (
    DATA_SIZE  : INTEGER := 16;
    PARAM_SIZE : INTEGER := 10;
    WINDOWS_PARAM : array_std_logic_vector_16b(0 TO 255)
    );

  PORT (
    clk  : IN STD_LOGIC;
    rstn : IN STD_LOGIC;

    restart_window : IN STD_LOGIC;

    data_in       : IN STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
    data_in_valid : IN STD_LOGIC;

    data_out       : OUT STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
    data_out_valid : OUT STD_LOGIC
    );

END window_function;

ARCHITECTURE beh OF window_function IS
  CONSTANT NB_POINT_BY_WINDOW     : INTEGER                      := 256;

  SIGNAL param_counter          : INTEGER RANGE 0 TO NB_POINT_BY_WINDOW-1;
  
  SIGNAL data_x_param           : STD_LOGIC_VECTOR(DATA_SIZE + PARAM_SIZE - 1 DOWNTO 0);
  
  SIGNAL windows_param_selected_s : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL windows_param_selected   : STD_LOGIC_VECTOR(PARAM_SIZE-1 DOWNTO 0);
  SIGNAL data_in_valid_s : STD_LOGIC;
  SIGNAL data_in_s : STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
    
BEGIN

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      param_counter <= 0;
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
      IF restart_window = '1' THEN
        param_counter <= 0;
      ELSE
        IF data_in_valid = '1' THEN
          IF param_counter < 255 THEN
            param_counter <= param_counter + 1;
          ELSE
            param_counter <= 0;
          END IF;
        END IF;
      END IF;
    END IF;
  END PROCESS;

  data_in_valid_s        <= data_in_valid;
  data_in_s              <= data_in;
  windows_param_selected_s <= WINDOWS_PARAM(param_counter);
  windows_param_selected   <= windows_param_selected_s(15 DOWNTO 16 - PARAM_SIZE);

  WINDOWS_Multiplier : Multiplier
    GENERIC MAP (
      Input_SZ_A => DATA_SIZE,
      Input_SZ_B => PARAM_SIZE)
    PORT MAP (
      clk   => clk,
      reset => rstn,
      
      mult  => data_in_valid_s,
      OP1   => data_in_s,
      OP2   => windows_param_selected,
      
      RES   => data_x_param);

  data_out <= data_x_param(DATA_SIZE + PARAM_SIZE-1 DOWNTO PARAM_SIZE);
  
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      data_out_valid <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
      data_out_valid <= data_in_valid_s;
    END IF;
  END PROCESS;
  
END beh;
