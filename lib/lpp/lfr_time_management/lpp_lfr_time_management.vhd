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
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
LIBRARY grlib;
USE grlib.amba.ALL;
USE grlib.stdlib.ALL;
USE grlib.devices.ALL;

PACKAGE lpp_lfr_time_management IS

--***************************
-- APB_LFR_TIME_MANAGEMENT

  COMPONENT apb_lfr_time_management IS
    GENERIC(
      pindex      : INTEGER := 0;       --! APB slave index
      paddr       : INTEGER := 0;       --! ADDR field of the APB BAR
      pmask       : INTEGER := 16#fff#;   --! MASK field of the APB BAR
      pirq        : INTEGER := 0
      );
    PORT (
      clk25MHz     : IN  STD_LOGIC;     --! Clock
      clk49_152MHz : IN  STD_LOGIC;     --! secondary clock
      resetn       : IN  STD_LOGIC;     --! Reset
      grspw_tick   : IN  STD_LOGIC;  --! grspw signal asserted when a valid time-code is received
      apbi         : IN  apb_slv_in_type;   --! APB slave input signals
      apbo         : OUT apb_slv_out_type;  --! APB slave output signals
      coarse_time  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);  --! coarse time
      fine_time    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)   --! fine time
      );
  END COMPONENT;

  COMPONENT lfr_time_management
    GENERIC (
      nb_time_code_missing_limit : INTEGER);
    PORT (
      clk            : IN  STD_LOGIC;
      rstn           : IN  STD_LOGIC;
      new_timecode   : IN  STD_LOGIC;
      new_coarsetime : IN  STD_LOGIC;
      coarsetime_reg : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      fine_time      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      fine_time_new   : OUT STD_LOGIC;
      coarse_time    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      coarse_time_new : OUT STD_LOGIC
      );
  END COMPONENT;

  COMPONENT lpp_counter
    GENERIC (
      nb_wait_period : INTEGER;
      nb_bit_of_data : INTEGER);
    PORT (
      clk   : IN  STD_LOGIC;
      rstn  : IN  STD_LOGIC;
      clear : IN  STD_LOGIC;
      full  : OUT STD_LOGIC;
      data  : OUT STD_LOGIC_VECTOR(nb_bit_of_data-1 DOWNTO 0);
      new_data : OUT STD_LOGIC );
  END COMPONENT;

END lpp_lfr_time_management;

