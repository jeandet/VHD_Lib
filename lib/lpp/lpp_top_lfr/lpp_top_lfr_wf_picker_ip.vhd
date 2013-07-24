LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY lpp;
USE lpp.lpp_ad_conv.ALL;
USE lpp.iir_filter.ALL;
USE lpp.FILTERcfg.ALL;
USE lpp.lpp_memory.ALL;
USE lpp.lpp_waveform_pkg.ALL;
USE lpp.general_purpose.SYNC_FF;

LIBRARY techmap;
USE techmap.gencomp.ALL;

LIBRARY grlib;
USE grlib.amba.ALL;
USE grlib.stdlib.ALL;
USE grlib.devices.ALL;
USE GRLIB.DMA2AHB_Package.ALL;

ENTITY lpp_top_lfr_wf_picker_ip IS
  GENERIC(
    hindex                  : INTEGER := 2;
    nb_burst_available_size : INTEGER := 11;
    nb_snapshot_param_size  : INTEGER := 11;
    delta_snapshot_size     : INTEGER := 16;
    delta_f2_f0_size        : INTEGER := 10;
    delta_f2_f1_size        : INTEGER := 10;
    tech                    : INTEGER := 0;
    Mem_use                 : INTEGER := use_RAM
    );
  PORT (
    sample           : IN Samples(7 DOWNTO 0);
    sample_val       : IN STD_LOGIC;
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
    data_shaping_SP0 : IN STD_LOGIC;
    data_shaping_SP1 : IN STD_LOGIC;
    data_shaping_R0  : IN STD_LOGIC;
    data_shaping_R1  : IN STD_LOGIC;

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
    nb_snapshot_param  : IN  STD_LOGIC_VECTOR(nb_snapshot_param_size-1 DOWNTO 0);
    status_full        : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    status_full_ack    : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    status_full_err    : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    status_new_err     : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);  -- New data f(i) before the current data is write by dma

    addr_data_f0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_data_f1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_data_f2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_data_f3 : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END lpp_top_lfr_wf_picker_ip;

ARCHITECTURE tb OF lpp_top_lfr_wf_picker_ip IS

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

  COMPONENT SYNC_FF
    GENERIC (
      NB_FF_OF_SYNC : INTEGER);
    PORT (
      clk    : IN  STD_LOGIC;
      rstn   : IN  STD_LOGIC;
      A      : IN  STD_LOGIC;
      A_sync : OUT STD_LOGIC);
  END COMPONENT;

  -----------------------------------------------------------------------------
  CONSTANT ChanelCount     : INTEGER := 8;

  -----------------------------------------------------------------------------
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
  -----------------------------------------------------------------------------
  --SIGNAL sample_filter_v2_out_reg : samplT(ChanelCount-1 DOWNTO 0, 17 DOWNTO 0);

  --SIGNAL sample_filter_v2_out_reg_val    : STD_LOGIC;
  --SIGNAL sample_filter_v2_out_reg_val_s  : STD_LOGIC;
  --SIGNAL sample_filter_v2_out_reg_val_s2 : STD_LOGIC;
  --SIGNAL only_one_hot                    : STD_LOGIC;
  --SIGNAL sample_filter_v2_out_sync_val_t : STD_LOGIC;
  --SIGNAL sample_filter_v2_out_sync_val   : STD_LOGIC;
  --SIGNAL sample_filter_v2_out_sync       : samplT(ChanelCount-1 DOWNTO 0, 17 DOWNTO 0);
  -----------------------------------------------------------------------------
  SIGNAL sample_data_shaping_out_val     : STD_LOGIC;
  SIGNAL sample_data_shaping_out         : samplT(ChanelCount-1 DOWNTO 0, 17 DOWNTO 0);
  SIGNAL sample_data_shaping_f0_s        : STD_LOGIC_VECTOR(17 DOWNTO 0);
  SIGNAL sample_data_shaping_f1_s        : STD_LOGIC_VECTOR(17 DOWNTO 0);
  SIGNAL sample_data_shaping_f2_s        : STD_LOGIC_VECTOR(17 DOWNTO 0);
  SIGNAL sample_data_shaping_f1_f0_s     : STD_LOGIC_VECTOR(17 DOWNTO 0);
  SIGNAL sample_data_shaping_f2_f1_s     : STD_LOGIC_VECTOR(17 DOWNTO 0);
  -----------------------------------------------------------------------------
  SIGNAL sample_filter_v2_out_val_s      : STD_LOGIC;
  SIGNAL sample_filter_v2_out_s          : samplT(ChanelCount-1 DOWNTO 0, 15 DOWNTO 0);
  -----------------------------------------------------------------------------
  SIGNAL sample_f0_val                   : STD_LOGIC;
  SIGNAL sample_f0                       : samplT(ChanelCount-1 DOWNTO 0, 15 DOWNTO 0);
  SIGNAL sample_f0_s                     : samplT(5 DOWNTO 0, 15 DOWNTO 0);
  --
  SIGNAL sample_f1_val                   : STD_LOGIC;
  SIGNAL sample_f1                       : samplT(ChanelCount-1 DOWNTO 0, 15 DOWNTO 0);
  SIGNAL sample_f1_s                     : samplT(5 DOWNTO 0, 15 DOWNTO 0);
  --
  SIGNAL sample_f2_val                   : STD_LOGIC;
  SIGNAL sample_f2                       : samplT(5 DOWNTO 0, 15 DOWNTO 0);
  --
  SIGNAL sample_f3_val                   : STD_LOGIC;
  SIGNAL sample_f3                       : samplT(5 DOWNTO 0, 15 DOWNTO 0);

  -----------------------------------------------------------------------------
  SIGNAL data_f0_in_valid : STD_LOGIC_VECTOR(159 DOWNTO 0) := (OTHERS => '0');
  SIGNAL data_f1_in_valid : STD_LOGIC_VECTOR(159 DOWNTO 0) := (OTHERS => '0');
  SIGNAL data_f2_in_valid : STD_LOGIC_VECTOR(159 DOWNTO 0) := (OTHERS => '0');
  SIGNAL data_f3_in_valid : STD_LOGIC_VECTOR(159 DOWNTO 0) := (OTHERS => '0');
  -----------------------------------------------------------------------------

  SIGNAL sample_f0_wdata_s : STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
  SIGNAL sample_f1_wdata_s : STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
  SIGNAL sample_f2_wdata_s : STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
  SIGNAL sample_f3_wdata_s : STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
BEGIN
  
  -----------------------------------------------------------------------------
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN              -- asynchronous reset (active low)
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
      Mem_use      => Mem_use,          -- use_RAM
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


  -----------------------------------------------------------------------------
  -- RESYNC STAGE
  -----------------------------------------------------------------------------

  --all_sample_reg : FOR I IN ChanelCount-1 DOWNTO 0 GENERATE
  --  all_data_reg : FOR J IN 17 DOWNTO 0 GENERATE
  --    PROCESS (cnv_clk, cnv_rstn)
  --    BEGIN  -- PROCESS
  --      IF cnv_rstn = '0' THEN          -- asynchronous reset (active low)
  --        sample_filter_v2_out_reg(I, J) <= '0';
  --      ELSIF cnv_clk'EVENT AND cnv_clk = '1' THEN  -- rising clock edge
  --        IF sample_filter_v2_out_val = '1' THEN
  --          sample_filter_v2_out_reg(I, J) <= sample_filter_v2_out(I, J);
  --        END IF;
  --      END IF;
  --    END PROCESS;
  --  END GENERATE all_data_reg;
  --END GENERATE all_sample_reg;

  --PROCESS (cnv_clk, cnv_rstn)
  --BEGIN  -- PROCESS
  --  IF cnv_rstn = '0' THEN              -- asynchronous reset (active low)
  --    sample_filter_v2_out_reg_val <= '0';
  --  ELSIF cnv_clk'EVENT AND cnv_clk = '1' THEN  -- rising clock edge
  --    IF sample_filter_v2_out_val = '1' THEN
  --      sample_filter_v2_out_reg_val <= '1';
  --    ELSIF sample_filter_v2_out_reg_val_s2 = '1' THEN
  --      sample_filter_v2_out_reg_val <= '0';
  --    END IF;
  --  END IF;
  --END PROCESS;

  --SYNC_FF_1 : SYNC_FF
  --  GENERIC MAP (
  --    NB_FF_OF_SYNC => 2)
  --  PORT MAP (
  --    clk    => clk,
  --    rstn   => rstn,
  --    A      => sample_filter_v2_out_reg_val,
  --    A_sync => sample_filter_v2_out_reg_val_s);

  --SYNC_FF_2 : SYNC_FF
  --  GENERIC MAP (
  --    NB_FF_OF_SYNC => 2)
  --  PORT MAP (
  --    clk    => cnv_clk,
  --    rstn   => cnv_rstn,
  --    A      => sample_filter_v2_out_reg_val_s,
  --    A_sync => sample_filter_v2_out_reg_val_s2);


  --PROCESS (clk, rstn)
  --BEGIN  -- PROCESS
  --  IF rstn = '0' THEN                  -- asynchronous reset (active low)
  --    sample_filter_v2_out_sync_val_t <= '0';
  --    sample_filter_v2_out_sync_val   <= '0';
  --    only_one_hot                    <= '0';
  --  ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
  --    sample_filter_v2_out_sync_val_t <= sample_filter_v2_out_reg_val_s AND NOT only_one_hot;
  --    only_one_hot                    <= sample_filter_v2_out_reg_val_s;
  --    sample_filter_v2_out_sync_val   <= sample_filter_v2_out_sync_val_t;
  --  END IF;
  --END PROCESS;


  --all_sample_reg2 : FOR I IN ChanelCount-1 DOWNTO 0 GENERATE
  --  all_data_reg : FOR J IN 17 DOWNTO 0 GENERATE
  --    PROCESS (clk, cnv_rstn)
  --    BEGIN  -- PROCESS
  --      IF cnv_rstn = '0' THEN              -- asynchronous reset (active low)
  --        sample_filter_v2_out_sync(I,J) <= '0';
  --      ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
  --        IF sample_filter_v2_out_sync_val_t = '1' THEN
  --          sample_filter_v2_out_sync(I,J) <= sample_filter_v2_out_reg(I,J);
  --        END IF;
  --      END IF;
  --    END PROCESS;
  --  END GENERATE all_data_reg;
  --END GENERATE all_sample_reg2;


  -----------------------------------------------------------------------------
  -- DATA_SHAPING
  ----------------------------------------------------------------------------- 
  all_data_shaping_in_loop : FOR I IN 17 DOWNTO 0 GENERATE
    sample_data_shaping_f0_s(I) <= sample_filter_v2_out(0, I);
    sample_data_shaping_f1_s(I) <= sample_filter_v2_out(1, I);
    sample_data_shaping_f2_s(I) <= sample_filter_v2_out(2, I);
  END GENERATE all_data_shaping_in_loop;

  sample_data_shaping_f1_f0_s <= sample_data_shaping_f1_s - sample_data_shaping_f0_s;
  sample_data_shaping_f2_f1_s <= sample_data_shaping_f2_s - sample_data_shaping_f1_s;

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      sample_data_shaping_out_val <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
      sample_data_shaping_out_val <= sample_filter_v2_out_val;
    END IF;
  END PROCESS;

  SampleLoop_data_shaping : FOR j IN 0 TO 17 GENERATE
    PROCESS (clk, rstn)
    BEGIN
      IF rstn = '0' THEN
        sample_data_shaping_out(0, j) <= '0';
        sample_data_shaping_out(1, j) <= '0';
        sample_data_shaping_out(2, j) <= '0';
        sample_data_shaping_out(3, j) <= '0';
        sample_data_shaping_out(4, j) <= '0';
        sample_data_shaping_out(5, j) <= '0';
        sample_data_shaping_out(6, j) <= '0';
        sample_data_shaping_out(7, j) <= '0';
      ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
        sample_data_shaping_out(0, j) <= sample_filter_v2_out(0, j);
        IF data_shaping_SP0 = '1' THEN
          sample_data_shaping_out(1, j) <= sample_data_shaping_f1_f0_s(j);
        ELSE
          sample_data_shaping_out(1, j) <= sample_filter_v2_out(1, j);
        END IF;
        IF data_shaping_SP1 = '1' THEN
          sample_data_shaping_out(2, j) <= sample_data_shaping_f2_f1_s(j);
        ELSE
          sample_data_shaping_out(2, j) <= sample_filter_v2_out(2, j);
        END IF;
        sample_data_shaping_out(3, j) <= sample_filter_v2_out(3, j);
        sample_data_shaping_out(4, j) <= sample_filter_v2_out(4, j);
        sample_data_shaping_out(5, j) <= sample_filter_v2_out(5, j);
        sample_data_shaping_out(6, j) <= sample_filter_v2_out(6, j);
        sample_data_shaping_out(7, j) <= sample_filter_v2_out(7, j);
      END IF;
    END PROCESS;
  END GENERATE;

  sample_filter_v2_out_val_s <= sample_data_shaping_out_val;
  ChanelLoopOut : FOR i IN 0 TO 7 GENERATE
    SampleLoopOut : FOR j IN 0 TO 15 GENERATE
      sample_filter_v2_out_s(i, j) <= sample_data_shaping_out(i, j);
    END GENERATE;
  END GENERATE;
  -----------------------------------------------------------------------------
  -- F0 -- @24.576 kHz
  -----------------------------------------------------------------------------
  Downsampling_f0 : Downsampling
    GENERIC MAP (
      ChanelCount => 8,
      SampleSize  => 16,
      DivideParam => 4)
    PORT MAP (
      clk            => clk,
      rstn           => rstn,
      sample_in_val  => sample_filter_v2_out_val_s,
      sample_in      => sample_filter_v2_out_s,
      sample_out_val => sample_f0_val,
      sample_out     => sample_f0);

  all_bit_sample_f0 : FOR I IN 15 DOWNTO 0 GENERATE
    sample_f0_wdata_s(I)      <= sample_f0(0, I);  -- V
    sample_f0_wdata_s(16*1+I) <= sample_f0(1, I) WHEN data_shaping_R0 = '1' ELSE sample_f0(3, I);  -- E1
    sample_f0_wdata_s(16*2+I) <= sample_f0(2, I) WHEN data_shaping_R0 = '1' ELSE sample_f0(4, I);  -- E2
    sample_f0_wdata_s(16*3+I) <= sample_f0(5, I);  -- B1
    sample_f0_wdata_s(16*4+I) <= sample_f0(6, I);  -- B2
    sample_f0_wdata_s(16*5+I) <= sample_f0(7, I);  -- B3
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
      ChanelCount => 8,
      SampleSize  => 16,
      DivideParam => 6)
    PORT MAP (
      clk            => clk,
      rstn           => rstn,
      sample_in_val  => sample_f0_val ,
      sample_in      => sample_f0,
      sample_out_val => sample_f1_val,
      sample_out     => sample_f1);

  all_bit_sample_f1 : FOR I IN 15 DOWNTO 0 GENERATE
    sample_f1_wdata_s(I)      <= sample_f1(0, I);  -- V
    sample_f1_wdata_s(16*1+I) <= sample_f1(1, I) WHEN data_shaping_R1 = '1' ELSE sample_f1(3, I);  -- E1
    sample_f1_wdata_s(16*2+I) <= sample_f1(2, I) WHEN data_shaping_R1 = '1' ELSE sample_f1(4, I);  -- E2
    sample_f1_wdata_s(16*3+I) <= sample_f1(5, I);  -- B1
    sample_f1_wdata_s(16*4+I) <= sample_f1(6, I);  -- B2
    sample_f1_wdata_s(16*5+I) <= sample_f1(7, I);  -- B3
  END GENERATE all_bit_sample_f1;

  sample_f1_wen <= NOT(sample_f1_val) &
                   NOT(sample_f1_val) &
                   NOT(sample_f1_val) &
                   NOT(sample_f1_val) &
                   NOT(sample_f1_val) &
                   NOT(sample_f1_val);

  -----------------------------------------------------------------------------
  -- F2 -- @256 Hz
  -----------------------------------------------------------------------------
  all_bit_sample_f0_s : FOR I IN 15 DOWNTO 0 GENERATE
    sample_f0_s(0, I) <= sample_f0(0, I);  -- V
    sample_f0_s(1, I) <= sample_f0(1, I);  -- E1
    sample_f0_s(2, I) <= sample_f0(2, I);  -- E2
    sample_f0_s(3, I) <= sample_f0(5, I);  -- B1
    sample_f0_s(4, I) <= sample_f0(6, I);  -- B2
    sample_f0_s(5, I) <= sample_f0(7, I);  -- B3
  END GENERATE all_bit_sample_f0_s;

  Downsampling_f2 : Downsampling
    GENERIC MAP (
      ChanelCount => 6,
      SampleSize  => 16,
      DivideParam => 96)
    PORT MAP (
      clk            => clk,
      rstn           => rstn,
      sample_in_val  => sample_f0_val ,
      sample_in      => sample_f0_s,
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
  all_bit_sample_f1_s : FOR I IN 15 DOWNTO 0 GENERATE
    sample_f1_s(0, I) <= sample_f1(0, I);  -- V
    sample_f1_s(1, I) <= sample_f1(1, I);  -- E1
    sample_f1_s(2, I) <= sample_f1(2, I);  -- E2
    sample_f1_s(3, I) <= sample_f1(5, I);  -- B1
    sample_f1_s(4, I) <= sample_f1(6, I);  -- B2
    sample_f1_s(5, I) <= sample_f1(7, I);  -- B3
  END GENERATE all_bit_sample_f1_s;

  Downsampling_f3 : Downsampling
    GENERIC MAP (
      ChanelCount => 6,
      SampleSize  => 16,
      DivideParam => 256)
    PORT MAP (
      clk            => clk,
      rstn           => rstn,
      sample_in_val  => sample_f1_val ,
      sample_in      => sample_f1_s,
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
      hindex                  => hindex,
      tech                    => tech,
      data_size               => 160,
      nb_burst_available_size => nb_burst_available_size,
      nb_snapshot_param_size  => nb_snapshot_param_size,
      delta_snapshot_size     => delta_snapshot_size,
      delta_f2_f0_size        => delta_f2_f0_size,
      delta_f2_f1_size        => delta_f2_f1_size)
    PORT MAP (
      clk  => clk,
      rstn => rstn,

      AHB_Master_In  => AHB_Master_In,
      AHB_Master_Out => AHB_Master_Out,

      coarse_time_0      => coarse_time_0,    -- IN
      delta_snapshot     => delta_snapshot,   -- IN
      delta_f2_f1        => delta_f2_f1,      -- IN
      delta_f2_f0        => delta_f2_f0,      -- IN
      enable_f0          => enable_f0,        -- IN
      enable_f1          => enable_f1,        -- IN
      enable_f2          => enable_f2,        -- IN
      enable_f3          => enable_f3,        -- IN
      burst_f0           => burst_f0,         -- IN
      burst_f1           => burst_f1,         -- IN
      burst_f2           => burst_f2,         -- IN
      nb_burst_available => nb_burst_available,
      nb_snapshot_param  => nb_snapshot_param,
      status_full        => status_full,
      status_full_ack    => status_full_ack,  -- IN
      status_full_err    => status_full_err,
      status_new_err     => status_new_err,

      addr_data_f0 => addr_data_f0,     -- IN
      addr_data_f1 => addr_data_f1,     -- IN
      addr_data_f2 => addr_data_f2,     -- IN
      addr_data_f3 => addr_data_f3,     -- IN

      data_f0_in => data_f0_in_valid,
      data_f1_in => data_f1_in_valid,
      data_f2_in => data_f2_in_valid,
      data_f3_in => data_f3_in_valid,

      data_f0_in_valid => sample_f0_val,
      data_f1_in_valid => sample_f1_val,
      data_f2_in_valid => sample_f2_val,
      data_f3_in_valid => sample_f3_val);

  data_f0_in_valid((4*16)-1 DOWNTO 0) <= (OTHERS => '0');
  data_f1_in_valid((4*16)-1 DOWNTO 0) <= (OTHERS => '0');
  data_f2_in_valid((4*16)-1 DOWNTO 0) <= (OTHERS => '0');
  data_f3_in_valid((4*16)-1 DOWNTO 0) <= (OTHERS => '0');

  data_f0_in_valid((10*16)-1 DOWNTO (4*16)) <= sample_f0_wdata_s;
  data_f1_in_valid((10*16)-1 DOWNTO (4*16)) <= sample_f1_wdata_s;
  data_f2_in_valid((10*16)-1 DOWNTO (4*16)) <= sample_f2_wdata_s;
  data_f3_in_valid((10*16)-1 DOWNTO (4*16)) <= sample_f3_wdata_s;

  sample_f0_wdata <= sample_f0_wdata_s;
  sample_f1_wdata <= sample_f1_wdata_s;
  sample_f2_wdata <= sample_f2_wdata_s;
  sample_f3_wdata <= sample_f3_wdata_s;
  
END tb;
