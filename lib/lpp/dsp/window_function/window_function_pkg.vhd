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
USE IEEE.NUMERIC_STD.ALL;

PACKAGE window_function_pkg IS

  COMPONENT window_function
    GENERIC (
      SIZE_DATA          : INTEGER;
      SIZE_PARAM         : INTEGER;
      NB_POINT_BY_WINDOW : INTEGER);
    PORT (
      clk            : IN  STD_LOGIC;
      rstn           : IN  STD_LOGIC;
      restart_window : IN  STD_LOGIC;
      data_in        : IN  STD_LOGIC_VECTOR(SIZE_DATA-1 DOWNTO 0);
      data_in_valid  : IN  STD_LOGIC;
      data_out       : OUT STD_LOGIC_VECTOR(SIZE_DATA-1 DOWNTO 0);
      data_out_valid : OUT STD_LOGIC
      );
  END COMPONENT;

  COMPONENT WF_processing
    GENERIC (
      SIZE_DATA          : INTEGER;
      SIZE_PARAM         : INTEGER;
      NB_POINT_BY_WINDOW : INTEGER);
    PORT (
      clk            : IN  STD_LOGIC;
      rstn           : IN  STD_LOGIC;
      restart_window : IN  STD_LOGIC;
      data_in        : IN  STD_LOGIC_VECTOR(SIZE_DATA-1 DOWNTO 0);
      data_in_valid  : IN  STD_LOGIC;
      data_out       : OUT STD_LOGIC_VECTOR(SIZE_DATA-1 DOWNTO 0);
      data_out_valid : OUT STD_LOGIC;
      param_in       : IN  STD_LOGIC_VECTOR(SIZE_PARAM-1 DOWNTO 0);
      param_index    : OUT INTEGER RANGE 0 TO NB_POINT_BY_WINDOW-1;
      PARAM_ALL_POSITIVE : IN STD_LOGIC
      );
  END COMPONENT;

  COMPONENT WF_rom
    GENERIC (
      SIZE_PARAM         : INTEGER;
      NB_POINT_BY_WINDOW : INTEGER);
    PORT (
      data  : OUT STD_LOGIC_VECTOR(SIZE_PARAM-1 DOWNTO 0);
      index : IN  INTEGER RANGE 0 TO NB_POINT_BY_WINDOW-1;
      PARAM_ALL_POSITIVE : OUT STD_LOGIC);
  END COMPONENT;  
  
END window_function_pkg;
