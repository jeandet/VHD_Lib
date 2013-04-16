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
    );
END lpp_top_lfr;

ARCHITECTURE tb OF lpp_top_lfr IS

  -----------------------------------------------------------------------------
  -- f0
  SIGNAL sample_f0_0_wen   : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f0_1_wen   : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f0_wdata   : STD_LOGIC_VECTOR((5*18)-1 DOWNTO 0);
  --
  SIGNAL sample_f0_0_ren   : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f0_0_rdata : STD_LOGIC_VECTOR((5*18)-1 DOWNTO 0);
  SIGNAL sample_f0_0_full  : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f0_0_empty : STD_LOGIC_VECTOR(4 DOWNTO 0);
  --
  SIGNAL sample_f0_1_ren   : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f0_1_rdata : STD_LOGIC_VECTOR((5*18)-1 DOWNTO 0);
  SIGNAL sample_f0_1_full  : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f0_1_empty : STD_LOGIC_VECTOR(4 DOWNTO 0);
  -----------------------------------------------------------------------------
  -- f1
  SIGNAL sample_f1_wen     : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f1_wdata   : STD_LOGIC_VECTOR((5*18)-1 DOWNTO 0);
  --
  SIGNAL sample_f1_ren     : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f1_rdata   : STD_LOGIC_VECTOR((5*18)-1 DOWNTO 0);
  SIGNAL sample_f1_full    : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f1_empty   : STD_LOGIC_VECTOR(4 DOWNTO 0);
  -----------------------------------------------------------------------------
  -- f2
  SIGNAL sample_f2_wen     : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f2_wdata   : STD_LOGIC_VECTOR((5*18)-1 DOWNTO 0);
  -----------------------------------------------------------------------------
  -- f3
  SIGNAL sample_f3_wen     : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f3_wdata   : STD_LOGIC_VECTOR((5*18)-1 DOWNTO 0);
  --
  SIGNAL sample_f3_ren     : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f3_rdata   : STD_LOGIC_VECTOR((5*18)-1 DOWNTO 0);
  SIGNAL sample_f3_full    : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f3_empty   : STD_LOGIC_VECTOR(4 DOWNTO 0);
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- SPECTRAL MATRIX
  -----------------------------------------------------------------------------
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

      sample_f0_0_wen => sample_f0_0_wen,
      sample_f0_1_wen => sample_f0_1_wen,
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
  
  lppFIFO_f0_0 : lppFIFOxN
    GENERIC MAP (
      tech         => tech,
      Data_sz      => 18,
      FifoCnt      => 5,
      Enable_ReUse => '0')
    PORT MAP (
      rst   => rstn,
      wclk  => clk,
      rclk  => clk,
      ReUse => (OTHERS => '0'),

      wen   => sample_f0_0_wen,
      ren   => sample_f0_0_ren,
      wdata => sample_f0_wdata,
      rdata => sample_f0_0_rdata,
      full  => sample_f0_0_full,
      empty => sample_f0_0_empty);

  lppFIFO_f0_1 : lppFIFOxN
    GENERIC MAP (
      tech         => tech,
      Data_sz      => 18,
      FifoCnt      => 5,
      Enable_ReUse => '0')
    PORT MAP (
      rst   => rstn,
      wclk  => clk,
      rclk  => clk,
      ReUse => (OTHERS => '0'),

      wen   => sample_f0_1_wen,
      ren   => sample_f0_1_ren,
      wdata => sample_f0_wdata,
      rdata => sample_f0_1_rdata,
      full  => sample_f0_1_full,
      empty => sample_f0_1_empty);

  lppFIFO_f1 : lppFIFOxN
    GENERIC MAP (
      tech         => tech,
      Data_sz      => 18,
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

  lppFIFO_f3 : lppFIFOxN
    GENERIC MAP (
      tech         => tech,
      Data_sz      => 18,
      FifoCnt      => 5,
      Enable_ReUse => '0')
    PORT MAP (
      rst   => rstn,
      wclk  => clk,
      rclk  => clk,
      ReUse => (OTHERS => '0'),

      wen   => sample_f3_wen,
      ren   => sample_f3_ren,
      wdata => sample_f3_wdata,
      rdata => sample_f3_rdata,
      full  => sample_f3_full,
      empty => sample_f3_empty);

  -----------------------------------------------------------------------------
  -- SPECTRAL MATRIX
  -----------------------------------------------------------------------------

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
      HCLK                                   => clk,
      HRESETn                                => rstn,
      apbi                                   => apbi,
      apbo                                   => apbo,
      
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

  
  --TODO : add the irq alert for DMA matrix transfert ending
  --TODO : add 5 bit register into APB to control the DATA SHIPING
  --TODO : add Spectral Matrix (FFT + SP)
  --TODO : add DMA for WaveForms Picker
  --TODO : add APB Reg to control WaveForms Picker
  --TODO : add WaveForms Picker
  
END tb;
