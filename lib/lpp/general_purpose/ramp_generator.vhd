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
------------------------------------------------------------------------------
--  Author : Jean-christophe Pellion
--  Mail   : jean-christophe.pellion@lpp.polytechnique.fr
------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY ramp_generator IS
  
  GENERIC (
    DATA_SIZE  : INTEGER := 16;
    VALUE_UNSIGNED_INIT : INTEGER := 0;
    VALUE_UNSIGNED_INCR : INTEGER := 1;
    VALUE_UNSIGNED_MASK : INTEGER := 16#FFFF#);

  PORT (
    clk         : IN  STD_LOGIC;
    rstn        : IN  STD_LOGIC;
    new_data    : IN  STD_LOGIC;
    output_data : OUT STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0));

END ramp_generator;

ARCHITECTURE beh OF ramp_generator IS

  SIGNAL data : STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
  
BEGIN  -- beh

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      data <=     STD_LOGIC_VECTOR(to_unsigned(VALUE_UNSIGNED_INIT,DATA_SIZE))
              AND STD_LOGIC_VECTOR(to_unsigned(VALUE_UNSIGNED_MASK,DATA_SIZE));
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      IF new_data = '1' THEN
        data <=     STD_LOGIC_VECTOR(to_unsigned(VALUE_UNSIGNED_INCR + to_integer(UNSIGNED(data)),DATA_SIZE))
                AND STD_LOGIC_VECTOR(to_unsigned(VALUE_UNSIGNED_MASK                             ,DATA_SIZE));
      END IF;
    END IF;
  END PROCESS;

  output_data <= data;
  
END beh;
