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
  
END lpp_sim_pkg;
