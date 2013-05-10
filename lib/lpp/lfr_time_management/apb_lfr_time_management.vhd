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
USE lpp.lpp_lfr_time_management.ALL;

ENTITY apb_lfr_time_management IS

  GENERIC(
    pindex      : INTEGER := 0;         --! APB slave index
    paddr       : INTEGER := 0;         --! ADDR field of the APB BAR
    pmask       : INTEGER := 16#fff#;   --! MASK field of the APB BAR
    pirq        : INTEGER := 0;         --! 2 consecutive IRQ lines are used
    masterclk   : INTEGER := 25000000;  --! master clock in Hz
    timeclk    : INTEGER := 49152000;  --! other clock in Hz
    finetimeclk : INTEGER := 65536  --! divided clock used for the fine time counter
    );

  PORT (
    clk25MHz     : IN  STD_LOGIC;       --! Clock
    clk49_152MHz : IN  STD_LOGIC;       --! secondary clock
    resetn       : IN  STD_LOGIC;       --! Reset
    grspw_tick   : IN  STD_LOGIC;  --! grspw signal asserted when a valid time-code is received
    apbi         : IN  apb_slv_in_type;   --! APB slave input signals
    apbo         : OUT apb_slv_out_type;  --! APB slave output signals
    coarse_time  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);  --! coarse time
    fine_time    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)   --! fine time
    );

END apb_lfr_time_management;

ARCHITECTURE Behavioral OF apb_lfr_time_management IS

  CONSTANT REVISION : INTEGER := 1;

--! the following types are defined in the grlib amba package
--! subtype amba_config_word is std_logic_vector(31 downto 0);
--! type apb_config_type is array (0 to NAPBCFG-1) of amba_config_word;
  CONSTANT pconfig : apb_config_type := (
--!  0 => ahb_device_reg (VENDOR_LPP, LPP_ROTARY, 0, REVISION, 0),
    0 => ahb_device_reg (VENDOR_LPP, 0, 0, REVISION, pirq),
    1 => apb_iobar(paddr, pmask));

  TYPE apb_lfr_time_management_Reg IS RECORD
    ctrl             : STD_LOGIC_VECTOR(31 DOWNTO 0);
    coarse_time_load : STD_LOGIC_VECTOR(31 DOWNTO 0);
    coarse_time      : STD_LOGIC_VECTOR(31 DOWNTO 0);
    fine_time        : STD_LOGIC_VECTOR(31 DOWNTO 0);
    next_commutation : STD_LOGIC_VECTOR(31 DOWNTO 0);
  END RECORD;

  SIGNAL r                      : apb_lfr_time_management_Reg;
  SIGNAL Rdata                  : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL force_tick             : STD_LOGIC;
  SIGNAL previous_force_tick    : STD_LOGIC;
  SIGNAL soft_tick              : STD_LOGIC;
  SIGNAL reset_next_commutation : STD_LOGIC;
  
  SIGNAL irq1 : STD_LOGIC;
  SIGNAL irq2 : STD_LOGIC;

BEGIN

  lfrtimemanagement0 : lfr_time_management
    GENERIC MAP(
      masterclk => masterclk,
      timeclk => timeclk,
      finetimeclk => finetimeclk,
      nb_clk_div_ticks => 1)
    PORT MAP(
      master_clock      => clk25MHz, 
      time_clock => clk49_152MHz, 
      resetn => resetn,
      grspw_tick       => grspw_tick, 
      soft_tick => soft_tick,
      coarse_time_load => r.coarse_time_load, 
      coarse_time => r.coarse_time, 
      fine_time => r.fine_time,
      next_commutation => r.next_commutation, 
      reset_next_commutation => reset_next_commutation,
      irq1             => irq1,--apbo.pirq(pirq), 
      irq2 => irq2);--apbo.pirq(pirq+1));  

  	--apbo.pirq <= (OTHERS => '0');

  all_irq_gen: FOR I IN 15 DOWNTO 0 GENERATE
    irq1_gen: IF I = pirq GENERATE
      apbo.pirq(I) <= irq1;
    END GENERATE irq1_gen;
    irq2_gen: IF I = pirq+1 GENERATE
      apbo.pirq(I) <= irq2;
    END GENERATE irq2_gen;
    others_irq: IF (I < pirq) OR (I > (pirq + 1)) GENERATE
      apbo.pirq(I) <= '0';
    END GENERATE others_irq;
  END GENERATE all_irq_gen;
  
  --all_irq_sig: FOR I IN 31 DOWNTO 0 GENERATE
  --END GENERATE all_irq_sig;
  
  PROCESS(resetn, clk25MHz, reset_next_commutation)
  BEGIN

    IF resetn = '0' THEN
      Rdata <=  (OTHERS => '0');
      r.coarse_time_load  <= x"80000000";
      r.ctrl              <= x"00000000";
      r.next_commutation  <= x"ffffffff";
      force_tick          <= '0';
      previous_force_tick <= '0';
      soft_tick           <= '0';

    ELSIF reset_next_commutation = '1' THEN
      r.next_commutation <= x"ffffffff";

    ELSIF clk25MHz'EVENT AND clk25MHz = '1' THEN

      previous_force_tick <= force_tick;
      force_tick          <= r.ctrl(0);
      IF (previous_force_tick = '0') AND (force_tick = '1') THEN
        soft_tick <= '1';
      ELSE
        soft_tick <= '0';
      END IF;

--APB Write OP
      IF (apbi.psel(pindex) AND apbi.penable AND apbi.pwrite) = '1' THEN
        CASE apbi.paddr(7 DOWNTO 2) IS
          WHEN "000000" =>
            r.ctrl <= apbi.pwdata(31 DOWNTO 0);
          WHEN "000001" =>
            r.coarse_time_load <= apbi.pwdata(31 DOWNTO 0);
          WHEN "000100" =>
            r.next_commutation <= apbi.pwdata(31 DOWNTO 0);
          WHEN OTHERS =>
            r.coarse_time_load <= x"00000000";
        END CASE;
      ELSIF r.ctrl(0) = '1' THEN
        r.ctrl(0) <= '0';
      END IF;

--APB READ OP
      IF (apbi.psel(pindex) AND (NOT apbi.pwrite)) = '1' THEN
        CASE apbi.paddr(7 DOWNTO 2) IS
          WHEN "000000" =>
            Rdata(31 DOWNTO 24) <= r.ctrl(31 DOWNTO 24);
            Rdata(23 DOWNTO 16) <= r.ctrl(23 DOWNTO 16);
            Rdata(15 DOWNTO 8)  <= r.ctrl(15 DOWNTO 8);
            Rdata(7 DOWNTO 0)   <= r.ctrl(7 DOWNTO 0);
          WHEN "000001" =>
            Rdata(31 DOWNTO 24) <= r.coarse_time_load(31 DOWNTO 24);
            Rdata(23 DOWNTO 16) <= r.coarse_time_load(23 DOWNTO 16);
            Rdata(15 DOWNTO 8)  <= r.coarse_time_load(15 DOWNTO 8);
            Rdata(7 DOWNTO 0)   <= r.coarse_time_load(7 DOWNTO 0);
          WHEN "000010" =>
            Rdata(31 DOWNTO 24) <= r.coarse_time(31 DOWNTO 24);
            Rdata(23 DOWNTO 16) <= r.coarse_time(23 DOWNTO 16);
            Rdata(15 DOWNTO 8)  <= r.coarse_time(15 DOWNTO 8);
            Rdata(7 DOWNTO 0)   <= r.coarse_time(7 DOWNTO 0);
          WHEN "000011" =>
            Rdata(31 DOWNTO 24) <= r.fine_time(31 DOWNTO 24);
            Rdata(23 DOWNTO 16) <= r.fine_time(23 DOWNTO 16);
            Rdata(15 DOWNTO 8)  <= r.fine_time(15 DOWNTO 8);
            Rdata(7 DOWNTO 0)   <= r.fine_time(7 DOWNTO 0);
          WHEN "000100" =>
            Rdata(31 DOWNTO 24) <= r.next_commutation(31 DOWNTO 24);
            Rdata(23 DOWNTO 16) <= r.next_commutation(23 DOWNTO 16);
            Rdata(15 DOWNTO 8)  <= r.next_commutation(15 DOWNTO 8);
            Rdata(7 DOWNTO 0)   <= r.next_commutation(7 DOWNTO 0);
          WHEN OTHERS =>
            Rdata(31 DOWNTO 0) <= x"00000000";
        END CASE;
      END IF;

    END IF;
  END PROCESS;

  apbo.prdata  <= Rdata ;--WHEN apbi.penable = '1';
  coarse_time  <= r.coarse_time;
  fine_time    <= r.fine_time;
  apbo.pconfig <= pconfig;
  apbo.pindex  <= pindex;

END Behavioral;
