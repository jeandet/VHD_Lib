LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
LIBRARY lpp;
USE lpp.lpp_ad_conv.ALL;
USE lpp.general_purpose.SYNC_FF;

-------------------------------------------------------------------------------

ENTITY ADS7886_drvr_tb IS

END ADS7886_drvr_tb;

-------------------------------------------------------------------------------

ARCHITECTURE tb OF ADS7886_drvr_tb IS

  COMPONENT TestModule_ADS7886
    GENERIC (
      freq      : INTEGER;
      amplitude : INTEGER);
    PORT (
      cnv_run : IN STD_LOGIC;
      cnv : IN  STD_LOGIC;
      sck : IN  STD_LOGIC;
      sdo : OUT STD_LOGIC);
  END COMPONENT;
  
  -- component generics
  CONSTANT ChanelCount     : INTEGER := 8;
  CONSTANT ncycle_cnv_high : INTEGER := 79;
  CONSTANT ncycle_cnv      : INTEGER := 500;

  -- component ports
  SIGNAL cnv_rstn   : STD_LOGIC;
  SIGNAL cnv        : STD_LOGIC;
  SIGNAL rstn       : STD_LOGIC;
  SIGNAL sck        : STD_LOGIC;
  SIGNAL sdo        : STD_LOGIC_VECTOR(ChanelCount-1 DOWNTO 0);
  SIGNAL sample     : Samples(ChanelCount-1 DOWNTO 0);
  SIGNAL sample_val : STD_LOGIC;
  SIGNAL run_cnv  : STD_LOGIC;

  
  -- clock
  signal Clk      : STD_LOGIC := '1';
  SIGNAL cnv_clk  : STD_LOGIC := '1';

  
BEGIN  -- tb

  MODULE_ADS7886: FOR I IN 0 TO ChanelCount-1 GENERATE
    TestModule_ADS7886_u: TestModule_ADS7886
      GENERIC MAP (
        freq      => 256/(I+1),
        amplitude => 300/(I+1))
      PORT MAP (
        cnv_run  => run_cnv,
        cnv => cnv,
        sck => sck,
        sdo => sdo(I));
  END GENERATE MODULE_ADS7886;
  
  -- component instantiation
  DUT: ADS7886_drvr
    GENERIC MAP (
      ChanelCount     => ChanelCount,
      ncycle_cnv_high => ncycle_cnv_high,
      ncycle_cnv      => ncycle_cnv)
    PORT MAP ( 
      cnv_clk    => cnv_clk,
      cnv_rstn   => cnv_rstn,
      cnv_run  => run_cnv,
      cnv        => cnv,
      clk        => clk,
      rstn       => rstn,
      sck        => sck,
      sdo        => sdo,
      sample     => sample,
      sample_val => sample_val);

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

  

END tb;

-------------------------------------------------------------------------------

CONFIGURATION ADS7886_drvr_tb_tb_cfg OF ADS7886_drvr_tb IS
  FOR tb
  END FOR;
END ADS7886_drvr_tb_tb_cfg;

-------------------------------------------------------------------------------
