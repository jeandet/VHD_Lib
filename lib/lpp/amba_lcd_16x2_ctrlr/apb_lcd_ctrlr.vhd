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
use ieee.numeric_std.all;
library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;
library lpp;
use lpp.amba_lcd_16x2_ctrlr.all;
use lpp.LCD_16x2_CFG.all;
use lpp.lpp_amba.all;

entity apb_lcd_ctrlr is
  generic (
    pindex   : integer := 0;
    paddr    : integer := 0;
    pmask    : integer := 16#fff#;
    pirq     : integer := 0;
    abits    : integer := 8);
  port (
	rst    : in  std_ulogic;
	clk    : in  std_ulogic;
	apbi   : in  apb_slv_in_type;
	apbo   : out apb_slv_out_type;
	LCD_data 	: out  STD_LOGIC_VECTOR (7 downto 0);
	LCD_RS 	: out  STD_LOGIC;
	LCD_RW 	: out  STD_LOGIC;
	LCD_E  	: out  STD_LOGIC;
	LCD_RET 	: out  STD_LOGIC;
	LCD_CS1 	: out  STD_LOGIC;
	LCD_CS2 	: out  STD_LOGIC;
	SF_CE0		: out	std_logic
    );
end apb_lcd_ctrlr;

architecture Behavioral of apb_lcd_ctrlr is

signal	FramBUFF :  FRM_Buff_Space;
signal	CMD		:	std_logic_vector(10 downto 0);
signal	Exec		:	std_logic;
signal	Ready		:	std_logic;
signal	LCD_CTRL	:	LCD_DRVR_CTRL_BUSS;



constant REVISION : integer := 1;

constant pconfig : apb_config_type := (
  0 => ahb_device_reg (VENDOR_LPP, LPP_LCD_CTRLR, 0, REVISION, 0),
  1 => apb_iobar(paddr, pmask));


--type FRM_Buff_El	is std_logic_vector(31 downto 0);
type FRM_Buff_Reg	is array(lcd_space_size-1 downto 0) of std_logic_vector(31 downto 0);


type LCD_ctrlr_Reg is record
  CTRL_Reg 		:   std_logic_vector(31 downto 0);
  FRAME_BUFF   :   FRM_Buff_Reg;
end record;

signal r : LCD_ctrlr_Reg;

signal Rdata	:	std_logic_vector(31 downto 0);

begin

LCD_data 	<=	LCD_CTRL.LCD_DATA;
LCD_RS 		<=	LCD_CTRL.LCD_RS;
LCD_RW 		<=	LCD_CTRL.LCD_RW;
LCD_E  		<=	LCD_CTRL.LCD_E;


LCD_RET	<=	'0';
LCD_CS1	<=	'0';
LCD_CS2	<=	'0';

SF_CE0	<=	'1';

CMD(7 downto 0)	<=	r.CTRL_Reg(7 downto 0); --CMD value
CMD(9 downto 8)	<=	r.CTRL_Reg(9 downto 8); --CMD tempo value

r.CTRL_Reg(10)		<=	Ready;

Driver0 : LCD_16x2_ENGINE
	generic map(50000)
    Port map(clk,rst,FramBUFF,CMD,Exec,Ready,LCD_CTRL);

FRM_BF : for i in 0 to lcd_space_size-1 generate
	FramBUFF(i)	<=	r.FRAME_BUFF(i)(7 downto 0);
end generate;


process(rst,clk)
begin
    if rst = '0' then
        r.CTRL_Reg(9 downto 0) <= (others => '0');
		  Exec	<=	'0';
    elsif clk'event and clk = '1' then

--APB Write OP
        if (apbi.psel(pindex) and apbi.penable and apbi.pwrite) = '1' then
            case apbi.paddr(7 downto 2) is
                when "000000" =>
                    r.CTRL_Reg(9 downto 0) <= apbi.pwdata(9 downto 0);
						  Exec	<=	'1';
                when others =>
                 writeC:   for i in 1 to lcd_space_size loop
								if TO_INTEGER(unsigned(apbi.paddr(abits-1 downto 2))) =i then
									r.FRAME_BUFF(i-1)	<=	apbi.pwdata;
								end if;
						Exec	<=	'0';
					end loop;
            end case;
			else
				Exec	<=	'0';
        end if;

--APB READ OP
        if (apbi.psel(pindex) and (not apbi.pwrite)) = '1' then
            case apbi.paddr(7 downto 2) is
                when "000000" =>
                    Rdata <= r.CTRL_Reg;
                when others =>
                    readC:   for i in 1 to lcd_space_size loop
								if TO_INTEGER(unsigned(apbi.paddr(abits-1 downto 2))) =i then
									Rdata(7 downto 0) <= r.FRAME_BUFF(i-1)(7 downto 0);
								end if;
					end loop;
            end case;
        end if;
    
    end if;
    apbo.pconfig <= pconfig;
end process;

apbo.prdata <=	Rdata when apbi.penable = '1' ;

end Behavioral;






