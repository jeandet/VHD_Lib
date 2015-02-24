
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.MATH_REAL.ALL;
USE ieee.numeric_std.ALL;

LIBRARY std;
USE std.textio.ALL;

LIBRARY lpp;
USE lpp.cic_pkg.ALL;
USE lpp.chirp_pkg.ALL;
USE lpp.lpp_fft.ALL;
USE lpp.lpp_lfr_pkg.ALL;
USE lpp.iir_filter.ALL;

ENTITY testbench IS
  GENERIC (
    input_file_name_f0  : STRING := "input_data_f0.txt";
    input_file_name_f1  : STRING := "input_data_f1.txt";
    input_file_name_f2  : STRING := "input_data_f2.txt";
    output_file_name_f0 : STRING := "output_data_f0.txt";
    output_file_name_f1 : STRING := "output_data_f1.txt";
    output_file_name_f2 : STRING := "output_data_f2.txt");
END;

ARCHITECTURE behav OF testbench IS

  COMPONENT data_read_with_timer
    GENERIC (
      input_file_name  : STRING;
      NB_CHAR_PER_DATA : INTEGER;
      NB_CYCLE_TIMER   : INTEGER);
    PORT (
      clk          : IN  STD_LOGIC;
      rstn         : IN  STD_LOGIC;
      end_of_file  : OUT STD_LOGIC;
      data_out_val : OUT STD_LOGIC;
      data_out     : OUT STD_LOGIC_VECTOR(NB_CHAR_PER_DATA * 4 - 1 DOWNTO 0));
  END COMPONENT;

  COMPONENT data_write_with_burstCounter
    GENERIC (
      OUTPUT_FILE_NAME : STRING;
      NB_CHAR_PER_DATA : INTEGER;
      BASE_ADDR        : STD_LOGIC_VECTOR(31 DOWNTO 0));
    PORT (
      clk         : IN  STD_LOGIC;
      rstn        : IN  STD_LOGIC;
      burst_valid : IN  STD_LOGIC;
      burst_addr  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      data_ren    : OUT STD_LOGIC;
      data        : IN  STD_LOGIC_VECTOR(NB_CHAR_PER_DATA * 4 - 1 DOWNTO 0);
      close_file  : IN  STD_LOGIC);
  END COMPONENT;
  
  SIGNAL clk  : STD_LOGIC := '0';
  SIGNAL rstn : STD_LOGIC;

  SIGNAL start : STD_LOGIC;

  -- IN
  SIGNAL sample_valid         : STD_LOGIC;
  SIGNAL fft_read             : STD_LOGIC;
  SIGNAL sample_data          : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL sample_load          : STD_LOGIC;
  -- OUT
  SIGNAL fft_pong             : STD_LOGIC;
  SIGNAL fft_data_im          : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL fft_data_re          : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL fft_data_valid       : STD_LOGIC;
  SIGNAL fft_ready            : STD_LOGIC;
  SIGNAL fft_component_number : INTEGER;

  SIGNAL end_of_sim : STD_LOGIC := '0';

  -----------------------------------------------------------------------------
  -- DATA GEN
  -----------------------------------------------------------------------------
  CONSTANT NB_CYCLE_f0 : INTEGER := 1017;   --   25MHz / 24576Hz
  CONSTANT NB_CYCLE_f1 : INTEGER := 6103;   --   25MHz / 4096Hz
  CONSTANT NB_CYCLE_f2 : INTEGER := 97656;  --   25MHz / 256Hz

  SIGNAL data_counter_f0 : INTEGER;
  SIGNAL data_counter_f1 : INTEGER;
  SIGNAL data_counter_f2 : INTEGER;

  SIGNAL sample_f0_wen : STD_LOGIC;
  SIGNAL sample_f1_wen : STD_LOGIC;
  SIGNAL sample_f2_wen : STD_LOGIC;

  SIGNAL sample_f0_wen_v : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f1_wen_v : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f2_wen_v : STD_LOGIC_VECTOR(4 DOWNTO 0);

  SIGNAL sample_f0_wdata : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
  SIGNAL sample_f1_wdata : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
  SIGNAL sample_f2_wdata : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);

  -----------------------------------------------------------------------------
  -- TIME
  -----------------------------------------------------------------------------
  SIGNAL start_date   : STD_LOGIC_VECTOR(30 DOWNTO 0);
  SIGNAL coarse_time  : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL fine_time    : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL time_counter : INTEGER;

  SIGNAL new_fine_time     : STD_LOGIC := '0';
  SIGNAL new_fine_time_reg : STD_LOGIC := '0';

  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  SIGNAL end_of_file  : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL data_out_val : STD_LOGIC_VECTOR(2 DOWNTO 0);

  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  SIGNAL dma_fifo_burst_valid   : STD_LOGIC;                      --TODO
  SIGNAL dma_fifo_data          : STD_LOGIC_VECTOR(31 DOWNTO 0);  --TODO
  SIGNAL dma_fifo_ren           : STD_LOGIC;                      --TODO
  SIGNAL dma_fifo_ren_f0        : STD_LOGIC;                      --TODO
  SIGNAL dma_fifo_ren_f1        : STD_LOGIC;                      --TODO
  SIGNAL dma_fifo_ren_f2        : STD_LOGIC;                      --TODO
  SIGNAL dma_buffer_new         : STD_LOGIC;                      --TODOx
  SIGNAL dma_buffer_addr        : STD_LOGIC_VECTOR(31 DOWNTO 0);  --TODO
  SIGNAL dma_buffer_length      : STD_LOGIC_VECTOR(25 DOWNTO 0);  --TODO
  SIGNAL dma_buffer_full        : STD_LOGIC;                      --TODO
  SIGNAL dma_buffer_full_err    : STD_LOGIC;                      --TODO
  SIGNAL ready_matrix_f0        : STD_LOGIC;                      -- TODO
  SIGNAL ready_matrix_f1        : STD_LOGIC;                      -- TODO
  SIGNAL ready_matrix_f2        : STD_LOGIC;                      -- TODO
  SIGNAL status_ready_matrix_f0 : STD_LOGIC;                      -- TODO
  SIGNAL status_ready_matrix_f1 : STD_LOGIC;                      -- TODO
  SIGNAL status_ready_matrix_f2 : STD_LOGIC;                      -- TODO
  SIGNAL addr_matrix_f0         : STD_LOGIC_VECTOR(31 DOWNTO 0);  -- TODO
  SIGNAL addr_matrix_f1         : STD_LOGIC_VECTOR(31 DOWNTO 0);  -- TODO
  SIGNAL addr_matrix_f2         : STD_LOGIC_VECTOR(31 DOWNTO 0);  -- TODO
  SIGNAL length_matrix_f0       : STD_LOGIC_VECTOR(25 DOWNTO 0);  -- TODO
  SIGNAL length_matrix_f1       : STD_LOGIC_VECTOR(25 DOWNTO 0);  -- TODO
  SIGNAL length_matrix_f2       : STD_LOGIC_VECTOR(25 DOWNTO 0);  -- TODO
  SIGNAL matrix_time_f0         : STD_LOGIC_VECTOR(47 DOWNTO 0);  -- TODO
  SIGNAL matrix_time_f1         : STD_LOGIC_VECTOR(47 DOWNTO 0);  -- TODO
  SIGNAL matrix_time_f2         : STD_LOGIC_VECTOR(47 DOWNTO 0);  -- TODO
  -----------------------------------------------------------------------------
  SIGNAL dma_ren_counter : INTEGER;
  SIGNAL dma_output_counter : INTEGER;
  -----------------------------------------------------------------------------
  CONSTANT BASE_ADDR_F0 : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"01000000"; 
  CONSTANT BASE_ADDR_F1 : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"10000000"; 
  CONSTANT BASE_ADDR_F2 : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"11000000";
  -----------------------------------------------------------------------------
  SIGNAL close_file : STD_LOGIC := '0';
  
BEGIN

  -----------------------------------------------------------------------------

  clk           <= NOT clk           AFTER 20 ns;
  new_fine_time <= NOT new_fine_time AFTER 15258 ns;

  PROCESS
  BEGIN  -- PROCESS
    WAIT UNTIL clk = '1';
    close_file <= '0';
    rstn  <= '0';
    start <= '0';
    WAIT UNTIL clk = '1';
    rstn  <= '1';
    WAIT UNTIL clk = '1';
    WAIT UNTIL clk = '1';
    WAIT UNTIL clk = '1';
    WAIT UNTIL clk = '1';
    start <= '1';
    WHILE NOT (end_of_file = "111") LOOP
      WAIT UNTIL clk = '1';
    END LOOP;
    REPORT "*** END READ FILE  ***";-- SEVERITY failure;
    WAIT FOR 3 ms;
    close_file <= '1';
    WAIT UNTIL clk = '1';
    WAIT UNTIL clk = '1';
    WAIT UNTIL clk = '1';
    end_of_sim <= '1';
    WAIT FOR 100 ns;
    REPORT "*** END SIMULATION ***" SEVERITY failure;
    WAIT;
  END PROCESS;

  -----------------------------------------------------------------------------
  -- TIME
  -----------------------------------------------------------------------------
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      start_date        <= X"0000000" & "001";
      coarse_time       <= (OTHERS => '0');
      fine_time         <= (OTHERS => '0');
      time_counter      <= 0;
      new_fine_time_reg <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
      new_fine_time_reg <= new_fine_time;
      IF start = '1' THEN
        IF coarse_time(30 downto 0) = X"0000000" & "000" THEN
          coarse_time(30 downto 0) <= start_date;
        ELSE
          IF new_fine_time = NOT new_fine_time_reg THEN
            IF fine_time = X"FFFF" THEN
              coarse_time <= STD_LOGIC_VECTOR(UNSIGNED(coarse_time) + 1);
              fine_time   <= (OTHERS => '0');
            ELSE
              fine_time <= STD_LOGIC_VECTOR(UNSIGNED(fine_time) + 1);
            END IF;
          END IF;
        END IF;
      END IF;
    END IF;
  END PROCESS;

  -----------------------------------------------------------------------------
  -- DATA IN
  -----------------------------------------------------------------------------
  data_read_with_timer_f0 : data_read_with_timer
    GENERIC MAP (input_file_name_f0, 4*5, NB_CYCLE_f0)
    PORT MAP (clk, rstn, end_of_file(0), data_out_val(0), sample_f0_wdata(16*5-1 downto 0));
  sample_f0_wen <= NOT data_out_val(0);
    
  data_read_with_timer_f1 : data_read_with_timer
    GENERIC MAP (input_file_name_f1, 4*5, NB_CYCLE_f1)
    PORT MAP (clk, rstn, end_of_file(1), data_out_val(1), sample_f1_wdata(16*5-1 downto 0));
  sample_f1_wen <= NOT data_out_val(1);

  data_read_with_timer_f2 : data_read_with_timer
    GENERIC MAP (input_file_name_f2, 4*5, NB_CYCLE_f2)
    PORT MAP (clk, rstn, end_of_file(2), data_out_val(2), sample_f2_wdata(16*5-1 downto 0));
  sample_f2_wen <= NOT data_out_val(2);

  -----------------------------------------------------------------------------
  -- DATA OUT 
  -----------------------------------------------------------------------------
  --dma_fifo_burst_valid  -- in
  --dma_fifo_data         -- in
  --dma_fifo_ren          -- OUT
  --dma_fifo_ren <= '0';

  --PROCESS (clk, rstn)
  --BEGIN  -- PROCESS
  --  IF rstn = '0' THEN                  -- asynchronous reset (active low)
  --    dma_ren_counter <= 0;
  --    dma_fifo_ren <= '1';
  --  ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
  --    dma_fifo_ren <= '1';
  --    IF dma_ren_counter = 0 AND dma_fifo_burst_valid = '1' THEN
  --      dma_ren_counter <= 16;
  --    END IF;
  --    IF dma_ren_counter > 0 THEN
  --      dma_ren_counter <= dma_ren_counter - 1;
  --      dma_fifo_ren <= '0';
  --    END IF;
      
  --  END IF;
  --END PROCESS;
  
  data_write_with_burstCounter_0: data_write_with_burstCounter
    GENERIC MAP (
      OUTPUT_FILE_NAME => output_file_name_f0,
      NB_CHAR_PER_DATA => 32/4,
      BASE_ADDR        => BASE_ADDR_F0)
    PORT MAP (
      clk         => clk,
      rstn        => rstn,
      burst_addr  => dma_buffer_addr,
      burst_valid => dma_fifo_burst_valid,
      data_ren    => dma_fifo_ren_f0,
      data        => dma_fifo_data,
      close_file  => close_file);
  
  data_write_with_burstCounter_1: data_write_with_burstCounter
    GENERIC MAP (
      OUTPUT_FILE_NAME => output_file_name_f1,
      NB_CHAR_PER_DATA => 32/4,
      BASE_ADDR        => BASE_ADDR_F1)
    PORT MAP (
      clk         => clk,
      rstn        => rstn,
      burst_addr  => dma_buffer_addr,
      burst_valid => dma_fifo_burst_valid,
      data_ren    => dma_fifo_ren_f1,
      data        => dma_fifo_data,
      close_file  => close_file);
  
  data_write_with_burstCounter_2: data_write_with_burstCounter
    GENERIC MAP (
      OUTPUT_FILE_NAME => output_file_name_f2,
      NB_CHAR_PER_DATA => 32/4,
      BASE_ADDR        => BASE_ADDR_F2)
    PORT MAP (
      clk         => clk,
      rstn        => rstn,
      burst_addr  => dma_buffer_addr,
      burst_valid => dma_fifo_burst_valid,
      data_ren    => dma_fifo_ren_f2,
      data        => dma_fifo_data,
      close_file  => close_file);
  
  dma_fifo_ren <= dma_fifo_ren_f0 AND dma_fifo_ren_f1 AND dma_fifo_ren_f2;
  
  
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      dma_buffer_full     <= '0';
      dma_buffer_full_err <= '0';
      dma_output_counter  <=  0;
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      dma_buffer_full <= '0';
      
      IF dma_buffer_new = '1' THEN
        dma_output_counter <= to_integer(UNSIGNED(dma_buffer_length));
      END IF;
      
      IF dma_fifo_ren = '0' THEN
        IF dma_output_counter = 1 THEN
          dma_buffer_full    <= '1';
          dma_output_counter <= 0;
        ELSE
          dma_output_counter <= dma_output_counter - 1;
        END IF;
      END IF;
      
    END IF;
  END PROCESS;
  
  --dma_buffer_new        -- in
  --dma_buffer_addr       -- in
  --dma_buffer_length     -- in
  --dma_buffer_full       -- out
  --dma_buffer_full_err   -- OUT
--  dma_buffer_full     <= '0';
--  dma_buffer_full_err <= '0';
  
  -----------------------------------------------------------------------------
  -- BUFFER CONFIGURATION and INFORMATION
  -----------------------------------------------------------------------------
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      status_ready_matrix_f0 <= '0';
      status_ready_matrix_f1 <= '0';
      status_ready_matrix_f2 <= '0';
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      status_ready_matrix_f0 <= ready_matrix_f0;
      status_ready_matrix_f1 <= ready_matrix_f1;
      status_ready_matrix_f2 <= ready_matrix_f2;      
    END IF;
  END PROCESS;
  
  addr_matrix_f0 <= BASE_ADDR_F0;
  addr_matrix_f1 <= BASE_ADDR_F1;
  addr_matrix_f2 <= BASE_ADDR_F2;

  length_matrix_f0 <= "00" & X"000C80";
  length_matrix_f1 <= "00" & X"000C80";
  length_matrix_f2 <= "00" & X"000C80";
  
  sample_f0_wen_v <= sample_f0_wen & sample_f0_wen & sample_f0_wen & sample_f0_wen & sample_f0_wen;
  sample_f1_wen_v <= sample_f1_wen & sample_f1_wen & sample_f1_wen & sample_f1_wen & sample_f1_wen;
  sample_f2_wen_v <= sample_f2_wen & sample_f2_wen & sample_f2_wen & sample_f2_wen & sample_f2_wen;

  -----------------------------------------------------------------------------
  -- DUT
  -----------------------------------------------------------------------------
  lpp_lfr_ms_1 : lpp_lfr_ms
    GENERIC MAP (
      Mem_use => use_RAM)
    PORT MAP (
      clk  => clk,
      rstn => rstn,
      run  => '1',

      -----------------------------------------------------------------------------
      -- TIME
      -----------------------------------------------------------------------------
      start_date  => start_date,
      coarse_time => coarse_time,
      fine_time   => fine_time,

      -------------------------------------------------------------------------
      -- DATA IN
      -------------------------------------------------------------------------
      sample_f0_wen   => sample_f0_wen_v,  -- 
      sample_f0_wdata => sample_f0_wdata,
      sample_f1_wen   => sample_f1_wen_v,
      sample_f1_wdata => sample_f1_wdata,
      sample_f2_wen   => sample_f2_wen_v,
      sample_f2_wdata => sample_f2_wdata,

      -------------------------------------------------------------------------
      -- DMA OUT
      -------------------------------------------------------------------------
      dma_fifo_burst_valid => dma_fifo_burst_valid,  --out
      dma_fifo_data        => dma_fifo_data,         --out
      dma_fifo_ren         => dma_fifo_ren,          --in
      dma_buffer_new       => dma_buffer_new,        --out
      dma_buffer_addr      => dma_buffer_addr,       --out
      dma_buffer_length    => dma_buffer_length,     --out
      dma_buffer_full      => dma_buffer_full,       --in
      dma_buffer_full_err  => dma_buffer_full_err,   --in

      -------------------------------------------------------------------------
      -- BUFFER CONFIGURATION and INFORMATION
      -------------------------------------------------------------------------
      ready_matrix_f0 => ready_matrix_f0,  --out
      ready_matrix_f1 => ready_matrix_f1,  --out
      ready_matrix_f2 => ready_matrix_f2,  --out        

      error_buffer_full      => OPEN,
      error_input_fifo_write => OPEN,

      status_ready_matrix_f0 => status_ready_matrix_f0,  --in
      status_ready_matrix_f1 => status_ready_matrix_f1,  --in
      status_ready_matrix_f2 => status_ready_matrix_f2,  --in

      addr_matrix_f0 => addr_matrix_f0,  --in
      addr_matrix_f1 => addr_matrix_f1,  --in
      addr_matrix_f2 => addr_matrix_f2,  --in

      length_matrix_f0 => length_matrix_f0,  --in
      length_matrix_f1 => length_matrix_f1,  --in
      length_matrix_f2 => length_matrix_f2,  --in

      matrix_time_f0 => matrix_time_f0,  --out
      matrix_time_f1 => matrix_time_f1,  --out
      matrix_time_f2 => matrix_time_f2,  --out

      debug_vector => OPEN);
  
END;
