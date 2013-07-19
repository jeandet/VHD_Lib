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
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
LIBRARY lpp;
USE lpp.general_purpose.Clk_divider;

ENTITY lfr_time_management IS
  GENERIC (
    masterclk        : INTEGER := 25000000;  -- master clock in Hz
    timeclk          : INTEGER := 49152000;  -- 2nd clock in Hz
    finetimeclk      : INTEGER := 65536;  -- divided clock used for the fine time counter
    nb_clk_div_ticks : INTEGER := 1  -- nb ticks before commutation to AUTO state
    );
  PORT (
    master_clock           : IN  STD_LOGIC;  --! Clock                                  -- 25MHz
    time_clock             : IN  STD_LOGIC;  --! 2nd Clock                              -- 49MHz
    resetn                 : IN  STD_LOGIC;  --! Reset          
    grspw_tick             : IN  STD_LOGIC;                     
    soft_tick              : IN  STD_LOGIC;  --! soft tick, load the coarse_time value  -- 25MHz
    coarse_time_load       : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);                         -- 25MHz
    coarse_time            : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);                         -- 25MHz
    fine_time              : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);                         -- 25MHz
    next_commutation       : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);                         -- 25MHz
--    reset_next_commutation : OUT STD_LOGIC;
    irq1                   : OUT STD_LOGIC;                                             -- 25MHz
    irq2                   : OUT STD_LOGIC                                              -- 25MHz
    );
END lfr_time_management;

ARCHITECTURE Behavioral OF lfr_time_management IS

  SIGNAL resetn_clk_div            : STD_LOGIC;
  SIGNAL clk_div                   : STD_LOGIC;
--
  SIGNAL flag                      : STD_LOGIC;
  SIGNAL s_coarse_time             : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL previous_coarse_time_load : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL cpt                       : INTEGER RANGE 0 TO 100000;
  SIGNAL secondary_cpt             : INTEGER RANGE 0 TO 72000;
--
  SIGNAL sirq1                     : STD_LOGIC;
  SIGNAL sirq2                     : STD_LOGIC;
  SIGNAL cpt_next_commutation      : INTEGER RANGE 0 TO 100000;
  SIGNAL p_next_commutation        : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL latched_next_commutation  : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL p_clk_div                 : STD_LOGIC;
--
  TYPE   state_type IS (auto, slave);
  SIGNAL state                     : state_type;
  TYPE   timer_type IS (idle, engaged);
  SIGNAL commutation_timer         : timer_type;

BEGIN

--*******************************************
-- COMMUTATION TIMER AND INTERRUPT GENERATION
  PROCESS(master_clock, resetn)
  BEGIN

    IF resetn = '0' THEN
      commutation_timer        <= idle;
      cpt_next_commutation     <= 0;
      sirq1                    <= '0';
      sirq2                    <= '0';
      latched_next_commutation <= x"ffffffff";
      p_next_commutation       <= (others => '0');
      p_clk_div                <= '0';
    ELSIF master_clock'EVENT AND master_clock = '1' THEN
      
      CASE commutation_timer IS
        
        WHEN idle =>
          sirq1 <= '0';
          sirq2 <= '0';
          IF s_coarse_time = latched_next_commutation THEN
            commutation_timer        <= engaged;  -- transition to state "engaged"
            sirq1                    <= '1';      -- start the pulse on sirq1
            latched_next_commutation <= x"ffffffff";
          ELSIF NOT(p_next_commutation = next_commutation) THEN  -- next_commutation has changed
            latched_next_commutation <= next_commutation;  -- latch the value
          ELSE
            commutation_timer <= idle;
          END IF;
          
        WHEN engaged =>
          sirq1 <= '0';                 -- stop the pulse on sirq1
          IF NOT(p_clk_div = clk_div) AND clk_div = '1' THEN  -- detect a clk_div raising edge
            IF cpt_next_commutation = 65536 THEN
              cpt_next_commutation <= 0;
              commutation_timer    <= idle;
              sirq2                <= '1';  -- start the pulse on sirq2
            ELSE
              cpt_next_commutation <= cpt_next_commutation + 1;
            END IF;
          END IF;
          
        WHEN OTHERS =>
          commutation_timer <= idle;
          
      END CASE;

      p_next_commutation <= next_commutation;
      p_clk_div          <= clk_div;
      
    END IF;

  END PROCESS;

  irq1                   <= sirq1;
  irq2                   <= sirq2;
--  reset_next_commutation <= '0';

--
--*******************************************

--**********************
-- synchronization stage
  PROCESS(master_clock, resetn)         -- resynchronisation with clk
  BEGIN

    IF resetn = '0' THEN
      coarse_time(31 DOWNTO 0) <= x"80000000";  -- set the most significant bit of the coarse time to 1 on reset

    ELSIF master_clock'EVENT AND master_clock = '1' THEN
      coarse_time(31 DOWNTO 0) <= s_coarse_time(31 DOWNTO 0);  -- coarse_time is changed synchronously with clk
    END IF;

  END PROCESS;
--
--**********************


  -- PROCESS(clk_div, resetn, grspw_tick, soft_tick, flag, coarse_time_load) -- JC
  PROCESS(clk_div, resetn)              -- JC
  BEGIN

    IF resetn = '0' THEN
      flag                      <= '0';
      cpt                       <= 0;
      secondary_cpt             <= 0;
      s_coarse_time             <= x"80000000";  -- set the most significant bit of the coarse time to 1 on reset
      previous_coarse_time_load <= x"80000000";
      state                     <= auto;

      --ELSIF grspw_tick = '1' OR soft_tick = '1' THEN
      --  --IF flag = '1' THEN  -- coarse_time_load shall change at least 1/65536 s before the timecode
      --  --  s_coarse_time <= coarse_time_load;
      --  --  flag          <= '0';
      --  --ELSE  -- if coarse_time_load has not changed, increment the value autonomously
      --  --  s_coarse_time <= STD_LOGIC_VECTOR(UNSIGNED(s_coarse_time) + 1);
      --  --END IF;

      --  cpt           <= 0;
      --  secondary_cpt <= 0;
      --  state         <= slave;
      
    ELSIF clk_div'EVENT AND clk_div = '1' THEN
      
      CASE state IS
        
        WHEN auto =>
          IF grspw_tick = '1' OR soft_tick = '1' THEN
            IF flag = '1' THEN  -- coarse_time_load shall change at least 1/65536 s before the timecode
              s_coarse_time <= coarse_time_load;
            ELSE  -- if coarse_time_load has not changed, increment the value autonomously
              s_coarse_time <= STD_LOGIC_VECTOR(UNSIGNED(s_coarse_time) + 1);
            END IF;
            flag          <= '0';
            cpt           <= 0;
            secondary_cpt <= 0;
            state         <= slave;
          ELSE
            IF cpt = 65535 THEN
              IF flag = '1' THEN
                s_coarse_time <= coarse_time_load;
                flag          <= '0';
              ELSE
                s_coarse_time <= STD_LOGIC_VECTOR(UNSIGNED(s_coarse_time) + 1);
              END IF;
              cpt           <= 0;
              secondary_cpt <= secondary_cpt + 1;
            ELSE
              cpt <= cpt + 1;
            END IF;
          END IF;
          
        WHEN slave =>
          IF grspw_tick = '1' OR soft_tick = '1' THEN
            IF flag = '1' THEN  -- coarse_time_load shall change at least 1/65536 s before the timecode
              s_coarse_time <= coarse_time_load;
            ELSE  -- if coarse_time_load has not changed, increment the value autonomously
              s_coarse_time <= STD_LOGIC_VECTOR(UNSIGNED(s_coarse_time) + 1);
            END IF;
            flag          <= '0';
            cpt           <= 0;
            secondary_cpt <= 0;
            state         <= slave;
          ELSE
            IF cpt = 65536 + nb_clk_div_ticks THEN  -- 1 / 65536 = 15.259 us
              state <= auto;            -- commutation to AUTO state
              IF flag = '1' THEN
                s_coarse_time <= coarse_time_load;
                flag          <= '0';
              ELSE
                s_coarse_time <= STD_LOGIC_VECTOR(UNSIGNED(s_coarse_time) + 1);
              END IF;
              cpt           <= nb_clk_div_ticks;  -- reset cpt at nb_clk_div_ticks
              secondary_cpt <= secondary_cpt + 1;
            ELSE
              cpt <= cpt + 1;
            END IF;
          END IF;
          
        WHEN OTHERS =>
          state <= auto;

      END CASE;

      IF secondary_cpt > 60 THEN
        s_coarse_time(31) <= '1';
      END IF;

      IF NOT(previous_coarse_time_load = coarse_time_load) THEN
        flag <= '1';
      END IF;

      previous_coarse_time_load <= coarse_time_load;
      
    END IF;
    
  END PROCESS;

  fine_time <= STD_LOGIC_VECTOR(to_unsigned(cpt, 32));

-- resetn       grspw_tick      soft_tick       resetn_clk_div
--      0                       0                               0                               0
--      0                       0                               1                               0
--      0                       1                               0                               0
--      0                       1                               1                               0
--      1                       0                               0                               1
--      1                       0                               1                               0
--      1                       1                               0                               0
--      1                       1                               1                               0
  resetn_clk_div <= '1' WHEN ((resetn = '1') AND (grspw_tick = '0') AND (soft_tick = '0')) ELSE '0';
  Clk_divider0 : Clk_divider            -- the target frequency is 65536 Hz
    GENERIC MAP (timeclk, finetimeclk) PORT MAP (time_clock, resetn_clk_div, clk_div);

END Behavioral;
