------------------------------------------------------------------------------
--  This file is a part of the LPP VHDL IP LIBRARY
--  Copyright (C) 2009 - 2012, Laboratory of Plasmas Physic - CNRS
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

entity WriteGen_ADC is
    port(
        clk         : in std_logic;
        rstn        : in std_logic;
        SmplCLK     : in std_logic;
        DataReady   : in std_logic;
        Full        : in std_logic_vector(4 downto 0);
        ReUse       : out std_logic_vector(4 downto 0);
        Write       : out std_logic_vector(4 downto 0)
    );
end entity;


architecture ar_WG of WriteGen_ADC is

type etat is (e0,e1,eX);
signal ect : etat;

signal ReUse_reg  : std_logic_vector(4 downto 0);

begin

    process(clk,rstn)
    begin
        if(rstn='0')then 
            ect <= e0;
            ReUse_reg <= (others => '0');
            write <= (others => '1'); 
            
        elsif(clk'event and clk='1')then
            ReUse_reg <= Full or ReUse_reg;

            case ect is

                when e0 =>
                    if(DataReady='0' and SmplCLK='1')then                        
                        ect <= e1;
                    end if;

                when e1 =>                    
                    if(DataReady='1')then
                        Write <= Full;                        
                        ect <= eX;
                    end if;   
                
                when eX =>
                    write <= (others => '1');
                    ect <= e0;

            end case;
        end if;
    end process;


ReUse <= ReUse_reg;

end architecture;

