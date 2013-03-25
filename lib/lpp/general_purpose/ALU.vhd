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
--                    Author : Alexis Jeandet
--                     Mail : alexis.jeandet@lpp.polytechnique.fr
----------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_1164.ALL;
LIBRARY lpp;
USE lpp.general_purpose.ALL;
--IDLE                  = 0000
--MAC                   = 0001
--MULT                  = 0010 and set MULT in ADD reg
--ADD                   = 0011
--CLRMAC                = 0100


ENTITY ALU IS
  GENERIC(
    Arith_en   : INTEGER := 1;
    Logic_en   : INTEGER := 1;
    Input_SZ_1 : INTEGER := 16;
    Input_SZ_2 : INTEGER := 9

    );
  PORT(
    clk   : IN  STD_LOGIC;
    reset : IN  STD_LOGIC;
    ctrl  : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    OP1   : IN  STD_LOGIC_VECTOR(Input_SZ_1-1 DOWNTO 0);
    OP2   : IN  STD_LOGIC_VECTOR(Input_SZ_2-1 DOWNTO 0);
    RES   : OUT STD_LOGIC_VECTOR(Input_SZ_1+Input_SZ_2-1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE ar_ALU OF ALU IS

  SIGNAL clr_MAC : STD_LOGIC := '1';
  
BEGIN
  clr_MAC <= '1' WHEN ctrl = "0100" OR ctrl = "0101" OR ctrl = "0110"  ELSE '0';

  arith : IF Arith_en = 1 GENERATE
    MACinst : MAC
      GENERIC MAP(Input_SZ_1, Input_SZ_2)
      PORT MAP(clk, reset, clr_MAC, ctrl(1 DOWNTO 0), OP1, OP2, RES);
  END GENERATE;

END ARCHITECTURE;












