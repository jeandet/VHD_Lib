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
use IEEE.STD_LOGIC_1164.all;
library lpp;
use lpp.amba_lcd_16x2_ctrlr.all;



package LCD_16x2_CFG is
  
  	
constant ClearDSPLY		:	std_logic_vector(7 downto 0):= X"01";	
constant	FunctionSet		:	std_logic_vector(7 downto 0):= X"38";	
constant RetHome			:	std_logic_vector(7 downto 0):= X"02";	
constant SetEntryMode	:	std_logic_vector(7 downto 0):= X"06";	
constant DSPL_CTRL		:	std_logic_vector(7 downto 0):= X"0E";	
	
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

