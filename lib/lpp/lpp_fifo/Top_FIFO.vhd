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
library techmap;
use techmap.gencomp.all;
use work.FIFO_Config.all;
use work.config.all;

--! Programme de la FIFO

entity Top_FIFO is
  port(
    clk,raz  : in std_logic;                             --! Horloge et reset general du composant
    flag_RE  : in std_logic;                             --! Flag, Demande la lecture de la mémoire
    flag_WR  : in std_logic;                             --! Flag, Demande l'écriture dans la mémoire
    Data_in  : in std_logic_vector(Data_sz-1 downto 0);  --! Data en entrée du composant
    full     : out std_logic;                            --! Flag, Mémoire pleine
    empty    : out std_logic;                            --! Flag, Mémoire vide
    Data_out : out std_logic_vector(Data_sz-1 downto 0)  --! Data en sortie du composant
    );
end Top_FIFO;

--! @details Une mémoire SRAM de chez Gaisler est utilisée,
--! associée a deux fifos, une pour écrire l'autre pour lire cette mémoire

architecture ar_Top_FIFO of Top_FIFO is

component syncram_2p
    generic (tech : integer := 0; abits : integer := 6; dbits : integer := 8; sepclk : integer
    := 0);
    port (
        rclk : in std_ulogic;
        renable : in std_ulogic;
        raddress : in std_logic_vector((abits -1) downto 0);
        dataout : out std_logic_vector((dbits -1) downto 0);
        wclk : in std_ulogic;
        write : in std_ulogic;
        waddress : in std_logic_vector((abits -1) downto 0);
        datain : in std_logic_vector((dbits -1) downto 0));
end component;

signal RAD : integer range 0 to addr_max_int; 
signal WAD : integer range 0 to addr_max_int; 
signal Raddr : std_logic_vector(addr_sz-1 downto 0);
signal Waddr : std_logic_vector(addr_sz-1 downto 0);

begin 

    SRAM : syncram_2p
        generic map(CFG_MEMTECH,addr_sz,Data_sz)
        port map(clk,flag_RE,Raddr,Data_out,clk,flag_WR,Waddr,Data_in);

    
    WR : entity work.Fifo_Write
        port map(clk,raz,flag_WR,RAD,full,WAD,Waddr);


    RE : entity work.Fifo_Read
        port map(clk,raz,flag_RE,WAD,empty,RAD,Raddr);


end ar_Top_FIFO;  