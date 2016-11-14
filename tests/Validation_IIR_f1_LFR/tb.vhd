
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
USE lpp.lpp_waveform_pkg.ALL;

ENTITY testbench IS
GENERIC(
    tech          : INTEGER := 0; --axcel,0
    Mem_use       : INTEGER := use_CEL --use_RAM,use_CEL
);
END;

ARCHITECTURE behav OF testbench IS
 -----------------------------------------------------------------------------
  -- CONFIG FILTER IIR f0 to f1
  -----------------------------------------------------------------------------
  CONSTANT f0_to_f1_CEL_NUMBER           : INTEGER := 5;
  CONSTANT f0_to_f1_COEFFICIENT_SIZE     : INTEGER := 10;
  CONSTANT f0_to_f1_POINT_POSITION       : INTEGER := 8;

  CONSTANT f0_to_f1_sos : COEFF_CEL_ARRAY_REAL(1 TO 5) :=
    (
      (1.0, -1.61171504942096,  1.0, 1.0, -1.68876443778669,  0.908610171614583),
      (1.0, -1.53324505744412,  1.0, 1.0, -1.51088513595779,  0.732564401274351),
      (1.0, -1.30646173160060,  1.0, 1.0, -1.30571711968384,  0.546869268827102),
      (1.0, -0.651038739239370, 1.0, 1.0, -1.08747326287406,  0.358436944718464),
      (1.0,  1.24322747034001,  1.0, 1.0, -0.929530176676438, 0.224862726961691)
    );
  CONSTANT f0_to_f1_gain : COEFF_CEL_REAL :=
    ( 0.566196896119831, 0.474937156750133, 0.347712822970540, 0.200868393871900, 0.0910613125308450, 1.0);

  CONSTANT coefs_iir_cel_f0_to_f1 : STD_LOGIC_VECTOR((f0_to_f1_CEL_NUMBER*f0_to_f1_COEFFICIENT_SIZE*5)-1 DOWNTO 0)
    :=  get_IIR_CEL_FILTER_CONFIG(
      f0_to_f1_COEFFICIENT_SIZE,
      f0_to_f1_POINT_POSITION,
      f0_to_f1_CEL_NUMBER,
      f0_to_f1_sos,
      f0_to_f1_gain);

  CONSTANT ChanelCount     : INTEGER := 6;
  -----------------------------------------------------------------------------

  SIGNAL sample     : samplT(ChanelCount-1 DOWNTO 0, 17 DOWNTO 0);
  SIGNAL sample_val : STD_LOGIC;

  SIGNAL sample_fx     : samplT(ChanelCount-1 DOWNTO 0, 17 DOWNTO 0);
  SIGNAL sample_fx_val : STD_LOGIC;


  SIGNAL TSTAMP    : INTEGER   := 0;
  SIGNAL clk       : STD_LOGIC := '0';
  SIGNAL clk_24576Hz   : STD_LOGIC := '0';
  SIGNAL clk_24576Hz_r : STD_LOGIC := '0';
  SIGNAL rstn      : STD_LOGIC;

  SIGNAL signal_gen : sample_vector(0 to ChanelCount-1,17 downto 0);
  SIGNAL sample_fx_wdata : Samples(ChanelCount-1 DOWNTO 0);
  SIGNAL signal_rec : sample_vector(0 to ChanelCount-1,15 downto 0);

  SIGNAL end_of_simu : STD_LOGIC := '0';

  CONSTANT half_samplig_period : time := 20345052 ps; --INTEGER( REAL(1000**4) / REAL(2.0*24576.0)) * 1 ps;

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
    WAIT FOR 10 ps;
    assert false report "end of test" severity note;
    --  Wait forever; this will finish the simulation.
    wait;
  END PROCESS;
  -----------------------------------------------------------------------------


  clk_24576Hz_gen:PROCESS
  BEGIN
    IF end_of_simu /= '1' THEN
      clk_24576Hz <= NOT clk_24576Hz;
      WAIT FOR half_samplig_period;
    ELSE
      WAIT FOR 10 ps;
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
      WAIT FOR 10 ps;
      assert false report "end of test" severity note;
      WAIT;
    END IF;
  END PROCESS;


  -----------------------------------------------------------------------------
  -- LPP_LFR_FILTER f1
  -----------------------------------------------------------------------------

    IIR_CEL_f0_to_f1 : IIR_CEL_CTRLR_v2
    GENERIC MAP (
      tech         => tech,
      Mem_use      => Mem_use,          -- use_RAM
      Sample_SZ    => 18,
      Coef_SZ      => f0_to_f1_COEFFICIENT_SIZE,
      Coef_Nb      => f0_to_f1_CEL_NUMBER*5,
      Coef_sel_SZ  => 5,
      Cels_count   => f0_to_f1_CEL_NUMBER,
      ChanelsCount => ChanelCount,
      FILENAME     => ""
      )
    PORT MAP (
      rstn           => rstn,
      clk            => clk,
      virg_pos       => f0_to_f1_POINT_POSITION,
      coefs          => coefs_iir_cel_f0_to_f1,

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
      clk_24576Hz_r  <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
      clk_24576Hz_r <= clk_24576Hz;
      IF clk_24576Hz = '1' AND clk_24576Hz_r = '0' THEN
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
