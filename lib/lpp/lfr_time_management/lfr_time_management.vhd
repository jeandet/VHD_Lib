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
    nb_time_code_missing_limit : INTEGER := 60;
    nb_wait_pediod             : INTEGER := 375
    );
  PORT (
    clk  : IN STD_LOGIC;
    rstn : IN STD_LOGIC;

    new_timecode   : IN STD_LOGIC;      -- transition signal information
    new_coarsetime : IN STD_LOGIC;      -- transition signal information
    coarsetime_reg : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

    fine_time       : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    fine_time_new   : OUT STD_LOGIC;
    coarse_time     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    coarse_time_new : OUT STD_LOGIC
    );
END lfr_time_management;

ARCHITECTURE Behavioral OF lfr_time_management IS

  SIGNAL counter_clear : STD_LOGIC;
  SIGNAL counter_full  : STD_LOGIC;

  SIGNAL nb_time_code_missing : INTEGER;
  SIGNAL coarse_time_s        : INTEGER;

  SIGNAL new_coarsetime_s : STD_LOGIC;
  
BEGIN
  
  lpp_counter_1 : lpp_counter
    GENERIC MAP (
      nb_wait_period => nb_wait_pediod,
      nb_bit_of_data => 16)
    PORT MAP (
      clk   => clk,
      rstn  => rstn,
      clear => counter_clear,
      full  => counter_full,
      data  => fine_time,
      new_data => fine_time_new);

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      nb_time_code_missing <= 0;
      counter_clear        <= '0';
      coarse_time_s <= 0;
      coarse_time_new <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
      IF new_coarsetime = '1' THEN
        new_coarsetime_s <= '1';
      ELSIF new_timecode = '1' THEN
        new_coarsetime_s <= '0';        
      END IF;
      
      IF new_timecode = '1' THEN
        coarse_time_new <= '1';
        IF new_coarsetime_s = '1' THEN
          coarse_time_s <= to_integer(unsigned(coarsetime_reg));
        ELSE
          coarse_time_s <= coarse_time_s + 1;
        END IF;
        nb_time_code_missing <= 0;
        counter_clear        <= '1';
      ELSE
        coarse_time_new <= '0';
        counter_clear <= '0';
        IF counter_full = '1' THEN
          coarse_time_new <= '1';
          coarse_time_s <= coarse_time_s + 1;
          IF nb_time_code_missing = nb_time_code_missing_limit THEN
            nb_time_code_missing <= nb_time_code_missing_limit;
          ELSE
            nb_time_code_missing <= nb_time_code_missing + 1;
          END IF;
        END IF;
      END IF;
    END IF;
  END PROCESS;

  coarse_time(30 DOWNTO 0) <= STD_LOGIC_VECTOR(to_unsigned(coarse_time_s,31));
  coarse_time(31)          <= '1' WHEN nb_time_code_missing = nb_time_code_missing_limit ELSE '0';
  
END Behavioral;
