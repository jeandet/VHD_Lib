LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


LIBRARY lpp;
USE lpp.lpp_memory.ALL;
USE lpp.iir_filter.ALL;
USE lpp.spectral_matrix_package.ALL;

use lpp.lpp_fft.all;
use lpp.fft_components.all;

ENTITY lpp_lfr_ms IS
  GENERIC (
    Mem_use : INTEGER := use_RAM
    );
  PORT (
    clk  : IN STD_LOGIC;
    rstn : IN STD_LOGIC;

    ---------------------------------------------------------------------------
    -- DATA INPUT
    ---------------------------------------------------------------------------
    -- TIME
    coarse_time     : IN STD_LOGIC_VECTOR(31 DOWNTO 0);  -- todo
    fine_time       : IN STD_LOGIC_VECTOR(15 DOWNTO 0);  -- todo
    --
    sample_f0_wen   : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    sample_f0_wdata : IN STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
    --
    sample_f1_wen   : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    sample_f1_wdata : IN STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
    --
    sample_f2_wen   : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    sample_f2_wdata : IN STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);

    ---------------------------------------------------------------------------
    -- DMA
    ---------------------------------------------------------------------------
    dma_addr        : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    dma_data        : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    dma_valid       : OUT STD_LOGIC;
    dma_valid_burst : OUT STD_LOGIC;
    dma_ren         : IN  STD_LOGIC;
    dma_done        : IN  STD_LOGIC;

    -- Reg out
    ready_matrix_f0_0             : OUT STD_LOGIC;
    ready_matrix_f0_1             : OUT STD_LOGIC;
    ready_matrix_f1               : OUT STD_LOGIC;
    ready_matrix_f2               : OUT STD_LOGIC;
    error_anticipating_empty_fifo : OUT STD_LOGIC;
    error_bad_component_error     : OUT STD_LOGIC;
    debug_reg                     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

    -- Reg In
    status_ready_matrix_f0_0             : IN STD_LOGIC;
    status_ready_matrix_f0_1             : IN STD_LOGIC;
    status_ready_matrix_f1               : IN STD_LOGIC;
    status_ready_matrix_f2               : IN STD_LOGIC;
    status_error_anticipating_empty_fifo : IN STD_LOGIC;
    status_error_bad_component_error     : IN STD_LOGIC;

    config_active_interruption_onNewMatrix : IN STD_LOGIC;
    config_active_interruption_onError     : IN STD_LOGIC;
    addr_matrix_f0_0                       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_matrix_f0_1                       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_matrix_f1                         : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_matrix_f2                         : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

    matrix_time_f0_0 : OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
    matrix_time_f0_1 : OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
    matrix_time_f1   : OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
    matrix_time_f2   : OUT STD_LOGIC_VECTOR(47 DOWNTO 0)

    );
END;

ARCHITECTURE Behavioral OF lpp_lfr_ms IS

  SIGNAL sample_f0_A_rdata : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
  SIGNAL sample_f0_A_ren   : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f0_A_wen   : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f0_A_full  : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f0_A_empty : STD_LOGIC_VECTOR(4 DOWNTO 0);

  SIGNAL sample_f0_B_rdata : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
  SIGNAL sample_f0_B_ren   : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f0_B_wen   : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f0_B_full  : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f0_B_empty : STD_LOGIC_VECTOR(4 DOWNTO 0);

  SIGNAL sample_f1_rdata : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
  SIGNAL sample_f1_ren   : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f1_full  : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f1_empty : STD_LOGIC_VECTOR(4 DOWNTO 0);
  
  SIGNAL sample_f1_almost_full : STD_LOGIC_VECTOR(4 DOWNTO 0);

  SIGNAL sample_f2_rdata : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
  SIGNAL sample_f2_ren   : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f2_full  : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f2_empty : STD_LOGIC_VECTOR(4 DOWNTO 0);

  SIGNAL error_wen_f0 : STD_LOGIC;
  SIGNAL error_wen_f1 : STD_LOGIC;
  SIGNAL error_wen_f2 : STD_LOGIC;
  
  SIGNAL one_sample_f1_full : STD_LOGIC;
  SIGNAL one_sample_f1_wen  : STD_LOGIC;
  SIGNAL one_sample_f2_full : STD_LOGIC;
  SIGNAL one_sample_f2_wen  : STD_LOGIC;
  
  -----------------------------------------------------------------------------
  -- FSM / SWITCH SELECT CHANNEL
  -----------------------------------------------------------------------------
  TYPE   fsm_select_channel IS (IDLE, SWITCH_F0_A, SWITCH_F0_B, SWITCH_F1, SWITCH_F2);
  SIGNAL state_fsm_select_channel : fsm_select_channel;

  SIGNAL sample_rdata : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
  SIGNAL sample_ren   : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_full  : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_empty : STD_LOGIC_VECTOR(4 DOWNTO 0);

  -----------------------------------------------------------------------------
  -- FSM LOAD FFT
  -----------------------------------------------------------------------------
  TYPE fsm_load_FFT IS (IDLE, FIFO_1, FIFO_2, FIFO_3, FIFO_4, FIFO_5, FIFO_transition);
  SIGNAL state_fsm_load_FFT : fsm_load_FFT;
  SIGNAL next_state_fsm_load_FFT : fsm_load_FFT;

  SIGNAL sample_ren_s : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_load  : STD_LOGIC;
  SIGNAL sample_valid : STD_LOGIC;
  SIGNAL sample_valid_r : STD_LOGIC;
  SIGNAL sample_data  : STD_LOGIC_VECTOR(15 DOWNTO 0);
 

  -----------------------------------------------------------------------------
  -- FFT
  -----------------------------------------------------------------------------
  SIGNAL fft_read       : STD_LOGIC;
  SIGNAL fft_pong       : STD_LOGIC;
  SIGNAL fft_data_im    : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL fft_data_re    : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL fft_data_valid : STD_LOGIC;
  SIGNAL fft_ready      : STD_LOGIC;
  
BEGIN

  switch_f0_inst : spectral_matrix_switch_f0
    PORT MAP (
      clk  => clk,
      rstn => rstn,

      sample_wen => sample_f0_wen,

      fifo_A_empty => sample_f0_A_empty,
      fifo_A_full  => sample_f0_A_full,
      fifo_A_wen   => sample_f0_A_wen,

      fifo_B_empty => sample_f0_B_empty,
      fifo_B_full  => sample_f0_B_full,
      fifo_B_wen   => sample_f0_B_wen,

      error_wen => error_wen_f0);          -- TODO

  -----------------------------------------------------------------------------
  -- FIFO IN
  -----------------------------------------------------------------------------
  lppFIFOxN_f0_a : lppFIFOxN
    GENERIC MAP (
      tech         => 0,
      Mem_use      => Mem_use,
      Data_sz      => 16,
      Addr_sz      => 8,
      FifoCnt      => 5,
      Enable_ReUse => '0')
    PORT MAP (
      rstn  => rstn,
      wclk  => clk,
      rclk  => clk,
      ReUse => (OTHERS => '0'),

      wen   => sample_f0_A_wen,         --      IN  in
      ren   => sample_f0_A_ren,         -- OUT in
      wdata => sample_f0_wdata,         --      IN  in
      rdata => sample_f0_A_rdata,       -- OUT in
      full  => sample_f0_A_full,        --      IN  out
      almost_full => OPEN,  --      IN  out
      empty => sample_f0_A_empty);      --      OUT OUT

  lppFIFOxN_f0_b : lppFIFOxN
    GENERIC MAP (
      tech         => 0,
      Mem_use      => Mem_use,
      Data_sz      => 16,
      Addr_sz      => 8,
      FifoCnt      => 5,
      Enable_ReUse => '0')
    PORT MAP (
      rstn  => rstn,
      wclk  => clk,
      rclk  => clk,
      ReUse => (OTHERS => '0'),

      wen   => sample_f0_B_wen,         --      IN  in
      ren   => sample_f0_B_ren,         -- OUT in
      wdata => sample_f0_wdata,         --      IN  in
      rdata => sample_f0_B_rdata,       -- OUT in
      full  => sample_f0_B_full,        --      IN  out
      almost_full => OPEN,  --      IN  out
      empty => sample_f0_B_empty);      --      OUT OUT

  lppFIFOxN_f1 : lppFIFOxN
    GENERIC MAP (
      tech         => 0,
      Mem_use      => Mem_use,
      Data_sz      => 16,
      Addr_sz      => 8,
      FifoCnt      => 5,
      Enable_ReUse => '0')
    PORT MAP (
      rstn  => rstn,
      wclk  => clk,
      rclk  => clk,
      ReUse => (OTHERS => '0'),

      wen         => sample_f1_wen,          --      IN  in
      ren         => sample_f1_ren,          -- OUT in
      wdata       => sample_f1_wdata,        --      IN  in
      rdata       => sample_f1_rdata,        --  OUT in
      full        => sample_f1_full,         --      IN  out
      almost_full => sample_f1_almost_full,  --      IN  out
      empty       => sample_f1_empty);       --      OUT OUT


  one_sample_f1_wen <= '0' WHEN  sample_f1_wen  = "11111" ELSE '1';

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
       one_sample_f1_full <= '0';
       error_wen_f1 <= '0';
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      IF sample_f1_full = "00000" THEN
        one_sample_f1_full <= '0';
      ELSE
        one_sample_f1_full <= '1';
      END IF;
      error_wen_f1 <= one_sample_f1_wen AND one_sample_f1_full;
    END IF;
  END PROCESS;
  

  lppFIFOxN_f2 : lppFIFOxN
    GENERIC MAP (
      tech         => 0,
      Mem_use      => Mem_use,
      Data_sz      => 16,
      Addr_sz      => 8,
      FifoCnt      => 5,
      Enable_ReUse => '0')
    PORT MAP (
      rstn  => rstn,
      wclk  => clk,
      rclk  => clk,
      ReUse => (OTHERS => '0'),

      wen   => sample_f2_wen,           --      IN  in
      ren   => sample_f2_ren,           -- OUT in
      wdata => sample_f2_wdata,         --      IN  in
      rdata => sample_f2_rdata,         -- OUT in
      full  => sample_f2_full,          --      IN  out
      almost_full => OPEN,  --      IN  out
      empty => sample_f2_empty);        --      OUT OUT


  one_sample_f2_wen <= '0' WHEN  sample_f2_wen  = "11111" ELSE '1';
  
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
       one_sample_f2_full <= '0';
       error_wen_f2 <= '0';
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      IF sample_f2_full = "00000" THEN
        one_sample_f2_full <= '0';
      ELSE
        one_sample_f2_full <= '1';
      END IF;
      error_wen_f2 <= one_sample_f2_wen AND one_sample_f2_full;
    END IF;
  END PROCESS;

  -----------------------------------------------------------------------------
  -- FSM SELECT CHANNEL
  -----------------------------------------------------------------------------
  PROCESS (clk, rstn)
  BEGIN
    IF rstn = '0' THEN
      state_fsm_select_channel <= IDLE;
    ELSIF clk'EVENT AND clk = '1' THEN
      CASE state_fsm_select_channel IS
        WHEN IDLE =>
          IF sample_f1_full = "11111" THEN
            state_fsm_select_channel <= SWITCH_F1;
          ELSIF sample_f1_almost_full = "00000" THEN
            IF sample_f0_A_full = "11111" THEN
              state_fsm_select_channel <= SWITCH_F0_A;
            ELSIF sample_f0_B_full = "11111" THEN
              state_fsm_select_channel <= SWITCH_F0_B;
            ELSIF sample_f2_full = "11111" THEN
              state_fsm_select_channel <= SWITCH_F2;
            END IF;
          END IF;
          
        WHEN SWITCH_F0_A =>
          IF sample_f0_A_empty = "11111" THEN
            state_fsm_select_channel <= IDLE;
          END IF;
        WHEN SWITCH_F0_B =>
          IF sample_f0_B_empty = "11111" THEN
            state_fsm_select_channel <= IDLE;
          END IF;
        WHEN SWITCH_F1 =>
          IF sample_f1_empty = "11111" THEN
            state_fsm_select_channel <= IDLE;
          END IF;
        WHEN SWITCH_F2 =>
          IF sample_f2_empty = "11111" THEN
            state_fsm_select_channel <= IDLE;
          END IF;
        WHEN OTHERS => NULL;
      END CASE;
      
    END IF;
  END PROCESS;



  -----------------------------------------------------------------------------
  -- SWITCH SELECT CHANNEL
  -----------------------------------------------------------------------------
  sample_empty <= sample_f0_A_empty WHEN state_fsm_select_channel = SWITCH_F0_A ELSE
                  sample_f0_B_empty WHEN state_fsm_select_channel = SWITCH_F0_B ELSE
                  sample_f1_empty   WHEN state_fsm_select_channel = SWITCH_F1   ELSE
                  sample_f2_empty   WHEN state_fsm_select_channel = SWITCH_F2   ELSE
                  (OTHERS => '1');
  
  sample_full <= sample_f0_A_full WHEN state_fsm_select_channel = SWITCH_F0_A ELSE
                 sample_f0_B_full WHEN state_fsm_select_channel = SWITCH_F0_B ELSE
                 sample_f1_full   WHEN state_fsm_select_channel = SWITCH_F1   ELSE
                 sample_f2_full   WHEN state_fsm_select_channel = SWITCH_F2   ELSE
                 (OTHERS => '0');
  
  sample_rdata <= sample_f0_A_rdata WHEN state_fsm_select_channel = SWITCH_F0_A ELSE
                  sample_f0_B_rdata WHEN state_fsm_select_channel = SWITCH_F0_B ELSE
                  sample_f1_rdata   WHEN state_fsm_select_channel = SWITCH_F1   ELSE
                  sample_f2_rdata;  -- WHEN state_fsm_select_channel = SWITCH_F2   ELSE


  sample_f0_A_ren <= sample_ren WHEN state_fsm_select_channel = SWITCH_F0_A ELSE (OTHERS => '1');
  sample_f0_B_ren <= sample_ren WHEN state_fsm_select_channel = SWITCH_F0_B ELSE (OTHERS => '1');
  sample_f1_ren   <= sample_ren WHEN state_fsm_select_channel = SWITCH_F1   ELSE (OTHERS => '1');
  sample_f2_ren   <= sample_ren WHEN state_fsm_select_channel = SWITCH_F2   ELSE (OTHERS => '1');

  -----------------------------------------------------------------------------
  -- FSM LOAD FFT
  -----------------------------------------------------------------------------

  sample_ren <= sample_ren_s;-- OR sample_empty;
  
  PROCESS (clk, rstn)
  BEGIN
    IF rstn = '0' THEN
      sample_ren_s              <= (OTHERS => '1');
      state_fsm_load_FFT        <= IDLE;
      next_state_fsm_load_FFT   <= IDLE;
      sample_valid              <= '0';
    ELSIF clk'event AND clk = '1' THEN
      CASE state_fsm_load_FFT IS
        WHEN IDLE   =>
          sample_valid <= '0';
          sample_ren_s <= (OTHERS => '1');
          IF sample_full = "11111" AND sample_load = '1' THEN
            state_fsm_load_FFT <= FIFO_1;
          END IF;
        WHEN FIFO_1 => 
          sample_ren_s <= "1111" & NOT(sample_load);
          sample_valid <= '1';
          IF sample_empty(0) = '1' THEN
            sample_valid <= '0';
            sample_ren_s   <=  (OTHERS => '1');
            state_fsm_load_FFT        <= FIFO_transition;
            next_state_fsm_load_FFT   <= FIFO_2;
          END IF;
          
        WHEN FIFO_transition =>
          sample_valid       <= '0';
          sample_ren_s       <= (OTHERS => '1');
          state_fsm_load_FFT <= next_state_fsm_load_FFT;
          
        WHEN FIFO_2 => 
          sample_ren_s <= "111" & NOT(sample_load) & '1';
          sample_valid <= sample_load;
          IF sample_empty(1) = '1' THEN
            sample_valid       <= '0';
            sample_ren_s   <=  (OTHERS => '1');
            state_fsm_load_FFT <= FIFO_transition;
            next_state_fsm_load_FFT   <= FIFO_3;
          END IF;
        WHEN FIFO_3 => 
          sample_ren_s <= "11" & NOT(sample_load) & "11";
          sample_valid <= sample_load;--'1';
          IF sample_empty(2) = '1' THEN
            sample_valid       <= '0';
            sample_ren_s   <=  (OTHERS => '1');
            state_fsm_load_FFT <= FIFO_transition;
            next_state_fsm_load_FFT   <= FIFO_4;
          END IF;
        WHEN FIFO_4 => 
          sample_ren_s <= '1' & NOT(sample_load) & "111";
          sample_valid <= sample_load;--'1';
          IF sample_empty(3) = '1' THEN
            sample_valid       <= '0';
            sample_ren_s   <=  (OTHERS => '1');
            state_fsm_load_FFT <= FIFO_transition;
            next_state_fsm_load_FFT   <= FIFO_5;
          END IF;
        WHEN FIFO_5 => 
          sample_ren_s <= NOT(sample_load) & "1111";
          sample_valid <= sample_load;--'1';
          IF sample_empty(4) = '1' THEN
            sample_valid       <= '0';
            sample_ren_s   <=  (OTHERS => '1');
            state_fsm_load_FFT <= FIFO_transition;
            next_state_fsm_load_FFT   <= IDLE;
          END IF;
        WHEN OTHERS => NULL;
      END CASE;
    END IF;
  END PROCESS;

  PROCESS (clk, rstn)
  BEGIN
    IF rstn = '0' THEN
      sample_valid_r <= '0';
    ELSIF clk'event AND clk = '1' THEN
      sample_valid_r <= sample_valid AND sample_load;
    END IF;
  END PROCESS;

  sample_data <= sample_rdata(16*1-1 DOWNTO 16*0) WHEN state_fsm_load_FFT = FIFO_1 OR (state_fsm_load_FFT = FIFO_transition AND next_state_fsm_load_FFT = FIFO_2) ELSE
                 sample_rdata(16*2-1 DOWNTO 16*1) WHEN state_fsm_load_FFT = FIFO_2 OR (state_fsm_load_FFT = FIFO_transition AND next_state_fsm_load_FFT = FIFO_3) ELSE
                 sample_rdata(16*3-1 DOWNTO 16*2) WHEN state_fsm_load_FFT = FIFO_3 OR (state_fsm_load_FFT = FIFO_transition AND next_state_fsm_load_FFT = FIFO_4) ELSE
                 sample_rdata(16*4-1 DOWNTO 16*3) WHEN state_fsm_load_FFT = FIFO_4 OR (state_fsm_load_FFT = FIFO_transition AND next_state_fsm_load_FFT = FIFO_5) ELSE
                 sample_rdata(16*5-1 DOWNTO 16*4); --WHEN state_fsm_load_FFT = FIFO_5 ELSE

  -----------------------------------------------------------------------------
  -- FFT
  -----------------------------------------------------------------------------
  CoreFFT_1: CoreFFT
    GENERIC MAP (
      LOGPTS      => gLOGPTS,
      LOGLOGPTS   => gLOGLOGPTS,
      WSIZE       => gWSIZE,
      TWIDTH      => gTWIDTH,
      DWIDTH      => gDWIDTH,
      TDWIDTH     => gTDWIDTH,
      RND_MODE    => gRND_MODE,
      SCALE_MODE  => gSCALE_MODE,
      PTS         => gPTS,
      HALFPTS     => gHALFPTS,
      inBuf_RWDLY => gInBuf_RWDLY)
    PORT MAP (
      clk        => clk,
      ifiStart   => '1',
      ifiNreset  => rstn,
      
      ifiD_valid => sample_valid_r,       -- IN
      ifiRead_y  => fft_read,
      ifiD_im    => (OTHERS => '0'),    -- IN
      ifiD_re    => sample_data,        -- IN
      ifoLoad    => sample_load,        -- IN

      ifoPong    => fft_pong,
      ifoY_im    => fft_data_im,
      ifoY_re    => fft_data_re,
      ifoY_valid => fft_data_valid,
      ifoY_rdy   => fft_ready);

  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  fft_read <= '1';
  -- fft_read       OUT
  -- fft_pong       IN
  -- fft_data_im    IN
  -- fft_data_re    IN
  -- fft_data_valid IN
  -- fft_ready      IN

  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  
  dma_addr        <= (OTHERS => '0');
  dma_data        <= (OTHERS => '0');
  dma_valid       <= '0';
  dma_valid_burst <= '0';
  
  ready_matrix_f0_0             <= '0';
  ready_matrix_f0_1             <= '0';
  ready_matrix_f1               <= '0';
  ready_matrix_f2               <= '0';
  error_anticipating_empty_fifo <= '0';
  error_bad_component_error     <= '0';
  debug_reg                     <= (OTHERS => '0');

  matrix_time_f0_0 <= (OTHERS => '0');
  matrix_time_f0_1 <= (OTHERS => '0');
  matrix_time_f1   <= (OTHERS => '0');
  matrix_time_f2   <= (OTHERS => '0');

  
END Behavioral;
