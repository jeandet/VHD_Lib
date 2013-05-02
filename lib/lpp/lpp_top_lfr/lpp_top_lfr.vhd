LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
LIBRARY grlib;
USE grlib.amba.ALL;
USE grlib.stdlib.ALL;
USE grlib.devices.ALL;
USE GRLIB.DMA2AHB_Package.ALL;
LIBRARY lpp;
USE lpp.lpp_ad_conv.ALL;
USE lpp.iir_filter.ALL;
USE lpp.FILTERcfg.ALL;
USE lpp.lpp_memory.ALL;
USE lpp.lpp_top_lfr_pkg.ALL;
USE lpp.lpp_dma_pkg.ALL;
USE lpp.lpp_demux.ALL;
USE lpp.lpp_fft.ALL;
USE lpp.lpp_matrix.ALL;
USE lpp.lpp_waveform_pkg.ALL;
LIBRARY techmap;
USE techmap.gencomp.ALL;

ENTITY lpp_top_lfr IS
  GENERIC(
    tech                  : INTEGER := 0;
    hindex_SpectralMatrix : INTEGER := 2;
    pindex                : INTEGER := 4;
    paddr                 : INTEGER := 4;
    pmask                 : INTEGER := 16#fff#;
    pirq                  : INTEGER := 0
    );
  PORT (
    -- ADS7886
    cnv_run  : IN  STD_LOGIC;
    cnv      : OUT STD_LOGIC;
    sck      : OUT STD_LOGIC;
    sdo      : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
    --
    cnv_clk  : IN  STD_LOGIC;           -- 49 MHz
    cnv_rstn : IN  STD_LOGIC;
    --
    clk      : IN  STD_LOGIC;           -- 25 MHz
    rstn     : IN  STD_LOGIC;
    --
    apbi     : IN  apb_slv_in_type;
    apbo     : OUT apb_slv_out_type;

    -- AMBA AHB Master Interface
    AHB_DMA_SpectralMatrix_In  : IN  AHB_Mst_In_Type;
    AHB_DMA_SpectralMatrix_Out : OUT AHB_Mst_Out_Type

    -- Time
    coarse_time : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);  --! coarse time
    fine_time   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)   --! fine time
    );
END lpp_top_lfr;

ARCHITECTURE tb OF lpp_top_lfr IS

  -----------------------------------------------------------------------------
  -- f0
  SIGNAL sample_f0_wen   : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f0_wdata   : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
  --
  SIGNAL sample_f0_0_ren   : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f0_0_rdata : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
  SIGNAL sample_f0_0_full  : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f0_0_empty : STD_LOGIC_VECTOR(4 DOWNTO 0);
  --
  SIGNAL sample_f0_1_ren   : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f0_1_rdata : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
  SIGNAL sample_f0_1_full  : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f0_1_empty : STD_LOGIC_VECTOR(4 DOWNTO 0);
  -----------------------------------------------------------------------------
  -- f1
  SIGNAL sample_f1_wen     : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f1_wdata   : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
  --
  SIGNAL sample_f1_ren     : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f1_rdata   : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
  SIGNAL sample_f1_full    : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f1_empty   : STD_LOGIC_VECTOR(4 DOWNTO 0);
  -----------------------------------------------------------------------------
  -- f2
  SIGNAL sample_f2_wen     : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f2_wdata   : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
  -----------------------------------------------------------------------------
  -- f3
  SIGNAL sample_f3_wen     : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f3_wdata   : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
  --
  SIGNAL sample_f3_ren     : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f3_rdata   : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
  SIGNAL sample_f3_full    : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f3_empty   : STD_LOGIC_VECTOR(4 DOWNTO 0);
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- SPECTRAL MATRIX
  -----------------------------------------------------------------------------
  SIGNAL sample_ren : STD_LOGIC_VECTOR(19 DOWNTO 0);

  SIGNAL demux_empty : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL demux_ren   : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL demux_data  : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);

  SIGNAL fft_fifo_full  : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL fft_fifo_data  : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
  SIGNAL fft_fifo_wen   : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL fft_fifo_reuse : STD_LOGIC_VECTOR(4 DOWNTO 0);

  SIGNAL SP_fifo_data : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
  SIGNAL SP_fifo_ren  : STD_LOGIC_VECTOR(4 DOWNTO 0);

  SIGNAL fifo_data  : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL fifo_empty : STD_LOGIC;
  SIGNAL fifo_ren   : STD_LOGIC;
  SIGNAL header     : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL header_val : STD_LOGIC;
  SIGNAL header_ack : STD_LOGIC;

  -----------------------------------------------------------------------------
  -- APB REG
  -----------------------------------------------------------------------------
  SIGNAL ready_matrix_f0_0                      : STD_LOGIC;
  SIGNAL ready_matrix_f0_1                      : STD_LOGIC;
  SIGNAL ready_matrix_f1                        : STD_LOGIC;
  SIGNAL ready_matrix_f2                        : STD_LOGIC;
  SIGNAL error_anticipating_empty_fifo          : STD_LOGIC;
  SIGNAL error_bad_component_error              : STD_LOGIC;
  SIGNAL debug_reg                              : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL status_ready_matrix_f0_0               : STD_LOGIC;
  SIGNAL status_ready_matrix_f0_1               : STD_LOGIC;
  SIGNAL status_ready_matrix_f1                 : STD_LOGIC;
  SIGNAL status_ready_matrix_f2                 : STD_LOGIC;
  SIGNAL status_error_anticipating_empty_fifo   : STD_LOGIC;
  SIGNAL status_error_bad_component_error       : STD_LOGIC;
  SIGNAL config_active_interruption_onNewMatrix : STD_LOGIC;
  SIGNAL config_active_interruption_onError     : STD_LOGIC;
  SIGNAL addr_matrix_f0_0                       : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL addr_matrix_f0_1                       : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL addr_matrix_f1                         : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL addr_matrix_f2                         : STD_LOGIC_VECTOR(31 DOWNTO 0);

  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------

  CONSTANT nb_snapshot_param_size : INTEGER := 11;
  CONSTANT delta_snapshot_size    : INTEGER := 16;
  CONSTANT delta_f2_f0_size       : INTEGER := 10;
  CONSTANT delta_f2_f1_size       : INTEGER := 10;

  SIGNAL waveform_enable_f0 : STD_LOGIC;
  SIGNAL waveform_enable_f1 : STD_LOGIC;
  SIGNAL waveform_enable_f2 : STD_LOGIC;
  SIGNAL waveform_enable_f3 : STD_LOGIC;

  SIGNAL waveform_burst_f0 : STD_LOGIC;
  SIGNAL waveform_burst_f1 : STD_LOGIC;
  SIGNAL waveform_burst_f2 : STD_LOGIC;

  SIGNAL waveform_nb_snapshot_param : STD_LOGIC_VECTOR(nb_snapshot_param_size-1 DOWNTO 0);
  SIGNAL waveform_delta_snapshot    : STD_LOGIC_VECTOR(delta_snapshot_size-1 DOWNTO 0);
  SIGNAL waveform_delta_f2_f1       : STD_LOGIC_VECTOR(delta_f2_f1_size-1 DOWNTO 0);
  SIGNAL waveform_delta_f2_f0       : STD_LOGIC_VECTOR(delta_f2_f0_size-1 DOWNTO 0);

  SIGNAL data_f0_in_valid   : STD_LOGIC;
  SIGNAL data_f0_in_valid_r : STD_LOGIC;
  SIGNAL data_f1_in_valid   : STD_LOGIC;
  SIGNAL data_f2_in_valid   : STD_LOGIC;
  SIGNAL data_f3_in_valid   : STD_LOGIC;
  
BEGIN

  -----------------------------------------------------------------------------
  -- CNA + FILTER
  -----------------------------------------------------------------------------
  lpp_top_acq_1 : lpp_top_acq
    GENERIC MAP (
      tech => tech)
    PORT MAP (
      cnv_run  => cnv_run,
      cnv      => cnv,
      sck      => sck,
      sdo      => sdo,
      cnv_clk  => cnv_clk,
      cnv_rstn => cnv_rstn,
      clk      => clk,
      rstn     => rstn,

      sample_f0_wen   => sample_f0_wen,
      sample_f0_wdata => sample_f0_wdata,
      sample_f1_wen   => sample_f1_wen,
      sample_f1_wdata => sample_f1_wdata,
      sample_f2_wen   => sample_f2_wen,
      sample_f2_wdata => sample_f2_wdata,
      sample_f3_wen   => sample_f3_wen,
      sample_f3_wdata => sample_f3_wdata);

  -----------------------------------------------------------------------------
  -- FIFO
  -----------------------------------------------------------------------------
  
  lppFIFO_f0 : lppFIFOxN
    GENERIC MAP (
      tech         => tech,
      Data_sz      => 16,
      FifoCnt      => 5,
      Enable_ReUse => '0')
    PORT MAP (
      rst   => rstn,
      wclk  => clk,
      rclk  => clk,
      ReUse => (OTHERS => '0'),

      wen   => sample_f0_wen,
      ren   => sample_f0_ren,
      wdata => sample_f0_wdata,
      rdata => sample_f0_rdata,
      full  => sample_f0_full,
      empty => sample_f0_empty);

  lppFIFO_f1 : lppFIFOxN
    GENERIC MAP (
      tech         => tech,
      Data_sz      => 16,
      FifoCnt      => 5,
      Enable_ReUse => '0')
    PORT MAP (
      rst   => rstn,
      wclk  => clk,
      rclk  => clk,
      ReUse => (OTHERS => '0'),

      wen   => sample_f1_wen,
      ren   => sample_f1_ren,
      wdata => sample_f1_wdata,
      rdata => sample_f1_rdata,
      full  => sample_f1_full,
      empty => sample_f1_empty);

  lppFIFO_f2 : lppFIFOxN
    GENERIC MAP (
      tech         => tech,
      Data_sz      => 16,
      FifoCnt      => 5,
      Enable_ReUse => '0')
    PORT MAP (
      rst   => rstn,
      wclk  => clk,
      rclk  => clk,
      ReUse => (OTHERS => '0'),

      wen   => sample_f2_wen,
      ren   => sample_f2_ren,
      wdata => sample_f2_wdata,
      rdata => sample_f2_rdata,
      full  => sample_f2_full,
      empty => sample_f2_empty);

  -----------------------------------------------------------------------------
  -- SPECTRAL MATRIX
  -----------------------------------------------------------------------------
  --sample_f0_ren <= sample_ren(4 DOWNTO 0);
  --sample_f1_ren   <= sample_ren(14 DOWNTO 10);
  --sample_f2_ren   <= sample_ren(19 DOWNTO 15);

  --Demultiplex_1 : Demultiplex
  --  GENERIC MAP (
  --    Data_sz => 16)
  --  PORT MAP (
  --    clk  => clk,
  --    rstn => rstn,

  --    Read       => demux_ren,
  --    EmptyF0a   => sample_f0_0_empty,
  --    EmptyF0b   => sample_f0_0_empty,
  --    EmptyF1    => sample_f1_empty,
  --    EmptyF2    => sample_f3_empty,
  --    DataF0a    => sample_f0_0_rdata,
  --    DataF0b    => sample_f0_1_rdata,
  --    DataF1     => sample_f1_rdata,
  --    DataF2     => sample_f3_rdata,
  --    Read_DEMUX => sample_ren,
  --    Empty      => demux_empty,
  --    Data       => demux_data);

  --FFT_1 : FFT
  --  GENERIC MAP (
  --    Data_sz => 16,
  --    NbData  => 256)
  --  PORT MAP (
  --    clkm         => clk,
  --    rstn         => rstn,
  --    FifoIN_Empty => demux_empty,
  --    FifoIN_Data  => demux_data,
  --    FifoOUT_Full => fft_fifo_full,
  --    Read         => demux_ren,
  --    Write        => fft_fifo_wen,
  --    ReUse        => fft_fifo_reuse,
  --    Data         => fft_fifo_data);   

  --lppFIFO_fft : lppFIFOxN
  --  GENERIC MAP (
  --    tech         => tech,
  --    Data_sz      => 16,
  --    FifoCnt      => 5,
  --    Enable_ReUse => '1')
  --  PORT MAP (
  --    rst   => rstn,
  --    wclk  => clk,
  --    rclk  => clk,
  --    ReUse => fft_fifo_reuse,
  --    wen   => fft_fifo_wen,
  --    ren   => SP_fifo_ren,
  --    wdata => fft_fifo_data,
  --    rdata => SP_fifo_data,
  --    full  => fft_fifo_full,
  --    empty => OPEN);

  --MatriceSpectrale_1 : MatriceSpectrale
  --  GENERIC MAP (
  --    Input_SZ  => 16,
  --    Result_SZ => 32)
  --  PORT MAP (
  --    clkm => clk,
  --    rstn => rstn,

  --    FifoIN_Full  => fft_fifo_full,
  --    FifoOUT_Full => ,                 -- TODO
  --    Data_IN      => SP_fifo_data,
  --    ACQ          => ,                 -- TODO
  --    FlagError    => ,                 -- TODO
  --    Pong         => ,                 -- TODO
  --    Write        => ,                 -- TODO
  --    Read         => SP_fifo_ren,
  --    Data_OUT     => );                -- TODO


  -----------------------------------------------------------------------------
  -- DMA SPECTRAL MATRIX
  -----------------------------------------------------------------------------
  lpp_dma_ip_1 : lpp_dma_ip
    GENERIC MAP (
      tech   => tech,
      hindex => hindex_SpectralMatrix)
    PORT MAP (
      HCLK           => clk,
      HRESETn        => rstn,
      AHB_Master_In  => AHB_DMA_SpectralMatrix_In,
      AHB_Master_Out => AHB_DMA_SpectralMatrix_Out,

      -- Connect to Spectral Matrix --
      fifo_data  => fifo_data,
      fifo_empty => fifo_empty,
      fifo_ren   => fifo_ren,
      header     => header,
      header_val => header_val,
      header_ack => header_ack,

      -- APB REG 

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
      addr_matrix_f2                         => addr_matrix_f2);

  lpp_top_apbreg_1 : lpp_top_apbreg
    GENERIC MAP (
      pindex => pindex,
      paddr  => paddr,
      pmask  => pmask,
      pirq   => pirq)
    PORT MAP (
      HCLK    => clk,
      HRESETn => rstn,
      apbi    => apbi,
      apbo    => apbo,

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
      addr_matrix_f2                         => addr_matrix_f2);


  -----------------------------------------------------------------------------
  -- WAVEFORM
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  delay_valid_waveform : PROCESS (clk, rstn)
  BEGIN
    IF rstn = '0' THEN
      data_f0_in_valid <= '0';
      data_f1_in_valid <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      data_f0_in_valid_r <= NOT sample_f0_wen;
      data_f0_in_valid   <= NOT data_f0_in_valid_r;
      data_f1_in_valid   <= NOT sample_f1_wen;
    END IF;
  END PROCESS delay_valid_waveform;

  data_f2_in_valid <= NOT sample_f2_wen;
  data_f3_in_valid <= NOT sample_f3_wen;
  
  -----------------------------------------------------------------------------
  lpp_waveform_1 : lpp_waveform
    GENERIC MAP (
      data_size              => 16,
      nb_snapshot_param_size => nb_snapshot_param_size,
      delta_snapshot_size    => delta_snapshot_size,
      delta_f2_f0_size       => delta_f2_f0_size,
      delta_f2_f1_size       => delta_f2_f1_size)
    PORT MAP (
      clk  => clk,
      rstn => rstn,

      coarse_time_0  => coarse_time(0),
      delta_snapshot => waveform_delta_snapshot,
      delta_f2_f1    => waveform_delta_f2_f1,
      delta_f2_f0    => waveform_delta_f2_f0,

      enable_f0 => waveform_enable_f0,
      enable_f1 => waveform_enable_f1,
      enable_f2 => waveform_enable_f2,
      enable_f3 => waveform_enable_f3,

      burst_f0 => waveform_burst_f0,
      burst_f1 => waveform_burst_f1,
      burst_f2 => waveform_burst_f2,

      nb_snapshot_param => waveform_nb_snapshot_param,

      data_f0_in => sample_f0_wdata,
      data_f1_in => sample_f1_wdata,
      data_f2_in => sample_f2_wdata,
      data_f3_in => sample_f3_wdata,

      data_f0_in_valid => data_f0_in_valid,
      data_f1_in_valid => data_f1_in_valid,
      data_f2_in_valid => data_f2_in_valid,
      data_f3_in_valid => data_f3_in_valid);

  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------

  --DONE : add the irq alert for DMA matrix transfert ending

  --TODO : add 5 bit register into APB to control the DATA SHIPING
  --TODO : data shiping

  --TODO : add Spectral Matrix (FFT + SP)
  --TODO : add DMA for WaveForms Picker
  --TODO : add APB Reg to control WaveForms Picker
  --TODO : add WaveForms Picker

END tb;
