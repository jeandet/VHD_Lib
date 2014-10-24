
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


ENTITY lpp_lfr_ms_fsmdma IS
  PORT (
    -- AMBA AHB system signals
    clk                  : IN  STD_ULOGIC;
    rstn                 : IN  STD_ULOGIC;
    run                  : IN  STD_LOGIC;

    ---------------------------------------------------------------------------
    -- FIFO - IN
    fifo_matrix_type     : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
    fifo_matrix_time     : IN  STD_LOGIC_VECTOR(47 DOWNTO 0);
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
    status_ready_matrix_f0 : IN STD_LOGIC;
    status_ready_matrix_f1 : IN STD_LOGIC;
    status_ready_matrix_f2 : IN STD_LOGIC;

    addr_matrix_f0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_matrix_f1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_matrix_f2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

    length_matrix_f0 : IN STD_LOGIC_VECTOR(25 DOWNTO 0);
    length_matrix_f1 : IN STD_LOGIC_VECTOR(25 DOWNTO 0);
    length_matrix_f2 : IN STD_LOGIC_VECTOR(25 DOWNTO 0);

    -- Reg Out
    ready_matrix_f0 : OUT STD_LOGIC;
    ready_matrix_f1 : OUT STD_LOGIC;
    ready_matrix_f2 : OUT STD_LOGIC;

    matrix_time_f0    : OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
    matrix_time_f1    : OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
    matrix_time_f2    : OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
    error_buffer_full : OUT STD_LOGIC
    );                                      
END;

ARCHITECTURE Behavioral OF lpp_lfr_ms_fsmdma IS

  TYPE   FSM_DMA_STATE IS (IDLE, ONGOING);
  SIGNAL state         : FSM_DMA_STATE;
  SIGNAL burst_valid_s : STD_LOGIC;

  SIGNAL current_matrix_type : STD_LOGIC_VECTOR(1 DOWNTO 0);
  
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
      current_matrix_type <= "00";
      matrix_time_f0      <= (OTHERS => '0');
      matrix_time_f1      <= (OTHERS => '0');
      matrix_time_f2      <= (OTHERS => '0');
      dma_buffer_addr     <= (OTHERS => '0');
      dma_buffer_length   <= (OTHERS => '0');
      dma_buffer_new      <= '0';
      ready_matrix_f0     <= '0';
      ready_matrix_f1     <= '0';
      ready_matrix_f2     <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
      ready_matrix_f0 <= '0';
      ready_matrix_f1 <= '0';
      ready_matrix_f2 <= '0';
      IF run = '1' THEN
        dma_buffer_new      <= '0';
        CASE state IS
          WHEN IDLE =>
            IF fifo_empty = '0' THEN
              current_matrix_type <= fifo_matrix_type;
              CASE fifo_matrix_type IS
                WHEN "00" =>
                  IF status_ready_matrix_f0 = '0' THEN
                    state             <= ONGOING;
                    matrix_time_f0    <= fifo_matrix_time;
                    dma_buffer_addr   <= addr_matrix_f0;
                    dma_buffer_length <= length_matrix_f0;
                    dma_buffer_new    <= '1';
                  END IF;
                WHEN "01" =>
                  IF status_ready_matrix_f1 = '0' THEN
                    state             <= ONGOING;
                    matrix_time_f1    <= fifo_matrix_time;
                    dma_buffer_addr   <= addr_matrix_f1;
                    dma_buffer_length <= length_matrix_f1;
                    dma_buffer_new    <= '1';
                  END IF;
                WHEN "10" =>
                  IF status_ready_matrix_f2 = '0' THEN
                    state             <= ONGOING;
                    matrix_time_f2    <= fifo_matrix_time;
                    dma_buffer_addr   <= addr_matrix_f2;
                    dma_buffer_length <= length_matrix_f2;
                    dma_buffer_new    <= '1';
                  END IF;
                WHEN OTHERS => NULL;
              END CASE;
            END IF;
          WHEN ONGOING =>
            IF dma_buffer_full = '1' THEN
              CASE current_matrix_type IS
                WHEN "00"   => ready_matrix_f0 <= '1'; state <= IDLE;
                WHEN "01"   => ready_matrix_f1 <= '1'; state <= IDLE;
                WHEN "10"   => ready_matrix_f2 <= '1'; state <= IDLE;
                WHEN OTHERS => NULL;
              END CASE;
            END IF;
          WHEN OTHERS => NULL;
        END CASE;
      ELSE
        state               <= IDLE;
        current_matrix_type <= "00";
        matrix_time_f0      <= (OTHERS => '0');
        matrix_time_f1      <= (OTHERS => '0');
        matrix_time_f2      <= (OTHERS => '0');
        dma_buffer_addr     <= (OTHERS => '0');
        dma_buffer_length   <= (OTHERS => '0');
        dma_buffer_new      <= '0';
      END IF;
    END IF;
  END PROCESS;
  
END Behavioral;
