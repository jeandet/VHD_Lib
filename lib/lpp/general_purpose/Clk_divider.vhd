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


entity Clk_divider is
	 generic(OSC_freqHz	:	integer := 50000000;
				TargetFreq_Hz	:	integer := 50000);
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           clk_divided : out  STD_LOGIC);
end Clk_divider;

architecture ar_Clk_divider of Clk_divider is

Constant clk_TRIGER	:	integer	:=	(OSC_freqHz/(2*TargetFreq_Hz))+1;


signal	cpt1				:	integer;

signal	clk_int		:	std_logic := '0';


begin

clk_divided		<=	clk_int;


process(reset,clk)
begin
	if reset = '0' then
		cpt1			<=	0;
		clk_int		<=	'0';
	elsif clk'event and clk = '1' then
		if cpt1 = clk_TRIGER then
			clk_int	<=	not clk_int;
			cpt1			<=	0;
		else
			cpt1			<=	cpt1 + 1;
		end if;
	end if;
end process;


end ar_Clk_divider;


