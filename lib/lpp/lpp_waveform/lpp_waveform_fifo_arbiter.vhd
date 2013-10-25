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
USE lpp.general_purpose.ALL;

ENTITY lpp_waveform_fifo_arbiter IS
  GENERIC(
    tech : INTEGER := 0;
    nb_data_by_buffer_size : INTEGER
    );
  PORT(
    clk               : IN  STD_LOGIC;
    rstn              : IN  STD_LOGIC;
    ---------------------------------------------------------------------------
    run               : IN  STD_LOGIC;
    nb_data_by_buffer : IN  STD_LOGIC_VECTOR(nb_data_by_buffer_size - 1 DOWNTO 0);
    ---------------------------------------------------------------------------
    -- SNAPSHOT INTERFACE (INPUT)
    ---------------------------------------------------------------------------
    data_in_valid     : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    data_in_ack       : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    data_in           : IN  Data_Vector(3 DOWNTO 0, 95 DOWNTO 0);
    time_in           : IN  Data_Vector(3 DOWNTO 0, 47 DOWNTO 0);

    ---------------------------------------------------------------------------
    -- FIFO INTERFACE (OUTPUT)
    ---------------------------------------------------------------------------
    data_out     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    data_out_wen : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    full         : IN  STD_LOGIC_VECTOR(3 DOWNTO 0)

    );
END ENTITY;


ARCHITECTURE ar_lpp_waveform_fifo_arbiter OF lpp_waveform_fifo_arbiter IS

  -----------------------------------------------------------------------------
  -- DATA FLOW
  -----------------------------------------------------------------------------
  TYPE WORD_VECTOR IS ARRAY (NATURAL RANGE <>) OF STD_LOGIC_VECTOR(31 DOWNTO 0); 
  SIGNAL time_temp_0      : WORD_VECTOR(3 DOWNTO 0);  
  SIGNAL time_temp_1      : WORD_VECTOR(3 DOWNTO 0); 
  SIGNAL data_temp_0      : WORD_VECTOR(3 DOWNTO 0);  
  SIGNAL data_temp_1      : WORD_VECTOR(3 DOWNTO 0);  
  SIGNAL data_temp_2      : WORD_VECTOR(3 DOWNTO 0); 
  SIGNAL data_temp_v      : WORD_VECTOR(3 DOWNTO 0);
  SIGNAL sel_input        : STD_LOGIC_VECTOR(3 DOWNTO 0);
  -----------------------------------------------------------------------------
  -- CHANNEL SELECTION (RoundRobin)
  -----------------------------------------------------------------------------
  SIGNAL valid_in_rr      : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL valid_out_rr     : STD_LOGIC_VECTOR(3 DOWNTO 0);
  -----------------------------------------------------------------------------
  -- FSM CONTROL
  -----------------------------------------------------------------------------
  TYPE   Counter_Vector IS ARRAY (NATURAL RANGE <>) OF INTEGER;
  SIGNAL reg_shift_data   : Counter_Vector(3 DOWNTO 0);
  SIGNAL reg_shift_time   : Counter_Vector(3 DOWNTO 0);
  SIGNAL reg_count_data   : Counter_Vector(3 DOWNTO 0);
  -- SHIFT_DATA ---------------------------------------------------------------
  SIGNAL shift_data_pre   : INTEGER;
  SIGNAL shift_data       : INTEGER;
  SIGNAL reg_shift_data_s : Counter_Vector(3 DOWNTO 0);
  -- SHIFT_TIME ---------------------------------------------------------------
  SIGNAL shift_time_pre   : INTEGER;
  SIGNAL shift_time       : INTEGER;
  SIGNAL reg_shift_time_s : Counter_Vector(3 DOWNTO 0);
  -- COUNT_DATA ---------------------------------------------------------------
  SIGNAL count_data_pre   : INTEGER;
  SIGNAL count_data       : INTEGER;
  SIGNAL reg_count_data_s : Counter_Vector(3 DOWNTO 0);
    
BEGIN

  -----------------------------------------------------------------------------
  -- DATA FLOW
  -----------------------------------------------------------------------------

  
  all_input : FOR I IN 3 DOWNTO 0 GENERATE
    
    all_bit_of_time: FOR J IN 31 DOWNTO 0 GENERATE
      time_temp_0(I)(J) <= time_in(I,J);
      J_47DOWNTO32: IF J+32 < 48 GENERATE
        time_temp_1(I)(J) <= time_in(I,32+J);
      END GENERATE J_47DOWNTO32;
      J_63DOWNTO48: IF J+32 > 47 GENERATE
        time_temp_1(I)(J) <= '0';
      END GENERATE J_63DOWNTO48; 
      data_temp_0(I)(J) <= data_in(I,J);
      data_temp_1(I)(J) <= data_in(I,J+32);
      data_temp_2(I)(J) <= data_in(I,J+32*2);
    END GENERATE all_bit_of_time;
    
    data_temp_v(I) <= time_temp_0(I)                     WHEN shift_time = 0 ELSE
                      time_temp_1(I)                     WHEN shift_time = 1 ELSE
                      data_temp_0(I)            WHEN shift_data = 0 ELSE
                      data_temp_1(I)           WHEN shift_data = 1 ELSE
                      data_temp_2(I);
  END GENERATE all_input;

  data_out <= data_temp_v(0) WHEN sel_input = "0001" ELSE
              data_temp_v(1) WHEN sel_input = "0010" ELSE
              data_temp_v(2) WHEN sel_input = "0100" ELSE
              data_temp_v(3);

  -----------------------------------------------------------------------------
  -- CHANNEL SELECTION (RoundRobin)
  -----------------------------------------------------------------------------
  all_input_rr : FOR I IN 3 DOWNTO 0 GENERATE
--    valid_in_rr(I) <= data_in_valid(I) AND NOT full_almost(I);
    valid_in_rr(I) <= data_in_valid(I) AND NOT full(I);
  END GENERATE all_input_rr;

  RR_Arbiter_4_1 : RR_Arbiter_4
    PORT MAP (
      clk       => clk,
      rstn      => rstn,
      in_valid  => valid_in_rr,
      out_grant => valid_out_rr);

  -----------------------------------------------------------------------------
  -- FSM CONTROL
  -----------------------------------------------------------------------------

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      reg_shift_data <= (0, 0, 0, 0);
      reg_shift_time <= (0, 0, 0, 0);
      reg_count_data <= (0, 0, 0, 0);
      sel_input      <= (OTHERS => '0');
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
      IF run = '0' THEN
        reg_shift_data <= (0, 0, 0, 0);
        reg_shift_time <= (0, 0, 0, 0);
        reg_count_data <= (0, 0, 0, 0);
        sel_input      <= (OTHERS => '0');
      ELSE
        sel_input <= valid_out_rr;

        IF count_data_pre = 0 THEN      -- first buffer data
          IF shift_time_pre < 2 THEN    -- TIME not completly send
            reg_shift_time <= reg_shift_time_s;
          ELSE
            reg_shift_data <= reg_shift_data_s;
            IF shift_data_pre = 2 THEN
              reg_count_data <= reg_count_data_s;
            END IF;
          END IF;
        ELSE
          reg_shift_data <= reg_shift_data_s;
          IF shift_data_pre = 2 THEN
            reg_count_data <= reg_count_data_s;
            IF count_data = 0 THEN
              reg_shift_time <= reg_shift_time_s;
            END IF;
          END IF;
        END IF;
      END IF;
    END IF;
  END PROCESS;

  -----------------------------------------------------------------------------
  data_out_wen <= NOT sel_input;
  data_in_ack  <= sel_input;

  -- SHIFT_DATA ---------------------------------------------------------------
  shift_data_pre <= reg_shift_data(0) WHEN valid_out_rr(0) = '1' ELSE
                    reg_shift_data(1) WHEN valid_out_rr(1) = '1' ELSE
                    reg_shift_data(2) WHEN valid_out_rr(2) = '1' ELSE
                    reg_shift_data(3);

  shift_data <= shift_data_pre + 1 WHEN shift_data_pre < 2 ELSE 0;

  reg_shift_data_s(0) <= shift_data WHEN valid_out_rr(0) = '1' ELSE reg_shift_data_s(0);
  reg_shift_data_s(1) <= shift_data WHEN valid_out_rr(1) = '1' ELSE reg_shift_data_s(1);
  reg_shift_data_s(2) <= shift_data WHEN valid_out_rr(2) = '1' ELSE reg_shift_data_s(2);
  reg_shift_data_s(3) <= shift_data WHEN valid_out_rr(3) = '1' ELSE reg_shift_data_s(3);

  -- SHIFT_TIME ---------------------------------------------------------------
  shift_time_pre <= reg_shift_time(0) WHEN valid_out_rr(0) = '1' ELSE
                    reg_shift_time(1) WHEN valid_out_rr(1) = '1' ELSE
                    reg_shift_time(2) WHEN valid_out_rr(2) = '1' ELSE
                    reg_shift_time(3);

  shift_time <= shift_time_pre + 1 WHEN shift_time_pre < 2 ELSE 0;

  reg_shift_time_s(0) <= shift_time WHEN valid_out_rr(0) = '1' ELSE reg_shift_time_s(0);
  reg_shift_time_s(1) <= shift_time WHEN valid_out_rr(1) = '1' ELSE reg_shift_time_s(1);
  reg_shift_time_s(2) <= shift_time WHEN valid_out_rr(2) = '1' ELSE reg_shift_time_s(2);
  reg_shift_time_s(3) <= shift_time WHEN valid_out_rr(3) = '1' ELSE reg_shift_time_s(3);

  -- COUNT_DATA ---------------------------------------------------------------
  count_data_pre <= reg_count_data(0) WHEN valid_out_rr(0) = '1' ELSE
                    reg_count_data(1) WHEN valid_out_rr(1) = '1' ELSE
                    reg_count_data(2) WHEN valid_out_rr(2) = '1' ELSE
                    reg_count_data(3);

  count_data <= count_data_pre + 1 WHEN count_data_pre < UNSIGNED(nb_data_by_buffer) ELSE 0;

  reg_count_data_s(0) <= count_data WHEN valid_out_rr(0) = '1' ELSE reg_count_data_s(0);
  reg_count_data_s(1) <= count_data WHEN valid_out_rr(1) = '1' ELSE reg_count_data_s(1);
  reg_count_data_s(2) <= count_data WHEN valid_out_rr(2) = '1' ELSE reg_count_data_s(2);
  reg_count_data_s(3) <= count_data WHEN valid_out_rr(3) = '1' ELSE reg_count_data_s(3);
  -----------------------------------------------------------------------------
  
END ARCHITECTURE;


























