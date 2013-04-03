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
--                    Author : Jean-christophe PELLION
--                    Mail   : jean-christophe.pellion@lpp.polytechnique.fr
----------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_1164.ALL;

ENTITY SYNC_FF IS
  
  GENERIC (
    NB_FF_OF_SYNC : INTEGER := 2);

  PORT (
    clk    : IN  STD_LOGIC;
    rstn   : IN  STD_LOGIC;
    A      : IN  STD_LOGIC;
    A_sync : OUT STD_LOGIC);

END SYNC_FF;

ARCHITECTURE beh OF SYNC_FF IS
  SIGNAL A_temp : STD_LOGIC_VECTOR(NB_FF_OF_SYNC DOWNTO 0);
BEGIN  -- beh

  sync_loop : FOR I IN 0 TO NB_FF_OF_SYNC-1 GENERATE
    PROCESS (clk, rstn)
    BEGIN  -- PROCESS
      IF rstn = '0' THEN                  -- asynchronous reset (active low)
        A_temp(I) <= '0';
      ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
        A_temp(I) <= A_temp(I+1);
      END IF;
    END PROCESS;
  END GENERATE sync_loop;

  A_temp(NB_FF_OF_SYNC) <= A;
  A_sync                <= A_temp(0);
  
END beh;
