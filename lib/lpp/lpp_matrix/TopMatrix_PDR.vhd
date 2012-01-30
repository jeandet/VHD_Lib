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

entity TopMatrix_PDR is
generic(
    Input_SZ  : integer := 16);
port(
    clk         : in std_logic;
    reset       : in std_logic;
    Data        : in std_logic_vector((5*Input_SZ)-1 downto 0);
    FULLin      : in std_logic_vector(4 downto 0);
    READin      : in std_logic_vector(1 downto 0);
    WRITEin     : in std_logic;
    FIFO1       : out std_logic_vector(Input_SZ-1 downto 0);
    FIFO2       : out std_logic_vector(Input_SZ-1 downto 0);    
    Start       : out std_logic;
    Read        : out std_logic_vector(4 downto 0);
    Statu       : out std_logic_vector(3 downto 0)  
);
end entity;

architecture ar_TopMatrix_PDR of TopMatrix_PDR is

type state is (st0,st1,st2,st3);
signal ect : state;

signal i,j          : integer;
signal full_int     : std_logic_vector(1 downto 0);
signal WRITEin_reg  : std_logic;

begin
    process(clk,reset)
    begin
    
        if(reset='0')then
            i <= 1;
            j <= 0;
            Start <= '0';
            WRITEin_reg <= '0';
            ect <= st0;
        
        elsif(clk'event and clk='1')then
            WRITEin_reg <= WRITEin;
              
            case ect is
                
                when st0 =>  
                    if(full_int = "11")then
                        Start <= '1';
                        ect <= st1;
                    end if;
                
                when st1 =>
                    if(WRITEin_reg='1' and WRITEin='0')then
                        if(i=1 or i=3 or i=6 or i=10 or i=15)then
                            ect <= st2;
                        else
                            ect <= st3;
                        end if;
                    end if;  
                     
                when st2 =>
                    if(j=127)then
                        if(i=15)then
                            i <= 1;
                        else
                            i <= i+1;
                        end if;
                        j <= 0;
                        Start <= '0';
                        ect <= st0;
                    elsif(WRITEin_reg='1' and WRITEin='0')then
                        j <= j+1; 
                    end if;
                        
                when st3 =>
                    if(j=255)then
                        j <= 0;
                        i <= i+1;
                        Start <= '0';
                        ect <= st0;                    
                    elsif(WRITEin_reg='1' and WRITEin='0')then
                        j <= j+1; 
                    end if;
                
            end case;
        end if;
    end process;

Statu <= std_logic_vector(to_unsigned(i,4));
                    
with i select
    FIFO1 <=    Data(15 downto 0) when 1,
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


with i select
    FIFO2 <=    (others => '0') when 1,
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

with i select
    Read <=     "1111" & not READin(0) when 1,
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

with i select
    full_int <= FULLin(0) & FULLin(0) when 1,
                FULLin(1) & FULLin(0) when 2,
                FULLin(1) & FULLin(1) when 3,
                FULLin(2) & FULLin(0) when 4,
                FULLin(2) & FULLin(1) when 5,
                FULLin(2) & FULLin(2) when 6,
                FULLin(3) & FULLin(0) when 7,
                FULLin(3) & FULLin(1) when 8,
                FULLin(3) & FULLin(2) when 9,
                FULLin(3) & FULLin(3) when 10,
                FULLin(4) & FULLin(0) when 11,
                FULLin(4) & FULLin(1) when 12,
                FULLin(4) & FULLin(2) when 13,
                FULLin(4) & FULLin(3) when 14,
                FULLin(4) & FULLin(4) when 15,
                "00" when others;

end architecture;






