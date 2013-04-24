----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:17:05 07/02/2012 
-- Design Name: 
-- Module Name:    apb_lfr_time_management - Behavioral 
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
library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;
library lpp;
use lpp.apb_devices_list.all;
use lpp.lpp_lfr_time_management.all;

entity apb_lfr_time_management is

generic(
			pindex      : integer := 0;			--! APB slave index
			paddr       : integer := 0;			--! ADDR field of the APB BAR
			pmask       : integer := 16#fff#;	--! MASK field of the APB BAR
			pirq        : integer := 0;			--! 2 consecutive IRQ lines are used
			masterclk 	: integer := 25000000;	--! master clock in Hz
			otherclk    : integer := 49152000;  --! other clock in Hz
			finetimeclk	: integer := 65536	    --! divided clock used for the fine time counter
			);

Port (
			clk25MHz		: in	STD_LOGIC;	--! Clock
			clk49_152MHz	: in  STD_LOGIC;  	--! secondary clock
			resetn      	: in	STD_LOGIC;	--! Reset
			grspw_tick		: in	STD_LOGIC;	--! grspw signal asserted when a valid time-code is received
			apbi       		: in	apb_slv_in_type;	--! APB slave input signals
			apbo       		: out	apb_slv_out_type;	--! APB slave output signals
			coarse_time		: out	std_logic_vector(31 downto 0);	--! coarse time
			fine_time		: out	std_logic_vector(31 downto 0)	--! fine time
			);
				
end apb_lfr_time_management;

architecture Behavioral of apb_lfr_time_management is

constant REVISION : integer := 1;

--! the following types are defined in the grlib amba package
--! subtype amba_config_word is std_logic_vector(31 downto 0);
--! type apb_config_type is array (0 to NAPBCFG-1) of amba_config_word;
constant pconfig : apb_config_type := (
--!  0 => ahb_device_reg (VENDOR_LPP, LPP_ROTARY, 0, REVISION, 0),
	0 => ahb_device_reg (19, 14, 0, REVISION, pirq),
	1 => apb_iobar(paddr, pmask));

type apb_lfr_time_management_Reg is record
	ctrl				: std_logic_vector(31 downto 0);
	coarse_time_load	: std_logic_vector(31 downto 0);
	coarse_time			: std_logic_vector(31 downto 0);
	fine_time			: std_logic_vector(31 downto 0);
    next_commutation    : std_logic_vector(31 downto 0);
end record;

signal r			: apb_lfr_time_management_Reg;
signal Rdata	  	: std_logic_vector(31 downto 0);
signal force_tick	: std_logic;
signal previous_force_tick	    : std_logic;
signal soft_tick			    : std_logic;
signal reset_next_commutation   : std_logic;

begin

lfrtimemanagement0: lfr_time_management
generic map(masterclk => masterclk, timeclk => otherclk, finetimeclk => finetimeclk)
Port map( master_clock => clk25MHz, time_clock => clk49_152MHz, resetn => resetn, 
	grspw_tick => grspw_tick, soft_tick => soft_tick, 
	coarse_time_load => r.coarse_time_load, coarse_time => r.coarse_time, fine_time => r.fine_time,
	next_commutation => r.next_commutation, reset_next_commutation => reset_next_commutation, 
	irq1 => apbo.pirq(pirq), irq2 => apbo.pirq(pirq+1) );	

process(resetn,clk25MHz, reset_next_commutation)
begin

	if resetn = '0' then
		r.coarse_time_load	<= x"80000000";
		r.ctrl				<= x"00000000";
        r.next_commutation  <= x"ffffffff";
		force_tick				<= '0';
		previous_force_tick	<= '0';
		soft_tick				<= '0';

    elsif reset_next_commutation = '1' then
        r.next_commutation  <= x"ffffffff";

	elsif clk25MHz'event and clk25MHz = '1' then

		previous_force_tick <= force_tick;
		force_tick <= r.ctrl(0);
		if (previous_force_tick = '0') and (force_tick = '1') then
			soft_tick <= '1';
		else
			soft_tick <= '0';
		end if;
		
--APB Write OP
		if (apbi.psel(pindex) and apbi.penable and apbi.pwrite) = '1' then
			case apbi.paddr(7 downto 2) is
				when "000000" =>
					r.ctrl <= apbi.pwdata(31 downto 0);
				when "000001" =>
					r.coarse_time_load <= apbi.pwdata(31 downto 0);
                when "000100" =>
                    r.next_commutation <= apbi.pwdata(31 downto 0);
				when others =>
					r.coarse_time_load <= x"00000000";
			end case;
		elsif r.ctrl(0) = '1' then
			r.ctrl(0) <= '0';
		end if;

--APB READ OP
		if (apbi.psel(pindex) and (not apbi.pwrite)) = '1' then
			case apbi.paddr(7 downto 2) is
				when "000000" =>
					Rdata(31 downto 24)	<= r.ctrl(31 downto 24);
					Rdata(23 downto 16)	<= r.ctrl(23 downto 16);
					Rdata(15 downto 8)	<= r.ctrl(15 downto 8);
					Rdata(7 downto 0)	<= r.ctrl(7 downto 0);
				when "000001" =>
					Rdata(31 downto 24)	<= r.coarse_time_load(31 downto 24);
					Rdata(23 downto 16)	<= r.coarse_time_load(23 downto 16);
					Rdata(15 downto 8)	<= r.coarse_time_load(15 downto 8);
					Rdata(7 downto 0)		<= r.coarse_time_load(7 downto 0);
				when "000010" =>
					Rdata(31 downto 24)	<= r.coarse_time(31 downto 24);
					Rdata(23 downto 16)	<= r.coarse_time(23 downto 16);
					Rdata(15 downto 8)	<= r.coarse_time(15 downto 8);
					Rdata(7 downto 0)	<= r.coarse_time(7 downto 0);
				when "000011" =>
					Rdata(31 downto 24)	<= r.fine_time(31 downto 24);
					Rdata(23 downto 16)	<= r.fine_time(23 downto 16);
					Rdata(15 downto 8)	<= r.fine_time(15 downto 8);
					Rdata(7 downto 0)	<= r.fine_time(7 downto 0);
                when "000100" =>
					Rdata(31 downto 24)	<= r.next_commutation(31 downto 24);
					Rdata(23 downto 16)	<= r.next_commutation(23 downto 16);
					Rdata(15 downto 8)	<= r.next_commutation(15 downto 8);
					Rdata(7 downto 0)	<= r.next_commutation(7 downto 0);
				when others =>
					Rdata(31 downto 0)	<= x"00000000";
				end case;
		end if;

	end if;
	apbo.pconfig <= pconfig;
end process;

apbo.prdata <=	Rdata when apbi.penable = '1' ;
coarse_time <= r.coarse_time;
fine_time <= r.fine_time;

end Behavioral;