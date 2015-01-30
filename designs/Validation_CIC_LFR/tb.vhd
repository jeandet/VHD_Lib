
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
  SIGNAL data_gen       : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL data_in_v_r2   : sample_vector(7 DOWNTO 0,15 DOWNTO 0);
  SIGNAL data_in_v      : sample_vector(5 DOWNTO 0,15 DOWNTO 0);
  SIGNAL data_in_valid  : STD_LOGIC;
 
  CONSTANT DATA_VALUE_0 : STD_LOGIC_VECTOR(15 DOWNTO 0) := X"7FFF";
  CONSTANT DATA_VALUE_1 : STD_LOGIC_VECTOR(15 DOWNTO 0) := X"FFFF";
  CONSTANT DATA_VALUE_2 : STD_LOGIC_VECTOR(15 DOWNTO 0) := X"8000";
  CONSTANT DATA_VALUE_3 : STD_LOGIC_VECTOR(15 DOWNTO 0) := X"0010";
  CONSTANT DATA_VALUE_4 : STD_LOGIC_VECTOR(15 DOWNTO 0) := X"0020";
  CONSTANT DATA_VALUE_5 : STD_LOGIC_VECTOR(15 DOWNTO 0) := X"0040";
  
  SIGNAL data_in_0_s      : STD_LOGIC_VECTOR(15 DOWNTO 0);
  
  SIGNAL data_in_0        : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL data_in_1        : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL data_in_2        : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL data_in_3        : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL data_in_4        : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL data_in_5        : STD_LOGIC_VECTOR(15 DOWNTO 0);
  
  SIGNAL data_in_0_temp        : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL data_in_1_temp        : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL data_in_2_temp        : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL data_in_3_temp        : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL data_in_4_temp        : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL data_in_5_temp        : STD_LOGIC_VECTOR(15 DOWNTO 0);

  SIGNAL param_r2 : STD_LOGIC;
  
BEGIN


  
  clk <= NOT clk AFTER 5 ns;
  clk_24k <= NOT clk_24k AFTER 20345 ns;

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                    -- asynchronous reset (active low)
      data_in_valid <= '0';
      clk_24k_r <= '0';
    ELSIF clk'event AND clk = '1' THEN    -- rising clock edge
      clk_24k_r <= clk_24k;
      IF clk_24k = '1' AND clk_24k_r = '0' THEN
        data_in_valid <= '1';
      ELSE
        data_in_valid <= '0';
      END IF;
    END IF;
  END PROCESS;
  
  
  PROCESS
  BEGIN  -- PROCESS
    WAIT UNTIL clk = '1';
    rstn <= '0';
    run  <= '0';
    param_r2 <= '1';  
    WAIT UNTIL clk = '1';
    rstn <= '1';
    WAIT UNTIL clk = '1';
    WAIT UNTIL clk = '1';
    run <= '1';
    WAIT UNTIL clk = '1';
    
    WAIT FOR 30 ms;
    param_r2 <= '0';
    
    WAIT FOR 30 ms;
    REPORT "*** END simulation ***" SEVERITY failure;
    WAIT;    
  END PROCESS;
  -----------------------------------------------------------------------------
  cic_lfr_1: cic_lfr
    GENERIC MAP (
      tech         => 0,
      use_RAM_nCEL => 0)
    PORT MAP (
      clk                => clk,
      rstn               => rstn,
      run                => run,
      data_in            => data_in_v,
      data_in_valid      => data_in_valid,
      data_out_16        => OPEN,
      data_out_16_valid  => OPEN,
      data_out_256       => OPEN,
      data_out_256_valid => OPEN);
  -----------------------------------------------------------------------------
  cic_lfr_r2_1: cic_lfr_r2
    GENERIC MAP (
      tech         => 0,
      use_RAM_nCEL => 0)
    PORT MAP (
      clk                => clk,
      rstn               => rstn,
      run                => run,
      param_r2           => param_r2,
      data_in            => data_in_v_r2,
      data_in_valid      => data_in_valid,
      data_out_16        => OPEN,
      data_out_16_valid  => OPEN, 
      data_out_256       => OPEN, 
      data_out_256_valid => OPEN);
  
  -----------------------------------------------------------------------------
  all_bit_r2: FOR J IN 15 DOWNTO 0 GENERATE
    data_in_v_r2(0,J) <= data_in_0(J);
    data_in_v_r2(1,J) <= data_in_1(J);
    data_in_v_r2(2,J) <= data_in_2(J);
    data_in_v_r2(3,J) <= data_in_3(J);
    data_in_v_r2(4,J) <= data_in_4(J);
    data_in_v_r2(5,J) <= data_in_5(J);
    data_in_v_r2(6,J) <= data_in_0(J);
    data_in_v_r2(7,J) <= data_in_0(J);
  END GENERATE all_bit_r2;
  -----------------------------------------------------------------------------
  all_bit: FOR J IN 15 DOWNTO 0 GENERATE
    data_in_v(0,J) <= data_in_0(J);
    data_in_v(1,J) <= data_in_1(J);
    data_in_v(2,J) <= data_in_2(J);
    data_in_v(3,J) <= data_in_3(J);
    data_in_v(4,J) <= data_in_4(J);
    data_in_v(5,J) <= data_in_5(J);
  END GENERATE all_bit;
  -----------------------------------------------------------------------------
  --chirp_gen: chirp
  --  GENERIC MAP (
  --    LOW_FREQUENCY_LIMIT  => 0,
  --    HIGH_FREQUENCY_LIMIT => 1000,
  --    NB_POINT_TO_GEN      => 10000,
  --    AMPLITUDE            => 200,
  --    NB_BITS              => 16)
  --  PORT MAP (
  --    clk      => clk,
  --    rstn     => rstn,
  --    run      => run,
  --    data_ack => data_in_valid,
  --    data     => data_in);

  PROCESS (clk, rstn)
  BEGIN
    IF rstn = '0' THEN
      data_in_0_temp <= (OTHERS => '0');
      data_in_1_temp <= (OTHERS => '0');
      data_in_2_temp <= (OTHERS => '0');
      data_in_3_temp <= (OTHERS => '0');
      data_in_4_temp <= (OTHERS => '0');
      data_in_5_temp <= (OTHERS => '0');
    ELSIF clk'event AND clk = '1' THEN
      IF data_in_valid = '1' THEN
        data_in_0_temp <= DATA_VALUE_0;
        data_in_1_temp <= DATA_VALUE_1;
        data_in_2_temp <= DATA_VALUE_2;
        data_in_3_temp <= DATA_VALUE_3;
        data_in_4_temp <= DATA_VALUE_4;
        data_in_5_temp <= DATA_VALUE_5;
      END IF;
    END IF;
  END PROCESS;
  --data_in_0 <= data_in_0_temp WHEN data_in_valid = '0' ELSE DATA_VALUE_0;
  data_in_1 <= data_in_1_temp WHEN data_in_valid = '0' ELSE DATA_VALUE_1;
  data_in_2 <= data_in_2_temp WHEN data_in_valid = '0' ELSE DATA_VALUE_2;
  data_in_3 <= data_in_3_temp WHEN data_in_valid = '0' ELSE DATA_VALUE_3;
  data_in_4 <= data_in_4_temp WHEN data_in_valid = '0' ELSE DATA_VALUE_4;
  data_in_5 <= data_in_5_temp WHEN data_in_valid = '0' ELSE DATA_VALUE_5;
  
  -----------------------------------------------------------------------------
  chirp_gen: chirp
    GENERIC MAP (
      LOW_FREQUENCY_LIMIT  => 0,
      HIGH_FREQUENCY_LIMIT => 1000,
      NB_POINT_TO_GEN      => 10000,
      AMPLITUDE            => 200,
      NB_BITS              => 16)
    PORT MAP (
      clk      => clk,
      rstn     => rstn,
      run      => run,
      data_ack => data_in_valid,
      data     => data_in_0_s);
  
  -----------------------------------------------------------------------------

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      data_in_0 <= (OTHERS => '0');
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      IF data_in_valid = '1' THEN
        data_in_0 <= data_in_0_s;
      END IF;
    END IF;
  END PROCESS;
  
  -----------------------------------------------------------------------------
  cic_1: cic
    GENERIC MAP (
      D_delay_number                   => 2,
      S_stage_number                   => 3,
      R_downsampling_decimation_factor => 16,
      b_data_size                      => 16,
      b_grow                           => 15)  --16 #### log2(RD)*S
    PORT MAP (
      clk            => clk,
      rstn           => rstn,
      run            => run,
      data_in        => data_in_0_s,
      data_in_valid  => data_in_valid,
      data_out       => OPEN,
      data_out_valid => OPEN);
  
  --cic_16: cic
  --  GENERIC MAP (
  --    D_delay_number                   => 2,
  --    S_stage_number                   => 3,
  --    R_downsampling_decimation_factor => 16,
  --    b_data_size                      => 16,
  --    b_grow                           => 15)  --16 #### log2(RD)*S
  --  PORT MAP (
  --    clk            => clk,
  --    rstn           => rstn,
  --    run            => run,
  --    data_in        => data_in_0_s,
  --    data_in_valid  => data_in_valid,
  --    data_out       => OPEN,
  --    data_out_valid => OPEN);

  cic_256: cic
    GENERIC MAP (
      D_delay_number                   => 2,
      S_stage_number                   => 3,
      R_downsampling_decimation_factor => 256,
      b_data_size                      => 16,
      b_grow                           => 27)  --32 #### log2(RD)*S = log2(256*2)*3
    PORT MAP (
      clk            => clk,
      rstn           => rstn,
      run            => run,
      data_in        => data_in_0_s,
      data_in_valid  => data_in_valid,
      data_out       => OPEN,
      data_out_valid => OPEN);

  

  
  
END;
