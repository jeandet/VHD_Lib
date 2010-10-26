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
-- Shifter.vhd
library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
library lpp;
use lpp.general_purpose.all;



entity RShifter is 
generic(
    Input_SZ       :   integer := 16;
    shift_SZ       :   integer := 4
);
port(
    clk     :   in  std_logic;
    reset   :   in  std_logic;
    shift   :   in  std_logic;
    OP      :   in  std_logic_vector(Input_SZ-1 downto 0);
    cnt     :   in  std_logic_vector(shift_SZ-1 downto 0);
    RES     :   out std_logic_vector(Input_SZ-1 downto 0)
);
end entity;




architecture ar_RShifter of RShifter is

signal  REG     :   std_logic_vector(Input_SZ-1 downto 0);
signal  RESSHIFT:   std_logic_vector(Input_SZ-1 downto 0);

begin

RES         <=  REG;
RESSHIFT    <=  std_logic_vector(SHIFT_RIGHT(signed(OP),to_integer(unsigned(cnt))));

process(clk,reset)
begin
if reset = '0' then
    REG     <=  (others => '0');
elsif clk'event and clk ='1' then
    if shift = '1' then
        REG     <=  RESSHIFT;
    end if;
end if;
end process;
end ar_RShifter;
