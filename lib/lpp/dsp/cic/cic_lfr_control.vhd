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
    -- DCBA     98765     43210
    --PROG I------------------
      "0001" & "00011" & "00000",                     --0
      "0101" & "00010" & "00001",                     --1
      "0101" & "00010" & "00001",                     --2
      "0001" & "00010" & "01011",                     --3
      "0101" & "00010" & "01001",                     --4
      "0101" & "00010" & "01001",                     --5
      "0001" & "00010" & "01011",                     --6
      "0101" & "00010" & "01001",                     --7
      "0101" & "00010" & "01001",                     --8
    --PROG_C16                
      "1001" & "00100" & "10010",                     --9
      "1001" & "10010" & "10101",                     --10
      "1001" & "10010" & "10101",                     --11
      "1010" & "10010" & "10101",                     --12
      "1001" & "01000" & "10010",                     --13
      "1001" & "10010" & "11101",                     --14
      "1001" & "10010" & "11101",                     --15
      "1010" & "10010" & "11101",                     --16
    --PROG_C256                
      "1001" & "00100" & "10010",                     --17
      "1001" & "10110" & "10101",                     --18
      "1001" & "10110" & "10101",                     --19
      "1010" & "10110" & "10101",                     --20
      "1001" & "01000" & "10010",                     --21
      "1001" & "10110" & "11101",                     --22
      "1001" & "10110" & "11101",                     --23
      "1010" & "10110" & "11101",                     --24
      "1001" & "01100" & "10010",                     --25
      "1001" & "10110" & "11101",                     --26
      "1001" & "10110" & "11101",                     --27
      "1010" & "10110" & "11101"                      --28
      );

  
  CONSTANT PROG_START_I    : INTEGER := 0;
  CONSTANT PROG_END_I      : INTEGER := 8;
  CONSTANT PROG_START_C16  : INTEGER := 9;
  CONSTANT PROG_END_C16    : INTEGER := 16;
  CONSTANT PROG_START_C256 : INTEGER := 17;
  CONSTANT PROG_END_C256   : INTEGER := 28;
  
BEGIN

  OPERATION(2 DOWNTO 0)   <= STD_LOGIC_VECTOR(to_unsigned(current_channel, 3));                                   --SEL_SAMPLE
  OPERATION(4 DOWNTO 3)   <= PROG(current_cmd)(1 DOWNTO 0);                                                       --SEL_DATA_A
  OPERATION(6 DOWNTO 5)   <= "00" WHEN STATE_CIC_LFR = IDLE ELSE PROG(current_cmd)(3 DOWNTO 2);                                                       --ALU_CMD
  OPERATION(7)            <= '0'  WHEN STATE_CIC_LFR = IDLE ELSE PROG(current_cmd)(4);                                                                --CARRY_PUSH
  OPERATION(8)            <= PROG(current_cmd)(5);                                                                --@_init
  OPERATION(9)            <= PROG(current_cmd)(6);                                                                --@_add_1

  OPERATION(10)           <= PROG(current_cmd)(7)  AND sample_256_odd WHEN STATE_CIC_LFR = RUN_PROG_C256  AND PROG(current_cmd)(9) = '1' ELSE
                             PROG(current_cmd)(7);                        --@_sel(1..0)
  OPERATION(11)           <= PROG(current_cmd)(8);
  OPERATION(12)           <= PROG(current_cmd)(9) AND sample_16_odd  WHEN STATE_CIC_LFR = RUN_PROG_C16  ELSE
                             --PROG(current_cmd)(9) AND sample_256_odd WHEN STATE_CIC_LFR = RUN_PROG_C256 ELSE
                             PROG(current_cmd)(9)                    WHEN STATE_CIC_LFR = RUN_PROG_C256 ELSE
                             '0'; --@_sel(2)

  
  OPERATION(13)           <= '0' WHEN STATE_CIC_LFR = IDLE ELSE PROG(current_cmd)(10);                            --WE
  OPERATION(14)           <= PROG(current_cmd)(12);  -- SEL_DATA_A = data_b_reg
  OPERATION(15)           <= PROG(current_cmd)(13);  -- WRITE_ADDR_sel
  data_out_16_valid       <= PROG(current_cmd)(11) WHEN STATE_CIC_LFR = RUN_PROG_C16  ELSE '0';
  data_out_256_valid      <= PROG(current_cmd)(11) WHEN STATE_CIC_LFR = RUN_PROG_C256 ELSE '0';
  








  
  --OPERATION(1 DOWNTO 0) <= PROG(current_cmd)(1 DOWNTO 0);
  --OPERATION(2)          <= '0' WHEN STATE_CIC_LFR = IDLE ELSE
  --                           PROG(current_cmd)(2);
  --OPERATION(5 DOWNTO 3) <= STD_LOGIC_VECTOR(to_unsigned(current_channel, 3)) WHEN STATE_CIC_LFR = RUN_PROG_I AND current_cmd = 0 ELSE
  --                           PROG(current_cmd)(5 DOWNTO 3);
  
  --OPERATION(8 DOWNTO 6) <= "000" WHEN STATE_CIC_LFR = IDLE ELSE
  --                           PROG(current_cmd)(8 DOWNTO 6);
  --OPERATION(11 DOWNTO 9)  <= STD_LOGIC_VECTOR(to_unsigned(current_channel, 3));
  --OPERATION(13 DOWNTO 12) <= PROG(current_cmd)(10 DOWNTO 9);
  --OPERATION(14)           <= PROG(current_cmd)(11) AND sample_16_odd  WHEN STATE_CIC_LFR = RUN_PROG_C16 ELSE
  --                           PROG(current_cmd)(11) AND sample_256_odd WHEN STATE_CIC_LFR = RUN_PROG_C256 ELSE '0';

  --OPERATION(15)           <= PROG(current_cmd)(12);

  --data_out_16_valid  <= PROG(current_cmd)(13) WHEN STATE_CIC_LFR = RUN_PROG_C16  ELSE '0';
  --data_out_256_valid <= PROG(current_cmd)(13) WHEN STATE_CIC_LFR = RUN_PROG_C256 ELSE '0';
  
  PROCESS (clk, rstn)
  BEGIN
    IF rstn = '0' THEN
      STATE_CIC_LFR      <= IDLE;
      nb_data_receipt    <= 0;
      current_channel    <= 0;
      current_cmd        <= 0;
      sample_16_odd      <= '0';
      sample_256_odd     <= '0';
      
    ELSIF clk'EVENT AND clk = '1' THEN
      
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
