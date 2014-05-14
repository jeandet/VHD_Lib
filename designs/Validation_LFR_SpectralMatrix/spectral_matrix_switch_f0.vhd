LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


ENTITY spectral_matrix_switch_f0 IS
  
  PORT (
    clk          : IN  STD_LOGIC;
    rstn         : IN  STD_LOGIC;
    --INPUT
    sample_wen   : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
    --OUTPUT A
    fifo_A_empty : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
    fifo_A_full  : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
    fifo_A_wen   : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
    --OUTPUT B
    fifo_B_empty : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
    fifo_B_full  : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
    fifo_B_wen   : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
    --ERROR
    error_wen    : OUT STD_LOGIC
    );

END spectral_matrix_switch_f0;

ARCHITECTURE beh OF spectral_matrix_switch_f0 IS
  SIGNAL ALL_1_sample_wen   : STD_LOGIC;
  
  SIGNAL ALL_1_fifo_A_empty : STD_LOGIC;
  SIGNAL ALL_1_fifo_A_full  : STD_LOGIC;
  SIGNAL ALL_1_fifo_B_empty : STD_LOGIC;
  SIGNAL ALL_1_fifo_B_full  : STD_LOGIC;

  TYPE state_fsm_switch_f0 IS (state_A,state_B,state_AtoB,state_BtoA);
  SIGNAL state_fsm : state_fsm_switch_f0;
  
BEGIN  -- beh
  ALL_1_sample_wen   <= '1' WHEN sample_wen = "11111" ELSE '0';
  
  ALL_1_fifo_A_empty <= '1' WHEN fifo_A_empty = "11111" ELSE '0';
  ALL_1_fifo_A_full  <= '1' WHEN fifo_A_full  = "11111" ELSE '0';
  ALL_1_fifo_B_empty <= '1' WHEN fifo_B_empty = "11111" ELSE '0';
  ALL_1_fifo_B_full  <= '1' WHEN fifo_B_full  = "11111" ELSE '0';
  
  fifo_A_wen <= sample_wen WHEN state_fsm = state_A ELSE (OTHERS => '1');
  fifo_B_wen <= sample_wen WHEN state_fsm = state_B ELSE (OTHERS => '1');

  PROCESS (clk, rstn)
  BEGIN
    IF rstn = '0' THEN
      state_fsm   <= state_A;
      error_wen   <= '0';

    ELSIF clk'event AND clk = '1' THEN
      CASE state_fsm IS

        WHEN state_A =>
          error_wen   <= '0';
          IF ALL_1_fifo_A_full = '1' THEN
            --error_wen   <= NOT ALL_1_sample_wen;
            IF ALL_1_fifo_B_empty = '1' THEN
              state_fsm <= state_B;
            ELSE
              state_fsm <= state_AtoB;
            END IF;
          END IF;
          
        WHEN state_B => 
          error_wen   <= '0';
          IF ALL_1_fifo_B_full = '1' THEN
            --error_wen   <= NOT ALL_1_sample_wen;
            IF ALL_1_fifo_A_empty = '1' THEN
              state_fsm <= state_A;
            ELSE
              state_fsm <= state_BtoA;
            END IF;
          END IF;
          
        WHEN state_AtoB =>
          error_wen <= NOT ALL_1_sample_wen;
          IF ALL_1_fifo_B_empty = '1' THEN
            state_fsm <= state_B;
          END IF;
          
        WHEN state_BtoA =>
          error_wen <= NOT ALL_1_sample_wen;
          IF ALL_1_fifo_A_empty = '1' THEN
            state_fsm <= state_A;
          END IF;
          
        WHEN OTHERS => NULL;
      END CASE;
      
      
    END IF;
  END PROCESS;
  

END beh;
