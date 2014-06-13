LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY lpp_lfr_ms_reg_head IS
  
  PORT (
    clk  : IN STD_LOGIC;
    rstn : IN STD_LOGIC;

    in_wen   : IN STD_LOGIC;
    in_data  : IN STD_LOGIC_VECTOR(5*16-1 DOWNTO 0);
    in_full  : IN STD_LOGIC;
    in_empty : IN STD_LOGIC;
    
    out_wen  : OUT STD_LOGIC;
    out_data : OUT STD_LOGIC_VECTOR(5*16-1 DOWNTO 0);
    out_full : OUT STD_LOGIC
    );

END lpp_lfr_ms_reg_head;

ARCHITECTURE Beh OF lpp_lfr_ms_reg_head IS
  TYPE fsm_state_reg_head IS (REG_EMPTY, REG_FULL);
  SIGNAL fsm_state : fsm_state_reg_head;
  
  SIGNAL reg_data : STD_LOGIC_VECTOR(5*16-1 DOWNTO 0);
  SIGNAL out_wen_s : STD_LOGIC;
BEGIN  -- Beh

  PROCESS (clk, rstn)
  BEGIN
    IF rstn = '0' THEN
      fsm_state <= REG_EMPTY;
      reg_data  <= (OTHERS => '0');
      out_wen_s <= '1';
    ELSIF clk'event AND clk = '1' THEN
      out_wen_s <= '1';

      CASE fsm_state IS
        WHEN REG_EMPTY =>
          reg_data <= in_data;
          IF in_wen = '0' AND in_full = '1' THEN
            fsm_state <= REG_FULL;
          END IF;
        WHEN REG_FULL =>
          IF in_empty = '1' THEN
            out_wen_s <= '0';
            IF in_wen = '0' THEN
              reg_data <= in_data;
            ELSE
              fsm_state <= REG_EMPTY;              
            END IF;
          END IF;
        WHEN OTHERS => NULL;
      END CASE;
      
    END IF;
  END PROCESS;

  out_full <= '1' WHEN fsm_state = REG_FULL ELSE in_full;
  
  out_data <= reg_data WHEN fsm_state = REG_FULL ELSE in_data;
  
  out_wen  <= '0' WHEN out_wen_s = '0'      ELSE
              '1' WHEN fsm_state = REG_FULL ELSE
              in_wen;  

END Beh;
