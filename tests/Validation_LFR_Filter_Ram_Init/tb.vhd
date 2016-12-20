
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
USE IEEE.std_logic_signed.ALL;
USE IEEE.MATH_real.ALL;

LIBRARY techmap;
USE techmap.gencomp.ALL;

library std;
use std.textio.all;

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
    tech          : INTEGER := axcel; --axcel,0
    Mem_use       : INTEGER := use_RAM --use_RAM,use_CEL
);
END;

ARCHITECTURE behav OF testbench IS
  CONSTANT ChanelCount   : INTEGER := 8;

  SIGNAL TSTAMP         : INTEGER:=0;
  SIGNAL clk            : STD_LOGIC := '0';
  SIGNAL clk_98304Hz        : STD_LOGIC := '0';
  SIGNAL clk_98304Hz_r      : STD_LOGIC := '0';
  SIGNAL rstn           : STD_LOGIC;

  SIGNAL signal_gen     :  sample_vector(0 to ChanelCount-1,15 downto 0);

  SIGNAL sample       : Samples(7 DOWNTO 0);

  SIGNAL sample_val   : STD_LOGIC;

  SIGNAL sample_f0_val   : STD_LOGIC;
  SIGNAL sample_f1_val   : STD_LOGIC;
  SIGNAL sample_f2_val   : STD_LOGIC;
  SIGNAL sample_f3_val   : STD_LOGIC;

  SIGNAL sample_f0_wdata : STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
  SIGNAL sample_f1_wdata : STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
  SIGNAL sample_f2_wdata : STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
  SIGNAL sample_f3_wdata : STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);

  SIGNAL signal_f0_rec : sample_vector(0 to 5,15 downto 0);
  SIGNAL signal_f1_rec : sample_vector(0 to 5,15 downto 0);
  SIGNAL signal_f2_rec : sample_vector(0 to 5,15 downto 0);
  SIGNAL signal_f3_rec : sample_vector(0 to 5,15 downto 0);

  SIGNAL end_of_simu : STD_LOGIC := '0';

  CONSTANT half_samplig_period : time :=  5086263 ps;--INTEGER( REAL(REAL(1000**4) / REAL(2.0*4.0*24576.0))) * 1 ps;



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


  clk_98304Hz_gen:PROCESS
  BEGIN
    IF end_of_simu /= '1' THEN
      clk_98304Hz <= NOT clk_98304Hz;
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
  -- LPP_LFR_FILTER
  -----------------------------------------------------------------------------
  lpp_lfr_filter_1: lpp_lfr_filter
    GENERIC MAP (
      tech    => tech,
      Mem_use => Mem_use,
      RTL_DESIGN_LIGHT =>0,
      DATA_SHAPING_SATURATION => 0                 
      )
    PORT MAP (
      sample           => sample,
      sample_val       => sample_val,
      sample_time      => (others=>'0'),
      clk              => clk,
      rstn             => rstn,

      data_shaping_SP0 => '0',
      data_shaping_SP1 => '0',
      data_shaping_R0  => '0',
      data_shaping_R1  => '0',
      data_shaping_R2  => '0',

      sample_f0_val    => sample_f0_val,
      sample_f1_val    => sample_f1_val,
      sample_f2_val    => sample_f2_val,
      sample_f3_val    => sample_f3_val,

      sample_f0_wdata  => sample_f0_wdata,
      sample_f1_wdata  => sample_f1_wdata,
      sample_f2_wdata  => sample_f2_wdata,
      sample_f3_wdata  => sample_f3_wdata
      );
  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  -- SAMPLE PULSE GENERATION
  -----------------------------------------------------------------------------
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      sample_val <= '0';
      clk_98304Hz_r  <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
        IF end_of_simu /= '1' THEN
            clk_98304Hz_r <= clk_98304Hz;
            IF clk_98304Hz = '1' AND clk_98304Hz_r = '0' THEN
                sample_val <= '1';
            ELSE
                sample_val <= '0';
            END IF;
        END IF;
    END IF;
  END PROCESS;
  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  --  READ INPUT SIGNALS
  -----------------------------------------------------------------------------
gen: sig_reader
  GENERIC MAP(
        FNAME       => "input.txt",
        WIDTH       => ChanelCount,
        RESOLUTION  => 16,
        GAIN        => 1.0
    )
    PORT MAP(
        clk             => sample_val,
        end_of_simu     => end_of_simu,
        out_signal      => signal_gen
    );

ChanelLoop : FOR i IN 0 TO ChanelCount-1 GENERATE
    SampleLoop : FOR j IN 0 TO 15 GENERATE
      sample(I)(J)  <= signal_gen(I,J);
  END GENERATE;
END GENERATE;

output_splitter: FOR CHAN IN 0 TO 5 GENERATE
    bits_splitter: FOR BIT IN 0 TO 15 GENERATE
        signal_f0_rec(CHAN,BIT)  <= sample_f0_wdata((CHAN*16) + BIT);
        signal_f1_rec(CHAN,BIT)  <= sample_f1_wdata((CHAN*16) + BIT);
        signal_f2_rec(CHAN,BIT)  <= sample_f2_wdata((CHAN*16) + BIT);
        signal_f3_rec(CHAN,BIT)  <= sample_f3_wdata((CHAN*16) + BIT);
    END GENERATE bits_splitter;
END GENERATE output_splitter;


  -----------------------------------------------------------------------------
  --  RECORD SIGNALS
  -----------------------------------------------------------------------------

f0_rec : sig_recorder
  GENERIC MAP(
      FNAME       => "output_f0.txt",
      WIDTH       => 6,
      RESOLUTION  => 16
  )
  PORT MAP(
      clk             => sample_f0_val,
      end_of_simu     => end_of_simu,
      timestamp       => TSTAMP,
      input_signal    => signal_f0_rec
  );

f1_rec : sig_recorder
  GENERIC MAP(
      FNAME       => "output_f1.txt",
      WIDTH       => 6,
      RESOLUTION  => 16
  )
  PORT MAP(
      clk             => sample_f1_val,
      end_of_simu     => end_of_simu,
      timestamp       => TSTAMP,
      input_signal    => signal_f1_rec
  );

f2_rec : sig_recorder
  GENERIC MAP(
      FNAME       => "output_f2.txt",
      WIDTH       => 6,
      RESOLUTION  => 16
  )
  PORT MAP(
      clk             => sample_f2_val,
      end_of_simu     => end_of_simu,
      timestamp       => TSTAMP,
      input_signal    => signal_f2_rec
  );

f3_rec : sig_recorder
  GENERIC MAP(
      FNAME       => "output_f3.txt",
      WIDTH       => 6,
      RESOLUTION  => 16
  )
  PORT MAP(
      clk             => sample_f3_val,
      end_of_simu     => end_of_simu,
      timestamp       => TSTAMP,
      input_signal    => signal_f3_rec
  );

END;
