
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
    HCLK    : IN STD_ULOGIC;
    HRESETn : IN STD_ULOGIC;

    --TIME
    data_time : IN STD_LOGIC_VECTOR(47 DOWNTO 0);

    -- fifo interface
    fifo_data  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    fifo_empty : IN  STD_LOGIC;
    fifo_ren   : OUT STD_LOGIC;

    -- header
    header     : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    header_val : IN  STD_LOGIC;
    header_ack : OUT STD_LOGIC;

    -- DMA
    dma_addr        : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    dma_data        : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    dma_valid       : OUT STD_LOGIC;
    dma_valid_burst : OUT STD_LOGIC;
    dma_ren         : IN  STD_LOGIC;
    dma_done        : IN  STD_LOGIC;

    -- Reg out
    ready_matrix_f0_0             : OUT STD_LOGIC;
    ready_matrix_f0_1             : OUT STD_LOGIC;
    ready_matrix_f1               : OUT STD_LOGIC;
    ready_matrix_f2               : OUT STD_LOGIC;
    error_anticipating_empty_fifo : OUT STD_LOGIC;
    error_bad_component_error     : OUT STD_LOGIC;
    debug_reg                     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

    -- Reg In
    status_ready_matrix_f0_0             : IN STD_LOGIC;
    status_ready_matrix_f0_1             : IN STD_LOGIC;
    status_ready_matrix_f1               : IN STD_LOGIC;
    status_ready_matrix_f2               : IN STD_LOGIC;
    status_error_anticipating_empty_fifo : IN STD_LOGIC;
    status_error_bad_component_error     : IN STD_LOGIC;

    config_active_interruption_onNewMatrix : IN STD_LOGIC;
    config_active_interruption_onError     : IN STD_LOGIC;
    addr_matrix_f0_0                       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_matrix_f0_1                       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_matrix_f1                         : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_matrix_f2                         : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

    matrix_time_f0_0 : OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
    matrix_time_f0_1 : OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
    matrix_time_f1   : OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
    matrix_time_f2   : OUT STD_LOGIC_VECTOR(47 DOWNTO 0)

    );                                      
END;

ARCHITECTURE Behavioral OF lpp_lfr_ms_fsmdma IS
  -----------------------------------------------------------------------------
--  SIGNAL DMAIn          : DMA_In_Type;
--  SIGNAL header_dmai    : DMA_In_Type;
--  SIGNAL component_dmai : DMA_In_Type;
--  SIGNAL DMAOut         : DMA_OUt_Type;
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  TYPE state_DMAWriteBurst IS (IDLE,
                               CHECK_COMPONENT_TYPE,
                               WRITE_COARSE_TIME,
                               WRITE_FINE_TIME,
                               TRASH_FIFO,
                               SEND_DATA,
                               WAIT_DATA_ACK
                               );
  SIGNAL state : state_DMAWriteBurst;   -- := IDLE;

  -- SIGNAL nbSend                 : INTEGER;
  SIGNAL matrix_type        : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL component_type     : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL component_type_pre : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL header_check_ok    : STD_LOGIC;
  SIGNAL address_matrix     : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL send_matrix        : STD_LOGIC;
  -- SIGNAL request                : STD_LOGIC;
--  SIGNAL remaining_data_request : INTEGER;
  SIGNAL Address            : STD_LOGIC_VECTOR(31 DOWNTO 0);
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  SIGNAL header_select      : STD_LOGIC;

  SIGNAL header_send    : STD_LOGIC;
  SIGNAL header_data    : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL header_send_ok : STD_LOGIC;
  SIGNAL header_send_ko : STD_LOGIC;

  SIGNAL component_send     : STD_LOGIC;
  SIGNAL component_send_ok  : STD_LOGIC;
  SIGNAL component_send_ko  : STD_LOGIC;
  -----------------------------------------------------------------------------
  SIGNAL fifo_ren_trash     : STD_LOGIC;
  SIGNAL component_fifo_ren : STD_LOGIC;

  -----------------------------------------------------------------------------
  SIGNAL debug_reg_s   : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL fine_time_reg : STD_LOGIC_VECTOR(15 DOWNTO 0);

  -----------------------------------------------------------------------------
  SIGNAL log_empty_fifo : STD_LOGIC;
  -----------------------------------------------------------------------------
  SIGNAL header_reg     : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL header_reg_val : STD_LOGIC;
  SIGNAL header_reg_ack : STD_LOGIC;
  SIGNAL header_error   : STD_LOGIC;
  
BEGIN
  
  debug_reg <= debug_reg_s;


  send_matrix <= '1' WHEN matrix_type = "00" AND status_ready_matrix_f0_0 = '0' ELSE
                 '1' WHEN matrix_type = "01" AND status_ready_matrix_f0_1 = '0' ELSE
                 '1' WHEN matrix_type = "10" AND status_ready_matrix_f1 = '0'   ELSE
                 '1' WHEN matrix_type = "11" AND status_ready_matrix_f2 = '0'   ELSE
                 '0';
  
  header_check_ok <= '0' WHEN component_type = "1111" ELSE  -- ?? component_type_pre = "1111"
                     '1' WHEN component_type = "0000" ELSE  --AND component_type_pre = "0000" ELSE
                     '1' WHEN component_type = component_type_pre + "0001"            ELSE
                     '0';

  address_matrix <= addr_matrix_f0_0 WHEN matrix_type = "00" ELSE
                    addr_matrix_f0_1 WHEN matrix_type = "01" ELSE
                    addr_matrix_f1   WHEN matrix_type = "10" ELSE
                    addr_matrix_f2   WHEN matrix_type = "11" ELSE
                    (OTHERS => '0');

  -----------------------------------------------------------------------------
  -- DMA control
  -----------------------------------------------------------------------------
  DMAWriteFSM_p : PROCESS (HCLK, HRESETn)
  BEGIN  -- PROCESS DMAWriteBurst_p
    IF HRESETn = '0' THEN               -- asynchronous reset (active low)
      matrix_type                   <= (OTHERS => '0');
      component_type                <= (OTHERS => '0');
      state                         <= IDLE;
--      header_ack                    <= '0';
      ready_matrix_f0_0             <= '0';
      ready_matrix_f0_1             <= '0';
      ready_matrix_f1               <= '0';
      ready_matrix_f2               <= '0';
      error_anticipating_empty_fifo <= '0';
      error_bad_component_error     <= '0';
      component_type_pre            <= "0000";
      fifo_ren_trash                <= '1';
      component_send                <= '0';
      address                       <= (OTHERS => '0');
      header_select                 <= '0';
      header_send                   <= '0';
      header_data                   <= (OTHERS => '0');
      fine_time_reg                 <= (OTHERS => '0');

      debug_reg_s(2 DOWNTO 0)  <= (OTHERS => '0');
      debug_reg_s(31 DOWNTO 4) <= (OTHERS => '0');

      log_empty_fifo <= '0';

    ELSIF HCLK'EVENT AND HCLK = '1' THEN  -- rising clock edge
      debug_reg_s(31 DOWNTO 10) <= (OTHERS => '0');
      header_reg_ack            <= '0';

      CASE state IS
        WHEN IDLE =>
          debug_reg_s(2 DOWNTO 0) <= "000";

          --matrix_type <= header(1 DOWNTO 0);
          --component_type <= header(5 DOWNTO 2);

          ready_matrix_f0_0         <= '0';
          ready_matrix_f0_1         <= '0';
          ready_matrix_f1           <= '0';
          ready_matrix_f2           <= '0';
          error_bad_component_error <= '0';
          --header_select             <= '1';

          IF header_reg_val = '1' AND fifo_empty = '0' AND send_matrix = '1' THEN
            header_reg_ack          <= '1';
            debug_reg_s(5 DOWNTO 4) <= header_reg(1 DOWNTO 0);
            debug_reg_s(9 DOWNTO 6) <= header_reg(5 DOWNTO 2);

            matrix_type        <= header_reg(1 DOWNTO 0);
            component_type     <= header_reg(5 DOWNTO 2);
            component_type_pre <= component_type;
            state              <= CHECK_COMPONENT_TYPE;
          END IF;
          log_empty_fifo <= '0';
          
        WHEN CHECK_COMPONENT_TYPE =>
          debug_reg_s(2 DOWNTO 0) <= "001";
          --header_ack              <= '0';

          IF header_check_ok = '1' THEN
            header_send <= '0';
            --
            IF component_type = "0000" THEN
              address <= address_matrix;
              CASE matrix_type IS
                WHEN "00"   => matrix_time_f0_0 <= data_time;
                WHEN "01"   => matrix_time_f0_1 <= data_time;
                WHEN "10"   => matrix_time_f1   <= data_time;
                WHEN "11"   => matrix_time_f2   <= data_time;
                WHEN OTHERS => NULL;
              END CASE;

              header_data    <= data_time(31 DOWNTO 0);
              fine_time_reg  <= data_time(47 DOWNTO 32);
              --state         <= WRITE_COARSE_TIME;
              --header_send   <= '1';
              state          <= SEND_DATA;
              header_send    <= '0';
              component_send <= '1';
              header_select  <= '0';
            ELSE
              state <= SEND_DATA;
            END IF;
            --
          ELSE
            error_bad_component_error <= '1';
            component_type_pre        <= "0000";
            state                     <= TRASH_FIFO;
          END IF;

          --WHEN WRITE_COARSE_TIME =>
          --  debug_reg_s(2 DOWNTO 0) <= "010";

          --  header_ack <= '0';

          --  IF dma_ren = '0' THEN
          --    header_send <= '0';
          --  ELSE
          --    header_send <= header_send;
          --  END IF;


          --  IF header_send_ko = '1' THEN
          --    header_send                   <= '0';
          --    state                         <= TRASH_FIFO;
          --    error_anticipating_empty_fifo <= '1';
          --    -- TODO : error sending header
          --  ELSIF header_send_ok = '1' THEN
          --    header_send               <= '1';
          --    header_select             <= '1';
          --    header_data(15 DOWNTO 0)  <= fine_time_reg;
          --    header_data(31 DOWNTO 16) <= (OTHERS => '0');
          --    state                     <= WRITE_FINE_TIME;
          --    address                   <= address + 4;
          --  END IF;


          --WHEN WRITE_FINE_TIME =>
          --  debug_reg_s(2 DOWNTO 0) <= "011";

          --  header_ack <= '0';

          --  IF dma_ren = '0' THEN
          --    header_send <= '0';
          --  ELSE
          --    header_send <= header_send;
          --  END IF;

          --  IF header_send_ko = '1' THEN
          --    header_send                   <= '0';
          --    state                         <= TRASH_FIFO;
          --    error_anticipating_empty_fifo <= '1';
          --    -- TODO : error sending header
          --  ELSIF header_send_ok = '1' THEN
          --    header_send   <= '0';
          --    header_select <= '0';
          --    state         <= SEND_DATA;
          --    address       <= address + 4;
          --  END IF;
          
        WHEN TRASH_FIFO =>
          debug_reg_s(2 DOWNTO 0) <= "100";

--          header_ack                    <= '0';
          error_bad_component_error     <= '0';
          error_anticipating_empty_fifo <= '0';
          IF fifo_empty = '1' THEN
            state          <= IDLE;
            fifo_ren_trash <= '1';
          ELSE
            fifo_ren_trash <= '0';
          END IF;

        WHEN SEND_DATA =>
--          header_ack <= '0';
          debug_reg_s(2 DOWNTO 0) <= "101";

          IF fifo_empty = '1' OR log_empty_fifo = '1' THEN
            state <= IDLE;
            IF component_type = "1110" THEN  --"1110" -- JC
              CASE matrix_type IS
                WHEN "00"   => ready_matrix_f0_0 <= '1';
                WHEN "01"   => ready_matrix_f0_1 <= '1';
                WHEN "10"   => ready_matrix_f1   <= '1';
                WHEN "11"   => ready_matrix_f2   <= '1';
                WHEN OTHERS => NULL;
              END CASE;

            END IF;
          ELSE
            component_send <= '1';
            address        <= address;
            state          <= WAIT_DATA_ACK;
          END IF;

        WHEN WAIT_DATA_ACK =>
          log_empty_fifo <= fifo_empty OR log_empty_fifo;

          debug_reg_s(2 DOWNTO 0) <= "110";

          component_send <= '0';
          IF component_send_ok = '1' THEN
            address <= address + 64;
            state   <= SEND_DATA;
          ELSIF component_send_ko = '1' THEN
            error_anticipating_empty_fifo <= '0';
            state                         <= TRASH_FIFO;
          END IF;


          --WHEN CHECK_LENGTH =>
          --  component_send <= '0';
          --  debug_reg_s(2 DOWNTO 0) <= "111";
          --  state <= IDLE;
          
        WHEN OTHERS => NULL;
      END CASE;
      
    END IF;
  END PROCESS DMAWriteFSM_p;

  dma_valid_burst <= '0'            WHEN header_select = '1' ELSE component_send;
  dma_valid       <= header_send    WHEN header_select = '1' ELSE '0';
  dma_data        <= header_data    WHEN header_select = '1' ELSE fifo_data;
  dma_addr        <= address;
  fifo_ren        <= fifo_ren_trash WHEN header_select = '1' ELSE dma_ren;

  component_send_ok <= '0' WHEN header_select = '1' ELSE dma_done;
  component_send_ko <= '0';

  header_send_ok <= '0' WHEN header_select = '0' ELSE dma_done;
  header_send_ko <= '0';


  -----------------------------------------------------------------------------
  -- FSM HEADER ACK
  -----------------------------------------------------------------------------
  PROCESS (HCLK, HRESETn)
  BEGIN  -- PROCESS
    IF HRESETn = '0' THEN                 -- asynchronous reset (active low)
      header_ack     <= '0';
      header_reg     <= (OTHERS => '0');
      header_reg_val <= '0';
    ELSIF HCLK'EVENT AND HCLK = '1' THEN  -- rising clock edge
      header_ack <= '0';

      IF header_val = '1' THEN
        header_ack <= '1';
        header_reg <= header;
      END IF;

      IF header_val = '1' THEN
        header_reg_val <= '1';
      ELSIF header_reg_ack = '1' THEN
        header_reg_val <= '0';
      END IF;

      header_error <= header_val AND header_reg_val AND (NOT Header_reg_ack);
      
    END IF;
  END PROCESS;

  debug_reg_s(3) <= header_error;
  
END Behavioral;
