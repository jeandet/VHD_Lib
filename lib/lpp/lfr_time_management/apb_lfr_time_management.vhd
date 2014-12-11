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
USE lpp.lpp_lfr_time_management.ALL;
USE lpp.lpp_lfr_time_management_apbreg_pkg.ALL;


ENTITY apb_lfr_time_management IS

  GENERIC(
    pindex         : INTEGER := 0;        --! APB slave index
    paddr          : INTEGER := 0;        --! ADDR field of the APB BAR
    pmask          : INTEGER := 16#fff#;   --! MASK field of the APB BAR
    FIRST_DIVISION   : INTEGER := 374;
    NB_SECOND_DESYNC : INTEGER := 60
    );

  PORT (
    clk25MHz     : IN STD_LOGIC;        --! Clock
    clk24_576MHz : IN STD_LOGIC;        --! secondary clock
    resetn       : IN STD_LOGIC;        --! Reset

    grspw_tick : IN STD_LOGIC;  --! grspw signal asserted when a valid time-code is received

    apbi : IN  apb_slv_in_type;         --! APB slave input signals
    apbo : OUT apb_slv_out_type;        --! APB slave output signals

    coarse_time : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);  --! coarse time
    fine_time   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);   --! fine TIME
    ---------------------------------------------------------------------------
    LFR_soft_rstn : OUT STD_LOGIC
    );

END apb_lfr_time_management;

ARCHITECTURE Behavioral OF apb_lfr_time_management IS

  CONSTANT REVISION : INTEGER := 1;
  CONSTANT pconfig : apb_config_type := (
    0 => ahb_device_reg (VENDOR_LPP, 14, 0, REVISION, 0),
    1 => apb_iobar(paddr, pmask)
    );

  TYPE apb_lfr_time_management_Reg IS RECORD
    ctrl             : STD_LOGIC;
    soft_reset       : STD_LOGIC;
    coarse_time_load : STD_LOGIC_VECTOR(30 DOWNTO 0);
    coarse_time      : STD_LOGIC_VECTOR(31 DOWNTO 0);
    fine_time        : STD_LOGIC_VECTOR(15 DOWNTO 0);
    LFR_soft_reset   : STD_LOGIC;
  END RECORD;
  SIGNAL r                   : apb_lfr_time_management_Reg;
  
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
  SIGNAL fine_time_new_49   : STD_LOGIC;
  SIGNAL fine_time_49       : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL fine_time_s        : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL tick               : STD_LOGIC;
  SIGNAL new_timecode       : STD_LOGIC;
  SIGNAL new_coarsetime     : STD_LOGIC;
  
  SIGNAL time_new_49 : STD_LOGIC;
  SIGNAL time_new    : STD_LOGIC;

  -----------------------------------------------------------------------------
  SIGNAL force_reset          : STD_LOGIC;
  SIGNAL previous_force_reset : STD_LOGIC;
  SIGNAL soft_reset           : STD_LOGIC;  
  SIGNAL soft_reset_sync      : STD_LOGIC;  
  -----------------------------------------------------------------------------

  SIGNAL rstn_LFR_TM : STD_LOGIC;
  
BEGIN

  LFR_soft_rstn <= NOT r.LFR_soft_reset;
  
  PROCESS(resetn, clk25MHz)
  BEGIN

    IF resetn = '0' THEN
      Rdata               <= (OTHERS => '0');
      r.coarse_time_load  <= (OTHERS => '0');
      r.soft_reset              <= '0';
      r.ctrl              <= '0';
      r.LFR_soft_reset    <= '1';
      
      force_tick          <= '0';
      previous_force_tick <= '0';
      soft_tick           <= '0';

      coarsetime_reg_updated <= '0';

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

--APB Write OP
      IF (apbi.psel(pindex) AND apbi.penable AND apbi.pwrite) = '1' THEN
        CASE apbi.paddr(7 DOWNTO 2) IS
          WHEN ADDR_LFR_TM_CONTROL =>
            r.ctrl              <= apbi.pwdata(0);
            r.soft_reset        <= apbi.pwdata(1);
            r.LFR_soft_reset    <= apbi.pwdata(2);
          WHEN ADDR_LFR_TM_TIME_LOAD =>
            r.coarse_time_load     <= apbi.pwdata(30 DOWNTO 0);
            coarsetime_reg_updated <= '1';
          WHEN OTHERS =>
            NULL;
        END CASE;
      ELSE
        IF r.ctrl = '1' THEN
          r.ctrl <= '0';
        END if;
        IF r.soft_reset = '1' THEN
          r.soft_reset <= '0';
        END if;
      END IF;

--APB READ OP
      IF (apbi.psel(pindex) AND (NOT apbi.pwrite)) = '1' THEN
        CASE apbi.paddr(7 DOWNTO 2) IS
          WHEN ADDR_LFR_TM_CONTROL =>
            Rdata(0)            <= r.ctrl;
            Rdata(1)            <= r.soft_reset;
            Rdata(2)            <= r.LFR_soft_reset;
            Rdata(31 DOWNTO 3)  <= (others => '0');
          WHEN ADDR_LFR_TM_TIME_LOAD =>
            Rdata(30 DOWNTO 0)  <= r.coarse_time_load(30 DOWNTO 0);
          WHEN ADDR_LFR_TM_TIME_COARSE =>
            Rdata(31 DOWNTO 0)  <= r.coarse_time(31 DOWNTO 0);
          WHEN ADDR_LFR_TM_TIME_FINE =>
            Rdata(31 DOWNTO 16) <= (OTHERS => '0');
            Rdata(15 DOWNTO 0)  <= r.fine_time(15 DOWNTO 0);
          WHEN OTHERS =>
            Rdata(31 DOWNTO 0)  <= (others => '0');
        END CASE;
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
  r.coarse_time  <= coarse_time_s;
  r.fine_time    <= fine_time_s;
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  tick <= grspw_tick OR soft_tick;

  SYNC_VALID_BIT_1 : SYNC_VALID_BIT
    GENERIC MAP (
      NB_FF_OF_SYNC => 2)
    PORT MAP (
      clk_in  => clk25MHz,
      clk_out => clk24_576MHz,
      rstn    => resetn,
      sin     => tick,
      sout    => new_timecode);

  SYNC_VALID_BIT_2 : SYNC_VALID_BIT
    GENERIC MAP (
      NB_FF_OF_SYNC => 2)
    PORT MAP (
      clk_in  => clk25MHz,
      clk_out => clk24_576MHz,
      rstn    => resetn,
      sin     => coarsetime_reg_updated,
      sout    => new_coarsetime);
  
  SYNC_VALID_BIT_3 : SYNC_VALID_BIT
    GENERIC MAP (
      NB_FF_OF_SYNC => 2)
    PORT MAP (
      clk_in  => clk25MHz,
      clk_out => clk24_576MHz,
      rstn    => resetn,
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
     clk_out => clk25MHz,
     rstn    => resetn,
     sin     => time_new_49,
     sout    => time_new);
 

  
  PROCESS (clk25MHz, resetn)
  BEGIN  -- PROCESS
    IF resetn = '0' THEN                -- asynchronous reset (active low)
      fine_time_s   <= (OTHERS => '0');
      coarse_time_s <= (OTHERS => '0');
    ELSIF clk25MHz'EVENT AND clk25MHz = '1' THEN  -- rising clock edge
      IF time_new = '1' THEN
        fine_time_s   <= fine_time_49;
        coarse_time_s <= coarse_time_49;
      END IF;
    END IF;
  END PROCESS;


  rstn_LFR_TM <= '0' WHEN resetn = '0' ELSE
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

END Behavioral;
