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

---TDODO => Clean Enable pulse FSM
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
library lpp;
use lpp.amba_lcd_16x2_ctrlr.all;
use lpp.lcd_16x2_cfg.all;

entity LCD_16x2_DRIVER is
	generic(
		OSC_Freq_KHz	 :	integer:=50000
	);
    Port( 
	   reset      : in  STD_LOGIC;
	   clk        : in  STD_LOGIC;
      LCD_CTRL	  : out LCD_DRVR_CTRL_BUSS;
	   SYNCH	     : out LCD_DRVR_SYNCH_BUSS;
	   DRIVER_CMD : in  LCD_DRVR_CMD_BUSS
			  );
end LCD_16x2_DRIVER;

architecture Behavioral of LCD_16x2_DRIVER is

type stateT is (idle,Enable0,Enable1,Enable2,tempo);
signal	state	:	stateT;


constant	trigger_4us		:	integer := 5;
constant	trigger_100us	:	integer := 100;
constant	trigger_4ms		:	integer := 4200;
constant	trigger_20ms	:	integer := 20000;


signal	i 				:	integer :=0;
signal	reset_i		:	std_logic := '0';
signal	tempoTRIG	:	integer :=0;

signal	clk_1us		:	std_logic;
signal	clk_1us_reg	:	std_logic;

begin


CLK0: LCD_CLK_GENERATOR
	 generic map(OSC_Freq_KHz)
    Port map( clk,reset,clk_1us);



process(clk_1us,reset_i)
begin
	if reset_i = '0' then
		i	<=	0;
	elsif clk_1us'event and clk_1us ='1' then
			i	<=	i+1;
	end if;
end process;

LCD_CTRL.LCD_RW	<=	'0';

process(clk,reset)
begin
	if reset = '0' then
		state	<=	idle;
		LCD_CTRL.LCD_E				<=	'0';
		SYNCH.DRVR_READY			<=	'0';
		SYNCH.LCD_INITIALISED	<=	'0';
		reset_i						<=	'0';
	elsif clk'event and clk = '1' then
		case state is
			when idle =>
				SYNCH.LCD_INITIALISED	<=	'1';
				LCD_CTRL.LCD_E				<=	'0';
				if DRIVER_CMD.Exec = '1' then
					state	<=	Enable0;
					reset_i	<=	'1';
					SYNCH.DRVR_READY			<=	'0';
					LCD_CTRL.LCD_DATA	<=	DRIVER_CMD.Word;
					LCD_CTRL.LCD_RS	<=	DRIVER_CMD.CMD_Data;
					case DRIVER_CMD.Duration is
						when Duration_4us =>
							tempoTRIG	<=	trigger_4us;
						when Duration_100us =>
							tempoTRIG	<=	trigger_100us;
						when Duration_4ms =>
							tempoTRIG	<=	trigger_4ms;
						when Duration_20ms =>
							tempoTRIG	<=	trigger_20ms;
						when others =>
							tempoTRIG	<=	trigger_20ms;
					end case;
				else
					SYNCH.DRVR_READY			<=	'1';
					reset_i						<=	'0';
				end if;
			when Enable0 =>
				if i = 1 then
					reset_i	<=	'0';
					LCD_CTRL.LCD_E				<=	'1';
					state	<=	Enable1;
				else
					reset_i	<=	'1';
					LCD_CTRL.LCD_E				<=	'0';
				end if;
			when Enable1 =>
				if i = 2 then
					reset_i	<=	'0';
					LCD_CTRL.LCD_E				<=	'0';
					state	<=	Enable2;
				else
					reset_i	<=	'1';
					LCD_CTRL.LCD_E				<=	'1';
				end if;
			when Enable2 =>
				if i = 1 then
					reset_i	<=	'0';
					LCD_CTRL.LCD_E				<=	'0';
					state	<=	tempo;
				else
					reset_i	<=	'1';
					LCD_CTRL.LCD_E				<=	'0';
				end if;
			when tempo =>
				if i = tempoTRIG then
					reset_i	<=	'0';
					state	<=	idle;
				else
					reset_i	<=	'1';
				end if;
		end case;
	end if;
end process;

end Behavioral;















