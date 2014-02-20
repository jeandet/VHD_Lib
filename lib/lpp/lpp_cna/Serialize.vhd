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

--! Programme qui permet de sérialiser un vecteur

entity Serialize is
  port(
    clk,raz : in std_logic;                      --! Horloge et Reset du composant
    sclk    : in std_logic;                      --! Horloge Systeme
    vectin  : in std_logic_vector(15 downto 0);  --! Vecteur d'entrée
    send    : in std_logic;                      --! Flag, Une nouvelle donnée est présente
    sended  : out std_logic;                     --! Flag, La donnée a été sérialisée
    Data    : out std_logic                      --! Donnée numérique sérialisé
    );
end Serialize;


architecture ar_Serialize of Serialize is

type etat is (chargemT,serialize);
signal ect      : etat;

signal vector_int   : std_logic_vector(16 downto 0);
--signal vectin_reg   : std_logic_vector(15 downto 0);
--signal load         : std_logic;
signal send_reg         : std_logic;

signal N            : integer range 0 to 16;
signal CPT_ended    : std_logic:='0';

begin
    process(clk,raz)
        begin
        if(raz='0')then           
            ect         <= chargemT;
--            vectin_reg  <= (others=> '0');
--            load        <= '0';
            sended      <= '1';            

        elsif(clk'event and clk='1')then 
            
--            vectin_reg <= vectin;
          
            case ect is
                when chargemT =>                     
                    if (send='1') then 
                        sended  <= '0'; 
--                        load    <= '1';                   
                        ect     <= serialize;                                               
                    end if;
                
                when serialize => 
--                    load <= '0';
                    if(N=14)then
                        sended <= '1';
                    end if;
                                        
                    if(CPT_ended='1')then 
                        ect     <= chargemT;
--                        sended  <= '1';                        
                    end if;

--                when attente =>
--                    if(send='0')then
--                        ect <= chargemT;
--                    end if;

            end case;
        end if;
    end process;

    process(sclk,raz)
        begin
        if (raz='0')then
            vector_int <= (others=> '0');
            N <= 16;
--        elsif(send='1')then
--            vector_int <= vectin & '0';
--            N <= 0;
        elsif(sclk'event and sclk='1')then
            send_reg <= send;
            
            
            if(send_reg='1' and send='0')then
                vector_int <= vectin & '0';
            elsif(send='1')then
                N <= 0;
            elsif (CPT_ended='0') then
                vector_int <= vector_int(15 downto 0) & '0'; 
                N <= N+1;
            end if; 
        end if;
    end process;

CPT_ended   <=  '1' when N = 16 else '0';

with ect select
    Data <=  vector_int(16) when serialize,
            '0' when others;
     
end ar_Serialize;
            
