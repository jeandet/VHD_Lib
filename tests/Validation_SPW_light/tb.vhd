
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.std_logic_signed.ALL;
USE IEEE.MATH_real.ALL;

LIBRARY techmap;
USE techmap.gencomp.ALL;

LIBRARY std;
USE std.textio.ALL;

LIBRARY opencores;
USE opencores.spwpkg.ALL;
USE opencores.spwambapkg.ALL;

LIBRARY lpp;
USE lpp.lpp_sim_pkg.ALL;

ENTITY testbench IS
END;

ARCHITECTURE behav OF testbench IS

  SIGNAL TSTAMP : INTEGER   := 0;
  SIGNAL clk    : STD_LOGIC := '0';
  SIGNAL rst    : STD_LOGIC;

  SIGNAL end_of_simu : STD_LOGIC := '0';

  SIGNAL autostart  : STD_LOGIC                    := '1';
  SIGNAL linkstart  : STD_LOGIC                    := '1';
  SIGNAL linkdis    : STD_LOGIC                    := '0';
  SIGNAL ctrl_in    : STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL time_in    : STD_LOGIC_VECTOR(5 DOWNTO 0) := (OTHERS => '0');
  SIGNAL txwrite    : STD_LOGIC                    := '0';
  SIGNAL txflag     : STD_LOGIC                    := '0';
  SIGNAL txdata     : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
  SIGNAL txrdy      : STD_LOGIC;
  SIGNAL txhalff    : STD_LOGIC;
  SIGNAL tick_out   : STD_LOGIC;
  SIGNAL ctrl_out   : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL time_out   : STD_LOGIC_VECTOR(5 DOWNTO 0);
  SIGNAL rxvalid    : STD_LOGIC;
  SIGNAL rxhalff    : STD_LOGIC;
  SIGNAL rxflag     : STD_LOGIC;
  SIGNAL rxdata     : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL rxread     : STD_LOGIC                    := '0';
  SIGNAL started    : STD_LOGIC;
  SIGNAL connecting : STD_LOGIC;
  SIGNAL running    : STD_LOGIC;
  SIGNAL errdisc    : STD_LOGIC;
  SIGNAL errpar     : STD_LOGIC;
  SIGNAL erresc     : STD_LOGIC;
  SIGNAL errcred    : STD_LOGIC;

  SIGNAL spw_di     : std_logic;
  SIGNAL spw_si     : std_logic;
  SIGNAL spw_do     : std_logic;
  SIGNAL spw_so     : std_logic;

  SIGNAL got_rmap_packet  : std_logic;
  SIGNAL got_ccsds_packet : std_logic;
  SIGNAL current_packet   : STRING(1 to 256);

BEGIN

  -----------------------------------------------------------------------------
  -- CLOCK and RESET
  -----------------------------------------------------------------------------
  PROCESS
  BEGIN  -- PROCESS
    WAIT UNTIL clk = '1';
    rst <= '1';
    WAIT UNTIL clk = '1';
    WAIT UNTIL clk = '1';
    WAIT UNTIL clk = '1';
    rst <= '0';
    WAIT UNTIL end_of_simu = '1';
    WAIT FOR 10 ps;
    ASSERT false REPORT "end of test" SEVERITY note;
    --  Wait forever; this will finish the simulation.
    WAIT;
  END PROCESS;
  -----------------------------------------------------------------------------

  clk_50M_gen : PROCESS
  BEGIN
    IF end_of_simu /= '1' THEN
      clk    <= NOT clk;
      TSTAMP <= TSTAMP+20;
      WAIT FOR 10 ns;
    ELSE
      WAIT FOR 10 ps;
      ASSERT false REPORT "end of test" SEVERITY note;
      WAIT;
    END IF;
  END PROCESS;


  SPW : spwstream

    GENERIC MAP(
      sysfreq         => 50.0e6,
      txclkfreq       => 50.0e6,
      rximpl          => impl_generic,
      rxchunk         => 1,
      tximpl          => impl_generic,
      rxfifosize_bits => 11,
      txfifosize_bits => 11
      )

    PORT MAP(
      -- System clock.
      clk   => clk,
      rxclk => clk,
      txclk => clk,
      rst   => rst,


      autostart => autostart,  -- Enables automatic link start on receipt of a NULL character.
      linkstart => linkstart,  -- Enables link start once the Ready state is reached. Without autostart or linkstart, the link remains in state Ready.
      linkdis   => linkdis,  -- Do not start link (overrides linkstart and autostart) and/or disconnect a running link.

      txdivcnt => X"00",


      -------------------------------------------------------------------------
      -- TimeCode transmission
      tick_in => '0',  -- High for one clock cycle to request transmission of a TimeCode. The request is registered inside the entity until it can be processed.
      ctrl_in => ctrl_in,  -- Control bits of the TimeCode to be sent. Must be valid while tick_in is high.
      time_in => time_in,  -- Counter value of the TimeCode to be sent. Must be valid while tick_in is high.
      -------------------------------------------------------------------------

      -------------------------------------------------------------------------
      -- ### tx data ###  tb -> SPW-light
      txwrite => txwrite,  -- Pulled high by the application to write an N-Char to the transmit queue.
      -- If "txwrite" and "txrdy" are both high on the rising edge of "clk", a character is added to the transmit queue.
      -- This signal has no effect if "txrdy" is low.
      txflag  => txflag,  -- Control flag to be sent with the next N_Char. Must be valid while txwrite is high.
      txdata  => txdata,  -- Byte to be sent, or "00000000" for EOP or "00000001" for EEP. Must be valid while txwrite is high.
      txrdy   => txrdy,  -- High if the entity is ready to accept an N-Char for transmission.
      txhalff => txhalff,  -- High if the transmission queue is at least half full.
      -------------------------------------------------------------------------

      -------------------------------------------------------------------------
      -- TimeCode reception
      tick_out => tick_out,  -- High for one clock cycle if a TimeCode was just received.
      ctrl_out => ctrl_out,  -- Control bits of the last received TimeCode.
      time_out => time_out,  -- Counter value of the last received TimeCode.
      -------------------------------------------------------------------------


      -------------------------------------------------------------------------
      -- ### rx data ### tb <- SPW-light
      rxvalid => rxvalid,  -- High if "rxflag" and "rxdata" contain valid data. This signal is high unless the receive FIFO is empty.
      rxhalff => rxhalff,  -- High if the receive FIFO is at least half full.
      rxflag  => rxflag,  -- High if the received character is EOP or EEP; low if the received character is a data byte. Valid if "rxvalid" is high.
      rxdata  => rxdata,  -- Received byte, or "00000000" for EOP or "00000001" for EEP. Valid if "rxvalid" is high.
      rxread  => rxread,  -- Pulled high by the application to accept a received character.
      -- If "rxvalid" and "rxread" are both high on the rising edge of "clk",
      -- a character is removed from the receive FIFO and "rxvalid", "rxflag" and "rxdata" are updated.
      -- This signal has no effect if "rxvalid" is low.
      -------------------------------------------------------------------------

      -------------------------------------------------------------------------
      -- STATUS
      started    => started,  -- High if the link state machine is currently in the Started state.
      connecting => connecting,  -- High if the link state machine is currently in the Connecting state.
      running    => running,  -- High if the link state machine is currently in the Run state, indicatin that the link is fully operational.
      -- If none of started, connecting or running is high, the link is in an initial state and the transmitter is not yet enabled.

      errdisc => errdisc,  -- Disconnect detected in state Run. Triggers a reset and reconnect of the link. This indication is auto-clearing.
      errpar  => errpar,  -- Parity error detected in state Run. Triggers a reset and reconnect of the link. This indication is auto-clearing.
      erresc  => erresc,  -- Invalid escape sequence detected in state Run. Triggers a reset and reconnect of the link. This indication is auto-clearing.
      errcred => errcred,  -- Credit error detected. Triggers a reset and reconnect of the link. This indication is auto-clearing.
      -------------------------------------------------------------------------

      spw_di => spw_di,              -- Data In signal from SpaceWire bus.
      spw_si => spw_si,              -- Strobe In signal from SpaceWire bus.
      spw_do => spw_do,               -- Data Out signal to SpaceWire bus.
      spw_so => spw_so                -- Strobe Out signal to SpaceWire bus.
      );


  spw_si <= spw_so;
  spw_di <= spw_do;

  spw_sender_1: spw_sender
    GENERIC MAP (
      FNAME => "spw_input.txt")
    PORT MAP (
      end_of_simu => OPEN,
      start_of_simu => running,
      clk         => clk,
      ack_ccsds_packet => got_ccsds_packet,
      ack_rmap_packet  => got_rmap_packet,
      current_packet   => current_packet,
      txwrite     => txwrite,
      txflag      => txflag,
      txdata      => txdata,
      txrdy       => txrdy,
      txhalff     => txhalff);

  spw_receiver_1: spw_receiver
    GENERIC MAP (
      FNAME => "spw_output.txt")
    PORT MAP (
      end_of_simu => '0',
      timestamp   => TSTAMP,
      clk         => clk,
      got_rmap_packet  => got_rmap_packet,
      got_ccsds_packet => got_ccsds_packet,
      rxread      => rxread,
      rxflag      => rxflag,
      rxdata      => rxdata,
      rxvalid     => rxvalid,
      rxhalff     => rxhalff);

END;
