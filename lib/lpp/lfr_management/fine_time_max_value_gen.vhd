LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY fine_time_max_value_gen IS
  
  PORT (
    clk                 : IN  STD_LOGIC;
    rstn                : IN  STD_LOGIC;
    tick                : IN  STD_LOGIC;
    fine_time_add       : IN  STD_LOGIC;
    fine_time_max_value : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
    );

END fine_time_max_value_gen;

ARCHITECTURE beh OF fine_time_max_value_gen IS

  SIGNAL count_even      : STD_LOGIC;
  SIGNAL count_first     : STD_LOGIC;
  SIGNAL count_modulo_33 : STD_LOGIC;
  
  
  SIGNAL count_33 : INTEGER range 0 TO 32;
  
BEGIN  -- beh

  fine_time_max_value <= STD_LOGIC_VECTOR(to_unsigned(381,9)) WHEN count_first      = '1' ELSE
                         STD_LOGIC_VECTOR(to_unsigned(380,9)) WHEN count_even       = count_modulo_33 ELSE
                         STD_LOGIC_VECTOR(to_unsigned(381,9)) WHEN count_even       = '1' ELSE
                         STD_LOGIC_VECTOR(to_unsigned(379,9)) WHEN count_modulo_33  = '1' ELSE
                         STD_LOGIC_VECTOR(to_unsigned(380,9));
                         
                         
  
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      count_first         <= '1';
      count_even          <= '0';
      count_modulo_33     <= '0';
      count_33            <= 0;
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      IF tick = '1' THEN
        count_even          <= '0';
        count_first         <= '1';
        count_modulo_33     <= '0';
        count_33            <= 0;
      ELSE
        IF fine_time_add = '1' THEN
          count_first   <= '0';
          IF count_even = '1' THEN
            count_even <= '0';
          ELSE
            count_even <= '1';
          END IF;
          IF count_33 = 31 THEN
            count_modulo_33 <= '1';
          ELSE
            count_modulo_33 <= '0';
          END IF;
          
          IF count_33 = 32 THEN
            count_33 <= 0;
          ELSE
            count_33 <= count_33 + 1;
          END IF;          
        END IF;
      END IF;      
    END IF;
  END PROCESS;

END beh;
