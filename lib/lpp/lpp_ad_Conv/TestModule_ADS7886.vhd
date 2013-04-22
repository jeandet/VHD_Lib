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
--                    Author :  Jean-christophe PELLION
--                     Mail :   jean-christophe.pellion@lpp.polytechnique.fr
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_signed.ALL;
USE IEEE.MATH_real.ALL;

ENTITY TestModule_ADS7886 IS
  GENERIC (
    freq      : INTEGER := 24;
    amplitude : INTEGER := 3000;
    impulsion : INTEGER := 0            -- 1 => impulsion generation
    );
  PORT (
    -- CONV --
    cnv_run : IN STD_LOGIC;
    cnv : IN STD_LOGIC;

    -- DATA --
    sck : IN  STD_LOGIC;
    sdo : OUT STD_LOGIC
    );    
END TestModule_ADS7886;

ARCHITECTURE beh OF TestModule_ADS7886 IS
  SIGNAL reg : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL n   : INTEGER := 0;
BEGIN  -- beh

  PROCESS (cnv, sck)
  BEGIN  -- PROCESS
    IF cnv = '0' AND cnv'EVENT THEN
      n   <= n + 1;
      IF impulsion = 1 THEN
        IF n = 1 THEN
          reg <= conv_std_logic_vector(integer(REAL(amplitude)) , 16);
        ELSE
          reg <= conv_std_logic_vector(integer(REAL(0)) , 16);
        END IF;
      ELSE
        reg <= conv_std_logic_vector(integer(REAL(amplitude) * SIN(MATH_2_PI*REAL(n)/REAL(freq))) , 16);
      END IF;
    ELSIF sck'EVENT AND sck = '0' THEN  -- rising clock edge
      reg(0)           <= 'X';
      reg(15 DOWNTO 1) <= reg(14 DOWNTO 0);
    END IF;
  END PROCESS;
  sdo              <= reg(15);
  
END beh;
