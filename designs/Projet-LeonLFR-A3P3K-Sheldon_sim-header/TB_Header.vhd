LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

LIBRARY lpp;
USE lpp.lpp_ad_conv.ALL;
USE lpp.lpp_Header.ALL;
USE lpp.lpp_dma_pkg.ALL;
use lpp.lpp_amba.all;
use lpp.lpp_memory.all;
use lpp.lpp_uart.all;
use lpp.lpp_matrix.all;
use lpp.lpp_delay.all;
use lpp.lpp_fft.all;
use lpp.fft_components.all;
use lpp.lpp_ad_conv.all;
use lpp.iir_filter.all;
use lpp.general_purpose.all;
use lpp.Filtercfg.all;
use lpp.lpp_demux.all;
use lpp.lpp_top_lfr_pkg.all;

LIBRARY grlib;
USE grlib.amba.ALL;
USE grlib.stdlib.ALL;
USE grlib.devices.ALL;
USE GRLIB.DMA2AHB_Package.ALL;

LIBRARY techmap;
USE techmap.gencomp.ALL;

-------------------------------------------------------------------------------

ENTITY TB_Header IS

END TB_Header;

-------------------------------------------------------------------------------

ARCHITECTURE tb OF TB_Header IS

  COMPONENT TestModule_ADS7886
    GENERIC (
      freq      : INTEGER;
      amplitude : INTEGER;
      impulsion : INTEGER);
    PORT (
      cnv_run : IN  STD_LOGIC;
      cnv     : IN  STD_LOGIC;
      sck     : IN  STD_LOGIC;
      sdo     : OUT STD_LOGIC);
  END COMPONENT;

  -- component ports
  SIGNAL cnv_rstn : STD_LOGIC;
  SIGNAL cnv      : STD_LOGIC;
  SIGNAL rstn     : STD_LOGIC;
  SIGNAL sck      : STD_LOGIC;
  SIGNAL sdo      : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL run_cnv  : STD_LOGIC;


  -- clock
  SIGNAL Clk     : STD_LOGIC := '1';
  SIGNAL cnv_clk : STD_LOGIC := '1';

  -----------------------------------------------------------------------------
-- FIFOs
  SIGNAL FifoF0_Empty : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL FifoF0_Data  : STD_LOGIC_VECTOR(79 DOWNTO 0);
  SIGNAL FifoF1_Empty : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL FifoF1_Data  : STD_LOGIC_VECTOR(79 DOWNTO 0);
  SIGNAL FifoF3_Empty : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL FifoF3_Data  : STD_LOGIC_VECTOR(79 DOWNTO 0);

  SIGNAL FifoINT_Full : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL FifoINT_Data : STD_LOGIC_VECTOR(79 DOWNTO 0);

  SIGNAL FifoOUT_Full : STD_LOGIC_VECTOR(1 DOWNTO 0);

-- MATRICE SPECTRALE
  SIGNAL SM_FlagError : STD_LOGIC;
  SIGNAL SM_Pong      : STD_LOGIC;
  SIGNAL SM_Read      : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL SM_Write     : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL SM_ReUse     : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL SM_Param     : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL SM_Data      : STD_LOGIC_VECTOR(63 DOWNTO 0);

  SIGNAL Dma_acq : STD_LOGIC;

-- FFT
  SIGNAL FFT_Load  : STD_LOGIC;
  SIGNAL FFT_Read  : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL FFT_Write : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL FFT_ReUse : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL FFT_Data  : STD_LOGIC_VECTOR(79 DOWNTO 0);

-- DEMUX
  SIGNAL DEMU_Read  : STD_LOGIC_VECTOR(14 DOWNTO 0);
  SIGNAL DEMU_Empty : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL DEMU_Data  : STD_LOGIC_VECTOR(79 DOWNTO 0);

-- ACQ
  SIGNAL sample_val : STD_LOGIC;
  SIGNAL sample     : Samples(8-1 DOWNTO 0);

  SIGNAL TopACQ_WenF0  : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL TopACQ_DataF0 : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
  SIGNAL TopACQ_WenF1  : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL TopACQ_DataF1 : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
  SIGNAL TopACQ_WenF3  : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL TopACQ_DataF3 : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);

  -----------------------------------------------------------------------------
  SIGNAL pong         : STD_LOGIC;
  SIGNAL Statu        : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL Matrix_Type  : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL Matrix_Write : STD_LOGIC;
  SIGNAL Valid        : STD_LOGIC;
  SIGNAL dataIN       : STD_LOGIC_VECTOR((2*Data_sz)-1 DOWNTO 0);
  SIGNAL emptyIN      : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL RenOUT       : STD_LOGIC_VECTOR(1 DOWNTO 0);

  -----------------------------------------------------------------------------

  SIGNAL AHB_Master_In  : AHB_Mst_In_Type;
  SIGNAL AHB_Master_Out : AHB_Mst_Out_Type;

  -----------------------------------------------------------------------------
  SIGNAL fifo_data                              : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL fifo_empty                             : STD_LOGIC;
  SIGNAL fifo_ren                               : STD_LOGIC;
  SIGNAL header                                 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL header_val                             : STD_LOGIC;
  SIGNAL header_ack                             : STD_LOGIC;
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
  
BEGIN  -- tb

  MODULE_ADS7886 : FOR I IN 0 TO 6 GENERATE
    TestModule_ADS7886_u : TestModule_ADS7886
      GENERIC MAP (
        freq      => 24*(I+1),
        amplitude => 30000/(I+1),
        impulsion => 0)
      PORT MAP (
        cnv_run => run_cnv,
        cnv     => cnv,
        sck     => sck,
        sdo     => sdo(I));
  END GENERATE MODULE_ADS7886;

  TestModule_ADS7886_u : TestModule_ADS7886
    GENERIC MAP (
      freq      => 0,
      amplitude => 30000,
      impulsion => 1)
    PORT MAP (
      cnv_run => run_cnv,
      cnv     => cnv,
      sck     => sck,
      sdo     => sdo(7));


  -- clock generation
  Clk     <= NOT Clk     AFTER 20 ns;     -- 25     Mhz
  cnv_clk <= NOT cnv_clk AFTER 10173 ps;  -- 49.152 MHz

  -- waveform generation
  WaveGen_Proc : PROCESS
  BEGIN
    -- insert signal assignments here
    WAIT UNTIL Clk = '1';
    rstn     <= '0';
    cnv_rstn <= '0';
    run_cnv  <= '0';
    WAIT UNTIL Clk = '1';
    WAIT UNTIL Clk = '1';
    WAIT UNTIL Clk = '1';
    rstn     <= '1';
    cnv_rstn <= '1';
    WAIT UNTIL Clk = '1';
    WAIT UNTIL Clk = '1';
    WAIT UNTIL Clk = '1';
    WAIT UNTIL Clk = '1';
    WAIT UNTIL Clk = '1';
    WAIT UNTIL Clk = '1';
    run_cnv  <= '1';
    WAIT;

  END PROCESS WaveGen_Proc;

  -----------------------------------------------------------------------------

  TopACQ : lpp_top_acq
    PORT MAP(run_cnv, cnv,sck, sdo, cnv_clk, rstn, clk, rstn, TopACQ_WenF0, TopACQ_DataF0, TopACQ_WenF1, TopACQ_DataF1, OPEN, OPEN, TopACQ_WenF3, TopACQ_DataF3);

  Bias_Fails <= '0';
  Memf0 : lppFIFOxN
    GENERIC MAP(Data_sz              => 16, Addr_sz => 9, FifoCnt => 5, Enable_ReUse => '0')
    PORT MAP(rstn, clk, clk, (OTHERS => '0'), TopACQ_WenF0, DEMU_Read(4 DOWNTO 0), TopACQ_DataF0, FifoF0_Data, OPEN, FifoF0_Empty);
  
  Memf1 : lppFIFOxN
    GENERIC MAP(Data_sz              => 16, Addr_sz => 8, FifoCnt => 5, Enable_ReUse => '0')
    PORT MAP(rstn, clk, clk, (OTHERS => '0'), TopACQ_WenF1, DEMU_Read(9 DOWNTO 5), TopACQ_DataF1, FifoF1_Data, OPEN, FifoF1_Empty);
  
  Memf3 : lppFIFOxN
    GENERIC MAP(Data_sz              => 16, Addr_sz => 8, FifoCnt => 5, Enable_ReUse => '0')
    PORT MAP(rstn, clk, clk, (OTHERS => '0'), TopACQ_WenF3, DEMU_Read(14 DOWNTO 10), TopACQ_DataF3, FifoF3_Data, OPEN, FifoF3_Empty);

--- DEMUX -------------------------------------------------------------

  DEMU0 : DEMUX
    GENERIC MAP(Data_sz => 16)
    PORT MAP(clk, rstn, FFT_Read, FFT_Load, FifoF0_Empty, FifoF1_Empty, FifoF3_Empty, FifoF0_Data, FifoF1_Data, FifoF3_Data,Matrix_Type ,DEMU_Read, DEMU_Empty, DEMU_Data);

--- FFT -------------------------------------------------------------

  FFT0 : FFT
    GENERIC MAP(Data_sz => 16, NbData => 256)
    PORT MAP(clk, rstn, DEMU_Empty, DEMU_Data, FifoINT_Full, FFT_Load, FFT_Read, FFT_Write, FFT_ReUse, FFT_Data);

----- LINK MEMORY -------------------------------------------------------

  MemInt : lppFIFOxN
    GENERIC MAP(Data_sz => 16, FifoCnt => 5, Enable_ReUse => '1')
    PORT MAP(rstn, clk, clk, SM_ReUse, FFT_Write, SM_Read, FFT_Data, FifoINT_Data, FifoINT_Full, OPEN);

----- MATRICE SPECTRALE ---------------------5 FIFO Input---------------

  SM0 : MatriceSpectrale
    GENERIC MAP(Input_SZ => 16, Result_SZ => 32)
    PORT MAP(clk, rstn, FifoINT_Full, FFT_ReUse,Valid,-- FifoOUT_Full,
             FifoINT_Data, Dma_acq, Matrix_Write,SM_FlagError, SM_Pong, SM_Param,
             SM_Write, SM_Read, SM_ReUse, SM_Data);

  Dma_acq <= '1';

  MemOut : APB_FIFO
    GENERIC MAP (pindex                    => 9, paddr => 9, FifoCnt => 2, Data_sz => 32, Addr_sz => 8, Enable_ReUse => '0', R => 1, W => 0)
    PORT MAP (clk, rstn, clk, clk, (OTHERS => '0'), RenOUT, SM_Write, emptyIN, FifoOUT_Full, dataIN, SM_Data, OPEN, OPEN, apbi, apbo(9));


  -----------------------------------------------------------------------------
  HeaderBuilder_1 : HeaderBuilder
    GENERIC MAP (
      Data_sz => Data_sz)
    PORT MAP (
      clkm => clk,
      rstn => rstn,

      pong         => SM_Pong,--pong,
      Statu        => SM_Param,--Statu,
      Matrix_Type  => Matrix_Type,      -- 
      Matrix_Write => Matrix_Write,
      Valid        => Valid,
      
      dataIN       => dataIN,
      emptyIN      => emptyIN,
      RenOUT       => RenOUT,

      dataOUT  => fifo_data,
      emptyOUT => fifo_empty,
      RenIN    => fifo_ren,

      header     => header,
      header_val => header_val,
      header_ack => header_ack);
  -----------------------------------------------------------------------------
  lpp_dma_ip_1 : lpp_dma_ip
    GENERIC MAP (
      tech   => 0,
      hindex => 2)
    PORT MAP (
      HCLK           => clk,
      HRESETn        => rstn,
      AHB_Master_In  => AHB_Master_In,
      AHB_Master_Out => AHB_Master_Out,

      fifo_data                              => fifo_data,
      fifo_empty                             => fifo_empty,
      fifo_ren                               => fifo_ren,
      header                                 => header,
      header_val                             => header_val,
      header_ack                             => header_ack,
      --OUT
      ready_matrix_f0_0                      => ready_matrix_f0_0,
      ready_matrix_f0_1                      => ready_matrix_f0_1,
      ready_matrix_f1                        => ready_matrix_f1,
      ready_matrix_f2                        => ready_matrix_f2,
      error_anticipating_empty_fifo          => error_anticipating_empty_fifo,
      error_bad_component_error              => error_bad_component_error,
      debug_reg                              => debug_reg,
      -- IN
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
  AHB_Master_In.HGRANT(2) <= '1';
  AHB_Master_In.HREADY    <= '1';


  AHB_Master_In.HRESP <= HRESP_OKAY;


END tb;
