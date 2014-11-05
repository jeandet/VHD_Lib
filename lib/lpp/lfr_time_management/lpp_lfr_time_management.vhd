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
      pindex            : INTEGER := 0;            --! APB slave index
      paddr             : INTEGER := 0;            --! ADDR field of the APB BAR
      pmask             : INTEGER := 16#fff#;       --! MASK field of the APB BAR
      FIRST_DIVISION    : INTEGER;
      NB_SECOND_DESYNC  : INTEGER);
    PORT (
      clk25MHz     : IN  STD_LOGIC;     --! Clock
      clk24_576MHz : IN  STD_LOGIC;     --! secondary clock
      resetn       : IN  STD_LOGIC;     --! Reset
      grspw_tick   : IN  STD_LOGIC;  --! grspw signal asserted when a valid time-code is received
      apbi         : IN  apb_slv_in_type;   --! APB slave input signals
      apbo         : OUT apb_slv_out_type;  --! APB slave output signals
      coarse_time  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);  --! coarse time
      fine_time    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);   --! fine TIME
      LFR_soft_rstn : OUT STD_LOGIC      
      );
  END COMPONENT;

  COMPONENT lfr_time_management
    GENERIC (
      FIRST_DIVISION   : INTEGER;
      NB_SECOND_DESYNC : INTEGER);
    PORT (
      clk             : IN  STD_LOGIC;
      rstn            : IN  STD_LOGIC;
      tick            : IN  STD_LOGIC;
      new_coarsetime  : IN  STD_LOGIC;
      coarsetime_reg  : IN  STD_LOGIC_VECTOR(30 DOWNTO 0);
      fine_time       : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      fine_time_new   : OUT STD_LOGIC;
      coarse_time     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      coarse_time_new : OUT STD_LOGIC);
  END COMPONENT;

  COMPONENT coarse_time_counter
    GENERIC (
      NB_SECOND_DESYNC : INTEGER );
    PORT (
      clk             : IN  STD_LOGIC;
      rstn            : IN  STD_LOGIC;
      tick            : IN  STD_LOGIC;
      set_TCU         : IN  STD_LOGIC;
      new_TCU         : IN  STD_LOGIC;
      set_TCU_value   : IN  STD_LOGIC_VECTOR(30 DOWNTO 0);
      CT_add1         : IN  STD_LOGIC;
      fsm_desync      : IN  STD_LOGIC;
      FT_max          : IN  STD_LOGIC;
      coarse_time     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      coarse_time_new : OUT STD_LOGIC);
  END COMPONENT;

  COMPONENT fine_time_counter
    GENERIC (
      WAITING_TIME : STD_LOGIC_VECTOR(15 DOWNTO 0);
      FIRST_DIVISION : INTEGER );
    PORT (
      clk            : IN  STD_LOGIC;
      rstn           : IN  STD_LOGIC;
      tick           : IN  STD_LOGIC;
      fsm_transition : IN  STD_LOGIC;
      FT_max         : OUT STD_LOGIC;
      FT_half        : OUT STD_LOGIC;
      FT_wait        : OUT STD_LOGIC;
      fine_time      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      fine_time_new  : OUT STD_LOGIC);
  END COMPONENT;
  
  
END lpp_lfr_time_management;

