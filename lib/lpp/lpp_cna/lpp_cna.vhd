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
library ieee;
use ieee.std_logic_1164.all;
library grlib;
use grlib.amba.all;
use std.textio.all;
library lpp;
use lpp.lpp_amba.all;

--! Package contenant tous les programmes qui forment le composant intégré dans le léon

package lpp_cna is

component APB_DAC is
  generic (
    pindex   : integer := 0;
    paddr    : integer := 0;
    pmask    : integer := 16#fff#;
    pirq     : integer := 0;
    abits    : integer := 8;
    Nmax     : integer := 7;
    cpt_serial : integer := 6);
  port (
    clk     : in  std_logic;           --! Horloge du composant
    rst     : in  std_logic;           --! Reset general du composant
    apbi    : in  apb_slv_in_type;     --! Registre de gestion des entrées du bus
    apbo    : out apb_slv_out_type;    --! Registre de gestion des sorties du bus
    DataIN  : in std_logic_vector(15 downto 0);
    Cal_EN  : out std_logic;           --! Signal Enable du multiplex pour la CAL
    Readn   : out std_logic;
    SYNC    : out std_logic;           --! Signal de synchronisation du convertisseur
    SCLK    : out std_logic;           --! Horloge systeme du convertisseur
    CLK_VAR : out std_logic;
    DATA    : out std_logic             --! Donnée numérique sérialisé
    );
end component;


component DacDriver is
--generic(cpt_serial : integer := 6);  --! Générique contenant le résultat de la division clk/sclk  !!! clk=25Mhz
  port(
    clk         : in std_logic;                        --! Horloge du composant
    rst         : in std_logic;                        --! Reset general du composant
    SysClk      : in std_logic;
    enable      : in std_logic;                        --! Autorise ou non l'utilisation du composant
    Data_IN     : in std_logic_vector(15 downto 0);    --! Donnée Numérique d'entrée sur 16 bits
    SYNC        : out std_logic;                       --! Signal de synchronisation du convertisseur
    SCLK        : out std_logic;                       --! Horloge systeme du convertisseur
    Readn       : out std_logic;
--    Ready       : out std_logic;                       --! Flag, signale la fin de la sérialisation d'une donnée
    Data        : out std_logic                        --! Donnée numérique sérialisé
    );
end component;


component Gene_SYNC is
  port(
    SysClk,raz : in std_logic;     --! Horloge systeme et Reset du composant
    SCLK : in std_logic;
    enable : in std_logic;       --! Autorise ou non l'utilisation du composant
    sended : in std_logic;
    send : out std_logic;   --! Flag, Autorise l'envoi (sérialisation) d'une nouvelle donnée
    Readn : out std_logic;
    SYNC : out std_logic         --! Signal de synchronisation du convertisseur généré
    );
end component;


component Serialize is
  port(
    clk,raz : in std_logic;                      --! Horloge et Reset du composant
    sclk    : in std_logic;                      --! Horloge Systeme
    vectin  : in std_logic_vector(15 downto 0);  --! Vecteur d'entrée
    send    : in std_logic;                      --! Flag, Une nouvelle donnée est présente
    sended  : out std_logic;                     --! Flag, La donnée a été sérialisée
    Data    : out std_logic                      --! Donnée numérique sérialisé
    );
end component;

component ReadFifo_GEN is
  port(
    clk,raz : in std_logic;                      --! Horloge et Reset du composant
    SYNC : in std_logic;
    Readn : out std_logic
    );
end component;


component ClkSetting is
generic(Nmax    : integer := 7);   
port( 
    clk, rst   : in std_logic;   --! Horloge et Reset globale
    N          : in integer range 0 to Nmax;
    sclk       : out std_logic   --! Horloge Systeme générée
);
end component;

end;