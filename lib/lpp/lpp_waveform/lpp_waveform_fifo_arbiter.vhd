------------------------------------------------------------------------------
--  This file is a part of the LPP VHDL IP LIBRARY
--  Copyright (C) 2009 - 2012, Laboratory of Plasmas Physic - CNRS
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
------------------------------------------------------------------------------
--                    Author : Jean-christophe PELLION
--                    Mail   : jean-christophe.pellion@lpp.polytechnique.fr
------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

LIBRARY lpp;
USE lpp.lpp_waveform_pkg.ALL;

ENTITY lpp_waveform_fifo_arbiter IS
  GENERIC(
    tech : INTEGER := 0
    );
  PORT(
    clk  : IN STD_LOGIC;
    rstn : IN STD_LOGIC;

    ---------------------------------------------------------------------------
    data_f0_valid : IN STD_LOGIC;
    data_f1_valid : IN STD_LOGIC;
    data_f2_valid : IN STD_LOGIC;
    data_f3_valid : IN STD_LOGIC;

    data_valid_ack : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);

    data_f0 : IN STD_LOGIC_VECTOR(159 DOWNTO 0);
    data_f1 : IN STD_LOGIC_VECTOR(159 DOWNTO 0);
    data_f2 : IN STD_LOGIC_VECTOR(159 DOWNTO 0);
    data_f3 : IN STD_LOGIC_VECTOR(159 DOWNTO 0);

    ---------------------------------------------------------------------------
    ready : IN STD_LOGIC_VECTOR(3 DOWNTO 0);

    ---------------------------------------------------------------------------
    time_wen : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    data_wen : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    data     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)

    );
END ENTITY;


ARCHITECTURE ar_lpp_waveform_fifo_arbiter OF lpp_waveform_fifo_arbiter IS
  TYPE   state_fsm IS (IDLE, T1, T2, D1, D2);
  SIGNAL state : state_fsm;

  SIGNAL data_valid_and_ready : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL data_selected        : STD_LOGIC_VECTOR(159 DOWNTO 0);
  SIGNAL data_valid_selected  : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL data_ready_to_go     : STD_LOGIC;

  SIGNAL data_temp : STD_LOGIC_VECTOR(32*4-1 DOWNTO 0);
  SIGNAL time_en_temp : STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN

  data_valid_and_ready(0) <= ready(0) AND data_f0_valid;
  data_valid_and_ready(1) <= ready(1) AND data_f1_valid;
  data_valid_and_ready(2) <= ready(2) AND data_f2_valid;
  data_valid_and_ready(3) <= ready(3) AND data_f3_valid;

  data_selected <= data_f0 WHEN data_valid_and_ready(0) = '1' ELSE
                   data_f1 WHEN data_valid_and_ready(1) = '1' ELSE
                   data_f2 WHEN data_valid_and_ready(2) = '1' ELSE
                   data_f3;
  
  data_valid_selected <= "0001" WHEN data_valid_and_ready(0) = '1' ELSE
                         "0010" WHEN data_valid_and_ready(1) = '1' ELSE
                         "0100" WHEN data_valid_and_ready(2) = '1' ELSE
                         "1000" WHEN data_valid_and_ready(3) = '1' ELSE
                         "0000";
  
  data_ready_to_go <= data_valid_and_ready(0) OR
                       data_valid_and_ready(1) OR
                       data_valid_and_ready(2) OR
                       data_valid_and_ready(3);

  PROCESS (clk, rstn)
  BEGIN
    IF rstn = '0' THEN
      state          <= IDLE;
      data_valid_ack <= (OTHERS => '0');
      data_wen       <= (OTHERS => '1');
      time_wen       <= (OTHERS => '1');
      data           <= (OTHERS => '0');
      data_temp      <= (OTHERS => '0');
      time_en_temp   <= (OTHERS => '0');
    ELSIF clk'EVENT AND clk = '1' THEN
      CASE state IS
        WHEN IDLE =>
          data_valid_ack <= (OTHERS => '0');
          time_wen       <= (OTHERS => '1');
          data_wen       <= (OTHERS => '1');
          data           <= (OTHERS => '0');
          data_temp      <= (OTHERS => '0');
          IF data_ready_to_go = '1' THEN
            state          <= T1;
            data_valid_ack <= data_valid_selected;
            time_wen       <= NOT data_valid_selected;
            time_en_temp   <= NOT data_valid_selected;
            data           <= data_selected(31 DOWNTO 0);
            data_temp      <= data_selected(159 DOWNTO 32);
          END IF;
        WHEN T1 =>
          state                      <= T2;
          data_valid_ack             <= (OTHERS => '0');
          data                       <= data_temp(31 DOWNTO 0);
          data_temp(32*3-1 DOWNTO 0) <= data_temp(32*4-1 DOWNTO 32);
          
        WHEN T2 =>
          state                      <= D1;
          time_wen                   <= (OTHERS => '1');
          data_wen                   <= time_en_temp;
          data                       <= data_temp(31 DOWNTO 0);
          data_temp(32*3-1 DOWNTO 0) <= data_temp(32*4-1 DOWNTO 32);
          
        WHEN D1 =>
          state                      <= D2;
          data                       <= data_temp(31 DOWNTO 0);
          data_temp(32*3-1 DOWNTO 0) <= data_temp(32*4-1 DOWNTO 32);
          
        WHEN D2 =>
          state                      <= IDLE;
          data                       <= data_temp(31 DOWNTO 0);
          data_temp(32*3-1 DOWNTO 0) <= data_temp(32*4-1 DOWNTO 32);
          
        WHEN OTHERS => NULL;
      END CASE;
      
    END IF;
  END PROCESS;
    
END ARCHITECTURE;


























