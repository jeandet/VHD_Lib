LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY counter IS
  
  GENERIC (
    CYCLIC          : STD_LOGIC := '1';
    NB_BITS_COUNTER : INTEGER   := 9
    );

  PORT (
    clk       : IN  STD_LOGIC;
    rstn      : IN  STD_LOGIC;
    --
    RST_VALUE  : IN STD_LOGIC_VECTOR(NB_BITS_COUNTER-1 DOWNTO 0) := (OTHERS => '0');
    MAX_VALUE  : IN STD_LOGIC_VECTOR(NB_BITS_COUNTER-1 DOWNTO 0) := (OTHERS => '1');
    --
    set       : IN  STD_LOGIC;
    set_value : IN  STD_LOGIC_VECTOR(NB_BITS_COUNTER-1 DOWNTO 0);
    add1      : IN  STD_LOGIC;
    counter   : OUT STD_LOGIC_VECTOR(NB_BITS_COUNTER-1 DOWNTO 0)
    );

END counter;

ARCHITECTURE beh OF counter IS
  SIGNAL counter_s : STD_LOGIC_VECTOR(NB_BITS_COUNTER-1 DOWNTO 0);

BEGIN  -- beh

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN  -- asynchronous reset (active low)
      counter_s <= RST_VALUE;
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      IF set = '1' THEN
        counter_s <= set_value;
      ELSIF add1 = '1' THEN
        IF counter_s < MAX_VALUE THEN
          counter_s <= counter_s + 1;
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
