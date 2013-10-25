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

ENTITY RR_Arbiter_4 IS
  
  GENERIC (
    NB_INPUT : INTEGER := 4);

  PORT (
    clk       : IN  STD_LOGIC;
    rstn      : IN  STD_LOGIC;
    in_valid  : IN  STD_LOGIC_VECTOR(NB_INPUT DOWNTO 0);
    out_grant : OUT STD_LOGIC_VECTOR(NB_INPUT DOWNTO 0)
    );

END RR_Arbiter;

ARCHITECTURE beh OF RR_Arbiter IS

  SIGNAL grant_vector : STD_LOGIC_VECTOR(NB_INPUT DOWNTO 0);

BEGIN  -- beh

  
  
END beh;
