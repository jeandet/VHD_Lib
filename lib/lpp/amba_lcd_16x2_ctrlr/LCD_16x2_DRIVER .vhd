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
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:09:57 10/13/2010 
-- Design Name: 
-- Module Name:    LCD_2x16_DRIVER - Behavioral 
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
use IEEE.NUMERIC_STD.all;
library lpp;
use lpp.amba_lcd_16x2_ctrlr.all;


entity LCD_16x2_DRIVER is
	generic(
		OSC_Freq_MHz	 :	integer:=60
	);
    Port ( reset : in  STD_LOGIC;
	   clk : in  STD_LOGIC;
           LCD_CTRL	:	out LCD_DRVR_CTRL_BUSS;
	   SYNCH	:	out LCD_DRVR_SYNCH_BUSS;
	   DRIVER_CMD	:	in  LCD_DRVR_CMD_BUSS
			  );
end LCD_16x2_DRIVER;

architecture Behavioral of LCD_16x2_DRIVER is

end Behavioral;





