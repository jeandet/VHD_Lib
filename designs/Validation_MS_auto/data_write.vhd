
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.MATH_REAL.ALL;
USE ieee.numeric_std.ALL;

LIBRARY std;
use std.textio.all;

ENTITY data_write IS
  GENERIC (
    OUTPUT_FILE_NAME : STRING  := "output_data_2.txt";
    NB_CHAR_PER_DATA : INTEGER := 4
    );
  PORT (
    clk            : IN STD_LOGIC;
    data_in_val    : IN STD_LOGIC;
    data           : IN STD_LOGIC_VECTOR(NB_CHAR_PER_DATA * 4 - 1 DOWNTO 0);    
    close_file     : IN STD_LOGIC
    );
END;

ARCHITECTURE beh OF data_write IS

  
BEGIN  -- beh

  PROCESS
    FILE     file_pointer : TEXT;
    VARIABLE line_read    : LINE;
    VARIABLE line_content : STRING(1 TO 4);
    VARIABLE line_write   : LINE;
    VARIABLE line_content_write : STRING(1 TO NB_CHAR_PER_DATA);
    VARIABLE line_content_write_inv : STRING(1 TO NB_CHAR_PER_DATA);
    VARIABLE char_read    : CHARACTER;
    VARIABLE data_read    : STD_LOGIC_VECTOR(15 DOWNTO 0);
    VARIABLE signal_part  : STD_LOGIC_VECTOR(3 DOWNTO 0);

  BEGIN  -- PROCESS
    
    WAIT UNTIL clk = '1';
    
    file_open(file_pointer , OUTPUT_FILE_NAME , WRITE_MODE);
    WHILE close_file = '0' LOOP
      IF data_in_val = '1' THEN
        FOR i IN 1 TO NB_CHAR_PER_DATA LOOP
          signal_part := data(i*4-1 DOWNTO (i-1)*4);
          CASE signal_part IS
            WHEN "0000" => line_content_write(NB_CHAR_PER_DATA+1-i) := '0';
            WHEN "0001" => line_content_write(NB_CHAR_PER_DATA+1-i) := '1';
            WHEN "0010" => line_content_write(NB_CHAR_PER_DATA+1-i) := '2';
            WHEN "0011" => line_content_write(NB_CHAR_PER_DATA+1-i) := '3';
            WHEN "0100" => line_content_write(NB_CHAR_PER_DATA+1-i) := '4';
            WHEN "0101" => line_content_write(NB_CHAR_PER_DATA+1-i) := '5';
            WHEN "0110" => line_content_write(NB_CHAR_PER_DATA+1-i) := '6';
            WHEN "0111" => line_content_write(NB_CHAR_PER_DATA+1-i) := '7';
            WHEN "1000" => line_content_write(NB_CHAR_PER_DATA+1-i) := '8';
            WHEN "1001" => line_content_write(NB_CHAR_PER_DATA+1-i) := '9';
            WHEN "1010" => line_content_write(NB_CHAR_PER_DATA+1-i) := 'a';
            WHEN "1011" => line_content_write(NB_CHAR_PER_DATA+1-i) := 'b';
            WHEN "1100" => line_content_write(NB_CHAR_PER_DATA+1-i) := 'c';
            WHEN "1101" => line_content_write(NB_CHAR_PER_DATA+1-i) := 'd';
            WHEN "1110" => line_content_write(NB_CHAR_PER_DATA+1-i) := 'e';
            WHEN "1111" => line_content_write(NB_CHAR_PER_DATA+1-i) := 'f';
            WHEN OTHERS => NULL;
          END CASE;
        END LOOP;  -- i        
        write(line_write,line_content_write);
        writeline(file_pointer,line_write);
      END IF;
      WAIT UNTIL clk = '1';
    END LOOP;
    file_close(file_pointer);
    WAIT;    
  END PROCESS;

END beh;
