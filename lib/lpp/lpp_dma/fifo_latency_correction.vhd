
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
LIBRARY grlib;
USE grlib.amba.ALL;
USE grlib.stdlib.ALL;
USE grlib.devices.ALL;
USE GRLIB.DMA2AHB_Package.ALL;
LIBRARY lpp;
USE lpp.lpp_amba.ALL;
USE lpp.apb_devices_list.ALL;
USE lpp.lpp_memory.ALL;
LIBRARY techmap;
USE techmap.gencomp.ALL;

ENTITY fifo_latency_correction IS
  
  PORT (
    clk     : IN STD_LOGIC;
    rstn    : IN STD_LOGIC;

    FIFO_empty           : IN  STD_LOGIC;
    FIFO_empty_threshold : IN  STD_LOGIC;
    FIFO_ren             : OUT STD_LOGIC;
    FIFO_rdata           : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    
    DMA_ren              : IN STD_LOGIC;
    DMA_data             : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

    DMA_send             : OUT STD_LOGIC;
    DMA_valid_burst      : OUT STD_LOGIC;
    DMA_done             : IN STD_LOGIC
    );

END fifo_latency_correction;

ARCHITECTURE beh OF fifo_latency_correction IS

  SIGNAL  FIFO_empty_d0        : STD_LOGIC := 'U';
  SIGNAL  FIFO_empty_d1        : STD_LOGIC := 'U';

  SIGNAL preloader_armed  : STD_LOGIC := '0';
  SIGNAL preloader_ren    : STD_LOGIC := '1';
  SIGNAL preloader_data   : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');

  signal DMA_ren_d :  STD_LOGIC := '1';

BEGIN  -- beh

    
    DMA_data <= FIFO_rdata when DMA_ren_d = '0' and preloader_armed = '1' else preloader_data;
    FIFO_ren <= preloader_ren and DMA_ren;

    process(rstn, clk)
    begin
      if rstn = '0' then
        FIFO_empty_d0  <= '1';
        FIFO_empty_d1  <= '1';

        preloader_armed  <= '0';
        preloader_ren    <= '1';
        preloader_data   <= FIFO_rdata;

        DMA_send   <= '0';

      elsif rising_edge(clk) then
        DMA_send <= not FIFO_empty_threshold;
        FIFO_empty_d0  <= FIFO_empty;
        FIFO_empty_d1  <= FIFO_empty_d0;
        DMA_ren_d <= DMA_ren;
        preloader_ren      <= '1';
        if FIFO_empty_d0 = '0' and FIFO_empty_d1 = '0' and preloader_armed = '0' then
          preloader_ren   <= '0';
          preloader_armed <= '1';
          preloader_data  <= FIFO_rdata;
        elsif DMA_ren = '0' or preloader_armed = '0' then
          preloader_data  <= FIFO_rdata;
        elsif DMA_done = '1' then
          preloader_armed <= '0';
        end if;
      end if;
    end process;

END beh;
