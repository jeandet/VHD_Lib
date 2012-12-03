
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

ENTITY lpp_dma_send_16word IS
  PORT (
    -- AMBA AHB system signals
    HCLK    : IN STD_ULOGIC;
    HRESETn : IN STD_ULOGIC;

    -- DMA
    DMAIn  : OUT DMA_In_Type;
    DMAOut : IN  DMA_OUt_Type;

    -- 
    send    : IN  STD_LOGIC;
    address : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    data    : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    ren     : OUT  STD_LOGIC;
    --
    send_ok : OUT STD_LOGIC;
    send_ko : OUT STD_LOGIC
    );  
END lpp_dma_send_16word;

ARCHITECTURE beh OF lpp_dma_send_16word IS
  
  TYPE   state_fsm_send_16word IS (IDLE, REQUEST_BUS, SEND_DATA, ERROR0, ERROR1,WAIT_LAST_READY);
  SIGNAL state : state_fsm_send_16word;

  SIGNAL data_counter : INTEGER;
  SIGNAL grant_counter : INTEGER;
  
BEGIN  -- beh

  DMAIn.Beat      <= HINCR16;
  DMAIn.Size      <= HSIZE32;

  PROCESS (HCLK, HRESETn)
  BEGIN  -- PROCESS
    IF HRESETn = '0' THEN                 -- asynchronous reset (active low)
      state          <= IDLE;
      send_ok        <= '0';
      send_ko        <= '0';
      
      DMAIn.Reset     <= '0';
      DMAIn.Address   <= (OTHERS => '0');
--      DMAIn.Data      <= (others => '0');
      DMAIn.Request   <= '0';
      DMAIn.Store     <= '0';
      DMAIn.Burst     <= '1';
      DMAIn.Lock      <= '0';
      data_counter    <= 0;
    ELSIF HCLK'EVENT AND HCLK = '1' THEN  -- rising clock edge
      
      CASE state IS
        WHEN IDLE =>
--          ren          <= '1';
          DMAIn.Store   <= '1';
          DMAIn.Request <= '0';
          send_ok      <= '0';
          send_ko      <= '0';
          DMAIn.Address   <= address;
          data_counter    <= 0;
          DMAIn.Lock      <= '0';       -- FIX test
          IF send = '1' THEN
            state        <= REQUEST_BUS;
            DMAIn.Request   <= '1';
            DMAIn.Lock      <= '1'; -- FIX test
            DMAIn.Store     <= '1';    
          END IF;
        WHEN REQUEST_BUS =>
--          ren            <= '1';
          IF DMAOut.Grant='1' THEN
            data_counter        <= 1;
            grant_counter       <= 1;
--          ren                 <= '0';
            state               <= SEND_DATA;
          END IF;
        WHEN SEND_DATA =>
--          ren            <= '1';
          
          IF DMAOut.Fault = '1' THEN
            DMAIn.Reset     <= '0';
            DMAIn.Address   <= (others => '0');
--            DMAIn.Data      <= (others => '0');
            DMAIn.Request   <= '0';
            DMAIn.Store     <= '0';
            DMAIn.Burst     <= '0';
            state        <= ERROR0;
          ELSE
            
            IF DMAOut.Grant = '1' THEN
              if grant_counter = 15 then
                DMAIn.Reset     <= '0';
                DMAIn.Request   <= '0';
                DMAIn.Store     <= '0';
                DMAIn.Burst     <= '0';
              else
                grant_counter  <= grant_counter+1;
              end if;
            END IF;

            IF DMAOut.OKAY = '1' THEN
              IF data_counter = 15 THEN
                DMAIn.Address   <= (others => '0');
                state           <= WAIT_LAST_READY;  
              ELSE
                --DMAIn.Data    <= data;
                data_counter  <= data_counter + 1;
--                ren           <= '0';
              END IF;
            END IF;
          END IF;
            
            
        WHEN WAIT_LAST_READY =>
--          ren          <= '1';
          IF DMAOut.Ready = '1' THEN
            IF grant_counter = 15 THEN
              state   <= IDLE;
              send_ok <= '1';
              send_ko <= '0';
            ELSE
              state <= ERROR0;              
            END IF;
          END IF;
          
        WHEN ERROR0 =>
--          ren   <= '1';
          state <= ERROR1;
        WHEN ERROR1 =>
          send_ok <= '0';
          send_ko <= '1';
--          ren     <= '1';
          state   <= IDLE;          
        WHEN OTHERS => NULL;
      END CASE;
    END IF;
  END PROCESS;

  DMAIn.Data          <= data;

  ren <= '0' WHEN DMAOut.OKAY = '1'    AND state = SEND_DATA  ELSE
         '0' WHEN state = REQUEST_BUS  AND DMAOut.Grant = '1' ELSE
         '1';
  
END beh;
