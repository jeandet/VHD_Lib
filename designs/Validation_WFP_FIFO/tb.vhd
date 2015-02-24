
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.MATH_REAL.ALL;
USE ieee.numeric_std.ALL;

LIBRARY lpp;
USE lpp.lpp_waveform_pkg.ALL;

ENTITY testbench IS
END;

ARCHITECTURE behav OF testbench IS

  -----------------------------------------------------------------------------
  -- Common signal
  SIGNAL clk  : STD_LOGIC := '0';
  SIGNAL rstn : STD_LOGIC := '0';
  SIGNAL run  : STD_LOGIC := '0';

  -----------------------------------------------------------------------------
  TYPE DATA_FIFO_VECTOR IS ARRAY (0 TO 3) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_out_obs : DATA_FIFO_VECTOR;

  SIGNAL full_almost : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL full        : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL data_wen    : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL wdata       : STD_LOGIC_VECTOR(31 DOWNTO 0);

  SIGNAL s_empty_almost : STD_LOGIC_VECTOR(3 DOWNTO 0);  --occupancy is lesser than 16 * 32b
  SIGNAL s_empty        : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL s_data_ren     : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL s_rdata        : STD_LOGIC_VECTOR(31 DOWNTO 0);

  SIGNAL empty_almost     : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL empty            : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL data_ren         : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL data_out         : DATA_FIFO_VECTOR;

  SIGNAL empty_reg : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL full_reg  : STD_LOGIC_VECTOR(3 DOWNTO 0);
  -----------------------------------------------------------------------------
  TYPE   DATA_CHANNEL IS ARRAY (0 TO 128/4-1) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
  TYPE   DATA_ARRAY IS ARRAY (0 TO 3) OF DATA_CHANNEL;
  SIGNAL data_in : DATA_ARRAY;

  -----------------------------------------------------------------------------
  CONSTANT RANDOM_VECTOR_SIZE           : INTEGER := 1+1+2+2;  --READ + WRITE + CHANNEL_READ + CHANNEL_WRITE
  CONSTANT TWO_POWER_RANDOM_VECTOR_SIZE : REAL    := (2**RANDOM_VECTOR_SIZE)*1.0;
  SIGNAL   random_vector                : STD_LOGIC_VECTOR(RANDOM_VECTOR_SIZE-1 DOWNTO 0);
  --
  SIGNAL   rand_ren                     : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL   rand_wen                     : STD_LOGIC_VECTOR(3 DOWNTO 0);

  TYPE   POINTER IS ARRAY (0 TO 3) OF INTEGER;
  SIGNAL pointer_read  : POINTER;
  SIGNAL pointer_write : POINTER := (0, 0, 0, 0);
  
  --SIGNAL data_f0_data_out_obs_data : STD_LOGIC_VECTOR(5 DOWNTO 0);
  --SIGNAL data_f0_data_out_obs      : STD_LOGIC;
  --SIGNAL data_f1_data_out_obs_data : STD_LOGIC_VECTOR(5 DOWNTO 0);
  --SIGNAL data_f1_data_out_obs      : STD_LOGIC;
  --SIGNAL data_f2_data_out_obs_data : STD_LOGIC_VECTOR(5 DOWNTO 0);
  --SIGNAL data_f2_data_out_obs      : STD_LOGIC;
  --SIGNAL data_f3_data_out_obs_data : STD_LOGIC_VECTOR(5 DOWNTO 0);
  --SIGNAL data_f3_data_out_obs      : STD_LOGIC;
  SIGNAL error_now     : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL error_new     : STD_LOGIC_VECTOR(3 DOWNTO 0);

  SIGNAL read_stop : STD_LOGIC;
  
--  SIGNAL empty_s            : STD_LOGIC_VECTOR(3 DOWNTO 0);

  -----------------------------------------------------------------------------
BEGIN

  all_I : FOR I IN 0 TO 3 GENERATE
    all_J : FOR J IN 0 TO 128/4-1 GENERATE
      data_in(I)(J) <= STD_LOGIC_VECTOR(to_unsigned(J*2+I*(2**28)+1, 32));
    END GENERATE all_J;
  END GENERATE all_I;


  -----------------------------------------------------------------------------
  lpp_waveform_fifo_1 : lpp_waveform_fifo
    GENERIC MAP (tech => 0)
    PORT MAP (
      clk  => clk,
      rstn => rstn,
      run  => run,

      empty        => s_empty,
      empty_almost => s_empty_almost,
      data_ren     => s_data_ren,
      rdata        => s_rdata,

      full_almost => full_almost,
      full        => full,
      data_wen    => data_wen,
      wdata       => wdata);

  lpp_waveform_fifo_headreg_1 : lpp_waveform_fifo_headreg
    GENERIC MAP (tech => 0)
    PORT MAP (
      clk            => clk,
      rstn           => rstn,
      run            => run,
      o_empty_almost => empty_almost,
      o_empty        => empty,

      o_data_ren => data_ren,
      o_rdata_0  => data_out(0),
      o_rdata_1  => data_out(1),
      o_rdata_2  => data_out(2),
      o_rdata_3  => data_out(3),

      i_empty_almost => s_empty_almost,
      i_empty        => s_empty,
      i_data_ren     => s_data_ren,
      i_rdata        => s_rdata);
  -----------------------------------------------------------------------------


  
  -----------------------------------------------------------------------------
  all_data_channel: FOR I IN 0 TO 3 GENERATE
    -----------------------------------------------------------------------------
    -- READ
    -----------------------------------------------------------------------------
  
    PROCESS (clk, rstn)
    BEGIN  -- PROCESS
      IF rstn = '0' THEN                  -- asynchronous reset (active low)
        empty_reg(I) <= '1';
      ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
        empty_reg(I) <= empty(I);
      END IF;
    END PROCESS;

    PROCESS (clk, rstn)
    BEGIN  -- PROCESS
      IF rstn = '0' THEN                  -- asynchronous reset (active low)
        data_out_obs(I) <= (OTHERS => '0');

        pointer_read(I) <= 0;
        error_now(I)    <= '0';
        error_new(I)    <= '0';
      
      ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
        error_now(I) <= '0';
        IF empty_reg(I) = '0' THEN
          IF data_ren(I) = '0' THEN
  
            error_new(I)    <= '0';
            data_out_obs(I) <= data_out(I);
            
            IF pointer_read(I) < 128/4-1 THEN
              pointer_read(I) <= pointer_read(I) + 1;
            ELSE
              pointer_read(I) <= 0;
            END IF;

            IF data_out(I) /= data_in(I)(pointer_read(I)) THEN
              error_now(I) <= '1';
              error_new(I) <= '1';
            END IF;
          END IF;
          
        END IF;
      END IF;
    END PROCESS;

    -----------------------------------------------------------------------------
    -- WRITE
    -----------------------------------------------------------------------------
    PROCESS (clk, rstn)
    BEGIN  -- PROCESS
      IF rstn = '0' THEN                  -- asynchronous reset (active low)
        full_reg(I) <= '0';
      ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
        full_reg(I) <= full(I);
      END IF;
    END PROCESS;

    PROCESS (clk, rstn)
    BEGIN  -- PROCESS proc_verif
      IF rstn = '0' THEN                  -- asynchronous reset (active low)
        pointer_write(I) <= 0;
      ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
        IF data_wen(I) = '0' THEN
          IF full_reg(I) = '0' THEN
            IF pointer_write(I) < 128/4-1 THEN
              pointer_write(I) <= pointer_write(I)+1;
            ELSE
              pointer_write(I) <= 0;
            END IF;
          END IF;
        END IF;
      END IF;
    END PROCESS;   
  END GENERATE all_data_channel;
  
  wdata <= data_in(0)(pointer_write(0)) WHEN data_wen = "1110" ELSE
           data_in(1)(pointer_write(1)) WHEN data_wen = "1101" ELSE
           data_in(2)(pointer_write(2)) WHEN data_wen = "1011" ELSE
           data_in(3)(pointer_write(3)) WHEN data_wen = "0111" ELSE
           (OTHERS => 'X');
  
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
  rand_ren <= "1111" WHEN random_vector(0) = '0' ELSE
              "1110" WHEN random_vector(2 DOWNTO 1) = "00" ELSE
              "1101" WHEN random_vector(2 DOWNTO 1) = "01" ELSE
              "1011" WHEN random_vector(2 DOWNTO 1) = "10" ELSE
              "0111";  -- WHEN random_vector(3 DOWNTO 1) = "11" ELSE
  
  rand_wen <= "1111" WHEN random_vector(3) = '0' ELSE
              "1110" WHEN random_vector(5 DOWNTO 4) = "00" ELSE
              "1101" WHEN random_vector(5 DOWNTO 4) = "01" ELSE
              "1011" WHEN random_vector(5 DOWNTO 4) = "10" ELSE
              "0111";  -- WHEN random_vector(3 DOWNTO 1) = "11" ELSE
  -----------------------------------------------------------------------------
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      data_wen <= (OTHERS => '1');
      data_ren <= (OTHERS => '1');
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
      data_wen <= rand_wen;
      IF read_stop = '0' THEN
        all_ren_bits: FOR I IN 0 TO 3 LOOP
          IF empty(I) = '1' THEN
            data_ren(I) <= '1';
          ELSE
            data_ren(I) <= rand_ren(I);
          END IF;
        END LOOP all_ren_bits;        
      ELSE
        data_ren <= (OTHERS => '1') ;
      END IF;
    END IF;
  END PROCESS;
  -----------------------------------------------------------------------------
  
  
  --PROCESS (clk, rstn)
  --BEGIN  -- PROCESS
  --  IF rstn = '0' THEN                  -- asynchronous reset (active low)
  --    empty <= (OTHERS => '1');
  --  ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
  --    empty <= empty_s;
  --  END IF;
  --END PROCESS;
  

  --PROCESS (clk, rstn)
  --BEGIN  -- PROCESS
  --  IF rstn = '0' THEN                  -- asynchronous reset (active low)
  --    data_f0_data_out_obs_data <= (OTHERS => '0');
  --    data_f1_data_out_obs_data <= (OTHERS => '0');
  --    data_f2_data_out_obs_data <= (OTHERS => '0');
  --    data_f3_data_out_obs_data <= (OTHERS => '0');
  --    data_f0_data_out_obs      <= '0';
  --    data_f1_data_out_obs      <= '0';
  --    data_f2_data_out_obs      <= '0';
  --    data_f3_data_out_obs      <= '0';

  --    pointer_read  <= (0, 0, 0, 0);
  --    error_now <= (OTHERS => '0');
  --    error_new <= (OTHERS => '0');
      
  --  ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
  --    error_now <= (OTHERS => '0');
  --    CASE data_ren IS
  --      WHEN "1110" => 
  --        IF empty(0) = '0' THEN
  --          error_new(0) <=  '0';
  --          data_f0_data_out_obs_data <= data_f0_data_out(5 DOWNTO 0);
  --          IF pointer_read(0) < 31 THEN
  --            pointer_read(0) <= pointer_read(0)+1;
  --          ELSE
  --            pointer_read(0) <= 0;
  --          END IF;
  --          IF data_f0_data_out /= data_in(0)(pointer_read(0)) THEN
  --            error_now(0) <=  '1';
  --            error_new(0) <=  '1';
  --            data_f0_data_out_obs      <= '1';
  --          END IF;
  --          --IF data_f0_data_out(29 DOWNTO 28) /= "00" THEN
  --          --  data_f0_data_out_obs      <= '1';
  --          --END IF;
  --        END IF;

  --      WHEN "1101" => 
  --        IF empty(1) = '0' THEN
  --          error_new(1) <=  '0';
  --          data_f1_data_out_obs_data <= data_f1_data_out(5 DOWNTO 0);
  --          IF pointer_read(1) < 31 THEN
  --            pointer_read(1) <= pointer_read(1)+1;
  --          ELSE
  --            pointer_read(1) <= 0;
  --          END IF;
  --          IF data_f1_data_out /= data_in(1)(pointer_read(1)) THEN
  --            error_new(1) <=  '1';
  --            error_now(1) <=  '1';
  --            data_f1_data_out_obs      <= '1';
  --          END IF;
  --        END IF;
  --      WHEN "1011" => 
  --        IF empty(2) = '0' THEN
  --          error_new(2) <=  '0';
  --          data_f2_data_out_obs_data <= data_f2_data_out(5 DOWNTO 0);
  --          IF pointer_read(2) < 31 THEN
  --            pointer_read(2) <= pointer_read(2)+1;
  --          ELSE
  --            pointer_read(2) <= 0;
  --          END IF;
  --          IF data_f2_data_out /= data_in(2)(pointer_read(2)) THEN
  --            error_new(2) <=  '1';
  --            error_now(2) <=  '1';
  --            data_f2_data_out_obs      <= '1';
  --          END IF;
  --        END IF;
  --      WHEN "0111" => 
  --        IF empty(3) = '0' THEN
  --          error_new(3) <=  '0';
  --          data_f3_data_out_obs_data <= data_f3_data_out(5 DOWNTO 0);
  --          IF pointer_read(3) < 31 THEN
  --            pointer_read(3) <= pointer_read(3)+1;
  --          ELSE
  --            pointer_read(3) <= 0;
  --          END IF;
  --          IF data_f3_data_out /= data_in(3)(pointer_read(3)) THEN
  --            error_new(3) <=  '1';
  --            error_now(3) <=  '1';
  --            data_f3_data_out_obs      <= '1';
  --          END IF;
  --        END IF;
  --      WHEN "1111" =>
  --        NULL;

          
  --      WHEN OTHERS => 
  --        REPORT "*** ERROR_DATA_REN ***" SEVERITY failure;
  --        NULL;
  --    END CASE;
      
  --  END IF;
  --END PROCESS;

    
  -------------------------------------------------------------------------------
  --clk <= NOT clk AFTER 5 ns;            -- 100 MHz

  -------------------------------------------------------------------------------
  --WaveGen_Proc : PROCESS
  --BEGIN

  --  -- insert signal assignments here
  --  WAIT UNTIL clk = '1';
  --  rstn <= '0';
  --  run  <= '0';
  --  WAIT UNTIL clk = '1';
  --  WAIT UNTIL clk = '1';
  --  WAIT UNTIL clk = '1';
  --  rstn <= '1';
  --  WAIT UNTIL clk = '1';
  --  WAIT UNTIL clk = '1';
  --  WAIT UNTIL clk = '1';
  --  WAIT UNTIL clk = '1';
  --  WAIT UNTIL clk = '1';
  --  run  <= '1';
  --  WAIT UNTIL clk = '1';
  --  WAIT UNTIL clk = '1';
  --  WAIT UNTIL clk = '1';
  --  WAIT UNTIL clk = '1';

  --  WAIT FOR 100 us;
  --  REPORT "*** END simulation ***" SEVERITY failure;
  --  WAIT;

  --END PROCESS WaveGen_Proc;

  -------------------------------------------------------------------------------
  --proc_verif : PROCESS (clk, rstn)
  --BEGIN  -- PROCESS proc_verif
  --  IF rstn = '0' THEN                  -- asynchronous reset (active low)
  --    pointer_write <= (0, 0, 0, 0);
  --  ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
  --    --IF rand_wen = "1111" THEN
  --    CASE rand_wen IS
  --      WHEN "1110" =>
  --        IF full(0) = '0' THEN
  --          IF pointer_write(0) = 128/4-1 THEN
  --            pointer_write(0) <= 0;
  --          ELSE
  --            pointer_write(0) <= pointer_write(0)+1;
  --          END IF;
  --        END IF;
          
  --      WHEN "1101" =>
  --        IF full(1) = '0' THEN
  --          IF pointer_write(1) = 128/4-1 THEN
  --            pointer_write(1) <= 0;
  --          ELSE
  --            pointer_write(1) <= pointer_write(1)+1;
  --          END IF;
  --        END IF;
          
  --      WHEN "1011" =>
  --        IF full(2) = '0' THEN
  --          IF pointer_write(2) = 128/4-1 THEN
  --            pointer_write(2) <= 0;
  --          ELSE
  --            pointer_write(2) <= pointer_write(2)+1;
  --          END IF;
  --        END IF;
  --      WHEN "0111" =>
  --        IF full(3) = '0' THEN
  --          IF pointer_write(3) = 128/4-1 THEN
  --            pointer_write(3) <= 0;
  --          ELSE
  --            pointer_write(3) <= pointer_write(3)+1;
  --          END IF;
  --        END IF;
  --      WHEN OTHERS => NULL;
  --    END CASE;

  --    --END IF;
  --  END IF;
  --END PROCESS proc_verif;

  --wdata <= data_in(0)(pointer_write(0)) WHEN rand_wen(0) = '0' ELSE
  --         data_in(1)(pointer_write(1)) WHEN rand_wen(1) = '0' ELSE
  --         data_in(2)(pointer_write(2)) WHEN rand_wen(2) = '0' ELSE
  --         data_in(3)(pointer_write(3)) WHEN rand_wen(3) = '0' ELSE
  --         (OTHERS => '0');
  
  --data_wen <= rand_wen;

  --data_ren <= rand_ren OR empty;


  
  
END;
