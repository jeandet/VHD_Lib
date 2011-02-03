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

entity Driver_IN is
  port(
    clk,raz  : in std_logic;
    load     : in std_logic;
    data     : in std_logic_vector(15 downto 0);
    start    : out std_logic;
    read_y   : out std_logic;
    d_valid  : out std_logic;
    d_re     : out std_logic_vector(15 downto 0);
    d_im     : out std_logic_vector(15 downto 0)
    );
end Driver_IN;


architecture ar_Driver_IN of Driver_IN is

begin 
    process (clk,raz)
    begin
        if(raz='0')then
            start   <= '1';
            d_valid <= '0';
            d_re    <= (others => '0'); 
            d_im    <= (others => '0');
            
        elsif(clk' event and clk='1')then
            start <= '0';
            if(load='1')then
                d_valid <= '1';
                d_re    <= data;
            else
                d_valid <= '0';
            end if; 
                           
        end if;
    end process;
    
    read_y <= '1';

end ar_Driver_IN;