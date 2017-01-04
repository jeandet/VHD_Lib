
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.std_logic_signed.ALL;
USE IEEE.MATH_real.ALL;

LIBRARY techmap;
USE techmap.gencomp.ALL;

LIBRARY std;
USE std.textio.ALL;

library opencores;
use opencores.spwpkg.all;
use opencores.spwambapkg.all;

LIBRARY lpp;
USE lpp.iir_filter.ALL;
USE lpp.lpp_ad_conv.ALL;
USE lpp.FILTERcfg.ALL;
USE lpp.lpp_lfr_filter_coeff.ALL;
USE lpp.general_purpose.ALL;
USE lpp.data_type_pkg.ALL;
USE lpp.lpp_lfr_pkg.ALL;
USE lpp.general_purpose.ALL;
USE lpp.lpp_sim_pkg.ALL;
USE lpp.CY7C1061DV33_pkg.ALL;

ENTITY testbench IS
GENERIC(
    tech          : INTEGER := 0; --axcel,0
    Mem_use       : INTEGER := use_CEL --use_RAM,use_CEL
);
END;

ARCHITECTURE behav OF testbench IS

  SIGNAL TSTAMP    : INTEGER   := 0;
  SIGNAL clk       : STD_LOGIC := '0';
  SIGNAL clk49_152MHz   : STD_LOGIC := '0';
  SIGNAL rstn,rst      : STD_LOGIC;

  SIGNAL end_of_simu : STD_LOGIC := '0';

  -----------------------------------------------------------------------------
  -- LFR TOP WRAPPER SIGNALS
  -----------------------------------------------------------------------------
    SIGNAL address        :    STD_LOGIC_VECTOR(18 DOWNTO 0);
    SIGNAL data           :    STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL nSRAM_MBE      :     STD_LOGIC;   -- new
    SIGNAL nSRAM_E1       :     STD_LOGIC;   -- new
    SIGNAL nSRAM_E2       :     STD_LOGIC;   -- new
--    nSRAM_SCRUB    : OUT   STD_LOGIC;   -- new
    SIGNAL nSRAM_W        :     STD_LOGIC;   -- new
    SIGNAL nSRAM_G        :     STD_LOGIC;   -- new
    SIGNAL nSRAM_BUSY     :     STD_LOGIC;   -- new
    -- SPW --------------------------------------------------------------------
    SIGNAL spw1_en        :     STD_LOGIC;   -- new
    SIGNAL spw1_din       :     STD_LOGIC;
    SIGNAL spw1_sin       :     STD_LOGIC;
    SIGNAL spw1_dout      :     STD_LOGIC;
    SIGNAL spw1_sout      :     STD_LOGIC;
    SIGNAL spw2_en        :     STD_LOGIC;   -- new
    SIGNAL spw2_din       :     STD_LOGIC;
    SIGNAL spw2_sin       :     STD_LOGIC;
    SIGNAL spw2_dout      :     STD_LOGIC;
    SIGNAL spw2_sout      :     STD_LOGIC;
    -- ADC --------------------------------------------------------------------
    SIGNAL bias_fail_sw   :     STD_LOGIC;
    SIGNAL ADC_OEB_bar_CH :     STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL ADC_smpclk     :     STD_LOGIC;
    SIGNAL ADC_data       :     STD_LOGIC_VECTOR(13 DOWNTO 0);
    -- DAC --------------------------------------------------------------------
    SIGNAL DAC_SDO    :   STD_LOGIC;
    SIGNAL DAC_SCK    :   STD_LOGIC;
    SIGNAL DAC_SYNC   :   STD_LOGIC;
    SIGNAL DAC_CAL_EN :   STD_LOGIC;
    -- HK ---------------------------------------------------------------------
    SIGNAL HK_smpclk      :     STD_LOGIC;
    SIGNAL ADC_OEB_bar_HK :     STD_LOGIC;
    SIGNAL HK_SEL         :     STD_LOGIC_VECTOR(1 DOWNTO 0);

    SIGNAL nSRAM_CE       :     STD_LOGIC;




    SIGNAL autostart:  std_logic := '1';

        -- Enables link start once the Ready state is reached.
        -- Without autostart or linkstart, the link remains in state Ready.
    SIGNAL    linkstart:    std_logic :='1';

        -- Do not start link (overrides linkstart and autostart) and/or
        -- disconnect a running link.
   SIGNAL     linkdis:      std_logic := '0';

        -- Control bits of the TimeCode to be sent. Must be valid while tick_in is high.
    SIGNAL    ctrl_in:      std_logic_vector(1 downto 0) :=(others => '0');

        -- Counter value of the TimeCode to be sent. Must be valid while tick_in is high.
    SIGNAL    time_in:      std_logic_vector(5 downto 0):=(others => '0');

        -- Pulled high by the application to write an N-Char to the transmit
        -- queue. If "txwrite" and "txrdy" are both high on the rising edge
        -- of "clk", a character is added to the transmit queue.
        -- This signal has no effect if "txrdy" is low.
    SIGNAL   txwrite:      std_logic := '0';

        -- Control flag to be sent with the next N_Char.
        -- Must be valid while txwrite is high.
    SIGNAL    txflag:       std_logic :='0';

        -- Byte to be sent, or "00000000" for EOP or "00000001" for EEP.
        -- Must be valid while txwrite is high.
    SIGNAL    txdata:       std_logic_vector(7 downto 0):=(others => '0');

        -- High if the entity is ready to accept an N-Char for transmission.
    SIGNAL    txrdy:       std_logic;

        -- High if the transmission queue is at least half full.
    SIGNAL    txhalff:     std_logic;

        -- High for one clock cycle if a TimeCode was just received.
    SIGNAL    tick_out:    std_logic;

        -- Control bits of the last received TimeCode.
    SIGNAL    ctrl_out:    std_logic_vector(1 downto 0);

        -- Counter value of the last received TimeCode.
    SIGNAL    time_out:    std_logic_vector(5 downto 0);

        -- High if "rxflag" and "rxdata" contain valid data.
        -- This signal is high unless the receive FIFO is empty.
    SIGNAL    rxvalid:     std_logic;

        -- High if the receive FIFO is at least half full.
    SIGNAL    rxhalff:     std_logic;

        -- High if the received character is EOP or EEP; low if the received
        -- character is a data byte. Valid if "rxvalid" is high.
     SIGNAL   rxflag:      std_logic;

        -- Received byte, or "00000000" for EOP or "00000001" for EEP.
        -- Valid if "rxvalid" is high.
     SIGNAL   rxdata:      std_logic_vector(7 downto 0);

        -- Pulled high by the application to accept a received character.
        -- If "rxvalid" and "rxread" are both high on the rising edge of "clk",
        -- a character is removed from the receive FIFO and "rxvalid", "rxflag"
        -- and "rxdata" are updated.
        -- This signal has no effect if "rxvalid" is low.
     SIGNAL   rxread:     std_logic:='0';

        -- High if the link state machine is currently in the Started state.
     SIGNAL   started:     std_logic;

        -- High if the link state machine is currently in the Connecting state.
    SIGNAL    connecting:  std_logic;

        -- High if the link state machine is currently in the Run state, indicating
        -- that the link is fully operational. If none of started, connecting or running
        -- is high, the link is in an initial state and the transmitter is not yet enabled.
     SIGNAL   running:     std_logic;

        -- Disconnect detected in state Run. Triggers a reset and reconnect of the link.
        -- This indication is auto-clearing.
     SIGNAL   errdisc:     std_logic;

        -- Parity error detected in state Run. Triggers a reset and reconnect of the link.
        -- This indication is auto-clearing.
      SIGNAL  errpar:      std_logic;

        -- Invalid escape sequence detected in state Run. Triggers a reset and reconnect of
        -- the link. This indication is auto-clearing.
      SIGNAL  erresc:      std_logic;

        -- Credit error detected. Triggers a reset and reconnect of the link.
        -- This indication is auto-clearing.
      SIGNAL  errcred:     std_logic;


BEGIN

  -----------------------------------------------------------------------------
  -- CLOCK and RESET
  -----------------------------------------------------------------------------
  PROCESS
  BEGIN  -- PROCESS
    WAIT UNTIL clk = '1';
    rstn <= '0';
    rst  <= '1';
    WAIT UNTIL clk = '1';
    WAIT UNTIL clk = '1';
    WAIT UNTIL clk = '1';
    rstn <= '1';
    rst  <= '0';
    WAIT UNTIL end_of_simu = '1';
    WAIT FOR 10 ps;
    assert false report "end of test" severity note;
    --  Wait forever; this will finish the simulation.
    wait;
  END PROCESS;
  -----------------------------------------------------------------------------


  clk49_152MHz_gen:PROCESS
  BEGIN
    IF end_of_simu /= '1' THEN
      clk49_152MHz <= NOT clk49_152MHz;
      WAIT FOR 10173 ps;
    ELSE
      WAIT FOR 10 ps;
      assert false report "end of test" severity note;
      WAIT;
    END IF;
  END PROCESS;

  clk_50M_gen:PROCESS
  BEGIN
    IF end_of_simu /= '1' THEN
      clk <= NOT clk;
      TSTAMP <= TSTAMP+20;
      WAIT FOR 10 ns;
    ELSE
      WAIT FOR 10 ps;
      assert false report "end of test" severity note;
      WAIT;
    END IF;
  END PROCESS;


LFR:  ENTITY work.LFR_FM
  GENERIC MAP(
    Mem_use                => use_RAM,
    USE_BOOTLOADER         => 0,
    USE_ADCDRIVER          => 1,
    tech                   => inferred,
    tech_leon              => inferred,
    DEBUG_FORCE_DATA_DMA   => 0,
    USE_DEBUG_VECTOR       => 0
    )

  PORT MAP(
    clk50MHz     => clk,
    clk49_152MHz => clk49_152MHz,
    reset        => rstn,

    TAG          => OPEN,

    address        => address,
    data           => data,

    nSRAM_MBE      => nSRAM_MBE,
    nSRAM_E1       => nSRAM_E1,
    nSRAM_E2       => nSRAM_E2,
--    nSRAM_SCRUB    : OUT   STD_LOGIC;   -- new
    nSRAM_W        => nSRAM_W,
    nSRAM_G        => nSRAM_G,
    nSRAM_BUSY     => nSRAM_BUSY,
    -- SPW --------------------------------------------------------------------
    spw1_en        => spw1_en,
    spw1_din       => spw1_din,
    spw1_sin       => spw1_sin,
    spw1_dout      => spw1_dout,
    spw1_sout      => spw1_sout,
    spw2_en        => spw2_en,
    spw2_din       => spw2_din,
    spw2_sin       => spw2_sin,
    spw2_dout      => spw2_dout,
    spw2_sout      => spw2_sout,
    -- ADC --------------------------------------------------------------------
    bias_fail_sw   => bias_fail_sw,
    ADC_OEB_bar_CH => ADC_OEB_bar_CH,
    ADC_smpclk     => ADC_smpclk,
    ADC_data       => ADC_data,
    -- DAC --------------------------------------------------------------------
    DAC_SDO    => DAC_SDO,
    DAC_SCK    => DAC_SCK,
    DAC_SYNC   => DAC_SYNC,
    DAC_CAL_EN => DAC_CAL_EN,
    -- HK ---------------------------------------------------------------------
    HK_smpclk      => HK_smpclk,
    ADC_OEB_bar_HK => ADC_OEB_bar_HK,
    HK_SEL         => HK_SEL
    );


spw2_din <= '1';
spw2_sin <= '1';
  -----------------------------------------------------------------------------
  --  SRAMS Same as EM, we don't have UT8ER1M32 models
  -----------------------------------------------------------------------------
 nSRAM_BUSY  <= '1';  -- TODO emulate scrubbing

 nSRAM_CE <= not nSRAM_E1;

 async_1Mx16_0: CY7C1061DV33
    GENERIC MAP (
      ADDR_BITS         => 19,
      DATA_BITS         => 16,
      depth 	        => 1048576,
      MEM_ARRAY_DEBUG   => 32,
      TimingInfo        => TRUE,
      TimingChecks	=> '1')
    PORT MAP (
      CE1_b => '0',
      CE2   => nSRAM_CE,
      WE_b  => nSRAM_W,
      OE_b  => nSRAM_G,
      BHE_b => '0',
      BLE_b => '0',
      A     => address,
      DQ    => data(15 DOWNTO 0));

  async_1Mx16_1: CY7C1061DV33
    GENERIC MAP (
      ADDR_BITS         => 19,
      DATA_BITS         => 16,
      depth 	        => 1048576,
      MEM_ARRAY_DEBUG   => 32,
      TimingInfo        => TRUE,
      TimingChecks	=> '1')
    PORT MAP (
      CE1_b => '0',
      CE2   => nSRAM_CE,
      WE_b  => nSRAM_W,
      OE_b  => nSRAM_G,
      BHE_b => '0',
      BLE_b => '0',
      A     => address,
      DQ    => data(31 DOWNTO 16));





SPW: spwstream

    generic map(
        sysfreq   =>   50.0e6,
        txclkfreq =>   50.0e6,
        rximpl    =>   impl_generic,
        rxchunk   =>   1,
        tximpl    =>   impl_generic,
        rxfifosize_bits => 11,
        txfifosize_bits => 11
    )

    port map(
        -- System clock.
        clk   => clk,
        rxclk => clk,
        txclk => clk,
        rst   =>  rst,
        autostart => autostart,
        linkstart => linkstart,
        linkdis   => linkdis,
        txdivcnt => X"00",
        tick_in  => '0',

        -- Control bits of the TimeCode to be sent. Must be valid while tick_in is high.
        ctrl_in => ctrl_in,

        -- Counter value of the TimeCode to be sent. Must be valid while tick_in is high.
        time_in => time_in,

        -- Pulled high by the application to write an N-Char to the transmit
        -- queue. If "txwrite" and "txrdy" are both high on the rising edge
        -- of "clk", a character is added to the transmit queue.
        -- This signal has no effect if "txrdy" is low.
        txwrite => txwrite,

        -- Control flag to be sent with the next N_Char.
        -- Must be valid while txwrite is high.
        txflag => txflag,

        -- Byte to be sent, or "00000000" for EOP or "00000001" for EEP.
        -- Must be valid while txwrite is high.
        txdata => txdata,

        -- High if the entity is ready to accept an N-Char for transmission.
        txrdy => txrdy,

        -- High if the transmission queue is at least half full.
        txhalff => txhalff,

        -- High for one clock cycle if a TimeCode was just received.
        tick_out => tick_out,

        -- Control bits of the last received TimeCode.
        ctrl_out => ctrl_out,

        -- Counter value of the last received TimeCode.
        time_out => time_out,

        -- High if "rxflag" and "rxdata" contain valid data.
        -- This signal is high unless the receive FIFO is empty.
        rxvalid => rxvalid,

        -- High if the receive FIFO is at least half full.
        rxhalff => rxhalff,

        -- High if the received character is EOP or EEP; low if the received
        -- character is a data byte. Valid if "rxvalid" is high.
        rxflag => rxflag,

        -- Received byte, or "00000000" for EOP or "00000001" for EEP.
        -- Valid if "rxvalid" is high.
        rxdata => rxdata,

        -- Pulled high by the application to accept a received character.
        -- If "rxvalid" and "rxread" are both high on the rising edge of "clk",
        -- a character is removed from the receive FIFO and "rxvalid", "rxflag"
        -- and "rxdata" are updated.
        -- This signal has no effect if "rxvalid" is low.
        rxread => rxread,

        -- High if the link state machine is currently in the Started state.
        started => started,

        -- High if the link state machine is currently in the Connecting state.
        connecting => connecting,

        -- High if the link state machine is currently in the Run state, indicating
        -- that the link is fully operational. If none of started, connecting or running
        -- is high, the link is in an initial state and the transmitter is not yet enabled.
        running => running,

        -- Disconnect detected in state Run. Triggers a reset and reconnect of the link.
        -- This indication is auto-clearing.
        errdisc => errdisc,

        -- Parity error detected in state Run. Triggers a reset and reconnect of the link.
        -- This indication is auto-clearing.
        errpar => errpar,

        -- Invalid escape sequence detected in state Run. Triggers a reset and reconnect of
        -- the link. This indication is auto-clearing.
        erresc => erresc,

        -- Credit error detected. Triggers a reset and reconnect of the link.
        -- This indication is auto-clearing.
        errcred => errcred,

        -- Data In signal from SpaceWire bus.
        spw_di => spw1_dout,

        -- Strobe In signal from SpaceWire bus.
        spw_si => spw1_sout,

        -- Data Out signal to SpaceWire bus.
        spw_do => spw1_din,

        -- Strobe Out signal to SpaceWire bus.
        spw_so => spw1_sin
    );






  -----------------------------------------------------------------------------
  --  RECORD OUTPUT SIGNALS
  -----------------------------------------------------------------------------



END;
