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
USE lpp.window_function_pkg.ALL;

ENTITY lpp_lfr_ms_FFT IS
  GENERIC (
    WINDOWS_HAANNING_PARAM_SIZE : INTEGER := 15
    );
  
  PORT (
    clk  : IN STD_LOGIC;
    rstn : IN STD_LOGIC;
    -- IN
    sample_valid : IN STD_LOGIC;
    fft_read     : IN STD_LOGIC;
    sample_data  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    sample_load  : OUT STD_LOGIC;

    --OUT
    fft_pong       : OUT STD_LOGIC;
    fft_data_im    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    fft_data_re    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    fft_data_valid : OUT STD_LOGIC;
    fft_ready      : OUT STD_LOGIC
    
    );
END;

ARCHITECTURE Behavioral OF lpp_lfr_ms_FFT IS

  SIGNAL data_win       : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL data_win_valid : STD_LOGIC;

  SIGNAL data_in_reg       : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL data_in_reg_valid : STD_LOGIC;

BEGIN

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      data_in_reg       <= (OTHERS => '0');
      data_in_reg_valid <= '0'; 
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      data_in_reg       <= sample_data;
      data_in_reg_valid <= sample_valid;       
    END IF;
  END PROCESS;
  
  window_hanning: window_function
    GENERIC MAP (
      SIZE_DATA          => 16,
      SIZE_PARAM         => WINDOWS_HAANNING_PARAM_SIZE,
      NB_POINT_BY_WINDOW => 256)
    PORT MAP (
      clk            => clk,
      rstn           => rstn,
      
      restart_window => '0',
      data_in        => data_in_reg,
      data_in_valid  => data_in_reg_valid,
      
      data_out       => data_win,
      data_out_valid => data_win_valid);
  
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
      ifiStart  => '0',                 -- '1'
      ifiNreset => rstn,

      ifiD_valid => data_win_valid,       -- IN
      ifiRead_y  => fft_read,
      ifiD_im    => (OTHERS => '0'),    -- IN
      ifiD_re    => data_win,        -- IN
      ifoLoad    => sample_load,        -- IN

      ifoPong    => fft_pong,
      ifoY_im    => fft_data_im,
      ifoY_re    => fft_data_re,
      ifoY_valid => fft_data_valid,
      ifoY_rdy   => fft_ready);

  -----------------------------------------------------------------------------

END Behavioral;
