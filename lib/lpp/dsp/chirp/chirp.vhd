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
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_signed.ALL;
USE IEEE.MATH_real.ALL;

ENTITY chirp IS
  
  GENERIC (
    LOW_FREQUENCY_LIMIT  : INTEGER := 0;
    HIGH_FREQUENCY_LIMIT : INTEGER := 2000;
    NB_POINT_TO_GEN      : INTEGER := 10000;
    AMPLITUDE            : INTEGER := 100;
    NB_BITS              : INTEGER := 16);

  PORT (
    clk      : IN  STD_LOGIC;
    rstn     : IN  STD_LOGIC;
    run      : IN  STD_LOGIC;
    
    data_ack : IN  STD_LOGIC;
    data     : OUT STD_LOGIC_VECTOR(NB_BITS-1 DOWNTO 0)
    );

END chirp;

ARCHITECTURE beh OF chirp IS

  SIGNAL reg : STD_LOGIC_VECTOR(NB_BITS-1 DOWNTO 0);
  SIGNAL n : INTEGER;
  SIGNAL current_time : REAL := REAL(0);
  SIGNAL freq_chirp : REAL := REAL(0);
BEGIN  -- beh

  current_time <= REAL(n) / REAL(NB_POINT_TO_GEN);
  freq_chirp   <= REAL(LOW_FREQUENCY_LIMIT) + (REAL(HIGH_FREQUENCY_LIMIT) - REAL(LOW_FREQUENCY_LIMIT))*current_time;
  
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      reg <= (OTHERS => '0');
      n <= 0;
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      IF run = '0' THEN
        reg <= (OTHERS => '0');
        n   <= 0;
      ELSE
        IF data_ack = '1' THEN
          IF n < NB_POINT_TO_GEN THEN
            n <= n+1;
            reg <= conv_std_logic_vector(INTEGER(REAL(AMPLITUDE) * SIN(MATH_2_PI*current_time*freq_chirp)),NB_BITS);
          ELSE
            reg <= (OTHERS => '0');
          END IF;
        END IF;
      END IF;
    END IF;
  END PROCESS;
  
  data <= reg;

END beh;
