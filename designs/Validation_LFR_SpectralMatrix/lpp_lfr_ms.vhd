LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


LIBRARY lpp;
USE lpp.lpp_memory.ALL;
USE lpp.iir_filter.ALL;
USE lpp.spectral_matrix_package.ALL;
USE lpp.lpp_dma_pkg.ALL;
USE lpp.lpp_Header.ALL;
USE lpp.lpp_matrix.ALL;
USE lpp.lpp_matrix.ALL;
USE lpp.lpp_lfr_pkg.ALL;
USE lpp.lpp_fft.ALL;
USE lpp.fft_components.ALL;

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
  SIGNAL state_fsm_select_channel     : fsm_select_channel;
  SIGNAL pre_state_fsm_select_channel : fsm_select_channel;

  SIGNAL sample_rdata : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
  SIGNAL sample_ren   : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_full  : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_empty : STD_LOGIC_VECTOR(4 DOWNTO 0);

  -----------------------------------------------------------------------------
  -- FSM LOAD FFT
  -----------------------------------------------------------------------------
  TYPE   fsm_load_FFT IS (IDLE, FIFO_1, FIFO_2, FIFO_3, FIFO_4, FIFO_5);
  SIGNAL state_fsm_load_FFT      : fsm_load_FFT;
  SIGNAL next_state_fsm_load_FFT : fsm_load_FFT;

  SIGNAL sample_ren_s   : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_load    : STD_LOGIC;
  SIGNAL sample_valid   : STD_LOGIC;
  SIGNAL sample_valid_r : STD_LOGIC;
  SIGNAL sample_data    : STD_LOGIC_VECTOR(15 DOWNTO 0);


  -----------------------------------------------------------------------------
  -- FFT
  -----------------------------------------------------------------------------
  SIGNAL fft_read            : STD_LOGIC;
  SIGNAL fft_pong            : STD_LOGIC;
  SIGNAL fft_data_im         : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL fft_data_re         : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL fft_data_valid      : STD_LOGIC;
  SIGNAL fft_ready           : STD_LOGIC;
  -----------------------------------------------------------------------------
  SIGNAL fft_linker_ReUse    : STD_LOGIC_VECTOR(4 DOWNTO 0);
  -----------------------------------------------------------------------------
  TYPE   fsm_load_MS_memory IS (IDLE, LOAD_FIFO, TRASH_FFT);
  SIGNAL state_fsm_load_MS_memory : fsm_load_MS_memory;
  SIGNAL current_fifo_load : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL current_fifo_empty : STD_LOGIC;
  SIGNAL current_fifo_locked : STD_LOGIC;
  SIGNAL current_fifo_full : STD_LOGIC;
  SIGNAL MEM_IN_SM_locked      : STD_LOGIC_VECTOR(4 DOWNTO 0);
  
  -----------------------------------------------------------------------------
  SIGNAL MEM_IN_SM_ReUse     : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL MEM_IN_SM_wen     : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL MEM_IN_SM_wen_s     : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL MEM_IN_SM_ren      : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL MEM_IN_SM_wData      : STD_LOGIC_VECTOR(16*2*5-1 DOWNTO 0);
  SIGNAL MEM_IN_SM_rData  : STD_LOGIC_VECTOR(16*2*5-1 DOWNTO 0);
  SIGNAL MEM_IN_SM_Full      : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL MEM_IN_SM_Empty      : STD_LOGIC_VECTOR(4 DOWNTO 0);
  -----------------------------------------------------------------------------
  SIGNAL HEAD_SM_Param       : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL HEAD_WorkFreq       : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL HEAD_SM_Wen         : STD_LOGIC;
  SIGNAL HEAD_Valid          : STD_LOGIC;
  SIGNAL HEAD_Data           : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL HEAD_Empty          : STD_LOGIC;
  SIGNAL HEAD_Read           : STD_LOGIC;
  -----------------------------------------------------------------------------
  SIGNAL MEM_OUT_SM_ReUse    : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL MEM_OUT_SM_Write    : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL MEM_OUT_SM_Read     : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL MEM_OUT_SM_Data_in  : STD_LOGIC_VECTOR(63 DOWNTO 0);
  SIGNAL MEM_OUT_SM_Data_out : STD_LOGIC_VECTOR(63 DOWNTO 0);
  SIGNAL MEM_OUT_SM_Full     : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL MEM_OUT_SM_Empty     : STD_LOGIC_VECTOR(1 DOWNTO 0);
  -----------------------------------------------------------------------------
  SIGNAL DMA_Header          : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL DMA_Header_Val      : STD_LOGIC;
  SIGNAL DMA_Header_Ack      : STD_LOGIC;

  -----------------------------------------------------------------------------
  -- TIME REG & INFOs
  -----------------------------------------------------------------------------
  SIGNAL all_time : STD_LOGIC_VECTOR(47 DOWNTO 0);

  SIGNAL time_reg_f0_A : STD_LOGIC_VECTOR(47 DOWNTO 0);
  SIGNAL time_reg_f0_B : STD_LOGIC_VECTOR(47 DOWNTO 0);
  SIGNAL time_reg_f1   : STD_LOGIC_VECTOR(47 DOWNTO 0);
  SIGNAL time_reg_f2   : STD_LOGIC_VECTOR(47 DOWNTO 0);

  SIGNAL time_update_f0_A : STD_LOGIC;
  SIGNAL time_update_f0_B : STD_LOGIC;
  SIGNAL time_update_f1   : STD_LOGIC;
  SIGNAL time_update_f2   : STD_LOGIC;
  --
  SIGNAL status_channel   : STD_LOGIC_VECTOR(49 DOWNTO 0);
  
  SIGNAL dma_time : STD_LOGIC_VECTOR(47 DOWNTO 0);
  -----------------------------------------------------------------------------

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

      error_wen => error_wen_f0);       -- TODO

  -----------------------------------------------------------------------------
  -- FIFO IN
  -----------------------------------------------------------------------------
  lppFIFOxN_f0_a : lppFIFOxN
    GENERIC MAP (
      tech         => 0,
      Mem_use      => Mem_use,
      Data_sz      => 16,
      Addr_sz      => 8,
      FifoCnt      => 5)
    PORT MAP (
      clk   => clk,
      rstn  => rstn,
      
      ReUse => (OTHERS => '0'),

      wen         => sample_f0_A_wen,   
      wdata       => sample_f0_wdata,   
      
      ren         => sample_f0_A_ren,   
      rdata       => sample_f0_A_rdata, 
      
      empty       => sample_f0_A_empty, 
      full        => sample_f0_A_full,  
      almost_full => OPEN);             

  lppFIFOxN_f0_b : lppFIFOxN
    GENERIC MAP (
      tech         => 0,
      Mem_use      => Mem_use,
      Data_sz      => 16,
      Addr_sz      => 8,
      FifoCnt      => 5)
    PORT MAP (
      clk   => clk,
      rstn  => rstn,
      
      ReUse => (OTHERS => '0'),

      wen         => sample_f0_B_wen,   
      wdata       => sample_f0_wdata,   
      ren         => sample_f0_B_ren,   
      rdata       => sample_f0_B_rdata, 
      empty       => sample_f0_B_empty, 
      full        => sample_f0_B_full,  
      almost_full => OPEN);             

  lppFIFOxN_f1 : lppFIFOxN
    GENERIC MAP (
      tech         => 0,
      Mem_use      => Mem_use,
      Data_sz      => 16,
      Addr_sz      => 8,
      FifoCnt      => 5)
    PORT MAP (
      clk   => clk,
      rstn  => rstn,
      
      ReUse => (OTHERS => '0'),

      wen         => sample_f1_wen,          
      wdata       => sample_f1_wdata,        
      ren         => sample_f1_ren,          
      rdata       => sample_f1_rdata,        
      empty       => sample_f1_empty,        
      full        => sample_f1_full,         
      almost_full => sample_f1_almost_full); 


  one_sample_f1_wen <= '0' WHEN sample_f1_wen = "11111" ELSE '1';

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      one_sample_f1_full <= '0';
      error_wen_f1       <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
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
      FifoCnt      => 5)
    PORT MAP (
      clk   => clk,
      rstn  => rstn,
      
      ReUse => (OTHERS => '0'),

      wen         => sample_f2_wen,     
      wdata       => sample_f2_wdata,   
      ren         => sample_f2_ren,     
      rdata       => sample_f2_rdata,   
      empty       => sample_f2_empty,   
      full        => sample_f2_full,    
      almost_full => OPEN);             


  one_sample_f2_wen <= '0' WHEN sample_f2_wen = "11111" ELSE '1';

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      one_sample_f2_full <= '0';
      error_wen_f2       <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
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

  PROCESS (clk, rstn)
  BEGIN
    IF rstn = '0' THEN
      pre_state_fsm_select_channel <= IDLE;
    ELSIF clk'EVENT AND clk = '1' THEN
      pre_state_fsm_select_channel <= state_fsm_select_channel;
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
  
  sample_rdata <= sample_f0_A_rdata WHEN pre_state_fsm_select_channel = SWITCH_F0_A ELSE
                  sample_f0_B_rdata WHEN pre_state_fsm_select_channel = SWITCH_F0_B ELSE
                  sample_f1_rdata   WHEN pre_state_fsm_select_channel = SWITCH_F1   ELSE
                  sample_f2_rdata;  -- WHEN state_fsm_select_channel = SWITCH_F2   ELSE


  sample_f0_A_ren <= sample_ren WHEN state_fsm_select_channel = SWITCH_F0_A ELSE (OTHERS => '1');
  sample_f0_B_ren <= sample_ren WHEN state_fsm_select_channel = SWITCH_F0_B ELSE (OTHERS => '1');
  sample_f1_ren   <= sample_ren WHEN state_fsm_select_channel = SWITCH_F1   ELSE (OTHERS => '1');
  sample_f2_ren   <= sample_ren WHEN state_fsm_select_channel = SWITCH_F2   ELSE (OTHERS => '1');


  status_channel <= time_reg_f0_A & "00" WHEN state_fsm_select_channel = SWITCH_F0_A ELSE
                    time_reg_f0_B & "00" WHEN state_fsm_select_channel = SWITCH_F0_B ELSE
                    time_reg_f1 & "01"   WHEN state_fsm_select_channel = SWITCH_F1   ELSE
                    time_reg_f2 & "10";  -- WHEN state_fsm_select_channel = SWITCH_F2

  -----------------------------------------------------------------------------
  -- FSM LOAD FFT
  -----------------------------------------------------------------------------

  sample_ren <= sample_ren_s WHEN sample_load = '1' ELSE (OTHERS => '1');

  PROCESS (clk, rstn)
  BEGIN
    IF rstn = '0' THEN
      sample_ren_s       <= (OTHERS => '1');
      state_fsm_load_FFT <= IDLE;
      --next_state_fsm_load_FFT <= IDLE;
      --sample_valid              <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      CASE state_fsm_load_FFT IS
        WHEN IDLE =>
          --sample_valid <= '0';
          sample_ren_s <= (OTHERS => '1');
          IF sample_full = "11111" AND sample_load = '1' THEN
            state_fsm_load_FFT <= FIFO_1;
          END IF;
          
        WHEN FIFO_1 =>
          sample_ren_s <= "1111" & NOT(sample_load);
          IF sample_empty(0) = '1' THEN
            sample_ren_s       <= (OTHERS => '1');
            state_fsm_load_FFT <= FIFO_2;
          END IF;
          
        WHEN FIFO_2 =>
          sample_ren_s <= "111" & NOT(sample_load) & '1';
          IF sample_empty(1) = '1' THEN
            sample_ren_s       <= (OTHERS => '1');
            state_fsm_load_FFT <= FIFO_3;
          END IF;
          
        WHEN FIFO_3 =>
          sample_ren_s <= "11" & NOT(sample_load) & "11";
          IF sample_empty(2) = '1' THEN
            sample_ren_s       <= (OTHERS => '1');
            state_fsm_load_FFT <= FIFO_4;
          END IF;
          
        WHEN FIFO_4 =>
          sample_ren_s <= '1' & NOT(sample_load) & "111";
          IF sample_empty(3) = '1' THEN
            sample_ren_s       <= (OTHERS => '1');
            state_fsm_load_FFT <= FIFO_5;
          END IF;
          
        WHEN FIFO_5 =>
          sample_ren_s <= NOT(sample_load) & "1111";
          IF sample_empty(4) = '1' THEN
            sample_ren_s       <= (OTHERS => '1');
            state_fsm_load_FFT <= IDLE;
          END IF;
        WHEN OTHERS => NULL;
      END CASE;
    END IF;
  END PROCESS;

  PROCESS (clk, rstn)
  BEGIN
    IF rstn = '0' THEN
      sample_valid_r          <= '0';
      next_state_fsm_load_FFT <= IDLE;
    ELSIF clk'EVENT AND clk = '1' THEN
      next_state_fsm_load_FFT <= state_fsm_load_FFT;
      IF sample_ren_s = "11111" THEN
        sample_valid_r <= '0';
      ELSE
        sample_valid_r <= '1';
      END IF;
    END IF;
  END PROCESS;

  sample_valid <= sample_valid_r AND sample_load;

  sample_data <= sample_rdata(16*1-1 DOWNTO 16*0) WHEN next_state_fsm_load_FFT = FIFO_1 ELSE
                 sample_rdata(16*2-1 DOWNTO 16*1) WHEN next_state_fsm_load_FFT = FIFO_2 ELSE
                 sample_rdata(16*3-1 DOWNTO 16*2) WHEN next_state_fsm_load_FFT = FIFO_3 ELSE
                 sample_rdata(16*4-1 DOWNTO 16*3) WHEN next_state_fsm_load_FFT = FIFO_4 ELSE
                 sample_rdata(16*5-1 DOWNTO 16*4);  --WHEN next_state_fsm_load_FFT = FIFO_5 ELSE

  -----------------------------------------------------------------------------
  -- FFT
  -----------------------------------------------------------------------------
  CoreFFT_1 : CoreFFT
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
      clk       => clk,
      ifiStart  => '1',
      ifiNreset => rstn,

      ifiD_valid => sample_valid,       -- IN
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
  -- in   fft_data_im & fft_data_re
  -- in   fft_data_valid
  -- in   fft_ready
  -- out  fft_read
  PROCESS (clk, rstn)
  BEGIN
    IF rstn = '0' THEN
      state_fsm_load_MS_memory <= IDLE;
      current_fifo_load <= "00001";
    ELSIF clk'event AND clk = '1' THEN
      CASE state_fsm_load_MS_memory IS
        WHEN IDLE =>
          IF current_fifo_empty = '1' AND fft_ready = '1' AND current_fifo_locked = '0' THEN
            state_fsm_load_MS_memory <= LOAD_FIFO;
          END IF;
        WHEN LOAD_FIFO =>
          IF current_fifo_full = '1' THEN
            state_fsm_load_MS_memory <= TRASH_FFT;
          END IF;
        WHEN TRASH_FFT =>
          IF fft_ready = '0' THEN
            state_fsm_load_MS_memory <= IDLE;
            current_fifo_load <= current_fifo_load(3 DOWNTO 0) & current_fifo_load(4);
          END IF;          
        WHEN OTHERS => NULL;
      END CASE;
      
    END IF;
  END PROCESS;
  
  current_fifo_empty <= MEM_IN_SM_Empty(0) WHEN current_fifo_load(0) = '1' ELSE
                        MEM_IN_SM_Empty(1) WHEN current_fifo_load(1) = '1' ELSE
                        MEM_IN_SM_Empty(2) WHEN current_fifo_load(2) = '1' ELSE
                        MEM_IN_SM_Empty(3) WHEN current_fifo_load(3) = '1' ELSE
                        MEM_IN_SM_Empty(4);-- WHEN current_fifo_load(3) = '1' ELSE
                        
  current_fifo_full  <= MEM_IN_SM_Full(0) WHEN current_fifo_load(0) = '1' ELSE
                        MEM_IN_SM_Full(1) WHEN current_fifo_load(1) = '1' ELSE
                        MEM_IN_SM_Full(2) WHEN current_fifo_load(2) = '1' ELSE
                        MEM_IN_SM_Full(3) WHEN current_fifo_load(3) = '1' ELSE
                        MEM_IN_SM_Full(4);-- WHEN current_fifo_load(3) = '1' ELSE
                        
  current_fifo_locked <= MEM_IN_SM_locked(0) WHEN current_fifo_load(0) = '1' ELSE
                         MEM_IN_SM_locked(1) WHEN current_fifo_load(1) = '1' ELSE
                         MEM_IN_SM_locked(2) WHEN current_fifo_load(2) = '1' ELSE
                         MEM_IN_SM_locked(3) WHEN current_fifo_load(3) = '1' ELSE
                         MEM_IN_SM_locked(4);-- WHEN current_fifo_load(3) = '1' ELSE
                        
  fft_read <= '0' WHEN state_fsm_load_MS_memory = IDLE ELSE '1';

  all_fifo: FOR I IN 4 DOWNTO 0 GENERATE
      MEM_IN_SM_wen_s(I) <= '0' WHEN fft_data_valid = '1'
                                   AND state_fsm_load_MS_memory = LOAD_FIFO
                                   AND current_fifo_load(I) = '1'
                          ELSE '1';
  END GENERATE all_fifo;

  PROCESS (clk, rstn)
  BEGIN
    IF rstn = '0' THEN
      MEM_IN_SM_wen <= (OTHERS => '1');
    ELSIF clk'event AND clk = '1' THEN
      MEM_IN_SM_wen <= MEM_IN_SM_wen_s;      
    END IF;
  END PROCESS;
  
  MEM_IN_SM_wData <= (fft_data_im & fft_data_re) &
                     (fft_data_im & fft_data_re) &
                     (fft_data_im & fft_data_re) &
                     (fft_data_im & fft_data_re) &
                     (fft_data_im & fft_data_re);
  

  -- out SM_MEM_IN_wData
  -- out SM_MEM_IN_wen
  -- out SM_MEM_IN_Full
  
  -- out SM_MEM_IN_locked
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  --Linker_FFT_1 : Linker_FFT
  --  GENERIC MAP (
  --    Data_sz => 16,
  --    NbData  => 256)
  --  PORT MAP (
  --    clk  => clk,
  --    rstn => rstn,

  --    Ready => fft_ready,
  --    Valid => fft_data_valid,

  --    Full => MEM_IN_SM_Full,

  --    Data_re => fft_data_re,
  --    Data_im => fft_data_im,
  --    Read    => fft_read,

  --    Write => MEM_IN_SM_wen,
  --    ReUse => fft_linker_ReUse,
  --    DATA  => MEM_IN_SM_wData);
  
  -----------------------------------------------------------------------------
  Mem_In_SpectralMatrix : lppFIFOxN
    GENERIC MAP (
      tech         => 0,
      Mem_use      => Mem_use,
      Data_sz      => 32,               --16,
      Addr_sz      => 7,                --8
      FifoCnt      => 5)
    PORT MAP (
      clk => clk,
      rstn => rstn,

      ReUse => MEM_IN_SM_ReUse,
      
      wen   => MEM_IN_SM_wen,
      wdata => MEM_IN_SM_wData,
      
      ren   => MEM_IN_SM_ren,
      rdata => MEM_IN_SM_rData,
      full  => MEM_IN_SM_Full,
      empty => MEM_IN_SM_Empty);


  all_lock: FOR I IN 4 DOWNTO 0 GENERATE
    PROCESS (clk, rstn)
    BEGIN
      IF rstn = '0' THEN
        MEM_IN_SM_locked(I) <= '0';
      ELSIF clk'event AND clk = '1' THEN 
        MEM_IN_SM_locked(I) <=   MEM_IN_SM_Full(I) OR  MEM_IN_SM_locked(I);  -- TODO
      END IF;
    END PROCESS;    
  END GENERATE all_lock;
  
  -----------------------------------------------------------------------------
  


  
  
  -----------------------------------------------------------------------------
  SM0 : MatriceSpectrale
    GENERIC MAP (
      Input_SZ  => 16,
      Result_SZ => 32)
    PORT MAP (
      clkm => clk,
      rstn => rstn,

      FifoIN_Full => MEM_IN_SM_Full,
      Data_IN     => MEM_IN_SM_rData(79 DOWNTO 0),
      Read        => MEM_IN_SM_ren,
      ReUse       => MEM_IN_SM_ReUse,

      SetReUse => fft_linker_ReUse,

      Valid     => HEAD_Valid,
      ACK       => DMA_Header_Ack,
      SM_Write  => HEAD_SM_Wen,
      FlagError => OPEN,
      Statu     => HEAD_SM_Param,
      Write     => MEM_OUT_SM_Write,
      Data_OUT  => MEM_OUT_SM_Data_in);
  -----------------------------------------------------------------------------
  Mem_Out_SpectralMatrix : lppFIFOxN
    GENERIC MAP (
      tech         => 0,
      Mem_use      => Mem_use,
      Data_sz      => 32,
      Addr_sz      => 8,
      FifoCnt      => 2)
    PORT MAP (
      clk => clk,
      rstn => rstn,

      ReUse => (OTHERS => '0'),

      wen   => MEM_OUT_SM_Write,
      wdata => MEM_OUT_SM_Data_in,
      ren   => MEM_OUT_SM_Read,
      rdata => MEM_OUT_SM_Data_out,

      full  => MEM_OUT_SM_Full,
      empty => MEM_OUT_SM_Empty);       
  -----------------------------------------------------------------------------
  Head0 : HeaderBuilder
    GENERIC MAP (
      Data_sz => 32)
    PORT MAP (
      clkm => clk,
      rstn => rstn,

      Statu        => HEAD_SM_Param,
      Matrix_Type  => HEAD_WorkFreq,    -- TODO IN
      Matrix_Write => HEAD_SM_Wen,
      Valid        => HEAD_Valid,

      dataIN  => MEM_OUT_SM_Data_out,
      emptyIN => MEM_OUT_SM_Empty,
      RenOUT  => MEM_OUT_SM_Read,

      dataOUT  => HEAD_Data,
      emptyOUT => HEAD_Empty,
      RenIN    => HEAD_Read,

      header     => DMA_Header,
      header_val => DMA_Header_Val,
      header_ack => DMA_Header_Ack);         
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  lpp_lfr_ms_fsmdma_1 : lpp_lfr_ms_fsmdma
    PORT MAP (
      HCLK    => clk,
      HRESETn => rstn,

      data_time => dma_time,           

      fifo_data  => HEAD_Data,
      fifo_empty => HEAD_Empty,
      fifo_ren   => HEAD_Read,

      header     => DMA_Header,
      header_val => DMA_Header_Val,
      header_ack => DMA_Header_Ack,

      dma_addr        => dma_addr,
      dma_data        => dma_data,
      dma_valid       => dma_valid,
      dma_valid_burst => dma_valid_burst,
      dma_ren         => dma_ren,
      dma_done        => dma_done,

      ready_matrix_f0_0                      => ready_matrix_f0_0,
      ready_matrix_f0_1                      => ready_matrix_f0_1,
      ready_matrix_f1                        => ready_matrix_f1,
      ready_matrix_f2                        => ready_matrix_f2,
      error_anticipating_empty_fifo          => error_anticipating_empty_fifo,
      error_bad_component_error              => error_bad_component_error,
      debug_reg                              => debug_reg,
      status_ready_matrix_f0_0               => status_ready_matrix_f0_0,
      status_ready_matrix_f0_1               => status_ready_matrix_f0_1,
      status_ready_matrix_f1                 => status_ready_matrix_f1,
      status_ready_matrix_f2                 => status_ready_matrix_f2,
      status_error_anticipating_empty_fifo   => status_error_anticipating_empty_fifo,
      status_error_bad_component_error       => status_error_bad_component_error,
      config_active_interruption_onNewMatrix => config_active_interruption_onNewMatrix,
      config_active_interruption_onError     => config_active_interruption_onError,
      addr_matrix_f0_0                       => addr_matrix_f0_0,
      addr_matrix_f0_1                       => addr_matrix_f0_1,
      addr_matrix_f1                         => addr_matrix_f1,
      addr_matrix_f2                         => addr_matrix_f2,

      matrix_time_f0_0 => matrix_time_f0_0,
      matrix_time_f0_1 => matrix_time_f0_1,
      matrix_time_f1   => matrix_time_f1,
      matrix_time_f2   => matrix_time_f2
      );
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------






  -----------------------------------------------------------------------------
  -- TIME MANAGMENT
  -----------------------------------------------------------------------------
  all_time         <= coarse_time & fine_time;
  --
  time_update_f0_A <= '0' WHEN sample_f0_A_wen = "11111" ELSE
                      '1' WHEN sample_f0_A_empty = "11111" ELSE
                      '0';
  
  s_m_t_m_f0_A : spectral_matrix_time_managment
    PORT MAP (
      clk      => clk,
      rstn     => rstn,
      time_in  => all_time,
      update_1 => time_update_f0_A,
      time_out => time_reg_f0_A);

  --  
  time_update_f0_B <= '0' WHEN sample_f0_B_wen = "11111" ELSE
                      '1' WHEN sample_f0_B_empty = "11111" ELSE
                      '0';
  
  s_m_t_m_f0_B : spectral_matrix_time_managment
    PORT MAP (
      clk      => clk,
      rstn     => rstn,
      time_in  => all_time,
      update_1 => time_update_f0_B,
      time_out => time_reg_f0_B);

  --  
  time_update_f1 <= '0' WHEN sample_f1_wen = "11111" ELSE
                    '1' WHEN sample_f1_empty = "11111" ELSE
                    '0';
  
  s_m_t_m_f1 : spectral_matrix_time_managment
    PORT MAP (
      clk      => clk,
      rstn     => rstn,
      time_in  => all_time,
      update_1 => time_update_f1,
      time_out => time_reg_f1);

  --  
  time_update_f2 <= '0' WHEN sample_f2_wen = "11111" ELSE
                    '1' WHEN sample_f2_empty = "11111" ELSE
                    '0';
  
  s_m_t_m_f2 : spectral_matrix_time_managment
    PORT MAP (
      clk      => clk,
      rstn     => rstn,
      time_in  => all_time,
      update_1 => time_update_f2,
      time_out => time_reg_f2);

  -----------------------------------------------------------------------------
  dma_time <= (OTHERS => '0');         -- TODO
  -----------------------------------------------------------------------------



END Behavioral;
