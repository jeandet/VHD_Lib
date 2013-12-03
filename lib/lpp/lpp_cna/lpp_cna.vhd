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

--! Package contenant tous les programmes qui forment le composant int�gr� dans le l�on

package lpp_cna is

component APB_DAC is
  generic (
    pindex   : integer := 0;
    paddr    : integer := 0;
    pmask    : integer := 16#fff#;
    pirq     : integer := 0;
    abits    : integer := 8);
  port (
    clk     : in  std_logic;
    rst     : in  std_logic;
    apbi    : in  apb_slv_in_type;
    apbo    : out apb_slv_out_type;
    Cal_EN  : out std_logic;
    SYNC    : out std_logic;
    SCLK    : out std_logic;
    DATA    : out std_logic
    );
end component;


component DacDriver is
generic(cpt_serial : integer := 6);  --! G�n�rique contenant le r�sultat de la division clk/sclk  !!! clk=25Mhz
    port(
        clk       : in std_logic;
        rst         : in std_logic;
        enable      : in std_logic;
        Data_C      : in std_logic_vector(15 downto 0);
        SYNC        : out std_logic;
        SCLK        : out std_logic;
        Ready     : out std_logic;
        Data        : out std_logic
        );
end component;


component Systeme_Clock is
    generic(N :integer := 695);
    port(
        clk, raz   : in std_logic ;
        sclk      : out std_logic);
end component;


component Gene_SYNC is
    port(
    SCLK,raz : in std_logic;     --! Horloge systeme et Reset du composant
    enable : in std_logic;       --! Autorise ou non l'utilisation du composant
    Sended : out std_logic;   --! Flag, Autorise l'envoi (s�rialisation) d'une nouvelle donn�e
    SYNC : out std_logic);         --! Signal de synchronisation du convertisseur g�n�r�
end component;


component Serialize is
port(
    clk,raz : in std_logic;
    sclk    : in std_logic;
    vectin  : in std_logic_vector(15 downto 0);
    send    : in std_logic;
    sended  : out std_logic;
    Data    : out std_logic);
end component;

end;