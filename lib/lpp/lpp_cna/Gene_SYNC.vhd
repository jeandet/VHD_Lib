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
    SCLK,raz : in std_logic;     --! Horloge systeme et Reset du composant
    enable : in std_logic;       --! Autorise ou non l'utilisation du composant
    Sended : out std_logic;   --! Flag, Autorise l'envoi (sérialisation) d'une nouvelle donnée
    SYNC : out std_logic         --! Signal de synchronisation du convertisseur généré
    );
end Gene_SYNC;

--! @details NB: Ce programme est uniquement synchronisé sur l'horloge Systeme (sclk)

architecture ar_Gene_SYNC of Gene_SYNC is

signal count : integer;

begin 
    process (SCLK,raz)
    begin
        if(raz='0')then
            SYNC <= '0';
            count <= 14;  
            Sended <= '0';
        
        elsif(SCLK' event and SCLK='1')then    
            if(enable='1')then

                if(count=15)then
                    SYNC <= '1';
                    count <= count+1;
                elsif(count=16)then
                    count <= 0;
                    SYNC <= '0';
                    Sended <= '1';
                else
                    count <= count+1;
                    Sended <= '0';
                end if;

            end if;
      	end if;
    end process;
end ar_Gene_SYNC;