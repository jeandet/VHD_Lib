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

--! Programme qui va permettre de générer le signal SYNC

entity Gene_SYNC is
  port(
    SysClk,raz : in std_logic;     --! Horloge systeme et Reset du composant
    SCLK : in std_logic;
    enable : in std_logic;       --! Autorise ou non l'utilisation du composant
    sended : in std_logic;
    send : out std_logic;   --! Flag, Autorise l'envoi (sérialisation) d'une nouvelle donnée
    Readn : out std_logic;
    SYNC : out std_logic         --! Signal de synchronisation du convertisseur généré
    );
end Gene_SYNC;


architecture ar_Gene_SYNC of Gene_SYNC is

--signal count : integer;
signal SysClk_reg : std_logic;

type etat is (e0,e1,e2,e3);
signal ect : etat;

begin 
    process (SCLK,raz)
    begin
        if(raz='0')then
            ect <= e0;
            SYNC <= '1';
            Readn <= '1';
----            count <= 14;  
            Send <= '0';
        
        elsif(SCLK' event and SCLK='1')then 
            SysClk_reg <= SysClk;
               
            if(enable='1')then
                
                case ect is
                    when e0 => 
                        if(SysClk_reg='0' and SysClk='1')then
--                            SYNC <= '0';
                            Readn <= '0';
                            Send <= '1';
                            ect <= e1;
                        end if;
                
                    when e1 =>
                        Readn <= '1';
--                        SYNC <= '0';
                        send <= '0';
                        ect <= e2;

                    when e2 =>
                        SYNC <= '0';
                        ect <= e3;

                    when e3 =>
                        if(sended='1')then
                            SYNC <= '1';                            
                            ect <= e0;
                        end if;
                        
--                        if(count=15)then
--                            SYNC <= '1';
--                            count <= count+1;
--                        if(Ready='1')then
----                            count <= 0;
--                            SYNC <= '1';
--                            
--                            ect <= e0;
----                            count <= count+1;
--                            Send <= '0';                           
--                        end if;

                end case;
            end if;
      	end if;
    end process;
end ar_Gene_SYNC;