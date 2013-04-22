
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
-- 1.1 - (01/11/2013) FIX boundary error (1kB address should not be crossed by BURSTS)
-------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
LIBRARY grlib;
USE grlib.amba.ALL;
USE grlib.stdlib.ALL;
USE grlib.devices.ALL;
USE GRLIB.DMA2AHB_Package.ALL;
--USE GRLIB.DMA2AHB_TestPackage.ALL;
LIBRARY lpp;
USE lpp.lpp_amba.ALL;
USE lpp.apb_devices_list.ALL;
USE lpp.lpp_memory.ALL;
USE lpp.lpp_dma_pkg.ALL;
LIBRARY techmap;
USE techmap.gencomp.ALL;


ENTITY lpp_dma_ip IS
  GENERIC (
    tech   : INTEGER := inferred;
    hindex : INTEGER := 2
    );
  PORT (
    -- AMBA AHB system signals
    HCLK    : IN STD_ULOGIC;
    HRESETn : IN STD_ULOGIC;

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

    -- Reg out
    ready_matrix_f0_0             : OUT STD_LOGIC;
    ready_matrix_f0_1             : OUT STD_LOGIC;
    ready_matrix_f1               : OUT STD_LOGIC;
    ready_matrix_f2               : OUT STD_LOGIC;
    error_anticipating_empty_fifo : OUT STD_LOGIC;
    error_bad_component_error     : OUT STD_LOGIC;
    debug_reg                     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

    -- Reg In
    status_ready_matrix_f0_0             :IN  STD_LOGIC;
    status_ready_matrix_f0_1             :IN  STD_LOGIC;
    status_ready_matrix_f1               :IN  STD_LOGIC;
    status_ready_matrix_f2               :IN  STD_LOGIC;
    status_error_anticipating_empty_fifo :IN  STD_LOGIC;
    status_error_bad_component_error     :IN  STD_LOGIC;
                                          
    config_active_interruption_onNewMatrix : IN STD_LOGIC;
    config_active_interruption_onError     : IN STD_LOGIC;
    addr_matrix_f0_0                       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_matrix_f0_1                       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_matrix_f1                         : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_matrix_f2                         : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
    );                                      
END;

ARCHITECTURE Behavioral OF lpp_dma_ip IS
  -----------------------------------------------------------------------------
  SIGNAL DMAIn          : DMA_In_Type;
  SIGNAL header_dmai    : DMA_In_Type;
  SIGNAL component_dmai : DMA_In_Type;
  SIGNAL DMAOut         : DMA_OUt_Type;
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  TYPE state_DMAWriteBurst IS (IDLE,
                               TRASH_FIFO,
                               WAIT_HEADER_ACK,
                               SEND_DATA,
                               WAIT_DATA_ACK,
                               CHECK_LENGTH
                               );
  SIGNAL state : state_DMAWriteBurst := IDLE;

  SIGNAL nbSend                 : INTEGER;
  SIGNAL matrix_type            : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL component_type         : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL component_type_pre     : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL header_check_ok        : STD_LOGIC;
  SIGNAL address_matrix         : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL send_matrix            : STD_LOGIC;
  SIGNAL request                : STD_LOGIC;
  SIGNAL remaining_data_request : INTEGER;
  SIGNAL Address                : STD_LOGIC_VECTOR(31 DOWNTO 0);
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  SIGNAL header_select          : STD_LOGIC;

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
  SIGNAL debug_reg_s          : STD_LOGIC_VECTOR(31 DOWNTO 0);
  
BEGIN

  -----------------------------------------------------------------------------
  -- DMA to AHB interface
  -----------------------------------------------------------------------------
  
  DMA2AHB_1 : DMA2AHB
    GENERIC MAP (
      hindex   => hindex,
      vendorid => VENDOR_LPP,
      deviceid => 0,
      version  => 0,
      syncrst  => 1,
      boundary => 1)                    -- FIX 11/01/2013
    PORT MAP (
      HCLK    => HCLK,
      HRESETn => HRESETn,
      DMAIn   => DMAIn,
      DMAOut  => DMAOut,
      AHBIn   => AHB_Master_In,
      AHBOut  => AHB_Master_Out);
  
  debug_reg <= debug_reg_s;

  debug_info: PROCESS (HCLK, HRESETn)
  BEGIN  -- PROCESS debug_info
    IF HRESETn = '0' THEN               -- asynchronous reset (active low)
      debug_reg <= (OTHERS => '0');                  
    ELSIF HCLK'event AND HCLK = '1' THEN  -- rising clock edge
      debug_reg_s(0) <= debug_reg_s(0) OR (DMAOut.Retry );
      debug_reg_s(1) <= debug_reg_s(1) OR (DMAOut.Grant AND DMAOut.Retry) ;
      IF state = TRASH_FIFO THEN debug_reg(2) <= '1'; END IF;
      debug_reg_s(3) <= debug_reg_s(3) OR (header_send_ko);
      debug_reg_s(4) <= debug_reg_s(4) OR (header_send_ok);
      debug_reg_s(5) <= debug_reg_s(5) OR (component_send_ko);
      debug_reg_s(6) <= debug_reg_s(6) OR (component_send_ok);
      
      debug_reg_s(31 DOWNTO 7) <= (OTHERS => '1');
    END IF;
  END PROCESS debug_info;
    
  
  matrix_type    <= header(1 DOWNTO 0);
  component_type <= header(5 DOWNTO 2);

  send_matrix <= '1' WHEN matrix_type = "00" AND status_ready_matrix_f0_0 = '0' ELSE
                 '1' WHEN matrix_type = "01" AND status_ready_matrix_f0_1 = '0' ELSE
                 '1' WHEN matrix_type = "10" AND status_ready_matrix_f1 = '0'   ELSE
                 '1' WHEN matrix_type = "11" AND status_ready_matrix_f2 = '0'   ELSE
                 '0';
  
  header_check_ok <= '0' WHEN component_type = "1111" ELSE
                     '1' WHEN component_type = "0000" AND component_type_pre = "1110" ELSE
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
    IF HRESETn = '0' THEN                 -- asynchronous reset (active low)
      state                         <= IDLE;
      header_ack                    <= '0';
      ready_matrix_f0_0             <= '0';
      ready_matrix_f0_1             <= '0';
      ready_matrix_f1               <= '0';
      ready_matrix_f2               <= '0';
      error_anticipating_empty_fifo <= '0';
      error_bad_component_error     <= '0';
      component_type_pre            <= "1110";
      fifo_ren_trash                <= '1';
      component_send                <= '0';
      address                       <= (OTHERS => '0');
      header_select                 <= '0';
      header_send        <= '0';
      header_data        <= (OTHERS => '0');
    ELSIF HCLK'EVENT AND HCLK = '1' THEN  -- rising clock edge

      CASE state IS
        WHEN IDLE =>
          ready_matrix_f0_0 <= '0';
          ready_matrix_f0_1 <= '0';
          ready_matrix_f1   <= '0';
          ready_matrix_f2   <= '0';
          error_bad_component_error <= '0';
          header_select                    <= '1';
          IF header_val = '1' AND fifo_empty = '0' AND send_matrix = '1' THEN
            IF header_check_ok = '1' THEN
              header_data        <= header;
              component_type_pre <= header(5 DOWNTO 2);
              header_ack         <= '1';
              --
              header_send        <= '1';
              IF component_type = "0000" THEN
                address <= address_matrix;
              END IF;
              header_data <= header;
              --
              state       <= WAIT_HEADER_ACK;
            ELSE
              error_bad_component_error <= '1';
              component_type_pre               <= "1110";
              header_ack                       <= '1';
              state                            <= TRASH_FIFO;
            END IF;
          END IF;

        WHEN TRASH_FIFO =>
          error_bad_component_error <= '0';
          error_anticipating_empty_fifo <= '0';
          IF fifo_empty = '1' THEN
            state          <= IDLE;
            fifo_ren_trash <= '1';
          ELSE
            fifo_ren_trash <= '0';
          END IF;
          
        WHEN WAIT_HEADER_ACK =>
          header_send <= '0';
          IF header_send_ko = '1' THEN
            state <= TRASH_FIFO;
            error_anticipating_empty_fifo <= '1';
            -- TODO : error sending header
          ELSIF header_send_ok = '1' THEN
            header_select <= '0';
            state         <= SEND_DATA;
            address       <= address + 4;
          END IF;

        WHEN SEND_DATA =>
          IF fifo_empty = '1' THEN
            state <= IDLE;
            IF component_type = "1110" THEN
              CASE matrix_type IS
                WHEN "00"  => ready_matrix_f0_0 <= '1';
                WHEN "01"  => ready_matrix_f0_1 <= '1';
                WHEN "10"  => ready_matrix_f1   <= '1';
                WHEN "11"  => ready_matrix_f2   <= '1';
                WHEN OTHERS => NULL;
              END CASE;
            END IF;
          ELSE
            component_send <= '1';
            address        <= address;
            state          <= WAIT_DATA_ACK;
          END IF;

        WHEN WAIT_DATA_ACK =>
          component_send <= '0';
          IF component_send_ok = '1' THEN
            address <= address + 64;
            state   <= SEND_DATA;
          ELSIF component_send_ko = '1' THEN
            error_anticipating_empty_fifo <= '0';
            state <= TRASH_FIFO;
          END IF;
          
        WHEN CHECK_LENGTH =>
          state <= IDLE;
        WHEN OTHERS => NULL;
      END CASE;
      
    END IF;
  END PROCESS DMAWriteFSM_p;

  -----------------------------------------------------------------------------
  -- SEND 1 word by DMA
  -----------------------------------------------------------------------------
  lpp_dma_send_1word_1 : lpp_dma_send_1word
    PORT MAP (
      HCLK    => HCLK,
      HRESETn => HRESETn,
      DMAIn   => header_dmai,
      DMAOut  => DMAOut,

      send    => header_send,
      address => address,
      data    => header_data,
      send_ok => header_send_ok,
      send_ko => header_send_ko
      );

  -----------------------------------------------------------------------------
  -- SEND 16 word by DMA (in burst mode)
  -----------------------------------------------------------------------------
  lpp_dma_send_16word_1 : lpp_dma_send_16word
    PORT MAP (
      HCLK    => HCLK,
      HRESETn => HRESETn,
      DMAIn   => component_dmai,
      DMAOut  => DMAOut,

      send    => component_send,      
      address => address,            
      data    => fifo_data,
      ren     => component_fifo_ren,
      send_ok => component_send_ok,    
      send_ko => component_send_ko);   

  DMAIn    <= header_dmai    WHEN header_select = '1' ELSE component_dmai;
  fifo_ren <= fifo_ren_trash WHEN header_select = '1' ELSE component_fifo_ren;

END Behavioral;
