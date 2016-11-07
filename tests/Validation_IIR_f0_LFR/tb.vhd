
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.std_logic_signed.ALL;
USE IEEE.MATH_real.ALL;

LIBRARY techmap;
USE techmap.gencomp.ALL;

LIBRARY std;
USE std.textio.ALL;

LIBRARY lpp;
USE lpp.iir_filter.ALL;
USE lpp.lpp_ad_conv.ALL;
USE lpp.FILTERcfg.ALL;
USE lpp.lpp_lfr_filter_coeff.ALL;
USE lpp.general_purpose.ALL;
USE lpp.data_type_pkg.ALL;
USE lpp.lpp_lfr_pkg.ALL;
USE lpp.general_purpose.ALL;
USE lpp.lpp_sim_pkg.ALL;

ENTITY testbench IS
GENERIC(
    tech          : INTEGER := 0; --axcel,0
    Mem_use       : INTEGER := use_CEL --use_RAM,use_CEL
);
END;

ARCHITECTURE behav OF testbench IS
  CONSTANT ChanelCount   : INTEGER := 8;
  CONSTANT Coef_SZ       : INTEGER := 9;
  CONSTANT CoefCntPerCel : INTEGER := 6;
  CONSTANT CoefPerCel    : INTEGER := 5;
  CONSTANT Cels_count    : INTEGER := 5;

  SIGNAL sample     : samplT(ChanelCount-1 DOWNTO 0, 17 DOWNTO 0);
  SIGNAL sample_val : STD_LOGIC;

  SIGNAL sample_fx     : samplT(ChanelCount-1 DOWNTO 0, 17 DOWNTO 0);
  SIGNAL sample_fx_val : STD_LOGIC;


  SIGNAL TSTAMP    : INTEGER   := 0;
  SIGNAL clk       : STD_LOGIC := '0';
  SIGNAL clk_98304Hz   : STD_LOGIC := '0';
  SIGNAL clk_98304Hz_r : STD_LOGIC := '0';
  SIGNAL rstn      : STD_LOGIC;

  SIGNAL signal_gen : sample_vector(0 to ChanelCount-1,17 downto 0);
  SIGNAL sample_fx_wdata : Samples(ChanelCount-1 DOWNTO 0);
  SIGNAL signal_rec : sample_vector(0 to ChanelCount-1,15 downto 0);

  SIGNAL end_of_simu : STD_LOGIC := '0';

  CONSTANT half_samplig_period : time := INTEGER( REAL(1000**4) / REAL(24576.0*4.0*2)) * 1 ps;

BEGIN

  -----------------------------------------------------------------------------
  -- CLOCK and RESET
  -----------------------------------------------------------------------------
  PROCESS
  BEGIN  -- PROCESS
    WAIT UNTIL clk = '1';
    rstn <= '0';
    WAIT UNTIL clk = '1';
    WAIT UNTIL clk = '1';
    WAIT UNTIL clk = '1';
    rstn <= '1';
    WAIT UNTIL end_of_simu = '1';
    WAIT UNTIL clk = '1';
    assert false report "end of test" severity note;
    --  Wait forever; this will finish the simulation.
    wait;
  END PROCESS;
  -----------------------------------------------------------------------------


  clk_98304Hz_gen:PROCESS
  BEGIN
    IF end_of_simu /= '1' THEN
      clk_98304Hz <= NOT clk_98304Hz;
      WAIT FOR half_samplig_period;
    ELSE
      assert false report "end of test" severity note;
      WAIT;
    END IF;
  END PROCESS;

  clk_25M_gen:PROCESS
  BEGIN
    IF end_of_simu /= '1' THEN
      clk <= NOT clk;
      TSTAMP <= TSTAMP+20;
      WAIT FOR 20 ns;
    ELSE
      assert false report "end of test" severity note;
      WAIT;
    END IF;
  END PROCESS;


  -----------------------------------------------------------------------------
  -- LPP_LFR_FILTER f0
  -----------------------------------------------------------------------------

  IIR_CEL_CTRLR_v2_1 : IIR_CEL_CTRLR_v2
    GENERIC MAP (
      tech         => tech,
      Mem_use      => Mem_use,
      Sample_SZ    => 18,
      Coef_SZ      => Coef_SZ,
      Coef_Nb      => 25,
      Coef_sel_SZ  => 5,
      Cels_count   => Cels_count,
      ChanelsCount => ChanelCount,
      FILENAME     => "")
    PORT MAP (
      rstn     => rstn,
      clk      => clk,
      virg_pos => 7,
      coefs    => CoefsInitValCst_v2,

      sample_in_val  => sample_val,
      sample_in      => sample,
      sample_out_val => sample_fx_val,
      sample_out     => sample_fx);
  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  -- SAMPLE GENERATION
  -----------------------------------------------------------------------------


  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      sample_val <= '0';
      clk_98304Hz_r  <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
      clk_98304Hz_r <= clk_98304Hz;
      IF clk_98304Hz = '1' AND clk_98304Hz_r = '0' THEN
        sample_val <= '1';
      ELSE
        sample_val <= '0';
      END IF;
    END IF;
  END PROCESS;
  -----------------------------------------------------------------------------

  ChanelLoop : FOR i IN 0 TO ChanelCount-1 GENERATE
    SampleLoop : FOR j IN 0 TO 15 GENERATE
      sample_fx_wdata(i)(j) <= sample_fx(i,j);
      signal_rec(i,j) <= sample_fx_wdata(i)(j);
      sample(i,j) <= signal_gen(i,j);
    END GENERATE;
      sample(i,16) <= signal_gen(i,16);
      sample(i,17) <= signal_gen(i,17);
  END GENERATE;



  -----------------------------------------------------------------------------
  --  READ INPUT SIGNALS
  -----------------------------------------------------------------------------

  gen: sig_reader
  GENERIC MAP(
        FNAME       => "input.txt",
        WIDTH       => ChanelCount,
        RESOLUTION  => 18,
        GAIN        => 1.0
    )
    PORT MAP(
        clk             => sample_val,
        end_of_simu     => end_of_simu,
        out_signal      => signal_gen
    );


  -----------------------------------------------------------------------------
  --  RECORD OUTPUT SIGNALS
  -----------------------------------------------------------------------------

  rec : sig_recorder
  GENERIC MAP(
      FNAME       => "output_fx.txt",
      WIDTH       => ChanelCount,
      RESOLUTION  => 16
  )
  PORT MAP(
      clk             => sample_fx_val,
      end_of_simu     => end_of_simu,
      timestamp       => TSTAMP,
      input_signal    => signal_rec
  );

END;
