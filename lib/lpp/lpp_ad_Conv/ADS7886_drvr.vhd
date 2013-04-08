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
--                    Author : Alexis Jeandet
--                     Mail : alexis.jeandet@lpp.polytechnique.fr
-------------------------------------------------------------------------------
-- MODIFIED by  Jean-christophe PELLION
--              jean-christophe.pellion@lpp.polytechnique.fr
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
LIBRARY lpp;
USE lpp.lpp_ad_conv.ALL;
USE lpp.general_purpose.SYNC_FF;

ENTITY ADS7886_drvr IS
  GENERIC(
    ChanelCount     : INTEGER;
    ncycle_cnv_high : INTEGER := 79;
    ncycle_cnv      : INTEGER := 500);
  PORT (
    -- CONV --
    cnv_clk   : IN  STD_LOGIC;
    cnv_rstn  : IN  STD_LOGIC;
    cnv_run : IN  STD_LOGIC;
    cnv       : OUT STD_LOGIC;

    -- DATA --
    clk  : IN  STD_LOGIC;
    rstn : IN  STD_LOGIC;
    sck  : OUT STD_LOGIC;
    sdo  : IN  STD_LOGIC_VECTOR(ChanelCount-1 DOWNTO 0);

    sample     : OUT Samples(ChanelCount-1 DOWNTO 0);
    sample_val : OUT STD_LOGIC
    );    
END ADS7886_drvr;

ARCHITECTURE ar_ADS7886_drvr OF ADS7886_drvr IS

  COMPONENT SYNC_FF
    GENERIC (
      NB_FF_OF_SYNC : INTEGER);
    PORT (
      clk    : IN  STD_LOGIC;
      rstn   : IN  STD_LOGIC;
      A      : IN  STD_LOGIC;
      A_sync : OUT STD_LOGIC);
  END COMPONENT;


  SIGNAL cnv_cycle_counter  : INTEGER;
  SIGNAL cnv_s              : STD_LOGIC;
  SIGNAL cnv_sync           : STD_LOGIC;
  SIGNAL cnv_sync_r         : STD_LOGIC;
  SIGNAL cnv_done           : STD_LOGIC;
  SIGNAL sample_bit_counter : INTEGER;
  SIGNAL shift_reg          : Samples(ChanelCount-1 DOWNTO 0);

  SIGNAL cnv_run_sync : STD_LOGIC;
  
BEGIN
  -----------------------------------------------------------------------------
  -- CONV
  -----------------------------------------------------------------------------
  PROCESS (cnv_clk, cnv_rstn)
  BEGIN  -- PROCESS
    IF cnv_rstn = '0' THEN              -- asynchronous reset (active low)
      cnv_cycle_counter <= 0;
      cnv_s             <= '0';
    ELSIF cnv_clk'EVENT AND cnv_clk = '1' THEN  -- rising clock edge
      IF cnv_run = '1' THEN
        IF cnv_cycle_counter < ncycle_cnv THEN
          cnv_cycle_counter <= cnv_cycle_counter +1;
          IF cnv_cycle_counter < ncycle_cnv_high THEN
            cnv_s <= '1';
          ELSE
            cnv_s <= '0';
          END IF;
        ELSE
          cnv_s             <= '1';
          cnv_cycle_counter <= 0;
        END IF;
      ELSE
        cnv_s             <= '0';
        cnv_cycle_counter <= 0;
      END IF;
    END IF;
  END PROCESS;

  cnv <= cnv_s;

  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  -- SYNC CNV
  -----------------------------------------------------------------------------
  
  SYNC_FF_cnv : SYNC_FF
    GENERIC MAP (
      NB_FF_OF_SYNC => 2)
    PORT MAP (
      clk    => clk,
      rstn   => rstn,
      A      => cnv_s,
      A_sync => cnv_sync);

  PROCESS (clk, rstn)
  BEGIN
    IF rstn = '0' THEN
      cnv_sync_r <= '0';
      cnv_done   <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      cnv_sync_r <= cnv_sync;
      cnv_done   <= (NOT cnv_sync) AND cnv_sync_r;
    END IF;
  END PROCESS;

  -----------------------------------------------------------------------------
  
  SYNC_FF_run : SYNC_FF
    GENERIC MAP (
      NB_FF_OF_SYNC => 2)
    PORT MAP (
      clk    => clk,
      rstn   => rstn,
      A      => cnv_run,
      A_sync => cnv_run_sync);


  
  -----------------------------------------------------------------------------
  -- DATA
  -----------------------------------------------------------------------------
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN
      FOR l IN 0 TO ChanelCount-1 LOOP
        shift_reg(l) <= (OTHERS => '0');
      END LOOP;
      sample_bit_counter <= 0;
      sample_val         <= '0';
      SCK                <= '1';
    ELSIF clk'EVENT AND clk = '1' THEN
      
      IF cnv_run_sync = '0' THEN
        sample_bit_counter <= 0;
      ELSIF cnv_done = '1' THEN
        sample_bit_counter <= 1;
      ELSIF sample_bit_counter > 0 AND sample_bit_counter < 32 THEN
        sample_bit_counter <= sample_bit_counter + 1;
      END IF;

      IF (sample_bit_counter MOD 2) = 1 THEN
        FOR l IN 0 TO ChanelCount-1 LOOP
          shift_reg(l)(15)          <= sdo(l);
          shift_reg(l)(14 DOWNTO 0) <= shift_reg(l)(15 DOWNTO 1);
        END LOOP;
        SCK <= '0';
      ELSE
        SCK <= '1';
      END IF;

      IF sample_bit_counter = 31 THEN
        sample_val <= '1';
        FOR l IN 0 TO ChanelCount-1 LOOP
          sample(l)(15)           <= sdo(l);
          sample(l)(14 DOWNTO 0) <= shift_reg(l)(15 DOWNTO 1);
        END LOOP;
      ELSE
        sample_val <= '0';
      END IF;
    END IF;
  END PROCESS;
  
END ar_ADS7886_drvr;

