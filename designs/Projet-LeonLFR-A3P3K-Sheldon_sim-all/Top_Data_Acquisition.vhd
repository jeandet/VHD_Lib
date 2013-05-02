LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

LIBRARY lpp;
USE lpp.lpp_ad_conv.ALL;
USE lpp.iir_filter.ALL;
USE lpp.FILTERcfg.ALL;
USE lpp.lpp_memory.ALL;
USE lpp.lpp_waveform_pkg.ALL;

LIBRARY techmap;
USE techmap.gencomp.ALL;

LIBRARY grlib;
USE grlib.amba.ALL;
USE grlib.stdlib.ALL;
USE grlib.devices.ALL;
USE GRLIB.DMA2AHB_Package.ALL;

ENTITY Top_Data_Acquisition IS
  GENERIC(
    hindex                 : INTEGER := 2;
    nb_burst_available_size : INTEGER := 11;
    nb_snapshot_param_size : INTEGER := 11;
    delta_snapshot_size    : INTEGER := 16;
    delta_f2_f0_size       : INTEGER := 10;
    delta_f2_f1_size       : INTEGER := 10;
    tech                   : INTEGER := 0
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
    sample_f0_wen   : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
    sample_f0_wdata : OUT STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
    --
    sample_f1_wen   : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
    sample_f1_wdata : OUT STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
    --
    sample_f2_wen   : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
    sample_f2_wdata : OUT STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
    --
    sample_f3_wen   : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
    sample_f3_wdata : OUT STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);

    -- AMBA AHB Master Interface
    AHB_Master_In  : IN  AHB_Mst_In_Type;
    AHB_Master_Out : OUT AHB_Mst_Out_Type;

    coarse_time_0 : IN STD_LOGIC;

    --config
    delta_snapshot : IN STD_LOGIC_VECTOR(delta_snapshot_size-1 DOWNTO 0);
    delta_f2_f1    : IN STD_LOGIC_VECTOR(delta_f2_f1_size-1 DOWNTO 0);
    delta_f2_f0    : IN STD_LOGIC_VECTOR(delta_f2_f0_size-1 DOWNTO 0);

    enable_f0 : IN STD_LOGIC;
    enable_f1 : IN STD_LOGIC;
    enable_f2 : IN STD_LOGIC;
    enable_f3 : IN STD_LOGIC;

    burst_f0 : IN STD_LOGIC;
    burst_f1 : IN STD_LOGIC;
    burst_f2 : IN STD_LOGIC;

    nb_burst_available : IN  STD_LOGIC_VECTOR(nb_burst_available_size-1 DOWNTO 0);
    nb_snapshot_param : IN  STD_LOGIC_VECTOR(nb_snapshot_param_size-1 DOWNTO 0);
    status_full       : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    status_full_ack   : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    status_full_err   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    status_new_err    : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);  -- New data f(i) before the current data is write by dma

    addr_data_f0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_data_f1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_data_f2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_data_f3 : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END Top_Data_Acquisition;

ARCHITECTURE tb OF Top_Data_Acquisition IS

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

  SIGNAL coefs                    : STD_LOGIC_VECTOR((Coef_SZ*CoefCntPerCel*Cels_count)-1 DOWNTO 0);
  SIGNAL coefs_v2                 : STD_LOGIC_VECTOR((Coef_SZ*CoefPerCel*Cels_count)-1 DOWNTO 0);
  SIGNAL sample_filter_in         : samplT(ChanelCount-1 DOWNTO 0, 17 DOWNTO 0);
  SIGNAL sample_filter_out        : samplT(ChanelCount-1 DOWNTO 0, 17 DOWNTO 0);
  --
  SIGNAL sample_filter_v2_out_val : STD_LOGIC;
  SIGNAL sample_filter_v2_out     : samplT(ChanelCount-1 DOWNTO 0, 17 DOWNTO 0);
  SIGNAL sample_filter_v2_out_s   : samplT(5 DOWNTO 0, 15 DOWNTO 0);
  -----------------------------------------------------------------------------
  SIGNAL sample_f0_val            : STD_LOGIC;
  SIGNAL sample_f0                : samplT(5 DOWNTO 0, 15 DOWNTO 0);
  --
  SIGNAL sample_f1_val            : STD_LOGIC;
  SIGNAL sample_f1                : samplT(5 DOWNTO 0, 15 DOWNTO 0);
  --
  SIGNAL sample_f2_val            : STD_LOGIC;
  SIGNAL sample_f2                : samplT(5 DOWNTO 0, 15 DOWNTO 0);
  --
  SIGNAL sample_f3_val            : STD_LOGIC;
  SIGNAL sample_f3                : samplT(5 DOWNTO 0, 15 DOWNTO 0);

  -----------------------------------------------------------------------------
  SIGNAL data_f0_in_valid : STD_LOGIC_VECTOR(159 DOWNTO 0) := (OTHERS => '0');
  SIGNAL data_f1_in_valid : STD_LOGIC_VECTOR(159 DOWNTO 0) := (OTHERS => '0');
  SIGNAL data_f2_in_valid : STD_LOGIC_VECTOR(159 DOWNTO 0) := (OTHERS => '0');
  SIGNAL data_f3_in_valid : STD_LOGIC_VECTOR(159 DOWNTO 0) := (OTHERS => '0');
  -----------------------------------------------------------------------------
  
  SIGNAL  sample_f0_wdata_s :  STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
  SIGNAL  sample_f1_wdata_s :  STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
  SIGNAL  sample_f2_wdata_s :  STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
  SIGNAL  sample_f3_wdata_s :  STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
BEGIN

  -- component instantiation
  -----------------------------------------------------------------------------
  DIGITAL_acquisition : AD7688_drvr
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

  coefs_v2 <= CoefsInitValCst_v2;

  IIR_CEL_CTRLR_v2_1 : IIR_CEL_CTRLR_v2
    GENERIC MAP (
      tech         => 0,
      Mem_use      => use_RAM,
      Sample_SZ    => 18,
      Coef_SZ      => Coef_SZ,
      Coef_Nb      => 25,
      Coef_sel_SZ  => 5,
      Cels_count   => Cels_count,
      ChanelsCount => ChanelCount)
    PORT MAP (
      rstn           => rstn,
      clk            => clk,
      virg_pos       => 7,
      coefs          => coefs_v2,
      sample_in_val  => sample_val_delay,
      sample_in      => sample_filter_in,
      sample_out_val => sample_filter_v2_out_val,
      sample_out     => sample_filter_v2_out);

  --sample_filter_v2_out_val <= sample_val_delay;
  
  ChanelLoopOut : FOR i IN 0 TO 5 GENERATE
    SampleLoopOut : FOR j IN 0 TO 15 GENERATE
      sample_filter_v2_out_s(i, j) <= sample_filter_v2_out(i, j);
      --sample_filter_v2_out_s(i, j) <= sample_filter_in(i, j);
    END GENERATE;
  END GENERATE;
  -----------------------------------------------------------------------------
  -- F0 -- @24.576 kHz
  -----------------------------------------------------------------------------
  Downsampling_f0 : Downsampling
    GENERIC MAP (
      ChanelCount => 6,
      SampleSize  => 16,
      DivideParam => 4)
    PORT MAP (
      clk            => clk,
      rstn           => rstn,
      sample_in_val  => sample_filter_v2_out_val,
      sample_in      => sample_filter_v2_out_s,
      sample_out_val => sample_f0_val,
      sample_out     => sample_f0);

  all_bit_sample_f0 : FOR I IN 15 DOWNTO 0 GENERATE
    sample_f0_wdata_s(I)      <= sample_f0(0, I);
    sample_f0_wdata_s(16*1+I) <= sample_f0(1, I);
    sample_f0_wdata_s(16*2+I) <= sample_f0(2, I);
    sample_f0_wdata_s(16*3+I) <= sample_f0(3, I);
    sample_f0_wdata_s(16*4+I) <= sample_f0(4, I);
    sample_f0_wdata_s(16*5+I) <= sample_f0(5, I);
  END GENERATE all_bit_sample_f0;

  sample_f0_wen <= NOT(sample_f0_val) &
                     NOT(sample_f0_val) &
                     NOT(sample_f0_val) &
                     NOT(sample_f0_val) &
                     NOT(sample_f0_val) &
                     NOT(sample_f0_val);

  -----------------------------------------------------------------------------
  -- F1 -- @4096 Hz
  -----------------------------------------------------------------------------
  Downsampling_f1 : Downsampling
    GENERIC MAP (
      ChanelCount => 6,
      SampleSize  => 16,
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
                     NOT(sample_f1_val) &
                     NOT(sample_f1_val);
  
  all_bit_sample_f1 : FOR I IN 15 DOWNTO 0 GENERATE
    sample_f1_wdata_s(I)      <= sample_f1(0, I);
    sample_f1_wdata_s(16*1+I) <= sample_f1(1, I);
    sample_f1_wdata_s(16*2+I) <= sample_f1(2, I);
    sample_f1_wdata_s(16*3+I) <= sample_f1(3, I);
    sample_f1_wdata_s(16*4+I) <= sample_f1(4, I);
    sample_f1_wdata_s(16*5+I) <= sample_f1(5, I);
  END GENERATE all_bit_sample_f1;

  -----------------------------------------------------------------------------
  -- F2 -- @256 Hz
  -----------------------------------------------------------------------------
  Downsampling_f2 : Downsampling
    GENERIC MAP (
      ChanelCount => 6,
      SampleSize  => 16,
      DivideParam => 96)
    PORT MAP (
      clk            => clk,
      rstn           => rstn,
      sample_in_val  => sample_f0_val ,
      sample_in      => sample_f0,
      sample_out_val => sample_f2_val,
      sample_out     => sample_f2);

  sample_f2_wen <= NOT(sample_f2_val) &
                     NOT(sample_f2_val) &
                     NOT(sample_f2_val) &
                     NOT(sample_f2_val) &
                     NOT(sample_f2_val) &
                     NOT(sample_f2_val);
  
  all_bit_sample_f2 : FOR I IN 15 DOWNTO 0 GENERATE
    sample_f2_wdata_s(I)      <= sample_f2(0, I);
    sample_f2_wdata_s(16*1+I) <= sample_f2(1, I);
    sample_f2_wdata_s(16*2+I) <= sample_f2(2, I);
    sample_f2_wdata_s(16*3+I) <= sample_f2(3, I);
    sample_f2_wdata_s(16*4+I) <= sample_f2(4, I);
    sample_f2_wdata_s(16*5+I) <= sample_f2(5, I);
  END GENERATE all_bit_sample_f2;

  -----------------------------------------------------------------------------
  -- F3 -- @16 Hz
  -----------------------------------------------------------------------------
  Downsampling_f3 : Downsampling
    GENERIC MAP (
      ChanelCount => 6,
      SampleSize  => 16,
      DivideParam => 256)
    PORT MAP (
      clk            => clk,
      rstn           => rstn,
      sample_in_val  => sample_f1_val ,
      sample_in      => sample_f1,
      sample_out_val => sample_f3_val,
      sample_out     => sample_f3);

  sample_f3_wen <= (NOT sample_f3_val) &
                     (NOT sample_f3_val) &
                     (NOT sample_f3_val) &
                     (NOT sample_f3_val) &
                     (NOT sample_f3_val) &
                     (NOT sample_f3_val);
  
  all_bit_sample_f3 : FOR I IN 15 DOWNTO 0 GENERATE
    sample_f3_wdata_s(I)      <= sample_f3(0, I);
    sample_f3_wdata_s(16*1+I) <= sample_f3(1, I);
    sample_f3_wdata_s(16*2+I) <= sample_f3(2, I);
    sample_f3_wdata_s(16*3+I) <= sample_f3(3, I);
    sample_f3_wdata_s(16*4+I) <= sample_f3(4, I);
    sample_f3_wdata_s(16*5+I) <= sample_f3(5, I);
  END GENERATE all_bit_sample_f3;

  lpp_waveform_1 : lpp_waveform
    GENERIC MAP (
      hindex                 => hindex,
      tech                   => tech,
      data_size              => 160,
      nb_burst_available_size => nb_burst_available_size,
      nb_snapshot_param_size => nb_snapshot_param_size,
      delta_snapshot_size    => delta_snapshot_size,
      delta_f2_f0_size       => delta_f2_f0_size,
      delta_f2_f1_size       => delta_f2_f1_size)
    PORT MAP (
      clk  => clk,
      rstn => rstn,

      AHB_Master_In  => AHB_Master_In,
      AHB_Master_Out => AHB_Master_Out,

      coarse_time_0     => coarse_time_0,    -- IN
      delta_snapshot    => delta_snapshot,   -- IN
      delta_f2_f1       => delta_f2_f1,      -- IN
      delta_f2_f0       => delta_f2_f0,      -- IN
      enable_f0         => enable_f0,        -- IN
      enable_f1         => enable_f1,        -- IN
      enable_f2         => enable_f2,        -- IN
      enable_f3         => enable_f3,        -- IN
      burst_f0          => burst_f0,         -- IN
      burst_f1          => burst_f1,         -- IN
      burst_f2          => burst_f2,         -- IN
      nb_burst_available => nb_burst_available,
      nb_snapshot_param => nb_snapshot_param,
      status_full       => status_full,
      status_full_ack   => status_full_ack,  -- IN
      status_full_err   => status_full_err,
      status_new_err    => status_new_err,

      addr_data_f0 => addr_data_f0,     -- IN
      addr_data_f1 => addr_data_f1,     -- IN
      addr_data_f2 => addr_data_f2,     -- IN
      addr_data_f3 => addr_data_f3,     -- IN

      data_f0_in       => data_f0_in_valid,
      data_f1_in       => data_f1_in_valid,
      data_f2_in       => data_f2_in_valid,
      data_f3_in       => data_f3_in_valid,
      data_f0_in_valid => sample_f0_val,
      data_f1_in_valid => sample_f1_val,
      data_f2_in_valid => sample_f2_val,
      data_f3_in_valid => sample_f3_val);

  data_f0_in_valid((10*16)-1 DOWNTO (4*16)) <= sample_f0_wdata_s;
  data_f1_in_valid((10*16)-1 DOWNTO (4*16)) <= sample_f1_wdata_s;
  data_f2_in_valid((10*16)-1 DOWNTO (4*16)) <= sample_f2_wdata_s;
  data_f3_in_valid((10*16)-1 DOWNTO (4*16)) <= sample_f3_wdata_s;

  sample_f0_wdata <= sample_f0_wdata_s;
  sample_f1_wdata <= sample_f1_wdata_s;
  sample_f2_wdata <= sample_f2_wdata_s;
  sample_f3_wdata <= sample_f3_wdata_s;
  
END tb;
