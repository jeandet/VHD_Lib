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
end entity;


architecture ar_DEMUX of DEMUX is

type etat is (eX,e0,e1,e2,e3);
signal ect : etat;

signal pong : std_logic;

signal DataCpt_reg : std_logic_vector(3 downto 0);
constant Dummy_Read : std_logic_vector(4 downto 0) := (others => '1');

signal Countf0 : integer;
signal Countf1 : integer;

begin
    process(clk,rstn)
    begin
        if(rstn='0')then
            ect <= e0;
            pong <= '0';
            Countf0 <= 1;
            Countf1 <= 0;

        elsif(clk'event and clk='1')then
            DataCpt_reg <= DataCpt;

            case ect is

                when e0 =>
                    if(DataCpt_reg(0) = '1' and DataCpt(0) = '0')then
                        pong <= not pong;
                        if(Countf0 = 5)then
                            Countf0 <= 0;
                            ect <= e2;
                        else
                            Countf0 <= Countf0 + 1;
                            ect <= e1;
                        end if;
                    end if;                        

                when e1 =>
                    if(DataCpt_reg(1) = '1' and DataCpt(1) = '0')then
                        pong <= not pong;
                        if(Countf0 = 5)then
                            Countf0 <= 0;
                            ect <= e2;
                        else
                            Countf0 <= Countf0 + 1;
                            ect <= e0;
                        end if;
                    end if;  

                when e2 =>
                    if(DataCpt_reg(2) = '1' and DataCpt(2) = '0')then
                        if(Countf1 = 15)then
                            Countf1 <= 0;
                            ect <= e3;
                        else
                            Countf1 <= Countf1 + 1;
                            if(pong = '0')then
                                ect <= e0;
                            else
                                ect <= e1;
                            end if;
                        end if;
                    end if;  

                when e3 =>
                    if(DataCpt_reg(3) = '1' and DataCpt(3) = '0')then
                        if(pong = '0')then
                            ect <= e0;
                        else
                            ect <= e1;
                        end if;
                    end if;                
                
                when others =>
                    null;

            end case;
        end if;
    end process;

with ect select
    Empty      <=   EmptyF0a when e0,
                    EmptyF0b when e1,
                    EmptyF1 when e2,
                    EmptyF2 when e3,
                    (others => '1') when others;

with ect select
    Data      <=    DataF0a when e0,
                    DataF0b when e1,
                    DataF1 when e2,
                    DataF2 when e3,
                    (others => '0') when others;

with ect select
    Read_DEMUX  <=  Dummy_Read & Dummy_Read & Dummy_Read & Read when e0,
                    Dummy_Read & Dummy_Read & Read & Dummy_Read when e1,
                    Dummy_Read & Read & Dummy_Read & Dummy_Read when e2,
                    Read & Dummy_Read & Dummy_Read & Dummy_Read when e3,
                    (others => '1') when others;




end architecture;




















