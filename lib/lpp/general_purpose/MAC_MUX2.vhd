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
--                    Author : Alexis Jeandet
--                     Mail : alexis.jeandet@lpp.polytechnique.fr
----------------------------------------------------------------------------
library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;


entity MAC_MUX2 is 
generic(Input_SZ     :   integer := 16);
port(
    sel     :   in  std_logic;
    RES1    :   in  std_logic_vector(Input_SZ-1 downto 0);
    RES2    :   in  std_logic_vector(Input_SZ-1 downto 0);
    RES     :   out std_logic_vector(Input_SZ-1 downto 0)
);
end entity;




architecture ar_MAC_MUX2 of MAC_MUX2 is

begin

RES     <=  RES1 when sel = '0' else RES2;

end ar_MAC_MUX2;
