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
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;

entity ReadFifo_GEN is
  port(
    clk,raz : in std_logic;                      --! Horloge et Reset du composant
    SYNC : in std_logic;
    Readn : out std_logic
    );
end entity;


architecture ar_ReadFifo_GEN of ReadFifo_GEN is

type etat is (eX,e0);
signal ect      : etat;

signal SYNC_reg : std_logic;

begin
    process(clk,raz)
        begin
        if(raz='0')then           
            ect         <= eX;
            Readn  <= '1';           

        elsif(clk'event and clk='1')then
            SYNC_reg <= SYNC;
          
            case ect is
                when eX =>                     
                    if (SYNC_reg='0' and  SYNC='1') then 
                        Readn    <= '0';                   
                        ect     <= e0;                      
                    end if;
                
                when e0 => 
                    Readn <= '1';                    
                    ect <= eX;

            end case;
        end if;
    end process;

end architecture;