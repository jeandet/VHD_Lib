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

--! Programme de calcule de Matrice Spectral, composé d'une ALU et de son Driver

entity Matrix is
  generic(
      Input_SZ : integer := 16);
  port(
      clk       : in std_logic;                                --! Horloge du composant
      raz       : in std_logic;                                --! Reset general du composant
      IN1       : in std_logic_vector(Input_SZ-1 downto 0);    --! Donnée d'entrée
      IN2       : in std_logic_vector(Input_SZ-1 downto 0);    --! Donnée d'entrée
      Take      : in std_logic;                                --! Flag, opérande récupéré
      Received  : in std_logic;                                --! Flag, Résultat bien ressu
      Conjugate : in std_logic;                                --! Flag, Calcul sur un complexe et son conjugué
      Valid     : out std_logic;                               --! Flag, Résultat disponible
      Read      : out std_logic;                               --! Flag, opérande disponible
      Result    : out std_logic_vector(2*Input_SZ-1 downto 0)  --! Résultat du calcul
);
end Matrix;


architecture ar_Matrix of Matrix is

signal CTRL  : std_logic_vector(4 downto 0);
signal OP1   : std_logic_vector(Input_SZ-1 downto 0);
signal OP2   : std_logic_vector(Input_SZ-1 downto 0);

begin

DRIVE : ALU_Driver
    generic map(Input_SZ,Input_SZ)
    port map(clk,raz,IN1,IN2,Take,Received,Conjugate,Valid,Read,CTRL,OP1,OP2);


ALU : ALU_v2
    generic map(1,0,Input_SZ,Input_SZ)
    port map(clk,raz,CTRL,OP1,OP2,Result);  


end ar_Matrix;

