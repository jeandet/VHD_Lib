LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY MS_control IS
  PORT (
    clk           : IN  STD_LOGIC;
    rstn          : IN  STD_LOGIC;
        
    -- IN
    fifo_in_lock   : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
    fifo_in_data  : IN  STD_LOGIC_VECTOR(32*5-1 DOWNTO 0);
    fifo_in_full  : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
    fifo_in_empty : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
    fifo_in_ren   : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
    fifo_in_reuse : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
    -- OUT
    fifo_out_data  : OUT STD_LOGIC_VECTOR(32*2-1 DOWNTO 0);
    fifo_out_ren   : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
    fifo_out_empty : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    -- OUT
    correlation_start : OUT STD_LOGIC;
    correlation_auto  : OUT STD_LOGIC;   -- 1 => auto correlation / 0 => inter correlation
    correlation_done  : IN  STD_LOGIC
    );
END MS_control;

ARCHITECTURE beh OF MS_control IS

  TYPE fsm_control_MS IS (WAIT_DATA, CORRELATION_ONGOING);
  SIGNAL state : fsm_control_MS;

  SUBTYPE fifo_pointer IS RANGE 0 TO 4;
  SIGNAL fifo_1 : fifo_pointer;
  SIGNAL fifo_2 : fifo_pointer;

  SIGNAL fifo_in_lock_s  : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL fifo_in_reuse_s : STD_LOGIC_VECTOR(4 DOWNTO 0);
  
BEGIN  -- beh

  fifo_in_lock  <= fifo_in_lock_s;
  fifo_in_reuse <= fifo_in_reuse_s;
  
  PROCESS (clk, rstn)
  BEGIN
    IF rstn = '0' THEN
      state <= WAIT_DATA;
      fifo_1  <= 0;
      fifo_2  <= 0;
      fifo_in_lock_s  <= (OTHERS => '0');
      fifo_in_reuse_s <= (OTHERS => '0');
      correlation_start <= '0';
      correlation_auto  <= '0';
    ELSIF clk'event AND clk = '1' THEN
      CASE state IS
        WHEN WAIT_DATA =>
          fifo_in_reuse_s <= (OTHERS => '0');
          IF fifo_in_full[fifo_1] = '1' AND fifo_in_full[fifo_2] = '1' THEN
            fifo_in_lock_s(fifo_1) <= '1';
            fifo_in_lock_s(fifo_2) <= '1';
            correlation_start <= '1';
            IF fifo_1 = fifo_2 THEN
              correlation_auto <= '1';
            END IF;
            state <= CORRELATION_ONGOING;
          END IF;

        WHEN CORRELATION_ONGOING =>
            correlation_start <= '0';
            correlation_auto  <= '0';
            IF correlation_done = '1' THEN
              state <= WAIT_DATA;
              IF fifo_2 = 4 THEN
                fifo_in_lock_s(fifo_1) <= '0';
                IF fifo_1 = 4 THEN
                  fifo_1 <= 0;
                  fifo_2 <= 0;
                ELSE
                  fifo_in_reuse_s(fifo_2) <= '1';
                  fifo_1 <= fifo_1 + 1;
                  fifo_2 <= fifo_1 + 1;                  
                END IF;
              ELSE
                fifo_in_reuse_s(fifo_2) <= '1';
                fifo_in_reuse_s(fifo_1) <= '1';
                fifo_2 <= fifo_2 + 1;
              END IF;
            END IF;

        WHEN OTHERS => NULL;
      END CASE;
    END IF;
  END PROCESS;


  fifo_out_data(31 DOWNTO 0) <= fifo_in_data(31*1-1 DOWNTO 32*0) WHEN fifo_1 = 0 ELSE
                                fifo_in_data(32*2-1 DOWNTO 32*1) WHEN fifo_1 = 1 ELSE
                                fifo_in_data(32*3-1 DOWNTO 32*2) WHEN fifo_1 = 2 ELSE
                                fifo_in_data(32*4-1 DOWNTO 32*3) WHEN fifo_1 = 3 ELSE
                                fifo_in_data(32*5-1 DOWNTO 32*4);-- WHEN fifo_1 = 4
                                

  fifo_out_data(63 DOWNTO 32) <= fifo_in_data(31*1-1 DOWNTO 32*0) WHEN fifo_2 = 0 ELSE
                                 fifo_in_data(32*2-1 DOWNTO 32*1) WHEN fifo_2 = 1 ELSE
                                 fifo_in_data(32*3-1 DOWNTO 32*2) WHEN fifo_2 = 2 ELSE
                                 fifo_in_data(32*4-1 DOWNTO 32*3) WHEN fifo_2 = 3 ELSE
                                 fifo_in_data(32*5-1 DOWNTO 32*4);-- WHEN fifo_2 = 4

  fifo_out_empty(0) <= fifo_in_empty(0) WHEN  fifo_1 = 0 ELSE
                       fifo_in_empty(1) WHEN  fifo_1 = 1 ELSE
                       fifo_in_empty(2) WHEN  fifo_1 = 2 ELSE
                       fifo_in_empty(3) WHEN  fifo_1 = 3 ELSE
                       fifo_in_empty(4);
  
  fifo_out_empty(1) <= fifo_in_empty(0) WHEN  fifo_2 = 0 ELSE
                       fifo_in_empty(1) WHEN  fifo_2 = 1 ELSE
                       fifo_in_empty(2) WHEN  fifo_2 = 2 ELSE
                       fifo_in_empty(3) WHEN  fifo_2 = 3 ELSE
                       fifo_in_empty(4);


  all_fifo: FOR I IN 0 TO 4 GENERATE
    fifo_in_ren(I) <= fifo_out_ren(I) WHEN fifo_1 = I ELSE
                      fifo_out_ren(I) WHEN fifo_2 = I ELSE
                      '1';
  END GENERATE all_fifo;  

END beh;
