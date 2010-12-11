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
-- Gene_SYNC.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Gene_SYNC is

port( 
    SCLK,raz : in std_logic;
    enable : in std_logic;
--    Sysclk : in std_logic;
    OKAI_send : out std_logic;
    SYNC : out std_logic
);

end Gene_SYNC;


architecture ar_Gene_SYNC of Gene_SYNC is

--signal Sysclk_reg : std_logic;
signal count : integer;


begin 
    process (SCLK,raz)
    begin
        if(raz='0')then
            SYNC <= '0';
--            Sysclk_reg <= '0'; 
            count <= 14;  
            OKAI_send <= '0';         
        
        elsif(SCLK' event and SCLK='1')then    
            if(enable='1')then
            
--            Sysclk_reg <= Sysclk;
                if(count=15)then
                    SYNC <= '1';
                    count <= count+1;
                elsif(count=16)then
                    count <= 0;
                    SYNC <= '0';
                    OKAI_send <= '1';
                else
                    count <= count+1;
                    OKAI_send <= '0';
                end if;
            end if;
      	end if;
  	end process;
  	
end ar_Gene_SYNC;