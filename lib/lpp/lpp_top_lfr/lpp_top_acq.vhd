LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
LIBRARY lpp;
USE lpp.lpp_ad_conv.ALL;
USE lpp.iir_filter.ALL;
USE lpp.FILTERcfg.ALL;
USE lpp.lpp_memory.ALL;
USE lpp.lpp_top_lfr_pkg.ALL;
LIBRARY techmap;
USE techmap.gencomp.ALL;

ENTITY lpp_top_acq IS
  GENERIC(
    tech : INTEGER := 0
    );
  PORT (
    -- ADS7886
    cnv_run         : IN  STD_LOGIC;
    cnv             : OUT STD_LOGIC;
    sck             : OUT STD_LOGIC;
    sdo             : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
    --
    cnv_clk         : IN  STD_LOGIC;
    cnv_rstn        : IN  STD_LOGIC;
    --
    clk             : IN  STD_LOGIC;
    rstn            : IN  STD_LOGIC;
    --
    sample_f0_0_wen : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
    sample_f0_1_wen : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
    sample_f0_wdata : OUT STD_LOGIC_VECTOR((5*18)-1 DOWNTO 0);
    --
    sample_f1_wen   : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
    sample_f1_wdata : OUT STD_LOGIC_VECTOR((5*18)-1 DOWNTO 0);
    --
    sample_f2_wen   : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
    sample_f2_wdata : OUT STD_LOGIC_VECTOR((5*18)-1 DOWNTO 0);
    --
    sample_f3_wen   : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
    sample_f3_wdata : OUT STD_LOGIC_VECTOR((5*18)-1 DOWNTO 0)
    );
END lpp_top_acq;

ARCHITECTURE tb OF lpp_top_acq IS

  COMPONENT Downsampling
    GENERIC (
      ChanelCount : INTEGER;
      SampleSize  : INTEGER;
      DivideParam : INTEGER);
    PORT (
      clk            : IN  STD_LOGIC;
      rstn           : IN  STD_LOGIC;
      sample_in_val  : IN  STD_LOGIC;
      sample_in      : IN  samplT(ChanelCount-1 DOWNTO 0, SampleSize-1 DOWNTO 0);
      sample_out_val : OUT STD_LOGIC;
      sample_out     : OUT samplT(ChanelCount-1 DOWNTO 0, SampleSize-1 DOWNTO 0));
  END COMPONENT;

  -----------------------------------------------------------------------------
  CONSTANT ChanelCount     : INTEGER := 8;
  CONSTANT ncycle_cnv_high : INTEGER := 79;
  CONSTANT ncycle_cnv      : INTEGER := 500;

  -----------------------------------------------------------------------------
  SIGNAL   sample           : Samples(ChanelCount-1 DOWNTO 0);
  SIGNAL   sample_val       : STD_LOGIC;
  SIGNAL   sample_val_delay : STD_LOGIC;
  -----------------------------------------------------------------------------
  CONSTANT Coef_SZ          : INTEGER := 9;
  CONSTANT CoefCntPerCel    : INTEGER := 6;
  CONSTANT CoefPerCel       : INTEGER := 5;
  CONSTANT Cels_count       : INTEGER := 5;

--  SIGNAL coefs                       : STD_LOGIC_VECTOR((Coef_SZ*CoefCntPerCel*Cels_count)-1 DOWNTO 0);
  SIGNAL coefs_JC                    : STD_LOGIC_VECTOR((Coef_SZ*CoefPerCel*Cels_count)-1 DOWNTO 0);
  SIGNAL sample_filter_in            : samplT(ChanelCount-1 DOWNTO 0, 17 DOWNTO 0);
--  SIGNAL sample_filter_out           : samplT(ChanelCount-1 DOWNTO 0, 17 DOWNTO 0);
  --
  SIGNAL sample_filter_JC_out_val    : STD_LOGIC;
  SIGNAL sample_filter_JC_out        : samplT(ChanelCount-1 DOWNTO 0, 17 DOWNTO 0);
  --
  SIGNAL sample_filter_JC_out_r_val  : STD_LOGIC;
  SIGNAL sample_filter_JC_out_r      : samplT(ChanelCount-1 DOWNTO 0, 17 DOWNTO 0);
  -----------------------------------------------------------------------------
  SIGNAL downsampling_cnt            : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL sample_downsampling_out_val : STD_LOGIC;
  SIGNAL sample_downsampling_out     : samplT(ChanelCount-1 DOWNTO 0, 17 DOWNTO 0);
  --
  SIGNAL sample_f0_val               : STD_LOGIC;
  SIGNAL sample_f0                   : samplT(ChanelCount-1 DOWNTO 0, 17 DOWNTO 0);
  --  
  SIGNAL sample_f0_0_val             : STD_LOGIC;
  SIGNAL sample_f0_1_val             : STD_LOGIC;
  SIGNAL counter_f0                  : INTEGER;
  -----------------------------------------------------------------------------
  SIGNAL sample_f1_val               : STD_LOGIC;
  SIGNAL sample_f1                   : samplT(ChanelCount-1 DOWNTO 0, 17 DOWNTO 0);
  --
  SIGNAL sample_f2_val               : STD_LOGIC;
  SIGNAL sample_f2                   : samplT(ChanelCount-1 DOWNTO 0, 17 DOWNTO 0);
  --
  SIGNAL sample_f3_val               : STD_LOGIC;
  SIGNAL sample_f3                   : samplT(ChanelCount-1 DOWNTO 0, 17 DOWNTO 0);
  
BEGIN

  -- component instantiation
  -----------------------------------------------------------------------------
  DIGITAL_acquisition : ADS7886_drvr
    GENERIC MAP (
      ChanelCount     => ChanelCount,
      ncycle_cnv_high => ncycle_cnv_high,
      ncycle_cnv      => ncycle_cnv)
    PORT MAP (
      cnv_clk    => cnv_clk,                      -- 
      cnv_rstn   => cnv_rstn,                     -- 
      cnv_run    => cnv_run,                      --
      cnv        => cnv,                          -- 
      clk        => clk,                          -- 
      rstn       => rstn,                         -- 
      sck        => sck,                          -- 
      sdo        => sdo(ChanelCount-1 DOWNTO 0),  -- 
      sample     => sample,
      sample_val => sample_val);

  -----------------------------------------------------------------------------

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      sample_val_delay <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
      sample_val_delay <= sample_val;
    END IF;
  END PROCESS;

  -----------------------------------------------------------------------------
  ChanelLoop : FOR i IN 0 TO ChanelCount-1 GENERATE
    SampleLoop : FOR j IN 0 TO 15 GENERATE
      sample_filter_in(i, j) <= sample(i)(j);
    END GENERATE;

    sample_filter_in(i, 16) <= sample(i)(15);
    sample_filter_in(i, 17) <= sample(i)(15);
  END GENERATE;

--  coefs    <= CoefsInitValCst;
  coefs_JC <= CoefsInitValCst_JC;

  --FILTER : IIR_CEL_CTRLR
  --  GENERIC MAP (
  --    tech          => 0,
  --    Sample_SZ     => 18,
  --    ChanelsCount  => ChanelCount,
  --    Coef_SZ       => Coef_SZ,
  --    CoefCntPerCel => CoefCntPerCel,
  --    Cels_count    => Cels_count,
  --    Mem_use       => use_CEL)  -- use_CEL for SIMU, use_RAM for synthesis
  --  PORT MAP (
  --    reset      => rstn,
  --    clk        => clk,
  --    sample_clk => sample_val_delay,
  --    sample_in  => sample_filter_in,
  --    sample_out => sample_filter_out,
  --    virg_pos   => 7,
  --    GOtest     => OPEN,
  --    coefs      => coefs);

  IIR_CEL_CTRLR_v2_1 : IIR_CEL_CTRLR_v2
    GENERIC MAP (
      tech         => 0,
      Mem_use      => use_CEL,
      Sample_SZ    => 18,
      Coef_SZ      => Coef_SZ,
      Coef_Nb      => 25,               -- TODO
      Coef_sel_SZ  => 5,                -- TODO
      Cels_count   => Cels_count,
      ChanelsCount => ChanelCount)
    PORT MAP (
      rstn           => rstn,
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
      rst_all_chanel : FOR I IN ChanelCount-1 DOWNTO 0 LOOP
        rst_all_bits : FOR J IN 17 DOWNTO 0 LOOP
          sample_filter_JC_out_r(I, J) <= '0';
        END LOOP rst_all_bits;
      END LOOP rst_all_chanel;
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
      sample_filter_JC_out_r_val <= sample_filter_JC_out_val;
      IF sample_filter_JC_out_val = '1' THEN
        sample_filter_JC_out_r <= sample_filter_JC_out;
      END IF;
    END IF;
  END PROCESS;

  -----------------------------------------------------------------------------
  -- F0 -- @24.576 kHz
  -----------------------------------------------------------------------------
  Downsampling_f0 : Downsampling
    GENERIC MAP (
      ChanelCount => ChanelCount,
      SampleSize  => 18,
      DivideParam => 4)
    PORT MAP (
      clk            => clk,
      rstn           => rstn,
      sample_in_val  => sample_filter_JC_out_val ,
      sample_in      => sample_filter_JC_out,
      sample_out_val => sample_f0_val,
      sample_out     => sample_f0);

  all_bit_sample_f0 : FOR I IN 17 DOWNTO 0 GENERATE
    sample_f0_wdata(I)      <= sample_f0(0, I);
    sample_f0_wdata(18*1+I) <= sample_f0(1, I);
    sample_f0_wdata(18*2+I) <= sample_f0(2, I);
    sample_f0_wdata(18*3+I) <= sample_f0(6, I);
    sample_f0_wdata(18*4+I) <= sample_f0(7, I);
  END GENERATE all_bit_sample_f0;

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      counter_f0 <= 0;
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
      IF sample_f0_val = '1' THEN
        IF counter_f0 = 511 THEN
          counter_f0 <= 0;
        ELSE
          counter_f0 <= counter_f0 + 1;
        END IF;
      END IF;
    END IF;
  END PROCESS;

  sample_f0_0_val <= sample_f0_val WHEN counter_f0 < 256 ELSE '0';
  sample_f0_0_wen <= NOT(sample_f0_0_val) &
                       NOT(sample_f0_0_val) &
                       NOT(sample_f0_0_val) &
                       NOT(sample_f0_0_val) &
                       NOT(sample_f0_0_val);
  
  sample_f0_1_val <= sample_f0_val WHEN counter_f0 > 255 ELSE '0';
  sample_f0_1_wen <= NOT(sample_f0_1_val) &
                       NOT(sample_f0_1_val) &
                       NOT(sample_f0_1_val) &
                       NOT(sample_f0_1_val) &
                       NOT(sample_f0_1_val);


  -----------------------------------------------------------------------------
  -- F1 -- @4096 Hz
  -----------------------------------------------------------------------------
  Downsampling_f1 : Downsampling
    GENERIC MAP (
      ChanelCount => ChanelCount,
      SampleSize  => 18,
      DivideParam => 6)
    PORT MAP (
      clk            => clk,
      rstn           => rstn,
      sample_in_val  => sample_f0_val ,
      sample_in      => sample_f0,
      sample_out_val => sample_f1_val,
      sample_out     => sample_f1);

  sample_f1_wen <= NOT(sample_f1_val) &
                     NOT(sample_f1_val) &
                     NOT(sample_f1_val) &
                     NOT(sample_f1_val) &
                     NOT(sample_f1_val);
  
  all_bit_sample_f1 : FOR I IN 17 DOWNTO 0 GENERATE
    sample_f1_wdata(I)      <= sample_f1(0, I);
    sample_f1_wdata(18*1+I) <= sample_f1(1, I);
    sample_f1_wdata(18*2+I) <= sample_f1(2, I);
    sample_f1_wdata(18*3+I) <= sample_f1(6, I);
    sample_f1_wdata(18*4+I) <= sample_f1(7, I);
  END GENERATE all_bit_sample_f1;

  -----------------------------------------------------------------------------
  -- F2 -- @16 Hz
  -----------------------------------------------------------------------------
  Downsampling_f2 : Downsampling
    GENERIC MAP (
      ChanelCount => ChanelCount,
      SampleSize  => 18,
      DivideParam => 256)
    PORT MAP (
      clk            => clk,
      rstn           => rstn,
      sample_in_val  => sample_f1_val ,
      sample_in      => sample_f1,
      sample_out_val => sample_f2_val,
      sample_out     => sample_f2);

  sample_f2_wen <= NOT(sample_f2_val) &
                     NOT(sample_f2_val) &
                     NOT(sample_f2_val) &
                     NOT(sample_f2_val) &
                     NOT(sample_f2_val);
  
  all_bit_sample_f2 : FOR I IN 17 DOWNTO 0 GENERATE
    sample_f2_wdata(I)      <= sample_f2(0, I);
    sample_f2_wdata(18*1+I) <= sample_f2(1, I);
    sample_f2_wdata(18*2+I) <= sample_f2(2, I);
    sample_f2_wdata(18*3+I) <= sample_f2(6, I);
    sample_f2_wdata(18*4+I) <= sample_f2(7, I);
  END GENERATE all_bit_sample_f2;

  -----------------------------------------------------------------------------
  -- F3 -- @256 Hz
  -----------------------------------------------------------------------------
  Downsampling_f3 : Downsampling
    GENERIC MAP (
      ChanelCount => ChanelCount,
      SampleSize  => 18,
      DivideParam => 96)
    PORT MAP (
      clk            => clk,
      rstn           => rstn,
      sample_in_val  => sample_f0_val ,
      sample_in      => sample_f0,
      sample_out_val => sample_f3_val,
      sample_out     => sample_f3);

  sample_f3_wen <= (NOT sample_f3_val) &
                     (NOT sample_f3_val) &
                     (NOT sample_f3_val) &
                     (NOT sample_f3_val) &
                     (NOT sample_f3_val);
  
  all_bit_sample_f3 : FOR I IN 17 DOWNTO 0 GENERATE
    sample_f3_wdata(I)      <= sample_f3(0, I);
    sample_f3_wdata(18*1+I) <= sample_f3(1, I);
    sample_f3_wdata(18*2+I) <= sample_f3(2, I);
    sample_f3_wdata(18*3+I) <= sample_f3(6, I);
    sample_f3_wdata(18*4+I) <= sample_f3(7, I);
  END GENERATE all_bit_sample_f3;

  
  
END tb;
