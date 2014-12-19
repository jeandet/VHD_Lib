LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY lpp;
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

ENTITY DMA_SubSystem_MUX IS

  PORT (
    clk             : IN  STD_LOGIC;
    rstn            : IN  STD_LOGIC;
    run             : IN  STD_LOGIC;
    --
    fifo_grant      : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
    fifo_data       : IN  STD_LOGIC_VECTOR(32*5-1 DOWNTO 0);  --
    fifo_address    : IN  STD_LOGIC_VECTOR(32*5-1 DOWNTO 0);  --
    fifo_ren        : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);       --
    fifo_burst_done : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
    --    
    dma_send        : OUT STD_LOGIC;
    dma_valid_burst : OUT STD_LOGIC;                          --
    dma_address     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);      --
    dma_data        : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);      --
    dma_ren         : IN  STD_LOGIC;                          --
    dma_done        : IN  STD_LOGIC;                          --
    --
    grant_error : OUT STD_LOGIC                               --
    );

END DMA_SubSystem_MUX;

ARCHITECTURE beh OF DMA_SubSystem_MUX IS
  SIGNAL channel_ongoing     : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL one_grant           : STD_LOGIC;
  SIGNAL more_than_one_grant : STD_LOGIC;
  
BEGIN

  one_grant           <= '0' WHEN fifo_grant = "00000" ELSE '1';
  more_than_one_grant <= '0' WHEN fifo_grant = "00000" OR
                                  fifo_grant = "00001" OR
                                  fifo_grant = "00010" OR
                                  fifo_grant = "00100" OR
                                  fifo_grant = "01000" OR
                                  fifo_grant = "10000" ELSE '1';

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      channel_ongoing <= (OTHERS => '0');
      fifo_burst_done <= (OTHERS => '0');
      dma_send        <= '0';
      dma_valid_burst <= '0';
      grant_error     <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
      grant_error     <= '0';
      IF run = '1' THEN
        IF dma_done = '1' THEN
          fifo_burst_done  <= channel_ongoing;
        ELSE
          fifo_burst_done  <= (OTHERS => '0');
        END IF;
        
        IF channel_ongoing = "00000" OR dma_done = '1' THEN
          channel_ongoing <= fifo_grant;
          grant_error     <= more_than_one_grant;
          dma_valid_burst <= one_grant;
          dma_send        <= one_grant;
        ELSE
          dma_send <= '0';
        END IF;
        
      ELSE
        channel_ongoing <= (OTHERS => '0');
        fifo_burst_done <= (OTHERS => '0');
        dma_send        <= '0';
        dma_valid_burst <= '0';      
      END IF;
    END IF;
  END PROCESS;

  -------------------------------------------------------------------------

  all_channel : FOR I IN 4 DOWNTO 0 GENERATE
    fifo_ren(I) <= dma_ren WHEN channel_ongoing(I) = '1' ELSE '1';
  END GENERATE all_channel;

  dma_data <= fifo_data(32*1-1 DOWNTO 32*0) WHEN channel_ongoing(0) = '1' ELSE
              fifo_data(32*2-1 DOWNTO 32*1) WHEN channel_ongoing(1) = '1' ELSE
              fifo_data(32*3-1 DOWNTO 32*2) WHEN channel_ongoing(2) = '1' ELSE
              fifo_data(32*4-1 DOWNTO 32*3) WHEN channel_ongoing(3) = '1' ELSE
              fifo_data(32*5-1 DOWNTO 32*4);  --WHEN channel_ongoing(4) = '1' ELSE
  
  dma_address <= fifo_address(32*1-1 DOWNTO 32*0) WHEN channel_ongoing(0) = '1' ELSE
                 fifo_address(32*2-1 DOWNTO 32*1) WHEN channel_ongoing(1) = '1' ELSE
                 fifo_address(32*3-1 DOWNTO 32*2) WHEN channel_ongoing(2) = '1' ELSE
                 fifo_address(32*4-1 DOWNTO 32*3) WHEN channel_ongoing(3) = '1' ELSE
                 fifo_address(32*5-1 DOWNTO 32*4);  --WHEN channel_ongoing(4) = '1' ELSE
  
END beh;
