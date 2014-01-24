
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
LIBRARY lpp;
USE lpp.lpp_ad_conv.ALL;
USE lpp.general_purpose.SYNC_FF;

ENTITY top_ad_conv_ADS7886_v2 IS
  GENERIC(
    ChannelCount    : INTEGER := 8;
    SampleNbBits    : INTEGER := 14;
    ncycle_cnv_high : INTEGER := 40;    -- at least 32 cycles
    ncycle_cnv      : INTEGER := 500);
  PORT (
    -- CONV
    cnv_clk    : IN  STD_LOGIC;
    cnv_rstn   : IN  STD_LOGIC;
    cnv        : OUT STD_LOGIC;
    -- DATA
    clk        : IN  STD_LOGIC;
    rstn       : IN  STD_LOGIC;
    sck        : OUT STD_LOGIC;
    sdo        : IN  STD_LOGIC_VECTOR(ChannelCount-1 DOWNTO 0);
    -- SAMPLE
    sample     : OUT Samples14v(ChannelCount-1 DOWNTO 0);
    sample_val : OUT STD_LOGIC
    );
END top_ad_conv_ADS7886_v2;

ARCHITECTURE ar_top_ad_conv_ADS7886_v2 OF top_ad_conv_ADS7886_v2 IS
  
  SIGNAL cnv_cycle_counter : INTEGER;
  SIGNAL cnv_s             : STD_LOGIC;
  SIGNAL cnv_sync          : STD_LOGIC;
  SIGNAL cnv_sync_not      : STD_LOGIC;

  SIGNAL sample_adc     : Samples(ChannelCount-1 DOWNTO 0);
  SIGNAL sample_val_adc : STD_LOGIC;

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

  cnv <= NOT(cnv_s);

  -----------------------------------------------------------------------------
  -- SYNC CNV
  -----------------------------------------------------------------------------

  SYNC_FF_cnv : SYNC_FF
    GENERIC MAP (
      NB_FF_OF_SYNC => 2)
    PORT MAP (
      clk    => clk,
      rstn   => rstn,
      A      => cnv_s,                  -- the data fetching begins immediately
      A_sync => cnv_sync);

  -----------------------------------------------------------------------------

  cnv_sync_not <= NOT(cnv_sync);

  ADS7886_drvr_v2_1 : ADS7886_drvr_v2
    GENERIC MAP(
      ChannelCount  => 8,
      NbBitsSamples => 16)
    PORT MAP(
      -- CONV --
      cnv_clk    => cnv_sync_not,
      cnv_rstn   => rstn,
      -- DATA --
      clk        => clk,                -- master clock, 25 MHz
      rstn       => rstn,
      sck        => sck,
      sdo        => sdo,
      -- SAMPLE --
      sample     => sample_adc,
      sample_val => sample_val_adc);

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      FOR k IN 0 TO ChannelCount-1 LOOP
        sample(k)(13 DOWNTO 0) <= (OTHERS => '0');
      END LOOP;
      sample_val <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
      IF sample_val_adc = '1' THEN
        FOR k IN 0 TO ChannelCount-1 LOOP
          IF (UNSIGNED(sample_adc(k)(11 DOWNTO 0)) >= 2048) THEN
            sample(k)(13 DOWNTO 0) <= "00" &
                                      STD_LOGIC_VECTOR(UNSIGNED(sample_adc(k)(11 DOWNTO 0)) - 2048);
          ELSE
            sample(k)(13 DOWNTO 0) <= "11" &
                                      STD_LOGIC_VECTOR(UNSIGNED(sample_adc(k)(11 DOWNTO 0)) - 2048);
          END IF;
        END LOOP;
        sample_val <= sample_val_adc;
      ELSE
        sample_val <= '0';
      END IF;
    END IF;
  END PROCESS;

END ar_top_ad_conv_ADS7886_v2;
