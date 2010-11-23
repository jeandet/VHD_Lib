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
library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
library lpp;
use lpp.general_purpose.all;

entity REG is 
generic(size    :   integer := 16 ; initial_VALUE : integer := 0);
port(
    reset   :   in  std_logic;
    clk     :   in  std_logic;
    D       :   in  std_logic_vector(size-1 downto 0);
    Q       :   out std_logic_vector(size-1 downto 0)
);
end entity;



architecture    ar_REG of REG is
begin
process(clk,reset)
begin
if reset = '0' then
    Q   <=  std_logic_vector(to_unsigned(initial_VALUE,size));
elsif clk'event and clk ='1' then
    Q   <=  D;
end if;
end process;
end ar_REG;
