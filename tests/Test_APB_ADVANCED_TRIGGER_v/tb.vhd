
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.std_logic_signed.ALL;
USE IEEE.MATH_real.ALL;

LIBRARY techmap;
USE techmap.gencomp.ALL;

library gaisler;
use gaisler.libdcom.all;
use gaisler.sim.all;
use gaisler.uart.all;

library grlib;
use grlib.stdlib.all;
use grlib.amba.all;
use grlib.devices.all;

LIBRARY std;
USE std.textio.ALL;

LIBRARY lpp;
USE lpp.general_purpose.ALL;
USE lpp.lpp_amba.all;

ENTITY testbench IS

END;

ARCHITECTURE behav OF testbench IS

  SIGNAL TSTAMP    : INTEGER   := 0;
  SIGNAL clk       : STD_LOGIC := '0';
  SIGNAL rstn      : STD_LOGIC;

--AMBA bus standard interface signals--
  signal apbi  : apb_slv_in_type;
  signal apbo  : apb_slv_out_vector := (others => apb_none);
  signal ahbsi : ahb_slv_in_type;
  signal ahbso : ahb_slv_out_vector := (others => ahbs_none);
  signal ahbmi : ahb_mst_in_type;
  signal ahbmo : ahb_mst_out_vector := (others => ahbm_none);


  signal dui : uart_in_type;
  signal duo : uart_out_type;
  signal dsutx : STD_LOGIC;
  signal dsurx : STD_LOGIC;

  SIGNAL end_of_simu : STD_LOGIC := '0';

  constant lresp : boolean := false;

  SIGNAL SPW_Tickout : std_logic:='0';
  SIGNAL CoarseTime  : STD_LOGIC_VECTOR(31 DOWNTO 0):=(others=>'0');
  SIGNAL FineTime    : STD_LOGIC_VECTOR(15 DOWNTO 0):=(others=>'0');
  SIGNAL Trigger     : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN

  -----------------------------------------------------------------------------
  -- CLOCK and RESET
  -----------------------------------------------------------------------------
  PROCESS
  BEGIN  -- PROCESS
    WAIT UNTIL clk = '1';
    rstn <= '0';
    WAIT UNTIL clk = '1';
    WAIT UNTIL clk = '1';
    WAIT UNTIL clk = '1';
    rstn <= '1';
    WAIT UNTIL end_of_simu = '1';
    WAIT UNTIL clk = '1';
    assert false report "end of test" severity note;
    --  Wait forever; this will finish the simulation.
    wait;
  END PROCESS;
  -----------------------------------------------------------------------------

  clk_25M_gen:PROCESS
  BEGIN
    IF end_of_simu /= '1' THEN
      clk <= NOT clk;
      TSTAMP <= TSTAMP+20;
      WAIT FOR 20 ns;
    ELSE
      assert false report "end of test" severity note;
      WAIT;
    END IF;
  END PROCESS;

-----------------------------------------------------------------------------
-- CoarseTime and FineTime
-----------------------------------------------------------------------------

SpwFineTime:PROCESS
BEGIN
    IF end_of_simu /= '1' THEN
      IF SPW_Tickout = '1' then
        FineTime <= (others=>'0');
      ELSE
        FineTime <= std_logic_vector(UNSIGNED(FineTime) + 1);
      END IF;
      WAIT FOR 15 us;
    ELSE
      assert false report "end of test" severity note;
      WAIT;
    END IF;
END PROCESS;

SpwCoarseTime:PROCESS
BEGIN
    IF end_of_simu /= '1' THEN
      wait until SPW_Tickout = '1';
      CoarseTime <= std_logic_vector(UNSIGNED(CoarseTime) + 1);
    ELSE
      assert false report "end of test" severity note;
      WAIT;
    END IF;
END PROCESS;

SPWTickout:PROCESS
BEGIN
    IF end_of_simu /= '1' THEN
      wait for (1000 ms - 20 ns);
      SPW_Tickout <= '1';
      wait for 20 ns;
      SPW_Tickout <= '0';
    ELSE
      assert false report "end of test" severity note;
      WAIT;
    END IF;
END PROCESS;



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
 dsutx <= duo.txd;
 dui.rxd <= dsurx;

----------------------------------------------------------------------
---  APB Bridge ------------------------------------------------------
----------------------------------------------------------------------

  apb0 : apbctrl				-- AHB/APB bridge
  generic map (hindex => 0, haddr => 16#800#)
  port map (rstn, clk, ahbsi, ahbso(0), apbi, apbo );


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



  dsucom : process
    variable w32 : std_logic_vector(31 downto 0);
    constant txp : time := 160 * 1 ns;
    procedure writeReg(signal dsutx : out std_logic;  address : integer; value : integer) is
    begin
        txc(dsutx, 16#c0#, txp); --control byte
        txa(dsutx, (address / (256*256*256)) , (address / (256*256)), (address / (256)),  address, txp); --adress
        txa(dsutx, (value / (256*256*256)) , (value / (256*256)), (value / (256)), value, txp); --write data
    end;

    procedure readReg(signal dsurx : in std_logic; signal dsutx : out std_logic;  address : integer; value: out std_logic_vector) is

    begin
        txc(dsutx, 16#a0#, txp); --control byte
        txa(dsutx, (address / (256*256*256)) , (address / (256*256)), (address / (256)), address, txp); --adress
        rxi(dsurx, value, txp, lresp); --write data
    end;

    procedure dsucfg(signal dsurx : in std_logic; signal dsutx : out std_logic) is
    variable c8  : std_logic_vector(7 downto 0);
    begin
    dsutx <= '1';
    wait for 5000 ns;
    txc(dsutx, 16#55#, txp);

    writeReg(dsutx,16#8000100#,16#00#);

    end;

  begin

    dsucfg(dsutx, dsurx);

    wait for 1000 ms;
    end_of_simu <= '1';
    wait;
 end process;

  all_apbo : FOR I IN 0 TO 15 GENERATE
    apbo_not_used : IF I /= 1 AND I /= 0 GENERATE
      apbo(I) <= apb_none;
    END GENERATE apbo_not_used;
  END GENERATE all_apbo;

END;
