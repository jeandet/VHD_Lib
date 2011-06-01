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
--                    Author : Martin Morlot
--                   Mail : martin.morlot@lpp.polytechnique.fr
-------------------------------------------------------------------------------
library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;

entity Starter is
port(
    clk     : in  std_logic;
    raz     : in  std_logic;
    empty1    : in  std_logic;
    empty2    : in  std_logic;
    Conjugate : in std_logic;
    Start    : out std_logic
);
end Starter;


architecture ar_Starter of Starter is

begin
    process(clk,raz)
    begin
    
        if(raz='0')then
            Start <= '0';
                                
        elsif(clk'event and clk='1')then

            if(Conjugate='1')then
                if(empty1='1')then
                    Start <= '0';
                else
                    Start <= '1';
                end if;
            else
                if(empty1='1' or empty2='1')then
                    Start <= '0';
                else
                    Start <= '1';
                end if;

            end if;
        end if;
    end process;

end ar_Starter;
    


















