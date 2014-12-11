
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
USE lpp.lpp_dma_pkg.ALL;
LIBRARY techmap;
USE techmap.gencomp.ALL;


ENTITY lpp_waveform_fsmdma IS
  PORT (
    -- AMBA AHB system signals
    clk  : IN STD_ULOGIC;
    rstn : IN STD_ULOGIC;
    run  : IN STD_LOGIC;

    ---------------------------------------------------------------------------
    -- FIFO - IN
    fifo_buffer_time     : IN  STD_LOGIC_VECTOR(47 DOWNTO 0);
    fifo_data            : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    fifo_empty           : IN  STD_LOGIC;
    fifo_empty_threshold : IN  STD_LOGIC;
    fifo_ren             : OUT STD_LOGIC;

    ---------------------------------------------------------------------------
    -- DMA - OUT
    dma_fifo_valid_burst : OUT STD_LOGIC;
    dma_fifo_data        : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    dma_fifo_ren         : IN  STD_LOGIC;

    dma_buffer_new      : OUT STD_LOGIC;
    dma_buffer_addr     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    dma_buffer_length   : OUT STD_LOGIC_VECTOR(25 DOWNTO 0);
    dma_buffer_full     : IN  STD_LOGIC;
    dma_buffer_full_err : IN  STD_LOGIC;

    ---------------------------------------------------------------------------
    -- Reg In
    status_buffer_ready : IN  STD_LOGIC;
    addr_buffer         : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    length_buffer       : IN  STD_LOGIC_VECTOR(25 DOWNTO 0);
    -- Reg Out
    ready_buffer        : OUT STD_LOGIC;
    buffer_time         : OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
    error_buffer_full   : OUT STD_LOGIC
    );                                      
END;

ARCHITECTURE Behavioral OF lpp_waveform_fsmdma IS

  TYPE   FSM_DMA_STATE IS (IDLE, ONGOING);
  SIGNAL state         : FSM_DMA_STATE;
  SIGNAL burst_valid_s : STD_LOGIC;
  
BEGIN
  burst_valid_s <= NOT fifo_empty_threshold;

  error_buffer_full <= dma_buffer_full_err;

  fifo_ren             <= dma_fifo_ren  WHEN state = ONGOING ELSE '1';
  dma_fifo_data        <= fifo_data;
  dma_fifo_valid_burst <= burst_valid_s WHEN state = ONGOING ELSE '0';

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      state               <= IDLE;
      buffer_time         <= (OTHERS => '0');
      dma_buffer_addr     <= (OTHERS => '0');
      dma_buffer_length   <= (OTHERS => '0');
      dma_buffer_new      <= '0';
      ready_buffer       <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
      ready_buffer <= '0';
      dma_buffer_new      <= '0';
      IF run = '1' THEN
        CASE state IS
          WHEN IDLE =>
            IF fifo_empty = '0' THEN
              IF status_buffer_ready = '0' THEN
                state       <= ONGOING;
                buffer_time <= fifo_buffer_time;
                dma_buffer_addr   <= addr_buffer;
                dma_buffer_length <= length_buffer;
                dma_buffer_new    <= '1';
              END IF;
            END IF;
          WHEN ONGOING =>
            IF dma_buffer_full = '1' THEN
              ready_buffer <= '1';
              state        <= IDLE;
            END IF;
          WHEN OTHERS => NULL;
        END CASE;
      ELSE
        state               <= IDLE;
        buffer_time         <= (OTHERS => '0');
        dma_buffer_addr     <= (OTHERS => '0');
        dma_buffer_length   <= (OTHERS => '0');
        dma_buffer_new      <= '0';
      END IF;
    END IF;
  END PROCESS;
  
END Behavioral;
