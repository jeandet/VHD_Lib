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

--! Programme de la FIFO

entity Top_FifoRead is
  generic(
    Data_sz      : integer := 16;
    Addr_sz      : integer := 8;
    addr_max_int : integer := 256);
  port(
    clk,raz  : in std_logic;                             --! Horloge et reset general du composant
    flag_RE  : in std_logic;                             --! Flag, Demande la lecture de la mémoire
    flag_WR  : in std_logic;                             --! Flag, Demande l'écriture dans la mémoire
    Data_in  : in std_logic_vector(Data_sz-1 downto 0);  --! Data en entrée du composant
    Waddr    : in std_logic_vector(addr_sz-1 downto 0);  --! Adresse du registre d'écriture dans la mémoire
    empty    : out std_logic;                            --! Flag, Mémoire vide
    Raddr    : out std_logic_vector(addr_sz-1 downto 0); --! Adresse du registre de lecture de la mémoire
    Data_out : out std_logic_vector(Data_sz-1 downto 0)  --! Data en sortie du composant
    );
end Top_FifoRead;

--! @details Une mémoire SRAM de chez Gaisler est utilisée,
--! associée a une fifo, utilisé pour la lecture

architecture ar_Top_FifoRead of Top_FifoRead is

component syncram_2p
    generic (tech : integer := 0; abits : integer := 6; dbits : integer := 8; sepclk : integer := 0);
    port (
        rclk     : in std_ulogic;
        renable  : in std_ulogic;
        raddress : in std_logic_vector((abits -1) downto 0);
        dataout  : out std_logic_vector((dbits -1) downto 0);
        wclk     : in std_ulogic;
        write    : in std_ulogic;
        waddress : in std_logic_vector((abits -1) downto 0);
        datain   : in std_logic_vector((dbits -1) downto 0));
end component;

signal Raddr_int  : std_logic_vector(addr_sz-1 downto 0);
signal s_flag_RE  : std_logic;
signal s_empty    : std_logic;

begin 
   
    SRAM : syncram_2p
        generic map(CFG_MEMTECH,addr_sz,Data_sz)
        port map(clk,s_flag_RE,Waddr,Data_int,clk,flag_WR,Raddr_int,Data_in);

    
    RE : entity work.Fifo_Read
        generic map(Addr_sz,addr_max_int)
        port map(clk,raz,s_flag_RE,Waddr,s_empty,Raddr_int);

    link : entity work.Link_Reg
       generic map(Data_sz)
       port map(clk,raz,Data_in,Data_int,s_flag_RE,flag_WR,s_empty,Data_out);

    process(clk,raz)
    begin
        if(raz='0')then            
            s_flag_RE <= '0';

        elsif(clk'event and clk='1')then
            if(s_empty='0')then
                s_flag_RE <= Flag_RE;
            else
                s_flag_RE <= '0';
            end if;            
            
        end if;
    end process;

empty  <= s_empty;
Raddr <= Raddr_int;

end ar_Top_FifoRead; 