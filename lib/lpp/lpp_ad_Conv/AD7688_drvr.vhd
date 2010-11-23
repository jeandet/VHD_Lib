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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity AD7688_drvr is
    generic(ChanelCount	:	integer; 
				clkkHz		:	integer);
		 Port ( clk 	: in  STD_LOGIC;
				  reset 	: in  STD_LOGIC;
				  smplClk: in	STD_LOGIC;
				  smpout : out Samples_out(ChanelCount-1 downto 0);	
				  AD_in	: in	AD7688_in(ChanelCount-1 downto 0);	
				  AD_out : out AD7688_out);
end AD7688_drvr;

architecture ar_AD7688_drvr of AD7688_drvr is

constant		convTrigger	:	integer:=  clkkHz*1.6/1000;  --tconv = 1.6µs

signal i	: integer range 0 to convTrigger :=0;

begin

sckgen: process(clk,reset)
begin
	if reset = '0' then
		i <= 0;
		AD_out.CNV	<=	'0';
	elsif clk'event and clk = '1' then
	end if;
end process;


end ar_AD7688_drvr;

