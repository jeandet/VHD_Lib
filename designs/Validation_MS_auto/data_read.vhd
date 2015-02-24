
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.MATH_REAL.ALL;
USE ieee.numeric_std.ALL;

LIBRARY std;
use std.textio.all;

ENTITY data_read IS
  GENERIC (
    input_file_name  : STRING := "input_data_2.txt";
    NB_CHAR_PER_DATA : INTEGER := 4
    );
  PORT (
    clk           : IN STD_LOGIC;
    read_new_data : IN STD_LOGIC;

    end_of_file   : OUT STD_LOGIC;
    
    data_out_val  : OUT STD_LOGIC;
    data_out      : OUT STD_LOGIC_VECTOR(NB_CHAR_PER_DATA * 4 - 1 DOWNTO 0)
    );
END;

ARCHITECTURE beh OF data_read IS

BEGIN  -- beh

  PROCESS
    FILE     file_pointer : TEXT;
    VARIABLE line_read    : LINE;
    VARIABLE line_content : STRING(1 TO NB_CHAR_PER_DATA);
    VARIABLE char_read    : CHARACTER;
    VARIABLE data_read    : STD_LOGIC_VECTOR(NB_CHAR_PER_DATA * 4 - 1 DOWNTO 0);
    VARIABLE signal_part  : STD_LOGIC_VECTOR(3 DOWNTO 0);
  BEGIN  -- PROCESS
    end_of_file  <= '0';
    data_out_val <= '0';
    data_out     <= (OTHERS => '0');
    
    WAIT UNTIL clk = '1';
    
    file_open(file_pointer,input_file_name,READ_MODE);
    WHILE NOT endfile(file_pointer) LOOP
      readline(file_pointer, line_read);
      read(line_read,line_content);
      FOR i IN 1 TO NB_CHAR_PER_DATA LOOP
        char_read := line_content(NB_CHAR_PER_DATA+1-i);
        CASE char_read IS
          WHEN '0' => data_read(4*i-1 DOWNTO 4*(i-1)) := "0000";
          WHEN '1' => data_read(4*i-1 DOWNTO 4*(i-1)) := "0001";
          WHEN '2' => data_read(4*i-1 DOWNTO 4*(i-1)) := "0010";
          WHEN '3' => data_read(4*i-1 DOWNTO 4*(i-1)) := "0011";
          WHEN '4' => data_read(4*i-1 DOWNTO 4*(i-1)) := "0100";
          WHEN '5' => data_read(4*i-1 DOWNTO 4*(i-1)) := "0101";
          WHEN '6' => data_read(4*i-1 DOWNTO 4*(i-1)) := "0110";
          WHEN '7' => data_read(4*i-1 DOWNTO 4*(i-1)) := "0111";
          WHEN '8' => data_read(4*i-1 DOWNTO 4*(i-1)) := "1000";
          WHEN '9' => data_read(4*i-1 DOWNTO 4*(i-1)) := "1001";
          WHEN 'a' => data_read(4*i-1 DOWNTO 4*(i-1)) := "1010";
          WHEN 'b' => data_read(4*i-1 DOWNTO 4*(i-1)) := "1011";
          WHEN 'c' => data_read(4*i-1 DOWNTO 4*(i-1)) := "1100";
          WHEN 'd' => data_read(4*i-1 DOWNTO 4*(i-1)) := "1101";
          WHEN 'e' => data_read(4*i-1 DOWNTO 4*(i-1)) := "1110";
          WHEN 'f' => data_read(4*i-1 DOWNTO 4*(i-1)) := "1111";
          WHEN OTHERS => NULL;
        END CASE;        
      END LOOP;
      WAIT UNTIL read_new_data = '1';    
      WAIT UNTIL clk = '1';
      data_out          <= data_read;
      data_out_val      <= '1';  
      WAIT UNTIL clk = '1';
      data_out_val      <= '0';  
    END LOOP;
    file_close(file_pointer);
    end_of_file  <= '1';
    data_out_val <= '0';
    WAIT;
    
  END PROCESS;

END beh;
