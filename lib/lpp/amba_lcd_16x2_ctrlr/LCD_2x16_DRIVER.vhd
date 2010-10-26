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

entity LCD_2x16_DRIVER is
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
end LCD_2x16_DRIVER;

architecture Behavioral of LCD_2x16_DRIVER is

type	stateT is(Rst,Configure,IDLE,RefreshScreen);
signal	state	:	stateT;

signal	ShortTimePulse		:	 std_logic;
signal	MidleTimePulse		:	 std_logic;
signal   Refresh_RatePulse	:	 std_logic;
signal   Start 				:   STD_LOGIC;

signal	CFGM_LCD_RS			:	std_logic;
signal	CFGM_LCD_RW			:	std_logic;
signal	CFGM_LCD_E			:	std_logic;
signal	CFGM_LCD_DATA		:	std_logic_vector(7 downto 0);
signal	CFGM_Enable			:	std_logic;
signal	CFGM_completed		:	std_logic;


signal	FRMW_LCD_RS			:	std_logic;
signal	FRMW_LCD_RW			:	std_logic;
signal	FRMW_LCD_E			:	std_logic;
signal	FRMW_LCD_DATA		:	std_logic_vector(7 downto 0);
signal	FRMW_Enable			:	std_logic;
signal	FRMW_completed		:	std_logic;

begin


Counter : LCD_Counter
generic map(OSC_Freq_MHz,Refresh_RateHz)
port map(reset,clk,ShortTimePulse,MidleTimePulse,Refresh_RatePulse,Start);

ConfigModule	:	Config_Module
port map(reset,clk,CFGM_LCD_RS,CFGM_LCD_RW,CFGM_LCD_E,CFGM_LCD_DATA,CFGM_Enable,CFGM_completed,MidleTimePulse);


FrameWriter	:	FRAME_WRITER 
port map(reset,clk,FramBUFF,FRMW_LCD_DATA,FRMW_LCD_RS,FRMW_LCD_RW,FRMW_LCD_E,FRMW_Enable,FRMW_Completed,ShortTimePulse,MidleTimePulse);


STATEOUT(0)	<=	'1' when state = 	Rst else '0';
STATEOUT(1)	<=	'1' when state = 	Configure else '0';
STATEOUT(2)	<=	'1' when state = 	IDLE else '0';
STATEOUT(3)	<=	'1' when state = 	RefreshScreen else '0';



refreshPulse	<=	Refresh_RatePulse;

Start			<=	'1';

process(reset,clk)
begin
	if reset = '0' then
		LCD_data	<=	(others=>'0');
		LCD_RS	<=	'0';
		LCD_RW	<=	'0';
		LCD_RET	<=	'0';
		LCD_CS1	<=	'0';
		LCD_CS2	<=	'0';
		LCD_E		<=	'0';
		state		<=	Rst;
		CFGM_Enable	<=	'0';
		FRMW_Enable	<=	'0';
	elsif clk'event and clk ='1' then
		case state is
			when	Rst =>
				LCD_data		<=	(others=>'0');
				LCD_RS		<=	'0';
				LCD_RW		<=	'0';
				LCD_E			<=	'0';
				CFGM_Enable	<=	'1';
				FRMW_Enable	<=	'0';
				if	Refresh_RatePulse = '1' then
					state <=	Configure;
				end if; 
			when	Configure =>
				LCD_data		<=	CFGM_LCD_data;
				LCD_RS		<=	CFGM_LCD_RS;
				LCD_RW		<=	CFGM_LCD_RW;
				LCD_E			<=	CFGM_LCD_E;
				CFGM_Enable	<=	'0';
				if CFGM_completed	=	'1' then
					state	<=	IDLE;
				end if;
			when	IDLE =>
				if	Refresh_RatePulse = '1' then
					state <=	RefreshScreen;
					FRMW_Enable	<=	'1';
				end if;
				LCD_RS		<=	'0';
				LCD_RW		<=	'0';
				LCD_E			<=	'0';
				LCD_data		<=	(others=>'0');
			when	RefreshScreen =>
				LCD_data		<=	FRMW_LCD_data;
				LCD_RS		<=	FRMW_LCD_RS;
				LCD_RW		<=	FRMW_LCD_RW;
				LCD_E			<=	FRMW_LCD_E;
				FRMW_Enable	<=	'0';
				if FRMW_completed	=	'1' then
					state	<=	IDLE;
				end if;
		end case;
	end if;
end process;
end Behavioral;





