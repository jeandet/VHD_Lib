
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

ENTITY testbench IS
GENERIC(
    tech          : INTEGER := 0; --axcel,
    Mem_use       : INTEGER := use_CEL --use_RAM
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
  SIGNAL clk_24k   : STD_LOGIC := '0';
  SIGNAL clk_24k_r : STD_LOGIC := '0';
  SIGNAL rstn      : STD_LOGIC;

  SIGNAL signal_gen : Samples(7 DOWNTO 0);
  SIGNAL offset_gen : Samples(7 DOWNTO 0);

  --SIGNAL sample_fx_wdata : STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);

  SIGNAL sample_fx_wdata : Samples(ChanelCount-1 DOWNTO 0);


  COMPONENT generator IS
    GENERIC (
      AMPLITUDE : INTEGER := 100;
      NB_BITS   : INTEGER := 16);

    PORT (
      clk  : IN STD_LOGIC;
      rstn : IN STD_LOGIC;
      run  : IN STD_LOGIC;

      data_ack : IN  STD_LOGIC;
      offset   : IN  STD_LOGIC_VECTOR(NB_BITS-1 DOWNTO 0);
      data     : OUT STD_LOGIC_VECTOR(NB_BITS-1 DOWNTO 0)
      );
  END COMPONENT;


  FILE log_input     : TEXT OPEN write_mode IS "log_input.txt";
  FILE log_output_fx : TEXT OPEN write_mode IS "log_output_fx.txt";

  SIGNAL end_of_simu : STD_LOGIC := '0';

BEGIN

  -----------------------------------------------------------------------------
  -- CLOCK and RESET
  -----------------------------------------------------------------------------
  clk <= NOT clk AFTER 5 ns;
  PROCESS
  BEGIN  -- PROCESS
    end_of_simu <= '0';
    WAIT UNTIL clk = '1';
    rstn <= '0';
    WAIT UNTIL clk = '1';
    WAIT UNTIL clk = '1';
    WAIT UNTIL clk = '1';
    rstn <= '1';
    WAIT FOR 2000 ms;
    end_of_simu <= '1';
    WAIT UNTIL clk = '1';    
    REPORT "*** END simulation ***" SEVERITY failure;
    WAIT;
  END PROCESS;
  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  -- COMMON TIMESTAMPS
  -----------------------------------------------------------------------------

  PROCESS(clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      TSTAMP <= TSTAMP+1;
    END IF;
  END PROCESS;
  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  -- LPP_LFR_FILTER f0
  -----------------------------------------------------------------------------

  IIR_CEL_CTRLR_v2_1 : IIR_CEL_CTRLR_v2
    GENERIC MAP (
      tech         => tech,
      Mem_use      => use_RAM,
      Sample_SZ    => 18,
      Coef_SZ      => Coef_SZ,
      Coef_Nb      => 25,
      Coef_sel_SZ  => 5,
      Cels_count   => Cels_count,
      ChanelsCount => ChanelCount,
      FILENAME     => "RAM.txt")
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
  clk_24k <= NOT clk_24k AFTER 20345 ns;

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      sample_val <= '0';
      clk_24k_r  <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
      clk_24k_r <= clk_24k;
      IF clk_24k = '1' AND clk_24k_r = '0' THEN
        sample_val <= '1';
      ELSE
        sample_val <= '0';
      END IF;
    END IF;
  END PROCESS;
  -----------------------------------------------------------------------------
  generators : FOR I IN 0 TO 7 GENERATE
    gen1 : generator
      GENERIC MAP (
        AMPLITUDE => 100,
        NB_BITS   => 16)
      PORT MAP (
        clk      => clk,
        rstn     => rstn,
        run      => '1',
        data_ack => sample_val,
        offset   => offset_gen(I),
        data     => signal_gen(I)
        );
    offset_gen(I) <= STD_LOGIC_VECTOR(to_signed((I*200), 16));
  END GENERATE generators;

  ChanelLoop : FOR i IN 0 TO ChanelCount-1 GENERATE
    SampleLoop : FOR j IN 0 TO 15 GENERATE
      sample(i,j) <= signal_gen(i)(j);
      sample_fx_wdata(i)(j) <= sample_fx(i,j);
    END GENERATE;

    sample(i, 16) <= signal_gen(i)(15);
    sample(i, 17) <= signal_gen(i)(15);
  END GENERATE;

  
    
  -----------------------------------------------------------------------------
  --  RECORD SIGNALS
  -----------------------------------------------------------------------------

  -- PROCESS(sample_val)
  --   VARIABLE line_var : LINE;
  -- BEGIN
  --   IF sample_val'EVENT AND sample_val = '1' THEN
  --     write(line_var, INTEGER'IMAGE(TSTAMP));
  --     FOR I IN 0 TO 7 LOOP
  --       write(line_var, "  " & INTEGER'IMAGE(to_integer(SIGNED(signal_gen(I)))));
  --     END LOOP;
  --     writeline(log_input, line_var);
  --   END IF;
  --  END PROCESS;

  PROCESS(sample_fx_val,end_of_simu)
    VARIABLE line_var : LINE;
  BEGIN
    IF sample_fx_val'EVENT AND sample_fx_val = '1' THEN
      write(line_var, INTEGER'IMAGE(TSTAMP));
      FOR I IN 0 TO 5 LOOP
        write(line_var, "  " & INTEGER'IMAGE(to_integer(SIGNED(sample_fx_wdata(I)))));
      END LOOP;
      writeline(log_output_fx, line_var);
    END IF;
    IF end_of_simu = '1' THEN
      file_close(log_output_fx);
    END IF;
  END PROCESS;




END;
