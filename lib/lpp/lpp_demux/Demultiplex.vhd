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
use lpp.lpp_demux.all;

entity Demultiplex is
generic(
    Data_sz        :   integer range 1 to 32 := 16);
port(
    clk    :   in std_logic;
    rstn   :   in std_logic;

    Read : in std_logic_vector(4 downto 0);

    EmptyF0a    :   in std_logic_vector(4 downto 0);
    EmptyF0b    :   in std_logic_vector(4 downto 0);
    EmptyF1     :   in std_logic_vector(4 downto 0);
    EmptyF2     :   in std_logic_vector(4 downto 0);

    DataF0a     :   in std_logic_vector((5*Data_sz)-1 downto 0);
    DataF0b     :   in std_logic_vector((5*Data_sz)-1 downto 0);
    DataF1      :   in std_logic_vector((5*Data_sz)-1 downto 0);
    DataF2      :   in std_logic_vector((5*Data_sz)-1 downto 0);

    Read_DEMUX : out std_logic_vector(19 downto 0);
    Empty   :   out std_logic_vector(4 downto 0);
    Data    :   out std_logic_vector((5*Data_sz)-1 downto 0)
);
end entity;


architecture ar_Demultiplex of Demultiplex is

signal DataCpt      : std_logic_vector(3 downto 0);

begin

    FLG0 : WatchFlag
        port map(clk,rstn,EmptyF0a,EmptyF0b,EmptyF1,EmptyF2,DataCpt);

    DEM : DEMUX
        generic map(Data_sz)
        port map(clk,rstn,Read,DataCpt,EmptyF0a,EmptyF0b,EmptyF1,EmptyF2,DataF0a,DataF0b,DataF1,DataF2,Read_DEMUX,Empty,Data);

end architecture;




















