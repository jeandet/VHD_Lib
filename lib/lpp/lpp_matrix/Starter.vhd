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
--                    Author : Martin Morlot
--                   Mail : martin.morlot@lpp.polytechnique.fr
-------------------------------------------------------------------------------
library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;

entity Starter is
port(
    clk     : in  std_logic;
    raz     : in  std_logic;
    Full    : in  std_logic_vector(1 downto 0);
    Empty    : in  std_logic_vector(1 downto 0);
    Conjugate : in std_logic;
    received : in std_logic;
    Start    : out std_logic
);
end Starter;


architecture ar_Starter of Starter is

type etat is (eX,e0,e1);
signal ect : etat;

signal received_reg : std_logic;

begin
    process(clk,raz)
    begin
    
        if(raz='0')then
            Start <= '0';
            ect <= eX;

        elsif(clk'event and clk='1')then
            received_reg <= received;

            case ect is
               when eX =>
                   if(Conjugate='0')then
                       if(full="11")then
                           Start <= '1';
                           ect <= e0;
                       end if;
                   else
                       if(full(0)='1')then
                           Start <= '1';
                           ect <= e0;
                       end if;
                   end if;

                when e0 =>
                   if(Conjugate='0')then
                       if(empty="11")then
                           --Start <= '0';
                           ect <= e1;
                       end if;
                   else
                       if(empty(0)='1')then
                           --Start <= '0';
                           ect <= e1;
                       end if;
                   end if;

                when e1 =>
                    if(received_reg='1' and received='0')then
                        Start <= '0';
                        ect <= eX;
                    end if; 
                    
           end case;

        end if;
    end process;

end ar_Starter;
    


















