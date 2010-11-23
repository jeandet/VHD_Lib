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
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity GeneSYNC_flag is

port( 
    clk,raz     : in std_logic;
    flag_nw     : in std_logic;
    Sysclk      : in std_logic;
    OKAI_send   : out std_logic;
    SYNC        : out std_logic
);

end GeneSYNC_flag;


architecture ar_GeneSYNC_flag of GeneSYNC_flag is

signal Sysclk_reg : std_logic;
signal flag_nw_reg : std_logic;
signal count : integer;

type etat is (e0,e1,e2,eX);
signal ect : etat;

begin 
    process (clk,raz)
    begin
        if(raz='0')then
            SYNC <= '0';
            Sysclk_reg <= '0';
            flag_nw_reg <= '0'; 
            count <= 14;  
            OKAI_send <= '0'; 
            ect <= e0;        
            
        elsif(clk' event and clk='1')then
            Sysclk_reg <= Sysclk;
            flag_nw_reg <= flag_nw;
            
            case ect is
                when e0 =>
                    if(flag_nw_reg='0' and flag_nw='1')then
                        ect <= e1;
                    else
                        count <= 14;
                        ect <= e0;
                    end if;


                when e1 =>
                    if(Sysclk_reg='1' and Sysclk='0')then
                        if(count=15)then
                            SYNC <= '1';
                            count <= count+1;
                            ect <= e2;
                        elsif(count=16)then
                            count <= 0;
                            OKAI_send <= '1';
                            ect <= eX;
                        else
                            count <= count+1;
                            OKAI_send <= '0';
                            ect <= e1;
                        end if; 
                    end if;       
            
            
                when e2 =>
                    if(Sysclk_reg='0' and Sysclk='1')then
                        if(count=16)then
                            SYNC <= '0';
                            ect <= e1;
                        end if;                        
                    end if;
                
                when eX =>
                    if(Sysclk_reg='0' and Sysclk='1')then
                        if(count=15)then                       
                            OKAI_send <= '0';
                            ect <= e0;
                        else
                            count <= count+1;
                            ect <= eX;
                        end if;
                    end if;

            end case;
        end if;
  
    end process;
end ar_GeneSYNC_flag;
