----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:04:01 07/02/2012 
-- Design Name: 
-- Module Name:    lpp_lfr_time_management - Behavioral 
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
use IEEE.STD_LOGIC_1164.all;
library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;

package lpp_lfr_time_management is

--***************************
-- APB_LFR_TIME_MANAGEMENT

component apb_lfr_time_management is

    generic(
			pindex      : integer := 0;			--! APB slave index
			paddr       : integer := 0;			--! ADDR field of the APB BAR
			pmask       : integer := 16#fff#;	--! MASK field of the APB BAR
			pirq        : integer := 0;			--! 2 consecutive IRQ lines are used
			masterclk 	: integer := 25000000;		--! master clock in Hz
			timeclk  	: integer := 49152000;      --! other clock in Hz
			finetimeclk	: integer := 65536			--! divided clock used for the fine time counter
			);

    Port (
			clk25MHz		: in	STD_LOGIC;	--! Clock
			clk49_152MHz	: in    STD_LOGIC;  --! secondary clock
			resetn      	: in	STD_LOGIC;	--! Reset
			grspw_tick		: in	STD_LOGIC;	--! grspw signal asserted when a valid time-code is received
			apbi       		: in	apb_slv_in_type;	--! APB slave input signals
			apbo       		: out	apb_slv_out_type;	--! APB slave output signals
			coarse_time		: out	std_logic_vector(31 downto 0);	--! coarse time
			fine_time		: out	std_logic_vector(31 downto 0)	--! fine time
			);

end component;

component lfr_time_management is	

    generic (
		masterclk	: integer := 25000000;		-- master clock in Hz
		timeclk		: integer := 49152000;      -- 2nd clock in Hz
		finetimeclk	: integer := 65536;			-- divided clock used for the fine time counter
		nb_clk_div_ticks	: integer   := 1    -- nb ticks before commutation to AUTO state
		);
    Port ( 
		master_clock		: in    std_logic;				--! Clock
		time_clock        	: in    std_logic;				--! 2nd Clock
		resetn      		: in    std_logic;				--! Reset
		grspw_tick			: in    std_logic;
		soft_tick			: in    std_logic;				--! soft tick, load the coarse_time value
		coarse_time_load	: in    std_logic_vector(31 downto 0);
		coarse_time			: out   std_logic_vector(31 downto 0);
		fine_time			: out	std_logic_vector(31 downto 0);
		next_commutation	: in	std_logic_vector(31 downto 0);
		reset_next_commutation: out  std_logic;
		irq1                : out std_logic;
		irq2                : out std_logic
		);
				
end component;

end lpp_lfr_time_management;

