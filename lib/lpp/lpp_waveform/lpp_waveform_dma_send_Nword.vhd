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
----------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
LIBRARY grlib;
USE grlib.amba.ALL;
USE grlib.stdlib.ALL;
USE grlib.devices.ALL;
USE GRLIB.DMA2AHB_Package.ALL;
LIBRARY lpp;
USE lpp.lpp_amba.ALL;
USE lpp.apb_devices_list.ALL;
USE lpp.lpp_memory.ALL;
LIBRARY techmap;
USE techmap.gencomp.ALL;

ENTITY lpp_waveform_dma_send_Nword IS
  PORT (
    -- AMBA AHB system signals
    HCLK    : IN STD_ULOGIC;
    HRESETn : IN STD_ULOGIC;

    -- DMA
    DMAIn  : OUT DMA_In_Type;
    DMAOut : IN  DMA_OUt_Type;

    --
    Nb_word_less1 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    -- 
    send    : IN  STD_LOGIC;
    address : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    data    : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    ren     : OUT STD_LOGIC;
    --
    send_ok : OUT STD_LOGIC;
    send_ko : OUT STD_LOGIC
    );  
END lpp_waveform_dma_send_Nword;

ARCHITECTURE beh OF lpp_waveform_dma_send_Nword IS
  
  TYPE   state_fsm_send_Nword IS (IDLE, REQUEST_BUS, SEND_DATA, ERROR0, ERROR1, WAIT_LAST_READY);
  SIGNAL state : state_fsm_send_Nword;

  SIGNAL data_counter  : INTEGER;
  SIGNAL grant_counter : INTEGER;
  
BEGIN  -- beh

  DMAIn.Beat <= HINCR16;
  DMAIn.Size <= HSIZE32;

  PROCESS (HCLK, HRESETn)
  BEGIN  -- PROCESS
    IF HRESETn = '0' THEN               -- asynchronous reset (active low)
      state   <= IDLE;
      send_ok <= '0';
      send_ko <= '0';

      DMAIn.Reset   <= '0';
      DMAIn.Address <= (OTHERS => '0');
      DMAIn.Request <= '0';
      DMAIn.Store   <= '0';
      DMAIn.Burst   <= '1';
      DMAIn.Lock    <= '0';
      data_counter  <= 0;
    ELSIF HCLK'EVENT AND HCLK = '1' THEN  -- rising clock edge
      
      CASE state IS
        WHEN IDLE =>
          DMAIn.Store   <= '1';
          DMAIn.Request <= '0';
          send_ok       <= '0';
          send_ko       <= '0';
          DMAIn.Address <= address;
          data_counter  <= 0;
          DMAIn.Lock    <= '0';         -- FIX test
          IF send = '1' THEN
            state         <= REQUEST_BUS;
            DMAIn.Request <= '1';
            DMAIn.Lock    <= '1';       -- FIX test
            DMAIn.Store   <= '1';
          END IF;
        WHEN REQUEST_BUS =>
          IF DMAOut.Grant = '1' THEN
            data_counter  <= 1;
            grant_counter <= 1;
            state         <= SEND_DATA;
          END IF;
        WHEN SEND_DATA =>
          
          IF DMAOut.Fault = '1' THEN
            DMAIn.Reset   <= '0';
            DMAIn.Address <= (OTHERS => '0');
            DMAIn.Request <= '0';
            DMAIn.Store   <= '0';
            DMAIn.Burst   <= '0';
            state         <= ERROR0;
          ELSE
            
            IF DMAOut.Grant = '1' THEN
              IF grant_counter = UNSIGNED(Nb_word_less1) THEN  --
                DMAIn.Reset   <= '0';
                DMAIn.Request <= '0';
                DMAIn.Store   <= '0';
                DMAIn.Burst   <= '0';
              ELSE
                grant_counter <= grant_counter+1;
              END IF;
            END IF;

            IF DMAOut.OKAY = '1' THEN
              IF data_counter = UNSIGNED(Nb_word_less1) THEN
                DMAIn.Address <= (OTHERS => '0');
                state         <= WAIT_LAST_READY;
              ELSE
                data_counter <= data_counter + 1;
              END IF;
            END IF;
          END IF;
          
          
        WHEN WAIT_LAST_READY =>
          IF DMAOut.Ready = '1' THEN
            IF grant_counter = UNSIGNED(Nb_word_less1) THEN
              state   <= IDLE;
              send_ok <= '1';
              send_ko <= '0';
            ELSE
              state <= ERROR0;
            END IF;
          END IF;
          
        WHEN ERROR0 =>
          state <= ERROR1;
        WHEN ERROR1 =>
          send_ok <= '0';
          send_ko <= '1';
          state   <= IDLE;
        WHEN OTHERS => NULL;
      END CASE;
    END IF;
  END PROCESS;

  DMAIn.Data <= data;

  ren <= '0' WHEN DMAOut.OKAY = '1' AND state = SEND_DATA ELSE
         '0' WHEN state = REQUEST_BUS AND DMAOut.Grant = '1' ELSE
         '1';
  
END beh;
