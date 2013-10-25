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
  
  PORT (
    clk       : IN  STD_LOGIC;
    rstn      : IN  STD_LOGIC;
    in_valid  : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    out_grant : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );

END RR_Arbiter_4;

ARCHITECTURE beh OF RR_Arbiter_4 IS

  SIGNAL out_grant_s : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL grant_sel : STD_LOGIC_VECTOR(1 DOWNTO 0);
  
BEGIN  -- beh

  out_grant   <=  out_grant_s;
  
  out_grant_s <= "0001" WHEN grant_sel = "00" AND in_valid(0) = '1' ELSE
                 "0010" WHEN grant_sel = "00" AND in_valid(1) = '1' ELSE
                 "0100" WHEN grant_sel = "00" AND in_valid(2) = '1' ELSE
                 "1000" WHEN grant_sel = "00" AND in_valid(3) = '1' ELSE
                 "0010" WHEN grant_sel = "01" AND in_valid(1) = '1' ELSE
                 "0100" WHEN grant_sel = "01" AND in_valid(2) = '1' ELSE
                 "1000" WHEN grant_sel = "01" AND in_valid(3) = '1' ELSE
                 "0001" WHEN grant_sel = "01" AND in_valid(0) = '1' ELSE
                 "0100" WHEN grant_sel = "10" AND in_valid(2) = '1' ELSE
                 "1000" WHEN grant_sel = "10" AND in_valid(3) = '1' ELSE
                 "0001" WHEN grant_sel = "10" AND in_valid(0) = '1' ELSE
                 "0010" WHEN grant_sel = "10" AND in_valid(1) = '1' ELSE
                 "1000" WHEN grant_sel = "11" AND in_valid(3) = '1' ELSE
                 "0001" WHEN grant_sel = "11" AND in_valid(0) = '1' ELSE
                 "0010" WHEN grant_sel = "11" AND in_valid(1) = '1' ELSE
                 "0100" WHEN grant_sel = "11" AND in_valid(2) = '1' ELSE
                 "0000";
                
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      grant_sel <= "00";
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      CASE out_grant_s IS
        WHEN "0001" => grant_sel <= "01";
        WHEN "0010" => grant_sel <= "10";
        WHEN "0100" => grant_sel <= "11";
        WHEN "1000" => grant_sel <= "00";
        WHEN OTHERS => grant_sel <= grant_sel;
      END CASE;
    END IF;
  END PROCESS;
  
END beh;
