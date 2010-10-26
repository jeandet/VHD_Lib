------------------------------------------------------------------------------
--  This file is a part of the LPP VHDL IP LIBRARY
--  Copyright (C) 2009 - 2010, Laboratory of Plasmas Physic - CNRS
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
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
-- MAC_CONTROLER.vhd
library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
library lpp;
use lpp.general_purpose.all;


--IDLE =00 MAC =01 MULT =10 ADD =11


entity MAC_CONTROLER is
port(
    ctrl        :   in  std_logic_vector(1 downto 0);
    MULT        :   out std_logic;
    ADD         :   out std_logic;
    MACMUX_sel  :   out std_logic;
    MACMUX2_sel :   out std_logic

);
end MAC_CONTROLER;





architecture ar_MAC_CONTROLER of MAC_CONTROLER is 

begin



MULT        <=  '0' when (ctrl = "00" or ctrl = "11") else '1';
ADD         <=  '0' when (ctrl = "00" or ctrl = "10") else '1';
MACMUX_sel  <=  '0' when (ctrl = "00" or ctrl = "01") else '1';
MACMUX2_sel <=  '0' when (ctrl = "00" or ctrl = "01"or ctrl = "11") else '1';


end ar_MAC_CONTROLER;










