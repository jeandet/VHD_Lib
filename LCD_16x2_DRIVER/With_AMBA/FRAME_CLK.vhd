----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:21:03 10/19/2010 
-- Design Name: 
-- Module Name:    FRAME_CLK_GEN - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity FRAME_CLK_GEN is
	generic(OSC_freqKHz	:	integer := 50000);
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           FRAME_CLK : out  STD_LOGIC);
end FRAME_CLK_GEN;

architecture Behavioral of FRAME_CLK_GEN is

Constant	Goal_FRAME_CLK_FREQ	:	integer := 20;

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









