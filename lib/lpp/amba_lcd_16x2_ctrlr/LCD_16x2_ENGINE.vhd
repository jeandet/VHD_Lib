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
-- Create Date:    08:32:21 10/19/2010 
-- Design Name: 
-- Module Name:    LCD_16x2_ENGINE - Behavioral 
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

library lpp;
use lpp.amba_lcd_16x2_ctrlr.all;
use lpp.LCD_16x2_CFG.all;


entity LCD_16x2_ENGINE is
	generic(OSC_freqKHz	:	integer := 50000);
    Port ( clk 	:	in  STD_LOGIC;
           reset 	:	in  STD_LOGIC;
			  DATA	:	in std_logic_vector(16*2*8-1 downto 0);
			  CMD		:	in std_logic_vector(10 downto 0);
			  Exec	:	in	std_logic;
			  Ready	:	out std_logic;
			  LCD_CTRL	:	out LCD_DRVR_CTRL_BUSS
			  );
end LCD_16x2_ENGINE;

architecture ar_LCD_16x2_ENGINE of LCD_16x2_ENGINE is

constant ConfigTbl	: LCD_CFG_Tbl	:=(ClearDSPLY,FunctionSet,DSPL_CTRL,SetEntryMode,RetHome);



signal	SYNCH		:	 LCD_DRVR_SYNCH_BUSS;
signal   DRIVER_CMD	   :	 LCD_DRVR_CMD_BUSS;
signal	FRAME_CLK	:	std_logic;

signal	FRAME_CLK_reg	:	std_logic;
signal	RefreshFlag		:	std_logic;
signal	CMD_Flag			:	std_logic;
signal	Exec_Reg			:	std_logic;

type state_t is (INIT0,INIT1,INIT2,IDLE,Refresh,Refresh0,Refresh1,ReturnHome,GoLine2,GoLine2_0,ExecCMD0,ExecCMD1);
signal	state	:	state_t;
signal	i		:	integer range 0 to 32 := 0;



begin

Driver0 :  LCD_16x2_DRIVER
	generic map(OSC_freqKHz)
    Port map(reset,clk,LCD_CTRL,SYNCH,DRIVER_CMD);

FRAME_CLK_GEN0 : FRAME_CLK_GEN
	generic map(OSC_freqKHz)
    Port map( clk,reset,FRAME_CLK);



process(reset,clk)
begin
	if reset = '0' then
		state <=	INIT0;
		Ready	<=	'0';
		RefreshFlag	<=	'0';
		i	<=	0;
	elsif clk'event and clk ='1' then
		FRAME_CLK_reg	<=	FRAME_CLK;
		Exec_Reg			<=	Exec;
		
		if FRAME_CLK_reg = '0' and FRAME_CLK = '1' then
			RefreshFlag	<=	'1';
		elsif state = Refresh or state = Refresh0 or state = Refresh1 then
			RefreshFlag	<=	'0';
		end if;
		
		if Exec_Reg = '0' and Exec = '1' then
			CMD_Flag	<=	'1';
		elsif state = ExecCMD0 or state = ExecCMD1 then
			CMD_Flag	<=	'0';
		end if;
		
		case state is
			when	INIT0 =>
				if SYNCH.DRVR_READY = '1' then 
					DRIVER_CMD.Exec		<=	'1';
					DRIVER_CMD.Duration	<=	Duration_20ms;
					DRIVER_CMD.CMD_Data	<=	'0';
					DRIVER_CMD.Word			<=	ConfigTbl(i);
					i	<=	i + 1;
					state	<=	INIT1;
				else
					DRIVER_CMD.Exec		<=	'0';
				end if;
			when	INIT1 =>
				state	<=	INIT2;
				DRIVER_CMD.Exec		<=	'0';
			when	INIT2 =>
				if SYNCH.DRVR_READY = '1' then 
					if i = 5 then
						state	<=	Idle;
					else
						state	<=	INIT0;
					end if;
				end if;
			when Idle=>
				DRIVER_CMD.Exec		<=	'0';
				if RefreshFlag	=	'1' then
					Ready	<=	'0';
					state	<=	Refresh;
				elsif CMD_Flag = '1' then
					Ready	<=	'0';
					state	<=	ExecCMD0;
				else
					Ready	<=	'1';
				end if;
				i	<=	0;
			when Refresh=>
				if SYNCH.DRVR_READY = '1' then 
					DRIVER_CMD.Exec		<=	'1';
					DRIVER_CMD.Duration	<=	Duration_100us;
					DRIVER_CMD.CMD_Data	<=	'1';
					DRIVER_CMD.Word			<=	DATA(i*8+7 downto i*8);
					state	<=	Refresh0;
				else
					DRIVER_CMD.Exec		<=	'0';
				end if;
			when Refresh0=>
				i	<=	i + 1;
				state	<=	Refresh1;
				DRIVER_CMD.Exec		<=	'0';
			when Refresh1=>
				if SYNCH.DRVR_READY = '1' then 
					if i = 32 then
						state	<=	ReturnHome;
					elsif i = 16 then
						state	<=	GoLine2;
					else
						state	<=	Refresh;
					end if;
				end if;
				
			when ExecCMD0=>
				if SYNCH.DRVR_READY = '1' then 
					DRIVER_CMD.Exec		<=	'1';
					DRIVER_CMD.Duration	<=	CMD(9 downto 8);
					DRIVER_CMD.CMD_Data	<=	'0';
					DRIVER_CMD.Word		<= CMD(7 downto 0);
					state	<=	ExecCMD1;
				else
					DRIVER_CMD.Exec		<=	'0';
				end if;
			
			when ExecCMD1=>
				state	<=	Idle;
				DRIVER_CMD.Exec		<=	'0';
				
			when	GoLine2=>
				if SYNCH.DRVR_READY = '1' then 
					DRIVER_CMD.Exec		<=	'1';
					DRIVER_CMD.Duration	<=	Duration_100us;
					DRIVER_CMD.CMD_Data	<=	'0';
					DRIVER_CMD.Word			<= X"C0";
					state	<=	GoLine2_0;
				else
					DRIVER_CMD.Exec		<=	'0';
				end if;
			when	GoLine2_0=>
				state	<=	Refresh;
				DRIVER_CMD.Exec		<=	'0';
			when ReturnHome=>
				if SYNCH.DRVR_READY = '1' then 
					DRIVER_CMD.Exec		<=	'1';
					DRIVER_CMD.Duration	<=	Duration_4ms;
					DRIVER_CMD.CMD_Data	<=	'0';
					DRIVER_CMD.Word			<= RetHome;
					state	<=	Idle;
				else
					DRIVER_CMD.Exec		<=	'0';
				end if;
		end case;
	end if;
end process;


end ar_LCD_16x2_ENGINE;










