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
use work.config.all;
use lpp.lpp_memory.all;

--! Programme de la FIFO

entity Top_FIFO is
  generic(
    Data_sz      : integer := 16;
    Addr_sz      : integer := 8;    
    addr_max_int : integer := 256
    );
  port(
    clk,raz  : in std_logic;                             --! Horloge et reset general du composant
    flag_RE  : in std_logic;                             --! Flag, Demande la lecture de la mémoire
    flag_WR  : in std_logic;                             --! Flag, Demande l'écriture dans la mémoire
    RstMem   : in std_logic;
    Data_in  : in std_logic_vector(Data_sz-1 downto 0);  --! Data en entrée du composant
    Addr_RE  : out std_logic_vector(addr_sz-1 downto 0); --! Adresse d'écriture
    Addr_WR  : out std_logic_vector(addr_sz-1 downto 0); --! Adresse de lecture
    full     : out std_logic;                            --! Flag, Mémoire pleine
    empty    : out std_logic;                            --! Flag, Mémoire vide
    Data_out : out std_logic_vector(Data_sz-1 downto 0)  --! Data en sortie du composant
    );
end Top_FIFO;

--! @details Une mémoire SRAM de chez Gaisler est utilisée,
--! associée a deux Drivers, un pour écrire l'autre pour lire cette mémoire

architecture ar_Top_FIFO of Top_FIFO is

component syncram_2p
    generic (tech : integer := 0; abits : integer := 6; dbits : integer := 8; sepclk : integer := 0);
    port (
        rclk      : in std_ulogic;
        renable   : in std_ulogic;
        raddress  : in std_logic_vector((abits -1) downto 0);
        dataout   : out std_logic_vector((dbits -1) downto 0);
        wclk      : in std_ulogic;
        write     : in std_ulogic;
        waddress  : in std_logic_vector((abits -1) downto 0);
        datain    : in std_logic_vector((dbits -1) downto 0));
end component;

signal Raddr     : std_logic_vector(addr_sz-1 downto 0);
signal Waddr     : std_logic_vector(addr_sz-1 downto 0);
signal Data_int  : std_logic_vector(Data_sz-1 downto 0);
signal Data_svg  : std_logic_vector(Data_sz-1 downto 0);
signal s_empty   : std_logic;
signal s_full    : std_logic;
signal Data1     : std_logic;
signal Data2     : std_logic;
signal s_flag_RE : std_logic;
signal s_flag_WR : std_logic;
signal rstf      : std_logic;

begin

    Reset : entity LocalReset
        port map(clk,raz,RstMem,rstf);

    WR : entity Fifo_Write
        generic map(Addr_sz,addr_max_int)
        port map(clk,rstf,s_flag_WR,Raddr,s_full,Waddr);

    SRAM : syncram_2p
        generic map(CFG_MEMTECH,Addr_sz,Data_sz)
        port map(clk,s_flag_RE,Raddr,Data_int,clk,s_flag_WR,Waddr,Data_in);
 
    RE : entity Fifo_Read
        generic map(Addr_sz,addr_max_int)
        port map(clk,rstf,s_flag_RE,Waddr,s_empty,Raddr);

    PIPE : entity PipeLine
        generic map(Data_sz)
        port map(clk,rstf,Data_in,s_flag_RE,s_flag_WR,s_empty,Data_svg,Data1,Data2);


Data_out <= Data_svg when Data1='1' else
            Data_int when Data2='1';

full    <= s_full;
empty   <= s_empty;
Addr_RE <= Raddr;
Addr_WR <= Waddr;

s_flag_WR <= Flag_WR when s_full='0' else
             '0';

s_flag_RE <= Flag_RE when s_empty='0' else
             '0';

end ar_Top_FIFO;