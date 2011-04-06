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
--                        Author : Martin Morlot
--                     Mail : martin.morlot@lpp.polytechnique.fr
------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.FFT_config.all;

entity Flag_Extremum is
  port(
    clk,raz    : in std_logic;
    load       : in std_logic;
    y_rdy      : in std_logic;
    full       : out std_logic;
    empty      : out std_logic    
    );
end Flag_Extremum;

architecture ar_Flag_Extremum of Flag_Extremum is

--type etat is (eA,eB,eC,e0,e1,e2);
--signal ect : etat;

signal load_reg : std_logic;
signal y_rdy_reg : std_logic;

begin 
    process (clk,raz)
    begin
        if(raz='0')then
            full  <= '1';
            empty <= '1';            
--            ect   <= eA;        
            
        elsif(clk' event and clk='1')then       
--            load_reg  <= load;
--            y_rdy_reg <= y_rdy;

            if(load='1' and y_rdy='0')then
                full <= '0';
                empty <= '1';
            
            elsif(y_rdy='1')then
                full <= '1';
                empty <= '0';

            else
                full  <= '1';
                empty <= '1';

            end if;

--            case ect is

--                when eA => 
--                    if(load_reg='0' and load='1')then
--                        full <= '0';
--                        ect <= eB;
--                    end if;
--                    
--                when eB =>
--                    if(load_reg='1' and load='0')then
--                        ect <= eC;
--                    end if;
--                    
--                when eC =>
--                    if(load_reg='1' and load='0')then
--                        full <= '1';
--                        ect <= e0;
--                    end if;

--===================================================================================

--                when e0 => 
--                    if(load_reg='0' and load='1')then
--                        full <= '0';
--                        ect <= e1;
--                    end if;
--                    
--                when e1 =>
--                    if(load_reg='1' and load='0')then
--                        full <= '1';
--                        empty <= '0';
--                        ect <= e2;
--                    end if;
--                    
--                when e2 => 
--                    if(y_rdy_reg='1' and y_rdy='0')then  
--                        empty <= '1';
--                        ect <= e0;
--                    end if;
--                        
--
--            end case;
        end if;
    end process;

end ar_Flag_Extremum;

                


