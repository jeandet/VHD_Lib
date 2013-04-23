LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
LIBRARY lpp;
USE lpp.lpp_ad_conv.ALL;
USE lpp.lpp_top_lfr_pkg.ALL;

-------------------------------------------------------------------------------

ENTITY TB_Data_Acquisition IS

END TB_Data_Acquisition;

-------------------------------------------------------------------------------

ARCHITECTURE tb OF TB_Data_Acquisition IS

  COMPONENT TestModule_ADS7886
    GENERIC (
      freq      : INTEGER;
      amplitude : INTEGER;
      impulsion : INTEGER);
    PORT (
      cnv_run : IN STD_LOGIC;
      cnv : IN  STD_LOGIC;
      sck : IN  STD_LOGIC;
      sdo : OUT STD_LOGIC);
  END COMPONENT;
  
  -- component ports
  SIGNAL cnv_rstn   : STD_LOGIC;
  SIGNAL cnv        : STD_LOGIC;
  SIGNAL rstn       : STD_LOGIC;
  SIGNAL sck        : STD_LOGIC;
  SIGNAL sdo        : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL run_cnv  : STD_LOGIC;

  
  -- clock
  signal Clk      : STD_LOGIC := '1';
  SIGNAL cnv_clk  : STD_LOGIC := '1';

  -----------------------------------------------------------------------------
  SIGNAL sample_f0_wen   :  STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f0_wdata :  STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
  -----------------------------------------------------------------------------
  SIGNAL sample_f1_wen   :  STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f1_wdata :  STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
  -----------------------------------------------------------------------------
  SIGNAL sample_f2_wen   :  STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f2_wdata :  STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
  -----------------------------------------------------------------------------
  SIGNAL sample_f3_wen   :  STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f3_wdata :  STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
  
BEGIN  -- tb

  MODULE_ADS7886: FOR I IN 0 TO 6 GENERATE
    TestModule_ADS7886_u: TestModule_ADS7886
      GENERIC MAP (
        freq      => 24*(I+1),
        amplitude => 30000/(I+1),
        impulsion => 0)
      PORT MAP (
        cnv_run  => run_cnv,
        cnv => cnv,
        sck => sck,
        sdo => sdo(I));
  END GENERATE MODULE_ADS7886;
  
  TestModule_ADS7886_u: TestModule_ADS7886
    GENERIC MAP (
      freq      => 0,
      amplitude => 30000,
      impulsion => 1)
    PORT MAP (
        cnv_run  => run_cnv,
        cnv     => cnv,
        sck     => sck,
        sdo     => sdo(7));

  
  -- clock generation
  Clk     <= not Clk     after 20 ns;           -- 25     Mhz
  cnv_clk <= not cnv_clk after 10173 ps;        -- 49.152 MHz

  -- waveform generation
  WaveGen_Proc: process
  begin
    -- insert signal assignments here
    wait until Clk = '1';
    rstn        <= '0';
    cnv_rstn    <= '0';
    run_cnv     <= '0';
    wait until Clk = '1';
    wait until Clk = '1';
    wait until Clk = '1';
    rstn        <= '1';
    cnv_rstn    <= '1';
    wait until Clk = '1';
    wait until Clk = '1';
    wait until Clk = '1';
    wait until Clk = '1';
    wait until Clk = '1';
    wait until Clk = '1';
    run_cnv     <= '1';
    wait;

  end process WaveGen_Proc;
  
  -----------------------------------------------------------------------------
  
  Top_Data_Acquisition_1: lpp_top_acq 
    PORT MAP (
      cnv_run  => run_cnv,
      cnv      => cnv,
      sck      => sck,
      sdo      => sdo,
      cnv_clk  => cnv_clk,
      cnv_rstn => cnv_rstn,
      clk      => clk,
      rstn     => rstn,
    --
      sample_f0_wen   => sample_f0_wen,
      sample_f0_wdata => sample_f0_wdata,
    --
      sample_f1_wen   => sample_f1_wen,
      sample_f1_wdata => sample_f1_wdata,
    --
      sample_f2_wen   => sample_f2_wen,
      sample_f2_wdata => sample_f2_wdata,
    --
      sample_f3_wen   => sample_f3_wen,
      sample_f3_wdata => sample_f3_wdata
      );
  
  
  
  
  
END tb;
