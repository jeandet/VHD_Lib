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

package lpp_demux is


component Demultiplex is
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
end component;


component DEMUX is
generic(
    Data_sz        :   integer range 1 to 32 := 16);
port(
    clk    :   in std_logic;
    rstn   :   in std_logic;

    Read : in std_logic_vector(4 downto 0);
    DataCpt : in std_logic_vector(3 downto 0); -- f2 f1 f0b f0a

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
end component;


component WatchFlag is
port(
    clk    :   in std_logic;
    rstn   :   in std_logic;

    EmptyF0a    :   in std_logic_vector(4 downto 0);
    EmptyF0b    :   in std_logic_vector(4 downto 0);
    EmptyF1     :   in std_logic_vector(4 downto 0);
    EmptyF2     :   in std_logic_vector(4 downto 0);

    DataCpt     :   out std_logic_vector(3 downto 0) -- f2 f1 f0b f0a
);
end component;


end;