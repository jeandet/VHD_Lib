----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:06:46 08/22/2013 
-- Design Name: 
-- Module Name:    OneShot - AR_OneShot 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity OneShot is
    Port ( reset : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           input : in  STD_LOGIC;
           output : out  STD_LOGIC);
end OneShot;

architecture AR_OneShot of OneShot is
signal inreg	:	std_logic;
begin

process(clk,reset)
begin
if reset = '0' then
	output	<=	'0';
elsif clk'event and clk = '1' then
	inreg	<=	input;
	if inreg = '0' and input = '1' then
		output 	<=	'1';
	else
		output	<=	'0';
	end if;
end if;
end process;

end AR_OneShot;










