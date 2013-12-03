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
use lpp.lpp_cna.all;

--! Programme du Convertisseur Numérique/Analogique

entity DacDriver is
generic(cpt_serial : integer := 6);  --! Générique contenant le résultat de la division clk/sclk  !!! clk=25Mhz
  port(
    clk         : in std_logic;                        --! Horloge du composant
    rst         : in std_logic;                        --! Reset general du composant
    enable      : in std_logic;                        --! Autorise ou non l'utilisation du composant
    Data_IN      : in std_logic_vector(15 downto 0);    --! Donnée Numérique d'entrée sur 16 bits
    SYNC        : out std_logic;                       --! Signal de synchronisation du convertisseur
    SCLK        : out std_logic;                       --! Horloge systeme du convertisseur
    Readn       : out std_logic;
    Ready     : out std_logic;                       --! Flag, signale la fin de la sérialisation d'une donnée
    Data        : out std_logic                        --! Donnée numérique sérialisé
    );
end entity;

--! @details Un driver C va permettre de génerer un tableau de données sur 16 bits, 
--! qui seront sérialisé pour étre ensuite dirigées vers le convertisseur.

architecture ar_DacDriver of DacDriver is

signal s_SCLK      : std_logic;
signal Send    : std_logic;

begin

SystemCLK : Systeme_Clock
    generic map (cpt_serial)
    port map (clk,rst,s_SCLK);


Signal_sync : Gene_SYNC
    port map (s_SCLK,rst,enable,Send,SYNC);


Serial : serialize
    port map (clk,rst,s_SCLK,Data_IN,Send,Ready,Data);

RenGEN : ReadFifo_GEN
    port map (clk,rst,Send,Readn);

SCLK        <= s_SCLK;

end architecture;