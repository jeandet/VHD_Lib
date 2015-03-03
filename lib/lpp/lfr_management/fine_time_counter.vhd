LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY lpp;
USE lpp.general_purpose.ALL;

ENTITY fine_time_counter IS
  
  GENERIC (
    WAITING_TIME : STD_LOGIC_VECTOR(15 DOWNTO 0) := X"0040";
    FIRST_DIVISION : INTEGER := 374
    );

  PORT (
    clk            : IN STD_LOGIC;
    rstn           : IN STD_LOGIC;
    --
    tick           : IN STD_LOGIC;
    fsm_transition : IN STD_LOGIC;

    FT_max        : OUT STD_LOGIC;
    FT_half       : OUT STD_LOGIC;
    FT_wait       : OUT STD_LOGIC;
    fine_time     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    fine_time_new : OUT STD_LOGIC
    );

END fine_time_counter;

ARCHITECTURE beh OF fine_time_counter IS

  SIGNAL new_ft_counter    : STD_LOGIC_VECTOR(8 DOWNTO 0);
  SIGNAL new_ft            : STD_LOGIC;
  SIGNAL fine_time_counter : STD_LOGIC_VECTOR(15 DOWNTO 0);

--  CONSTANT FIRST_DIVISION : INTEGER := 20; -- TODO : 374 
  
BEGIN  -- beh


  
  counter_1 : general_counter
    GENERIC MAP (
      CYCLIC          => '1',
      NB_BITS_COUNTER => 9,
      RST_VALUE       => 0
      )
    PORT MAP (
      clk       => clk,
      rstn      => rstn,
      MAX_VALUE => STD_LOGIC_VECTOR(to_unsigned(FIRST_DIVISION, 9)),  
      set       => tick,
      set_value => (OTHERS => '0'),
      add1      => '1',
      counter   => new_ft_counter);

  new_ft <= '1' WHEN new_ft_counter = STD_LOGIC_VECTOR(to_unsigned(FIRST_DIVISION, 9)) ELSE '0';

  counter_2 : general_counter
    GENERIC MAP (
      CYCLIC          => '1',
      NB_BITS_COUNTER => 16,
      RST_VALUE       => 0
      )
    PORT MAP (
      clk       => clk,
      rstn      => rstn,
      MAX_VALUE => X"FFFF",
      set       => tick,
      set_value => (OTHERS => '0'),
      add1      => new_ft,
      counter   => fine_time_counter);

  FT_max  <= '1' WHEN new_ft = '1' AND fine_time_counter = X"FFFF" ELSE '0';
  FT_half <= '1' WHEN fine_time_counter > X"7FFF"                  ELSE '0';
  FT_wait <= '1' WHEN fine_time_counter > WAITING_TIME             ELSE '0';

  fine_time <= X"FFFF" WHEN fsm_transition = '1' ELSE fine_time_counter;

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      fine_time_new <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
      IF (new_ft = '1' AND fsm_transition = '0') OR tick = '1' THEN
        fine_time_new <= '1';
      ELSE
        fine_time_new <= '0';
      END IF;
    END IF;
  END PROCESS;
  
END beh;
