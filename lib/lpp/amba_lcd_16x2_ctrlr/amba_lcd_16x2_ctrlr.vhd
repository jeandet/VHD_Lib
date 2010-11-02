------------------------------------------------------------------------------
--  This file is a part of the LPP VHDL IP LIBRARY
--  Copyright (C) 2009 - 2010, Laboratory of Plasmas Physic - CNRS
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
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

library ieee;
use ieee.std_logic_1164.all;



package amba_lcd_16x2_ctrlr is


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
	


component LCD_16x2_DRIVER is
	generic(
		OSC_Freq_MHz	 :	integer:=60
	);
    Port ( reset : in  STD_LOGIC;
	   clk : in  STD_LOGIC;
           LCD_CTRL	:	out LCD_DRVR_CTRL_BUSS;
	   SYNCH	:	out LCD_DRVR_SYNCH_BUSS;
	   DRIVER_CMD	:	in  LCD_DRVR_CMD_BUSS
			  );
end component;



component  amba_lcd_16x2_driver is
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
end component; 



component FRAME_CLK_GEN is
	generic(OSC_freqKHz	:	integer := 50000);
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           FRAME_CLK : out  STD_LOGIC);
end component;



component LCD_2x16_DRIVER is
	generic(
		OSC_Freq_MHz	 :	integer:=60;
		Refresh_RateHz :	integer:=5
	);
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           FramBUFF : in  STD_LOGIC_VECTOR(16*2*8-1 downto 0);
           LCD_data : out  STD_LOGIC_VECTOR (7 downto 0);
           LCD_RS : out  STD_LOGIC;
           LCD_RW : out  STD_LOGIC;
	   LCD_E  : out  STD_LOGIC;
           LCD_RET : out  STD_LOGIC;
           LCD_CS1 : out  STD_LOGIC;
           LCD_CS2 : out  STD_LOGIC;
	   STATEOUT:	out	std_logic_vector(3 downto 0);
	   refreshPulse	:	out	std_logic
			  );
end component;


component LCD_CLK_GENERATOR is
	 generic(OSC_freqKHz	:	integer := 50000);
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           clk_1us : out  STD_LOGIC);
end component;

component LCD_16x2_ENGINE is
	generic(OSC_freqKHz	:	integer := 50000);
    Port ( clk 	:	in  STD_LOGIC;
           reset 	:	in  STD_LOGIC;
	  DATA	:	in std_logic_vector(16*2*8-1 downto 0);
	  CMD		:	in std_logic_vector(10 downto 0);
	  Exec	:	in	std_logic;
	  Ready	:	out std_logic;
	  LCD_CTRL	:	out LCD_DRVR_CTRL_BUSS
			  );
end component;


end;
