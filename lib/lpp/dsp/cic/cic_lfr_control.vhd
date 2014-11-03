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
    w_addr_init : OUT STD_LOGIC;
    w_addr_base : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    w_addr_add1 : OUT STD_LOGIC
    );

END cic_lfr_control;

ARCHITECTURE beh OF cic_lfr_control IS

  TYPE STATE_CIC_LFR_TYPE IS (IDLE,INT_0, INT_1, INT_2);
  SIGNAL STATE_CIC_LFR : STATE_CIC_LFR_TYPE;

  SIGNAL nb_data_receipt : INTEGER;
  
BEGIN

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
      w_addr_init <= '0';
      w_addr_base <= (OTHERS => '0');
      w_addr_add1 <= '0';
      --
      nb_data_receipt <= 0;
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
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
        w_addr_init <= '0';
        w_addr_base <= (OTHERS => '0');
        w_addr_add1 <= '0';
        --
        nb_data_receipt <= 0;
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
            w_addr_init <= '0';
            w_addr_base <= (OTHERS => '0');
            w_addr_add1 <= '0';
            IF data_in_valid = '1' THEN
              nb_data_receipt <= 0;
              STATE_CIC_LFR <= INT_0;
            END IF;
          WHEN INT_0 =>
            
          WHEN OTHERS => NULL;
        END CASE;
      END IF;
    END IF;
  END PROCESS;
  
END beh;

