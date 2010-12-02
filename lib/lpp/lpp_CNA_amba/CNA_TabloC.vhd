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
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.Convertisseur_config.all;

entity CNA_TabloC is
    port(
        clock       : in std_logic;
        rst         : in std_logic;
        flag_nw     : in std_logic;
        bp          : in std_logic;
        Data_C      : in std_logic_vector(15 downto 0);
        SYNC        : out std_logic;
        SCLK        : out std_logic;
        Rz          : out std_logic;
        flag_sd     : out std_logic;
        Data        : out std_logic
        );
end CNA_TabloC;


architecture ar_CNA_TabloC of CNA_TabloC is

component CLKINT
port( A : in    std_logic := 'U';
      Y : out   std_logic);
end component;

signal clk      : std_logic;
--signal reset    : std_logic;

signal raz          : std_logic;
signal sys_clk      : std_logic;
signal Data_int     : std_logic_vector(15 downto 0);
signal OKAI_send    : std_logic;

begin


CLKINT_0 : CLKINT
    port map(A => clock, Y => clk);

CLKINT_1 : CLKINT
    port map(A => rst, Y => raz);


SystemCLK : entity work.Clock_Serie
    generic map (nb_serial)
    port map (clk,raz,sys_clk);


Signal_sync : entity work.GeneSYNC_flag
    port map (clk,raz,flag_nw,sys_clk,OKAI_send,SYNC);


Serial : entity work.serialize
    port map (clk,raz,sys_clk,Data_int,OKAI_send,flag_sd,Data);


--raz         <= not reset;
Rz          <= raz;
SCLK        <= not sys_clk;
--Data_Cvec   <= std_logic_vector(to_unsigned(Data_C,12));
--Data_TOT    <= "0001" & Data_Cvec;

with bp select
    Data_int <= X"9555" when '1',
                Data_C when others;

end ar_CNA_TabloC;
