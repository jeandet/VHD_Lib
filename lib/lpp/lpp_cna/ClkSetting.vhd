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
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all;

--! Programme qui va permetre de générer une horloge systeme (sclk) parametrable

entity ClkSetting is
generic(Nmax    : integer := 7);   
port( 
    clk, rst   : in std_logic;   --! Horloge et Reset globale
    N          : in integer range 0 to Nmax;
    sclk       : out std_logic   --! Horloge Systeme générée
);
end entity;

--! @details Fonctionne a base d'un compteur (countint) qui va permetre de diviser l'horloge N fois
architecture ar_ClkSetting of ClkSetting is

signal clockint : std_logic_vector(Nmax downto 0);

begin 
    process (clk,rst)
        begin
        if(rst = '0') then
            clockint <= (others => '0');
        
        elsif (clk' event and clk='1') then

            clockint <= clockint + 1;

        end if;
    end process;

sclk <= clk when N=0 else clockint(N-1);

end architecture;