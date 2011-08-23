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

entity DriveInputs is
port(
    clk     : in  std_logic;
    raz     : in  std_logic;
    Read    : in  std_logic;
--    FIFO1      : in std_logic_vector(Input_SZ-1 downto 0);
--    FIFO2      : in std_logic_vector(Input_SZ-1 downto 0);
--    Statu : in std_logic_vector(3 downto 0);
    Conjugate : in std_logic;
    Take    : out std_logic;
    ReadFIFO : out std_logic_vector(1 downto 0)
--    OP1     : out std_logic_vector(Input_SZ-1 downto 0);    
--    OP2     : out std_logic_vector(Input_SZ-1 downto 0)
);
end DriveInputs;


architecture ar_DriveInputs of DriveInputs is

signal Read_reg : std_logic;
signal i : integer range 0 to 128;
--signal j : integer range 0 to 15;
--signal Read_int : std_logic_vector(4 downto 0);

type state is (stX,sta,stb,st1,st2,idl1,idl2);
signal ect : state;

begin
    process(clk,raz)
    begin
    
        if(raz='0')then
            Take <= '0';
            i <= 0;
            ReadFIFO <= "00";
--            j <= 0;
            Read_reg <= '0';
            ect <= stX;
        
        elsif(clk'event and clk='1')then
            Read_reg <= Read;
              
            case ect is

                when stX =>
                    i <= 1;                    
                    if(Read_reg='0' and Read='1')then
--                        if(j=15)then
--                            j <= 1;
--                        else
--                            j<= j+1;
--                        end if;
                        ect <= idl1;
                    end if;                

                when idl1 =>
                    if(Conjugate='1')then
                        ReadFIFO <= "01";
                    else
                        ReadFIFO <= "11";
                    end if;
                    ect <= st1;                
                
                when st1 =>
                    ReadFIFO <= "00";
                    ect <= sta;
                
                when sta =>
                    Take <= '1';
                    if(Read_reg='0' and Read='1')then
                        ect <= idl2;
                    end if;

                when idl2 =>
                    if(Conjugate='1')then
                        ReadFIFO <= "01";
                    else
                        ReadFIFO <= "11";
                    end if;
                    ect <= st2;
                
                when st2 =>
                    ReadFIFO <= "00";
                    ect <= stb;
                
                when stb =>
                    Take <= '0';                     
                    if(i=128)then                        
                        ect <= stX;
                    elsif(Read_reg='0' and Read='1')then
                        i <= i+1;
                        ect <= idl1;                                            
                    end if;

            end case;
        end if;
    end process;


end ar_DriveInputs;