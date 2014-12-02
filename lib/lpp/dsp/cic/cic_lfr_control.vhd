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
    clk                : IN  STD_LOGIC;
    rstn               : IN  STD_LOGIC;
    run                : IN  STD_LOGIC;
    --
    data_in_valid      : IN  STD_LOGIC;
    data_out_16_valid  : OUT STD_LOGIC;
    data_out_256_valid : OUT STD_LOGIC;
    --
    OPERATION          : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );

END cic_lfr_control;

ARCHITECTURE beh OF cic_lfr_control IS

  TYPE STATE_CIC_LFR_TYPE IS (IDLE,
                              RUN_PROG_I,
                              RUN_PROG_C16,
                              RUN_PROG_C256
                              );

  SIGNAL STATE_CIC_LFR : STATE_CIC_LFR_TYPE;

  SIGNAL nb_data_receipt : INTEGER := 0;
  SIGNAL current_cmd     : INTEGER := 0;
  SIGNAL current_channel : INTEGER := 0;
  SIGNAL sample_16_odd   : STD_LOGIC;
  SIGNAL sample_256_odd  : STD_LOGIC;

  TYPE     PROGRAM_ARRAY IS ARRAY (INTEGER RANGE <>) OF STD_LOGIC_VECTOR(13 DOWNTO 0);
  --OPERATION( 8 DOWNTO  0) <= PROGRAM_ARRAY( 8 DOWNTO 0) sauf pour PROG_I(0)
  --OPERATION(13 DOWNTO 12) <= PROGRAM_ARRAY(10 DOWNTO 9)
  --OPERATION(11 DOWNTO  9) <= current_channel
  --OPERATION(14)           <= PROGRAM_ARRAY(11) selon sample_X_odd et l'etat
  CONSTANT PROG : PROGRAM_ARRAY(0 TO 28) :=
    (
      --    BA9876   543210
--PROG I
      "00"&"000111"&"000000" --C0                     --0
      "00"&"000101"&"111000" --78                     --1
      "00"&"000101"&"111000" --78                     --2
      "01"&"000101"&"000010" --42                     --3
      "01"&"000101"&"111010" --7A                     --4
      "01"&"000101"&"111010" --7A                     --5
      "01"&"000101"&"000010" --42                     --6
      "01"&"000101"&"111010" --7A                     --7
      "01"&"000101"&"111010" --7A                     --8
--PROG_C16
      "11"&"001000"&"111000" --38                     --9
      "00"&"100101"&"110001" --71                     --10
      "00"&"100101"&"110001" --71                     --11
      "00"&"100101"&"110001" --71                     --12
      "11"&"010000"&"111000" --38                     --13
      "00"&"100101"&"111111" --7F                     --14
      "00"&"100101"&"110111" --77                     --15
      "00"&"100101"&"110111" --77                     --16
--PROG_C256
      "11"&"001000"&"111000" --38                     --17
      "00"&"100101"&"110001" --71                     --18
      "00"&"100101"&"110001" --71                     --19
      "00"&"100101"&"110001" --71                     --20
      "11"&"010000"&"111000" --38                     --21
      "00"&"100101"&"111111" --7F                     --22
      "00"&"100101"&"110111" --77                     --23
      "00"&"100101"&"110111" --77                     --24
      "11"&"011000"&"111000" --38                     --25
      "00"&"100101"&"111111" --7F                     --26
      "00"&"100101"&"110111" --77                     --27
      "00"&"100101"&"110111" --77                     --28
      );

  
  CONSTANT PROG_START_I    : INTEGER := 0;
  CONSTANT PROG_END_I      : INTEGER := 8;
  CONSTANT PROG_START_C16  : INTEGER := 9;
  CONSTANT PROG_END_C16    : INTEGER := 16;
  CONSTANT PROG_START_C256 : INTEGER := 17;
  CONSTANT PROG_END_C256   : INTEGER := 28;
  
BEGIN

  OPERATION(1 DOWNTO 0) <= PROG(current_cmd)(1 DOWNTO 0);
  OPERATION(2)          <= '0' WHEN STATE_CIC_LFR = IDLE ELSE
                             PROG(current_cmd)(2);
  OPERATION(5 DOWNTO 3) <= STD_LOGIC_VECTOR(to_unsigned(current_channel, 3)) WHEN STATE_CIC_LFR = RUN_PROG_I AND current_cmd = 0 ELSE
                             PROG(current_cmd)(5 DOWNTO 3);
  
  OPERATION(8 DOWNTO 6) <= "000" WHEN STATE_CIC_LFR = IDLE ELSE
                             PROG(current_cmd)(8 DOWNTO 6);
  OPERATION(11 DOWNTO 9)  <= STD_LOGIC_VECTOR(to_unsigned(current_channel, 3));
  OPERATION(13 DOWNTO 12) <= PROG(current_cmd)(10 DOWNTO 9);
  OPERATION(14)           <= PROG(current_cmd)(11) AND sample_16_odd  WHEN STATE_CIC_LFR = RUN_PROG_C16 ELSE
                             PROG(current_cmd)(11) AND sample_256_odd WHEN STATE_CIC_LFR = RUN_PROG_C256 ELSE '0';

  OPERATION(15)           <= PROG(current_cmd)(12);

  data_out_16_valid  <= PROG(current_cmd)(13) WHEN STATE_CIC_LFR = RUN_PROG_C16  ELSE '0';
  data_out_256_valid <= PROG(current_cmd)(13) WHEN STATE_CIC_LFR = RUN_PROG_C256 ELSE '0';
  
  PROCESS (clk, rstn)
  BEGIN
    IF rstn = '0' THEN
      STATE_CIC_LFR      <= IDLE;
      nb_data_receipt    <= 0;
      current_channel    <= 0;
      current_cmd        <= 0;
      sample_16_odd      <= '0';
      sample_256_odd     <= '0';
--      data_out_16_valid  <= '0';
--      data_out_256_valid <= '0';
      
    ELSIF clk'EVENT AND clk = '1' THEN
      
--      data_out_16_valid  <= '0';
--      data_out_256_valid <= '0';
      
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
            IF nb_data_receipt MOD 16 = 15 THEN
              STATE_CIC_LFR <= RUN_PROG_C16;
              current_cmd   <= PROG_START_C16;
              IF current_channel = 0 THEN
                sample_16_odd <= NOT sample_16_odd;
              END IF;
            ELSE
              IF current_channel = 5 THEN
                current_channel <= 0;
                STATE_CIC_LFR   <= IDLE;
              ELSE
                current_cmd     <= PROG_START_I;
                current_channel <= current_channel + 1;
              END IF;
            END IF;
          ELSE
            current_cmd <= current_cmd +1;
          END IF;
          
        WHEN RUN_PROG_C16 =>
          IF current_cmd = PROG_END_C16 THEN
--          data_out_16_valid  <= '1';
            IF nb_data_receipt MOD 256 = 255 THEN
              STATE_CIC_LFR <= RUN_PROG_C256;
              current_cmd   <= PROG_START_C256;
              IF current_channel = 0 THEN
                sample_256_odd <= NOT sample_256_odd;
              END IF;
            ELSE
              IF current_channel = 5 THEN
                current_channel <= 0;
                STATE_CIC_LFR   <= IDLE;
              ELSE
                STATE_CIC_LFR   <= RUN_PROG_I;
                current_cmd     <= PROG_START_I;
                current_channel <= current_channel + 1;
              END IF;
            END IF;
          ELSE
            current_cmd <= current_cmd +1;
          END IF;
          
        WHEN RUN_PROG_C256 =>
          IF current_cmd = PROG_END_C256 THEN
--          data_out_256_valid  <= '1';
            IF current_channel = 5 THEN
              current_channel <= 0;
              STATE_CIC_LFR   <= IDLE;
            ELSE
              STATE_CIC_LFR   <= RUN_PROG_I;
              current_cmd     <= PROG_START_I;
              current_channel <= current_channel + 1;
            END IF;
          ELSE
            current_cmd <= current_cmd +1;
          END IF;
          
        WHEN OTHERS => NULL;
      END CASE;
    END IF;
  END PROCESS;

END beh;
