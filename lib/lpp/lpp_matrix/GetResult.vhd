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

entity GetResult is
generic(
    Result_SZ : integer := 32);
port(
    clk         : in  std_logic;
    raz         : in  std_logic;
    Valid       : in  std_logic;
    Conjugate   : in std_logic;
    Res         : in std_logic_vector(Result_SZ-1 downto 0);
--    Full        : in std_logic;
    WriteFIFO   : out std_logic;
    Received    : out std_logic;    
    Result      : out std_logic_vector(Result_SZ-1 downto 0)
);
end GetResult;


architecture ar_GetResult of GetResult is

signal Valid_reg : std_logic;

type state is (st0,st1,stX,stY);
signal ect : state;

begin
    process(clk,raz)
    begin
    
        if(raz='0')then
            Received <= '0';            
            Valid_reg <= '0';
            WriteFIFO <= '0';
            ect <= st0;
            Result <= (others => '0');
                    
        elsif(clk'event and clk='1')then
            Valid_reg <= Valid;

            case ect is
                when st0 =>
                    if(Valid='1')then--if(Full='0' and Valid='1')then
                        Result <= Res;
                        WriteFIFO <= '1';
                        Received <= '1';
                        ect <= stX;                            
                    end if;

                when stX =>                    
                    WriteFIFO <= '0';
                    if(Conjugate='1')then
                        Received <= '0';
                    end if;
                    if(Valid_reg='1' and Valid='0')then
                        if(Conjugate='1')then
                            ect <= st0;
                        else
                            ect <= st1;
                        end if;                        
                    end if;        
                
                when st1 =>
                    if(Valid='1')then--if(Full='0' and Valid='1')then
                        Result <= Res;
                        WriteFIFO <= '1';
                        Received <= '0';
                        ect <= stY;
                    end if;
                
                 when stY =>                    
                    WriteFIFO <= '0';
                    if(Valid_reg='1' and Valid='0')then
                        ect <= st0;
                    end if;

            end case;
        end if;
    end process;

end ar_GetResult;

