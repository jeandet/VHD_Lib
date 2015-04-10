LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY lpp;
USE lpp.apb_devices_list.ALL;
USE lpp.lpp_ad_conv.ALL;
USE lpp.iir_filter.ALL;
USE lpp.FILTERcfg.ALL;
USE lpp.lpp_memory.ALL;
--USE lpp.lpp_waveform_pkg.ALL;
USE lpp.lpp_dma_pkg.ALL;
--USE lpp.lpp_top_lfr_pkg.ALL;
--USE lpp.lpp_lfr_pkg.ALL;
USE lpp.general_purpose.ALL;

LIBRARY techmap;
USE techmap.gencomp.ALL;

LIBRARY grlib;
USE grlib.amba.ALL;
USE grlib.stdlib.ALL;
USE grlib.devices.ALL;
USE GRLIB.DMA2AHB_Package.ALL;

ENTITY DMA_SubSystem IS
  
  GENERIC (
    hindex     : INTEGER := 2;
    CUSTOM_DMA : INTEGER := 1);

  PORT (
    clk                            : IN  STD_LOGIC;
    rstn                           : IN  STD_LOGIC;
    run                            : IN  STD_LOGIC;
    -- AHB
    ahbi                           : IN  AHB_Mst_In_Type;
    ahbo                           : OUT AHB_Mst_Out_Type;
    ---------------------------------------------------------------------------
    fifo_burst_valid               : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
    fifo_data                      : IN  STD_LOGIC_VECTOR(32*5-1 DOWNTO 0);
    fifo_ren                       : OUT  STD_LOGIC_VECTOR(4 DOWNTO 0);
    ---------------------------------------------------------------------------
    buffer_new                     : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    buffer_addr                    : IN STD_LOGIC_VECTOR(32*5-1 DOWNTO 0);
    buffer_length                  : IN STD_LOGIC_VECTOR(26*5-1 DOWNTO 0);
    buffer_full                    : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
    buffer_full_err                : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
    ---------------------------------------------------------------------------
    grant_error : OUT STD_LOGIC                               --

    );

END DMA_SubSystem;


ARCHITECTURE beh OF DMA_SubSystem IS

  COMPONENT DMA_SubSystem_GestionBuffer
    GENERIC (
      BUFFER_ADDR_SIZE   : INTEGER;
      BUFFER_LENGTH_SIZE : INTEGER);
    PORT (
      clk             : IN  STD_LOGIC;
      rstn            : IN  STD_LOGIC;
      run             : IN  STD_LOGIC;
      buffer_new      : IN  STD_LOGIC;
      buffer_addr     : IN  STD_LOGIC_VECTOR(BUFFER_ADDR_SIZE-1 DOWNTO 0);
      buffer_length   : IN  STD_LOGIC_VECTOR(BUFFER_LENGTH_SIZE-1 DOWNTO 0);
      buffer_full     : OUT STD_LOGIC;
      buffer_full_err : OUT STD_LOGIC;
      burst_send      : IN  STD_LOGIC;
      burst_addr      : OUT STD_LOGIC_VECTOR(BUFFER_ADDR_SIZE-1 DOWNTO 0));
  END COMPONENT;

  COMPONENT DMA_SubSystem_Arbiter
    PORT (
      clk                    : IN  STD_LOGIC;
      rstn                   : IN  STD_LOGIC;
      run                    : IN  STD_LOGIC;
      data_burst_valid       : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
      data_burst_valid_grant : OUT STD_LOGIC_VECTOR(4 DOWNTO 0));
  END COMPONENT;

  COMPONENT DMA_SubSystem_MUX
    PORT (
      clk             : IN  STD_LOGIC;
      rstn            : IN  STD_LOGIC;
      run             : IN  STD_LOGIC;
      fifo_grant      : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
      fifo_data       : IN  STD_LOGIC_VECTOR(32*5-1 DOWNTO 0);
      fifo_address    : IN  STD_LOGIC_VECTOR(32*5-1 DOWNTO 0);
      fifo_ren        : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
      fifo_burst_done : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
      dma_send        : OUT STD_LOGIC;
      dma_valid_burst : OUT STD_LOGIC;
      dma_address     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      dma_data        : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      dma_ren         : IN  STD_LOGIC;
      dma_done        : IN  STD_LOGIC;
      grant_error     : OUT STD_LOGIC);
  END COMPONENT;
  
  -----------------------------------------------------------------------------
  SIGNAL dma_send        : STD_LOGIC;
  SIGNAL dma_valid_burst : STD_LOGIC;   -- (1 => BURST , 0 => SINGLE)
  SIGNAL dma_done        : STD_LOGIC;
  SIGNAL dma_ren         : STD_LOGIC;
  SIGNAL dma_address     : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL dma_data        : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL burst_send      : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL fifo_grant      :  STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL fifo_address    :   STD_LOGIC_VECTOR(32*5-1 DOWNTO 0);  --
  
  
BEGIN  -- beh

  -----------------------------------------------------------------------------
  -- DMA
  -----------------------------------------------------------------------------
  GR_DMA : IF CUSTOM_DMA = 0 GENERATE
    lpp_dma_singleOrBurst_1 : lpp_dma_singleOrBurst
      GENERIC MAP (
        tech   => inferred,
        hindex => hindex)
      PORT MAP (
        HCLK           => clk,
        HRESETn        => rstn,
        run            => run,
        AHB_Master_In  => ahbi,
        AHB_Master_Out => ahbo,

        send        => dma_send,
        valid_burst => dma_valid_burst,
        done        => dma_done,
        ren         => dma_ren,
        address     => dma_address,
        data        => dma_data);
  END GENERATE GR_DMA;

  LPP_DMA_IP : IF CUSTOM_DMA = 1 GENERATE
    lpp_dma_SEND16B_FIFO2DMA_1 : lpp_dma_SEND16B_FIFO2DMA
      GENERIC MAP (
        hindex   => hindex,
        vendorid => VENDOR_LPP,
        deviceid => 10,
        version  => 0)
      PORT MAP (
        clk            => clk,
        rstn           => rstn,
        AHB_Master_In  => ahbi,
        AHB_Master_Out => ahbo,

        ren         => dma_ren,
        data        => dma_data,
        send        => dma_send,
        valid_burst => dma_valid_burst,
        done        => dma_done,
        address     => dma_address);
  END GENERATE LPP_DMA_IP;


  -----------------------------------------------------------------------------
  -- RoundRobin Selection Channel For DMA
  -----------------------------------------------------------------------------
  DMA_SubSystem_Arbiter_1: DMA_SubSystem_Arbiter
    PORT MAP (
      clk                    => clk,
      rstn                   => rstn,
      run                    => run,
      data_burst_valid       => fifo_burst_valid,
      data_burst_valid_grant => fifo_grant);


  -----------------------------------------------------------------------------
  -- Mux between the channel from Waveform Picker and Spectral Matrix
  -----------------------------------------------------------------------------
  DMA_SubSystem_MUX_1: DMA_SubSystem_MUX
    PORT MAP (
      clk             => clk,
      rstn            => rstn,
      run             => run,
      
      fifo_grant      => fifo_grant,
      fifo_data       => fifo_data,
      fifo_address    => fifo_address,
      fifo_ren        => fifo_ren,
      fifo_burst_done => burst_send,
      
      dma_send        => dma_send,
      dma_valid_burst => dma_valid_burst,
      dma_address     => dma_address,
      dma_data        => dma_data,
      dma_ren         => dma_ren,
      dma_done        => dma_done,
      
      grant_error     => grant_error);
  
  
  -----------------------------------------------------------------------------
  -- GEN ADDR
  -----------------------------------------------------------------------------
  all_buffer : FOR I IN 4 DOWNTO 0 GENERATE
    DMA_SubSystem_GestionBuffer_I : DMA_SubSystem_GestionBuffer
      GENERIC MAP (
        BUFFER_ADDR_SIZE   => 32,
        BUFFER_LENGTH_SIZE => 26)
      PORT MAP (
        clk  => clk,
        rstn => rstn,
        run  => run,

        buffer_new      => buffer_new(I),
        buffer_addr     => buffer_addr(32*(I+1)-1 DOWNTO I*32),
        buffer_length   => buffer_length(26*(I+1)-1 DOWNTO I*26),
        buffer_full     => buffer_full(I),
        buffer_full_err => buffer_full_err(I),

        burst_send => burst_send(I),
        burst_addr => fifo_address(32*(I+1)-1 DOWNTO 32*I)
        );
  END GENERATE all_buffer;


  
END beh;
