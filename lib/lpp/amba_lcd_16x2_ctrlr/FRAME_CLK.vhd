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
use IEEE.NUMERIC_STD.ALL;
library lpp;
use lpp.amba_lcd_16x2_ctrlr.all;

entity FRAME_CLK_GEN is
	generic(OSC_freqKHz	:	integer := 50000);
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           FRAME_CLK : out  STD_LOGIC);
end FRAME_CLK_GEN;

architecture Behavioral of FRAME_CLK_GEN is

Constant	Goal_FRAME_CLK_FREQ	:	integer := 25;

Constant FRAME_CLK_TRIG	:	integer	:= OSC_freqKHz*500/Goal_FRAME_CLK_FREQ -1;

signal	CPT	:	integer := 0;
signal	FRAME_CLK_reg : std_logic :='0';

begin

FRAME_CLK	<=	FRAME_CLK_reg;

process(reset,clk)
begin
	if reset = '0' then
		CPT <=	0;
		FRAME_CLK_reg <= '0';
	elsif clk'event and clk = '1' then
		if CPT = FRAME_CLK_TRIG then
			CPT <= 0;
			FRAME_CLK_reg	<= not FRAME_CLK_reg;
		else
			CPT	<=	CPT + 1;
		end if;
	end if;
end process;
end Behavioral;









