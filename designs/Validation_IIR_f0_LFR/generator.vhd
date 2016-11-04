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
use ieee.numeric_std.all;
USE IEEE.std_logic_signed.ALL;
USE IEEE.MATH_real.ALL;

ENTITY generator IS
  
  GENERIC (
    AMPLITUDE            : INTEGER := 100;
    NB_BITS              : INTEGER := 16
    );

  PORT (
    clk      : IN  STD_LOGIC;
    rstn     : IN  STD_LOGIC;
    run      : IN  STD_LOGIC;
    
    data_ack : IN  STD_LOGIC;
    offset   : IN  STD_LOGIC_VECTOR(NB_BITS-1 DOWNTO 0);
    data     : OUT STD_LOGIC_VECTOR(NB_BITS-1 DOWNTO 0)
    );

END generator;

ARCHITECTURE beh OF generator IS

  SIGNAL reg : STD_LOGIC_VECTOR(NB_BITS-1 DOWNTO 0);
BEGIN  -- beh

  PROCESS (clk, rstn)
    variable seed1, seed2: positive; -- seed values for random generator
    variable rand: real; -- random real-number value in range 0 to 1.0  
  BEGIN  -- PROCESS
    uniform(seed1, seed2, rand);--more entropy by skipping values
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      reg <= (OTHERS => '0');
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      IF run = '0' THEN
        reg <= (OTHERS => '0');
      ELSE
        IF data_ack = '1' THEN
            reg <= std_logic_vector(to_signed(INTEGER( (REAL(AMPLITUDE) * rand) + REAL(to_integer(SIGNED(offset))) ),NB_BITS));
        END IF;
      END IF;
    END IF;
  END PROCESS;
  
  data <= reg;

END beh;
