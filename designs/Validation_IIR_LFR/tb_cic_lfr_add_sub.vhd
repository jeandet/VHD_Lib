
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.MATH_REAL.ALL;
USE ieee.numeric_std.ALL;

LIBRARY lpp;
USE lpp.cic_pkg.ALL;
USE lpp.data_type_pkg.ALL;
USE lpp.chirp_pkg.ALL;

ENTITY testbench IS
  
END;

ARCHITECTURE behav OF testbench IS

  SIGNAL clk            : STD_LOGIC := '0';
  SIGNAL clk_24k        : STD_LOGIC := '0';
  SIGNAL clk_24k_r      : STD_LOGIC := '0';
  SIGNAL rstn           : STD_LOGIC;
  SIGNAL run            : STD_LOGIC;
  SIGNAL data_in        : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL data_in_v      : sample_vector(5 DOWNTO 0,15 DOWNTO 0);
  SIGNAL data_in_valid  : STD_LOGIC;
  -----------------------------------------------------------------------------
  CONSTANT CARRY    : STD_LOGIC := '1';
  CONSTANT CARRY_NO : STD_LOGIC := '0';
  CONSTANT ADD : STD_LOGIC := '0';
  CONSTANT SUB : STD_LOGIC := '1';
  SIGNAL OP : STD_LOGIC;
  SIGNAL OP_0 : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL OP_1 : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL data_out_verif : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_out_verif_s : STD_LOGIC_VECTOR(32 DOWNTO 0);
  SIGNAL data_in_A_reg : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_in_B_reg : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_in_A : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_in_B : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_out_s  : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL data_out  : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_out_pre  : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_out_diff  : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_out_Carry : STD_LOGIC;

  SIGNAL COUNTER_A : INTEGER;
  SIGNAL COUNTER_B : INTEGER;
  CONSTANT COUNTER_MIN : INTEGER := INTEGER'LOW;
  CONSTANT COUNTER_MAX : INTEGER := INTEGER'HIGH;
  CONSTANT COUNTER_STEP : INTEGER := INTEGER'HIGH/100;

  SIGNAL ALL_is_OK : STD_LOGIC;
BEGIN

  clk <= NOT clk AFTER 5 ns;
  
  -----------------------------------------------------------------------------
  PROCESS
  BEGIN  -- PROCESS
    WAIT UNTIL clk = '1';
    rstn <= '0';
    run  <= '0';
    WAIT UNTIL clk = '1';
    rstn <= '1';
    WAIT UNTIL clk = '1';
    WAIT UNTIL clk = '1';
    run <= '1';
    WAIT UNTIL clk = '1';
    OP <= ADD;        
    WAIT FOR 500 us;
    OP <= SUB;        
    WAIT FOR 500 us;
    REPORT "*** END simulation ***" SEVERITY failure;
    WAIT;    
  END PROCESS;

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      COUNTER_A <= COUNTER_MIN;
      COUNTER_B <= COUNTER_MIN;
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      IF COUNTER_A < COUNTER_MAX - COUNTER_STEP THEN
        COUNTER_A <= COUNTER_A + COUNTER_STEP;
      ELSE
        COUNTER_A <= COUNTER_MIN;
        IF COUNTER_B < COUNTER_MAX - COUNTER_STEP THEN
          COUNTER_B <= COUNTER_B + COUNTER_STEP;
        ELSE
          COUNTER_B <= COUNTER_MIN;
        END IF;
      END IF;      
    END IF;
  END PROCESS;
  
  data_in_A <= STD_LOGIC_VECTOR(to_signed(COUNTER_A,32));
  data_in_B <= STD_LOGIC_VECTOR(to_signed(COUNTER_B,32));
  
  -----------------------------------------------------------------------------
  OP_0 <= CARRY_NO & OP;
  OP_1 <= CARRY    & OP;
  cic_lfr_add_sub_1: cic_lfr_add_sub
    PORT MAP (
      clk            => clk,
      rstn           => rstn,
      run            => run,
      OP             => OP_0,
      data_in_A      => data_in_A(15 DOWNTO 0),
      data_in_B      => data_in_B(15 DOWNTO 0),
      data_in_Carry  => '0',
      data_out       => data_out_s,
      data_out_Carry => data_out_Carry);

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      data_in_A_reg <= (OTHERS => '0');
      data_in_B_reg <= (OTHERS => '0');
      data_out(15 DOWNTO 0) <= (OTHERS => '0');
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      data_in_A_reg <= data_in_A;
      data_in_B_reg <= data_in_B;
      data_out(15 DOWNTO 0) <= data_out_s;
    END IF;
  END PROCESS;
  
  cic_lfr_add_sub_2: cic_lfr_add_sub
    PORT MAP (
      clk            => clk,
      rstn           => rstn,
      run            => run,
      OP             => OP_1,
      data_in_A      => data_in_A_reg(31 DOWNTO 16),
      data_in_B      => data_in_B_reg(31 DOWNTO 16),
      data_in_Carry  => data_out_Carry,
      data_out       => data_out(31 DOWNTO 16),
      data_out_Carry => OPEN);
  -----------------------------------------------------------------------------
  data_out_verif_s <= STD_LOGIC_VECTOR(to_signed(to_integer(SIGNED(data_in_A_reg)) + to_integer(SIGNED(data_in_B_reg)),33)) WHEN OP = ADD ELSE
                      STD_LOGIC_VECTOR(to_signed(to_integer(SIGNED(data_in_A_reg)) - to_integer(SIGNED(data_in_B_reg)),33));
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      data_out_verif <= (OTHERS => '0');
      ALL_is_OK <= '0';
      data_out_pre <= (OTHERS => '0');
      data_out_diff <= (OTHERS => '0');
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      data_out_verif <= data_out_verif_s(31 DOWNTO 0);
      IF data_out_verif = data_out THEN
        ALL_is_OK <= '1';
      ELSE
        ALL_is_OK <= '0';
      END IF;
      -------------------------------------------------------------------------
      data_out_pre <= data_out;
      IF OP = ADD THEN
        data_out_diff <= STD_LOGIC_VECTOR(to_signed(to_integer(SIGNED(data_out)) - to_integer(SIGNED(data_out_pre) ),32));
      ELSE
        data_out_diff <= STD_LOGIC_VECTOR(to_signed(to_integer(SIGNED(data_out)) - to_integer(SIGNED(data_out_pre) ),32));
      END IF;      
    END IF;
  END PROCESS;
  -----------------------------------------------------------------------------

  
  




  
END;
