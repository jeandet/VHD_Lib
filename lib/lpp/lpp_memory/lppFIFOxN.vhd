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

entity lppFIFOxN is
generic(
    tech          :   integer := 0;
    Mem_use       :   integer := use_RAM;
    Data_sz       :   integer range 1 to 32 := 8;
    Addr_sz       :   integer range 2 to 12 := 8;
    FifoCnt       :   integer := 1;
    Enable_ReUse  :   std_logic := '0'
    );
port(
    rstn     :   in std_logic;
    wclk    :   in std_logic;    
    rclk    :   in std_logic;
    ReUse   :   in std_logic_vector(FifoCnt-1 downto 0);
    wen     :   in std_logic_vector(FifoCnt-1 downto 0);
    ren     :   in std_logic_vector(FifoCnt-1 downto 0);
    wdata   :   in std_logic_vector((FifoCnt*Data_sz)-1 downto 0);
    rdata   :   out std_logic_vector((FifoCnt*Data_sz)-1 downto 0);
    full    :   out std_logic_vector(FifoCnt-1 downto 0);
    empty   :   out std_logic_vector(FifoCnt-1 downto 0)
);
end entity;


architecture ar_lppFIFOxN of lppFIFOxN is

begin

fifos: for i in 0 to FifoCnt-1 generate
    FIFO0 : lpp_fifo
        generic map (tech,Mem_use,Enable_ReUse,Data_sz,Addr_sz)
        port map(rstn,ReUse(i),rclk,ren(i),rdata((i+1)*Data_sz-1 downto i*Data_sz),empty(i),open,wclk,wen(i),wdata((i+1)*Data_sz-1 downto i*Data_sz),full(i),open);
end generate;

end architecture;
