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

entity WatchFlag is
port(
    clk    :   in std_logic;
    rstn   :   in std_logic;

    EmptyF0a    :   in std_logic_vector(4 downto 0);
    EmptyF0b    :   in std_logic_vector(4 downto 0);
    EmptyF1     :   in std_logic_vector(4 downto 0);
    EmptyF2     :   in std_logic_vector(4 downto 0);

    DataCpt     :   out std_logic_vector(3 downto 0) -- f2 f1 f0b f0a
);
end entity;


architecture ar_WatchFlag of WatchFlag is

constant FlagSet : std_logic_vector(4 downto 0) := (others =>'1');
constant OneToSet : std_logic_vector(4 downto 0) := "01111";

begin
    process(clk,rstn)
    begin
        if(rstn='0')then
            DataCpt <= (others => '0');

        elsif(clk'event and clk='1')then
           
            if(EmptyF0a = OneToSet)then
                DataCpt(0) <= '1';
            elsif(EmptyF0a = FlagSet)then
                DataCpt(0) <= '0';
            end if;

            if(EmptyF0b = OneToSet)then
                DataCpt(1) <= '1';
            elsif(EmptyF0b = FlagSet)then
                DataCpt(1) <= '0';
            end if;

            if(EmptyF1 = OneToSet)then
                DataCpt(2) <= '1';
            elsif(EmptyF1 = FlagSet)then
                DataCpt(2) <= '0';
            end if;

            if(EmptyF2 = OneToSet)then
                DataCpt(3) <= '1';
            elsif(EmptyF2 = FlagSet)then
                DataCpt(3) <= '0';
            end if;

        end if;
    end process;

end architecture;