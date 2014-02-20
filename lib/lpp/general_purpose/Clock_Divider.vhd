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
------------------------------------------------------------------------------
--                    Author : Martin Morlot
--                     Mail : martin.morlot@lpp.polytechnique.fr
------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--! Programme qui va permetre de générer une horloge systeme (sclk)

entity Clock_Divider is
generic(N :integer := 10);   --! Générique contenant le résultat de la division clk/sclk
port( 
    clk, rst   : in std_logic;   --! Horloge et Reset globale
    sclk       : out std_logic   --! Horloge Systeme générée
);
end entity;

--! @details Fonctionne a base d'un compteur (countint) qui va permetre de diviser l'horloge N fois
architecture ar_Clock_Divider of Clock_Divider is

signal clockint : std_logic;
signal countint : integer range 0 to N/2-1;

begin 
    process (clk,rst)
        begin
        if(rst = '0') then
            countint <= 0;
            clockint <= '0';
        elsif (clk' event and clk='1') then
            if (countint = N/2-1) then 
                countint <= 0;
                clockint <= not clockint;
            else 
                countint <= countint+1;
            end if;
        end if;
    end process;

sclk <= clockint;

end architecture;