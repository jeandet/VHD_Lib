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
use lpp.lpp_matrix.all;

--! Une ALU : Arithmetic and logical unit, permettant de réaliser une ou plusieurs opération

entity ALU_v2 is
generic(
    Arith_en        :   integer := 1;
    Logic_en        :   integer := 1;
    Input_SZ_1      :   integer := 16;
    Input_SZ_2      :   integer := 9);
port(
    clk     :   in  std_logic;                                           --! Horloge du composant
    reset   :   in  std_logic;                                           --! Reset general du composant
    ctrl    :   in  std_logic_vector(4 downto 0);                        --! Permet de sélectionner la/les opération désirée
    OP1     :   in  std_logic_vector(Input_SZ_1-1 downto 0);             --! Premier Opérande
    OP2     :   in  std_logic_vector(Input_SZ_2-1 downto 0);             --! Second Opérande
    RES     :   out std_logic_vector(Input_SZ_1+Input_SZ_2-1 downto 0)   --! Résultat de l'opération
);
end ALU_v2;

--! @details Sélection grace a l'entrée "ctrl" :
--! Pause                    : IDLE = 00000
--! Multiplieur/Accumulateur : MAC = 0XX01
--! Multiplication           : MULT = 0XX10
--! Addition                 : ADD = 0XX11
--! Complement a 2           : 2C = 011XX
--! Reset du MAC             : CLRMAC = 10000

architecture ar_ALU_v2 of ALU_v2 is

signal clr_MAC : std_logic:='1';

begin

clr_MAC   <=  '1' when    ctrl = "10000" else '0';

arith : if Arith_en = 1 generate
MACinst : MAC_v2
generic map(Input_SZ_1,Input_SZ_2)
port map(clk,reset,clr_MAC,ctrl(3 downto 0),OP1,OP2,RES);
end generate;

end ar_ALU_v2;