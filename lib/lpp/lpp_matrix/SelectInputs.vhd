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

entity SelectInputs is
generic(
    Input_SZ : integer := 16);
port(
    clk     : in  std_logic;
    raz     : in  std_logic;
    Read    : in  std_logic;
    B1      : in std_logic_vector(Input_SZ-1 downto 0);
    B2      : in std_logic_vector(Input_SZ-1 downto 0);
    B3      : in std_logic_vector(Input_SZ-1 downto 0);
    E1      : in std_logic_vector(Input_SZ-1 downto 0);
    E2      : in std_logic_vector(Input_SZ-1 downto 0);
    Conjugate : out std_logic;
    Take    : out std_logic;
    ReadFIFO : out std_logic_vector(4 downto 0); --B1,B2,B3,E1,E2    
    OP1     : out std_logic_vector(Input_SZ-1 downto 0);    
    OP2     : out std_logic_vector(Input_SZ-1 downto 0)
);
end SelectInputs;


architecture ar_SelectInputs of SelectInputs is

signal Read_reg : std_logic;
signal i : integer range 1 to 15;

type state is (stX,st1a,st1b);
signal ect : state;

begin
    process(clk,raz)
    begin
    
        if(raz='0')then
            Take <= '0';
            i <= 0;
            Read_reg <= '0';
            ect <= stX;
        
        elsif(clk'event and clk='1')then
            Read_reg <= Read;
              
            case ect is
                when stX =>
                     i <= 1;
                    if(Read_reg='0' and Read='1')then
                        ect <= st1a;
                    end if;                
-------------------------------------------------------------------------------
                when st1a =>
                    Take <= '1';                  
                    if(Read_reg='0' and Read='1')then
                        ect <= st1b;
                    end if;

                when st1b =>
                    Take <= '0';
                    if(i=15)then
                        ect <= stX;
                    elsif(Read_reg='0' and Read='1')then
                        i <= i+1;
                        ect <= st1a;                                            
                    end if;
-------------------------------------------------------------------------------
--                when st2a =>
--                    Take <= '1';                  
--                    if(Read_reg='0' and Read='1')then
--                        ect <= st2b;
--                    end if;
--
--                when st2b =>
--                    Take <= '0';
--                    if(Read_reg='0' and Read='1')then
--                        ect <= st3a;                        
--                    end if;
---------------------------------------------------------------------------------
--                when st3a =>
--                    Take <= '1';                  
--                    if(Read_reg='0' and Read='1')then
--                        ect <= st3b;
--                    end if;
--
--                when st3b =>
--                    Take <= '0';
--                    if(Read_reg='0' and Read='1')then
--                        ect <= st4a;                        
--                    end if;
---------------------------------------------------------------------------------
--                when st4a =>
--                    Take <= '1';                  
--                    if(Read_reg='0' and Read='1')then
--                        ect <= st4b;
--                    end if;
--
--                when st4b =>
--                    Take <= '0';
--                    if(Read_reg='0' and Read='1')then
--                        ect <= st5a;                        
--                    end if;
---------------------------------------------------------------------------------
--                
--                when st5a =>
--                    Take <= '1';                  
--                    if(Read_reg='0' and Read='1')then
--                        ect <= st5b;
--                    end if;
--
--                when st5b =>
--                    Take <= '0';
--                    if(Read_reg='0' and Read='1')then
--                        ect <= st6a;                        
--                    end if;
---------------------------------------------------------------------------------
--                when st6a =>
--                    Take <= '1';                  
--                    if(Read_reg='0' and Read='1')then
--                        ect <= st6b;
--                    end if;
--
--                when st6b =>
--                    Take <= '0';
--                    if(Read_reg='0' and Read='1')then
--                        ect <= st7a;                        
--                    end if;
---------------------------------------------------------------------------------
--                when st7a =>
--                    Take <= '1';                  
--                    if(Read_reg='0' and Read='1')then
--                        ect <= st7b;
--                    end if;
--
--                when st7b =>
--                    Take <= '0';
--                    if(Read_reg='0' and Read='1')then
--                        ect <= st8a;                        
--                    end if;
---------------------------------------------------------------------------------
--                when st8a =>
--                    Take <= '1';                  
--                    if(Read_reg='0' and Read='1')then
--                        ect <= st8b;
--                    end if;
--
--                when st8b =>
--                    Take <= '0';
--                    if(Read_reg='0' and Read='1')then
--                        ect <= st9a;                        
--                    end if;
---------------------------------------------------------------------------------
--                when st9a =>
--                    Take <= '1';                  
--                    if(Read_reg='0' and Read='1')then
--                        ect <= st9b;
--                    end if;
--
--                when st9b =>
--                    Take <= '0';
--                    if(Read_reg='0' and Read='1')then
--                        ect <= st10a;                        
--                    end if;
---------------------------------------------------------------------------------
--                when st10a =>
--                    Take <= '1';                  
--                    if(Read_reg='0' and Read='1')then
--                        ect <= st10b;
--                    end if;
--
--                when st10b =>
--                    Take <= '0';
--                    if(Read_reg='0' and Read='1')then
--                        ect <= st11a;                        
--                    end if;
---------------------------------------------------------------------------------
--                when st11a =>
--                    Take <= '1';                  
--                    if(Read_reg='0' and Read='1')then
--                        ect <= st11b;
--                    end if;
--
--                when st11b =>
--                    Take <= '0';
--                    if(Read_reg='0' and Read='1')then
--                        ect <= st12a;                        
--                    end if;
---------------------------------------------------------------------------------
--                when st12a =>
--                    Take <= '1';                  
--                    if(Read_reg='0' and Read='1')then
--                        ect <= st12b;
--                    end if;
--
--                when st12b =>
--                    Take <= '0';
--                    if(Read_reg='0' and Read='1')then
--                        ect <= st13a;                        
--                    end if;
---------------------------------------------------------------------------------
--                when st13a =>
--                    Take <= '1';                  
--                    if(Read_reg='0' and Read='1')then
--                        ect <= st13b;
--                    end if;
--
--                when st13b =>
--                    Take <= '0';
--                    if(Read_reg='0' and Read='1')then
--                        ect <= st14a;                        
--                    end if;
---------------------------------------------------------------------------------
--                when st14a =>
--                    Take <= '1';                  
--                    if(Read_reg='0' and Read='1')then
--                        ect <= st14b;
--                    end if;
--
--                when st14b =>
--                    Take <= '0';
--                    if(Read_reg='0' and Read='1')then
--                        ect <= st15a;                        
--                    end if;
---------------------------------------------------------------------------------
--                when st15a =>
--                    Take <= '1';                  
--                    if(Read_reg='0' and Read='1')then
--                        ect <= st7_b;
--                    end if;
--
--                when st15b =>
--                    Take <= '0';
--                    if(Read_reg='0' and Read='1')then
--                        ect <= stX;                        
--                    end if;
-------------------------------------------------------------------------------
            end case;
        end if;
    end process;

with i select
    ReadFIFO <= "10000" when 1,
                "11000" when 2,
                "01000" when 3,
                "10100" when 4,
                "01100" when 5,
                "00100" when 6,
                "10010" when 7,
                "01010" when 8,
                "00110" when 9,
                "00010" when 10,
                "10001" when 11,
                "01001" when 12,
                "00101" when 13,
                "00011" when 14,
                "00001" when 15,                
                "00000" when others;                

--with ect select
--    ReadB2 <=   Read when st1,
--                Read when st2,
--                Read when st4,
--                Read when st7,
--                Read when st11,
--                '0' when others;
--
--with ect select
--    ReadB3 <=   Read when st3,
--                Read when st4,
--                Read when st5,
--                Read when st8,
--                Read when st12,
--                '0' when others;
--
--with ect select
--    ReadE1 <=   Read when st6,
--                Read when st7,
--                Read when st8,
--                Read when st9,
--                Read when st13,
--                '0' when others;
--
--with ect select
--    ReadE2 <=   Read when st10,
--                Read when st11,
--                Read when st12,
--                Read when st13,
--                Read when st14,
--                '0' when others;

with i select
    OP1 <=  B1 when 1,
            B1 when 2,
            B1 when 4,
            B1 when 7,
            B1 when 11,
            B2 when 3,
            B2 when 5,
            B2 when 8,
            B2 when 12,
            B3 when 6,
            B3 when 9,
            B3 when 13,
            E1 when 10,
            E1 when 14,
            E2 when 15,            
            X"FFFF" when others;

with i select
    OP2 <=  B1 when 1,
            B2 when 2,
            B2 when 3,
            B3 when 4,
            B3 when 5,
            B3 when 6,
            E1 when 7,
            E1 when 8,
            E1 when 9,
            E1 when 10,
            E2 when 11,
            E2 when 12,
            E2 when 13,
            E2 when 14,
            E2 when 15,
            X"FFFF" when others;

with i select 
    Conjugate <= '1' when 1,
                 '1' when 3,
                 '1' when 6,
                 '1' when 10,
                 '1' when 15,
                 '0' when others;   


--RE_FIFO <= ReadE2 & ReadE1 & ReadB3 & ReadB2 & ReadB1;
end ar_SelectInputs;