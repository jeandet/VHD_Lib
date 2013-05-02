
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
-- 1.0 - initial version
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;


ENTITY lpp_waveform_dma_selectaddress IS
  GENERIC (
    nb_burst_available_size : INTEGER := 11
    );
  PORT (
    HCLK    : IN STD_ULOGIC;
    HRESETn : IN STD_ULOGIC;

    update : IN STD_LOGIC_VECTOR(1 DOWNTO 0);

    nb_burst_available : IN STD_LOGIC_VECTOR(nb_burst_available_size-1 DOWNTO 0);
    addr_data_reg      : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

    addr_data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

    status_full     : OUT STD_LOGIC;
    status_full_ack : IN  STD_LOGIC;
    status_full_err : OUT STD_LOGIC
    );                                      
END;

ARCHITECTURE Behavioral OF lpp_waveform_dma_selectaddress IS
  TYPE   state_fsm_select_data IS (IDLE, ADD, FULL, ERR, UPDATED);
  SIGNAL state : state_fsm_select_data;

  SIGNAL address      : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL nb_send      : STD_LOGIC_VECTOR(nb_burst_available_size-1 DOWNTO 0);
  SIGNAL nb_send_next : STD_LOGIC_VECTOR(nb_burst_available_size-1 DOWNTO 0);

  SIGNAL update_s : STD_LOGIC;
  SIGNAL update_r : STD_LOGIC_VECTOR(1 DOWNTO 0);
BEGIN

  update_s <= update(0) OR update(1);

  addr_data    <= address;
  nb_send_next <= STD_LOGIC_VECTOR(UNSIGNED(nb_send) + 1);

  FSM_SELECT_ADDRESS : PROCESS (HCLK, HRESETn)
  BEGIN
    IF HRESETn = '0' THEN
      state           <= IDLE;
      address         <= (OTHERS => '0');
      nb_send         <= (OTHERS => '0');
      status_full     <= '0';
      status_full_err <= '0';
      update_r        <= "00";
    ELSIF HCLK'EVENT AND HCLK = '1' THEN
      update_r        <= update;
      CASE state IS
        WHEN IDLE =>
          IF update_s = '1' THEN
            state <= ADD;
          END IF;

        WHEN ADD =>
          IF UNSIGNED(nb_send_next) < UNSIGNED(nb_burst_available) THEN
            state <= IDLE;
            IF update_r = "10" THEN
              address <= STD_LOGIC_VECTOR(UNSIGNED(address) + 64);
              nb_send <= nb_send_next;
            ELSIF update_r = "01" THEN
              address <= STD_LOGIC_VECTOR(UNSIGNED(address) + 4);
            END IF;
          ELSE
            state       <= FULL;
            nb_send     <= (OTHERS => '0');
            status_full <= '1';
          END IF;
          
        WHEN FULL =>
          status_full <= '0';
          IF status_full_ack = '1' THEN
            IF update_s = '1' THEN
              status_full_err <= '1';
            END IF;
            state <= UPDATED;
          ELSE
            IF update_s = '1' THEN
              status_full_err <= '1';
              state           <= ERR;
            END IF;
          END IF;
          
        WHEN ERR =>
          status_full_err <= '0';
          IF status_full_ack = '1' THEN
            state <= UPDATED;
          END IF;
          
        WHEN UPDATED =>
          status_full_err <= '0';
          state           <= IDLE;
          address         <= addr_data_reg;
          
        WHEN OTHERS => NULL;
      END CASE;
    END IF;
  END PROCESS FSM_SELECT_ADDRESS;
  
END Behavioral;
