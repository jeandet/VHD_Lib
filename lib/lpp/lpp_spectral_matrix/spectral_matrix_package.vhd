LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

PACKAGE spectral_matrix_package IS

  COMPONENT spectral_matrix_switch_f0
    PORT (
      clk          : IN  STD_LOGIC;
      rstn         : IN  STD_LOGIC;
      sample_wen   : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
      fifo_A_empty : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
      fifo_A_full  : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
      fifo_A_wen   : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
      fifo_B_empty : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
      fifo_B_full  : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
      fifo_B_wen   : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
      error_wen    : OUT STD_LOGIC);
  END COMPONENT;

  COMPONENT spectral_matrix_time_managment
    PORT (
      clk      : IN  STD_LOGIC;
      rstn     : IN  STD_LOGIC;
      time_in  : IN  STD_LOGIC_VECTOR(47 DOWNTO 0);
      update_1 : IN  STD_LOGIC;
      time_out : OUT STD_LOGIC_VECTOR(47 DOWNTO 0));
  END COMPONENT;

  COMPONENT MS_control
    PORT (
      clk               : IN  STD_LOGIC;
      rstn              : IN  STD_LOGIC;
      current_status_ms : IN STD_LOGIC_VECTOR(49 DOWNTO 0); -- TIME(47 .. 0) & Matrix_type(1..0)
      fifo_in_lock      : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
      fifo_in_data      : IN  STD_LOGIC_VECTOR(32*5-1 DOWNTO 0);
      fifo_in_full      : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
      fifo_in_empty     : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
      fifo_in_ren       : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
      fifo_in_reuse     : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
      fifo_out_data     : OUT STD_LOGIC_VECTOR(32*2-1 DOWNTO 0);
      fifo_out_ren      : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
      fifo_out_empty    : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      current_status_component : OUT STD_LOGIC_VECTOR(53 DOWNTO 0);  -- TIME(47 .. 0) &
      correlation_start : OUT STD_LOGIC;
      correlation_auto  : OUT STD_LOGIC;
      correlation_done  : IN  STD_LOGIC);
  END COMPONENT;

  COMPONENT MS_calculation
    PORT (
      clk               : IN  STD_LOGIC;
      rstn              : IN  STD_LOGIC;
      fifo_in_data      : IN  STD_LOGIC_VECTOR(32*2-1 DOWNTO 0);
      fifo_in_ren       : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      fifo_in_empty     : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
      fifo_out_data     : OUT STD_LOGIC_VECTOR(32-1 DOWNTO 0);
      fifo_out_wen      : OUT STD_LOGIC;
      fifo_out_full     : IN  STD_LOGIC;
      correlation_start : IN  STD_LOGIC;
      correlation_auto  : IN  STD_LOGIC;
      correlation_begin  : OUT  STD_LOGIC;
      correlation_done  : OUT STD_LOGIC);
  END COMPONENT;
  
END spectral_matrix_package;
