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

--! Programme qui va permettre de "pipeliner" la FIFO, donn�e disponible en sortie d� son �criture en entr�e de la FIFO

entity PipeLine is
generic(Data_sz : integer := 16);
port( 
    clk,raz  : in std_logic;                             --! Horloge et reset general du composant
    Data_in  : in std_logic_vector(Data_sz-1 downto 0);  --! Donn�e en entr�e de la FIFO, cot� �criture
    flag_RE  : in std_logic;                             --! Flag, Demande la lecture de la m�moire
    flag_WR  : in std_logic;                             --! Flag, Demande l'�criture dans la m�moire
    empty    : in std_logic;                             --! Flag, M�moire vide
    Data_svg : out std_logic_vector(Data_sz-1 downto 0);
    Data1 : out std_logic;
    Data2 : out std_logic 
    );
end PipeLine;

architecture ar_PipeLine of PipeLine is

type etat is (e0,e1,e2,st0,st1,st2);
signal ect : etat;

begin 
    process (clk,raz)
    begin
        if(raz='0')then
            Data1 <= '0';
            Data2 <= '0';
            ect      <= e0;
            
        elsif(clk' event and clk='1')then
            Data_svg <= Data_in;

            case ect is
                when e0 =>
                    Data2 <= '0';                    
                    if(flag_WR='1')then
                        Data1 <= '1';                        
                        ect      <= st2;              
                    end if;

                when st2 =>
                    Data1 <= '0';
                    ect <= e1;

                when e1 =>                    
                    if(flag_RE='1')then
                        ect      <= st0;
                    end if;                

                when st0 =>                    
                    ect <= st1;

                when st1 =>
                    Data2 <= '1';                    
                    ect <= e2;


                when e2 =>                    
                    if(empty='1')then
                        ect <= e0;
                    else
                        ect      <= e2;
                    end if;


            end case;                        
        end if;
    end process;
    
end ar_PipeLine;



















