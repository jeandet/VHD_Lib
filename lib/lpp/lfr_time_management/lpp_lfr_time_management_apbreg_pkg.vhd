LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

PACKAGE lpp_lfr_time_management_apbreg_pkg IS
  
  CONSTANT ADDR_LFR_TM_CONTROL          : STD_LOGIC_VECTOR(7 DOWNTO 2) := "000000";
  CONSTANT ADDR_LFR_TM_TIME_LOAD        : STD_LOGIC_VECTOR(7 DOWNTO 2) := "000001";
  CONSTANT ADDR_LFR_TM_TIME_COARSE      : STD_LOGIC_VECTOR(7 DOWNTO 2) := "000010";
  CONSTANT ADDR_LFR_TM_TIME_FINE        : STD_LOGIC_VECTOR(7 DOWNTO 2) := "000011";
  
END lpp_lfr_time_management_apbreg_pkg;
