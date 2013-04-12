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

entity Dispatch is
generic(
    Data_SZ  : integer := 32);
port(
    clk         : in std_logic;
    reset       : in std_logic;
    Acq         : in std_logic;
    Data        : in std_logic_vector(Data_SZ-1 downto 0);
    Write       : in std_logic;
    Full        : in std_logic_vector(1 downto 0);
    FifoData    : out std_logic_vector(2*Data_SZ-1 downto 0);
    FifoWrite   : out std_logic_vector(1 downto 0);
    Pong        : out std_logic;
    Error       : out std_logic
);
end entity;


architecture ar_Dispatch of Dispatch is

type etat is (eX,e0,e1,e2);
signal ect : etat;

signal Pong_int : std_logic;
signal FifoCpt : integer range 0 to 1 := 0;

begin

 process (clk,reset)
    begin
        if(reset='0')then
            Pong_int    <= '0';
            Error   <= '0';
            ect <= e0;   
            
        elsif(clk' event and clk='1')then

            case ect is

                when e0 =>
                    if(Full(FifoCpt) = '1')then
                        Pong_int <= not Pong_int;
                        ect <= e1;
                    end if;

                when e1 =>
                    if(Acq = '0')then
                        Error <= '1';
                        ect <= e1;
                    else
                        Error <= '0';
                        ect <= e0;
                    end if;                  
                        
                when others =>
                    null;  

            end case;

        end if;
    end process;

FifoData <= Data & Data;
Pong <= Pong_int;

FifoCpt <= 0 when Pong_int='0' else 1;

FifoWrite <= '1' & not Write when Pong_int='0' else not Write & '1';
                    
end architecture;