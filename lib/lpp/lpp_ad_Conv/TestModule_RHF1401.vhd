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

ENTITY TestModule_RHF1401 IS
  GENERIC (
    freq      : INTEGER := 24;
    amplitude : INTEGER := 3000;
    impulsion : INTEGER := 0            -- 1 => impulsion generation
    );
  PORT (
    -- CONV --
    ADC_smpclk  : IN STD_LOGIC;
    ADC_OEB_bar : IN STD_LOGIC;
    
    -- DATA --
    ADC_data : OUT STD_LOGIC_VECTOR(13 DOWNTO 0)
    );    
END TestModule_RHF1401;

ARCHITECTURE beh OF TestModule_RHF1401 IS
  SIGNAL reg : STD_LOGIC_VECTOR(13 DOWNTO 0);
  SIGNAL n   : INTEGER := 0;
BEGIN  -- beh

  PROCESS (ADC_smpclk)
  BEGIN  -- PROCESS
    IF ADC_smpclk = '0' AND ADC_smpclk'EVENT THEN
      n   <= n + 1;
      IF impulsion = 1 THEN
        IF n = 1 THEN
          reg <= conv_std_logic_vector(integer(REAL(amplitude)) , 14);
        ELSE
          reg <= conv_std_logic_vector(integer(REAL(0)) , 14);
        END IF;
      ELSE
        reg <= conv_std_logic_vector(integer(REAL(amplitude) * SIN(MATH_2_PI*REAL(n)/REAL(freq))) , 14);
      END IF;
    END IF;
  END PROCESS;

  ADC_data <= reg WHEN ADC_OEB_bar = '0' ELSE (OTHERS => 'Z');
  
END beh;
