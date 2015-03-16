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

LIBRARY lpp;
USE lpp.general_purpose.ALL;

ENTITY SYNC_VALID_BIT IS
  GENERIC (
    NB_FF_OF_SYNC : INTEGER := 2);
  PORT (
    clk_in  : IN  STD_LOGIC;
    rstn_in : IN  STD_LOGIC;
    clk_out  : IN  STD_LOGIC;
    rstn_out : IN  STD_LOGIC;
    sin      : IN  STD_LOGIC;
    sout     : OUT STD_LOGIC);
END SYNC_VALID_BIT;

ARCHITECTURE beh OF SYNC_VALID_BIT IS
  SIGNAL s_1 : STD_LOGIC;
  SIGNAL s_2 : STD_LOGIC;
BEGIN  -- beh

  lpp_front_to_level_1: lpp_front_to_level
    PORT MAP (
      clk  => clk_in,
      rstn => rstn_in,
      sin  => sin,
      sout => s_1);
  
  SYNC_FF_1:  SYNC_FF
    GENERIC MAP (
      NB_FF_OF_SYNC => NB_FF_OF_SYNC)
    PORT MAP (
      clk    => clk_out,
      rstn   => rstn_out,
      A      => s_1,
      A_sync => s_2);

  lpp_front_detection_1: lpp_front_detection
    PORT MAP (
      clk  => clk_out,
      rstn => rstn_out,
      sin  => s_2,
      sout => sout);
  
END beh;
