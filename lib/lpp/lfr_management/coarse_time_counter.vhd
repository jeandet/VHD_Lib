LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY lpp;
USE lpp.general_purpose.ALL;

ENTITY coarse_time_counter IS
  GENERIC (
    NB_SECOND_DESYNC : INTEGER := 60);
  
  PORT (
    clk           : IN STD_LOGIC;
    rstn          : IN STD_LOGIC;
    
    tick          : IN STD_LOGIC;
    set_TCU       : IN STD_LOGIC;
    new_TCU       : IN STD_LOGIC;
    set_TCU_value : IN STD_LOGIC_VECTOR(30 DOWNTO 0);
    CT_add1       : IN STD_LOGIC;
    fsm_desync    : IN STD_LOGIC;
    FT_max        : IN STD_LOGIC;
    
    coarse_time   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    coarse_time_new   : OUT STD_LOGIC
    
    );

END coarse_time_counter;

ARCHITECTURE beh OF coarse_time_counter IS

  SIGNAL add1_bit31 : STD_LOGIC;
  SIGNAL nb_second_counter : STD_LOGIC_VECTOR(5 DOWNTO 0);
  SIGNAL coarse_time_new_counter : STD_LOGIC;
  SIGNAL coarse_time_31 : STD_LOGIC;
  SIGNAL coarse_time_31_reg : STD_LOGIC;

  SIGNAL set_synchronized       : STD_LOGIC;
  SIGNAL set_synchronized_value : STD_LOGIC_VECTOR(5 DOWNTO 0);
  
  --CONSTANT NB_SECOND_DESYNC : INTEGER := 4; -- TODO : 60 ;
  SIGNAL set_TCU_reg       :  STD_LOGIC;
  
BEGIN  -- beh

  -----------------------------------------------------------------------------
  -- COARSE_TIME( 30 DOWNTO 0)
  -----------------------------------------------------------------------------
  counter_1 : general_counter
    GENERIC MAP (
      CYCLIC => '1',
      NB_BITS_COUNTER => 31,
      RST_VALUE => 0)
    PORT MAP (
      clk       => clk,
      rstn      => rstn,
      MAX_VALUE => "111" & X"FFFFFFF" ,
      set       => set_TCU_reg,
      set_value => set_TCU_value(30 DOWNTO 0),
      add1      => CT_add1,
      counter   => coarse_time(30 DOWNTO 0));

  
  add1_bit31 <= '1' WHEN fsm_desync = '1' AND FT_max = '1' ELSE '0';

  -----------------------------------------------------------------------------
  -- COARSE_TIME(31)
  -----------------------------------------------------------------------------
  
  --set_synchronized       <= (tick AND (NOT coarse_time_31)) OR (coarse_time_31 AND set_TCU);
  --set_synchronized_value <= STD_LOGIC_VECTOR(to_unsigned(NB_SECOND_DESYNC, 6)) WHEN (set_TCU AND set_TCU_value(31)) =  '1' ELSE
  --                          (OTHERS => '0');
  set_synchronized       <= tick AND ((NOT coarse_time_31) OR (coarse_time_31 AND new_TCU));
  set_synchronized_value <= (OTHERS => '0');
  
  counter_2 : general_counter
    GENERIC MAP (
      CYCLIC          => '0',
      NB_BITS_COUNTER => 6,
      RST_VALUE       => NB_SECOND_DESYNC
      )
    PORT MAP (
      clk       => clk,
      rstn      => rstn,
      MAX_VALUE => STD_LOGIC_VECTOR(to_unsigned(NB_SECOND_DESYNC, 6)),
      set       => set_synchronized,
      set_value => set_synchronized_value,
      add1      => add1_bit31,
      counter   => nb_second_counter);

  coarse_time_31 <= '1' WHEN nb_second_counter = STD_LOGIC_VECTOR(to_unsigned(NB_SECOND_DESYNC, 6))  ELSE '0';
  coarse_time(31) <= coarse_time_31;
  coarse_time_new <= coarse_time_new_counter OR (coarse_time_31 XOR coarse_time_31_reg);
  
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      coarse_time_new_counter <= '0';
      coarse_time_31_reg <= '0';
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      coarse_time_31_reg <= coarse_time_31;
      IF set_TCU_reg = '1' OR CT_add1 = '1' THEN
        coarse_time_new_counter <= '1';
      ELSE
        coarse_time_new_counter <= '0';
      END IF;
    END IF;
  END PROCESS;

  -----------------------------------------------------------------------------
  -- Just to try to limit the constraint
  --PROCESS (clk, rstn)
  --BEGIN  -- PROCESS
  --  IF rstn = '0' THEN                  -- asynchronous reset (active low)
  --    set_TCU_reg <= '0';
  --  ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
  --    set_TCU_reg <= set_TCU;
  --  END IF;
  --END PROCESS;  
  -----------------------------------------------------------------------------
  set_TCU_reg <= set_TCU;
  
END beh;
