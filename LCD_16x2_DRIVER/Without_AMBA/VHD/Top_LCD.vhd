----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:44:41 10/14/2010 
-- Design Name: 
-- Module Name:    Top_LCD - Behavioral 
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
use work.LCD_16x2_CFG.all;

entity Top_LCD is
    Port ( reset 		: in  STD_LOGIC;
           clk 		: in  STD_LOGIC;
           Bp0 		: in  STD_LOGIC;
           Bp1 		: in  STD_LOGIC;
           Bp2 		: in  STD_LOGIC;
			  LCD_data 	: out  STD_LOGIC_VECTOR (7 downto 0);
           LCD_RS 	: out  STD_LOGIC;
           LCD_RW 	: out  STD_LOGIC;
			  LCD_E  	: out  STD_LOGIC;
           LCD_RET 	: out  STD_LOGIC;
           LCD_CS1 	: out  STD_LOGIC;
           LCD_CS2 	: out  STD_LOGIC;
			  SF_CE0		: out	std_logic
			  );
end Top_LCD;

architecture Behavioral of Top_LCD is

signal	FramBUFF :  STD_LOGIC_VECTOR(16*2*8-1 downto 0);
signal	CMD		:	std_logic_vector(10 downto 0);
signal	Exec	:		std_logic;
signal	Ready	:	 std_logic;
signal	rst	:	std_logic;
signal	LCD_CTRL	:	 LCD_DRVR_CTRL_BUSS;

begin

LCD_data 	<=	LCD_CTRL.LCD_DATA;
LCD_RS 	<=	LCD_CTRL.LCD_RS;
LCD_RW 	<=	LCD_CTRL.LCD_RW;
LCD_E  	<=	LCD_CTRL.LCD_E;


LCD_RET	<=	'0';
LCD_CS1	<=	'0';
LCD_CS2	<=	'0';

SF_CE0	<=	'1';

rst <= not reset;



Driver0 : entity work.LCD_16x2_ENGINE
	generic map(50000)
    Port map(clk,rst,FramBUFF,CMD,Exec,Ready,LCD_CTRL);

FramBUFF(0*8+7 downto 0*8)	<=	X"41" when	Bp0 = '1' else
								X"42" when	Bp1 = '1' else
								X"43" when	Bp2 = '1' else
								X"44";
								
FramBUFF(1*8+7 downto 1*8)<=	X"46" when	Bp0 = '1' else
								X"47" when	Bp1 = '1' else
								X"48" when	Bp2 = '1' else
								X"49";


CMD(9 downto 0)	<=	Duration_100us & CursorON when	Bp0 = '1' else
							Duration_100us & CursorOFF;
							

Exec	<=	Bp1;

FramBUFF(2*8+7 downto 2*8) <= X"23";
FramBUFF(3*8+7 downto 3*8) <= X"66";
FramBUFF(4*8+7 downto 4*8) <= X"67";
FramBUFF(5*8+7 downto 5*8) <= X"68";
FramBUFF(17*8+7 downto 17*8) <= X"69";
--FramBUFF(16*2*8-1 downto 16) <= (others => '0');

end Behavioral;






