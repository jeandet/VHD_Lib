
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


COMPONENT LFR_EQM IS
  GENERIC (
    Mem_use                : INTEGER := use_RAM;
    USE_BOOTLOADER         : INTEGER := 0;
    USE_ADCDRIVER          : INTEGER := 1;
    tech                   : INTEGER := inferred;
    tech_leon              : INTEGER := inferred;
    DEBUG_FORCE_DATA_DMA   : INTEGER := 0;
    USE_DEBUG_VECTOR       : INTEGER := 0
    );

  PORT (
    clk50MHz    : IN STD_ULOGIC;
    clk49_152MHz : IN STD_ULOGIC;
    reset        : IN STD_ULOGIC;

    TAG          : INOUT STD_LOGIC_VECTOR(9 DOWNTO 1);

    address        : OUT   STD_LOGIC_VECTOR(18 DOWNTO 0);
    data           : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);

    nSRAM_MBE      : INOUT   STD_LOGIC;   -- new
    nSRAM_E1       : OUT   STD_LOGIC;   -- new
    nSRAM_E2       : OUT   STD_LOGIC;   -- new
--    nSRAM_SCRUB    : OUT   STD_LOGIC;   -- new
    nSRAM_W        : OUT   STD_LOGIC;   -- new
    nSRAM_G        : OUT   STD_LOGIC;   -- new
    nSRAM_BUSY     : IN   STD_LOGIC;   -- new
    -- SPW --------------------------------------------------------------------
    spw1_en        : OUT   STD_LOGIC;   -- new
    spw1_din       : IN    STD_LOGIC;
    spw1_sin       : IN    STD_LOGIC;
    spw1_dout      : OUT   STD_LOGIC;
    spw1_sout      : OUT   STD_LOGIC;
    spw2_en        : OUT   STD_LOGIC;   -- new
    spw2_din       : IN    STD_LOGIC;
    spw2_sin       : IN    STD_LOGIC;
    spw2_dout      : OUT   STD_LOGIC;
    spw2_sout      : OUT   STD_LOGIC;
    -- ADC --------------------------------------------------------------------
    bias_fail_sw   : OUT   STD_LOGIC;
    ADC_OEB_bar_CH : OUT   STD_LOGIC_VECTOR(7 DOWNTO 0);
    ADC_smpclk     : OUT   STD_LOGIC;
    ADC_data       : IN    STD_LOGIC_VECTOR(13 DOWNTO 0);
    -- DAC --------------------------------------------------------------------
    DAC_SDO    : OUT STD_LOGIC;
    DAC_SCK    : OUT STD_LOGIC;
    DAC_SYNC   : OUT STD_LOGIC;
    DAC_CAL_EN : OUT STD_LOGIC;
    -- HK ---------------------------------------------------------------------
    HK_smpclk      : OUT   STD_LOGIC;
    ADC_OEB_bar_HK : OUT   STD_LOGIC;
    HK_SEL         : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0)
    );

END LFR_EQM;


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
