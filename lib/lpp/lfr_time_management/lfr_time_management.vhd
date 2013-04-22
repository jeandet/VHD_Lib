----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:14:05 07/02/2012 
-- Design Name: 
-- Module Name:    lfr_time_management - Behavioral 
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
use lpp.general_purpose.Clk_divider;

entity lfr_time_management is
	generic (
		masterclk	: integer := 25000000;		-- master clock in Hz
		timeclk    : integer := 49152000;      -- 2nd clock in Hz
		finetimeclk	: integer := 65536;			-- divided clock used for the fine time counter
		nb_clk_div_ticks    : integer   := 1    -- nb ticks before commutation to AUTO state
		);
	Port ( 
		master_clock		: in    std_logic;				--! Clock
		time_clock      	: in    std_logic;				--! 2nd Clock
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
end lfr_time_management;

architecture Behavioral of lfr_time_management is

signal	resetn_clk_div		: std_logic;
signal	clk_div				: std_logic;
--
signal	flag					: std_logic;
signal	s_coarse_time		: std_logic_vector(31 downto 0);
signal	previous_coarse_time_load	: std_logic_vector(31 downto 0);
signal 	cpt					: integer range 0 to 100000;
signal 	secondary_cpt		: integer range 0 to 72000;
--
signal  	sirq1             : std_logic;
signal  	sirq2             : std_logic;
signal  	cpt_next_commutation			: integer range 0 to 100000;
signal  	p_next_commutation 			: std_logic_vector(31 downto 0);
signal	latched_next_commutation	: std_logic_vector(31 downto 0);
signal  	p_clk_div			: std_logic;
--
type state_type is (auto, slave);
signal state				: state_type;
type timer_type is (idle, engaged);
signal commutation_timer	: timer_type;

begin

--*******************************************
-- COMMUTATION TIMER AND INTERRUPT GENERATION
process(master_clock, resetn)
begin

	if resetn = '0' then
		commutation_timer <= idle;
		cpt_next_commutation <= 0;
		sirq1 <= '0';		
		sirq2 <= '0';		
		latched_next_commutation <= x"ffffffff";
		
	elsif master_clock'event and master_clock = '1' then
	
		case commutation_timer is
		
			when idle =>
				sirq1 <= '0';
				sirq2 <= '0';
				if s_coarse_time = latched_next_commutation then
					commutation_timer <= engaged;								-- transition to state "engaged"
					sirq1 <= '1';													-- start the pulse on sirq1
					latched_next_commutation <= x"ffffffff";
				elsif not(p_next_commutation = next_commutation) then	-- next_commutation has changed
					latched_next_commutation <= next_commutation;		-- latch the value
				else
					commutation_timer <= idle;
				end if;
				
			when engaged => 
				sirq1 <= '0';														-- stop the pulse on sirq1
				if not(p_clk_div = clk_div) and clk_div = '1' then		-- detect a clk_div raising edge
					if cpt_next_commutation = 65536 then
						cpt_next_commutation <= 0;
						commutation_timer <= idle;
						sirq2 <= '1';													-- start the pulse on sirq2
					else
						cpt_next_commutation <= cpt_next_commutation + 1;
					end if;
				end if;
			
			when others =>
				commutation_timer <= idle;
				
		end case;
		
		p_next_commutation <= next_commutation;
		p_clk_div <= clk_div;
	
	end if;

end process;

irq1 <= sirq1;
irq2 <= sirq2;
reset_next_commutation <= '0';

--
--*******************************************

--**********************
-- synchronization stage
process(master_clock, resetn) -- resynchronisation with clk
begin

	if resetn = '0' then
        coarse_time(31 downto 0) <= x"80000000"; -- set the most significant bit of the coarse time to 1 on reset

    elsif master_clock'event and master_clock = '1' then
        coarse_time(31 downto 0) <= s_coarse_time(31 downto 0); -- coarse_time is changed synchronously with clk
    end if;

end process;
--
--**********************


process(clk_div, resetn, grspw_tick, soft_tick, flag, coarse_time_load) -- 
begin

	if resetn = '0' then
		flag <= '0';
		cpt <= 0;
		secondary_cpt <= 0;
		s_coarse_time <= x"80000000"; -- set the most significant bit of the coarse time to 1 on reset
		previous_coarse_time_load <= x"80000000";
		state <= auto;
		
	elsif grspw_tick = '1' or soft_tick = '1' then
        if flag = '1' then -- coarse_time_load shall change at least 1/65536 s before the timecode
			s_coarse_time <= coarse_time_load;
			flag <= '0';
		else -- if coarse_time_load has not changed, increment the value autonomously
			s_coarse_time <= std_logic_vector(unsigned(s_coarse_time) + 1);
		end if;
		cpt <= 0;
		secondary_cpt <= 0;
		state <= slave;
		
	elsif clk_div'event and clk_div = '1' then
	
		case state is
		
			when auto =>
				if cpt = 65535 then
					if flag = '1' then
						s_coarse_time <= coarse_time_load;
						flag <= '0';
					else
						s_coarse_time <= std_logic_vector(unsigned(s_coarse_time) + 1);
					end if;
					cpt <= 0;
					secondary_cpt <= secondary_cpt + 1;
                else 
                    cpt <= cpt + 1 ;
				end if;
			
			when slave =>
				if cpt = 65536 + nb_clk_div_ticks then -- 1 / 65536 = 15.259 us
                    state <= auto;      -- commutation to AUTO state
					if flag = '1' then
						s_coarse_time <= coarse_time_load;
						flag <= '0';
					else
						s_coarse_time <= std_logic_vector(unsigned(s_coarse_time) + 1);
					end if;
					cpt <= nb_clk_div_ticks;           -- reset cpt at nb_clk_div_ticks
					secondary_cpt <= secondary_cpt + 1;
                else
                    cpt <= cpt + 1;
				end if;
				
			when others =>
				state <= auto;

		end case;
		
		if secondary_cpt > 60 then
			s_coarse_time(31) <= '1';
		end if;

        if not(previous_coarse_time_load = coarse_time_load) then
			flag <= '1';
		end if;

        previous_coarse_time_load <= coarse_time_load;
	
	end if;
	
end process;

fine_time <= std_logic_vector(to_unsigned(cpt, 32));

-- resetn	grspw_tick	soft_tick	resetn_clk_div
--	0			0				0				0
--	0			0				1				0
--	0			1				0				0
--	0			1				1				0
--	1			0				0				1
--	1			0				1				0
--	1			1				0				0
--	1			1				1				0
resetn_clk_div <= '1' when ( (resetn='1') and (grspw_tick='0') and (soft_tick='0') ) else '0';
Clk_divider0 : Clk_divider  -- the target frequency is 65536 Hz
generic map (timeclk,finetimeclk) port map ( time_clock, resetn_clk_div, clk_div);

end Behavioral;