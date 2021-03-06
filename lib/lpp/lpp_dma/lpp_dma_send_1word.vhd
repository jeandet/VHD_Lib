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

ENTITY lpp_dma_send_1word IS
  PORT (
    -- AMBA AHB system signals
    HCLK    : IN STD_ULOGIC;
    HRESETn : IN STD_ULOGIC;

    -- DMA
    DMAIn  : OUT DMA_In_Type;
    DMAOut : IN  DMA_OUt_Type;
    -- 
    send    : IN  STD_LOGIC;
    address : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    data    : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    ren     : OUT STD_LOGIC;
    --
    send_ok : OUT STD_LOGIC;
    send_ko : OUT STD_LOGIC
    );  
END lpp_dma_send_1word;

ARCHITECTURE beh OF lpp_dma_send_1word IS
  
  TYPE   state_fsm_send_1word IS (IDLE, REQUEST_BUS, SEND_DATA, ERROR0, ERROR1);
  SIGNAL state : state_fsm_send_1word;
  
BEGIN  -- beh

  DMAIn.Reset   <= '0';
  DMAIn.Address <= address;
  DMAIn.Data    <= data;
  DMAIn.Beat    <= (OTHERS => '0');
  DMAIn.Size    <= HSIZE32;
  DMAIn.Burst   <= '0';

  PROCESS (HCLK, HRESETn)
  BEGIN  -- PROCESS
    IF HRESETn = '0' THEN                 -- asynchronous reset (active low)
      state        <= IDLE;
      DMAIn.Request <= '0';
      DMAIn.Store   <= '0';
      send_ok      <= '0';
      send_ko      <= '0';
      DMAIn.Lock    <= '0';
      ren <= '1';
    ELSIF HCLK'EVENT AND HCLK = '1' THEN  -- rising clock edge
      ren <= '1';
      CASE state IS
        WHEN IDLE =>
          DMAIn.Store   <= '1';
          DMAIn.Request <= '0';
          send_ok      <= '0';
          send_ko      <= '0';
          DMAIn.Lock    <= '0';
          IF send = '1' THEN
            DMAIn.Request <= '1';
            DMAIn.Lock    <= '1';
            state        <= REQUEST_BUS;
          END IF;
        WHEN REQUEST_BUS =>
          IF DMAOut.Grant = '1' THEN
            DMAIn.Request <= '0';
            DMAIn.Store   <= '0';
            state        <= SEND_DATA;
            ren <= '0';
          END IF;
        WHEN SEND_DATA =>
          IF DMAOut.Fault = '1' THEN
            DMAIn.Request <= '0';
            DMAIn.Store   <= '0';
            state        <= ERROR0;
          ELSIF DMAOut.Ready = '1' THEN
            DMAIn.Request <= '0';
            DMAIn.Store   <= '0';
            send_ok       <= '1';
            send_ko       <= '0';
            state         <= IDLE;
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

END beh;
