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
USE lpp.lpp_sim_pkg.ALL;
USE lpp.lpp_lfr_apbreg_pkg.ALL;
USE lpp.lpp_lfr_time_management_apbreg_pkg.ALL;

PACKAGE lpp_lfr_sim_pkg IS

  PROCEDURE UNRESET_LFR (
    SIGNAL   TX                       : OUT STD_LOGIC;
    CONSTANT tx_period                : IN  TIME;
    CONSTANT ADDR_BASE_TIME_MANAGMENT : IN  STD_LOGIC_VECTOR(31 DOWNTO 8)
    );

  PROCEDURE LAUNCH_SPECTRAL_MATRIX(
    SIGNAL   TX                       : OUT STD_LOGIC;
    SIGNAL   RX                       : IN  STD_LOGIC;
    CONSTANT tx_period                : IN  TIME;
    CONSTANT ADDR_BASE_LFR            : IN  STD_LOGIC_VECTOR(31 DOWNTO 8);
    CONSTANT PARAM_SM_f0_0_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_SM_f0_1_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_SM_f1_0_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_SM_f1_1_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_SM_f2_0_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_SM_f2_1_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
  
  -----------------------------------------------------------------------------
  -- SM function
  -----------------------------------------------------------------------------

  PROCEDURE RESET_SPECTRAL_MATRIX_REGS(
    SIGNAL   TX                       : OUT STD_LOGIC;
    SIGNAL   RX                       : IN  STD_LOGIC;
    CONSTANT tx_period                : IN  TIME;
    CONSTANT ADDR_BASE_LFR            : IN  STD_LOGIC_VECTOR(31 DOWNTO 8);
    CONSTANT PARAM_SM_f0_0_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_SM_f0_1_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_SM_f1_0_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_SM_f1_1_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_SM_f2_0_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_SM_f2_1_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
    );

  PROCEDURE SET_SM_IRQ_onNewMatrix(
    SIGNAL   TX                       : OUT STD_LOGIC;
    SIGNAL   RX                       : IN  STD_LOGIC;
    CONSTANT tx_period                : IN  TIME;
    CONSTANT ADDR_BASE_LFR            : IN  STD_LOGIC_VECTOR(31 DOWNTO 8);
    CONSTANT PARAM_value              : IN STD_LOGIC
    );

  PROCEDURE SET_SM_IRQ_ERROR(
    SIGNAL   TX                       : OUT STD_LOGIC;
    SIGNAL   RX                       : IN  STD_LOGIC;
    CONSTANT tx_period                : IN  TIME;
    CONSTANT ADDR_BASE_LFR            : IN  STD_LOGIC_VECTOR(31 DOWNTO 8);
    CONSTANT PARAM_value              : IN STD_LOGIC
    );

  PROCEDURE RESET_SM_STATUS(
    SIGNAL   TX                       : OUT STD_LOGIC;
    SIGNAL   RX                       : IN  STD_LOGIC;
    CONSTANT tx_period                : IN  TIME;
    CONSTANT ADDR_BASE_LFR            : IN  STD_LOGIC_VECTOR(31 DOWNTO 8) 
    );
  
END lpp_lfr_sim_pkg;



PACKAGE BODY lpp_lfr_sim_pkg IS

  PROCEDURE UNRESET_LFR (
    SIGNAL   TX                       : OUT STD_LOGIC;
    CONSTANT tx_period                : IN  TIME;
    CONSTANT ADDR_BASE_TIME_MANAGMENT : IN  STD_LOGIC_VECTOR(31 DOWNTO 8))
  IS
  BEGIN
    UART_WRITE(TX,tx_period,ADDR_BASE_TIME_MANAGMENT & ADDR_LFR_TM_CONTROL   , X"00000000");
    UART_WRITE(TX,tx_period,ADDR_BASE_TIME_MANAGMENT & ADDR_LFR_TM_TIME_LOAD , X"00000000");
  END;
  
  PROCEDURE LAUNCH_SPECTRAL_MATRIX(
    SIGNAL   TX                       : OUT STD_LOGIC;
    SIGNAL   RX                       : IN  STD_LOGIC;
    CONSTANT tx_period                : IN  TIME;
    CONSTANT ADDR_BASE_LFR            : IN  STD_LOGIC_VECTOR(31 DOWNTO 8);
    CONSTANT PARAM_SM_f0_0_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_SM_f0_1_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_SM_f1_0_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_SM_f1_1_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_SM_f2_0_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_SM_f2_1_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
    )
  IS
  BEGIN
    RESET_SPECTRAL_MATRIX_REGS(TX,RX,tx_period,ADDR_BASE_LFR,
                               PARAM_SM_f0_0_addr, PARAM_SM_f0_1_addr, PARAM_SM_f1_0_addr, 
                               PARAM_SM_f1_1_addr, PARAM_SM_f2_0_addr, PARAM_SM_f2_1_addr);
    SET_SM_IRQ_onNewMatrix    (TX,RX,tx_period,ADDR_BASE_LFR,
                               '1');
  END;

  -----------------------------------------------------------------------------
  -- SM function
  -----------------------------------------------------------------------------
  PROCEDURE RESET_SPECTRAL_MATRIX_REGS(
    SIGNAL   TX                       : OUT STD_LOGIC;
    SIGNAL   RX                       : IN  STD_LOGIC;
    CONSTANT tx_period                : IN  TIME;
    CONSTANT ADDR_BASE_LFR            : IN  STD_LOGIC_VECTOR(31 DOWNTO 8);
    CONSTANT PARAM_SM_f0_0_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_SM_f0_1_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_SM_f1_0_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_SM_f1_1_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_SM_f2_0_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_SM_f2_1_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
    )
  IS
  BEGIN
    SET_SM_IRQ_ERROR      (TX,RX,tx_period,ADDR_BASE_LFR,'0');
    SET_SM_IRQ_onNewMatrix(TX,RX,tx_period,ADDR_BASE_LFR,'0');
    RESET_SM_STATUS       (TX,RX,tx_period,ADDR_BASE_LFR);
    UART_WRITE            (TX   ,tx_period,ADDR_BASE_LFR & ADDR_LFR_SM_F0_0_ADDR,PARAM_SM_f0_0_addr);
    UART_WRITE            (TX   ,tx_period,ADDR_BASE_LFR & ADDR_LFR_SM_F0_1_ADDR,PARAM_SM_f0_1_addr);
    UART_WRITE            (TX   ,tx_period,ADDR_BASE_LFR & ADDR_LFR_SM_F1_0_ADDR,PARAM_SM_f1_0_addr);
    UART_WRITE            (TX   ,tx_period,ADDR_BASE_LFR & ADDR_LFR_SM_F1_1_ADDR,PARAM_SM_f1_1_addr);
    UART_WRITE            (TX   ,tx_period,ADDR_BASE_LFR & ADDR_LFR_SM_F2_0_ADDR,PARAM_SM_f2_0_addr);
    UART_WRITE            (TX   ,tx_period,ADDR_BASE_LFR & ADDR_LFR_SM_F2_1_ADDR,PARAM_SM_f2_1_addr);
    UART_WRITE            (TX   ,tx_period,ADDR_BASE_LFR & ADDR_LFR_SM_LENGTH   ,X"000000C8");
  END;  

  PROCEDURE SET_SM_IRQ_onNewMatrix(
    SIGNAL   TX                       : OUT STD_LOGIC;
    SIGNAL   RX                       : IN  STD_LOGIC;
    CONSTANT tx_period                : IN  TIME;
    CONSTANT ADDR_BASE_LFR            : IN  STD_LOGIC_VECTOR(31 DOWNTO 8) ;
    CONSTANT PARAM_value              : IN STD_LOGIC
    )
  IS
    VARIABLE data_read : STD_LOGIC_VECTOR(31 DOWNTO 0);
  BEGIN
    UART_READ(TX,RX,tx_period,ADDR_BASE_LFR &  ADDR_LFR_SM_CONFIG, data_read);
    IF PARAM_value = '1' THEN
      UART_WRITE(TX,tx_period,ADDR_BASE_LFR & ADDR_LFR_SM_CONFIG , data_read(31 DOWNTO 1) & '1' );
    ELSE
      UART_WRITE(TX,tx_period,ADDR_BASE_LFR & ADDR_LFR_SM_CONFIG , data_read(31 DOWNTO 1) & '0' );
    END IF;
  END;
  
  PROCEDURE SET_SM_IRQ_ERROR(
    SIGNAL   TX                       : OUT STD_LOGIC;
    SIGNAL   RX                       : IN  STD_LOGIC;
    CONSTANT tx_period                : IN  TIME;
    CONSTANT ADDR_BASE_LFR            : IN  STD_LOGIC_VECTOR(31 DOWNTO 8) ;
    CONSTANT PARAM_value              : IN STD_LOGIC
    )
  IS
    VARIABLE data_read : STD_LOGIC_VECTOR(31 DOWNTO 0);
  BEGIN
    UART_READ(TX,RX,tx_period,ADDR_BASE_LFR &  ADDR_LFR_SM_CONFIG, data_read);
    IF PARAM_value = '1' THEN
      UART_WRITE(TX,tx_period,ADDR_BASE_LFR & ADDR_LFR_SM_CONFIG , data_read(31 DOWNTO 2) & '1' & data_read(0) );
    ELSE
      UART_WRITE(TX,tx_period,ADDR_BASE_LFR & ADDR_LFR_SM_CONFIG , data_read(31 DOWNTO 2) & '0' & data_read(0) );
    END IF;
  END;
  
  PROCEDURE RESET_SM_STATUS(
    SIGNAL   TX                       : OUT STD_LOGIC;
    SIGNAL   RX                       : IN  STD_LOGIC;
    CONSTANT tx_period                : IN  TIME;
    CONSTANT ADDR_BASE_LFR            : IN  STD_LOGIC_VECTOR(31 DOWNTO 8)
    )
  IS
  BEGIN
    UART_WRITE(TX,tx_period,ADDR_BASE_LFR & ADDR_LFR_SM_STATUS, X"000007FF");
  END;
 
END lpp_lfr_sim_pkg;
