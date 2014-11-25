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
--                             jean-christophe.pellion@easii-ic.com
----------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;


LIBRARY lpp;
USE lpp.cic_pkg.ALL;
USE lpp.data_type_pkg.ALL;

ENTITY cic_lfr_control IS
  PORT (
    clk            : IN  STD_LOGIC;
    rstn           : IN  STD_LOGIC;
    run            : IN  STD_LOGIC;
    --
    data_in_valid      : IN  STD_LOGIC;
    data_out_16_valid  : OUT STD_LOGIC;
    data_out_256_valid : OUT STD_LOGIC;
    --
    OPERATION          : OUT STD_LOGIC_VECTOR(14 DOWNTO 0)
    );

END cic_lfr_control;

ARCHITECTURE beh OF cic_lfr_control IS

  TYPE STATE_CIC_LFR_TYPE IS (IDLE,
                              RUN_PROG_I,
                              RUN_PROG_C16,
                              RUN_PROG_C256
                              );
  
  SIGNAL STATE_CIC_LFR     : STATE_CIC_LFR_TYPE;

  SIGNAL nb_data_receipt : INTEGER := 0;
  SIGNAL current_cmd : INTEGER := 0;
  SIGNAL current_channel : INTEGER := 0;
  SIGNAL sample_16_odd : STD_LOGIC;
  SIGNAL sample_256_odd : STD_LOGIC;

  TYPE PROGRAM_ARRAY IS ARRAY (INTEGER RANGE <>) OF STD_LOGIC_VECTOR(11 DOWNTO 0);
  --OPERATION( 8 DOWNTO  0) <= PROGRAM_ARRAY( 8 DOWNTO 0) sauf pour PROG_I(0)
  --OPERATION(13 DOWNTO 12) <= PROGRAM_ARRAY(10 DOWNTO 9)
  --OPERATION(11 DOWNTO  9) <= current_channel
  --OPERATION(14)           <= PROGRAM_ARRAY(11) selon sample_X_odd et l'etat
  CONSTANT PROG : PROGRAM_ARRAY(0 TO 28) :=
    (
      --PROG I
      "0001"&X"C0",                        --0
      "0001"&X"70",                        --1
      "0001"&X"70",                        --2
      "0001"&X"7A",                        --3
      "0001"&X"7A",                        --4
      "0001"&X"7A",                        --5
      "0001"&X"7A",                        --6
      "0001"&X"7A",                        --7
      "0001"&X"7A",                        --8
      --PROG_C16
      "0010"&X"38",                        --9
      "1001"&X"71",                        --10
      "1001"&X"71",                        --11
      "1001"&X"71",                        --12
      "0100"&X"38",                        --13
      "1001"&X"77",                        --14
      "1001"&X"77",                        --15
      "1001"&X"77",                        --16
      --PROG_C256
      "0010"&X"38",                        --17
      "1001"&X"71",                        --18
      "1001"&X"71",                        --19
      "1001"&X"71",                        --20
      "0100"&X"38",                        --21
      "1001"&X"77",                        --22
      "1001"&X"77",                        --23
      "1001"&X"77",                        --24
      "0110"&X"38",                        --25
      "1001"&X"77",                        --26
      "1001"&X"77",                        --27
      "1001"&X"77"                         --28
     );

  
  CONSTANT PROG_START_I    : INTEGER := 0;
  CONSTANT PROG_END_I      : INTEGER := 8;
  CONSTANT PROG_START_C16  : INTEGER := 9;
  CONSTANT PROG_END_C16    : INTEGER := 16;
  CONSTANT PROG_START_C256 : INTEGER := 17;
  CONSTANT PROG_END_C256   : INTEGER := 28;
  
BEGIN

  OPERATION( 1 DOWNTO  0) <= PROG(current_cmd)( 1 DOWNTO 0);
  OPERATION( 2 )          <= '0' WHEN STATE_CIC_LFR = IDLE ELSE
                             PROG(current_cmd)( 2 );
  OPERATION( 5 DOWNTO  3) <= STD_LOGIC_VECTOR(to_unsigned(current_channel,3)) WHEN STATE_CIC_LFR = RUN_PROG_I AND current_cmd = 0 ELSE
                             PROG(current_cmd)(5 DOWNTO  3);
  OPERATION( 8 DOWNTO  6) <= "000" WHEN STATE_CIC_LFR = IDLE ELSE
                             PROG(current_cmd)( 8 DOWNTO 6);
  OPERATION(11 DOWNTO  9) <= STD_LOGIC_VECTOR(to_unsigned(current_channel,3));
  OPERATION(13 DOWNTO 12) <= PROG(current_cmd)(10 DOWNTO 9);  
  OPERATION(14)           <= PROG(current_cmd)(11) AND sample_16_odd  WHEN STATE_CIC_LFR = RUN_PROG_C16  ELSE
                             PROG(current_cmd)(11) AND sample_256_odd WHEN STATE_CIC_LFR = RUN_PROG_C256 ELSE '0';

  PROCESS (clk, rstn)
  BEGIN
    IF rstn = '0' THEN
      STATE_CIC_LFR <= IDLE;
      nb_data_receipt <= 0;
      current_channel <= 0;
      current_cmd     <= 0;
      sample_16_odd <= '0';
      sample_256_odd <= '0';
      data_out_16_valid  <= '0';
      data_out_256_valid  <= '0';
      
    ELSIF clk'event AND clk = '1' THEN
      data_out_16_valid  <= '0';
      data_out_256_valid  <= '0';
      CASE STATE_CIC_LFR IS
        WHEN IDLE =>
          IF data_in_valid = '1' THEN
            STATE_CIC_LFR   <= RUN_PROG_I;
            current_cmd     <= PROG_START_I;
            current_channel <= 0;
            nb_data_receipt <= nb_data_receipt + 1;
          END IF;
          
        WHEN RUN_PROG_I =>
          IF current_cmd = PROG_END_I THEN
            IF current_channel = 5 THEN
              current_channel <= 0;
              IF nb_data_receipt MOD 16 = 0 THEN
                STATE_CIC_LFR   <= RUN_PROG_C16;
                current_cmd     <= PROG_START_C16;     
                sample_16_odd   <= NOT sample_16_odd;
              ELSE
                STATE_CIC_LFR   <= IDLE;
              END IF;              
            ELSE
              current_channel <= current_channel +1;
              current_cmd     <= PROG_START_I;
            END IF;
          ELSE
            current_cmd <= current_cmd +1;
          END IF;
          
        WHEN RUN_PROG_C16 =>
          IF current_cmd = PROG_END_C16 THEN
            data_out_16_valid <= '1';
            IF current_channel = 5 THEN
              current_channel <= 0;
              IF nb_data_receipt MOD 256 = 0 THEN 
                sample_256_odd  <= NOT sample_256_odd;
                STATE_CIC_LFR   <= RUN_PROG_C256;
                current_cmd     <= PROG_START_C256;     
              ELSE
                STATE_CIC_LFR   <= IDLE;
              END IF;              
            ELSE
              current_channel <= current_channel +1;
              current_cmd     <= PROG_START_C16;
            END IF;
          ELSE
            current_cmd <= current_cmd +1;
          END IF;
                    
        WHEN RUN_PROG_C256 =>
          IF current_cmd = PROG_END_C256 THEN
            data_out_256_valid <= '1';
            IF current_channel = 5 THEN
              nb_data_receipt <= 0;
              current_channel <= 0;
              STATE_CIC_LFR   <= IDLE;
            ELSE
              current_channel <= current_channel +1;
              current_cmd     <= PROG_START_C256;
            END IF;
          ELSE
            current_cmd <= current_cmd +1;
          END IF;
          
        WHEN OTHERS => NULL;
      END CASE;
    END IF;
  END PROCESS;

END beh;
