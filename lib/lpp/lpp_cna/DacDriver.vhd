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
library lpp;
use lpp.lpp_cna.all;

--! Programme du Convertisseur Num�rique/Analogique

entity DacDriver is
--generic(cpt_serial : integer := 6);  --! G�n�rique contenant le r�sultat de la division clk/sclk  !!! clk=25Mhz
  port(
    clk         : in std_logic;                        --! Horloge du composant
    rst         : in std_logic;                        --! Reset general du composant
    SysClk      : in std_logic;
    enable      : in std_logic;                        --! Autorise ou non l'utilisation du composant
    Data_IN     : in std_logic_vector(15 downto 0);    --! Donn�e Num�rique d'entr�e sur 16 bits
    SYNC        : out std_logic;                       --! Signal de synchronisation du convertisseur
    SCLK        : out std_logic;                       --! Horloge systeme du convertisseur
    Readn       : out std_logic;
--    Ready       : out std_logic;                       --! Flag, signale la fin de la s�rialisation d'une donn�e
    Data        : out std_logic                        --! Donn�e num�rique s�rialis�
    );
end entity;


architecture ar_DacDriver of DacDriver is

--signal s_SCLK      : std_logic;
signal Send    : std_logic;
signal Sended : std_logic;

begin

--SystemCLK : entity work.Clock_Divider
--    generic map (cpt_serial)
--    port map (clk,rst,s_SCLK);


Signal_sync : Gene_SYNC
    port map (SysClk,rst,clk,enable,Sended,Send,Readn,SYNC);


Serial : serialize
    port map (clk,rst,clk,Data_IN,Send,Sended,Data);

--RenGEN : entity work.ReadFifo_GEN
--    port map (clk,rst,Send,Readn);

SCLK        <= clk;
--Ready <= s_Rdy;

end architecture;