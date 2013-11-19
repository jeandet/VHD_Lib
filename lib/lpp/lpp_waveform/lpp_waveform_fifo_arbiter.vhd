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
    full_almost  : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    full         : IN  STD_LOGIC_VECTOR(3 DOWNTO 0)

    );
END ENTITY;


ARCHITECTURE ar_lpp_waveform_fifo_arbiter OF lpp_waveform_fifo_arbiter IS
  TYPE state_type_fifo_arbiter IS (IDLE,TIME1,TIME2,DATA1,DATA2,DATA3,LAST);
  SIGNAL state : state_type_fifo_arbiter;
  
  -----------------------------------------------------------------------------
  -- DATA MUX
  -----------------------------------------------------------------------------
  SIGNAL data_0_v   : STD_LOGIC_VECTOR(32*5-1 DOWNTO 0);
  SIGNAL data_1_v   : STD_LOGIC_VECTOR(32*5-1 DOWNTO 0);
  SIGNAL data_2_v   : STD_LOGIC_VECTOR(32*5-1 DOWNTO 0);
  SIGNAL data_3_v   : STD_LOGIC_VECTOR(32*5-1 DOWNTO 0);
  TYPE WORD_VECTOR IS ARRAY (NATURAL RANGE <>) OF STD_LOGIC_VECTOR(31 DOWNTO 0); 
  SIGNAL data_0   : WORD_VECTOR(4 DOWNTO 0);
  SIGNAL data_1   : WORD_VECTOR(4 DOWNTO 0);
  SIGNAL data_2   : WORD_VECTOR(4 DOWNTO 0);
  SIGNAL data_3   : WORD_VECTOR(4 DOWNTO 0);
  SIGNAL data_sel : WORD_VECTOR(4 DOWNTO 0);  
  
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
  
  --SIGNAL shift_data_enable : STD_LOGIC;
  --SIGNAL shift_data        : STD_LOGIC_VECTOR(1 DOWNTO 0);
  --SIGNAL shift_data_s      : STD_LOGIC_VECTOR(1 DOWNTO 0);
  
  --SIGNAL shift_time_enable : STD_LOGIC;
  --SIGNAL shift_time        : STD_LOGIC_VECTOR(1 DOWNTO 0);
  --SIGNAL shift_time_s      : STD_LOGIC_VECTOR(1 DOWNTO 0);
  
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
      state <= IDLE;
    ELSIF clk'event AND clk = '1' THEN    -- rising clock edge
      count_enable      <= '0';
      data_in_ack       <= (OTHERS => '0');
      data_out_wen      <= (OTHERS => '1');
      sel_ack           <= '0';
      IF run = '0'  THEN
        state             <= IDLE;
      ELSE
        CASE state IS
          WHEN IDLE  =>
            IF no_sel = '0' THEN
              state <= TIME1;
            END IF;
          WHEN TIME1 =>
            count_enable <= '1';
            IF UNSIGNED(count) = 0 THEN
              state        <= TIME2;
              data_out_wen <= NOT sel;
              data_out     <= data_sel(0);
            ELSE
              state        <= DATA1;    
            END IF;
          WHEN TIME2 =>  
            data_out_wen <= NOT sel;
            data_out     <= data_sel(1)  ;
            state        <= DATA1;
          WHEN DATA1 =>  
            data_out_wen <= NOT sel;
            data_out     <= data_sel(2); 
            state        <= DATA2;
          WHEN DATA2 =>  
            data_out_wen <= NOT sel;
            data_out     <= data_sel(3); 
            state        <= DATA3;
          WHEN DATA3 => 
            data_out_wen <= NOT sel;
            data_out     <= data_sel(4);
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

  
  --PROCESS (clk, rstn)
  --BEGIN  -- PROCESS
  --  IF rstn = '0' THEN                  -- asynchronous reset (active low)
  --    count_enable      <= '0';
  --    shift_time_enable <= '0';
  --    shift_data_enable <= '0';
  --    data_in_ack       <= (OTHERS => '0');
  --    data_out_wen      <= (OTHERS => '1');
  --    sel_ack <= '0';
  --  ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
  --    IF run = '0' OR no_sel = '1' THEN
  --      count_enable      <= '0';
  --      shift_time_enable <= '0';
  --      shift_data_enable <= '0';
  --      data_in_ack       <= (OTHERS => '0');
  --      data_out_wen      <= (OTHERS => '1');
  --      sel_ack <= '0';
  --    ELSE
  --      --COUNT
  --      IF shift_data_s = "10" THEN
  --        count_enable <= '1';
  --      ELSE          
  --        count_enable <= '0';
  --      END IF;
  --      --DATA
  --      IF shift_time_s = "10" THEN
  --        shift_data_enable <= '1';
  --      ELSE
  --        shift_data_enable <= '0';
  --      END IF;

  --      --TIME
  --      IF ((shift_data_s = "10") AND (count = nb_data_by_buffer)) OR
  --        shift_time_s = "00" OR
  --        shift_time_s = "01"
  --      THEN
  --        shift_time_enable <= '1';
  --      ELSE
  --        shift_time_enable <= '0';
  --      END IF;
        
  --      --ACK
  --      IF shift_data_s = "10" THEN
  --        data_in_ack <= sel;
  --        sel_ack <= '1';
  --      ELSE
  --        data_in_ack <= (OTHERS => '0');
  --        sel_ack <= '0';
  --      END IF;
        
  --      --VALID OUT
  --      all_wen: FOR I IN 3 DOWNTO 0 LOOP
  --        IF sel(I) = '1' AND count_enable = '0' THEN
  --          data_out_wen(I) <= '0';
  --        ELSE
  --          data_out_wen(I) <= '1';
  --        END IF;
  --      END LOOP all_wen;

  --    END IF;
  --  END IF;
  --END PROCESS;
  
  -----------------------------------------------------------------------------
  -- DATA MUX
  -----------------------------------------------------------------------------
  all_bit_data_in: FOR I IN 32*5-1 DOWNTO 0 GENERATE
    I_time_in: IF I < 48 GENERATE
      data_0_v(I) <= time_in(0,I);
      data_1_v(I) <= time_in(1,I);
      data_2_v(I) <= time_in(2,I);
      data_3_v(I) <= time_in(3,I);
    END GENERATE I_time_in;
    I_null: IF (I > 47) AND (I < 32*2)  GENERATE
      data_0_v(I) <= '0';
      data_1_v(I) <= '0';
      data_2_v(I) <= '0';
      data_3_v(I) <= '0';
    END GENERATE I_null;
    I_data_in: IF I > 32*2-1  GENERATE
      data_0_v(I) <= data_in(0,I-32*2);
      data_1_v(I) <= data_in(1,I-32*2);
      data_2_v(I) <= data_in(2,I-32*2);
      data_3_v(I) <= data_in(3,I-32*2);
    END GENERATE I_data_in;
  END GENERATE all_bit_data_in;

  all_word: FOR J IN 4 DOWNTO 0 GENERATE
    all_data_bit: FOR I IN 31 DOWNTO 0 GENERATE
        data_0(J)(I) <= data_0_v(J*32+I);      
        data_1(J)(I) <= data_1_v(J*32+I);      
        data_2(J)(I) <= data_2_v(J*32+I);      
        data_3(J)(I) <= data_3_v(J*32+I);      
    END GENERATE all_data_bit;    
  END GENERATE all_word;

  data_sel <= data_0 WHEN sel(0) = '1' ELSE
              data_1 WHEN sel(1) = '1' ELSE
              data_2 WHEN sel(2) = '1' ELSE
              data_3;

  --data_out <= data_sel(0) WHEN shift_time = "00" ELSE
  --            data_sel(1) WHEN shift_time = "01" ELSE
  --            data_sel(2) WHEN shift_data = "00" ELSE
  --            data_sel(3) WHEN shift_data = "01" ELSE
  --            data_sel(4);
              
  
  -----------------------------------------------------------------------------
  -- RR and SELECTION
  -----------------------------------------------------------------------------
  all_input_rr : FOR I IN 3 DOWNTO 0 GENERATE
--    valid_in_rr(I) <= data_in_valid(I) AND NOT full(I);
    valid_in_rr(I) <= data_in_valid(I) AND NOT full_almost(I);
  END GENERATE all_input_rr;

  RR_Arbiter_4_1 : RR_Arbiter_4
    PORT MAP (
      clk       => clk,
      rstn      => rstn,
      in_valid  => valid_in_rr,
      out_grant => sel_s);              --sel_s);

--  sel <= sel_s;
  
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      sel <= "0000";
      sel_reg <= '0';
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      -- sel_reg
      -- sel_ack
      -- sel_s
      -- sel = "0000 "
      --sel <= sel_s;
      IF sel_reg = '0' OR sel_ack = '1'
        --OR shift_data_s = "10"
      THEN
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

  --reg_shift_data_i: lpp_waveform_fifo_arbiter_reg
  --  GENERIC MAP (
  --    data_size => 2,
  --    data_nb   => 4)
  --  PORT MAP (
  --    clk       => clk,
  --    rstn      => rstn,
  --    run       => run,
  --    max_count => "10",                -- 2
  --    enable    => shift_data_enable,
  --    sel       => sel,
  --    data      => shift_data,
  --    data_s    => shift_data_s);


  --reg_shift_time_i: lpp_waveform_fifo_arbiter_reg
  --  GENERIC MAP (
  --    data_size => 2,
  --    data_nb   => 4)
  --  PORT MAP (
  --    clk       => clk,
  --    rstn      => rstn,
  --    run       => run,
  --    max_count => "10",                -- 2
  --    enable    => shift_time_enable,
  --    sel       => sel,
  --    data      => shift_time,
  --    data_s    => shift_time_s);
  
  


END ARCHITECTURE;


























