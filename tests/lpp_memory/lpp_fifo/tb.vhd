
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
USE IEEE.std_logic_signed.ALL;
USE IEEE.MATH_real.ALL;

LIBRARY techmap;
USE techmap.gencomp.ALL;

library std;
use std.textio.all;

LIBRARY lpp;
USE lpp.general_purpose.ALL;
USE lpp.data_type_pkg.ALL;
USE lpp.lpp_sim_pkg.ALL;
USE lpp.lpp_memory.ALL;
USE lpp.iir_filter.ALL;

ENTITY testbench IS
GENERIC(
    tech          : INTEGER := artix7; --axcel,0
    Mem_use       : INTEGER := use_CEL; --use_RAM,use_CEL
    CLK_PERIOD_ns : INTEGER := 10
);
END;

ARCHITECTURE behav OF testbench IS

  CONSTANT EMPTY_THRESHOLD_LIMIT : INTEGER               := 16;
  CONSTANT FULL_THRESHOLD_LIMIT  : INTEGER               := 5;
  CONSTANT DataSz                : INTEGER RANGE 1 TO 32 := 8;
  CONSTANT AddrSz                : INTEGER RANGE 2 TO 12 := 8;

  SIGNAL TSTAMP         : INTEGER:=0;
  SIGNAL clk            : STD_LOGIC := '0';
  SIGNAL rstn           : STD_LOGIC := '0';

  SIGNAL end_of_simu : STD_LOGIC := '0';


  SIGNAL reUse : STD_LOGIC := '0';
  SIGNAL run   : STD_LOGIC := '0';

    --IN
  SIGNAL ren   : STD_LOGIC := '1';
  SIGNAL rdata : STD_LOGIC_VECTOR(DataSz-1 DOWNTO 0);

    --OUT
  SIGNAL  wen   : STD_LOGIC := '1';
  SIGNAL  wdata : STD_LOGIC_VECTOR(DataSz-1 DOWNTO 0) := (others => '1');

  SIGNAL  empty           : STD_LOGIC;
  SIGNAL  full            : STD_LOGIC;
  SIGNAL  full_almost     : STD_LOGIC;
  SIGNAL  empty_threshold : STD_LOGIC;
  SIGNAL  full_threshold  : STD_LOGIC;


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
    WAIT FOR 10 ps;
    assert false report "end of test" severity note;
    --  Wait forever; this will finish the simulation.
    wait;
  END PROCESS;
  -----------------------------------------------------------------------------


  clk_gen:PROCESS
  BEGIN
    IF end_of_simu /= '1' THEN
      clk <= NOT clk;
      TSTAMP <= TSTAMP+CLK_PERIOD_ns;
      WAIT FOR CLK_PERIOD_ns * 1 ns;
    ELSE
      WAIT FOR 10 ps;
      assert false report "end of test" severity note;
      WAIT;
    END IF;
  END PROCESS;


  -----------------------------------------------------------------------------
  -- LPP_FIFO DUT
  -----------------------------------------------------------------------------

  DUT: lpp_fifo
  GENERIC map(
    tech                  => tech,
    Mem_use               => Mem_use,
    EMPTY_THRESHOLD_LIMIT => EMPTY_THRESHOLD_LIMIT,
    FULL_THRESHOLD_LIMIT  => FULL_THRESHOLD_LIMIT,
    DataSz                => DataSz,
    AddrSz                => AddrSz
    )
  PORT MAP(
      clk              => clk,
      rstn             => rstn,
    --
    reUse => reUse,
    run   => run,

    --IN
    ren   => ren,
    rdata => rdata,
    --OUT
    wen   => wen,
    wdata => wdata,

    empty           => empty,
    full            => full,
    full_almost     => full_almost,
    empty_threshold => empty_threshold,
    full_threshold  => full_threshold
    );
  -----------------------------------------------------------------------------

    process

    begin
    wait until rstn = '1';
    run <= '1';
    WAIT_N_CYCLES(clk, 10);
    if empty = '0' then
        wait until empty = '1';
    end if;
    while full = '0' LOOP
        NEGATIVE_SYNCHRONOUS_PULSE(clk, wen);
        wait until rising_edge(clk);
        wdata <= std_logic_vector(UNSIGNED(wdata) + 1);
    end loop;
    while empty = '0' LOOP
        NEGATIVE_SYNCHRONOUS_PULSE(clk, ren);
        wait until rising_edge(clk);
    end loop;


    WAIT_N_CYCLES(clk, 10);
    end_of_simu <= '1';
    wait;
    end process;

END;