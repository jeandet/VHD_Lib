
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
    HCLK     : IN STD_ULOGIC;
    HRESETn  : IN STD_ULOGIC;
    
    fifo_data  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    fifo_empty : IN STD_LOGIC;
    fifo_ren   : OUT STD_LOGIC;

    dma_data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    dma_empty : OUT STD_LOGIC;
    dma_ren  : IN STD_LOGIC
    );

END fifo_latency_correction;

ARCHITECTURE beh OF fifo_latency_correction IS

  SIGNAL valid_s1 : STD_LOGIC;
  SIGNAL valid_s2 : STD_LOGIC;
  
  SIGNAL data_s1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_s2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL dma_data_s : STD_LOGIC_VECTOR(31 DOWNTO 0);


  SIGNAL ren_s1 : STD_LOGIC;
  SIGNAL ren_s2 : STD_LOGIC;

  SIGNAL fifo_ren_s   : STD_LOGIC;
BEGIN  -- beh

    
  --fifo_data    : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
  --fifo_empty   : IN STD_LOGIC;

  --dma_ren  : IN STD_LOGIC

  
  PROCESS (HCLK, HRESETn)
  BEGIN
    IF HRESETn = '0' THEN 
      ren_s1 <= '1';
      ren_s2 <= '1';
    ELSIF HCLK'event AND HCLK = '1' THEN
      ren_s1 <= fifo_ren_s;
      ren_s2 <= fifo_ren_s;    
    END IF;
  END PROCESS;
  fifo_ren <= fifo_ren_s;

  PROCESS (HCLK, HRESETn)
  BEGIN
    IF HRESETn = '0' THEN 
      valid_s1 <= '0'; 
      --data_s1  <= (OTHERS => 'X');  -- TODO just for simulation
      data_s1  <= (OTHERS => '0');
    ELSIF HCLK'event AND HCLK = '1' THEN
      IF valid_s1 = '0' THEN
        IF valid_s2 = '1' AND ren_s2 = '0' AND dma_ren = '1' THEN
          valid_s1 <= '1';
          data_s1  <= fifo_data;
        END IF;
      ELSE
        IF valid_s2 = '0' THEN
          IF ren_s2 = '0' AND dma_ren = '1' THEN
            valid_s1 <= '1';
            data_s1  <= fifo_data;
          ELSE
            valid_s1 <= '0';
--            data_s1  <= (OTHERS => 'X'); -- TODO just for simulation
          END IF;
        ELSE
          IF dma_ren = '1' THEN
            valid_s1 <= '1';
            data_s1  <= data_s1;
          ELSE
            IF ren_s2 = '0' THEN
              valid_s1 <= '1';
              data_s1  <= fifo_data;
            ELSE
              valid_s1 <= '0';
--              data_s1  <= (OTHERS => 'X'); -- TODO just for simulation
            END IF;
          END IF;
        END IF;
      END IF;
    END IF;
  END PROCESS;

  PROCESS (HCLK, HRESETn)
  BEGIN
    IF HRESETn = '0' THEN
      valid_s2 <= '0'; 
--      data_s2  <= (OTHERS => 'X');  -- TODO just for simulation
      data_s2  <= (OTHERS => '0');
    ELSIF HCLK'event AND HCLK = '1' THEN
      IF valid_s2 = '0' THEN
        IF dma_ren = '1' THEN
          IF valid_s1 = '1' THEN
            valid_s2 <= '1';
            data_s2  <= data_s1;
          ELSE
            IF ren_s2 = '0' THEN
              valid_s2 <= '1';
              data_s2  <= fifo_data;
            END IF;
          END IF;
        END IF;
      ELSE
        IF dma_ren = '1' THEN
          valid_s2 <= '1';
          data_s2  <= data_s2;
        ELSE
          IF valid_s1 = '1' THEN
            valid_s2 <= '1';
            data_s2  <= data_s1;
          ELSE
            IF ren_s2 = '0' THEN
              valid_s2 <= '1';
              data_s2  <= fifo_data;
            ELSE
              valid_s2 <= '0'; 
--              data_s2  <= (OTHERS => 'X');  -- TODO just for simulation
            END IF;
          END IF;
        END IF;
      END IF;
    END IF;
  END PROCESS;

--  PROCESS (HCLK, HRESETn)
--  BEGIN
--    IF HRESETn = '0' THEN
--      dma_data <= (OTHERS => 'X');
--    ELSIF HCLK'event AND HCLK = '1' THEN
--      IF valid_s2 = '1' THEN
--        dma_data <= data_s2;
--      ELSIF valid_s1 = '1' THEN
--        dma_data <= data_s1;
--      ELSIF ren_s2 = '0' THEN
--        dma_data <= fifo_data;
--      ELSE
--        dma_data <= (OTHERS => 'X');
--      END IF;
--    END IF;
--  END PROCESS;

  
  
  dma_data_s <= data_s2 WHEN valid_s2 = '1' ELSE
              data_s1 WHEN valid_s1 = '1' ELSE
              fifo_data;

  PROCESS (HCLK, HRESETn)
  BEGIN  -- PROCESS
    IF HRESETn = '0' THEN                 -- asynchronous reset (active low)
      dma_data <= (OTHERS => '0');
    ELSIF HCLK'event AND HCLK = '1' THEN  -- rising clock edge
      IF dma_ren = '0' THEN
        dma_data <= dma_data_s;
      END IF;
    END IF;
  END PROCESS;
  
  fifo_ren_s <= '1' WHEN fifo_empty = '1' ELSE
--                '0' WHEN valid_s1 = '0'  OR valid_s2 = '0' ELSE -- FIX test0
                '0' WHEN (valid_s1 = '0'  OR valid_s2 = '0') AND ren_s2 = '1' ELSE -- FIX test0
                 dma_ren;
  
  dma_empty  <= fifo_empty AND (NOT valid_s1) AND (NOT valid_s2);

END beh;
