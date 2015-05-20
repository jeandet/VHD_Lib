
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY lpp;
USE lpp.lpp_ad_conv.ALL;
USE lpp.general_purpose.SYNC_FF;

ENTITY top_ad_conv_RHF1401_withFilter IS
  GENERIC(
    ChanelCount     : INTEGER := 8;
    ncycle_cnv_high : INTEGER := 25;
    ncycle_cnv      : INTEGER := 50;
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
  
  SIGNAL cnv_cycle_counter : INTEGER;
  SIGNAL cnv_s             : STD_LOGIC;
  SIGNAL cnv_s_reg         : STD_LOGIC;
  SIGNAL cnv_sync          : STD_LOGIC;
  SIGNAL cnv_sync_reg      : STD_LOGIC;
  SIGNAL cnv_sync_falling   : STD_LOGIC;

  SIGNAL ADC_nOE_reg : STD_LOGIC_VECTOR(ChanelCount-1 DOWNTO 0);
  SIGNAL enable_ADC : STD_LOGIC;

  
  SIGNAL sample_reg  : Samples14v(ChanelCount-1 DOWNTO 0);

  SIGNAL channel_counter : INTEGER;
  CONSTANT MAX_COUNTER : INTEGER := ChanelCount*2+1;

  SIGNAL ADC_data_selected : Samples14;
  SIGNAL ADC_data_result   : Samples15;

  SIGNAL sample_counter : INTEGER;
  CONSTANT MAX_SAMPLE_COUNTER : INTEGER := 9;

  CONSTANT FILTER_ENABLED_STDLOGIC : STD_LOGIC_VECTOR(ChanelCount-1 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(FILTER_ENABLED,ChanelCount));

  -----------------------------------------------------------------------------
  CONSTANT OE_NB_CYCLE_ENABLED : INTEGER := 1;
  CONSTANT DATA_CYCLE_VALID    : INTEGER := 2;
  
  -- GEN OutPut Enable
  TYPE FSM_GEN_OEn_state IS (IDLE, GEN_OE, WAIT_CYCLE);
  SIGNAL state_GEN_OEn             : FSM_GEN_OEn_state;
  SIGNAL ADC_current               : INTEGER RANGE 0 TO ChanelCount-1;
  SIGNAL ADC_current_cycle_enabled : INTEGER RANGE 0 TO OE_NB_CYCLE_ENABLED + 1 ;
  SIGNAL ADC_data_valid            : STD_LOGIC;
  SIGNAL ADC_data_valid_s          : STD_LOGIC;
  SIGNAL ADC_data_reg              : Samples14;
  -----------------------------------------------------------------------------
  CONSTANT SAMPLE_DIVISION  : INTEGER := 10;
  SIGNAL sample_val_s       : STD_LOGIC;
  SIGNAL sample_val_s2      : STD_LOGIC;
  SIGNAL sample_val_counter : INTEGER RANGE 0 TO SAMPLE_DIVISION;
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
        IF cnv_cycle_counter < ncycle_cnv_high-1 THEN
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
      cnv_s_reg             <= '0';
    ELSIF cnv_clk'EVENT AND cnv_clk = '1' THEN  -- rising clock edge
      cnv_s_reg             <= cnv_s;
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

  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      cnv_sync_reg <= '0';
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      cnv_sync_reg <= cnv_sync;      
    END IF;
  END PROCESS;
  
  cnv_sync_falling <= '1' WHEN cnv_sync = '0' AND cnv_sync_reg = '1' ELSE '0';
  
  -----------------------------------------------------------------------------
  -- GEN OutPut Enable
  -----------------------------------------------------------------------------
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN
      -------------------------------------------------------------------------
      ADC_nOE                   <= (OTHERS => '1');
      ADC_current               <= 0;
      ADC_current_cycle_enabled <= 0;
      state_GEN_OEn             <= IDLE;
      -------------------------------------------------------------------------
      ADC_data_reg              <= (OTHERS => '0');
      all_channel_sample_reg_init: FOR I IN 0 TO ChanelCount-1 LOOP
        sample_reg(I) <= (OTHERS => '0');
        sample(I)     <= (OTHERS => '0');
      END LOOP all_channel_sample_reg_init;
      sample_val     <= '0';
      sample_val_s     <= '0';
      sample_val_counter <= 0;
      -------------------------------------------------------------------------
    ELSIF clk'event AND clk = '1' THEN
      -------------------------------------------------------------------------
      sample_val_s     <= '0';
      ADC_nOE        <= (OTHERS => '1');
      CASE state_GEN_OEn IS
        WHEN IDLE =>
          IF cnv_sync_falling = '1' THEN
            --ADC_nOE(0)                <= '1';
            state_GEN_OEn             <= GEN_OE;
            ADC_current               <= 0;
            ADC_current_cycle_enabled <= 1;
          END IF;
          
        WHEN GEN_OE =>
          ADC_nOE(ADC_current) <= '0';
          
          ADC_current_cycle_enabled <= ADC_current_cycle_enabled + 1;
          
          IF ADC_current_cycle_enabled = OE_NB_CYCLE_ENABLED  THEN
            state_GEN_OEn             <= WAIT_CYCLE;
          END IF;
          
        WHEN WAIT_CYCLE =>
          ADC_current_cycle_enabled <= 1;
          IF ADC_current = ChanelCount-1 THEN
            state_GEN_OEn <= IDLE;
            sample_val_s     <= '1';
          ELSE
            ADC_current <= ADC_current + 1;
            state_GEN_OEn <= GEN_OE;
          END IF;
        WHEN OTHERS => NULL;
      END CASE;
      -------------------------------------------------------------------------
      ADC_data_reg              <= ADC_data;
      
      all_channel_sample_reg: FOR I IN 0 TO ChanelCount-1 LOOP
        IF ADC_data_valid = '1' AND ADC_current = I THEN
          sample_reg(I) <= ADC_data_result(14 DOWNTO 1);
        ELSE
          sample_reg(I) <= sample_reg(I);
        END IF;
      END LOOP all_channel_sample_reg;
      -------------------------------------------------------------------------
      sample_val         <= '0';
      IF sample_val_s2 = '1' THEN
        IF sample_val_counter = SAMPLE_DIVISION-1 THEN
          sample_val_counter <= 0;
          sample_val         <= '1';            -- TODO
          sample             <= sample_reg;
        ELSE
          sample_val_counter <= sample_val_counter + 1;
          sample_val         <= '0';
        END IF;        
      END IF;
      
    END IF;
  END PROCESS;


  
  REG_ADC_DATA_valid: IF DATA_CYCLE_VALID = OE_NB_CYCLE_ENABLED GENERATE
    ADC_data_valid_s <= '1' WHEN ADC_current_cycle_enabled = DATA_CYCLE_VALID + 1 ELSE '0';
    
    PROCESS (clk, rstn)
    BEGIN  -- PROCESS
      IF rstn = '0' THEN                -- asynchronous reset (active low)
        ADC_data_valid <= '0';
        sample_val_s2  <= '0';
      ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
        ADC_data_valid <= ADC_data_valid_s;
        sample_val_s2  <= sample_val_s;
      END IF;
    END PROCESS;
    
  END GENERATE REG_ADC_DATA_valid;

  noREG_ADC_DATA_valid: IF DATA_CYCLE_VALID < OE_NB_CYCLE_ENABLED GENERATE
    ADC_data_valid_s <= '1' WHEN ADC_current_cycle_enabled = DATA_CYCLE_VALID + 1 ELSE '0';
  
    ADC_data_valid <= ADC_data_valid_s; 
    sample_val_s2  <= sample_val_s;
  END GENERATE noREG_ADC_DATA_valid;
  
  REGm_ADC_DATA_valid: IF DATA_CYCLE_VALID > OE_NB_CYCLE_ENABLED GENERATE
    
    ADC_data_valid_s <= '1' WHEN ADC_current_cycle_enabled = OE_NB_CYCLE_ENABLED + 1 ELSE '0';
  
    REG_1: SYNC_FF
      GENERIC MAP (
        NB_FF_OF_SYNC => DATA_CYCLE_VALID-OE_NB_CYCLE_ENABLED+1)
      PORT MAP (
        clk    => clk,
        rstn   => rstn,
        A      => ADC_data_valid_s,
        A_sync => ADC_data_valid);
    
    REG_2: SYNC_FF
      GENERIC MAP (
        NB_FF_OF_SYNC => DATA_CYCLE_VALID-OE_NB_CYCLE_ENABLED+1)
      PORT MAP (
        clk    => clk,
        rstn   => rstn,
        A      => sample_val_s,
        A_sync => sample_val_s2);    
  END GENERATE REGm_ADC_DATA_valid;

  

  WITH ADC_current SELECT
    ADC_data_selected <= sample_reg(0) WHEN 0,
                         sample_reg(1) WHEN 1,
                         sample_reg(2) WHEN 2,
                         sample_reg(3) WHEN 3,
                         sample_reg(4) WHEN 4,
                         sample_reg(5) WHEN 5,
                         sample_reg(6) WHEN 6,
                         sample_reg(7) WHEN 7,
                         sample_reg(8) WHEN OTHERS ;
    
  ADC_data_result <= std_logic_vector((
    signed( ADC_data_selected(13) & ADC_data_selected) +
    signed( ADC_data_reg(13)      & ADC_data_reg)
    ));
  
--  sample <= sample_reg;
  
END ar_top_ad_conv_RHF1401;














