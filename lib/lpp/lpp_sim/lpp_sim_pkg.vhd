------------------------------------------------------------------------------
--  This file is a part of the LPP VHDL IP LIBRARY
--  Copyright (C) 2009 - 2010, Laboratory of Plasmas Physic - CNRS
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 3 of the License, or
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
-------------------------------------------------------------------------------
--                    Author : Jean-christophe Pellion
--                    Mail   : jean-christophe.pellion@lpp.polytechnique.fr
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
LIBRARY grlib;
USE grlib.stdlib.ALL;
LIBRARY gaisler;
USE gaisler.libdcom.ALL;
USE gaisler.sim.ALL;
USE gaisler.jtagtst.ALL;
LIBRARY techmap;
USE techmap.gencomp.ALL;

LIBRARY lpp;
USE lpp.data_type_pkg.ALL;

PACKAGE lpp_sim_pkg IS

  PROCEDURE UART_INIT (
    SIGNAL   TX        : OUT STD_LOGIC;
    CONSTANT tx_period : IN  TIME
    );
  PROCEDURE UART_WRITE_ADDR32 (
    SIGNAL   TX        : OUT STD_LOGIC;
    CONSTANT tx_period : IN  TIME;
    CONSTANT ADDR      : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT DATA      : IN  STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
  PROCEDURE UART_WRITE (
    SIGNAL   TX        : OUT STD_LOGIC;
    CONSTANT tx_period : IN  TIME;
    CONSTANT ADDR      : IN  STD_LOGIC_VECTOR(31 DOWNTO 2);
    CONSTANT DATA      : IN  STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
  PROCEDURE UART_READ (
    SIGNAL   TX        : OUT STD_LOGIC;
    SIGNAL   RX        : IN  STD_LOGIC;
    CONSTANT tx_period : IN  TIME;
    CONSTANT ADDR      : IN  STD_LOGIC_VECTOR(31 DOWNTO 2);
    DATA      : OUT  STD_LOGIC_VECTOR
    );

  COMPONENT sig_reader IS
    GENERIC(
      FNAME       : STRING  := "input.txt";
      WIDTH       : INTEGER := 1;
      RESOLUTION  : INTEGER := 8;
      GAIN        : REAL    := 1.0
    );
    PORT(
      clk             : IN std_logic;
      end_of_simu     : out std_logic;
      out_signal      : out sample_vector(0 to WIDTH-1,RESOLUTION-1 downto 0)
    );
  END COMPONENT;

  COMPONENT sig_recorder IS
  GENERIC(
      FNAME       : STRING  := "output.txt";
      WIDTH       : INTEGER := 1;
      RESOLUTION  : INTEGER := 8
  );
  PORT(
      clk             : IN STD_LOGIC;
      end_of_simu     : IN STD_LOGIC;
      timestamp       : IN INTEGER;
      input_signal    : IN sample_vector(0 TO WIDTH-1,RESOLUTION-1 DOWNTO 0)
  );
  END COMPONENT;

  -----------------------------------------------------------------------------
  -- SPW
  -----------------------------------------------------------------------------
  COMPONENT spw_sender IS
    GENERIC (
      FNAME : STRING);
    PORT (
          end_of_simu : OUT STD_LOGIC;
          start_of_simu  : IN  STD_LOGIC;
          ack_rmap_packet  : IN STD_LOGIC;
          ack_ccsds_packet : IN STD_LOGIC;
          current_packet   : OUT STRING(1 to 256);
          clk     : IN  STD_LOGIC;
          txwrite : OUT STD_LOGIC;
          txflag  : OUT STD_LOGIC;
          txdata  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
          txrdy   : IN  STD_LOGIC;
          txhalff : IN  STD_LOGIC);
  END COMPONENT spw_sender;

  COMPONENT spw_receiver IS
    GENERIC (
      FNAME : STRING);
    PORT (
          end_of_simu : IN STD_LOGIC;
          timestamp : IN integer;
          got_rmap_packet  : OUT STD_LOGIC;
          got_ccsds_packet : OUT STD_LOGIC;
          clk     : IN  STD_LOGIC;
          rxread  : out STD_LOGIC;
          rxflag  : in STD_LOGIC;
          rxdata  : in STD_LOGIC_VECTOR(7 DOWNTO 0);
          rxvalid : in  STD_LOGIC;
          rxhalff : out  STD_LOGIC);
  END COMPONENT spw_receiver;

  -----------------------------------------------------------------------------
  -- LFR-I/O
  -----------------------------------------------------------------------------
  COMPONENT lfr_input_gen IS
    GENERIC (
      FNAME : STRING);
    PORT (
      end_of_simu            : OUT STD_LOGIC;
      rhf1401_data           : OUT STD_LOGIC_VECTOR(13 DOWNTO 0);
      adc_rhf1401_smp_clk    : IN  STD_LOGIC;
      adc_rhf1401_oeb_bar_ch : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
      adc_bias_fail_sel      : IN  STD_LOGIC;
      hk_rhf1401_smp_clk     : IN  STD_LOGIC;
      hk_rhf1401_oeb_bar_ch  : IN  STD_LOGIC;
      hk_sel                 : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
      error_oeb              : OUT STD_LOGIC;
      error_hksel            : OUT STD_LOGIC);
  END COMPONENT lfr_input_gen;

END lpp_sim_pkg;

PACKAGE BODY lpp_sim_pkg IS

  PROCEDURE UART_INIT (SIGNAL TX : OUT STD_LOGIC; CONSTANT tx_period : IN TIME) IS
  BEGIN
    txc(TX, 16#55#, tx_period);
  END;

  PROCEDURE UART_WRITE_ADDR32 (SIGNAL TX : OUT STD_LOGIC; CONSTANT tx_period : IN TIME;
  CONSTANT ADDR                   : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
  CONSTANT DATA                   : IN  STD_LOGIC_VECTOR(31 DOWNTO 0)) IS
  BEGIN
    txc(TX, 16#c0#, tx_period);
    txa(TX,
        to_integer(UNSIGNED(ADDR(31 DOWNTO 24))),
        to_integer(UNSIGNED(ADDR(23 DOWNTO 16))),
        to_integer(UNSIGNED(ADDR(15 DOWNTO 8))),
        to_integer(UNSIGNED(ADDR(7 DOWNTO 0))),
        tx_period);
    txa(TX,
        to_integer(UNSIGNED(DATA(31 DOWNTO 24))),
        to_integer(UNSIGNED(DATA(23 DOWNTO 16))),
        to_integer(UNSIGNED(DATA(15 DOWNTO 8))),
        to_integer(UNSIGNED(DATA(7 DOWNTO 0))),
        tx_period);
  END;

  PROCEDURE UART_WRITE (SIGNAL TX : OUT STD_LOGIC; CONSTANT tx_period : IN TIME;
  CONSTANT ADDR                   : IN  STD_LOGIC_VECTOR(31 DOWNTO 2);
  CONSTANT DATA                   : IN  STD_LOGIC_VECTOR(31 DOWNTO 0)) IS

    CONSTANT ADDR_last : STD_LOGIC_VECTOR(7 DOWNTO 0) := ADDR(7 DOWNTO 2) & "00";

  BEGIN
    txc(TX, 16#c0#, tx_period);
    txa(TX,
        to_integer(UNSIGNED(ADDR(31 DOWNTO 24))),
        to_integer(UNSIGNED(ADDR(23 DOWNTO 16))),
        to_integer(UNSIGNED(ADDR(15 DOWNTO 8))),
        to_integer(UNSIGNED(ADDR_last)),
        tx_period);
    txa(TX,
        to_integer(UNSIGNED(DATA(31 DOWNTO 24))),
        to_integer(UNSIGNED(DATA(23 DOWNTO 16))),
        to_integer(UNSIGNED(DATA(15 DOWNTO 8))),
        to_integer(UNSIGNED(DATA(7 DOWNTO 0))),
        tx_period);
  END;

  PROCEDURE UART_READ (
    SIGNAL   TX        : OUT STD_LOGIC;
    SIGNAL   RX        : IN  STD_LOGIC;
    CONSTANT tx_period : IN  TIME;
    CONSTANT ADDR      : IN  STD_LOGIC_VECTOR(31 DOWNTO 2);
    DATA      : OUT  STD_LOGIC_VECTOR )
  IS
    VARIABLE V_DATA : STD_LOGIC_VECTOR(7 DOWNTO 0);
    CONSTANT ADDR_last : STD_LOGIC_VECTOR(7 DOWNTO 0) := ADDR(7 DOWNTO 2) & "00";
  BEGIN
    txc(TX, 16#80#, tx_period);
    txa(TX,
        to_integer(UNSIGNED(ADDR(31 DOWNTO 24))),
        to_integer(UNSIGNED(ADDR(23 DOWNTO 16))),
        to_integer(UNSIGNED(ADDR(15 DOWNTO 8))),
        to_integer(UNSIGNED(ADDR_last)),
        tx_period);
    rxc(RX,V_DATA,tx_period);
    DATA(31 DOWNTO 24) := V_DATA;
    rxc(RX,V_DATA,tx_period);
    DATA(23 DOWNTO 16) := V_DATA;
    rxc(RX,V_DATA,tx_period);
    DATA(15 DOWNTO 8) := V_DATA;
    rxc(RX,V_DATA,tx_period);
    DATA(7 DOWNTO 0) := V_DATA;
  END;

END lpp_sim_pkg;
