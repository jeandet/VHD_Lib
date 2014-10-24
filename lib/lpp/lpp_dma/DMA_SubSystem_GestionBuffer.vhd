 
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY DMA_SubSystem_GestionBuffer IS
  GENERIC (
    BUFFER_ADDR_SIZE   : INTEGER := 32;
    BUFFER_LENGTH_SIZE : INTEGER := 26);
  PORT (
    clk  : IN STD_LOGIC;
    rstn : IN STD_LOGIC;
    run  : IN STD_LOGIC;
    --
    buffer_new      : IN STD_LOGIC;
    buffer_addr     : IN STD_LOGIC_VECTOR(BUFFER_ADDR_SIZE-1   DOWNTO 0);
    buffer_length   : IN STD_LOGIC_VECTOR(BUFFER_LENGTH_SIZE-1 DOWNTO 0);  --in 64B
    buffer_full     : OUT STD_LOGIC;
    buffer_full_err : OUT STD_LOGIC;
    --
    burst_send    : IN STD_LOGIC;
    burst_addr    : OUT STD_LOGIC_VECTOR(BUFFER_ADDR_SIZE-1 DOWNTO 0)
    );
END DMA_SubSystem_GestionBuffer;


ARCHITECTURE beh OF DMA_SubSystem_GestionBuffer IS

  TYPE state_DMA_GestionBuffer IS (IDLE, ON_GOING);
  SIGNAL state : state_DMA_GestionBuffer;

  SIGNAL burst_send_counter      : STD_LOGIC_VECTOR(BUFFER_LENGTH_SIZE-1 DOWNTO 0);
  SIGNAL burst_send_counter_add1 : STD_LOGIC_VECTOR(BUFFER_LENGTH_SIZE-1 DOWNTO 0);
  SIGNAL addr_shift              : STD_LOGIC_VECTOR(BUFFER_ADDR_SIZE-1 DOWNTO 0);
  
BEGIN
  addr_shift <= burst_send_counter & "000000";
  burst_addr <= STD_LOGIC_VECTOR(unsigned(buffer_addr) + unsigned(addr_shift));

  burst_send_counter_add1 <= STD_LOGIC_VECTOR(unsigned(burst_send_counter) + 1);
  
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      burst_send_counter <= (OTHERS => '0');
      state       <= IDLE;
      buffer_full     <= '0';
      buffer_full_err <= '0';
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      CASE state IS
        WHEN IDLE     =>
          burst_send_counter <= (OTHERS => '0');
          buffer_full_err <= burst_send;
          buffer_full     <= '0';
          IF buffer_new = '1' THEN
            state <= ON_GOING;
          END IF;
          
        WHEN ON_GOING =>
          buffer_full_err <= '0';
          buffer_full     <= '0';
          IF burst_send = '1' THEN
            IF unsigned(burst_send_counter_add1) < unsigned(buffer_length) THEN
              burst_send_counter <= burst_send_counter_add1;
            ELSE
              buffer_full <= '1';
              state       <= IDLE;
            END IF;
          END IF;

        WHEN OTHERS => NULL;
      END CASE;
    END IF;
  END PROCESS;
    
END beh;
