
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.MATH_REAL.ALL;
USE ieee.numeric_std.ALL;

LIBRARY techmap;
USE techmap.gencomp.ALL;

LIBRARY lpp;
USE lpp.iir_filter.ALL;
USE lpp.lpp_ad_conv.ALL;
USE lpp.FILTERcfg.ALL;
USE lpp.lpp_lfr_filter_coeff.ALL;
USE lpp.general_purpose.ALL;
USE lpp.data_type_pkg.ALL;
USE lpp.chirp_pkg.ALL;
USE lpp.lpp_lfr_pkg.ALL;
USE lpp.general_purpose.ALL;

ENTITY testbench IS
END;

ARCHITECTURE behav OF testbench IS

  COMPONENT IIR_CEL_TEST
    PORT (
      rstn           : IN  STD_LOGIC;
      clk            : IN  STD_LOGIC;
      sample_in_val  : IN  STD_LOGIC;
      sample_in      : IN  samplT(7 DOWNTO 0, 17 DOWNTO 0);
      sample_out_val : OUT STD_LOGIC;
      sample_out     : OUT samplT(7 DOWNTO 0, 17 DOWNTO 0));
  END COMPONENT;

  COMPONENT IIR_CEL_TEST_v3
    PORT (
      rstn            : IN  STD_LOGIC;
      clk             : IN  STD_LOGIC;
      sample_in1_val  : IN  STD_LOGIC;
      sample_in1      : IN  samplT(7 DOWNTO 0, 17 DOWNTO 0);
      sample_in2_val  : IN  STD_LOGIC;
      sample_in2      : IN  samplT(7 DOWNTO 0, 17 DOWNTO 0);
      sample_out1_val : OUT STD_LOGIC;
      sample_out1     : OUT samplT(7 DOWNTO 0, 17 DOWNTO 0);
      sample_out2_val : OUT STD_LOGIC;
      sample_out2     : OUT samplT(7 DOWNTO 0, 17 DOWNTO 0));
  END COMPONENT;
  
  SIGNAL clk            : STD_LOGIC := '0';
  SIGNAL clk_24k        : STD_LOGIC := '0';
  SIGNAL clk_24k_r      : STD_LOGIC := '0';
  SIGNAL rstn           : STD_LOGIC;

  SIGNAL sample       : Samples(7 DOWNTO 0);
  SIGNAL sample_val   : STD_LOGIC;
  SIGNAL sample_val_2   : STD_LOGIC;

  SIGNAL data_chirp   : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL data_chirp_2 : STD_LOGIC_VECTOR(15 DOWNTO 0);

  SIGNAL sample_s     :  samplT(7 DOWNTO 0, 17 DOWNTO 0);
  SIGNAL sample_out_s :  samplT(7 DOWNTO 0, 17 DOWNTO 0);
  SIGNAL sample_out_s2 :  samplT(7 DOWNTO 0, 17 DOWNTO 0);
  SIGNAL sample_out_val :  STD_LOGIC;
  
  
  SIGNAL sample_out1_val : STD_LOGIC;
  SIGNAL sample_out2_val : STD_LOGIC;
  SIGNAL sample_out1     : samplT(7 DOWNTO 0, 17 DOWNTO 0);
  SIGNAL sample_out2     : samplT(7 DOWNTO 0, 17 DOWNTO 0);
  SIGNAL sample_out1_reg : samplT(7 DOWNTO 0, 17 DOWNTO 0);
  SIGNAL sample_out2_reg  : samplT(7 DOWNTO 0, 17 DOWNTO 0);
  
  SIGNAL sample_s_v3    :  samplT(7 DOWNTO 0, 17 DOWNTO 0);
  SIGNAL sample_val_v3   : STD_LOGIC;
  SIGNAL sample_val_v3_2   : STD_LOGIC;

  SIGNAL temp : STD_LOGIC;
BEGIN

  -----------------------------------------------------------------------------
  -- CLOCK and RESET
  -----------------------------------------------------------------------------
  clk <= NOT clk AFTER 5 ns;
  PROCESS
  BEGIN  -- PROCESS
    WAIT UNTIL clk = '1';
    rstn <= '0';
    WAIT UNTIL clk = '1';
    WAIT UNTIL clk = '1';
    WAIT UNTIL clk = '1';
    rstn <= '1';
    WAIT FOR 30 ms;
    REPORT "*** END simulation ***" SEVERITY failure;
    WAIT;    
  END PROCESS;
  -----------------------------------------------------------------------------

  
  -----------------------------------------------------------------------------
  -- LPP_LFR_FILTER
  -----------------------------------------------------------------------------
  lpp_lfr_filter_1: lpp_lfr_filter
    GENERIC MAP (
      Mem_use => use_CEL)
    PORT MAP (
      sample           => sample,
      sample_val       => sample_val,
      
      clk              => clk,
      rstn             => rstn,

      data_shaping_SP0 => '0',
      data_shaping_SP1 => '0',
      data_shaping_R0  => '0',
      data_shaping_R1  => '0',
      data_shaping_R2  => '0',

      sample_f0_val    => OPEN,
      sample_f1_val    => OPEN,
      sample_f2_val    => OPEN,
      sample_f3_val    => OPEN,
      sample_f0_wdata  => OPEN,
      sample_f1_wdata  => OPEN,
      sample_f2_wdata  => OPEN,
      sample_f3_wdata  => OPEN);
  -----------------------------------------------------------------------------

  
  -----------------------------------------------------------------------------
  -- SAMPLE GENERATION
  -----------------------------------------------------------------------------
  clk_24k <= NOT clk_24k AFTER 20345 ns;

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                    -- asynchronous reset (active low)
      sample_val <= '0';
      sample_val_2 <= '0';
      clk_24k_r  <= '0';
      temp <= '0';
    ELSIF clk'event AND clk = '1' THEN    -- rising clock edge
      clk_24k_r <= clk_24k;
      IF clk_24k = '1' AND clk_24k_r = '0' THEN
        sample_val   <= '1';
        sample_val_2 <= temp;
        temp         <= NOT temp;
      ELSE
        sample_val   <= '0';
        sample_val_2 <= '0';
      END IF;
    END IF;
  END PROCESS;
  -----------------------------------------------------------------------------
  chirp_1: chirp
    GENERIC MAP (
      LOW_FREQUENCY_LIMIT  => 0,
      HIGH_FREQUENCY_LIMIT => 2000,
      NB_POINT_TO_GEN      => 10000,
      AMPLITUDE            => 100,
      NB_BITS              => 16)
    PORT MAP (
      clk      => clk,
      rstn     => rstn,
      run      => '1',
      data_ack => sample_val,
      data     => data_chirp);
  
  chirp_2: chirp
    GENERIC MAP (
      LOW_FREQUENCY_LIMIT  => 0,
      HIGH_FREQUENCY_LIMIT => 2000,
      NB_POINT_TO_GEN      => 100000,
      AMPLITUDE            => 200,
      NB_BITS              => 16)
    PORT MAP (
      clk      => clk,
      rstn     => rstn,
      run      => '1',
      data_ack => sample_val,
      data     => data_chirp_2);
  
  all_channel: FOR I IN 0 TO 3 GENERATE
    sample(2*I)   <= data_chirp;
    sample(2*I+1) <= data_chirp_2;
  END GENERATE all_channel;
  -----------------------------------------------------------------------------

  all_channel_test: FOR I IN 0 TO 3 GENERATE
    all_bit_test: FOR J IN 0 TO 15 GENERATE
      sample_s(2*I  ,J) <= data_chirp(J);
      sample_s(2*I+1,J) <= data_chirp_2(J);
    END GENERATE all_bit_test;
    sample_s(2*I,16)   <= data_chirp(15);
    sample_s(2*I,17)   <= data_chirp(15);
    sample_s(2*I+1,16) <= data_chirp_2(15);
    sample_s(2*I+1,17) <= data_chirp_2(15);    
  END GENERATE all_channel_test;
  
  IIR_CEL_TEST_1: IIR_CEL_TEST
    PORT MAP (
      rstn           => rstn,
      clk            => clk,
      sample_in_val  => sample_val,
      sample_in      => sample_s,
      sample_out_val => sample_out_val,
      sample_out     => sample_out_s);

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      all_channel: FOR I IN 0 TO 7 LOOP
        all_bit: FOR J IN 0 TO 17 LOOP
          sample_out_s2(I,J) <= '0';
        END LOOP all_bit;
      END LOOP all_channel;

    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      IF sample_out_val = '1' THEN
        sample_out_s2 <= sample_out_s;
      END IF;
    END IF;
  END PROCESS;
  -----------------------------------------------------------------------------
  IIR_CEL_TEST_v3_1: IIR_CEL_TEST_v3
    PORT MAP (
      rstn            => rstn,
      clk             => clk,
      sample_in1_val  => sample_val_v3,
      sample_in1      => sample_s_v3,
      sample_in2_val  => sample_val_v3_2,
      sample_in2      => sample_s_v3,
      sample_out1_val => sample_out1_val,
      sample_out1     => sample_out1,
      sample_out2_val => sample_out2_val,
      sample_out2     => sample_out2);

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      IF sample_val = '1' THEN
        sample_s_v3 <= sample_s;
      END IF;
      sample_val_v3   <= sample_val;
      sample_val_v3_2 <= sample_val_2;
      
      IF sample_out1_val = '1' THEN
        sample_out1_reg <= sample_out1;
      END IF;
      IF sample_out2_val = '1' THEN
        sample_out2_reg <= sample_out2;
      END IF;
    END IF;
    
  END PROCESS;

  
  
END;
