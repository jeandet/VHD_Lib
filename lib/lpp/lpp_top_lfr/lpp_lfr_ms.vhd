LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

LIBRARY lpp;
USE lpp.lpp_amba.ALL;
USE lpp.lpp_memory.ALL;
--USE lpp.lpp_uart.ALL;
USE lpp.lpp_matrix.ALL;
--USE lpp.lpp_delay.ALL;
USE lpp.lpp_fft.ALL;
USE lpp.fft_components.ALL;
USE lpp.lpp_ad_conv.ALL;
USE lpp.iir_filter.ALL;
USE lpp.general_purpose.ALL;
USE lpp.Filtercfg.ALL;
USE lpp.lpp_demux.ALL;
USE lpp.lpp_top_lfr_pkg.ALL;
USE lpp.lpp_dma_pkg.ALL;
USE lpp.lpp_Header.ALL;
USE lpp.lpp_lfr_pkg.ALL;

LIBRARY grlib;
USE grlib.amba.ALL;
USE grlib.stdlib.ALL;
USE grlib.devices.ALL;
USE GRLIB.DMA2AHB_Package.ALL;


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
    coarse_time     : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);  -- todo
    fine_time       : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);  -- todo
    --
    sample_f0_wen   : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    sample_f0_wdata : IN STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
    --
    sample_f1_wen   : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    sample_f1_wdata : IN STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
    --
    sample_f3_wen   : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    sample_f3_wdata : IN STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);

    ---------------------------------------------------------------------------
    -- DMA
    ---------------------------------------------------------------------------
    dma_addr        : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    dma_data        : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    dma_valid       : OUT STD_LOGIC;
    dma_valid_burst : OUT STD_LOGIC;
    dma_ren         : IN STD_LOGIC;
    dma_done        : IN STD_LOGIC;

    -- Reg out
    ready_matrix_f0_0             : OUT STD_LOGIC;
    ready_matrix_f0_1             : OUT STD_LOGIC;
    ready_matrix_f1               : OUT STD_LOGIC;
    ready_matrix_f2               : OUT STD_LOGIC;
    error_anticipating_empty_fifo : OUT STD_LOGIC;
    error_bad_component_error     : OUT STD_LOGIC;
    debug_reg                     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

    -- Reg In
    status_ready_matrix_f0_0             :IN  STD_LOGIC;
    status_ready_matrix_f0_1             :IN  STD_LOGIC;
    status_ready_matrix_f1               :IN  STD_LOGIC;
    status_ready_matrix_f2               :IN  STD_LOGIC;
    status_error_anticipating_empty_fifo :IN  STD_LOGIC;
    status_error_bad_component_error     :IN  STD_LOGIC;
                                          
    config_active_interruption_onNewMatrix : IN STD_LOGIC;
    config_active_interruption_onError     : IN STD_LOGIC;
    addr_matrix_f0_0                       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_matrix_f0_1                       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_matrix_f1                         : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_matrix_f2                         : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

    matrix_time_f0_0                       : OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
    matrix_time_f0_1                       : OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
    matrix_time_f1                         : OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
    matrix_time_f2                         : OUT STD_LOGIC_VECTOR(47 DOWNTO 0)
    
    );
END;

ARCHITECTURE Behavioral OF lpp_lfr_ms IS
  -----------------------------------------------------------------------------
  SIGNAL FifoF0_Empty : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL FifoF1_Empty : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL FifoF3_Empty : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL FifoF0_Data  : STD_LOGIC_VECTOR(79 DOWNTO 0);
  SIGNAL FifoF1_Data  : STD_LOGIC_VECTOR(79 DOWNTO 0);
  SIGNAL FifoF3_Data  : STD_LOGIC_VECTOR(79 DOWNTO 0);
  
  -----------------------------------------------------------------------------
  SIGNAL DMUX_Read     : STD_LOGIC_VECTOR(14 DOWNTO 0);
  SIGNAL DMUX_Empty    : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL DMUX_Data     : STD_LOGIC_VECTOR(79 DOWNTO 0);
  SIGNAL DMUX_WorkFreq : STD_LOGIC_VECTOR(1 DOWNTO 0);

  -----------------------------------------------------------------------------
  SIGNAL FFT_Load  : STD_LOGIC;
  SIGNAL FFT_Read  : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL FFT_Write : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL FFT_ReUse : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL FFT_Data  : STD_LOGIC_VECTOR(79 DOWNTO 0);

  -----------------------------------------------------------------------------
  SIGNAL FifoINT_Full : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL FifoINT_Data : STD_LOGIC_VECTOR(79 DOWNTO 0);

  -----------------------------------------------------------------------------
  SIGNAL SM_FlagError : STD_LOGIC;
--  SIGNAL SM_Pong      : STD_LOGIC;
  SIGNAL SM_Wen       : STD_LOGIC;
  SIGNAL SM_Read      : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL SM_Write     : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL SM_ReUse     : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL SM_Param     : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL SM_Data      : STD_LOGIC_VECTOR(63 DOWNTO 0);

  -----------------------------------------------------------------------------
  SIGNAL FifoOUT_Full  : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL FifoOUT_Empty : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL FifoOUT_Data  : STD_LOGIC_VECTOR(63 DOWNTO 0);

  -----------------------------------------------------------------------------
  SIGNAL Head_Read   : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL Head_Data   : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL Head_Empty  : STD_LOGIC;
  SIGNAL Head_Header : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL Head_Valid  : STD_LOGIC;
  SIGNAL Head_Val    : STD_LOGIC;

  -----------------------------------------------------------------------------
  SIGNAL   DMA_Read  : STD_LOGIC;
  SIGNAL   DMA_ack   : STD_LOGIC;
  
  -----------------------------------------------------------------------------
  SIGNAL data_time   : STD_LOGIC_VECTOR(47 DOWNTO 0);

  SIGNAL debug_reg_s : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL dma_valid_s       : STD_LOGIC;
  SIGNAL dma_valid_burst_s : STD_LOGIC;
  
BEGIN

  -----------------------------------------------------------------------------
  Memf0: lppFIFOxN
    GENERIC MAP (
      tech         => 0, Mem_use      => Mem_use, Data_sz      => 16,
      Addr_sz      => 9, FifoCnt      => 5,       Enable_ReUse => '0')
    PORT MAP (
      rstn   => rstn, wclk  => clk, rclk  => clk,
      ReUse => (OTHERS => '0'),
      wen   => sample_f0_wen,   ren   => DMUX_Read(4 DOWNTO 0),
      wdata => sample_f0_wdata, rdata => FifoF0_Data,
      full  => OPEN,            empty => FifoF0_Empty);
  
  Memf1: lppFIFOxN
    GENERIC MAP (
      tech         => 0, Mem_use      => Mem_use, Data_sz      => 16,
      Addr_sz      => 8, FifoCnt      => 5,       Enable_ReUse => '0')
    PORT MAP (
      rstn   => rstn, wclk  => clk, rclk  => clk,
      ReUse => (OTHERS => '0'),
      wen   => sample_f1_wen,   ren   => DMUX_Read(9 DOWNTO 5),
      wdata => sample_f1_wdata, rdata => FifoF1_Data,
      full  => OPEN,            empty => FifoF1_Empty);
  
  
  Memf2: lppFIFOxN
    GENERIC MAP (
      tech         => 0, Mem_use      => Mem_use, Data_sz      => 16,
      Addr_sz      => 8, FifoCnt      => 5,       Enable_ReUse => '0')
    PORT MAP (
      rstn   => rstn, wclk  => clk, rclk  => clk,
      ReUse => (OTHERS => '0'),
      wen   => sample_f3_wen,   ren   => DMUX_Read(14 DOWNTO 10),
      wdata => sample_f3_wdata, rdata => FifoF3_Data,
      full  => OPEN,            empty => FifoF3_Empty);
  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  DMUX0 : DEMUX
    GENERIC MAP (
      Data_sz => 16)
    PORT MAP (
      clk        => clk,
      rstn       => rstn,
      Read       => FFT_Read,
      Load       => FFT_Load,
      EmptyF0    => FifoF0_Empty,
      EmptyF1    => FifoF1_Empty,
      EmptyF2    => FifoF3_Empty,
      DataF0     => FifoF0_Data,
      DataF1     => FifoF1_Data,
      DataF2     => FifoF3_Data,
      WorkFreq   => DMUX_WorkFreq,
      Read_DEMUX => DMUX_Read,
      Empty      => DMUX_Empty,
      Data       => DMUX_Data);
  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  FFT0: FFT
    GENERIC MAP (
      Data_sz => 16,
      NbData  => 256)
    PORT MAP (
      clkm         => clk,
      rstn         => rstn,
      FifoIN_Empty => DMUX_Empty,  
      FifoIN_Data  => DMUX_Data,   
      FifoOUT_Full => FifoINT_Full,
      Load         => FFT_Load,
      Read         => FFT_Read,
      Write        => FFT_Write,
      ReUse        => FFT_ReUse,
      Data         => FFT_Data);
  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  MemInt : lppFIFOxN
    GENERIC MAP (
      tech         => 0,
      Mem_use      => Mem_use,
      Data_sz      => 16,
      Addr_sz      => 8,
      FifoCnt      => 5,
      Enable_ReUse => '1')
    PORT MAP (
      rstn   => rstn,
      wclk  => clk,
      rclk  => clk,
      ReUse => SM_ReUse,
      wen   => FFT_Write,
      ren   => SM_Read,
      wdata => FFT_Data,
      rdata => FifoINT_Data,
      full  => FifoINT_Full,
      empty => OPEN);
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  SM0 : MatriceSpectrale
    GENERIC MAP (
      Input_SZ  => 16,
      Result_SZ => 32)
    PORT MAP (
      clkm        => clk,
      rstn        => rstn,
      FifoIN_Full => FifoINT_Full,      --
      SetReUse    => FFT_ReUse,         --
      Valid       => Head_Valid,        -- HeaderBuilder
      Data_IN     => FifoINT_Data,      --
      ACK         => DMA_ack,           -- HeaderBuilder
      SM_Write    => SM_Wen,            -- HeaderBuilder
      FlagError   => SM_FlagError,      -- UNUSED
--      Pong        => SM_Pong,      
      Statu       => SM_Param,          -- HeaderBuilder
      Write       => SM_Write,          -- FIFO MemOut
      Read        => SM_Read,           --
      ReUse       => SM_ReUse,          --
      Data_OUT    => SM_Data);          -- FIFO MemOut
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  MemOut : lppFIFOxN
    GENERIC MAP (
      tech         => 0,
      Mem_use      => Mem_use,
      Data_sz      => 32,
      Addr_sz      => 8,
      FifoCnt      => 2,
      Enable_ReUse => '0')
    PORT MAP (
      rstn   => rstn,
      wclk  => clk,
      rclk  => clk,
      ReUse => (OTHERS => '0'),
      wen   => SM_Write,
      ren   => Head_Read,
      wdata => SM_Data,
      rdata => FifoOUT_Data,
      full  => FifoOUT_Full,
      empty => FifoOUT_Empty);
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  Head0 : HeaderBuilder
    GENERIC MAP (
      Data_sz => 32)
    PORT MAP (
      clkm         => clk,
      rstn         => rstn,
--      pong         => SM_Pong,
      Statu        => SM_Param,
      Matrix_Type  => DMUX_WorkFreq, 
      Matrix_Write => SM_Wen, 
      Valid        => Head_Valid,
      
      dataIN       => FifoOUT_Data, 
      emptyIN      => FifoOUT_Empty, 
      RenOUT       => Head_Read,
      
      dataOUT      => Head_Data, 
      emptyOUT     => Head_Empty, 
      RenIN        => DMA_Read,
      
      header       => Head_Header,
      header_val   => Head_Val,
      header_ack   => DMA_ack );
  -----------------------------------------------------------------------------
  data_time(31 DOWNTO  0) <= coarse_time;
  data_time(47 DOWNTO 32) <= fine_time;

  lpp_lfr_ms_fsmdma_1: lpp_lfr_ms_fsmdma
    PORT MAP (
      HCLK                                   => clk,
      HRESETn                                => rstn,
      
      data_time                              => data_time,
      
      fifo_data                              => Head_Data,
      fifo_empty                             => Head_Empty,
      fifo_ren                               => DMA_Read,
      
      header                                 => Head_Header, 
      header_val                             => Head_Val,    
      header_ack                             => DMA_ack,     
      
      dma_addr                               => dma_addr,
      dma_data                               => dma_data,
      dma_valid                              => dma_valid_s,
      dma_valid_burst                        => dma_valid_burst_s,
      dma_ren                                => dma_ren,
      dma_done                               => dma_done,
      
      ready_matrix_f0_0                      => ready_matrix_f0_0,
      ready_matrix_f0_1                      => ready_matrix_f0_1,
      ready_matrix_f1                        => ready_matrix_f1,
      ready_matrix_f2                        => ready_matrix_f2,
      error_anticipating_empty_fifo          => error_anticipating_empty_fifo,
      error_bad_component_error              => error_bad_component_error,
      debug_reg                              => debug_reg_s,
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

      matrix_time_f0_0                       => matrix_time_f0_0,
      matrix_time_f0_1                       => matrix_time_f0_1,
      matrix_time_f1                         => matrix_time_f1,
      matrix_time_f2                         => matrix_time_f2
      );

  dma_valid       <= dma_valid_s;
  dma_valid_burst <= dma_valid_burst_s;
  
  debug_reg(9 DOWNTO 0)   <= debug_reg_s(9 DOWNTO 0);
  debug_reg(10)           <= Head_Empty;
  debug_reg(11)           <= DMA_Read;
  debug_reg(12)           <= Head_Val;
  debug_reg(13)           <= DMA_ack;
  debug_reg(14)           <= dma_ren;
  debug_reg(15)           <= dma_done;
  debug_reg(16)           <= dma_valid_s;
  debug_reg(17)           <= dma_valid_burst_s;
  debug_reg(31 DOWNTO 18) <= (OTHERS => '0');
  
  
  
END Behavioral;
