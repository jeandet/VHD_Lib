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
-- Author : Jean-christophe Pellion
-- Mail   : jean-christophe.pellion@lpp.polytechnique.fr
--          jean-christophe.pellion@easii-ic.com
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY lpp;
USE lpp.general_purpose.ALL;

ENTITY lpp_waveform_snapshot_controler IS

  GENERIC (
    delta_vector_size : INTEGER := 20;
    delta_vector_size_f0_2 : INTEGER := 3
    );

  PORT (
    clk                : IN  STD_LOGIC;
    rstn               : IN  STD_LOGIC;
    ---------------------------------------------------------------------------
    --REGISTER CONTROL
    reg_run            : IN  STD_LOGIC;
    reg_start_date     : IN  STD_LOGIC_VECTOR(30 DOWNTO 0);
    reg_delta_snapshot : IN  STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
    reg_delta_f0       : IN  STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
    reg_delta_f0_2     : IN  STD_LOGIC_VECTOR(delta_vector_size_f0_2-1 DOWNTO 0);
    reg_delta_f1       : IN  STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
    reg_delta_f2       : IN  STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
    ---------------------------------------------------------------------------
    -- INPUT
    coarse_time        : IN  STD_LOGIC_VECTOR(30 DOWNTO 0);
    data_f0_valid      : IN  STD_LOGIC;
    data_f2_valid      : IN  STD_LOGIC;
    ---------------------------------------------------------------------------
    -- OUTPUT
    start_snapshot_f0  : OUT STD_LOGIC;
    start_snapshot_f1  : OUT STD_LOGIC;
    start_snapshot_f2  : OUT STD_LOGIC;
    wfp_on             : OUT STD_LOGIC
    );

END lpp_waveform_snapshot_controler;

ARCHITECTURE beh OF lpp_waveform_snapshot_controler IS
  -----------------------------------------------------------------------------
  -- WAVEFORM ON/OFF FSM
  SIGNAL state_on               : STD_LOGIC;
  SIGNAL wfp_on_s               : STD_LOGIC;
  -----------------------------------------------------------------------------
  -- StartSnapshot Generator for f2, f1 and f0_pre
  SIGNAL start_snapshot_f0_pre  : STD_LOGIC;
--  SIGNAL first_decount_s        : STD_LOGIC;
  SIGNAL first_decount          : STD_LOGIC;
  SIGNAL first_init            : STD_LOGIC;
  SIGNAL counter_delta_snapshot : INTEGER;
  -----------------------------------------------------------------------------
  -- StartSnapshot Generator for f0
  SIGNAL counter_delta_f0       : INTEGER;
  SIGNAL send_start_snapshot_f0 : STD_LOGIC;
BEGIN  -- beh
  wfp_on <= wfp_on_s;

  -----------------------------------------------------------------------------
  -- WAVEFORM ON/OFF FSM
  -----------------------------------------------------------------------------
  -- INPUT   reg_run
  --         coarse_time
  --         reg_start_date
  -- OUTPUT  wfp_on_s
  -----------------------------------------------------------------------------
  waveform_on_off_fsm : PROCESS (clk, rstn)
  BEGIN
    IF rstn = '0' THEN
      state_on <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF state_on = '1' THEN            -- Waveform Picker ON
        state_on <= reg_run;
      ELSE                              -- Waveform Picker OFF
        IF coarse_time = reg_start_date THEN
          state_on <= reg_run;
        END IF;
      END IF;
    END IF;
  END PROCESS waveform_on_off_fsm;
  wfp_on_s <= state_on;
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- StartSnapshot Generator for f2, f1 and f0_pre
  -----------------------------------------------------------------------------
  -- INPUT  wfp_on_s
  --        reg_delta_snapshot
  --        reg_delta_f0      
  --        reg_delta_f1      
  --        reg_delta_f2
  --        data_f2_valid
  -- OUTPUT start_snapshot_f0_pre
  --        start_snapshot_f1
  --        start_snapshot_f2
  -----------------------------------------------------------------------------
  --lpp_front_positive_detection_1 : lpp_front_positive_detection
  --  PORT MAP (
  --    clk  => clk,
  --    rstn => rstn,
  --    sin  => wfp_on_s,
  --    sout => first_decount_s);

  Decounter_Cyclic_DeltaSnapshot : PROCESS (clk, rstn)
  BEGIN  -- PROCESS Decounter_Cyclic_DeltaSnapshot
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      counter_delta_snapshot <= 0;
      first_decount          <= '1';
      first_init             <= '1';
      start_snapshot_f0_pre  <= '0';
      start_snapshot_f1      <= '0';
      start_snapshot_f2      <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
      IF wfp_on_s = '0' THEN
        counter_delta_snapshot <= 0;
        first_decount          <= '1';
        first_init             <= '1';
        start_snapshot_f0_pre  <= '0';
        start_snapshot_f1      <= '0';
        start_snapshot_f2      <= '0';
      ELSE
        start_snapshot_f0_pre <= '0';
        start_snapshot_f1     <= '0';
        start_snapshot_f2     <= '0';

        IF data_f2_valid = '1' THEN
          IF first_init = '1' THEN
            counter_delta_snapshot <= to_integer(UNSIGNED(reg_delta_f2));
            first_init             <= '0';
          ELSE
            IF counter_delta_snapshot > 0 THEN
              counter_delta_snapshot <= counter_delta_snapshot - 1;
            ELSE
              counter_delta_snapshot <= to_integer(UNSIGNED(reg_delta_snapshot));
              first_decount          <= '0';
            END IF;
            
            IF counter_delta_snapshot = to_integer(UNSIGNED(reg_delta_f0)) THEN
              IF first_decount = '0' THEN
                start_snapshot_f0_pre <= '1';
              END IF;
            END IF;

            IF counter_delta_snapshot = to_integer(UNSIGNED(reg_delta_f1)) THEN
              IF first_decount = '0' THEN
                start_snapshot_f1 <= '1';
              END IF;
            END IF;

            IF counter_delta_snapshot = 0 THEN
              start_snapshot_f2 <= '1';
            END IF;
          END IF;
        END IF;
      END IF;
    END IF;
  END PROCESS Decounter_Cyclic_DeltaSnapshot;
  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  -- StartSnapshot Generator for f0
  -----------------------------------------------------------------------------
  -- INPUT  wfp_on_s
  --        start_snapshot_f0_pre
  --        reg_delta_snapshot
  --        reg_delta_f0_2
  --        data_f0_valid
  -- OUTPUT start_snapshot_f0
  -----------------------------------------------------------------------------
  Decounter_DeltaSnapshot_f0 : PROCESS (clk, rstn)
  BEGIN  -- PROCESS Decounter_Cyclic_DeltaSnapshot
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      counter_delta_f0       <= 0;
      start_snapshot_f0      <= '0';
      send_start_snapshot_f0 <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
      start_snapshot_f0 <= '0';
      IF wfp_on_s = '0' THEN
        counter_delta_f0       <= 0;
        send_start_snapshot_f0 <= '1';
      ELSE
        IF start_snapshot_f0_pre = '1' THEN
          send_start_snapshot_f0 <= '0';
          counter_delta_f0       <= to_integer(UNSIGNED(reg_delta_f0_2));
        ELSIF data_f0_valid = '1' THEN
          IF counter_delta_f0 > 0 THEN
            send_start_snapshot_f0 <= '0';
            counter_delta_f0       <= counter_delta_f0 - 1;
          ELSE
            IF send_start_snapshot_f0 = '0' THEN
              send_start_snapshot_f0 <= '1';
              start_snapshot_f0      <= '1';
            END IF;
          END IF;
        END IF;
      END IF;
    END IF;
  END PROCESS Decounter_DeltaSnapshot_f0;
  -----------------------------------------------------------------------------

END beh;
