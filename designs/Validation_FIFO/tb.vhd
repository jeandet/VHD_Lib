
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.MATH_REAL.ALL;
USE ieee.numeric_std.ALL;

LIBRARY lpp;
USE lpp.lpp_memory.ALL;
USE lpp.iir_filter.ALL;


ENTITY testbench IS
END;

ARCHITECTURE behav OF testbench IS

  -----------------------------------------------------------------------------
  -- Common signal
  SIGNAL clk  : STD_LOGIC := '0';
  SIGNAL rstn : STD_LOGIC := '0';
  SIGNAL run  : STD_LOGIC := '0';

  -----------------------------------------------------------------------------

  SIGNAL full_almost : STD_LOGIC;
  SIGNAL full        : STD_LOGIC;
  SIGNAL data_wen    : STD_LOGIC;
  SIGNAL wdata       : STD_LOGIC_VECTOR(31 DOWNTO 0);

  SIGNAL empty        : STD_LOGIC;
  SIGNAL data_ren     : STD_LOGIC;
  SIGNAL data_out     : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_out_obs : STD_LOGIC_VECTOR(31 DOWNTO 0);

  SIGNAL empty_reg : STD_LOGIC;
  SIGNAL full_reg  : STD_LOGIC;

  -----------------------------------------------------------------------------
  TYPE   DATA_CHANNEL IS ARRAY (0 TO 128-1) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_in : DATA_CHANNEL;

  -----------------------------------------------------------------------------
  CONSTANT RANDOM_VECTOR_SIZE           : INTEGER := 1+1;  --READ + WRITE + CHANNEL_READ + CHANNEL_WRITE
  CONSTANT TWO_POWER_RANDOM_VECTOR_SIZE : REAL    := (2**RANDOM_VECTOR_SIZE)*1.0;
  SIGNAL   random_vector                : STD_LOGIC_VECTOR(RANDOM_VECTOR_SIZE-1 DOWNTO 0);
  --
  SIGNAL   rand_ren                     : STD_LOGIC;
  SIGNAL   rand_wen                     : STD_LOGIC;

  SIGNAL pointer_read  : INTEGER;
  SIGNAL pointer_write : INTEGER := 0;

  SIGNAL error_now : STD_LOGIC;
  SIGNAL error_new : STD_LOGIC;

  SIGNAL read_stop : STD_LOGIC;
BEGIN


  all_J : FOR J IN 0 TO 127 GENERATE
    data_in(J) <= STD_LOGIC_VECTOR(to_unsigned(J*2+1, 32));
  END GENERATE all_J;


  -----------------------------------------------------------------------------
  lpp_fifo_1 : lpp_fifo
    GENERIC MAP (
      tech    => 0,
      Mem_use => use_CEL,
      DataSz  => 32,
      AddrSz  => 8)
    PORT MAP (
      clk         => clk,
      rstn        => rstn,
      reUse       => '0',
      ren         => data_ren,
      rdata       => data_out,
      wen         => data_wen,
      wdata       => wdata,
      empty       => empty,
      full        => full,
      almost_full => full_almost);

  -----------------------------------------------------------------------------


  
  -----------------------------------------------------------------------------
  -- READ
  -----------------------------------------------------------------------------
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      empty_reg <= '1';
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
      empty_reg <= empty;
    END IF;
  END PROCESS;

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      data_out_obs <= (OTHERS => '0');

      pointer_read <= 0;
      error_now    <= '0';
      error_new    <= '0';
      
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
      error_now <= '0';
      IF empty_reg = '0' THEN
        IF data_ren = '0' THEN
          --IF data_ren_and_not_empty = '0' THEN
          error_new    <= '0';
          data_out_obs <= data_out;

          IF pointer_read < 127 THEN
            pointer_read <= pointer_read + 1;
          ELSE
            pointer_read <= 0;
          END IF;

          IF data_out /= data_in(pointer_read) THEN
            error_now <= '1';
            error_new <= '1';
          END IF;
        END IF;
        
      END IF;
    END IF;
  END PROCESS;
  -----------------------------------------------------------------------------




  -----------------------------------------------------------------------------
  -- WRITE
  -----------------------------------------------------------------------------
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      full_reg <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
      full_reg <= full;
    END IF;
  END PROCESS;

  proc_verif : PROCESS (clk, rstn)
  BEGIN  -- PROCESS proc_verif
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      pointer_write <= 0;
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
      IF data_wen = '0' THEN
        IF full_reg = '0' THEN
          IF pointer_write < 127 THEN
            pointer_write <= pointer_write+1;
          ELSE
            pointer_write <= 0;
          END IF;
        END IF;
      END IF;
    END IF;
  END PROCESS proc_verif;

  wdata <= data_in(pointer_write) WHEN data_wen = '0' ELSE (OTHERS => 'X');
  -----------------------------------------------------------------------------



  -----------------------------------------------------------------------------
  clk <= NOT clk AFTER 5 ns;            -- 100 MHz
  -----------------------------------------------------------------------------
  WaveGen_Proc : PROCESS
  BEGIN
    -- insert signal assignments here
    WAIT UNTIL clk = '1';
    read_stop <= '0';
    rstn      <= '0';
    run       <= '0';
    WAIT UNTIL clk = '1';
    WAIT UNTIL clk = '1';
    WAIT UNTIL clk = '1';
    rstn      <= '1';
    WAIT UNTIL clk = '1';
    WAIT UNTIL clk = '1';
    WAIT UNTIL clk = '1';
    WAIT UNTIL clk = '1';
    WAIT UNTIL clk = '1';
    run       <= '1';
    WAIT UNTIL clk = '1';
    WAIT UNTIL clk = '1';
    WAIT UNTIL clk = '1';
    WAIT UNTIL clk = '1';
    WAIT FOR 10 us;
    read_stop <= '1';
    WAIT FOR 10 us;
    read_stop <= '0';
    WAIT FOR 80 us;
    REPORT "*** END simulation ***" SEVERITY failure;
    WAIT;
  END PROCESS WaveGen_Proc;
  -----------------------------------------------------------------------------


  
  -----------------------------------------------------------------------------
  -- RANDOM GENERATOR
  -----------------------------------------------------------------------------
  PROCESS (clk, rstn)
    VARIABLE seed1, seed2      : POSITIVE;
    VARIABLE rand1             : REAL;
    VARIABLE RANDOM_VECTOR_VAR : STD_LOGIC_VECTOR(RANDOM_VECTOR_SIZE-1 DOWNTO 0);
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      random_vector <= (OTHERS => '0');
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
      UNIFORM(seed1, seed2, rand1);
      RANDOM_VECTOR_VAR := STD_LOGIC_VECTOR(
        to_unsigned(INTEGER(TRUNC(rand1*TWO_POWER_RANDOM_VECTOR_SIZE)),
                    RANDOM_VECTOR_VAR'LENGTH)
        );
      random_vector <= RANDOM_VECTOR_VAR;
    END IF;
  END PROCESS;
  -----------------------------------------------------------------------------
  rand_wen <= random_vector(1);
  rand_ren <= random_vector(0);
  -----------------------------------------------------------------------------
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      data_wen <= '1';
      data_ren <= '1';
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
      data_wen <= rand_wen;
      IF read_stop = '0' THEN
        data_ren <= rand_ren;
      ELSE
        data_ren <= '1';
      END IF;
    END IF;
  END PROCESS;
  -----------------------------------------------------------------------------
  

  
END;
