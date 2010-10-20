--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--	constants, and functions 


library IEEE;
use IEEE.STD_LOGIC_1164.all;

package LCD_16x2_CFG is
  
  type LCD_DRVR_CTRL_BUSS is
    record
        LCD_RW	        : std_logic;
        LCD_RS         : std_logic;
		  LCD_E          : std_logic;
		  LCD_DATA		  : std_logic_vector(7 downto 0);
    end record;

	 type LCD_DRVR_SYNCH_BUSS is
    record
        DRVR_READY     	: std_logic;
        LCD_INITIALISED	: std_logic;
    end record;
	
	
	 type LCD_DRVR_CMD_BUSS is
    record
		  Word				: std_logic_vector(7 downto 0);
        CMD_Data			: std_logic;  --CMD = '0' and data = '1'
		  Exec				: std_logic;
        Duration			: std_logic_vector(1 downto 0);
    end record;
	type LCD_CFG_Tbl is array(0 to 4) of std_logic_vector(7 downto 0);
	
	
constant ClearDSPLY		:	std_logic_vector(7 downto 0):= X"01";	
constant	FunctionSet		:	std_logic_vector(7 downto 0):= X"38";	
constant RetHome			:	std_logic_vector(7 downto 0):= X"02";	
constant SetEntryMode	:	std_logic_vector(7 downto 0):= X"06";	
constant DSPL_CTRL		:	std_logic_vector(7 downto 0):= X"0C";	
	
constant CursorON			:	std_logic_vector(7 downto 0):= X"0E";	
constant CursorOFF		:	std_logic_vector(7 downto 0):= X"0C";	

--===========================================================|
--======L C D    D R I V E R     T I M I N G     C O D E=====|
--===========================================================|	
	
constant    Duration_4us    		:   std_logic_vector(1 downto 0) := "00";
constant    Duration_100us   		:   std_logic_vector(1 downto 0) := "01";
constant    Duration_4ms    		:   std_logic_vector(1 downto 0) := "10";	
constant    Duration_20ms    		:   std_logic_vector(1 downto 0) := "11";	
	

end LCD_16x2_CFG;

