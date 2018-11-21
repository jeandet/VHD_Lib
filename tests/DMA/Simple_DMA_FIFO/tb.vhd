
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
USE IEEE.std_logic_signed.ALL;
USE IEEE.MATH_real.ALL;

LIBRARY techmap;
USE techmap.gencomp.ALL;

library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;

library gaisler;
use gaisler.sim.all;
use gaisler.memctrl.all;
use gaisler.misc.all;
use gaisler.spi.all;

library std;
use std.textio.all;

LIBRARY lpp;
USE lpp.general_purpose.ALL;
USE lpp.data_type_pkg.ALL;
USE lpp.lpp_sim_pkg.ALL;
USE lpp.lpp_memory.ALL;
USE lpp.iir_filter.ALL;
use LPP.lpp_dma_pkg.lpp_dma_SEND16B_FIFO2DMA;

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
  CONSTANT DataSz                : INTEGER RANGE 1 TO 32 := 32;
  CONSTANT AddrSz                : INTEGER RANGE 2 TO 12 := 8;

  constant CFG_FABTECH : integer := artix7;
  constant CFG_MEMTECH : integer := artix7;
  constant CFG_PADTECH : integer := artix7;

  constant CFG_DEFMST : integer := (0);
  constant CFG_RROBIN : integer := 1;
  constant CFG_SPLIT : integer := 0;
  constant CFG_FPNPEN : integer := 1;
  constant CFG_AHBIO : integer := 16#FFF#;
  constant CFG_APBADDR : integer := 16#800#;
  constant CFG_AHB_MON : integer := 0;
  constant CFG_AHB_MONERR : integer := 0;
  constant CFG_AHB_MONWAR : integer := 0;
  constant CFG_AHB_DTRACE : integer := 0;

  constant CFG_AHBRAMEN : integer := 1;
  constant CFG_AHBRSZ : integer := 128;
  constant CFG_AHBRADDR : integer := 16#400#;
  constant CFG_AHBRPIPE : integer := 0;

  signal apbi  : apb_slv_in_type;
  signal apbo  : apb_slv_out_vector := (others => apb_none);
  signal ahbsi : ahb_slv_in_type;
  signal ahbso : ahb_slv_out_vector := (others => ahbs_none);
  signal ahbmi : ahb_mst_in_type;
  signal ahbmo : ahb_mst_out_vector := (others => ahbm_none);

  signal spmi : spimctrl_in_type;
  signal spmo : spimctrl_out_type;

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
  SIGNAL  empty_d0        : STD_LOGIC := 'U';
  SIGNAL  empty_d1        : STD_LOGIC := 'U';
  SIGNAL  empty_d2        : STD_LOGIC := 'U';
  SIGNAL  full            : STD_LOGIC;
  SIGNAL  full_almost     : STD_LOGIC;
  SIGNAL  empty_threshold : STD_LOGIC;
  SIGNAL  full_threshold  : STD_LOGIC;

  SIGNAL preloader_armed  : STD_LOGIC := '0';
  SIGNAL preloader_ren    : STD_LOGIC := '1';
  SIGNAL preloader_data   : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
  -- DMA Module

  -- FIFO Interface
  signal DMA_ren   :  STD_LOGIC := '1';
  signal DMA_ren_d :  STD_LOGIC := '1';
  signal DMA_data :  STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');

  -- Controls
  signal DMA_send        : STD_LOGIC := '0';
  signal DMA_valid_burst : STD_LOGIC := '0';        -- (1 => BURST , 0 => SINGLE)
  signal DMA_done        : STD_LOGIC := '0';
  signal DMA_address     : STD_LOGIC_VECTOR(31 DOWNTO 0):= X"0000_0000";


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


  ----------------------------------------------------------------------
  ---  AHB CONTROLLER --------------------------------------------------
  ----------------------------------------------------------------------

  ahb0 : ahbctrl
    generic map (defmast => CFG_DEFMST, split => CFG_SPLIT,
                 rrobin  => CFG_RROBIN, ioaddr => CFG_AHBIO, ioen => 1,
                 nahbm => 1,
                 nahbs => 6)
    port map (rstn, clk, ahbmi, ahbmo, ahbsi, ahbso);


  -- 0 latency device
  ahbram0 : ahbram_sim
    generic map (hindex => 3, haddr => CFG_AHBRADDR, tech => CFG_MEMTECH,
                 kbytes => 1024, pipe => CFG_AHBRPIPE, fname => "ram.srec")
    port map (rstn, clk, ahbsi, ahbso(3));

  -- Slow device with big latency
  spimctrl1 : spimctrl
    generic map (hindex => 0, hirq => 7, faddr => 16#000#, fmask => 16#ff0#,
                 ioaddr => 16#700#, iomask => 16#fff#, spliten => CFG_SPLIT)
    port map (rstn, clk, ahbsi, ahbso(0), spmi, spmo);
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

    dma0: lpp_dma_SEND16B_FIFO2DMA
    generic map(hindex => 0,
        vendorid => 0,
        deviceid => 0,
        version  => 0
    )
    port map(
        clk => clk,
        rstn => rstn,
        AHB_Master_In  => ahbmi,
        AHB_Master_Out => ahbmo(0),

        ren  => DMA_ren,
        data => DMA_data,

        send => DMA_send,
        valid_burst => DMA_valid_burst,
        done => DMA_done,
        address => DMA_address
    );

    DMA_data <= rdata when DMA_ren_d = '0' and preloader_armed = '1' else preloader_data;

  -----------------------------------------------------------------------------
    ren <= preloader_ren and DMA_ren;
  process(clk)
  begin
    if rising_edge(clk) then
      DMA_send <= not empty_threshold;
      empty_d0  <= empty;
      empty_d1  <= empty_d0;
      empty_d2  <= empty_d1;
      DMA_ren_d <= DMA_ren;
      preloader_ren      <= '1';
      if empty_d0 = '0' and empty_d1 = '0' and preloader_armed = '0' then
        preloader_ren   <= '0';
        preloader_armed <= '1';
        preloader_data  <= rdata;
      elsif DMA_ren = '0' or preloader_armed = '0' then
        preloader_data  <= rdata;
      elsif DMA_done = '1' then
        preloader_armed <= '0';
      end if;
    end if;
  end process;

    process
    begin
        wait until DMA_done = '1';
        DMA_address <= std_logic_vector(UNSIGNED(DMA_address) + 64);
        IF end_of_simu = '1' THEN
            wait;
        END IF;
    end process;


    process
    begin
        wait until rstn = '1';
        run <= '1';
        WAIT_N_CYCLES(clk, 10);
        if empty = '0' then
            wait until empty = '1';
        end if;
        FOR I in 0 TO 256 LOOP
            NEGATIVE_SYNCHRONOUS_PULSE(clk, wen);
            wait until rising_edge(clk);
            wdata <= std_logic_vector(UNSIGNED(wdata) + 1);
        end loop;

        WAIT_N_CYCLES(clk, 1000);
        end_of_simu <= '1';
        wait;
    end process;

END;