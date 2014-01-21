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
-------------------------------------------------------------------------------
-- MODIFIED by  Paul LEROY
--              paul.leroy@lpp.polytechnique.fr
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
LIBRARY lpp;
USE lpp.lpp_ad_conv.ALL;

ENTITY ADS7886_drvr_v2 IS
  GENERIC(
    ChannelCount	: INTEGER	:= 8;
    NbBitsSamples	: INTEGER	:= 16);
  PORT (
    -- CONV --
    cnv_clk   : IN  STD_LOGIC;
    cnv_rstn  : IN  STD_LOGIC;
    -- DATA --
    clk  : IN  STD_LOGIC;
    rstn : IN  STD_LOGIC;
    sck  : OUT STD_LOGIC;
    sdo  : IN  STD_LOGIC_VECTOR(ChannelCount-1 DOWNTO 0);
	-- SAMPLE --
    sample     : OUT Samples(ChannelCount-1 DOWNTO 0);
    sample_val : OUT STD_LOGIC
    );    
END ADS7886_drvr_v2;

ARCHITECTURE ar_ADS7886_drvr_v2 OF ADS7886_drvr_v2 IS

  SIGNAL cnv_sync           : STD_LOGIC;
  SIGNAL cnv_sync_r         : STD_LOGIC;
  SIGNAL cnv_done           : STD_LOGIC;
  SIGNAL sample_bit_counter : INTEGER;
  SIGNAL shift_reg          : Samples(ChannelCount-1 DOWNTO 0);
  
BEGIN

cnv_sync <= cnv_clk;

  PROCESS (clk, rstn)		-- falling edge detection on cnv_sync
  BEGIN
    IF rstn = '0' THEN
      cnv_sync_r <= '1';
      cnv_done   <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      cnv_sync_r <= cnv_sync;
      cnv_done   <= (NOT cnv_sync) AND cnv_sync_r;
    END IF;
  END PROCESS;

  -----------------------------------------------------------------------------
  -- DATA
  -----------------------------------------------------------------------------
  
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN
      FOR k IN 0 TO ChannelCount-1 LOOP
        shift_reg(k)(15 downto 0)	<= (OTHERS => '0');
		sample(k)(15 downto 0) 		<= (OTHERS => '0');
      END LOOP;
      sample_bit_counter <= 0;
      sample_val         <= '0';
      SCK                <= '1';
    ELSIF clk'EVENT AND clk = '1' THEN
	  IF (cnv_done = '1') AND (sample_bit_counter = 0) THEN
        sample_bit_counter <= 1;
      ELSIF sample_bit_counter > 0 AND sample_bit_counter < 31 THEN
        sample_bit_counter <= sample_bit_counter + 1;
	  ELSIF sample_bit_counter = 31 THEN
        sample_val <= '1';
        FOR k IN 0 TO ChannelCount-1 LOOP
          sample(k)(0)           <= sdo(k);
          sample(k)(15 DOWNTO 1) <= shift_reg(k)(14 DOWNTO 0);
        END LOOP;
		sample_bit_counter <= 0;
      ELSE
        sample_val <= '0';
      END IF;

      IF (sample_bit_counter MOD 2) = 1 THEN	-- get data on each channel
        FOR k IN 0 TO ChannelCount-1 LOOP
          shift_reg(k)(0)           <= sdo(k);
          shift_reg(k)(15 DOWNTO 1) <= shift_reg(k)(14 DOWNTO 0);
        END LOOP;
        SCK <= '0';
      ELSE
        SCK <= '1';
      END IF;
    END IF;
  END PROCESS;
  
END ar_ADS7886_drvr_v2;