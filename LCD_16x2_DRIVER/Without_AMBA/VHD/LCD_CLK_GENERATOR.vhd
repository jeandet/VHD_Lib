----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:52:25 10/18/2010 
-- Design Name: 
-- Module Name:    LCD_CLK_GENERATOR - Behavioral 
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


entity LCD_CLK_GENERATOR is
	 generic(OSC_freqKHz	:	integer := 50000);
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           clk_1us : out  STD_LOGIC);
end LCD_CLK_GENERATOR;

architecture ar_LCD_CLK_GENERATOR of LCD_CLK_GENERATOR is

Constant clk_1usTRIGER	:	integer	:=	(OSC_freqKHz/2000)+1;


signal	cpt1				:	integer;

signal	clk_1us_int		:	std_logic := '0';


begin

clk_1us		<=	clk_1us_int;


process(reset,clk)
begin
	if reset = '0' then
		cpt1			<=	0;
		clk_1us_int		<=	'0';
	elsif clk'event and clk = '1' then
		if cpt1 = clk_1usTRIGER then
			clk_1us_int	<=	not clk_1us_int;
			cpt1			<=	0;
		else
			cpt1			<=	cpt1 + 1;
		end if;
	end if;
end process;


end ar_LCD_CLK_GENERATOR;









