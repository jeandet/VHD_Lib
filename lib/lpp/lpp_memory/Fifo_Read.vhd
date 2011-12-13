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

--! Programme de la FIFO de lecture

entity Fifo_Read is
generic(
    Addr_sz      : integer := 8;
    addr_max_int : integer := 256);
port( 
    clk,raz : in std_logic;                              --! Horloge et reset general du composant
    flag_RE : in std_logic;                              --! Flag, Demande la lecture de la mémoire
--    flag_WR : in std_logic;
--    ReUse   : in std_logic;                              --! Flag, Permet de relire la mémoire du début
    Waddr   : in std_logic_vector(addr_sz-1 downto 0);   --! Adresse du registre d'écriture dans la mémoire
    empty   : out std_logic;                             --! Flag, Mémoire vide
    Raddr   : out std_logic_vector(addr_sz-1 downto 0)   --! Adresse du registre de lecture de la mémoire
    );
end Fifo_Read;

--! @details En aval de la SRAM Gaisler

architecture ar_Fifo_Read of Fifo_Read is

signal Rad_int      : integer range 0 to addr_max_int;
signal Rad_int_reg  : integer range 0 to addr_max_int;
signal Wad_int      : integer range 0 to addr_max_int;
signal Wad_int_reg  : integer range 0 to addr_max_int;
signal s_empty     : std_logic;

begin 
    process (clk,raz)
    begin
        if(raz='0')then
            Rad_int <= 0;            
            s_empty   <= '1';

        elsif(clk' event and clk='1')then
            Wad_int_reg <= Wad_int;
            Rad_int_reg <= Rad_int;
    

            if(flag_RE='1')then

                if(s_empty = '0')then
                    if(Rad_int=addr_max_int-1)then
                        Rad_int <= 0;               
--                    elsif(Rad_int=Wad_int-1)then
--                        Rad_int <= Rad_int+1;
--                        s_empty <= '1';
                    else
                        Rad_int <= Rad_int+1;
                    end if;
                end if;
                
                if(Rad_int=Wad_int-1)then
                    s_empty <= '1';
                elsif(Rad_int=addr_max_int-1 and Wad_int=0)then
                    s_empty <= '1';
                end if;
            
            end if;          
            
            
            if(Wad_int_reg /= Wad_int)then
                if(s_empty='1')then
                    s_empty <= '0';
                end if;
            end if;
                        
        end if;

    end process;

Wad_int  <= to_integer(unsigned(Waddr));
Raddr    <= std_logic_vector(to_unsigned(Rad_int,addr_sz));
empty <= s_empty;

end ar_Fifo_Read;