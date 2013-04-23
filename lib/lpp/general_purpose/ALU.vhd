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
library lpp;
use lpp.general_purpose.all;

--! Une ALU : Arithmetic and logical unit, permettant de réaliser une ou plusieurs opération

entity ALU is
generic(
    Arith_en        :   integer := 1;
    Logic_en        :   integer := 1;
    Input_SZ_1      :   integer := 16;
    Input_SZ_2      :   integer := 16;
    COMP_EN    : INTEGER := 0 -- 1 =>  No Comp
    );
port(
    clk     :   in  std_logic;                                           --! Horloge du composant
    reset   :   in  std_logic;                                           --! Reset general du composant
    ctrl    :   in  std_logic_vector(2 downto 0);                        --! Permet de sélectionner la/les opération désirée
    comp    :   in  std_logic_vector(1 downto 0);                        --! (set) Permet de complémenter les opérandes
    OP1     :   in  std_logic_vector(Input_SZ_1-1 downto 0);             --! Premier Opérande
    OP2     :   in  std_logic_vector(Input_SZ_2-1 downto 0);             --! Second Opérande
    RES     :   out std_logic_vector(Input_SZ_1+Input_SZ_2-1 downto 0)   --! Résultat de l'opération
);
end ALU;

--! @details Sélection grace a l'entrée "ctrl" :
--! Pause                    : IDLE     = 000
--! Multiplieur/Accumulateur : MAC      = 001
--! Multiplication           : MULT     = 010
--! Addition                 : ADD      = 011
--! Reset du MAC             : CLRMAC   = 100
architecture ar_ALU of ALU is

begin

arith : if Arith_en = 1 generate
MACinst : MAC
generic map(Input_SZ_1,Input_SZ_2,COMP_EN)
port map(clk,reset,ctrl(2),ctrl(1 downto 0),comp,OP1,OP2,RES);
end generate;

end architecture;
