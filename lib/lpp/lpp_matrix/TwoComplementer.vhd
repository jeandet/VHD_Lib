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

--! Programme permetant de complémenter ou non les entrées de l'ALU, et ainsi de travailler avec des nombres négatifs

entity TwoComplementer is
generic(
    Input_SZ : integer := 16);
port(
    clk     : in  std_logic;                                --! Horloge du composant
    reset   : in  std_logic;                                --! Reset general du composant
    clr     : in  std_logic;                                --! Un reset spécifique au programme
    TwoComp : in  std_logic;                                --! Autorise l'utilisation du complément
    OP      : in  std_logic_vector(Input_SZ-1 downto 0);    --! Opérande d'entrée
    RES     : out std_logic_vector(Input_SZ-1 downto 0)     --! Résultat, opérande complémenté ou non
);
end TwoComplementer;


architecture ar_TwoComplementer of TwoComplementer is

signal REG       : std_logic_vector(Input_SZ-1 downto 0);
signal OPinteger : integer;
signal RESCOMP   : std_logic_vector(Input_SZ-1 downto 0);

begin

RES       <= REG;
OPinteger <= to_integer(signed(OP));
RESCOMP   <= std_logic_vector(to_signed(-OPinteger,Input_SZ));

    process(clk,reset)
    begin

        if(reset='0')then
            REG     <=  (others => '0');
        elsif(clk'event and clk='1')then
            
            if(clr='1')then
                REG <= (others => '0');
            elsif(TwoComp='1')then
                REG <= RESCOMP;
            else 
                REG <= OP;
            end if;

        end if;

    end process;
end ar_TwoComplementer;