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

  CONSTANT LFR_MODE_STANDBY : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
  CONSTANT LFR_MODE_NORMAL  : STD_LOGIC_VECTOR(2 DOWNTO 0) := "001";
  CONSTANT LFR_MODE_BURST   : STD_LOGIC_VECTOR(2 DOWNTO 0) := "010";
  CONSTANT LFR_MODE_SBM1    : STD_LOGIC_VECTOR(2 DOWNTO 0) := "011";
  CONSTANT LFR_MODE_SBM2    : STD_LOGIC_VECTOR(2 DOWNTO 0) := "100";
  
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

  PROCEDURE LAUNCH_WAVEFORM_PICKER(
    SIGNAL   TX                       : OUT STD_LOGIC;
    SIGNAL   RX                       : IN  STD_LOGIC;
    CONSTANT tx_period                : IN  TIME;

    CONSTANT LFR_MODE                 : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
    CONSTANT TRANSITION_COARSE_TIME   : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    
    CONSTANT DATA_SHAPING             : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
    CONSTANT DELTA_SNAPSHOT           : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT DELTA_F0                 : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT DELTA_F0_2               : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT DELTA_F1                 : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT DELTA_F2                 : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);

    CONSTANT ADDR_BASE_LFR            : IN  STD_LOGIC_VECTOR(31 DOWNTO 8);
    
    CONSTANT PARAM_WP_f0_0_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_WP_f0_1_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_WP_f1_0_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_WP_f1_1_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_WP_f2_0_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_WP_f2_1_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_WP_f3_0_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_WP_f3_1_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
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

  -----------------------------------------------------------------------------
  -- WP function
  -----------------------------------------------------------------------------

  PROCEDURE RESET_WAVEFORM_PICKER_REGS(
    SIGNAL   TX                       : OUT STD_LOGIC;
    SIGNAL   RX                       : IN  STD_LOGIC;
    CONSTANT tx_period                : IN  TIME;
    CONSTANT ADDR_BASE_LFR            : IN  STD_LOGIC_VECTOR(31 DOWNTO 8);
    
    CONSTANT DATA_SHAPING             : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
    CONSTANT DELTA_SNAPSHOT           : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT DELTA_F0                 : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT DELTA_F0_2               : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT DELTA_F1                 : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT DELTA_F2                 : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    
    CONSTANT PARAM_WP_f0_0_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_WP_f0_1_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_WP_f1_0_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_WP_f1_1_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_WP_f2_0_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_WP_f2_1_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_WP_f3_0_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_WP_f3_1_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
  
  PROCEDURE SET_WFP_DATA_SHAPING(
    SIGNAL   TX                       : OUT STD_LOGIC;
    CONSTANT tx_period                : IN  TIME;
    CONSTANT ADDR_BASE_LFR            : IN  STD_LOGIC_VECTOR(31 DOWNTO 8);
    CONSTANT DATA_SHAPING             : IN  STD_LOGIC_VECTOR(4 DOWNTO 0));

  PROCEDURE RESET_WFP_BURST_ENABLE(
    SIGNAL   TX                       : OUT STD_LOGIC;
    SIGNAL   RX                       : IN  STD_LOGIC;
    CONSTANT tx_period                : IN  TIME;
    CONSTANT ADDR_BASE_LFR            : IN  STD_LOGIC_VECTOR(31 DOWNTO 8));

  PROCEDURE RESET_WFP_STATUS(
    SIGNAL   TX                       : OUT STD_LOGIC;
    CONSTANT tx_period                : IN  TIME;
    CONSTANT ADDR_BASE_LFR            : IN  STD_LOGIC_VECTOR(31 DOWNTO 8));

  PROCEDURE SET_WFP_BURST_ENABLE_REGISTER(
    SIGNAL   TX                       : OUT STD_LOGIC;
    SIGNAL   RX                       : IN  STD_LOGIC;
    CONSTANT tx_period                : IN  TIME;
    CONSTANT ADDR_BASE_LFR            : IN  STD_LOGIC_VECTOR(31 DOWNTO 8);
    CONSTANT LFR_MODE                 : IN  STD_LOGIC_VECTOR(2 DOWNTO 0)
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


  PROCEDURE LAUNCH_WAVEFORM_PICKER(
    SIGNAL   TX                       : OUT STD_LOGIC;
    SIGNAL   RX                       : IN  STD_LOGIC;
    CONSTANT tx_period                : IN  TIME;

    CONSTANT LFR_MODE                 : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
    CONSTANT TRANSITION_COARSE_TIME   : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    
    CONSTANT DATA_SHAPING             : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
    CONSTANT DELTA_SNAPSHOT           : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT DELTA_F0                 : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT DELTA_F0_2               : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT DELTA_F1                 : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT DELTA_F2                 : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);

    CONSTANT ADDR_BASE_LFR            : IN  STD_LOGIC_VECTOR(31 DOWNTO 8);
    CONSTANT PARAM_WP_f0_0_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_WP_f0_1_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_WP_f1_0_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_WP_f1_1_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_WP_f2_0_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_WP_f2_1_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_WP_f3_0_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_WP_f3_1_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
--    CONSTANT PARAM_SM_f0_0_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
--    CONSTANT PARAM_SM_f0_1_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
--    CONSTANT PARAM_SM_f1_0_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
--    CONSTANT PARAM_SM_f1_1_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
--    CONSTANT PARAM_SM_f2_0_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
--    CONSTANT PARAM_SM_f2_1_addr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
    )
  IS
  BEGIN
    RESET_WAVEFORM_PICKER_REGS(TX,RX,tx_period,ADDR_BASE_LFR,
                               DATA_SHAPING  ,
                               DELTA_SNAPSHOT,
                               DELTA_F0      ,
                               DELTA_F0_2    ,
                               DELTA_F1      ,
                               DELTA_F2      ,
                               PARAM_WP_f0_0_addr, PARAM_WP_f0_1_addr,
                               PARAM_WP_f1_0_addr, PARAM_WP_f1_1_addr,
                               PARAM_WP_f2_0_addr, PARAM_WP_f2_1_addr,
                               PARAM_WP_f3_0_addr, PARAM_WP_f3_1_addr);

    SET_WFP_BURST_ENABLE_REGISTER(TX, RX, tx_period, ADDR_BASE_LFR, LFR_MODE);
    
    UART_WRITE(TX   ,tx_period,ADDR_BASE_LFR & ADDR_LFR_WP_START_DATE, TRANSITION_COARSE_TIME);
    
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
 
  -----------------------------------------------------------------------------
  -- WP function
  -----------------------------------------------------------------------------

  PROCEDURE RESET_WAVEFORM_PICKER_REGS(
    SIGNAL   TX                       : OUT STD_LOGIC;
    SIGNAL   RX                       : IN  STD_LOGIC;
    CONSTANT tx_period                : IN  TIME;
    CONSTANT ADDR_BASE_LFR            : IN  STD_LOGIC_VECTOR(31 DOWNTO 8); 
    
    CONSTANT DATA_SHAPING             : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
    CONSTANT DELTA_SNAPSHOT           : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT DELTA_F0                 : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT DELTA_F0_2               : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT DELTA_F1                 : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT DELTA_F2                 : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    
    CONSTANT PARAM_WP_f0_0_addr       : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_WP_f0_1_addr       : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_WP_f1_0_addr       : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_WP_f1_1_addr       : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_WP_f2_0_addr       : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_WP_f2_1_addr       : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_WP_f3_0_addr       : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT PARAM_WP_f3_1_addr       : IN  STD_LOGIC_VECTOR(31 DOWNTO 0)
    )
  IS
  BEGIN
    SET_WFP_DATA_SHAPING  (TX,     tx_period, ADDR_BASE_LFR, DATA_SHAPING);
    RESET_WFP_BURST_ENABLE(TX, RX, tx_period, ADDR_BASE_LFR);
    UART_WRITE            (TX,     tx_period, ADDR_BASE_LFR & ADDR_LFR_WP_F0_0_ADDR, PARAM_WP_f0_0_addr);
    UART_WRITE            (TX,     tx_period, ADDR_BASE_LFR & ADDR_LFR_WP_F0_1_ADDR, PARAM_WP_f0_1_addr);
    UART_WRITE            (TX,     tx_period, ADDR_BASE_LFR & ADDR_LFR_WP_F1_0_ADDR, PARAM_WP_f1_0_addr);
    UART_WRITE            (TX,     tx_period, ADDR_BASE_LFR & ADDR_LFR_WP_F1_1_ADDR, PARAM_WP_f1_1_addr);
    UART_WRITE            (TX,     tx_period, ADDR_BASE_LFR & ADDR_LFR_WP_F2_0_ADDR, PARAM_WP_f2_0_addr);
    UART_WRITE            (TX,     tx_period, ADDR_BASE_LFR & ADDR_LFR_WP_F2_1_ADDR, PARAM_WP_f2_1_addr);
    UART_WRITE            (TX,     tx_period, ADDR_BASE_LFR & ADDR_LFR_WP_F3_0_ADDR, PARAM_WP_f3_0_addr);
    UART_WRITE            (TX,     tx_period, ADDR_BASE_LFR & ADDR_LFR_WP_F3_1_ADDR, PARAM_WP_f3_1_addr);
    RESET_WFP_STATUS      (TX,     tx_period, ADDR_BASE_LFR);
    UART_WRITE(TX   ,tx_period,ADDR_BASE_LFR & ADDR_LFR_WP_DELTASNAPSHOT, DELTA_SNAPSHOT);
    UART_WRITE(TX   ,tx_period,ADDR_BASE_LFR & ADDR_LFR_WP_DELTA_F0,      DELTA_F0);
    UART_WRITE(TX   ,tx_period,ADDR_BASE_LFR & ADDR_LFR_WP_DELTA_F0_2,    DELTA_F0_2);
    UART_WRITE(TX   ,tx_period,ADDR_BASE_LFR & ADDR_LFR_WP_DELTA_F1,      DELTA_F1);
    UART_WRITE(TX   ,tx_period,ADDR_BASE_LFR & ADDR_LFR_WP_DELTA_F2,      DELTA_F2);
    
    UART_WRITE(TX   ,tx_period,ADDR_BASE_LFR & ADDR_LFR_WP_DATA_IN_BUFFER, X"00000A7F");
    UART_WRITE(TX   ,tx_period,ADDR_BASE_LFR & ADDR_LFR_WP_NBSNAPSHOT,     X"00000A80");
    UART_WRITE(TX   ,tx_period,ADDR_BASE_LFR & ADDR_LFR_WP_START_DATE,     X"7FFFFFFF");
    UART_WRITE(TX   ,tx_period,ADDR_BASE_LFR & ADDR_LFR_WP_LENGTH,         X"000001F8");
    
  END;

  PROCEDURE SET_WFP_DATA_SHAPING(
    SIGNAL   TX                       : OUT STD_LOGIC;
    CONSTANT tx_period                : IN  TIME;
    CONSTANT ADDR_BASE_LFR            : IN  STD_LOGIC_VECTOR(31 DOWNTO 8);
    CONSTANT DATA_SHAPING             : IN  STD_LOGIC_VECTOR(4 DOWNTO 0))
  IS
  BEGIN
    UART_WRITE(TX,tx_period,ADDR_BASE_LFR & ADDR_LFR_WP_DATASHAPING, X"000000" & "000" & DATA_SHAPING);
  END;

  PROCEDURE RESET_WFP_BURST_ENABLE(
    SIGNAL   TX                       : OUT STD_LOGIC;
    SIGNAL   RX                       : IN  STD_LOGIC;
    CONSTANT tx_period                : IN  TIME;
    CONSTANT ADDR_BASE_LFR            : IN  STD_LOGIC_VECTOR(31 DOWNTO 8))
  IS
    VARIABLE data_read_v : STD_LOGIC_VECTOR(31 DOWNTO 0);
  BEGIN
    UART_READ (TX,RX,tx_period,ADDR_BASE_LFR & ADDR_LFR_WP_CONTROL, data_read_v);
    UART_WRITE(TX   ,tx_period,ADDR_BASE_LFR & ADDR_LFR_WP_CONTROL, X"000000" & data_read_v(7) & "0000000");
  END;

  PROCEDURE RESET_WFP_STATUS(
    SIGNAL   TX                       : OUT STD_LOGIC;
    CONSTANT tx_period                : IN  TIME;
    CONSTANT ADDR_BASE_LFR            : IN  STD_LOGIC_VECTOR(31 DOWNTO 8))
  IS
  BEGIN
    UART_WRITE(TX   ,tx_period,ADDR_BASE_LFR & ADDR_LFR_WP_STATUS, X"0000FFFF");
  END;
  
  PROCEDURE SET_WFP_BURST_ENABLE_REGISTER(
    SIGNAL   TX                       : OUT STD_LOGIC;
    SIGNAL   RX                       : IN  STD_LOGIC;
    CONSTANT tx_period                : IN  TIME;
    CONSTANT ADDR_BASE_LFR            : IN  STD_LOGIC_VECTOR(31 DOWNTO 8);
    CONSTANT LFR_MODE                 : IN  STD_LOGIC_VECTOR(2 DOWNTO 0))
  IS
    VARIABLE data_read_v : STD_LOGIC_VECTOR(31 DOWNTO 0);
  BEGIN
    CASE LFR_MODE IS
      WHEN LFR_MODE_STANDBY =>
        UART_WRITE(TX   ,tx_period,ADDR_BASE_LFR & ADDR_LFR_WP_CONTROL, X"00000000");
      WHEN LFR_MODE_NORMAL => 
        UART_WRITE(TX   ,tx_period,ADDR_BASE_LFR & ADDR_LFR_WP_CONTROL, X"00000000");
        UART_WRITE(TX   ,tx_period,ADDR_BASE_LFR & ADDR_LFR_WP_CONTROL, X"0000000F");
      WHEN LFR_MODE_BURST => 
        UART_WRITE(TX   ,tx_period,ADDR_BASE_LFR & ADDR_LFR_WP_CONTROL, X"00000040");
        UART_READ (TX,RX,tx_period,ADDR_BASE_LFR & ADDR_LFR_WP_CONTROL, data_read_v);
        UART_WRITE(TX   ,tx_period,ADDR_BASE_LFR & ADDR_LFR_WP_CONTROL, data_read_v(31 DOWNTO 4) & "11" & data_read_v(1 DOWNTO 0));
      WHEN LFR_MODE_SBM1 => 
        UART_WRITE(TX   ,tx_period,ADDR_BASE_LFR & ADDR_LFR_WP_CONTROL, X"00000020");
        UART_READ (TX,RX,tx_period,ADDR_BASE_LFR & ADDR_LFR_WP_CONTROL, data_read_v);
        UART_WRITE(TX   ,tx_period,ADDR_BASE_LFR & ADDR_LFR_WP_CONTROL, data_read_v(31 DOWNTO 4) & "1111");
      WHEN LFR_MODE_SBM2 =>
        UART_WRITE(TX   ,tx_period,ADDR_BASE_LFR & ADDR_LFR_WP_CONTROL, X"00000040");
        UART_READ (TX,RX,tx_period,ADDR_BASE_LFR & ADDR_LFR_WP_CONTROL, data_read_v);
        UART_WRITE(TX   ,tx_period,ADDR_BASE_LFR & ADDR_LFR_WP_CONTROL, data_read_v(31 DOWNTO 4) & "1111");
      WHEN OTHERS =>
        UART_WRITE(TX   ,tx_period,ADDR_BASE_LFR & ADDR_LFR_WP_CONTROL, X"00000000"); 
    END CASE;
  END;

END lpp_lfr_sim_pkg;
