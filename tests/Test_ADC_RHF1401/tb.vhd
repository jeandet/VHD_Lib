
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.std_logic_signed.ALL;
USE IEEE.MATH_real.ALL;

LIBRARY techmap;
USE techmap.gencomp.ALL;

LIBRARY std;
USE std.textio.ALL;

LIBRARY opencores;
USE opencores.spwpkg.ALL;
USE opencores.spwambapkg.ALL;

LIBRARY lpp;
USE lpp.lpp_sim_pkg.ALL;
USE lpp.lpp_ad_conv.ALL;

ENTITY testbench IS
END;

ARCHITECTURE behav OF testbench IS

  SIGNAL TSTAMP : INTEGER   := 0;
  
  SIGNAL clk_25    : STD_LOGIC := '0';
  SIGNAL rstn_25    : STD_LOGIC;
  SIGNAL clk_24    : STD_LOGIC := '0';
  SIGNAL rstn_24    : STD_LOGIC;

  SIGNAL end_of_simu : STD_LOGIC := '0';

  SIGNAL ADC_smpclk_s : STD_LOGIC;
  
  SIGNAL ADC_data   : Samples14;
  SIGNAL ADC_OEB_bar_CH_s    : STD_LOGIC_VECTOR(8 DOWNTO 0);
  SIGNAL sample     : Samples14v(8 DOWNTO 0);
  SIGNAL sample_val : STD_LOGIC;

BEGIN

  -----------------------------------------------------------------------------
  -- CLOCK and RESET
  -----------------------------------------------------------------------------
  PROCESS
  BEGIN  -- PROCESS
    WAIT UNTIL clk_25 = '1';
    rstn_25 <= '0';
    WAIT UNTIL clk_25 = '1';
    WAIT UNTIL clk_25 = '1';
    WAIT UNTIL clk_25 = '1';
    rstn_25 <= '1';
    WAIT UNTIL end_of_simu = '1';
    WAIT FOR 10 ps;
    ASSERT false REPORT "end of test" SEVERITY note;
    --  Wait forever; this will finish the simulation.
    WAIT;
  END PROCESS;
  -----------------------------------------------------------------------------
  clk_25_gen : PROCESS
  BEGIN
    IF end_of_simu /= '1' THEN
      clk_25 <= NOT clk_25;
      TSTAMP <= TSTAMP+20;
      WAIT FOR 20 ns;
    ELSE
      WAIT FOR 20 ps;
      ASSERT false REPORT "end of test" SEVERITY note;
      WAIT;
    END IF;
  END PROCESS;

  -----------------------------------------------------------------------------
  -- CLOCK and RESET
  -----------------------------------------------------------------------------
  PROCESS
  BEGIN  -- PROCESS
    WAIT UNTIL clk_24 = '1';
    rstn_24 <= '0';
    WAIT UNTIL clk_24 = '1';
    WAIT UNTIL clk_24 = '1';
    WAIT UNTIL clk_24 = '1';
    rstn_24 <= '1';
    WAIT UNTIL end_of_simu = '1';
    WAIT FOR 10 ps;
    ASSERT false REPORT "end of test" SEVERITY note;
    --  Wait forever; this will finish the simulation.
    WAIT;
  END PROCESS;
  -----------------------------------------------------------------------------
  clk_24_gen : PROCESS
  BEGIN
    IF end_of_simu /= '1' THEN
      clk_24 <= NOT clk_24;
      WAIT FOR 20345 ps;
    ELSE
      WAIT FOR 20 ps;
      ASSERT false REPORT "end of test" SEVERITY note;
      WAIT;
    END IF;
  END PROCESS;

  -----------------------------------------------------------------------------
  top_ad_conv_RHF1401_withFilter_1 : top_ad_conv_RHF1401_withFilter
    GENERIC MAP (
      ChanelCount     => 9,
      ncycle_cnv_high => 12,
      ncycle_cnv      => 25,
      FILTER_ENABLED  => 16#FF#)
    PORT MAP (
      cnv_clk    => clk_24,
      cnv_rstn   => rstn_24,
      cnv        => ADC_smpclk_s,
      clk        => clk_25,
      rstn       => rstn_25,
      ADC_data   => ADC_data,
      ADC_nOE    => ADC_OEB_bar_CH_s,
      sample     => sample,
      sample_val => sample_val);
  
  -----------------------------------------------------------------------------
  lfr_input_gen_1: lfr_input_gen
    GENERIC MAP (
      FNAME => "adc_input.txt")
    PORT MAP (
      end_of_simu            => end_of_simu,
      rhf1401_data           => ADC_data,
      adc_rhf1401_smp_clk    => ADC_smpclk_s,
      adc_rhf1401_oeb_bar_ch => ADC_OEB_bar_CH_s(7 DOWNTO 0),
      adc_bias_fail_sel      => '0',
      hk_rhf1401_smp_clk     => ADC_smpclk_s,
      hk_rhf1401_oeb_bar_ch  => ADC_OEB_bar_CH_s(8),
      hk_sel                 => "00",
      error_oeb              => OPEN,
      error_hksel            => OPEN);
  -----------------------------------------------------------------------------
  
END;
