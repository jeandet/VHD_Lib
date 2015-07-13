
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

  -----------------------------------------------------------------------------
  -- CNV GEN
  -----------------------------------------------------------------------------
  SIGNAL cnv_cycle_counter     : INTEGER RANGE 0 TO ncycle_cnv-1;
  SIGNAL cnv_s                 : STD_LOGIC;
  SIGNAL cnv_s_reg             : STD_LOGIC;

  -----------------------------------------------------------------------------
  -- SYNC CNV
  -----------------------------------------------------------------------------
  SIGNAL cnv_sync              : STD_LOGIC;
  SIGNAL cnv_sync_pre          : STD_LOGIC;
  SIGNAL cnv_sync_falling_edge : STD_LOGIC;

  -----------------------------------------------------------------------------
  -- DATA Read and Data Output Enable
  -----------------------------------------------------------------------------
  CONSTANT MAX_CHANNEL_COUNTER   : INTEGER := (ChanelCount-1)*2 + 5;
  SIGNAL channel_counter         : INTEGER RANGE 0 TO MAX_CHANNEL_COUNTER;
  SIGNAL channel_counter_r       : INTEGER RANGE 0 TO MAX_CHANNEL_COUNTER;
  SIGNAL channel_counter_r2      : INTEGER RANGE 0 TO MAX_CHANNEL_COUNTER;
  SIGNAL channel_counter_d1      : INTEGER RANGE 0 TO MAX_CHANNEL_COUNTER;
  
  SIGNAL channel_sel_n   : STD_LOGIC_VECTOR(ChanelCount-1 DOWNTO 0);
  
  SIGNAL sample_reg        : Samples14v(ChanelCount-1 DOWNTO 0);
  SIGNAL ADC_data_d1       : Samples14;
  SIGNAL ADC_data_selected : Samples14;
  SIGNAL ADC_data_result   : Samples15;
  

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

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      cnv_sync_pre <= '0';      
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      cnv_sync_pre <= cnv_sync;      
    END IF;
  END PROCESS;

  cnv_sync_falling_edge <= '1' WHEN cnv_sync = '0' AND cnv_sync_pre = '1' ELSE '0';


  -----------------------------------------------------------------------------
  -- DATA Read and Data Output Enable
  -----------------------------------------------------------------------------

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      channel_counter <= MAX_CHANNEL_COUNTER;
      sample_val    <= '0';
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      IF cnv_sync_falling_edge = '1' THEN
        channel_counter <= 0;
      ELSE
        IF channel_counter < MAX_CHANNEL_COUNTER THEN
          channel_counter <= channel_counter + 1;
        END IF;
      END IF;

      IF channel_counter = MAX_CHANNEL_COUNTER-1 THEN
        sample_val    <= '1';
      ELSE
        sample_val    <= '0';
      END IF;      
    END IF;
  END PROCESS;

  all_channel: FOR I IN 0 TO ChanelCount-1 GENERATE
    channel_sel_n(I) <= '0' WHEN channel_counter = 2*I ELSE '1';
  
    PROCESS (clk, rstn)
    BEGIN  -- PROCESS
      IF rstn = '0' THEN                  -- asynchronous reset (active low)
        sample_reg(I) <= (OTHERS => '0');
      ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
        IF channel_counter_d1 = 2*I THEN
          IF FILTER_ENABLED_STDLOGIC(I) = '1' THEN
            sample_reg(I) <= ADC_data_result(14 DOWNTO 1);
          ELSE
            sample_reg(I) <= ADC_data_d1;
          END IF;          
        END IF;      
      END IF;
    END PROCESS;

  END GENERATE all_channel;

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      ADC_nOE            <= (OTHERS => '1');
      channel_counter_r  <= MAX_CHANNEL_COUNTER;
      channel_counter_r2 <= MAX_CHANNEL_COUNTER;
      channel_counter_d1 <= MAX_CHANNEL_COUNTER;
      ADC_data_d1        <= (OTHERS => '0');
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      ADC_nOE            <= channel_sel_n;
      channel_counter_r  <= channel_counter;
      channel_counter_r2 <= channel_counter_r;
      channel_counter_d1 <= channel_counter_r2;
      ADC_data_d1        <= ADC_data;
    END IF;
  END PROCESS;
  
  WITH channel_counter_d1 SELECT
    ADC_data_selected <= sample_reg(0) WHEN 0*2,
                         sample_reg(1) WHEN 1*2,
                         sample_reg(2) WHEN 2*2,
                         sample_reg(3) WHEN 3*2,
                         sample_reg(4) WHEN 4*2,
                         sample_reg(5) WHEN 5*2,
                         sample_reg(6) WHEN 6*2,
                         sample_reg(7) WHEN 7*2,
                         sample_reg(8) WHEN OTHERS;

  ADC_data_result <= STD_LOGIC_VECTOR((SIGNED(ADC_data_selected(13) & ADC_data_selected) + SIGNED(ADC_data_d1(13) & ADC_data_d1)));
  
  sample <= sample_reg;

  
  
END ar_top_ad_conv_RHF1401;














