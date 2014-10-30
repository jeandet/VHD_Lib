
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.MATH_REAL.ALL;
USE ieee.numeric_std.ALL;

LIBRARY lpp;
USE lpp.cic_pkg.ALL;
USE lpp.chirp_pkg.ALL;

ENTITY testbench IS
END;

ARCHITECTURE behav OF testbench IS

  SIGNAL clk            : STD_LOGIC := '0';
  SIGNAL rstn           : STD_LOGIC;
  SIGNAL run            : STD_LOGIC;
  SIGNAL data_in        : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL data_in_valid  : STD_LOGIC;
  SIGNAL data_out       : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL data_out_valid : STD_LOGIC;
  
BEGIN

  clk <= NOT clk AFTER 5 ns;

  PROCESS
  BEGIN  -- PROCESS
    WAIT UNTIL clk = '1';
    rstn <= '0';
    run  <= '0';
    data_in_valid <= '0';
    
    WAIT UNTIL clk = '1';
    rstn <= '1';
    WAIT UNTIL clk = '1';
    WAIT UNTIL clk = '1';
    run <= '1';
    WAIT UNTIL clk = '1';
    WAIT UNTIL clk = '1';
    data_in_valid <= '1';
    WAIT FOR 105 us;
    REPORT "*** END simulation ***" SEVERITY failure;
    WAIT;    
  END PROCESS;
  -----------------------------------------------------------------------------
  DUT_cic: cic
    GENERIC MAP (
      D_delay_number                   => 2,
      S_stage_number                   => 3,
      R_downsampling_decimation_factor => 16,
      b_data_size                      => 16,
      b_grow                           => 15)
    PORT MAP (
      clk            => clk,
      rstn           => rstn,
      run            => run,
      data_in        => data_in,
      data_in_valid  => data_in_valid,
      data_out       => data_out,
      data_out_valid => data_out_valid);
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
      data     => data_in);
  
END;
