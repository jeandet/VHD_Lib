LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
LIBRARY lpp;
USE lpp.lpp_ad_conv.ALL;
use lpp.iir_filter.all;
use lpp.FILTERcfg.all;

ENTITY Top_Data_Acquisition IS
    PORT (
      -- ADS7886
      cnv_run   : IN  STD_LOGIC;
      cnv       : OUT STD_LOGIC;
      sck       : OUT STD_LOGIC;
      sdo       : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
      --
      cnv_clk : IN  STD_LOGIC;
      cnv_rstn : IN  STD_LOGIC;
      --
      clk : IN  STD_LOGIC;
      rstn : IN  STD_LOGIC
      
      );
END Top_Data_Acquisition;

ARCHITECTURE tb OF Top_Data_Acquisition IS
  
  -----------------------------------------------------------------------------
  CONSTANT ChanelCount     : INTEGER := 8;
  CONSTANT ncycle_cnv_high : INTEGER := 79;
  CONSTANT ncycle_cnv      : INTEGER := 500;

  -----------------------------------------------------------------------------
  SIGNAL sample     : Samples(ChanelCount-1 DOWNTO 0);
  SIGNAL sample_val : STD_LOGIC;
  SIGNAL sample_val_delay : STD_LOGIC;
  -----------------------------------------------------------------------------
  CONSTANT		  Coef_SZ      : integer := 9;
  CONSTANT		  CoefCntPerCel: integer := 6;
  CONSTANT		  CoefPerCel   : integer := 5;
  CONSTANT		  Cels_count   : integer := 5;

  signal coefs             : std_logic_vector((Coef_SZ*CoefCntPerCel*Cels_count)-1 downto 0);
  signal coefs_JC          : std_logic_vector((Coef_SZ*CoefPerCel*Cels_count)-1 downto 0);
  signal sample_filter_in  : samplT(ChanelCount-1 downto 0,17 downto 0);
  signal sample_filter_out : samplT(ChanelCount-1 downto 0,17 downto 0);
  --
  signal sample_filter_JC_out_val : STD_LOGIC;
  signal sample_filter_JC_out     : samplT(ChanelCount-1 downto 0,17 downto 0);
  --
  signal sample_filter_JC_out_r_val : STD_LOGIC;
  signal sample_filter_JC_out_r     : samplT(ChanelCount-1 downto 0,17 downto 0);
  
BEGIN  
  
  -- component instantiation
  -----------------------------------------------------------------------------
  DIGITAL_acquisition: ADS7886_drvr
    GENERIC MAP (
      ChanelCount     => ChanelCount,
      ncycle_cnv_high => ncycle_cnv_high,
      ncycle_cnv      => ncycle_cnv)
    PORT MAP ( 
      cnv_clk    => cnv_clk,            -- 
      cnv_rstn   => cnv_rstn,           -- 
      cnv_run    => cnv_run,            --
      cnv        => cnv,                -- 
      clk        => clk,                -- 
      rstn       => rstn,               -- 
      sck        => sck,                -- 
      sdo        => sdo(ChanelCount-1 DOWNTO 0),                -- 
      sample     => sample,
      sample_val => sample_val);

  -----------------------------------------------------------------------------

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      sample_val_delay <= '0';
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      sample_val_delay <= sample_val;
    END IF;
  END PROCESS;
  
  -----------------------------------------------------------------------------
  ChanelLoop: for i in 0 to ChanelCount-1 generate
    SampleLoop: for j in 0 to 15 generate
        sample_filter_in(i,j) <= sample(i)(j);
    end generate;
    
    sample_filter_in(i,16) <= sample(i)(15);
    sample_filter_in(i,17) <= sample(i)(15);
  end generate;

  coefs    <= CoefsInitValCst;
  coefs_JC <= CoefsInitValCst_JC;

  FILTER: IIR_CEL_CTRLR
    GENERIC MAP (
      tech          => 0,
      Sample_SZ     => 18,
      ChanelsCount  => ChanelCount,
      Coef_SZ       => Coef_SZ,
      CoefCntPerCel => CoefCntPerCel,
      Cels_count    => Cels_count,
      Mem_use       => use_CEL)         -- use_CEL for SIMU, use_RAM for synthesis
    PORT MAP (
      reset      => rstn,
      clk        => clk,
      sample_clk => sample_val_delay,
      sample_in  => sample_filter_in,
      sample_out => sample_filter_out,
      virg_pos   => 7,
      GOtest     => OPEN,
      coefs      => coefs);

  IIR_CEL_CTRLR_v2_1: IIR_CEL_CTRLR_v2
    GENERIC MAP (
      tech          => 0,
      Mem_use       => use_CEL,
      Sample_SZ     => 18,
      Coef_SZ       => Coef_SZ,
      Coef_Nb       => 25,         -- TODO
      Coef_sel_SZ   => 5,          -- TODO
      Cels_count    => Cels_count,
      ChanelsCount  => ChanelCount)
    PORT MAP (
      rstn          => rstn,
      clk            => clk,
      virg_pos       => 7,
      coefs          => coefs_JC,
      sample_in_val  => sample_val_delay,
      sample_in      => sample_filter_in,
      sample_out_val => sample_filter_JC_out_val,
      sample_out     => sample_filter_JC_out);
  
  -----------------------------------------------------------------------------
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      sample_filter_JC_out_r_val <= '0';
      rst_all_chanel: FOR I IN ChanelCount-1 DOWNTO 0 LOOP
        rst_all_bits: FOR J IN 17 DOWNTO 0 LOOP
          sample_filter_JC_out_r(I,J) <= '0';
        END LOOP rst_all_bits;
      END LOOP rst_all_chanel;
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      sample_filter_JC_out_r_val <= sample_filter_JC_out_val;
      IF sample_filter_JC_out_val = '1' THEN
        sample_filter_JC_out_r <= sample_filter_JC_out;
      END IF;
    END IF;
  END PROCESS;
  
END tb;
