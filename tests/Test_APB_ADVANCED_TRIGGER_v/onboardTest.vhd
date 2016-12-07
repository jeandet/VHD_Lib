
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.std_logic_signed.ALL;

LIBRARY techmap;
USE techmap.gencomp.ALL;
use techmap.allclkgen.all;

library gaisler;
use gaisler.uart.all;
use gaisler.misc.all;

library grlib;
use grlib.stdlib.all;
use grlib.amba.all;
use grlib.devices.all;

LIBRARY std;
USE std.textio.ALL;

LIBRARY lpp;
USE lpp.general_purpose.ALL;
USE lpp.lpp_amba.all;
USE lpp.lpp_lfr_management.ALL;

ENTITY testbench IS
 port (
    CLK50  : in std_logic;
    LEDS   : inout std_logic_vector(7 downto 0);
    SW     : in std_logic_vector(4 downto 1);
    Trigger     : out STD_LOGIC_VECTOR(3 DOWNTO 0);
    uart_txd  	: out std_logic;		-- DSU tx data
    uart_rxd  	: in  std_logic		-- DSU rx data
    );
END;

ARCHITECTURE behav OF testbench IS

  SIGNAL TSTAMP    : INTEGER   := 0;
  SIGNAL clk_50    : STD_LOGIC := '0';
  SIGNAL clk       : STD_LOGIC := '0';
  SIGNAL rstn      : STD_LOGIC;
  SIGNAL rst       : STD_LOGIC;
  SIGNAL resetn    : STD_LOGIC;
  SIGNAL rstraw    : STD_LOGIC;

--AMBA bus standard interface signals--
  signal apbi  : apb_slv_in_type;
  signal apbo  : apb_slv_out_vector := (others => apb_none);
  signal ahbsi : ahb_slv_in_type;
  signal ahbso : ahb_slv_out_vector := (others => ahbs_none);
  signal ahbmi : ahb_mst_in_type;
  signal ahbmo : ahb_mst_out_vector := (others => ahbm_none);


  signal dui : uart_in_type;
  signal duo : uart_out_type;

  SIGNAL SPW_Tickout : std_logic:='0';
  SIGNAL CoarseTime  : STD_LOGIC_VECTOR(31 DOWNTO 0):=(others=>'0');
  SIGNAL FineTime    : STD_LOGIC_VECTOR(15 DOWNTO 0):=(others=>'0');
  SIGNAL SubFineTime    : integer range 0 to 49999999:=0;

BEGIN


  clk_25:PROCESS(clk_50)
  BEGIN
  IF clk_50'EVENT AND clk_50 = '1' THEN
    clk <= not clk;
  END IF;
  END PROCESS;

  resetn <= SW(1);
  LEDS <= CoarseTime(7 downto 0);

  uart_txd <= duo.txd;
  dui.rxd <= uart_rxd;

  clk_pad : clkpad generic map (tech => spartan6) port map (CLK50, clk_50);

  resetn_pad : inpad generic map (tech => spartan6) port map (resetn, rst);
  rst0 : rstgen			-- reset generator (reset is active LOW)
    port map (rst, clk, '1', rstn, rstraw);
----------------------------------------------------------------------
---  AHB CONTROLLER --------------------------------------------------
----------------------------------------------------------------------

  ahb0 : ahbctrl 		-- AHB arbiter/multiplexer
  generic map (defmast => 0, split => 1,
	rrobin => 1, ioaddr => 16#FFF#,
	nahbm => 1, nahbs => 1)

  port map (rstn, clk, ahbmi, ahbmo, ahbsi, ahbso);


  dcom0: ahbuart		-- Debug UART
    generic map (hindex => 0, pindex => 0, paddr => 0)
    port map (rstn, clk, dui, duo, apbi, apbo(0), ahbmi, ahbmo(0));

----------------------------------------------------------------------
---  APB Bridge ------------------------------------------------------
----------------------------------------------------------------------

  apb0 : apbctrl				-- AHB/APB bridge
  generic map (hindex => 0, haddr => 16#800#)
  port map (rstn, clk, ahbsi, ahbso(0), apbi, apbo );


spw_time:PROCESS(clk,rstn)
BEGIN
IF rstn = '0' THEN
  SPW_Tickout <= '0';
  SubFineTime <= 0;
ELSIF clk'EVENT AND clk = '1' THEN
  if SubFineTime = 24999999 then
    SubFineTime <= 0;
    SPW_Tickout <= '1';
  else
    SPW_Tickout <= '0';
    SubFineTime <= SubFineTime + 1;
  end if;
END IF;
END PROCESS;


----------------------------------------------------------------------
---  APB_ADVANCED_TRIGGER_v -> Device Under Test ---------------------
----------------------------------------------------------------------

DUT: APB_ADVANCED_TRIGGER_v
  generic map(
    pindex   => 1,
    paddr    => 1,
    count    => 4
  )
  port map(
    rstn   => rstn,
    clk    => clk,
    apbi   => apbi,
    apbo   => apbo(1),

    SPW_Tickout => SPW_Tickout,
    CoarseTime  => CoarseTime,
    FineTime    => FineTime,

    Trigger     => Trigger
    );

-------------------------------------------------------------------------------
-- APB_LFR_MANAGEMENT ---------------------------------------------------------
-------------------------------------------------------------------------------
  apb_lfr_management_1 : apb_lfr_management
    GENERIC MAP (
      tech             => spartan6,
      pindex           => 2,
      paddr            => 2,
      pmask            => 16#fff#,
      NB_SECOND_DESYNC => 60)  -- 60 secondes of desynchronization before CoarseTime's MSB is Set
    PORT MAP (
      clk25MHz         => clk,
      resetn_25MHz     => rstn,
      grspw_tick       => SPW_Tickout,
      apbi             => apbi,
      apbo             => apbo(2),
      HK_sample        => (others=>'0'),
      HK_val           => '0',
      HK_sel           => open,
      DAC_SDO          => OPEN,
      DAC_SCK          => OPEN,
      DAC_SYNC         => OPEN,
      DAC_CAL_EN       => OPEN,
      coarse_time      => CoarseTime,
      fine_time        => FineTime,
      LFR_soft_rstn    => open
      );


END;
