------------------------------------------------------------------------------
--  This file is a part of the LPP VHDL IP LIBRARY
--  Copyright (C) 2009 - 2012, Laboratory of Plasmas Physic - CNRS
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
use lpp.lpp_memory.all;
use lpp.iir_filter.all;
library techmap;
use techmap.gencomp.all;

entity lpp_fifo is
generic(
    tech          :   integer := 0;
    Enable_ReUse  :   std_logic := '0';
    DataSz        :   integer range 1 to 32 := 8;
    abits         :   integer range 2 to 12 := 8
    );
port(
    rstn    :   in std_logic;
    ReUse   :   in std_logic;
    rclk    :   in std_logic;
    ren     :   in std_logic;
    rdata   :   out std_logic_vector(DataSz-1 downto 0);
    empty   :   out std_logic;
    raddr   :   out std_logic_vector(abits-1 downto 0);
    wclk    :   in std_logic;
    wen     :   in std_logic;
    wdata   :   in std_logic_vector(DataSz-1 downto 0);
    full    :   out std_logic;
    waddr   :   out std_logic_vector(abits-1 downto 0)
);
end entity;


architecture ar_lpp_fifo of lpp_fifo is

signal sFull        : std_logic;
signal sFull_s      : std_logic;
signal sEmpty_s     : std_logic;

signal sEmpty       : std_logic;
signal sREN         : std_logic;
signal sWEN         : std_logic;
signal sRE          : std_logic;
signal sWE          : std_logic;

signal Waddr_vect   : std_logic_vector(abits-1 downto 0):=(others =>'0');
signal Raddr_vect   : std_logic_vector(abits-1 downto 0):=(others =>'0');
signal Waddr_vect_s : std_logic_vector(abits-1 downto 0):=(others =>'0');
signal Raddr_vect_s : std_logic_vector(abits-1 downto 0):=(others =>'0');

begin

--==================================================================================
-- /!\ syncram_2p Write et Read actif a l'état haut /!\
-- A l'inverse de RAM_CEL !!!
--==================================================================================
SRAM : syncram_2p
    generic map(tech,abits,DataSz)
    port map(RCLK,sRE,Raddr_vect,rdata,WCLK,sWE,Waddr_vect,wdata);
--================================================================================== 
--RAM0: entity work.RAM_CEL
--    port map(wdata, rdata, sWEN, sREN, Waddr_vect, Raddr_vect, WCLK, rstn);
--================================================================================== 

--=============================
--     Read section
--=============================
sREN    <= REN or sEmpty;
sRE     <= not sREN;

sEmpty_s <= '0' when ReUse = '1' and Enable_ReUse='1' else
            '1' when sEmpty = '1' and Wen = '1' else
            '1' when sEmpty = '0' and (Wen = '1' and Ren = '0' and Raddr_vect_s = Waddr_vect) else
            '0';

Raddr_vect_s   <= std_logic_vector(unsigned(Raddr_vect) +1);

process (rclk,rstn)
begin
    if(rstn='0')then
        Raddr_vect   <=  (others =>'0');
        sempty  <= '1';
    elsif(rclk'event and rclk='1')then 
        sEmpty <= sempty_s;
        
        if(sREN='0' and sempty = '0')then
            Raddr_vect  <= Raddr_vect_s;
        end if;

    end if;
end process;

--=============================
--     Write section
--=============================
sWEN    <= WEN or sFull;
sWE     <= not sWEN;

sFull_s <= '1' when ReUse = '1' and Enable_ReUse='1' else
           '1' when Waddr_vect_s = Raddr_vect and REN = '1' and WEN = '0' else
           '1' when sFull = '1' and REN = '1' else
           '0';
           
Waddr_vect_s   <= std_logic_vector(unsigned(Waddr_vect) +1);

process (wclk,rstn)
begin
    if(rstn='0')then
        Waddr_vect   <=  (others =>'0');
        sfull        <=   '0';
    elsif(wclk'event and wclk='1')then
        sfull <= sfull_s;

        if(sWEN='0' and sfull='0')then
            Waddr_vect <= Waddr_vect_s;
        end if;
        
    end if;
end process;


full    <= sFull_s;
empty   <= sEmpty_s;
waddr   <= Waddr_vect;
raddr   <= Raddr_vect;

end architecture;


























