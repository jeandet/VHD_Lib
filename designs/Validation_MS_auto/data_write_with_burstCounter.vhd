
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.MATH_REAL.ALL;
USE ieee.numeric_std.ALL;

LIBRARY std;
use std.textio.all;

ENTITY data_write_with_burstCounter IS
  GENERIC (
    OUTPUT_FILE_NAME : STRING  := "output_data_2.txt";
    NB_CHAR_PER_DATA : INTEGER := 4;
    BASE_ADDR        : STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
  PORT (
    clk            : IN STD_LOGIC;
    rstn           : IN STD_LOGIC;

    burst_valid    : IN STD_LOGIC;
    burst_addr     : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    data_ren       : OUT STD_LOGIC;
    
    data           : IN STD_LOGIC_VECTOR(NB_CHAR_PER_DATA * 4 - 1 DOWNTO 0);
    close_file     : IN STD_LOGIC  
    );
END;

ARCHITECTURE beh OF data_write_with_burstCounter IS

  COMPONENT data_write
    GENERIC (
      OUTPUT_FILE_NAME : STRING;
      NB_CHAR_PER_DATA : INTEGER );
    PORT (
      clk         : IN STD_LOGIC;
      data_in_val : IN STD_LOGIC;
      data        : IN STD_LOGIC_VECTOR(NB_CHAR_PER_DATA * 4 - 1 DOWNTO 0);
      close_file  : IN STD_LOGIC);
  END COMPONENT;

  SIGNAL ren_counter : INTEGER;
  SIGNAL data_ren_s : STD_LOGIC;
  SIGNAL data_s : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_in_val : STD_LOGIC;
  
BEGIN 

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      ren_counter <= 0;
      data_ren_s <= '1';
      data_s <= (OTHERS => '0');
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      data_s <= data;
      data_ren_s <= '1';
      IF ren_counter = 0 AND burst_valid = '1' AND burst_addr = BASE_ADDR THEN
        ren_counter <= 16;
      END IF;
      IF ren_counter > 0 THEN
        ren_counter <= ren_counter - 1;
        data_ren_s <= '0';
      END IF;      
    END IF;
  END PROCESS;
  
  data_in_val <= NOT data_ren_s;
  data_ren    <= data_ren_s;
  
  data_write_1: data_write
    GENERIC MAP (
      OUTPUT_FILE_NAME => OUTPUT_FILE_NAME,
      NB_CHAR_PER_DATA => NB_CHAR_PER_DATA)
    PORT MAP (
      clk              => clk,
      data_in_val      => data_in_val,
      data             => data_s,
      close_file       => close_file);
  
END beh;
