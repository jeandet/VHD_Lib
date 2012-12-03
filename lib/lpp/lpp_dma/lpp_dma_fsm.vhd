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
LIBRARY lpp;
USE lpp.lpp_amba.ALL;
USE lpp.apb_devices_list.ALL;
USE lpp.lpp_memory.ALL;
LIBRARY techmap;
USE techmap.gencomp.ALL;

ENTITY lpp_dma_fsm IS
  PORT (
    -- AMBA AHB system signals
    HCLK    : IN STD_ULOGIC;
    HRESETn : IN STD_ULOGIC;

    -- AMBA APB Slave Interface
    apbi : IN  apb_slv_in_type;
    apbo : OUT apb_slv_out_type;

    -- AMBA AHB Master Interface
    AHB_Master_In  : IN  AHB_Mst_In_Type;
    AHB_Master_Out : OUT AHB_Mst_Out_Type;

    -- fifo interface
    fifo_data  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    fifo_empty : IN  STD_LOGIC;
    fifo_ren   : OUT STD_LOGIC;

    -- header
    header     : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    header_val : IN  STD_LOGIC;
    header_ack : OUT STD_LOGIC;


    -- OUT
    ready_matrix_f0_0             : OUT STD_LOGIC;  -- TODO
    ready_matrix_f0_1             : OUT STD_LOGIC;  -- TODO
    ready_matrix_f1               : OUT STD_LOGIC;  -- TODO
    ready_matrix_f2               : OUT STD_LOGIC;  -- TODO
    error_anticipating_empty_fifo : OUT STD_LOGIC;  -- TODO
    error_bad_component_error     : OUT STD_LOGIC;  -- TODO

    -- IN
    status_ready_matrix_f0_0             : IN STD_LOGIC;
    status_ready_matrix_f0_1             : IN STD_LOGIC;
    status_ready_matrix_f1               : IN STD_LOGIC;
    status_ready_matrix_f2               : IN STD_LOGIC;
    status_error_anticipating_empty_fifo : IN STD_LOGIC;  -- TODO
    status_error_bad_component_error     : IN STD_LOGIC;  -- TODO

    config_active_interruption_onNewMatrix : IN STD_LOGIC;
    config_active_interruption_onError     : IN STD_LOGIC;
    addr_matrix_f0_0                       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_matrix_f0_1                       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_matrix_f1                         : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_matrix_f2                         : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END lpp_dma_fsm;

ARCHITECTURE beh OF lpp_dma_fsm IS
  -----------------------------------------------------------------------------
  -- HEADER check and update
  -----------------------------------------------------------------------------
  SIGNAL send_matrix_val : STD_LOGIC;
  SIGNAL current_header : STD_LOGIC_VECTOR(31 DOWNTO 0);
  -----------------------------------------------------------------------------
  SIGNAL send_matrix    : STD_LOGIC;
  SIGNAL trash_matrix   : STD_LOGIC;
  SIGNAL get_new_header : STD_LOGIC;
  -----------------------------------------------------------------------------
  -- CONTROL SEND COMPONENT
  -----------------------------------------------------------------------------
  TYPE   state_fsm_send_component IS (IDLE,
                                      CHECK_HEADER,
                                      TRASH_FIFO,
                                      
                                      PACKET_IDLE,REQUEST_BUS,SEND_DATA_nextADDRESS,FAULT1,FAULT2);
BEGIN  -- beh

  -----------------------------------------------------------------------------
  -- HEADER check and update
  -----------------------------------------------------------------------------
  
  PROCESS (HCLK, HRESETn)
  BEGIN  -- PROCESS
    IF HRESETn = '0' THEN                 -- asynchronous reset (active low)
      current_header <= (OTHERS => '0');
      header_ack     <= '0';
    ELSIF HCLK'EVENT AND HCLK = '1' THEN  -- rising clock edge
      IF get_new_header = '1' AND header_val = '1' THEN
        IF send_matrix_val = '1' THEN
          current_header <= header;
          header_ack     <= '1';
          send_matrix    <= component_val;
          trash_matrix   <= (NOT component_val) OR (trash_matrix AND NOT (header(5 DOWNTO 2) = "0000"));
        END IF;
      ELSE
        current_header <= current_header;
        header_ack     <= '0';
        send_matrix    <= '0';
        trash_matrix   <= '0';
      END IF;
    END IF;
  END PROCESS;

  send_matrix_val <= '1' WHEN header(1 DOWNTO 0) = "00" AND status_ready_matrix_f0_0 = '0' ELSE
                     '1' WHEN header(1 DOWNTO 0) = "01" AND status_ready_matrix_f0_1 = '0' ELSE
                     '1' WHEN header(1 DOWNTO 0) = "10" AND status_ready_matrix_f1 = '0'   ELSE
                     '1' WHEN header(1 DOWNTO 0) = "11" AND status_ready_matrix_f2 = '0'   ELSE
                     '0';

  component_val <= '0' WHEN header(5 DOWNTO 2) = "1111" ELSE
                   '1' WHEN header(5 DOWNTO 2) = "0000"                              ELSE
                   '1' WHEN header(5 DOWNTO 2) = current_header(5 DOWNTO 2) + "0001" ELSE
                   '0';

  --OUT
  --send_matrix
  --trash_matrix

  --IN
  --get_new_header

  -----------------------------------------------------------------------------
  -- CONTROL SEND COMPONENT
  -----------------------------------------------------------------------------
  fsm_send_component: PROCESS (HCLK, HRESETn)
  BEGIN  -- PROCESS fsm_send_component
    IF HRESETn = '0' THEN               -- asynchronous reset (active low)
      
    ELSIF HCLK'event AND HCLK = '1' THEN  -- rising clock edge
      
    END IF;
  END PROCESS fsm_send_component;
  
  
END beh;
