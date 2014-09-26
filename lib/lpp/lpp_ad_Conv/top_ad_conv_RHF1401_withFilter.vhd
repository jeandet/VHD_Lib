
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
    ncycle_cnv      : INTEGER := 25);
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
  
  SIGNAL cnv_cycle_counter : INTEGER;
  SIGNAL cnv_s             : STD_LOGIC;
  SIGNAL cnv_sync          : STD_LOGIC;
  SIGNAL cnv_sync_pre          : STD_LOGIC;

  SIGNAL ADC_nOE_reg : STD_LOGIC_VECTOR(ChanelCount-1 DOWNTO 0);
  SIGNAL enable_ADC : STD_LOGIC;

  
  SIGNAL sample_reg  : Samples14v(ChanelCount-1 DOWNTO 0);

  SIGNAL channel_counter : INTEGER;
  CONSTANT MAX_COUNTER : INTEGER := ChanelCount*2+1;

  SIGNAL ADC_data_selected : Samples14;
  SIGNAL ADC_data_result   : Samples15;

  SIGNAL sample_counter : INTEGER;
  
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
  -- DATA GEN Output Enable
  -----------------------------------------------------------------------------
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      ADC_nOE_reg(ChanelCount-1 DOWNTO 0) <= (OTHERS => '1');
      cnv_sync_pre                        <= '0';
      enable_ADC <= '0';
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      cnv_sync_pre                        <= cnv_sync;
      IF cnv_sync = '1' AND cnv_sync_pre = '0' THEN
        enable_ADC     <= '1';
        ADC_nOE_reg(0) <= '0';
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
      sample_reg(0) <= (OTHERS => '0');
      sample_reg(1) <= (OTHERS => '0');
      sample_reg(2) <= (OTHERS => '0');
      sample_reg(3) <= (OTHERS => '0');
      sample_reg(4) <= (OTHERS => '0');
      sample_reg(5) <= (OTHERS => '0');
      sample_reg(6) <= (OTHERS => '0');
      sample_reg(7) <= (OTHERS => '0');

      sample_val     <= '0';
      sample_counter <= 0;
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      IF cnv_sync = '1' AND cnv_sync_pre = '0' THEN 
        channel_counter <= 0;
      ELSE
        IF channel_counter < MAX_COUNTER THEN
          channel_counter <= channel_counter + 1;
        END IF;
      END IF;      
      sample_val     <= '0';

      CASE channel_counter IS
        WHEN 0*2 => sample_reg(0) <= ADC_data_result(14 DOWNTO 1);
        WHEN 1*2 => sample_reg(1) <= ADC_data_result(14 DOWNTO 1);
        WHEN 2*2 => sample_reg(2) <= ADC_data_result(14 DOWNTO 1);
        WHEN 3*2 => sample_reg(3) <= ADC_data_result(14 DOWNTO 1);
        WHEN 4*2 => sample_reg(4) <= ADC_data_result(14 DOWNTO 1);
        WHEN 5*2 => sample_reg(5) <= ADC_data_result(14 DOWNTO 1);
        WHEN 6*2 => sample_reg(6) <= ADC_data_result(14 DOWNTO 1);
        WHEN 7*2 => sample_reg(7) <= ADC_data_result(14 DOWNTO 1);
          IF sample_counter = 9 THEN
            sample_counter <= 0 ;
            sample_val     <= '1';
          ELSE
            sample_counter <= sample_counter +1;
          END IF;
                      
        WHEN OTHERS => NULL;
      END CASE;
      
    END IF;
  END PROCESS;


  WITH channel_counter SELECT
    ADC_data_selected <= sample_reg(0) WHEN 0*2,
                         sample_reg(1) WHEN 1*2,
                         sample_reg(2) WHEN 2*2,
                         sample_reg(3) WHEN 3*2,
                         sample_reg(4) WHEN 4*2,
                         sample_reg(5) WHEN 5*2,
                         sample_reg(6) WHEN 6*2,
                         sample_reg(7) WHEN OTHERS ;
    
  
  ADC_data_result <= std_logic_vector( (signed( ADC_data_selected(13) & ADC_data_selected) + signed( ADC_data(13) & ADC_data)) );

  sample <= sample_reg;

  

  
  --RHF1401_drvr_1: RHF1401_drvr
  --  GENERIC MAP (
  --    ChanelCount => ChanelCount)
  --  PORT MAP (
  --    cnv_clk    => cnv_sync,
  --    clk        => clk,
  --    rstn       => rstn,
  --    ADC_data   => ADC_data,
  --    --ADC_smpclk => OPEN,
  --    ADC_nOE    => ADC_nOE,
  --    sample     => sample,
  --    sample_val => sample_val);

  

  
END ar_top_ad_conv_RHF1401;
















