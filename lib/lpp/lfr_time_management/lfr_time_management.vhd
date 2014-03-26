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
USE lpp.lpp_lfr_time_management.ALL;

ENTITY lfr_time_management IS
  GENERIC (
    FIRST_DIVISION   : INTEGER := 374;
    NB_SECOND_DESYNC : INTEGER := 60);
  PORT (
    clk  : IN STD_LOGIC;
    rstn : IN STD_LOGIC;

    tick           : IN STD_LOGIC;      -- transition signal information
    
    new_coarsetime : IN STD_LOGIC;      -- transition signal information
    coarsetime_reg : IN STD_LOGIC_VECTOR(30 DOWNTO 0);

    fine_time       : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    fine_time_new   : OUT STD_LOGIC;
    coarse_time     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    coarse_time_new : OUT STD_LOGIC
    );
END lfr_time_management;

ARCHITECTURE Behavioral OF lfr_time_management IS

  SIGNAL FT_max : STD_LOGIC;
  SIGNAL FT_half : STD_LOGIC;
  SIGNAL FT_wait : STD_LOGIC;

  TYPE state_fsm_time_management IS (DESYNC, TRANSITION, SYNC);
  SIGNAL state : state_fsm_time_management;

  SIGNAL fsm_desync   : STD_LOGIC;
  SIGNAL fsm_transition : STD_LOGIC;

  SIGNAL set_TCU : STD_LOGIC;
  SIGNAL CT_add1 : STD_LOGIC;

  SIGNAL new_coarsetime_reg : STD_LOGIC;
    
BEGIN

  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      new_coarsetime_reg <= '0';
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      IF new_coarsetime = '1' THEN
        new_coarsetime_reg <= '1';
      ELSIF tick = '1' THEN
        new_coarsetime_reg <= '0';
      END IF;      
    END IF;
  END PROCESS;
  
  -----------------------------------------------------------------------------
  -- FINE_TIME
  -----------------------------------------------------------------------------
  fine_time_counter_1: fine_time_counter
    GENERIC MAP (
      WAITING_TIME => X"0040",
      FIRST_DIVISION => FIRST_DIVISION)
    PORT MAP (
      clk            => clk,
      rstn           => rstn,
      tick           => tick,
      fsm_transition => fsm_transition,  -- todo
      FT_max         => FT_max,  
      FT_half        => FT_half, 
      FT_wait        => FT_wait, 
      fine_time      => fine_time, 
      fine_time_new  => fine_time_new);

  -----------------------------------------------------------------------------
  -- COARSE_TIME
  -----------------------------------------------------------------------------
  coarse_time_counter_1: coarse_time_counter
    GENERIC MAP(
      NB_SECOND_DESYNC => NB_SECOND_DESYNC )
    PORT MAP (
      clk           => clk,
      rstn          => rstn,
      tick          => tick,
      set_TCU       => set_TCU,         -- todo
      set_TCU_value => coarsetime_reg,  -- todo
      CT_add1       => CT_add1,         -- todo
      fsm_desync    => fsm_desync,      -- todo
      FT_max        => FT_max,
      coarse_time   => coarse_time,
      coarse_time_new   => coarse_time_new);

  -----------------------------------------------------------------------------
  -- FSM
  -----------------------------------------------------------------------------
  fsm_desync     <= '1' WHEN state = DESYNC     ELSE '0';
  fsm_transition <= '1' WHEN state = TRANSITION ELSE '0';
    
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      state <= DESYNC;
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      --CT_add1 <= '0';
      set_TCU <= '0';
      CASE state IS
        WHEN DESYNC =>
          IF tick = '1' THEN
            state <= SYNC;
            set_TCU <= new_coarsetime_reg;
            --IF new_coarsetime = '0' AND FT_half = '1' THEN
            --  CT_add1 <= '1';
            --END IF;
          --ELSIF FT_max = '1' THEN
          --  CT_add1 <= '1';
          END IF;
        WHEN TRANSITION => 
          IF tick = '1' THEN
            state         <= SYNC;
            set_TCU       <= new_coarsetime_reg;
            --IF new_coarsetime = '0' THEN
            --  CT_add1 <= '1';
            --END IF;
          ELSIF FT_wait = '1' THEN
            --CT_add1 <= '1';
            state         <= DESYNC;
          END IF;
        WHEN SYNC =>
          IF tick = '1' THEN
            set_TCU       <= new_coarsetime_reg;
            --IF new_coarsetime = '0' THEN
            --  CT_add1 <= '1';
            --END IF;
          ELSIF FT_max = '1' THEN
            state         <= TRANSITION;
          END IF;
        WHEN OTHERS => NULL;
      END CASE;
    END IF;
  END PROCESS;


  CT_add1 <= '1' WHEN state = SYNC   AND tick = '1' AND new_coarsetime_reg = '0' ELSE
             '1' WHEN state = DESYNC AND tick = '1' AND new_coarsetime_reg = '0' AND FT_half = '1' ELSE
             '1' WHEN state = DESYNC AND tick = '0' AND FT_max = '1' ELSE
             '1' WHEN state = TRANSITION AND  tick = '1' AND new_coarsetime_reg = '0' ELSE
             '1' WHEN state = TRANSITION AND  tick = '0' AND FT_wait = '1' ELSE             
             '0';
END Behavioral;
