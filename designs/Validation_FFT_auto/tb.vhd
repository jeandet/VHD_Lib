
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.MATH_REAL.ALL;
USE ieee.numeric_std.ALL;

LIBRARY std;
use std.textio.all;

LIBRARY lpp;
USE lpp.cic_pkg.ALL;
USE lpp.chirp_pkg.ALL;
USE lpp.lpp_fft.ALL;
USE lpp.lpp_lfr_pkg.ALL;

ENTITY testbench IS
  GENERIC (
    input_file_name  : STRING := "input_data_2.txt";
    output_file_name : STRING := "output_data.txt");
END;

ARCHITECTURE behav OF testbench IS

  SIGNAL clk            : STD_LOGIC := '0';
  SIGNAL rstn           : STD_LOGIC;

  -- IN
  SIGNAL sample_valid   : STD_LOGIC;
  SIGNAL fft_read       : STD_LOGIC;
  SIGNAL sample_data    : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL sample_load    : STD_LOGIC;
  -- OUT
  SIGNAL fft_pong       : STD_LOGIC;
  SIGNAL fft_data_im    : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL fft_data_re    : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL fft_data_valid : STD_LOGIC;
  SIGNAL fft_ready      : STD_LOGIC;
  SIGNAL fft_component_number : INTEGER;

  SIGNAL end_of_sim : STD_LOGIC := '0';

BEGIN

  clk <= NOT clk AFTER 5 ns;

  PROCESS
    FILE     file_pointer : TEXT;
    VARIABLE line_read    : LINE;
    VARIABLE line_content : STRING(1 TO 4);
    VARIABLE line_write   : LINE;
    VARIABLE line_content_write : STRING(1 TO 8);
    VARIABLE char_read    : CHARACTER;
    VARIABLE data_read    : STD_LOGIC_VECTOR(15 DOWNTO 0);
    VARIABLE signal_part  : STD_LOGIC_VECTOR(3 DOWNTO 0);

  BEGIN  -- PROCESS
    WAIT UNTIL clk = '1';
    rstn <= '0';
    fft_read <= '0';
    sample_valid <= '0';
    fft_component_number <= 0;
    WAIT UNTIL clk = '1';
    rstn <= '1';
    WAIT UNTIL clk = '1';
    WAIT UNTIL clk = '1';
    WAIT UNTIL clk = '1';
    WAIT UNTIL clk = '1';

    WHILE sample_load = '0' LOOP
      WAIT UNTIL clk = '1';
    END LOOP;
    WAIT UNTIL clk = '1';
    
    file_open(file_pointer,input_file_name,READ_MODE);
    WHILE NOT endfile(file_pointer) LOOP
      readline(file_pointer, line_read);
      read(line_read,line_content);
      FOR i IN 1 TO 4 LOOP
        char_read := line_content(5-i);
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
      sample_data  <= data_read;
      sample_valid <= '1';
      WAIT UNTIL clk = '1';     
    END LOOP;
    file_close(file_pointer);
    sample_valid <= '0';
    WAIT UNTIL clk = '1';
    WAIT UNTIL clk = '1';
    WHILE fft_ready = '0' LOOP
      WAIT UNTIL clk = '1';
    END LOOP;
    WAIT UNTIL clk = '1';
    

    file_open(file_pointer,output_file_name,WRITE_MODE);
    WHILE fft_ready = '1' LOOP
      IF fft_data_valid = '1' THEN
        FOR j IN 0 TO 1 LOOP
          FOR i IN 1 TO 4 LOOP
            IF j = 0 THEN
              signal_part := fft_data_im(i*4-1 DOWNTO (i-1)*4);
            ELSE
              signal_part := fft_data_re(i*4-1 DOWNTO (i-1)*4);
            END IF;
            CASE signal_part IS
              WHEN "0000" => line_content(i) := '0';
              WHEN "0001" => line_content(i) := '1';
              WHEN "0010" => line_content(i) := '2';
              WHEN "0011" => line_content(i) := '3';
              WHEN "0100" => line_content(i) := '4';
              WHEN "0101" => line_content(i) := '5';
              WHEN "0110" => line_content(i) := '6';
              WHEN "0111" => line_content(i) := '7';
              WHEN "1000" => line_content(i) := '8';
              WHEN "1001" => line_content(i) := '9';
              WHEN "1010" => line_content(i) := 'a';
              WHEN "1011" => line_content(i) := 'b';
              WHEN "1100" => line_content(i) := 'c';
              WHEN "1101" => line_content(i) := 'd';
              WHEN "1110" => line_content(i) := 'e';
              WHEN "1111" => line_content(i) := 'f';
              WHEN OTHERS => NULL;
            END CASE;
          END LOOP;  -- i
          line_content_write(j*4+1) := line_content(4);
          line_content_write(j*4+2) := line_content(3);
          line_content_write(j*4+3) := line_content(2);
          line_content_write(j*4+4) := line_content(1);
        END LOOP;  -- j
        write(line_write,line_content_write);
        writeline(file_pointer,line_write);
        fft_component_number <= fft_component_number + 1;
      END IF;
      fft_read <= '1';
      WAIT UNTIL clk = '1';
    END LOOP;
    file_close(file_pointer);
    
    fft_read <= '0';
    WAIT UNTIL clk = '1';

    
    WAIT FOR 1 us;
    end_of_sim <= '1';
    WAIT FOR 100 ns;
    REPORT "*** END simulation ***" SEVERITY failure;
    WAIT;    
  END PROCESS;
  -----------------------------------------------------------------------------
  
  lpp_lfr_ms_FFT_1 : lpp_lfr_ms_FFT
    PORT MAP (
      clk            => clk,
      rstn           => rstn,
      -- IN
      sample_valid   => sample_valid,   -- in
      fft_read       => fft_read,       -- in 
      sample_data    => sample_data,    -- in
      sample_load    => sample_load,    -- out
      -- OUT
      fft_pong       => fft_pong,       -- out
      fft_data_im    => fft_data_im,    -- out
      fft_data_re    => fft_data_re,    -- out
      fft_data_valid => fft_data_valid, -- out
      fft_ready      => fft_ready);     -- out
  
END;
