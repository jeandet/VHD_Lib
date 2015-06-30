
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY lpp;
USE lpp.lpp_ad_conv.ALL;
USE lpp.general_purpose.SYNC_FF;

ENTITY top_ad_conv_RHF1401_withFilter IS
  GENERIC(
    ChanelCount     : INTEGER := 8;
    ncycle_cnv_high : INTEGER := 13;
    ncycle_cnv      : INTEGER := 25;
    FILTER_ENABLED  : INTEGER := 16#FF#
    );
  PORT (
    cnv_clk  : IN STD_LOGIC;            -- 24Mhz
    cnv_rstn : IN STD_LOGIC;

    cnv : OUT STD_LOGIC;

    clk        : IN  STD_LOGIC;         -- 25MHz
    rstn       : IN  STD_LOGIC;
    ADC_data   : IN  Samples14;
    ADC_nOE    : OUT STD_LOGIC_VECTOR(ChanelCount-1 DOWNTO 0);
    sample     : OUT Samples14v(ChanelCount-1 DOWNTO 0);
    sample_val : OUT STD_LOGIC
    );
END top_ad_conv_RHF1401_withFilter;

ARCHITECTURE ar_top_ad_conv_RHF1401 OF top_ad_conv_RHF1401_withFilter IS
  
  SIGNAL cnv_cycle_counter     : INTEGER RANGE 0 TO ncycle_cnv-1;
  SIGNAL cnv_s                 : STD_LOGIC;
  SIGNAL cnv_s_reg             : STD_LOGIC;
  SIGNAL cnv_sync              : STD_LOGIC;
  SIGNAL cnv_sync_pre          : STD_LOGIC;
  SIGNAL cnv_sync_falling_edge : STD_LOGIC;

  SIGNAL ADC_nOE_reg : STD_LOGIC_VECTOR(ChanelCount-1 DOWNTO 0);
  SIGNAL enable_ADC  : STD_LOGIC;


  SIGNAL sample_reg : Samples14v(ChanelCount-1 DOWNTO 0);

  SIGNAL   channel_counter : INTEGER;
  CONSTANT MAX_COUNTER     : INTEGER := ChanelCount*2+1;

  SIGNAL ADC_data_selected : Samples14;
  SIGNAL ADC_data_result   : Samples15;

  SIGNAL   sample_counter     : INTEGER;
  CONSTANT MAX_SAMPLE_COUNTER : INTEGER := 9;

  CONSTANT FILTER_ENABLED_STDLOGIC : STD_LOGIC_VECTOR(ChanelCount-1 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(FILTER_ENABLED, ChanelCount));
  
BEGIN


  -----------------------------------------------------------------------------
  -- CNV GEN
  -----------------------------------------------------------------------------
  PROCESS (cnv_clk, cnv_rstn)
  BEGIN  -- PROCESS
    IF cnv_rstn = '0' THEN              -- asynchronous reset (active low)
      cnv_cycle_counter <= 0;
      cnv_s             <= '0';
    ELSIF cnv_clk'EVENT AND cnv_clk = '1' THEN  -- rising clock edge
      IF cnv_cycle_counter < ncycle_cnv-1 THEN
        cnv_cycle_counter <= cnv_cycle_counter + 1;
        IF cnv_cycle_counter < ncycle_cnv_high THEN
          cnv_s <= '1';
        ELSE
          cnv_s <= '0';
        END IF;
      ELSE
        cnv_s             <= '1';
        cnv_cycle_counter <= 0;
      END IF;
    END IF;
  END PROCESS;

  cnv <= cnv_s;

  PROCESS (cnv_clk, cnv_rstn)
  BEGIN  -- PROCESS
    IF cnv_rstn = '0' THEN              -- asynchronous reset (active low)
      cnv_s_reg <= '0';
    ELSIF cnv_clk'EVENT AND cnv_clk = '1' THEN  -- rising clock edge
      cnv_s_reg <= cnv_s;
    END IF;
  END PROCESS;


  -----------------------------------------------------------------------------
  -- SYNC CNV
  -----------------------------------------------------------------------------

  SYNC_FF_cnv : SYNC_FF
    GENERIC MAP (
      NB_FF_OF_SYNC => 2)
    PORT MAP (
      clk    => clk,
      rstn   => rstn,
      A      => cnv_s_reg,
      A_sync => cnv_sync);

  cnv_sync_falling_edge <= '1' WHEN cnv_sync = '0' AND cnv_sync_pre = '1' ELSE '0';

  -----------------------------------------------------------------------------
  -- DATA GEN Output Enable
  -----------------------------------------------------------------------------
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      ADC_nOE_reg(ChanelCount-1 DOWNTO 0) <= (OTHERS => '1');
      cnv_sync_pre                        <= '0';
      enable_ADC                          <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
      cnv_sync_pre <= cnv_sync;
      IF cnv_sync_falling_edge = '1' THEN
        enable_ADC                          <= '1';
        ADC_nOE_reg(0)                      <= '0';
        ADC_nOE_reg(ChanelCount-1 DOWNTO 1) <= (OTHERS => '1');
      ELSE
        enable_ADC <= NOT enable_ADC;
        IF enable_ADC = '0' THEN
          ADC_nOE_reg(ChanelCount-1 DOWNTO 0) <= ADC_nOE_reg(ChanelCount-2 DOWNTO 0) & '1';
        END IF;
      END IF;
      
    END IF;
  END PROCESS;

  ADC_nOE <= (OTHERS => '1') WHEN enable_ADC = '0' ELSE ADC_nOE_reg;

  -----------------------------------------------------------------------------
  -- ADC READ DATA
  -----------------------------------------------------------------------------
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      channel_counter <= MAX_COUNTER;

      all_sample_reg_init : FOR I IN ChanelCount-1 DOWNTO 0 LOOP
        sample_reg(I) <= (OTHERS => '0');
      END LOOP all_sample_reg_init;

      sample_val     <= '0';
      sample_counter <= 0;
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
      IF cnv_sync_falling_edge = '1' THEN
        channel_counter <= 0;
      ELSE
        IF channel_counter < MAX_COUNTER THEN
          channel_counter <= channel_counter + 1;
        END IF;
      END IF;
      sample_val <= '0';

      all_sample_reg : FOR I IN ChanelCount-1 DOWNTO 0 LOOP
        IF channel_counter = I*2 THEN
          IF FILTER_ENABLED_STDLOGIC(I) = '1' THEN
            sample_reg(I) <= ADC_data_result(14 DOWNTO 1);
          ELSE
            sample_reg(I) <= ADC_data;
          END IF;
        END IF;
      END LOOP all_sample_reg;

      IF channel_counter = (ChanelCount-1)*2 THEN

        IF sample_counter = MAX_SAMPLE_COUNTER THEN
          sample_counter <= 0;
          sample_val     <= '1';
        ELSE
          sample_counter <= sample_counter +1;
        END IF;
        
      END IF;
    END IF;
  END PROCESS;

--  mux_adc: PROCESS (sample_reg)-- (channel_counter, sample_reg)
--  BEGIN  -- PROCESS mux_adc
--    CASE channel_counter IS
--      WHEN OTHERS => ADC_data_selected <= sample_reg(channel_counter/2);
--    END CASE;
--  END PROCESS mux_adc;


  -----------------------------------------------------------------------------
  -- \/\/\/\/\/\/\/ TODO : this part is not GENERIC !!! \/\/\/\/\/\/\/
  -----------------------------------------------------------------------------

  WITH channel_counter SELECT
    ADC_data_selected <= sample_reg(0) WHEN 0*2,
    sample_reg(1)                      WHEN 1*2,
    sample_reg(2)                      WHEN 2*2,
    sample_reg(3)                      WHEN 3*2,
    sample_reg(4)                      WHEN 4*2,
    sample_reg(5)                      WHEN 5*2,
    sample_reg(6)                      WHEN 6*2,
    sample_reg(7)                      WHEN 7*2,
    sample_reg(8)                      WHEN OTHERS;

  -----------------------------------------------------------------------------
  -- /\/\/\/\/\/\/\ ----------------------------------- /\/\/\/\/\/\/\
  -----------------------------------------------------------------------------
  
  ADC_data_result <= STD_LOGIC_VECTOR((SIGNED(ADC_data_selected(13) & ADC_data_selected) + SIGNED(ADC_data(13) & ADC_data)));

  sample <= sample_reg;
  
END ar_top_ad_conv_RHF1401;














