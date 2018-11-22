-----------------------------------------------------------------------------
--  LEON3 Demonstration design test bench
--  Copyright (C) 2016 Cobham Gaisler
------------------------------------------------------------------------------
--  This file is a part of the GRLIB VHDL IP LIBRARY
--  Copyright (C) 2003 - 2008, Gaisler Research
--  Copyright (C) 2008 - 2014, Aeroflex Gaisler
--  Copyright (C) 2015 - 2017, Cobham Gaisler
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;
library gaisler;
use gaisler.sim.all;
use gaisler.libdcom.all;
library techmap;
use techmap.gencomp.all;
use work.debug.all;

use work.config.all;

entity testbench is
  generic (
    fabtech   : integer := CFG_FABTECH;
    memtech   : integer := CFG_MEMTECH;
    padtech   : integer := CFG_PADTECH;
    clktech   : integer := CFG_CLKTECH;
    disas     : integer := CFG_DISAS;   -- Enable disassembly to console
    dbguart   : integer := CFG_DUART;   -- Print UART on console
    pclow     : integer := CFG_PCLOW;
    USE_MIG_INTERFACE_MODEL : boolean := false;
    clkperiod : integer := 10           -- system clock period
    );
end;

architecture behav of testbench is
  constant promfile  : string  := "prom.srec";      -- rom contents
  constant sdramfile : string  := "ram.srec";       -- sdram contents

  constant ct       : integer := clkperiod/2;

  constant STOP_CPU : integer := 0;

  -- MIG Simulation parameters
  constant SIM_BYPASS_INIT_CAL : string := "FAST";
          -- # = "OFF" -  Complete memory init &
          --               calibration sequence
          -- # = "SKIP" - Not supported
          -- # = "FAST" - Complete memory init & use
          --              abbreviated calib sequence

  constant SIMULATION          : string := "TRUE";
          -- Should be TRUE during design simulations and
          -- FALSE during implementations

  constant lresp : boolean := false;

  signal sysclk             : std_ulogic := '0';
  -- LEDs
  signal led                : std_logic_vector(3 downto 0);
  -- Buttons
  signal btn                : std_logic_vector(3 downto 0);
  signal cpu_resetn         : std_ulogic:='0';
  -- Switches
  signal sw                 : std_logic_vector(3 downto 0);
  -- USB-RS232 interface
  signal uart_tx_in         : std_logic := '1';
  signal uart_rx_out        : std_logic;
  -- DDR3
  signal ddr3_dq            : std_logic_vector(15 downto 0);
  signal ddr3_dqs_p         : std_logic_vector(1 downto 0);
  signal ddr3_dqs_n         : std_logic_vector(1 downto 0);
  signal ddr3_addr          : std_logic_vector(13 downto 0);
  signal ddr3_ba            : std_logic_vector(2 downto 0);
  signal ddr3_ras_n         : std_logic;
  signal ddr3_cas_n         : std_logic;
  signal ddr3_we_n          : std_logic;
  signal ddr3_reset_n       : std_logic:='0';
  signal ddr3_reset_n_sim   : std_logic:='0';
  signal ddr3_ck_p          : std_logic_vector(0 downto 0);
  signal ddr3_ck_n          : std_logic_vector(0 downto 0);
  signal ddr3_cke           : std_logic_vector(0 downto 0);
  signal ddr3_dm            : std_logic_vector(1 downto 0);
  signal ddr3_odt           : std_logic_vector(0 downto 0);
  -- Fan PWM
  signal fan_pwm            : std_ulogic;
  -- SPI
  signal qspi_cs            : std_logic;
  signal qspi_dq            : std_logic_vector(3 downto 0);
  signal scl                : std_ulogic;

  signal gnd                : std_ulogic;

  signal ADC_SCLK           : std_logic;
  signal ADC_MISO           : std_logic_vector(1 downto 0):="00";
  signal ADC_csn            : std_logic;

begin

  gnd <= '0';

  ddr3_reset_n_sim <= '0' when cpu_resetn = '0' else
                      ddr3_reset_n;
  -- clock and reset
  sysclk        <= not sysclk after ct * 1 ns;
  cpu_resetn    <= '0', '1' after 100 ns;

  d3 : entity work.leon3mp
    generic map (fabtech, memtech, padtech, clktech, disas, dbguart, pclow,1,
                 SIM_BYPASS_INIT_CAL, SIMULATION, USE_MIG_INTERFACE_MODEL, STOP_CPU)
    port map (
      sysclk => sysclk, led => led,
      btn => btn,
      cpu_resetn => cpu_resetn,
      sw => sw,    uart_tx_in => uart_tx_in, uart_rx_out => uart_rx_out,
      ddr3_dq => ddr3_dq, ddr3_dqs_p => ddr3_dqs_p, ddr3_dqs_n => ddr3_dqs_n,
      ddr3_addr => ddr3_addr, ddr3_ba => ddr3_ba,
      ddr3_ras_n => ddr3_ras_n, ddr3_cas_n => ddr3_cas_n,
      ddr3_we_n => ddr3_we_n, ddr3_reset_n => ddr3_reset_n,
      ddr3_ck_p => ddr3_ck_p, ddr3_ck_n => ddr3_ck_n,
      ddr3_cke => ddr3_cke, ddr3_dm  => ddr3_dm, ddr3_odt => ddr3_odt,
      ADC_SCLK => ADC_SCLK,
      ADC_MISO => ADC_MISO,
      ADC_csn  => ADC_csn
     );

  ddr3mem0 : ddr3ram
    generic map(
      width => 16, abits => 14, colbits => 10, rowbits => 13,
      implbanks => 8, fname => sdramfile, speedbin=>1, density => 3, lddelay => (0 ns))
--      swap => CFG_MIG_7SERIES)
    port map (ck => ddr3_ck_p(0), ckn => ddr3_ck_n(0), cke => ddr3_cke(0), csn => gnd,
              odt => ddr3_odt(0), rasn => ddr3_ras_n, casn => ddr3_cas_n, wen => ddr3_we_n,
              dm => ddr3_dm, ba => ddr3_ba, a => ddr3_addr,
              resetn => ddr3_reset_n_sim,
              dq => ddr3_dq(15 downto 0),
              dqs => ddr3_dqs_p, dqsn => ddr3_dqs_n, doload => led(2));

  spimem0: if CFG_SPIMCTRL = 1 generate
    s0 : spi_flash generic map (ftype => 4, debug => 0, fname => promfile,
                                readcmd => CFG_SPIMCTRL_READCMD,
                                dummybyte => CFG_SPIMCTRL_DUMMYBYTE,
                                dualoutput => CFG_SPIMCTRL_DUALOUTPUT)
      port map (scl, qspi_dq(0), qspi_dq(1), qspi_cs);
  end generate spimem0;


  iuerr : process
  begin
    wait for 1000 us;
    assert (to_X01(led(3)) = '0')
      report "*** IU in error mode, simulation halted ***"
      severity failure;
  end process;



  dsucom : process
    variable w32 : std_logic_vector(31 downto 0);
    constant txp : time := 25 * 8 * 1 ns;
    procedure writeReg(signal dsutx : out std_logic;  address : unsigned(31 downto 0); value : unsigned(31 downto 0)) is
    begin
        txc(dsutx, 16#c0#, txp); --control byte
        txa(dsutx, to_integer(address(31 downto 24)) , to_integer(address(23 downto 16)), to_integer(address(15 downto 8)),  to_integer(address(7 downto 0)), txp); --adress
        txa(dsutx, to_integer(value(31 downto 24)) , to_integer(value(23 downto 16)), to_integer(value(15 downto 8)),  to_integer(value(7 downto 0)), txp); --write data
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
        --dsurst <= '0'; --reset low
    wait for 500 ns;
    --dsurst <= '1'; --reset high
    --wait; --evig w8
    wait for 5000 ns;
    -- txc(dsutx, 16#55#, txp);
    -- dsucfg(dsutx, dsurx);
    -- writeReg(dsutx,16#40000000#,16#12345678#);
    -- writeReg(dsutx,16#40000004#,16#22222222#);
    -- writeReg(dsutx,16#40000008#,16#33333333#);
    -- writeReg(dsutx,16#4000000C#,16#44444444#);

    -- readReg(dsurx,dsutx,16#40000000#,w32);
    -- readReg(dsurx,dsutx,16#40000004#,w32);
    -- readReg(dsurx,dsutx,16#40000008#,w32);
    -- readReg(dsurx,dsutx,16#4000000C#,w32);

    end;

  begin
    wait until cpu_resetn = '1';
    wait for 130 us;
    txc(uart_tx_in, 16#55#, txp);
    wait for 10 us;
    writeReg(uart_tx_in,X"8000_0604",X"4000_0000");
    writeReg(uart_tx_in,X"8000_0608",X"0000_0100");
    writeReg(uart_tx_in,X"8000_0600",X"0000_0001");
    wait;
 end process;

end;