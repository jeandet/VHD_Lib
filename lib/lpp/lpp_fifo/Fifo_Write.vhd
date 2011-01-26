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
------------------------------------------------------------------------------
--                    Author : Martin Morlot
--                     Mail : martin.morlot@lpp.polytechnique.fr
------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.FIFO_Config.all;

--! Programme de la FIFO d'écriture

entity Fifo_Write is
port( 
    clk,raz : in std_logic;                               --! Horloge et reset general du composant
    flag_WR : in std_logic;                               --! Flag, Demande l'écriture dans la mémoire
    RAD     : in integer range 0 to addr_max_int;         --! Adresse du registre de lecture de la mémoire (forme entière)
    full    : out std_logic;                              --! Flag, Mémoire pleine
    WAD     : out integer range 0 to addr_max_int;        --! Adresse du registre d'écriture dans la mémoire (forme entière)
    Waddr   : out std_logic_vector(addr_sz-1 downto 0)    --! Adresse du registre d'écriture dans la mémoire (forme vectorielle)
    );
end Fifo_Write;

--! @details En amont de la SRAM Gaisler

architecture ar_Fifo_Write of Fifo_Write is

signal Wad_int : integer range 0 to addr_max_int;
signal full_int : std_logic;

begin 
    process (clk,raz)
    begin
        if(raz='0')then
            Wad_int  <= 0;
            full_int <= '0';            
            
        elsif(clk' event and clk='1')then
            if(flag_WR='1')then
                if(Wad_int=addr_max_int)then
                    Wad_int <= 0;
                elsif(full_int='1')then
                    Wad_int <= Wad_int;         
                else
                    Wad_int <= Wad_int+1;                 
                end if;
            end if;
            if(Wad_int=RAD-1 or (Wad_int=addr_max_int and RAD=0))then
                full_int <= '1';
            else
                full_int <= '0';
            end if;
        end if;
    end process;

full  <= full_int;
WAD   <= Wad_int;
Waddr <= std_logic_vector(to_unsigned(Wad_int,addr_sz));
end ar_Fifo_Write;