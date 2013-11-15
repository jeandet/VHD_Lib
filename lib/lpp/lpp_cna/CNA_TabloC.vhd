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
use work.Convertisseur_config.all;

--! Programme du Convertisseur Num�rique/Analogique

entity CNA_TabloC is
  port(
    clock       : in std_logic;                        --! Horloge du composant
    rst         : in std_logic;                        --! Reset general du composant
    enable      : in std_logic;                        --! Autorise ou non l'utilisation du composant
    Data_C      : in std_logic_vector(15 downto 0);    --! Donn�e Num�rique d'entr�e sur 16 bits
    SYNC        : out std_logic;                       --! Signal de synchronisation du convertisseur
    SCLK        : out std_logic;                       --! Horloge systeme du convertisseur
    flag_sd     : out std_logic;                       --! Flag, signale la fin de la s�rialisation d'une donn�e
    Data        : out std_logic                        --! Donn�e num�rique s�rialis�
    );
end CNA_TabloC;

--! @details Un driver C va permettre de g�nerer un tableau de donn�es sur 16 bits, 
--! qui seront s�rialis� pour �tre ensuite dirig�es vers le convertisseur.

architecture ar_CNA_TabloC of CNA_TabloC is

--component CLKINT
--port( A : in    std_logic := 'U';
--      Y : out   std_logic);
--end component;

--signal clk      : std_logic;

--signal raz          : std_logic;
signal s_SCLK      : std_logic;
signal OKAI_send    : std_logic;

begin

--CLKINT_0 : CLKINT
--    port map(A => clock, Y => clk);

--CLKINT_1 : CLKINT
--    port map(A => rst, Y => raz);


SystemCLK : entity work.Systeme_Clock
    generic map (nb_serial)
    port map (clock,rst,s_SCLK);


Signal_sync : entity work.Gene_SYNC
    port map (s_SCLK,rst,enable,OKAI_send,SYNC);


Serial : entity work.serialize
    port map (clock,rst,s_SCLK,Data_C,OKAI_send,flag_sd,Data);


SCLK        <= s_SCLK;

end ar_CNA_TabloC;