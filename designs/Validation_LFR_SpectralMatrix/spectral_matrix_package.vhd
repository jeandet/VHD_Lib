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

END spectral_matrix_package;
