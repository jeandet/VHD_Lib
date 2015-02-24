
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.MATH_REAL.ALL;
USE ieee.numeric_std.ALL;

LIBRARY std;
use std.textio.all;

ENTITY data_read_with_timer IS
  GENERIC (
    input_file_name  : STRING := "input_data_2.txt";
    NB_CHAR_PER_DATA : INTEGER := 4;
    NB_CYCLE_TIMER   : INTEGER := 1024
    );
  PORT (
    clk           : IN STD_LOGIC;
    rstn          : IN STD_LOGIC;

    end_of_file   : OUT STD_LOGIC;
    
    data_out_val  : OUT STD_LOGIC;
    data_out      : OUT STD_LOGIC_VECTOR(NB_CHAR_PER_DATA * 4 - 1 DOWNTO 0)
    );
END;

ARCHITECTURE beh OF data_read_with_timer IS

  COMPONENT data_read
    GENERIC (
      input_file_name  : STRING;
      NB_CHAR_PER_DATA : INTEGER);
    PORT (
      clk           : IN  STD_LOGIC;
      read_new_data : IN  STD_LOGIC;
      end_of_file   : OUT STD_LOGIC;
      data_out_val  : OUT STD_LOGIC;
      data_out      : OUT STD_LOGIC_VECTOR(NB_CHAR_PER_DATA * 4 - 1 DOWNTO 0));
  END COMPONENT;

  SIGNAL nb_cycle_counter : INTEGER;
  SIGNAL read_new_data : STD_LOGIC;
  
BEGIN  -- beh

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      nb_cycle_counter <= 0;
      read_new_data    <= '0';
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      IF nb_cycle_counter < NB_CYCLE_TIMER-1 THEN
        nb_cycle_counter <= nb_cycle_counter + 1;
        read_new_data    <= '0';
      ELSE
        nb_cycle_counter <= 0;
        read_new_data <= '1';
      END IF;      
    END IF;
  END PROCESS;

  
  data_read_1: data_read
    GENERIC MAP (
      input_file_name  => input_file_name,
      NB_CHAR_PER_DATA => NB_CHAR_PER_DATA)
    PORT MAP (
      clk           => clk,
      read_new_data => read_new_data,
      end_of_file   => end_of_file,
      data_out_val  => data_out_val,
      data_out      => data_out);

END beh;
