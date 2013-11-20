------------------------------------------------------------------------------
--  This file is a part of the LPP VHDL IP LIBRARY
--  Copyright (C) 2009 - 2013, Laboratory of Plasmas Physic - CNRS
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
--                     Mail  : alexis.jeandet@member.fsf.org
------------------------------------------------------------------------------
--
--    This module implements the Slow to Slow Fast transfer:
--	   Data Transfer between Asynchronous Clock Domains without Pain
--    from  Markus Schutti, Markus Pfaff, Richard Hagelauer
--		http://www-micrel.deis.unibo.it/~benini/files/SNUG/paper9_final.pdf
--		see page 5
--
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Slow2FastSync is
generic
(
	N	:	integer range 0 to 256:=8
);
Port 
( 
	Data 			: in   STD_LOGIC_VECTOR (N-1 downto 0);
   ClockF 		: in   STD_LOGIC;
   ClockS 		: in   STD_LOGIC;
   SyncSignal 	: in   STD_LOGIC;
   DataSinkS 	: out  STD_LOGIC_VECTOR (N-1 downto 0)
);
end Slow2FastSync;

architecture AR_Slow2FastSync of Slow2FastSync is

signal DataS			:	STD_LOGIC_VECTOR (N-1 downto 0);


begin

		

process(ClockF)
begin
	if ClockF'event and ClockF = '1' and SyncSignal = '1' then
		DataSinkS			<= DataS;
	end if;
end process;

process(ClockS)
begin
	if ClockS'event and ClockS = '1' then
		DataS	<= Data;
	end if;
end process;

end AR_Slow2FastSync;



















