LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY lpp_counter IS
  
  GENERIC (
    nb_wait_period : INTEGER := 750;
    nb_bit_of_data : INTEGER := 16
    );
  PORT (
    clk   : IN  STD_LOGIC;
    rstn  : IN  STD_LOGIC;
    clear : IN  STD_LOGIC;
    full  : OUT STD_LOGIC;
    data  : OUT STD_LOGIC_VECTOR(nb_bit_of_data-1 DOWNTO 0);
    new_data : OUT STD_LOGIC
    );

END lpp_counter;

ARCHITECTURE beh OF lpp_counter IS

  SIGNAL counter_wait : INTEGER;
  SIGNAL counter_data : INTEGER;

  SIGNAL new_data_s : STD_LOGIC;
BEGIN  -- beh

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      counter_wait <= 0;
      counter_data <= 0;
      full         <= '0';
      new_data_s   <= '0';
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      IF clear = '1' THEN
        counter_wait <= 0;
        counter_data <= 0;
        full         <= '0';
        new_data_s   <= NOT new_data_s;
      ELSE
        IF counter_wait = nb_wait_period-1 THEN
          counter_wait <= 0;
          new_data_s <= NOT new_data_s;
          IF counter_data = (2**nb_bit_of_data)-1 THEN
            full         <= '1';
            counter_data <= 0;
          ELSE
            full         <= '0';
            counter_data <= counter_data +1;
          END IF;
        ELSE
          full         <= '0';
          counter_wait <= counter_wait +1;
        END IF;
      END IF;
    END IF;
  END PROCESS;

  data <= STD_LOGIC_VECTOR(to_unsigned(counter_data,nb_bit_of_data));
  new_data <= new_data_s;
  
END beh;
