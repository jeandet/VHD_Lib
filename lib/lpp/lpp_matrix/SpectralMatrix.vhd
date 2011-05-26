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

entity SpectralMatrix is
generic(
    Input_SZ  : integer := 16;
    Result_SZ : integer := 32);
port(
    clk      : in std_logic;
    reset    : in std_logic;
    B1       : in std_logic_vector(Input_SZ-1 downto 0);
    B2       : in std_logic_vector(Input_SZ-1 downto 0);
    B3       : in std_logic_vector(Input_SZ-1 downto 0);
    E1       : in std_logic_vector(Input_SZ-1 downto 0);
    E2       : in std_logic_vector(Input_SZ-1 downto 0);
    ReadFIFO : out std_logic_vector(4 downto 0);  --B1,B2,B3,E1,E2
    Result   : out std_logic_vector(Result_SZ-1 downto 0)
);
end SpectralMatrix;


architecture ar_SpectralMatrix of SpectralMatrix is

signal Read         :   std_logic;
signal Take         :   std_logic;
signal Received     :   std_logic;
signal Valid        :   std_logic;
signal Conjugate    :   std_logic;
signal OP1          :   std_logic_vector(Input_SZ-1 downto 0);
signal OP2          :   std_logic_vector(Input_SZ-1 downto 0);
signal Resultat     :   std_logic_vector(Result_SZ-1 downto 0);

begin


IN0 : SelectInputs
    generic map(Input_SZ)
    port map(clk,reset,Read,B1,B2,B3,E1,E2,Conjugate,Take,ReadFIFO,OP1,OP2);


CALC0 : Matrix
    generic map(Input_SZ)
    port map(clk,reset,OP1,OP2,Take,Received,Conjugate,Valid,Read,Resultat);


RES0 : GetResult
    generic map(Result_SZ)
    port map(clk,reset,Valid,Conjugate,Resultat,Received,Result);


end ar_SpectralMatrix;