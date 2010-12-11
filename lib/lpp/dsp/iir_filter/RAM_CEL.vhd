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
library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity RAM_CEL is 
    port( WD : in std_logic_vector(35 downto 0); RD : out 
        std_logic_vector(35 downto 0);WEN, REN : in std_logic; 
        WADDR : in std_logic_vector(7 downto 0); RADDR : in 
        std_logic_vector(7 downto 0);RWCLK, RESET : in std_logic
        ) ;
end RAM_CEL;



architecture ar_RAM_CEL of RAM_CEL is
type    RAMarrayT   is array (0 to 255) of std_logic_vector(35 downto 0);
signal  RAMarray           :   RAMarrayT:=(others => X"000000000");
signal  RD_int       :   std_logic_vector(35 downto 0);

begin

RD_int  <=  RAMarray(to_integer(unsigned(RADDR)));


process(RWclk,reset)
begin
if reset = '0' then
	RD <= (X"000000000");
rst:for i in 0 to 255 loop
        RAMarray(i)    <=  (others => '0');
      end loop;

elsif RWclk'event and RWclk = '1' then
    if REN = '0' then
        RD      <=  RD_int;
    end if;

    if WEN = '0' then
        RAMarray(to_integer(unsigned(WADDR)))      <=  WD;
    end if;

end if;
end process;
end ar_RAM_CEL;




























