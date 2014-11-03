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
    -- dataflow
    sel_sample  : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    --
    op_valid    : OUT STD_LOGIC;
    op_ADD_SUBn : OUT STD_LOGIC;
    --
    r_addr_init : OUT STD_LOGIC;
    r_addr_base : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    r_addr_add1 : OUT STD_LOGIC;
    --
    w_en        : OUT STD_LOGIC;
    w_addr_init : OUT STD_LOGIC;
    w_addr_base : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    w_addr_add1 : OUT STD_LOGIC
    );

END cic_lfr_control;

ARCHITECTURE beh OF cic_lfr_control IS

  TYPE STATE_CIC_LFR_TYPE IS (IDLE,
                              
                              INT_0_d0,      INT_1_d0,      INT_2_d0,
                              INT_0_d1,      INT_1_d1,      INT_2_d1,
                              INT_0_d2,      INT_1_d2,      INT_2_d2,
                              
                              WAIT_INT_to_COMB_16,
                              
                              COMB_0_16_d0,  COMB_1_16_d0,  COMB_2_16_d0,
                              COMB_0_16_d1,  COMB_1_16_d1,  COMB_2_16_d1,
                              
                              COMB_0_256_d0, COMB_1_256_d0, COMB_2_256_d0,
                              COMB_0_256_d1, COMB_1_256_d1, COMB_2_256_d1,
                              COMB_0_256_d2, COMB_1_256_d2, COMB_2_256_d2,
                              
                              READ_INT_2_d0,
                              READ_INT_2_d1
                              );
  SIGNAL STATE_CIC_LFR : STATE_CIC_LFR_TYPE;

  SIGNAL nb_data_receipt : INTEGER;
  SIGNAL current_channel : INTEGER;

  TYPE ARRAY_OF_ADDR IS ARRAY (5 DOWNTO 0) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
  
  SIGNAL   base_addr_INT   : ARRAY_OF_ADDR;
  CONSTANT base_addr_delta : INTEGER := 40;
BEGIN

  all_channel: FOR I IN 5 DOWNTO 0 GENERATE
    all_bit: FOR J IN 7 DOWNTO 0 GENERATE
      base_addr_INT(I)(J) <= '1' WHEN (base_addr_delta * I/(2**J)) MOD 2 = 1 ELSE '0';
    END GENERATE all_bit;
  END GENERATE all_channel;

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      STATE_CIC_LFR      <= IDLE;
      --
      data_out_16_valid  <= '0';
      data_out_256_valid <= '0';
      --
      sel_sample  <= (OTHERS => '0');
      --
      op_valid    <= '0';
      op_ADD_SUBn <= '0';
      --
      r_addr_init <= '0';
      r_addr_base <= (OTHERS => '0');
      r_addr_add1 <= '0';
      --
      w_en        <= '1';
      w_addr_init <= '0';
      w_addr_base <= (OTHERS => '0');
      w_addr_add1 <= '0';
      --
      nb_data_receipt <= 0;
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      data_out_16_valid  <= '0';
      data_out_256_valid <= '0';
      op_valid    <= '0';
      op_ADD_SUBn <= '0';
      r_addr_init <= '0';
      r_addr_base <= (OTHERS => '0');
      r_addr_add1 <= '0';
      w_en        <= '1';
      w_addr_init <= '0';
      w_addr_base <= (OTHERS => '0');
      w_addr_add1 <= '0';

      IF run = '0' THEN
        STATE_CIC_LFR      <= IDLE;
        --
        data_out_16_valid  <= '0';
        data_out_256_valid <= '0';
        --
        sel_sample  <= (OTHERS => '0');
        --
        op_valid    <= '0';
        op_ADD_SUBn <= '0';
        --
        r_addr_init <= '0';
        r_addr_base <= (OTHERS => '0');
        r_addr_add1 <= '0';
        --
        w_en        <= '1';
        w_addr_init <= '0';
        w_addr_base <= (OTHERS => '0');
        w_addr_add1 <= '0';
        --
        nb_data_receipt <= 0;
        current_channel   <= 0;
      ELSE
        CASE STATE_CIC_LFR IS
          WHEN IDLE => 
            data_out_16_valid  <= '0';
            data_out_256_valid <= '0';
            --
            sel_sample  <= (OTHERS => '0');
            --
            op_valid    <= '0';
            op_ADD_SUBn <= '0';
            --
            r_addr_init <= '0';
            r_addr_base <= (OTHERS => '0');
            r_addr_add1 <= '0';
            --
            w_en        <= '1';
            w_addr_init <= '0';
            w_addr_base <= (OTHERS => '0');
            w_addr_add1 <= '0';
            --
            IF data_in_valid = '1' THEN
              nb_data_receipt   <= nb_data_receipt+1;
              current_channel   <= 0;
              STATE_CIC_LFR     <= INT_0_d0;
            END IF;

            -------------------------------------------------------------------
          WHEN INT_0_d0 =>
            sel_sample    <= STD_LOGIC_VECTOR(to_unsigned(current_channel, 3));
            STATE_CIC_LFR <= INT_0_d1;
            r_addr_init   <= '1';
            r_addr_base   <= base_addr_INT(current_channel);
            
            
          WHEN INT_0_d1 =>
            STATE_CIC_LFR <= INT_0_d2;
            r_addr_add1   <= '1';
            
          WHEN INT_0_d2 =>
            STATE_CIC_LFR <= INT_1_d0;
            r_addr_add1   <= '1';
            op_ADD_SUBn   <= '1';
            op_valid      <= '1';
                           
          WHEN INT_1_d0 => STATE_CIC_LFR <= INT_1_d1;
          WHEN INT_1_d1 => STATE_CIC_LFR <= INT_1_d2;
          WHEN INT_1_d2 => STATE_CIC_LFR <= INT_2_d0;
                        
          WHEN INT_2_d0 => STATE_CIC_LFR <= INT_2_d1;
          WHEN INT_2_d1 => STATE_CIC_LFR <= INT_2_d2;
          WHEN INT_2_d2 => 
            IF nb_data_receipt = 256 THEN
              STATE_CIC_LFR <= COMB_0_256_d0;
            ELSIF (nb_data_receipt mod 16) = 0 THEN
              STATE_CIC_LFR   <= WAIT_INT_to_COMB_16;
            ELSE
              IF current_channel = 5 THEN
                STATE_CIC_LFR   <= IDLE;
              ELSE
                current_channel <= current_channel +1;
                STATE_CIC_LFR   <= INT_0_d0;
              END IF;
            END IF;

            -------------------------------------------------------------------
          WHEN WAIT_INT_to_COMB_16 =>
            STATE_CIC_LFR   <= COMB_0_16_d0;

          WHEN COMB_0_16_d0 => STATE_CIC_LFR <= COMB_0_16_d1;
          WHEN COMB_0_16_d1 => STATE_CIC_LFR <= COMB_1_16_d0;
                               
          WHEN COMB_1_16_d0 => STATE_CIC_LFR <= COMB_1_16_d1;
          WHEN COMB_1_16_d1 => STATE_CIC_LFR <= COMB_2_16_d0;

          WHEN COMB_2_16_d0 => STATE_CIC_LFR <= COMB_2_16_d1;
          WHEN COMB_2_16_d1 =>
            IF current_channel = 5 THEN
              STATE_CIC_LFR <= IDLE;
              IF nb_data_receipt = 256 THEN
                nb_data_receipt   <= 0;
              END IF;
            ELSE
              current_channel <= current_channel +1;
              STATE_CIC_LFR   <= INT_0_d0;
            END IF;

            -------------------------------------------------------------------
          WHEN COMB_0_256_d0 => STATE_CIC_LFR <= COMB_0_256_d1;
          WHEN COMB_0_256_d1 => STATE_CIC_LFR <= COMB_0_256_d2;
          WHEN COMB_0_256_d2 => STATE_CIC_LFR <= COMB_1_256_d0;
                             
          WHEN COMB_1_256_d0 => STATE_CIC_LFR <= COMB_1_256_d1;
          WHEN COMB_1_256_d1 => STATE_CIC_LFR <= COMB_1_256_d2;
          WHEN COMB_1_256_d2 => STATE_CIC_LFR <= COMB_2_256_d0;
                             
          WHEN COMB_2_256_d0 => STATE_CIC_LFR <= COMB_2_256_d1;
          WHEN COMB_2_256_d1 => STATE_CIC_LFR <= COMB_2_256_d2;
          WHEN COMB_2_256_d2 => STATE_CIC_LFR <= READ_INT_2_d0;

            -------------------------------------------------------------------
          WHEN READ_INT_2_d0 => STATE_CIC_LFR <= READ_INT_2_d1;
          WHEN READ_INT_2_d1 => STATE_CIC_LFR <= COMB_0_16_d0;
            
          WHEN OTHERS => NULL;
        END CASE;
      END IF;
    END IF;
  END PROCESS;
  
END beh;

