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

entity SM_5lppFIFO is
generic(
    tech          :   integer := apa3;
    Data_sz       :   integer range 1 to 32 := 16;
    Addr_sz       :   integer range 2 to 12 := 8;
    Enable_ReUse  :   std_logic := '0'
    );
port(
    rst     :   in std_logic;
    wclk    :   in std_logic;    
    rclk    :   in std_logic;
    ReUse   :   in std_logic_vector(4 downto 0);
    wen     :   in std_logic_vector(4 downto 0); 
    ren     :   in std_logic_vector(4 downto 0);
    wdata   :   in std_logic_vector((5*Data_sz)-1 downto 0);
    rdata   :   out std_logic_vector((5*Data_sz)-1 downto 0);
    full    :   out std_logic_vector(4 downto 0);
    empty   :   out std_logic_vector(4 downto 0)    
);
end entity;


architecture ar_SM_5lppFIFO of SM_5lppFIFO is

begin

    fifoB1 : lpp_fifo
        generic map (tech,Enable_ReUse,Data_sz,Addr_sz)
        port map(rst,ReUse(0),rclk,ren(0),rdata(Data_sz-1 downto 0),empty(0),open,wclk,wen(0),wdata(Data_sz-1 downto 0),full(0),open);

    fifoB2 : lpp_fifo
        generic map (tech,Enable_ReUse,Data_sz,Addr_sz)
        port map(rst,ReUse(1),rclk,ren(1),rdata((2*Data_sz)-1 downto Data_sz),empty(1),open,wclk,wen(1),wdata((2*Data_sz)-1 downto Data_sz),full(1),open);

    fifoB3 : lpp_fifo
        generic map (tech,Enable_ReUse,Data_sz,Addr_sz)
        port map(rst,ReUse(2),rclk,ren(2),rdata((3*Data_sz)-1 downto 2*Data_sz),empty(2),open,wclk,wen(2),wdata((3*Data_sz)-1 downto 2*Data_sz),full(2),open);

    fifoE1 : lpp_fifo
        generic map (tech,Enable_ReUse,Data_sz,Addr_sz)
        port map(rst,ReUse(3),rclk,ren(3),rdata((4*Data_sz)-1 downto 3*Data_sz),empty(3),open,wclk,wen(3),wdata((4*Data_sz)-1 downto 3*Data_sz),full(3),open);

    fifoE2 : lpp_fifo
        generic map (tech,Enable_ReUse,Data_sz,Addr_sz)
        port map(rst,ReUse(4),rclk,ren(4),rdata((5*Data_sz)-1 downto 4*Data_sz),empty(4),open,wclk,wen(4),wdata((5*Data_sz)-1 downto 4*Data_sz),full(4),open);


end architecture;


























