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


ENTITY lpp_waveform_dma_genvalid IS
  PORT (
    HCLK    : IN STD_LOGIC;
    HRESETn : IN STD_LOGIC;
    run     : IN STD_LOGIC;

    valid_in : IN STD_LOGIC;
    time_in  : IN STD_LOGIC_VECTOR(47 DOWNTO 0);

    ack_in    : IN  STD_LOGIC;
    valid_out : OUT STD_LOGIC;
    time_out  : OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
    error     : OUT STD_LOGIC
    );                                      
END;

ARCHITECTURE Behavioral OF lpp_waveform_dma_genvalid IS
  TYPE   state_fsm IS (IDLE, VALID);
  SIGNAL state : state_fsm;
BEGIN

  FSM_SELECT_ADDRESS : PROCESS (HCLK, HRESETn)
  BEGIN
    IF HRESETn = '0' THEN
      state     <= IDLE;
      valid_out <= '0';
      error     <= '0';
      time_out  <= (OTHERS => '0');
    ELSIF HCLK'EVENT AND HCLK = '1' THEN
      IF run = '1' THEN
        CASE state IS
          WHEN IDLE =>
            
            valid_out <= valid_in;
            error     <= '0';
            time_out  <= time_in;

            IF valid_in = '1' THEN
              state <= VALID;
            END IF;

          WHEN VALID =>
            IF valid_in = '1' THEN
              IF ack_in = '1' THEN
                state     <= VALID;
                valid_out <= '1';
                time_out  <= time_in;
              ELSE
                state     <= IDLE;
                error     <= '1';
                valid_out <= '0';
              END IF;
            ELSIF ack_in = '1' THEN
              state     <= IDLE;
              valid_out <= '0';
            END IF;
            
          WHEN OTHERS => NULL;
        END CASE;

      ELSE
        state     <= IDLE;
        valid_out <= '0';
        error     <= '0';
        time_out  <= (OTHERS => '0');
      END IF;
    END IF;
  END PROCESS FSM_SELECT_ADDRESS;
  
END Behavioral;
