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

entity TopSpecMatrix is
generic(
    Input_SZ  : integer := 16);
port(
    clk         : in std_logic;
    rstn       : in std_logic;
    Write       : in std_logic;
    ReadIn      : in std_logic_vector(1 downto 0);
    Full        : in std_logic_vector(4 downto 0);
    Data        : in std_logic_vector((5*Input_SZ)-1 downto 0);
    Start       : out std_logic;
    ReadOut     : out std_logic_vector(4 downto 0);
    Statu       : out std_logic_vector(3 downto 0); 
    DATA1       : out std_logic_vector(Input_SZ-1 downto 0);
    DATA2       : out std_logic_vector(Input_SZ-1 downto 0)
);
end entity;

architecture ar_TopSpecMatrix of TopSpecMatrix is

type etat is (eX,e0,e1,e2);
signal ect : etat;

signal DataCount    : integer range 0 to 256 := 0;
signal StatuINT    : integer range 1 to 15 := 1;

signal Write_reg : std_logic;
signal Full_int : std_logic_vector(1 downto 0);

begin
    process(clk,rstn)
    begin
    
        if(rstn='0')then
            DataCount <= 0;
            StatuINT <= 1;
            Write_reg <= '0';
            Start <= '0';
            ect <= e0;
        
        elsif(clk'event and clk='1')then
            Write_reg <= Write;
              
            if(Write_reg='1' and Write='0')then
                if(DataCount=256)then
                    DataCount <= 0;
                else
                    DataCount <= DataCount + 1;
                end if;
            end if;            
            
            
            case ect is
                
                when e0 =>  
                    if(Full_int = "11")then
                        Start <= '1';
                        if(StatuINT=1 or StatuINT=3 or StatuINT=6 or StatuINT=10 or StatuINT=15)then
                            ect <= e1; 
                        else
                            ect <= e2;
                        end if;      
                    end if;
                     
                when e1 =>
                    if(DataCount=128)then
                        if(StatuINT=15)then
                            StatuINT <= 1;
                        else
                            StatuINT <= StatuINT + 1;
                        end if;
                        DataCount <= 0;
                        Start <= '0';
                        ect <= e0;
                    end if;
                        
                when e2 =>
                    if(DataCount=256)then
                        DataCount <= 0;
                        StatuINT <= StatuINT + 1;
                        Start <= '0';
                        ect <= e0;
                    end if;
               
                when others =>
                    null;
                
            end case;
        end if;
    end process;

Statu <= std_logic_vector(to_unsigned(StatuINT,4));
                    
with StatuINT select
    DATA1 <=    Data(15 downto 0) when 1,
                Data(15 downto 0) when 2,
                Data(31 downto 16) when 3,
                Data(15 downto 0) when 4,
                Data(31 downto 16) when 5,
                Data(47 downto 32) when 6,
                Data(15 downto 0) when 7,
                Data(31 downto 16) when 8,
                Data(47 downto 32) when 9,
                Data(63 downto 48) when 10,
                Data(15 downto 0) when 11,
                Data(31 downto 16) when 12,
                Data(47 downto 32) when 13,
                Data(63 downto 48) when 14,
                Data(79 downto 64) when 15,
                X"0000" when others;


with StatuINT select
    DATA2 <=    (others => '0') when 1,
                Data(31 downto 16) when 2,
                (others => '0') when 3,
                Data(47 downto 32) when 4,
                Data(47 downto 32) when 5,
                (others => '0') when 6,
                Data(63 downto 48) when 7,
                Data(63 downto 48) when 8,
                Data(63 downto 48) when 9,
                (others => '0') when 10,
                Data(79 downto 64) when 11,
                Data(79 downto 64) when 12,
                Data(79 downto 64) when 13,
                Data(79 downto 64) when 14,
                (others => '0') when 15,
                X"0000" when others;

with StatuINT select
    ReadOut <=     "1111" & not READin(0) when 1,
                "111" & not READin(1) & not READin(0) when 2,
                "111" & not READin(0) & '1' when 3,
                "11" & not READin(1) & '1' & not READin(0) when 4,
                "11" & not READin(1) & not READin(0) & '1' when 5,
                "11" & not READin(0) & "11" when 6,
                "1" & not READin(1) & "11" & not READin(0) when 7,
                '1' & not READin(1) & '1' & not READin(0) & '1' when 8,
                '1' & not READin(1) & not READin(0) & "11" when 9,
                '1' & not READin(0) & "111" when 10,
                not READin(1) & "111" &  not READin(0) when 11,
                not READin(1) & "11" & not READin(0) & '1' when 12,
                not READin(1) & '1' & not READin(0) & "11" when 13,
                not READin(1) & not READin(0) & "111" when 14,
                not READin(0) & "1111" when 15,
                "11111" when others;

with StatuINT select
    Full_int <= Full(0) & Full(0) when 1,
                Full(1) & Full(0) when 2,
                Full(1) & Full(1) when 3,
                Full(2) & Full(0) when 4,
                Full(2) & Full(1) when 5,
                Full(2) & Full(2) when 6,
                Full(3) & Full(0) when 7,
                Full(3) & Full(1) when 8,
                Full(3) & Full(2) when 9,
                Full(3) & Full(3) when 10,
                Full(4) & Full(0) when 11,
                Full(4) & Full(1) when 12,
                Full(4) & Full(2) when 13,
                Full(4) & Full(3) when 14,
                Full(4) & Full(4) when 15,
                "00" when others;

end architecture;






