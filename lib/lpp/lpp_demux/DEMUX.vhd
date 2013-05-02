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

entity DEMUX is
generic(
    Data_sz        :   integer range 1 to 32 := 16);
port(
    clk    :   in std_logic;
    rstn   :   in std_logic;

    Read : in std_logic_vector(4 downto 0);
    Load : in std_logic;

    EmptyF0    :   in std_logic_vector(4 downto 0);
    EmptyF1     :   in std_logic_vector(4 downto 0);
    EmptyF2     :   in std_logic_vector(4 downto 0);

    DataF0     :   in std_logic_vector((5*Data_sz)-1 downto 0);
    DataF1      :   in std_logic_vector((5*Data_sz)-1 downto 0);
    DataF2      :   in std_logic_vector((5*Data_sz)-1 downto 0);

    Read_DEMUX : out std_logic_vector(14 downto 0);
    Empty   :   out std_logic_vector(4 downto 0);
    Data    :   out std_logic_vector((5*Data_sz)-1 downto 0)
);
end entity;


architecture ar_DEMUX of DEMUX is

type etat is (eX,e0,e1,e2,e3);
signal ect : etat;


signal load_reg : std_logic;
constant Dummy_Read : std_logic_vector(4 downto 0) := (others => '1');

signal Countf0 : integer;
signal Countf1 : integer;

begin
    process(clk,rstn)
    begin
        if(rstn='0')then
            ect <= e0;
            load_reg <= '0';
            Countf0 <= 5;
            Countf1 <= 0;

        elsif(clk'event and clk='1')then
            load_reg <= Load;

            case ect is

                when e0 =>
                    if(load_reg = '1' and Load = '0')then
                        if(Countf0 = 24)then
                            Countf0 <= 0;
                            ect <= e1;
                        else
                            Countf0 <= Countf0 + 1;
                            ect <= e0;
                        end if;
                    end if;                        

                when e1 =>
                    if(load_reg = '1' and Load = '0')then
                        if(Countf1 = 74)then
                            Countf1 <= 0;
                            ect <= e2;
                        else
                            Countf1 <= Countf1 + 1;
                            ect <= e0;
                        end if;
                    end if;  

                when e2 =>
                    if(load_reg = '1' and Load = '0')then
                        ect <= e0;
                    end if;                
                
                when others =>
                    null;

            end case;
        end if;
    end process;

with ect select
    Empty      <=   EmptyF0 when e0,
                    EmptyF1 when e1,
                    EmptyF2 when e2,
                    (others => '1') when others;

with ect select
    Data      <=    DataF0 when e0,
                    DataF1 when e1,
                    DataF2 when e2,
                    (others => '0') when others;

with ect select
    Read_DEMUX  <=  Dummy_Read & Dummy_Read & Read when e0,
                    Dummy_Read & Read & Dummy_Read when e1,
                    Read & Dummy_Read & Dummy_Read when e2,
                    (others => '1') when others;

end architecture;




















