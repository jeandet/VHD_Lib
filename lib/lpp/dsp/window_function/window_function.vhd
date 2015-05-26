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

ENTITY window_function IS
  GENERIC (
    DATA_SIZE  : INTEGER := 16;
    PARAM_SIZE : INTEGER := 10
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
  
  SUBTYPE  RANGE_NB_BIT_BY_WINDOW_PARAM IS INTEGER RANGE 1 TO DATA_SIZE;
  CONSTANT NB_BIT_BY_WINDOW_PARAM : RANGE_NB_BIT_BY_WINDOW_PARAM := 16;
  CONSTANT NB_POINT_BY_WINDOW     : INTEGER                      := 256;

  TYPE   WINDOWS_PARAM_TYPE IS ARRAY (INTEGER RANGE <>) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
  CONSTANT windows_param_lfr_sigmoide : WINDOWS_PARAM_TYPE(0 TO 32) :=
    ( X"0000",X"0012",X"002E",X"005B", X"00A2",X"0113",X"01C7",X"02E0", --0   - 7
      X"0498",X"073A",X"0B37",X"110D", X"193C",X"240F",X"3147",X"3FF7", --8  - 15
      X"4EA7",X"5BDF",X"66B2",X"6EE1", X"74B7",X"78B4",X"7B56",X"7D0E", --16 - 23
      X"7E27",X"7EDB",X"7F4C",X"7F93", X"7FC0",X"7FDC",X"7FEE",X"7FF9", --24 - 31
      X"7FFF" ); --32
  CONSTANT windows_param_lfr_rampe : WINDOWS_PARAM_TYPE(0 TO 32) :=
    ( X"0000",X"03E1",X"07C2",X"0BA3", X"0F84",X"1365",X"1746",X"1B27",
      X"1F08",X"22E8",X"26C9",X"2AAA", X"2E8B",X"326C",X"364D",X"3A2E",
      X"3E0F",X"41F0",X"45D1",X"49B2", X"4D93",X"5174",X"5555",X"5936",
      X"5D17",X"60F7",X"64D8",X"68B9", X"6C9A",X"707B",X"745C",X"783D",
      X"7FFF"  );
  CONSTANT windows_param_lfr_echelon : WINDOWS_PARAM_TYPE(0 TO 32) :=
    ( X"0000",X"0000",X"0000",X"0000", X"0000",X"0000",X"0000",X"0000",
      X"0000",X"0000",X"0000",X"0000", X"0000",X"0000",X"0000",X"0000",
      X"FFFF",X"FFFF",X"FFFF",X"FFFF", X"FFFF",X"FFFF",X"FFFF",X"FFFF",
      X"FFFF",X"FFFF",X"FFFF",X"FFFF", X"FFFF",X"FFFF",X"FFFF",X"FFFF",
      X"FFFF");
  
  CONSTANT windows_param_lfr : WINDOWS_PARAM_TYPE(0 TO 32) := windows_param_lfr_sigmoide;

  SIGNAL windows_param : WINDOWS_PARAM_TYPE(0 TO NB_POINT_BY_WINDOW-1);

  SIGNAL param_counter          : INTEGER RANGE 0 TO NB_POINT_BY_WINDOW-1;
  
  SIGNAL data_x_param           : STD_LOGIC_VECTOR(DATA_SIZE + PARAM_SIZE - 1 DOWNTO 0);
  
  SIGNAL windows_param_selected_s : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL windows_param_selected   : STD_LOGIC_VECTOR(PARAM_SIZE-1 DOWNTO 0);
  SIGNAL data_in_valid_s : STD_LOGIC;
  SIGNAL data_in_s : STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
    
BEGIN
  
  all_windows_param_0: FOR I IN 0 TO 31 GENERATE
    windows_param(I) <= windows_param_lfr(I); 
  END GENERATE all_windows_param_0;
  all_windows_param_1: FOR I IN 32 TO 223 GENERATE
    windows_param(I) <= windows_param_lfr(32); 
  END GENERATE all_windows_param_1;
  all_windows_param_2: FOR I IN 224 TO 255 GENERATE
    windows_param(I) <= windows_param_lfr(255-I); 
  END GENERATE all_windows_param_2;

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
  windows_param_selected_s <= windows_param(param_counter);
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