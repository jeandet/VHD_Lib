LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
LIBRARY lpp;
USE lpp.lpp_ad_conv.ALL;

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

  COMPONENT Top_Data_Acquisition
    PORT (
      cnv_run  : IN  STD_LOGIC;
      cnv      : OUT STD_LOGIC;
      sck      : OUT STD_LOGIC;
      sdo      : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
      cnv_clk  : IN  STD_LOGIC;
      cnv_rstn : IN  STD_LOGIC;
      clk      : IN  STD_LOGIC;
      rstn     : IN  STD_LOGIC;
    --
    sample_f0_0_ren   : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
    sample_f0_0_rdata : OUT STD_LOGIC_VECTOR((5*18)-1 DOWNTO 0);
    sample_f0_0_full  : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
    sample_f0_0_empty : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
    --
    sample_f0_1_ren   : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
    sample_f0_1_rdata : OUT STD_LOGIC_VECTOR((5*18)-1 DOWNTO 0);
    sample_f0_1_full  : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
    sample_f0_1_empty : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
    --
    sample_f1_ren   : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
    sample_f1_rdata : OUT STD_LOGIC_VECTOR((5*18)-1 DOWNTO 0);
    sample_f1_full  : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
    sample_f1_empty : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
    --
    sample_f3_ren   : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
    sample_f3_rdata : OUT STD_LOGIC_VECTOR((5*18)-1 DOWNTO 0);
    sample_f3_full  : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
    sample_f3_empty : OUT STD_LOGIC_VECTOR(4 DOWNTO 0));
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
  SIGNAL sample_f0_0_ren   :  STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f0_0_rdata :  STD_LOGIC_VECTOR((5*18)-1 DOWNTO 0);
  SIGNAL sample_f0_0_full  :  STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f0_0_empty :  STD_LOGIC_VECTOR(4 DOWNTO 0);
  -----------------------------------------------------------------------------
  SIGNAL sample_f0_1_ren   :  STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f0_1_rdata :  STD_LOGIC_VECTOR((5*18)-1 DOWNTO 0);
  SIGNAL sample_f0_1_full  :  STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f0_1_empty :  STD_LOGIC_VECTOR(4 DOWNTO 0);
  -----------------------------------------------------------------------------
  SIGNAL sample_f1_ren   :  STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f1_rdata :  STD_LOGIC_VECTOR((5*18)-1 DOWNTO 0);
  SIGNAL sample_f1_full  :  STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f1_empty :  STD_LOGIC_VECTOR(4 DOWNTO 0);
  -----------------------------------------------------------------------------
  SIGNAL sample_f3_ren   :  STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f3_rdata :  STD_LOGIC_VECTOR((5*18)-1 DOWNTO 0);
  SIGNAL sample_f3_full  :  STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f3_empty :  STD_LOGIC_VECTOR(4 DOWNTO 0);

  
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

  Top_Data_Acquisition_1: Top_Data_Acquisition
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
      sample_f0_0_ren   => sample_f0_0_ren,
      sample_f0_0_rdata => sample_f0_0_rdata,
      sample_f0_0_full  => sample_f0_0_full,
      sample_f0_0_empty => sample_f0_0_empty,
      --
      sample_f0_1_ren   => sample_f0_1_ren,
      sample_f0_1_rdata => sample_f0_1_rdata,
      sample_f0_1_full  => sample_f0_1_full,
      sample_f0_1_empty => sample_f0_1_empty,
      --
      sample_f1_ren   => sample_f1_ren,
      sample_f1_rdata => sample_f1_rdata,
      sample_f1_full  => sample_f1_full,
      sample_f1_empty => sample_f1_empty,
      --
      sample_f3_ren   => sample_f3_ren,
      sample_f3_rdata => sample_f3_rdata,
      sample_f3_full  => sample_f3_full,
      sample_f3_empty => sample_f3_empty
      );
  sample_f0_0_ren <= (OTHERS => '1');
  sample_f0_1_ren <= (OTHERS => '1');
  sample_f1_ren   <= (OTHERS => '1');
  sample_f3_ren   <= (OTHERS => '1');
  
END tb;
