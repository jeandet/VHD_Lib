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
--library lpp;
--use lpp.lpp_matrix.all;

entity MatriceSpectrale is
  generic(
      Input_SZ  : integer := 16;
      Result_SZ : integer := 32);
    port(
        clkm            : in std_logic;
        rstn            : in std_logic;

        FifoIN_Full     : in std_logic_vector(4 downto 0);
        SetReUse        : in std_logic_vector(4 downto 0);
        FifoOUT_Full    : in std_logic_vector(1 downto 0);
        Data_IN         : in std_logic_vector((5*Input_SZ)-1 downto 0);
        ACQ             : in std_logic;
        FlagError       : out std_logic;
        Pong            : out std_logic;
        Statu           : out std_logic_vector(3 downto 0);
        Write           : out std_logic_vector(1 downto 0);
        Read            : out std_logic_vector(4 downto 0);
        ReUse           : out std_logic_vector(4 downto 0);
        Data_OUT        : out std_logic_vector((2*Result_SZ)-1 downto 0)
        );
end entity;


architecture ar_MatriceSpectrale of MatriceSpectrale is

signal Matrix_Write     : std_logic;
signal Matrix_Read      : std_logic_vector(1 downto 0);
signal Matrix_Result    : std_logic_vector(31 downto 0);

signal TopSM_Start      : std_logic;
signal TopSM_Statu      : std_logic_vector(3 downto 0);
signal TopSM_Data1      : std_logic_vector(15 downto 0);
signal TopSM_Data2      : std_logic_vector(15 downto 0);

begin

    CTRL0 : entity work.ReUse_CTRLR
        port map(clkm,rstn,SetReUse,TopSM_Statu,ReUse);


    TopSM : entity work.TopSpecMatrix
        generic map (Input_SZ)
        port map(clkm,rstn,Matrix_Write,Matrix_Read,FifoIN_Full,Data_IN,TopSM_Start,Read,TopSM_Statu,TopSM_Data1,TopSM_Data2);

    SM : entity work.SpectralMatrix
        generic map (Input_SZ,Result_SZ)
        port map(clkm,rstn,TopSM_Start,TopSM_Data1,TopSM_Data2,TopSM_Statu,Matrix_Read,Matrix_Write,Matrix_Result);

    DISP : entity work.Dispatch
        generic map(Result_SZ)
        port map(clkm,rstn,ACQ,Matrix_Result,Matrix_Write,FifoOUT_Full,Data_OUT,Write,Pong,FlagError);

Statu <= TopSM_Statu;

end architecture;

