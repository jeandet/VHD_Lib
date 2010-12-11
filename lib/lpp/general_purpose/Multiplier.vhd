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



entity Multiplier is 
generic(
    Input_SZ_A     :   integer := 16;
    Input_SZ_B     :   integer := 16

);
port(
    clk     :   in  std_logic;
    reset   :   in  std_logic;
    mult    :   in  std_logic;
    OP1     :   in  std_logic_vector(Input_SZ_A-1 downto 0);
    OP2     :   in  std_logic_vector(Input_SZ_B-1 downto 0);
    RES     :   out std_logic_vector(Input_SZ_A+Input_SZ_B-1 downto 0)
);
end Multiplier;





architecture ar_Multiplier of Multiplier is

signal  REG     :   std_logic_vector(Input_SZ_A+Input_SZ_B-1 downto 0);
signal  RESMULT :   std_logic_vector(Input_SZ_A+Input_SZ_B-1 downto 0);


begin

RES     <=  REG;
RESMULT <=  std_logic_vector(signed(OP1)*signed(OP2));
process(clk,reset)
begin
if reset = '0' then
    REG     <=  (others => '0');
elsif clk'event and clk ='1' then
    if mult = '1' then
        REG     <=  RESMULT;
    end if;
end if;
end process;

end ar_Multiplier;








