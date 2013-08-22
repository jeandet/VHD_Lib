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
--    This module implements the SyncSignal generator explained in:
--	   Data Transfer between Asynchronous Clock Domains without Pain
--    from  Markus Schutti, Markus Pfaff, Richard Hagelauer
--		http://www-micrel.deis.unibo.it/~benini/files/SNUG/paper9_final.pdf
--		see page 4 
--
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CrossDomainSyncGen is
Port ( 
		  reset      : in  STD_LOGIC;
		  ClockS     : in  STD_LOGIC;
		  ClockF     : in  STD_LOGIC;
		  SyncSignal : out  STD_LOGIC
);
end CrossDomainSyncGen;

architecture AR_CrossDomainSyncGen of CrossDomainSyncGen is

signal FFSYNC : std_logic_vector(2 downto 0);

begin

SyncSignal	<= FFSYNC(2);

process(reset,ClockF)
begin
if reset = '0' then
	FFSYNC	<= (others => '0');
elsif ClockF'event and ClockF = '1' then
	FFSYNC(0)	<= ClockS;
	FFSYNC(1)	<= FFSYNC(0);
	FFSYNC(2)	<=	FFSYNC(1);
end if;
end process;

end AR_CrossDomainSyncGen;






