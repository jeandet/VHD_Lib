LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY general_counter IS
  
  GENERIC (
    CYCLIC          : STD_LOGIC := '1';
    NB_BITS_COUNTER : INTEGER   := 9;
    RST_VALUE       : INTEGER   := 0
    );

  PORT (
    clk       : IN  STD_LOGIC;
    rstn      : IN  STD_LOGIC;
    --
    MAX_VALUE : IN  STD_LOGIC_VECTOR(NB_BITS_COUNTER-1 DOWNTO 0);
    --
    set       : IN  STD_LOGIC;
    set_value : IN  STD_LOGIC_VECTOR(NB_BITS_COUNTER-1 DOWNTO 0);
    add1      : IN  STD_LOGIC;
    counter   : OUT STD_LOGIC_VECTOR(NB_BITS_COUNTER-1 DOWNTO 0)
    );

END general_counter;

ARCHITECTURE beh OF general_counter IS
  CONSTANT RST_VALUE_v : STD_LOGIC_VECTOR(NB_BITS_COUNTER-1 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(RST_VALUE, NB_BITS_COUNTER));
  SIGNAL   counter_s   : STD_LOGIC_VECTOR(NB_BITS_COUNTER-1 DOWNTO 0);

BEGIN  -- beh

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      counter_s <= RST_VALUE_v;
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
      IF set = '1' THEN
        counter_s <= set_value;
      ELSIF add1 = '1' THEN
        IF counter_s < MAX_VALUE THEN
          counter_s <= STD_LOGIC_VECTOR((UNSIGNED(counter_s) + 1));
        ELSE
          IF CYCLIC = '1' THEN
            counter_s <= (OTHERS => '0');
          END IF;
        END IF;
      END IF;
    END IF;
  END PROCESS;

  counter <= counter_s;
  
END beh;
