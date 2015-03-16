----------------------------------------------------------------------------------
-- Company: 
-- Engineer:
-- 
-- Create Date:    11:17:05 07/02/2012
-- Design Name:
-- Module Name:    apb_lfr_time_management - Behavioral
-- Project Name:
-- Target Devices: 
-- Tool versions:
-- Description:
--
-- Dependencies:
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
LIBRARY grlib;
USE grlib.amba.ALL;
USE grlib.stdlib.ALL;
USE grlib.devices.ALL;
LIBRARY lpp;
USE lpp.apb_devices_list.ALL;
USE lpp.general_purpose.ALL;
USE lpp.lpp_lfr_management.ALL;
USE lpp.lpp_lfr_management_apbreg_pkg.ALL;
USE lpp.lpp_cna.ALL;
LIBRARY techmap;
USE techmap.gencomp.ALL;


ENTITY apb_lfr_management IS

  GENERIC(
    tech             : INTEGER := 0;
    pindex           : INTEGER := 0;        --! APB slave index
    paddr            : INTEGER := 0;        --! ADDR field of the APB BAR
    pmask            : INTEGER := 16#fff#;  --! MASK field of the APB BAR
    FIRST_DIVISION   : INTEGER := 374;
    NB_SECOND_DESYNC : INTEGER := 60
    );

  PORT (
    clk25MHz         : IN STD_LOGIC;    --! Clock
    resetn_25MHz     : IN STD_LOGIC;    --! Reset
    clk24_576MHz     : IN STD_LOGIC;    --! secondary clock
    resetn_24_576MHz : IN STD_LOGIC;    --! Reset

    grspw_tick : IN STD_LOGIC;  --! grspw signal asserted when a valid time-code is received

    apbi          : IN  apb_slv_in_type;   --! APB slave input signals
    apbo          : OUT apb_slv_out_type;  --! APB slave output signals
    ---------------------------------------------------------------------------
    HK_sample     : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
    HK_val        : IN  STD_LOGIC;
    HK_sel        : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    ---------------------------------------------------------------------------
    DAC_SDO       : OUT STD_LOGIC;
    DAC_SCK       : OUT STD_LOGIC;
    DAC_SYNC      : OUT STD_LOGIC;
    DAC_CAL_EN    : OUT STD_LOGIC;
    ---------------------------------------------------------------------------
    coarse_time   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);  --! coarse time
    fine_time     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);  --! fine TIME
    ---------------------------------------------------------------------------
    LFR_soft_rstn : OUT STD_LOGIC
    );

END apb_lfr_management;

ARCHITECTURE Behavioral OF apb_lfr_management IS

  CONSTANT REVISION : INTEGER := 1;
  CONSTANT pconfig : apb_config_type := (
    0 => ahb_device_reg (VENDOR_LPP, LPP_LFR_MANAGEMENT, 0, REVISION, 0),
    1 => apb_iobar(paddr, pmask)
    );

  TYPE apb_lfr_time_management_Reg IS RECORD
    ctrl             : STD_LOGIC;
    soft_reset       : STD_LOGIC;
    coarse_time_load : STD_LOGIC_VECTOR(30 DOWNTO 0);
    coarse_time      : STD_LOGIC_VECTOR(31 DOWNTO 0);
    fine_time        : STD_LOGIC_VECTOR(15 DOWNTO 0);
    LFR_soft_reset   : STD_LOGIC;
    HK_temp_0        : STD_LOGIC_VECTOR(15 DOWNTO 0);
    HK_temp_1        : STD_LOGIC_VECTOR(15 DOWNTO 0);
    HK_temp_2        : STD_LOGIC_VECTOR(15 DOWNTO 0);
  END RECORD;
  SIGNAL r : apb_lfr_time_management_Reg;

  SIGNAL Rdata               : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL force_tick          : STD_LOGIC;
  SIGNAL previous_force_tick : STD_LOGIC;
  SIGNAL soft_tick           : STD_LOGIC;

  SIGNAL coarsetime_reg_updated : STD_LOGIC;
  SIGNAL coarsetime_reg         : STD_LOGIC_VECTOR(30 DOWNTO 0);

  --SIGNAL coarse_time_new    : STD_LOGIC;
  SIGNAL coarse_time_new_49 : STD_LOGIC;
  SIGNAL coarse_time_49     : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL coarse_time_s      : STD_LOGIC_VECTOR(31 DOWNTO 0);

  --SIGNAL fine_time_new      : STD_LOGIC;
  --SIGNAL fine_time_new_temp : STD_LOGIC;
  SIGNAL fine_time_new_49 : STD_LOGIC;
  SIGNAL fine_time_49     : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL fine_time_s      : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL tick             : STD_LOGIC;
  SIGNAL new_timecode     : STD_LOGIC;
  SIGNAL new_coarsetime   : STD_LOGIC;

  SIGNAL time_new_49 : STD_LOGIC;
  SIGNAL time_new    : STD_LOGIC;

  -----------------------------------------------------------------------------
  SIGNAL force_reset          : STD_LOGIC;
  SIGNAL previous_force_reset : STD_LOGIC;
  SIGNAL soft_reset           : STD_LOGIC;
  SIGNAL soft_reset_sync      : STD_LOGIC;
  -----------------------------------------------------------------------------
  SIGNAL HK_sel_s             : STD_LOGIC_VECTOR(1 DOWNTO 0);

  SIGNAL previous_fine_time_bit : STD_LOGIC;

  SIGNAL rstn_LFR_TM : STD_LOGIC;

  -----------------------------------------------------------------------------
  -- DAC
  -----------------------------------------------------------------------------
  CONSTANT PRESZ         : INTEGER := 8;
  CONSTANT CPTSZ         : INTEGER := 16;
  CONSTANT datawidth     : INTEGER := 18;
  CONSTANT dacresolution : INTEGER := 12;
  CONSTANT abits         : INTEGER := 8;

  SIGNAL pre           : STD_LOGIC_VECTOR(PRESZ-1 DOWNTO 0);
  SIGNAL N             : STD_LOGIC_VECTOR(CPTSZ-1 DOWNTO 0);
  SIGNAL Reload        : STD_LOGIC;
  SIGNAL DATA_IN       : STD_LOGIC_VECTOR(datawidth-1 DOWNTO 0);
  SIGNAL WEN           : STD_LOGIC;
  SIGNAL LOAD_ADDRESSN : STD_LOGIC;
  SIGNAL ADDRESS_IN    : STD_LOGIC_VECTOR(abits-1 DOWNTO 0);
  SIGNAL ADDRESS_OUT   : STD_LOGIC_VECTOR(abits-1 DOWNTO 0);
  SIGNAL INTERLEAVED   : STD_LOGIC;
  SIGNAL DAC_CFG       : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL DAC_CAL_EN_s  : STD_LOGIC;
  
BEGIN

  LFR_soft_rstn <= NOT r.LFR_soft_reset;

  PROCESS(resetn_25MHz, clk25MHz)
    VARIABLE paddr : STD_LOGIC_VECTOR(7 DOWNTO 2);
  BEGIN

    IF resetn_25MHz = '0' THEN
      Rdata              <= (OTHERS => '0');
      r.coarse_time_load <= (OTHERS => '0');
      r.soft_reset       <= '0';
      r.ctrl             <= '0';
      r.LFR_soft_reset   <= '1';

      force_tick          <= '0';
      previous_force_tick <= '0';
      soft_tick           <= '0';

      coarsetime_reg_updated <= '0';
      --DAC
      pre                    <= (OTHERS => '1');
      N                      <= (OTHERS => '1');
      Reload                 <= '1';
      DATA_IN                <= (OTHERS => '0');
      WEN                    <= '1';
      LOAD_ADDRESSN          <= '1';
      ADDRESS_IN             <= (OTHERS => '1');
      INTERLEAVED            <= '0';
      DAC_CFG                <= (OTHERS => '0');
      --
      DAC_CAL_EN_s           <= '0';
    ELSIF clk25MHz'EVENT AND clk25MHz = '1' THEN
      coarsetime_reg_updated <= '0';

      force_tick          <= r.ctrl;
      previous_force_tick <= force_tick;
      IF (previous_force_tick = '0') AND (force_tick = '1') THEN
        soft_tick <= '1';
      ELSE
        soft_tick <= '0';
      END IF;

      force_reset          <= r.soft_reset;
      previous_force_reset <= force_reset;
      IF (previous_force_reset = '0') AND (force_reset = '1') THEN
        soft_reset <= '1';
      ELSE
        soft_reset <= '0';
      END IF;

      paddr             := "000000";
      paddr(7 DOWNTO 2) := apbi.paddr(7 DOWNTO 2);
      Rdata             <= (OTHERS => '0');

      LOAD_ADDRESSN <= '1';
      WEN           <= '1';

      IF apbi.psel(pindex) = '1' THEN
        --APB READ OP
        CASE paddr(7 DOWNTO 2) IS
          WHEN ADDR_LFR_MANAGMENT_CONTROL =>
            Rdata(0)           <= r.ctrl;
            Rdata(1)           <= r.soft_reset;
            Rdata(2)           <= r.LFR_soft_reset;
            Rdata(31 DOWNTO 3) <= (OTHERS => '0');
          WHEN ADDR_LFR_MANAGMENT_TIME_LOAD =>
            Rdata(30 DOWNTO 0) <= r.coarse_time_load(30 DOWNTO 0);
          WHEN ADDR_LFR_MANAGMENT_TIME_COARSE =>
            Rdata(31 DOWNTO 0) <= r.coarse_time(31 DOWNTO 0);
          WHEN ADDR_LFR_MANAGMENT_TIME_FINE =>
            Rdata(31 DOWNTO 16) <= (OTHERS => '0');
            Rdata(15 DOWNTO 0)  <= r.fine_time(15 DOWNTO 0);
          WHEN ADDR_LFR_MANAGMENT_HK_TEMP_0 =>
            Rdata(31 DOWNTO 16) <= (OTHERS => '0');
            Rdata(15 DOWNTO 0)  <= r.HK_temp_0;
          WHEN ADDR_LFR_MANAGMENT_HK_TEMP_1 =>
            Rdata(31 DOWNTO 16) <= (OTHERS => '0');
            Rdata(15 DOWNTO 0)  <= r.HK_temp_1;
          WHEN ADDR_LFR_MANAGMENT_HK_TEMP_2 =>
            Rdata(31 DOWNTO 16) <= (OTHERS => '0');
            Rdata(15 DOWNTO 0)  <= r.HK_temp_2;
          WHEN ADDR_LFR_MANAGMENT_DAC_CONTROL =>
            Rdata(3 DOWNTO 0)  <= DAC_CFG;
            Rdata(4)           <= Reload;
            Rdata(5)           <= INTERLEAVED;
            Rdata(6)           <= DAC_CAL_EN_s;
            Rdata(31 DOWNTO 7) <= (OTHERS => '0');
          WHEN ADDR_LFR_MANAGMENT_DAC_PRE =>
            Rdata(PRESZ-1 DOWNTO 0) <= pre;
            Rdata(31 DOWNTO PRESZ)  <= (OTHERS => '0');
          WHEN ADDR_LFR_MANAGMENT_DAC_N =>
            Rdata(CPTSZ-1 DOWNTO 0) <= N;
            Rdata(31 DOWNTO CPTSZ)  <= (OTHERS => '0');
          WHEN ADDR_LFR_MANAGMENT_DAC_ADDRESS_OUT =>
            Rdata(abits-1 DOWNTO 0) <= ADDRESS_OUT;
            Rdata(31 DOWNTO abits)  <= (OTHERS => '0');
          WHEN ADDR_LFR_MANAGMENT_DAC_DATA_IN =>
            Rdata(datawidth-1 DOWNTO 0) <= DATA_IN;
            Rdata(31 DOWNTO datawidth)  <= (OTHERS => '0');
          WHEN OTHERS =>
            Rdata(31 DOWNTO 0) <= (OTHERS => '0');
        END CASE;

        --APB Write OP
        IF (apbi.pwrite AND apbi.penable) = '1' THEN
          CASE paddr(7 DOWNTO 2) IS
            WHEN ADDR_LFR_MANAGMENT_CONTROL =>
              r.ctrl           <= apbi.pwdata(0);
              r.soft_reset     <= apbi.pwdata(1);
              r.LFR_soft_reset <= apbi.pwdata(2);
            WHEN ADDR_LFR_MANAGMENT_TIME_LOAD =>
              r.coarse_time_load     <= apbi.pwdata(30 DOWNTO 0);
              coarsetime_reg_updated <= '1';
            WHEN ADDR_LFR_MANAGMENT_DAC_CONTROL =>
              DAC_CFG      <= apbi.pwdata(3 DOWNTO 0);
              Reload       <= apbi.pwdata(4);
              INTERLEAVED  <= apbi.pwdata(5);
              DAC_CAL_EN_s <= apbi.pwdata(6);
            WHEN ADDR_LFR_MANAGMENT_DAC_PRE =>
              pre <= apbi.pwdata(PRESZ-1 DOWNTO 0);
            WHEN ADDR_LFR_MANAGMENT_DAC_N =>
              N <= apbi.pwdata(CPTSZ-1 DOWNTO 0);
            WHEN ADDR_LFR_MANAGMENT_DAC_ADDRESS_OUT =>
              ADDRESS_IN    <= apbi.pwdata(abits-1 DOWNTO 0);
              LOAD_ADDRESSN <= '0';
            WHEN ADDR_LFR_MANAGMENT_DAC_DATA_IN =>
              DATA_IN <= apbi.pwdata(datawidth-1 DOWNTO 0);
              WEN     <= '0';
              
            WHEN OTHERS =>
              NULL;
          END CASE;
        ELSE
          IF r.ctrl = '1' THEN
            r.ctrl <= '0';
          END IF;
          IF r.soft_reset = '1' THEN
            r.soft_reset <= '0';
          END IF;
        END IF;
        
      END IF;

    END IF;
  END PROCESS;

  apbo.pirq    <= (OTHERS => '0');
  apbo.prdata  <= Rdata;
  apbo.pconfig <= pconfig;
  apbo.pindex  <= pindex;

  -----------------------------------------------------------------------------
  -- IN
  coarse_time    <= r.coarse_time;
  fine_time      <= r.fine_time;
  coarsetime_reg <= r.coarse_time_load;
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- OUT
  r.coarse_time <= coarse_time_s;
  r.fine_time   <= fine_time_s;
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  tick <= grspw_tick OR soft_tick;

  SYNC_VALID_BIT_1 : SYNC_VALID_BIT
    GENERIC MAP (
      NB_FF_OF_SYNC => 2)
    PORT MAP (
      clk_in  => clk25MHz,
      rstn_in    => resetn_25MHz,
      clk_out => clk24_576MHz,
      rstn_out => resetn_24_576MHz,
      sin     => tick,
      sout    => new_timecode);

  SYNC_VALID_BIT_2 : SYNC_VALID_BIT
    GENERIC MAP (
      NB_FF_OF_SYNC => 2)
    PORT MAP (
      clk_in  => clk25MHz,
      rstn_in    => resetn_25MHz,
      clk_out => clk24_576MHz,
      rstn_out => resetn_24_576MHz,
      sin     => coarsetime_reg_updated,
      sout    => new_coarsetime);

  SYNC_VALID_BIT_3 : SYNC_VALID_BIT
    GENERIC MAP (
      NB_FF_OF_SYNC => 2)
    PORT MAP (
      clk_in  => clk25MHz,
      rstn_in    => resetn_25MHz,
      clk_out => clk24_576MHz,
      rstn_out => resetn_24_576MHz,
      sin     => soft_reset,
      sout    => soft_reset_sync);

  -----------------------------------------------------------------------------
  --SYNC_FF_1 : SYNC_FF
  --  GENERIC MAP (
  --    NB_FF_OF_SYNC => 2)
  --  PORT MAP (
  --    clk    => clk25MHz,
  --    rstn   => resetn,
  --    A      => fine_time_new_49,
  --    A_sync => fine_time_new_temp);

  --lpp_front_detection_1 : lpp_front_detection
  --  PORT MAP (
  --    clk  => clk25MHz,
  --    rstn => resetn,
  --    sin  => fine_time_new_temp,
  --    sout => fine_time_new);

  --SYNC_VALID_BIT_4 : SYNC_VALID_BIT
  --  GENERIC MAP (
  --    NB_FF_OF_SYNC => 2)
  --  PORT MAP (
  --    clk_in  => clk24_576MHz,
  --    clk_out => clk25MHz,
  --    rstn    => resetn,
  --    sin     => coarse_time_new_49,
  --    sout    => coarse_time_new);

  time_new_49 <= coarse_time_new_49 OR fine_time_new_49;

  SYNC_VALID_BIT_4 : SYNC_VALID_BIT
    GENERIC MAP (
      NB_FF_OF_SYNC => 2)
    PORT MAP (
      clk_in  => clk24_576MHz,
      rstn_in    => resetn_24_576MHz,
      clk_out => clk25MHz,
      rstn_out => resetn_25MHz,
      sin     => time_new_49,
      sout    => time_new);



  PROCESS (clk25MHz, resetn_25MHz)
  BEGIN  -- PROCESS
    IF resetn_25MHz = '0' THEN                -- asynchronous reset (active low)
      fine_time_s   <= (OTHERS => '0');
      coarse_time_s <= (OTHERS => '0');
    ELSIF clk25MHz'EVENT AND clk25MHz = '1' THEN  -- rising clock edge
      IF time_new = '1' THEN
        fine_time_s   <= fine_time_49;
        coarse_time_s <= coarse_time_49;
      END IF;
    END IF;
  END PROCESS;


  rstn_LFR_TM <= '0' WHEN resetn_24_576MHz = '0' ELSE
                 '0' WHEN soft_reset_sync = '1' ELSE
                 '1';


  -----------------------------------------------------------------------------
  -- LFR_TIME_MANAGMENT
  -----------------------------------------------------------------------------
  lfr_time_management_1 : lfr_time_management
    GENERIC MAP (
      FIRST_DIVISION   => FIRST_DIVISION,
      NB_SECOND_DESYNC => NB_SECOND_DESYNC)
    PORT MAP (
      clk  => clk24_576MHz,
      rstn => rstn_LFR_TM,

      tick           => new_timecode,
      new_coarsetime => new_coarsetime,
      coarsetime_reg => coarsetime_reg(30 DOWNTO 0),

      fine_time       => fine_time_49,
      fine_time_new   => fine_time_new_49,
      coarse_time     => coarse_time_49,
      coarse_time_new => coarse_time_new_49);

  -----------------------------------------------------------------------------
  -- HK
  -----------------------------------------------------------------------------

  PROCESS (clk25MHz, resetn_25MHz)
    CONSTANT BIT_FREQUENCY_UPDATE : INTEGER := 14;  -- freq = 2^(16-BIT)
                          -- for each HK, the update frequency is freq/3
                          --  
                          -- for 14, the update frequency is
                          -- 4Hz and update for each
                          -- HK is 1.33Hz
  BEGIN  -- PROCESS
    IF resetn_25MHz = '0' THEN                -- asynchronous reset (active low)

      r.HK_temp_0 <= (OTHERS => '0');
      r.HK_temp_1 <= (OTHERS => '0');
      r.HK_temp_2 <= (OTHERS => '0');

      HK_sel_s <= "00";

      previous_fine_time_bit <= '0';
      
    ELSIF clk25MHz'EVENT AND clk25MHz = '1' THEN  -- rising clock edge

      IF HK_val = '1' THEN
        IF previous_fine_time_bit = NOT(fine_time_s(BIT_FREQUENCY_UPDATE)) THEN
          previous_fine_time_bit <= fine_time_s(BIT_FREQUENCY_UPDATE);
          CASE HK_sel_s IS
            WHEN "00" =>
              r.HK_temp_0 <= HK_sample;
              HK_sel_s    <= "01";
            WHEN "01" =>
              r.HK_temp_1 <= HK_sample;
              HK_sel_s    <= "10";
            WHEN "10" =>
              r.HK_temp_2 <= HK_sample;
              HK_sel_s    <= "00";
            WHEN OTHERS => NULL;
          END CASE;
        END IF;
      END IF;
      
    END IF;
  END PROCESS;

  HK_sel <= HK_sel_s;

  -----------------------------------------------------------------------------
  -- DAC
  -----------------------------------------------------------------------------
  cal : lfr_cal_driver
    GENERIC MAP(
      tech      => tech,
      PRESZ     => PRESZ,
      CPTSZ     => CPTSZ,
      datawidth => datawidth,
      abits     => abits
      )
    PORT MAP(
      clk  => clk25MHz,
      rstn => resetn_25MHz,

      pre           => pre,
      N             => N,
      Reload        => Reload,
      DATA_IN       => DATA_IN,
      WEN           => WEN,
      LOAD_ADDRESSN => LOAD_ADDRESSN,
      ADDRESS_IN    => ADDRESS_IN,
      ADDRESS_OUT   => ADDRESS_OUT,
      INTERLEAVED   => INTERLEAVED,
      DAC_CFG       => DAC_CFG,

      SYNC   => DAC_SYNC,
      DOUT   => DAC_SDO,
      SCLK   => DAC_SCK,
      SMPCLK => OPEN                    --DAC_SMPCLK
      );

  DAC_CAL_EN <= DAC_CAL_EN_s;
END Behavioral;