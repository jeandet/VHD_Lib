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
-- MAC_MUX.vhd
library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
library lpp;
use lpp.general_purpose.all;



entity MAC_MUX is 
generic(
    Input_SZ_A     :   integer := 16;
    Input_SZ_B     :   integer := 16

);
port(
    sel     :   in  std_logic;
    INA1    :   in  std_logic_vector(Input_SZ_A-1 downto 0);
    INA2    :   in  std_logic_vector(Input_SZ_A-1 downto 0);
    INB1    :   in  std_logic_vector(Input_SZ_B-1 downto 0);
    INB2    :   in  std_logic_vector(Input_SZ_B-1 downto 0);
    OUTA    :   out std_logic_vector(Input_SZ_A-1 downto 0);
    OUTB    :   out std_logic_vector(Input_SZ_B-1 downto 0)
);
end entity;




architecture ar_MAC_MUX of MAC_MUX is

begin

OUTA    <=  INA1 when sel = '0' else INA2;
OUTB    <=  INB1 when sel = '0' else INB2;

end ar_MAC_MUX;
