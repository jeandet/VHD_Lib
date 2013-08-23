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
library lpp;
use lpp.lpp_matrix.all;

entity SpectralMatrix is
generic(
    Input_SZ  : integer := 16;
    Result_SZ : integer := 32);
port(
    clk        : in std_logic;
    reset      : in std_logic;
    Start      : in std_logic;
    FIFO1      : in std_logic_vector(Input_SZ-1 downto 0);
    FIFO2      : in std_logic_vector(Input_SZ-1 downto 0);
    Statu      : in std_logic_vector(3 downto 0);
--    FullFIFO   : in std_logic;
    ReadFIFO   : out std_logic_vector(1 downto 0);
    WriteFIFO  : out std_logic;
    Result     : out std_logic_vector(Result_SZ-1 downto 0)
);
end SpectralMatrix;


architecture ar_SpectralMatrix of SpectralMatrix is

signal RaZ              :   std_logic;
signal Read_int         :   std_logic;
signal Take_int         :   std_logic;
signal Received_int     :   std_logic;
signal Valid_int        :   std_logic;
signal Conjugate_int    :   std_logic;

signal Resultat     :   std_logic_vector(Result_SZ-1 downto 0);


begin

RaZ <= reset and Start;

IN1 : DriveInputs
    port map(clk,RaZ,Read_int,Conjugate_int,Take_int,ReadFIFO);


CALC0 : Matrix
    generic map(Input_SZ)
    port map(clk,RaZ,FIFO1,FIFO2,Take_int,Received_int,Conjugate_int,Valid_int,Read_int,Resultat);


RES0 : GetResult
    generic map(Result_SZ)
    port map(clk,RaZ,Valid_int,Conjugate_int,Resultat,WriteFIFO,Received_int,Result);--Resultat,FullFIFO,WriteFIFO


With Statu select
    Conjugate_int <= '1' when "0001",
                     '1' when "0011",
                     '1' when "0110",
                     '1' when "1010",
                     '1' when "1111",
                     '0' when others;

end ar_SpectralMatrix;