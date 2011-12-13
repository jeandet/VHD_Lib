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
--  along with this program; if not, Write_int to the Free Software
--  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA 
-------------------------------------------------------------------------------
--                    Author : Martin Morlot
--                   Mail : martin.morlot@lpp.polytechnique.fr
-------------------------------------------------------------------------------
library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;

entity LocalReset is
    port(
        clk         : in  std_logic;
        raz         : in std_logic;
        Rz          : in  std_logic;
        rstf        : out  std_logic        
    );
end LocalReset;


architecture ar_LocalReset of LocalReset is

signal Rz_reg : std_logic;

type state is (st0);
signal ect : state;

begin
    process(clk,raz)
    begin
    
        if(raz='0')then
            rstf <= '0';
            ect  <= st0;            
                               
        elsif(clk'event and clk='1')then
            Rz_reg <= Rz;

            case ect is

                when st0 =>
                    rstf <= '1';
                    if(Rz_reg='0' and Rz='1')then
                        rstf <= '0';
                        ect  <= st0;
                    elsif(Rz_reg='1' and Rz='0')then
                        rstf <= '0';
                        ect  <= st0;
                    end if;                   

            end case;
        end if;
    end process;

end ar_LocalReset;