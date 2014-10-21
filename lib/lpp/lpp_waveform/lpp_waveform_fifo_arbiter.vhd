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
    nb_data_by_buffer_size : INTEGER := 11
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
    full_almost  : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    full         : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);

    ---------------------------------------------------------------------------
    -- TIME INTERFACE (OUTPUT)
    ---------------------------------------------------------------------------
    time_out     : OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
    time_out_new : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)    

    );
END ENTITY;


ARCHITECTURE ar_lpp_waveform_fifo_arbiter OF lpp_waveform_fifo_arbiter IS
  TYPE state_type_fifo_arbiter IS (IDLE,DATA1,DATA2,DATA3,LAST);
  SIGNAL state : state_type_fifo_arbiter;
  
  -----------------------------------------------------------------------------
  -- DATA MUX
  -----------------------------------------------------------------------------
  TYPE WORD_VECTOR IS ARRAY (NATURAL RANGE <>) OF STD_LOGIC_VECTOR(31 DOWNTO 0); 
  SIGNAL data_0   : WORD_VECTOR(3 DOWNTO 0);
  SIGNAL data_1   : WORD_VECTOR(3 DOWNTO 0);
  SIGNAL data_2   : WORD_VECTOR(3 DOWNTO 0);
  SIGNAL data_3   : WORD_VECTOR(3 DOWNTO 0);
  SIGNAL data_sel : WORD_VECTOR(3 DOWNTO 0);  
  
  -----------------------------------------------------------------------------
  -- RR and SELECTION
  -----------------------------------------------------------------------------
  SIGNAL valid_in_rr : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL sel         : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL sel_s         : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL sel_reg : STD_LOGIC;
  SIGNAL sel_ack : STD_LOGIC;
  SIGNAL no_sel      : STD_LOGIC;
  
  -----------------------------------------------------------------------------
  -- REG
  -----------------------------------------------------------------------------
  SIGNAL count_enable : STD_LOGIC;
  SIGNAL count        : STD_LOGIC_VECTOR(nb_data_by_buffer_size-1 DOWNTO 0);
  SIGNAL count_s      : STD_LOGIC_VECTOR(nb_data_by_buffer_size-1 DOWNTO 0);

  SIGNAL time_sel : STD_LOGIC_VECTOR(47 DOWNTO 0);
  
BEGIN
  
  -----------------------------------------------------------------------------
  -- CONTROL
  -----------------------------------------------------------------------------
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                    -- asynchronous reset (active low)
      count_enable      <= '0';
      data_in_ack       <= (OTHERS => '0');
      data_out_wen      <= (OTHERS => '1');
      sel_ack           <= '0';
      state             <= IDLE;
      time_out          <= (OTHERS => '0');
      time_out_new      <= (OTHERS => '0');
    ELSIF clk'event AND clk = '1' THEN    -- rising clock edge
      count_enable      <= '0';
      data_in_ack       <= (OTHERS => '0');
      data_out_wen      <= (OTHERS => '1');
      sel_ack           <= '0';
      time_out_new      <= (OTHERS => '0');
      IF run = '0'  THEN
        state             <= IDLE;
        time_out     <= (OTHERS => '0');
      ELSE
        CASE state IS
          WHEN IDLE  =>
            IF no_sel = '0' THEN
              state <= DATA1;
            END IF;
          WHEN DATA1 =>
            count_enable <= '1';
            IF UNSIGNED(count) = 0 THEN
              time_out     <= time_sel;
              time_out_new <= sel;
            END IF;
            data_out_wen <= NOT sel;
            data_out     <= data_sel(0); 
            state        <= DATA2;
          WHEN DATA2 =>  
            data_out_wen <= NOT sel;
            data_out     <= data_sel(1); 
            state        <= DATA3;
          WHEN DATA3 => 
            data_out_wen <= NOT sel;
            data_out     <= data_sel(2);
            state        <= LAST;
            data_in_ack  <= sel;
          WHEN LAST =>
            state         <= IDLE;
            sel_ack       <= '1';
            
          WHEN OTHERS => NULL;
        END CASE;
      END IF;
    END IF;
  END PROCESS;
  -----------------------------------------------------------------------------
  
  -----------------------------------------------------------------------------
  -- DATA MUX
  -----------------------------------------------------------------------------

  all_word: FOR J IN 2 DOWNTO 0 GENERATE
    all_data_bit: FOR I IN 31 DOWNTO 0 GENERATE
        data_0(J)(I) <= data_in(0,I+32*J);
        data_1(J)(I) <= data_in(1,I+32*J);
        data_2(J)(I) <= data_in(2,I+32*J);
        data_3(J)(I) <= data_in(3,I+32*J);
    END GENERATE all_data_bit;    
  END GENERATE all_word;

  data_sel <= data_0 WHEN sel(0) = '1' ELSE
              data_1 WHEN sel(1) = '1' ELSE
              data_2 WHEN sel(2) = '1' ELSE
              data_3;

  all_time_bit: FOR I IN 3 DOWNTO 0 GENERATE
    time_sel(I) <= time_in(0,I) WHEN sel(0) = '1' ELSE
                   time_in(1,I) WHEN sel(1) = '1' ELSE
                   time_in(2,I) WHEN sel(2) = '1' ELSE
                   time_in(3,I);
  END GENERATE all_time_bit;
              
  
  -----------------------------------------------------------------------------
  -- RR and SELECTION
  -----------------------------------------------------------------------------
  all_input_rr : FOR I IN 3 DOWNTO 0 GENERATE
    valid_in_rr(I) <= data_in_valid(I) AND NOT full_almost(I);
  END GENERATE all_input_rr;

  RR_Arbiter_4_1 : RR_Arbiter_4
    PORT MAP (
      clk       => clk,
      rstn      => rstn,
      in_valid  => valid_in_rr,
      out_grant => sel_s);
  
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      sel <= "0000";
      sel_reg <= '0';
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      IF sel_reg = '0' OR sel_ack = '1' THEN
        sel <= sel_s;
        IF sel_s = "0000" THEN
          sel_reg <= '0';
        ELSE
          sel_reg <= '1';
        END IF;
      END IF;
    END IF;
  END PROCESS;
  
  no_sel <= '1' WHEN sel = "0000" ELSE '0';

  -----------------------------------------------------------------------------
  -- REG
  -----------------------------------------------------------------------------
  reg_count_i: lpp_waveform_fifo_arbiter_reg
    GENERIC MAP (
      data_size => nb_data_by_buffer_size,
      data_nb   => 4)
    PORT MAP (
      clk       => clk,
      rstn      => rstn,
      run       => run,
      max_count => nb_data_by_buffer,
      enable    => count_enable,
      sel       => sel,
      data      => count,
      data_s    => count_s);
  
  


END ARCHITECTURE;

























