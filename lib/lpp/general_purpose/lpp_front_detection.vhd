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
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY lpp_front_detection IS
  
  PORT (
    clk  : IN  STD_LOGIC;
    rstn : IN  STD_LOGIC;
    sin  : IN  STD_LOGIC;
    sout : OUT STD_LOGIC);

END lpp_front_detection;

ARCHITECTURE beh OF lpp_front_detection IS

  SIGNAL reg      : STD_LOGIC;
  SIGNAL sout_reg : STD_LOGIC;
  
BEGIN  -- beh

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      reg <= '0';
      sout_reg <= '0';
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      reg <= sin;
      IF sin = NOT reg THEN
        sout_reg <= '1';
      ELSE
        sout_reg <= '0';
      END IF;
    END IF;
  END PROCESS;
  
  sout <= sout_reg;

END beh;
