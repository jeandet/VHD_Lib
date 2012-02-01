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
    ReUse   :   in std_logic;   --27/01/12
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

signal sFull        : std_logic:='0';
signal sEmpty       : std_logic:='1';
signal sREN         : std_logic:='0';
signal sWEN         : std_logic:='0';

signal Waddr_vect   : std_logic_vector(abits-1 downto 0):=(others =>'0');
signal Raddr_vect   : std_logic_vector(abits-1 downto 0):=(others =>'0');
signal Waddr_vect_d : std_logic_vector(abits-1 downto 0):=(others =>'0');
signal Raddr_vect_d : std_logic_vector(abits-1 downto 0):=(others =>'0');

begin

SRAM : syncram_2p
generic map(tech,abits,DataSz)
port map(RCLK,sREN,Raddr_vect,rdata,WCLK,sWEN,Waddr_vect,wdata);

--RAM0: entity work.RAM_CEL
--    generic map(abits, DataSz)
--    port map(wdata, rdata, sWEN, sREN, Waddr_vect, Raddr_vect, RCLK, WCLK, rstn);


--=============================
--     Read section
--=============================
sREN    <= not REN and not sempty;

process (rclk,rstn)
begin
    if(rstn='0')then
        Raddr_vect   <=  (others =>'0');
        Raddr_vect_d <=  (others =>'1');
        sempty  <= '1';
    elsif(rclk'event and rclk='1')then
        if(ReUse = '1' and Enable_ReUse='1')then   --27/01/12
            sempty  <= '0';    --27/01/12
        elsif(Raddr_vect=Waddr_vect_d and REN = '0' and sempty = '0')then
            sempty  <= '1';
        elsif(Raddr_vect/=Waddr_vect) then
            sempty  <= '0';
        end if;
        if(sREN='1' and sempty = '0') then
            Raddr_vect  <= std_logic_vector(unsigned(Raddr_vect) + 1);
            Raddr_vect_d  <=  Raddr_vect;
        end if;
                            
    end if;
end process;

--=============================
--     Write section
--=============================
sWEN    <= not WEN and not sfull;

process (wclk,rstn)
begin
    if(rstn='0')then
        Waddr_vect   <=  (others =>'0');
        Waddr_vect_d <=  (others =>'1');
        sfull        <=   '0';
    elsif(wclk'event and wclk='1')then
        if(ReUse = '1' and Enable_ReUse='1')then   --27/01/12
            sfull  <= '1';    --27/01/12
        elsif(Raddr_vect_d=Waddr_vect and WEN = '0' and sfull = '0')then
            sfull  <= '1';
        elsif(Raddr_vect/=Waddr_vect) then
            sfull  <= '0';
        end if;
        if(sWEN='1' and sfull='0') then
            Waddr_vect   <= std_logic_vector(unsigned(Waddr_vect) +1);
            Waddr_vect_d <= Waddr_vect;
        end if;

                   
    end if;
end process;


full    <= sFull;
empty   <= sEmpty;
waddr   <= Waddr_vect;
raddr   <= Raddr_vect;

end architecture;


























