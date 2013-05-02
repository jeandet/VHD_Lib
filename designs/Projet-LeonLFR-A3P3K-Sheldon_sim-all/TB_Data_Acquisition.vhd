LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

LIBRARY lpp;
USE lpp.lpp_ad_conv.ALL;
USE lpp.lpp_top_lfr_pkg.ALL;
USE lpp.lpp_waveform_pkg.ALL;

LIBRARY grlib;
USE grlib.amba.ALL;
USE grlib.stdlib.ALL;
USE grlib.devices.ALL;
USE GRLIB.DMA2AHB_Package.ALL;

LIBRARY techmap;
USE techmap.gencomp.ALL;

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
    GENERIC (
      hindex : INTEGER;
    nb_burst_available_size : INTEGER := 11;
      nb_snapshot_param_size : INTEGER := 11;
    delta_snapshot_size    : INTEGER := 16;
    delta_f2_f0_size       : INTEGER := 10;
    delta_f2_f1_size       : INTEGER := 10;
      tech   : integer);
    PORT (
      cnv_run           : IN  STD_LOGIC;
      cnv               : OUT STD_LOGIC;
      sck               : OUT STD_LOGIC;
      sdo               : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
      cnv_clk           : IN  STD_LOGIC;
      cnv_rstn          : IN  STD_LOGIC;
      clk               : IN  STD_LOGIC;
      rstn              : IN  STD_LOGIC;
      sample_f0_wen     : out  STD_LOGIC_VECTOR(5 DOWNTO 0);
      sample_f0_wdata   : OUT STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
      sample_f1_wen     : out STD_LOGIC_VECTOR(5 DOWNTO 0);
      sample_f1_wdata   : OUT STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
      sample_f2_wen     : out STD_LOGIC_VECTOR(5 DOWNTO 0);
      sample_f2_wdata   : OUT STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
      sample_f3_wen     : out STD_LOGIC_VECTOR(5 DOWNTO 0);
      sample_f3_wdata   : OUT STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
      AHB_Master_In     : IN  AHB_Mst_In_Type;
      AHB_Master_Out    : OUT AHB_Mst_Out_Type;
      coarse_time_0     : IN  STD_LOGIC;
      delta_snapshot    : IN  STD_LOGIC_VECTOR(delta_snapshot_size-1 DOWNTO 0);
      delta_f2_f1       : IN  STD_LOGIC_VECTOR(delta_f2_f1_size-1 DOWNTO 0);
      delta_f2_f0       : IN  STD_LOGIC_VECTOR(delta_f2_f0_size-1 DOWNTO 0);
      enable_f0         : IN  STD_LOGIC;
      enable_f1         : IN  STD_LOGIC;
      enable_f2         : IN  STD_LOGIC;
      enable_f3         : IN  STD_LOGIC;
      burst_f0          : IN  STD_LOGIC;
      burst_f1          : IN  STD_LOGIC;
      burst_f2          : IN  STD_LOGIC;
    nb_burst_available : IN  STD_LOGIC_VECTOR(nb_burst_available_size-1 DOWNTO 0);
      nb_snapshot_param : IN  STD_LOGIC_VECTOR(nb_snapshot_param_size-1 DOWNTO 0);
      status_full       : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      status_full_ack   : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      status_full_err   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      status_new_err    : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      addr_data_f0      : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      addr_data_f1      : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      addr_data_f2      : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      addr_data_f3      : IN  STD_LOGIC_VECTOR(31 DOWNTO 0));
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
  SIGNAL sample_f0_wen   :  STD_LOGIC_VECTOR(5 DOWNTO 0);
  SIGNAL sample_f0_wdata :  STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
  -----------------------------------------------------------------------------
  SIGNAL sample_f1_wen   :  STD_LOGIC_VECTOR(5 DOWNTO 0);
  SIGNAL sample_f1_wdata :  STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
  -----------------------------------------------------------------------------
  SIGNAL sample_f2_wen   :  STD_LOGIC_VECTOR(5 DOWNTO 0);
  SIGNAL sample_f2_wdata :  STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
  -----------------------------------------------------------------------------
  SIGNAL sample_f3_wen   :  STD_LOGIC_VECTOR(5 DOWNTO 0);
  SIGNAL sample_f3_wdata :  STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);

  -----------------------------------------------------------------------------
  CONSTANT nb_burst_available_size : INTEGER := 11;
  CONSTANT nb_snapshot_param_size : INTEGER := 11;
  CONSTANT delta_snapshot_size    : INTEGER := 16;
  CONSTANT delta_f2_f0_size       : INTEGER := 10;
  CONSTANT delta_f2_f1_size       : INTEGER := 10;
  
  SIGNAL AHB_Master_In     : AHB_Mst_In_Type;
  SIGNAL AHB_Master_Out    : AHB_Mst_Out_Type;

  SIGNAL coarse_time_0     : STD_LOGIC;
  SIGNAL coarse_time_0_t   : STD_LOGIC := '0';
  SIGNAL coarse_time_0_t2  : STD_LOGIC := '0';

  SIGNAL delta_snapshot    : STD_LOGIC_VECTOR(delta_snapshot_size-1 DOWNTO 0);
  SIGNAL delta_f2_f1       : STD_LOGIC_VECTOR(delta_f2_f1_size-1 DOWNTO 0);
  SIGNAL delta_f2_f0       : STD_LOGIC_VECTOR(delta_f2_f0_size-1 DOWNTO 0);

  SIGNAL enable_f0         : STD_LOGIC;
  SIGNAL enable_f1         : STD_LOGIC;
  SIGNAL enable_f2         : STD_LOGIC;
  SIGNAL enable_f3         : STD_LOGIC;

  SIGNAL burst_f0          : STD_LOGIC;
  SIGNAL burst_f1          : STD_LOGIC;
  SIGNAL burst_f2          : STD_LOGIC;

  SIGNAL nb_burst_available : STD_LOGIC_VECTOR(nb_burst_available_size-1 DOWNTO 0);
  SIGNAL nb_snapshot_param : STD_LOGIC_VECTOR(nb_snapshot_param_size-1 DOWNTO 0);
  
  SIGNAL status_full       : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL status_full_ack   : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL status_full_err   : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL status_new_err    : STD_LOGIC_VECTOR(3 DOWNTO 0);
  
  SIGNAL addr_data_f0      : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL addr_data_f1      : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL addr_data_f2      : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL addr_data_f3      : STD_LOGIC_VECTOR(31 DOWNTO 0);
  
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

  Top_Data_Acquisition_2: Top_Data_Acquisition
    GENERIC MAP (
      hindex => 2,
      nb_burst_available_size => nb_burst_available_size,
      nb_snapshot_param_size => nb_snapshot_param_size,
      tech   => 0)
    PORT MAP (
      cnv_run           => run_cnv,
      cnv               => cnv,
      sck               => sck,
      sdo               => sdo,
      cnv_clk           => cnv_clk,
      cnv_rstn          => cnv_rstn,
      clk               => clk,
      rstn              => rstn,
      sample_f0_wen     => sample_f0_wen,
      sample_f0_wdata   => sample_f0_wdata,
      sample_f1_wen     => sample_f1_wen,
      sample_f1_wdata   => sample_f1_wdata,
      sample_f2_wen     => sample_f2_wen,
      sample_f2_wdata   => sample_f2_wdata,
      sample_f3_wen     => sample_f3_wen,
      sample_f3_wdata   => sample_f3_wdata,
      AHB_Master_In     => AHB_Master_In,
      AHB_Master_Out    => AHB_Master_Out,
      coarse_time_0     => coarse_time_0,       
      delta_snapshot    => delta_snapshot,      
      delta_f2_f1       => delta_f2_f1,         
      delta_f2_f0       => delta_f2_f0,         
      enable_f0         => enable_f0,           
      enable_f1         => enable_f1,           
      enable_f2         => enable_f2,           
      enable_f3         => enable_f3,           
      burst_f0          => burst_f0,            
      burst_f1          => burst_f1,            
      burst_f2          => burst_f2,            
      nb_burst_available => nb_burst_available,             
      nb_snapshot_param => nb_snapshot_param,   
      status_full       => status_full,
      status_full_ack   => status_full_ack,
      status_full_err   => status_full_err,
      status_new_err    => status_new_err,
      addr_data_f0      => addr_data_f0,        
      addr_data_f1      => addr_data_f1,        
      addr_data_f2      => addr_data_f2,        
      addr_data_f3      => addr_data_f3);

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      enable_f0 <= '0';
      enable_f1 <= '0';
      enable_f2 <= '0';
      enable_f3 <= '0';
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      enable_f0 <= '1';                 --TODO  test 
      enable_f1 <= '1';
      enable_f2 <= '1';
      enable_f3 <= '1';
    END IF;
  END PROCESS;
  
  burst_f0  <= '0'; --TODO  test 
  burst_f1  <= '0'; --TODO  test 
  burst_f2  <= '0';


  delta_snapshot        <= "0000000000000001";
  --nb_snapshot_param <= "00000001110";   -- 14+1 = 15
  --delta_f2_f0           <= "1010011001";--665 = 14/2*96 -14/2
  --delta_f2_f1           <= "0000100110";-- 38 = 14/2*6 - 14/4

  -- A redefinir car ca ne tombe pas correctement ... ???
  nb_burst_available    <= "00000110010";  -- 3*16 + 2 = 34 
  nb_snapshot_param     <= "00000001111";   -- x+1 = 16
  delta_f2_f0           <= "1011001000";--712 = x/2*96 -x/2
  delta_f2_f1           <= "0000101001";-- 41 = x/2*6 - x/4
  
  addr_data_f0 <= "00000000000000000000000000000000";
  addr_data_f1 <= "00010000000000000000000000000000";
  addr_data_f2 <= "00100000000000000000000000000000";
  addr_data_f3 <= "00110000000000000000000000000000";

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      status_full_ack <= (OTHERS => '0');
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      status_full_ack <= status_full;
    END IF;
  END PROCESS;

  
  coarse_time_0_t     <= not coarse_time_0_t     after 50 ms;
  
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      coarse_time_0_t2  <= '0';
      coarse_time_0     <= '0';
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      coarse_time_0_t2  <= coarse_time_0_t;   
      coarse_time_0     <= coarse_time_0_t AND (NOT coarse_time_0_t2);
    END IF;
  END PROCESS;


  AHB_Master_In.HGRANT(2)       <= '1';
  AHB_Master_In.HREADY          <= '1';
  
  
  AHB_Master_In.HRESP <= HRESP_OKAY;


END tb;
