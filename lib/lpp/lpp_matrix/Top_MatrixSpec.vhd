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
-------------------------------------------------------------------------------
--                    Author : Martin Morlot
--                   Mail : martin.morlot@lpp.polytechnique.fr
-------------------------------------------------------------------------------
library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use lpp.lpp_matrix.all;

entity Top_MatrixSpec is
generic(
    Input_SZ  : integer := 16;
    Result_SZ : integer := 32);
port(
    clk       : in std_logic;
    reset     : in std_logic;
    Statu     : in std_logic_vector(3 downto 0);
    FIFO1     : in std_logic_vector(Input_SZ-1 downto 0);
    FIFO2     : in std_logic_vector(Input_SZ-1 downto 0);
    Full      : in std_logic_vector(1 downto 0);
    Empty     : in std_logic_vector(1 downto 0);
    ReadFIFO  : out std_logic_vector(1 downto 0);
    FullFIFO  : in std_logic;
    WriteFIFO : out std_logic;
    Result    : out std_logic_vector(Result_SZ-1 downto 0)
);
end entity;


architecture ar_Top_MatrixSpec of Top_MatrixSpec is

signal Start :   std_logic;
signal Write :   std_logic;

begin
WriteFIFO <= Write;

ST0 : Starter
    port map(clk,reset,Full,Empty,Statu,Write,Start);

Mspec : SpectralMatrix
      generic map(Input_SZ,Result_SZ)
      port map(clk,reset,Start,FIFO1,FIFO2,Statu,FullFIFO,ReadFIFO,Write,Result);

end architecture;