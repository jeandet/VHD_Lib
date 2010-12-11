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
library lpp;
use lpp.general_purpose.all;



entity ADDRcntr is 
port(
    clk     :   in  std_logic;
    reset   :   in  std_logic;
    count   :   in  std_logic;
    clr     :   in  std_logic;
    Q       :   out std_logic_vector(7 downto 0)
);
end entity;




architecture ar_ADDRcntr of ADDRcntr is

signal  reg :   std_logic_vector(7 downto 0);

begin

Q   <=  REG;

process(clk,reset)
begin
if reset = '0' then
    REG     <=  (others => '0');
elsif clk'event and clk ='1' then
    if clr = '1' then
        REG <=  (others => '0');
    elsif count ='1' then
        REG <=  std_logic_vector(unsigned(REG)+1);
    end if;
end if;
end process;

end ar_ADDRcntr;
