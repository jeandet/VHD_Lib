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



ENTITY Adder IS
  GENERIC(
    Input_SZ_A : INTEGER := 16;
    Input_SZ_B : INTEGER := 16

    );
  PORT(
    clk   : IN  STD_LOGIC;
    reset : IN  STD_LOGIC;
    clr   : IN  STD_LOGIC;
    load  : IN  STD_LOGIC;
    add   : IN  STD_LOGIC;
    OP1   : IN  STD_LOGIC_VECTOR(Input_SZ_A-1 DOWNTO 0);
    OP2   : IN  STD_LOGIC_VECTOR(Input_SZ_B-1 DOWNTO 0);
    RES   : OUT STD_LOGIC_VECTOR(Input_SZ_A-1 DOWNTO 0)
    );
END ENTITY;




ARCHITECTURE ar_Adder OF Adder IS

  SIGNAL REG    : STD_LOGIC_VECTOR(Input_SZ_A-1 DOWNTO 0);
  SIGNAL RESADD : STD_LOGIC_VECTOR(Input_SZ_A-1 DOWNTO 0);

BEGIN

  RES    <= REG;
  RESADD <= STD_LOGIC_VECTOR(resize(SIGNED(OP1)+SIGNED(OP2), Input_SZ_A));

  PROCESS(clk, reset)
  BEGIN
    IF reset = '0' THEN
      REG <= (OTHERS => '0');
    ELSIF clk'EVENT AND clk = '1' then
      IF clr = '1' THEN
        REG <= (OTHERS => '0');
      ELSIF add = '1' THEN
        REG <= RESADD;
      ELSIF load = '1' THEN
        REG <= OP2;
      END IF;
    END IF;
  END PROCESS;
END ar_Adder;
