
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
LIBRARY lpp;
USE lpp.lpp_ad_conv.ALL;
USE lpp.general_purpose.SYNC_FF;

ENTITY top_ad_conv_RHF1401 IS
  GENERIC(
    ChanelCount : INTEGER := 8;
    ncycle_cnv_high : INTEGER := 79;
    ncycle_cnv      : INTEGER := 500);
  PORT (
    cnv_clk  : IN STD_LOGIC;
    cnv_rstn : IN STD_LOGIC;

    cnv : OUT STD_LOGIC;

    clk        : IN  STD_LOGIC;
    rstn       : IN  STD_LOGIC;
    ADC_data   : IN  Samples14;
    ADC_nOE    : OUT STD_LOGIC_VECTOR(ChanelCount-1 DOWNTO 0);
    sample     : OUT Samples14v(ChanelCount-1 DOWNTO 0);
    sample_val : OUT STD_LOGIC
    );
END top_ad_conv_RHF1401;

ARCHITECTURE ar_top_ad_conv_RHF1401 OF top_ad_conv_RHF1401 IS
  
  SIGNAL cnv_cycle_counter : INTEGER;
  SIGNAL cnv_s             : STD_LOGIC;
  SIGNAL cnv_sync          : STD_LOGIC;

BEGIN


  -----------------------------------------------------------------------------
  -- CONV
  -----------------------------------------------------------------------------
  PROCESS (cnv_clk, cnv_rstn)
  BEGIN  -- PROCESS
    IF cnv_rstn = '0' THEN              -- asynchronous reset (active low)
      cnv_cycle_counter <= 0;
      cnv_s             <= '0';
    ELSIF cnv_clk'EVENT AND cnv_clk = '1' THEN  -- rising clock edge
--      IF cnv_run = '1' THEN
      IF cnv_cycle_counter < ncycle_cnv THEN
        cnv_cycle_counter <= cnv_cycle_counter +1;
        IF cnv_cycle_counter < ncycle_cnv_high THEN
          cnv_s <= '1';
        ELSE
          cnv_s <= '0';
        END IF;
      ELSE
        cnv_s             <= '1';
        cnv_cycle_counter <= 0;
      END IF;
      --ELSE
      --  cnv_s             <= '0';
      --  cnv_cycle_counter <= 0;
      --END IF;
    END IF;
  END PROCESS;

  cnv <= cnv_s;


  -----------------------------------------------------------------------------
  -- SYNC CNV
  -----------------------------------------------------------------------------
  
  SYNC_FF_cnv : SYNC_FF
    GENERIC MAP (
      NB_FF_OF_SYNC => 2)
    PORT MAP (
      clk    => clk,
      rstn   => rstn,
      A      => cnv_s,
      A_sync => cnv_sync);

  -----------------------------------------------------------------------------
  RHF1401_drvr_1: RHF1401_drvr
    GENERIC MAP (
      ChanelCount => ChanelCount)
    PORT MAP (
      cnv_clk    => cnv_sync,
      clk        => clk,
      rstn       => rstn,
      ADC_data   => ADC_data,
      --ADC_smpclk => OPEN,
      ADC_nOE    => ADC_nOE,
      sample     => sample,
      sample_val => sample_val);

  

  
END ar_top_ad_conv_RHF1401;
















