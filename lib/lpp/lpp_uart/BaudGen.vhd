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
--                    Author : Alexis Jeandet
--                     Mail : alexis.jeandet@lpp.polytechnique.fr
----------------------------------------------------------------------------
library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;

--! Generateur de Bauds

entity BaudGen is

port(
    clk         :   in  std_logic;
    reset       :   in  std_logic;
    Capture     :   in  std_logic;
    Bclk        :   out std_logic;
    RXD         :   in  std_logic;
    BTrigger    :   out std_logic_vector(11 downto 0)
);
end BaudGen;


architecture ar_BaudGen of BaudGen is
signal  cpt         :   std_logic_vector(11 downto 0) := (others => '0');
signal  errorFlag   :   std_logic;
signal  triger      :   std_logic_vector(11 downto 0) := (others => '0');
signal  RX_reg      :   std_logic:='1';

begin


BTrigger    <=  triger;


BaudGeneration: 
process(clk,reset)
begin
    if reset = '0' then
        cpt         <=  (others => '0');
        triger      <=  (others => '1');
        errorFlag   <=  '0';
    elsif clk'event and clk = '1'then
        RX_reg  <=  RXD;
        if capture = '1' then
            cpt     <=  (others => '0');
            triger  <=  (others => '1');
            errorFlag   <=  '0';
        else
            if RX_reg /= RXD then
                cpt         <=  (others => '0');
                if cpt = std_logic_vector(TO_UNSIGNED(0,12)) then
                    errorFlag   <=  '1';
                elsif errorFlag = '1' then
                    triger      <=  cpt;
                    errorFlag   <=  '0';  
                else
                    errorFlag   <=  '1';              
                end if;
            else
                if cpt = triger then
                    cpt         <=  (others => '0');
                    errorFlag   <=  '0';
                else
                    cpt     <=  std_logic_vector(unsigned(cpt) + 1);
                end if;
            end if;
        end if;
    end if;
end process;


process(clk)
begin
    if clk'event and clk = '1' then
        if cpt = std_logic_vector(TO_UNSIGNED(0,12)) then
            Bclk    <=  '0';
        elsif cpt = '0' & triger(11 downto 1) then
            Bclk    <=  '1';
        end if;
    end if;
end process;


end ar_BaudGen;
