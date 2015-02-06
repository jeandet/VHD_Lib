------------------------------------------------------------------------------
--  This file is a part of the LPP VHDL IP LIBRARY
--  Copyright (C) 2009 - 2015, Laboratory of Plasmas Physic - CNRS
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
--                    Author : Alexis Jeandet
--                     Mail : alexis.jeandet@member.fsf.org
------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RAM_WRITER is
    Generic(
        datawidth     : integer := 18;
        abits         : integer := 8
    );
    Port ( 
        clk            : in  STD_LOGIC;                                --! clk input
        rstn           : in  STD_LOGIC;                                --! Active low reset input
        DATA_IN        : in  STD_LOGIC_VECTOR (datawidth-1 downto 0);  --! DATA input vector
        DATA_OUT       : out  STD_LOGIC_VECTOR (datawidth-1 downto 0); --! DATA output vector
        WEN_IN         : in  STD_LOGIC;                                --! Active low Write Enable input
        WEN_OUT        : out STD_LOGIC;                                --! Active low Write Enable output
        LOAD_ADDRESSN  : in  STD_LOGIC;                                --! Active low address load input
        ADDRESS_IN     : in  STD_LOGIC_VECTOR (abits-1 downto 0);      --! Adress input vector
        ADDRESS_OUT    : out  STD_LOGIC_VECTOR (abits-1 downto 0)      --! Adress output vector
   );
end RAM_WRITER;

architecture Behavioral of RAM_WRITER is

signal ADDRESS_R : STD_LOGIC_VECTOR (abits-1 downto 0):=(others=>'0');
begin

ADDRESS_OUT    <= ADDRESS_R;
-- pass through connections for DATA and WEN 
DATA_OUT    <= DATA_IN;  
WEN_OUT     <= WEN_IN;

process(clk,rstn)
begin
    if rstn='0' then 
        ADDRESS_R    <= (others=>'0');
    elsif clk'event and clk='1' then
        if LOAD_ADDRESSN = '0' then
            ADDRESS_R    <= ADDRESS_IN;
        elsif WEN_IN = '0' then    
            ADDRESS_R    <= STD_LOGIC_VECTOR(UNSIGNED(ADDRESS_R) + 1);
        end if;
    end if;
end process;

end Behavioral;

