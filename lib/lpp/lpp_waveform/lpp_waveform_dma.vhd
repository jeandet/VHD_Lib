
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
LIBRARY lpp;
USE lpp.lpp_amba.ALL;
USE lpp.apb_devices_list.ALL;
USE lpp.lpp_memory.ALL;
USE lpp.lpp_dma_pkg.ALL;
USE lpp.lpp_waveform_pkg.ALL;
LIBRARY techmap;
USE techmap.gencomp.ALL;


ENTITY lpp_waveform_dma IS
  GENERIC (
    data_size               : INTEGER := 160;
    tech                    : INTEGER := inferred;
    hindex                  : INTEGER := 2;
    nb_burst_available_size : INTEGER := 11
    );
  PORT (
    -- AMBA AHB system signals
    HCLK               : IN  STD_ULOGIC;
    HRESETn            : IN  STD_ULOGIC;
    -- AMBA AHB Master Interface
    AHB_Master_In      : IN  AHB_Mst_In_Type;
    AHB_Master_Out     : OUT AHB_Mst_Out_Type;
    --
    data_ready         : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);   -- todo
    data               : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);  -- todo
    data_data_ren      : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);   -- todo
    data_time_ren      : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);   -- todo
    -- Reg
    nb_burst_available : IN  STD_LOGIC_VECTOR(nb_burst_available_size-1 DOWNTO 0);
    status_full        : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    status_full_ack    : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    status_full_err    : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
--    status_new_err    : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);  -- New data f(i) before the current data is write by dma
    addr_data_f0       : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_data_f1       : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_data_f2       : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_data_f3       : IN  STD_LOGIC_VECTOR(31 DOWNTO 0)
    );                                      
END;

ARCHITECTURE Behavioral OF lpp_waveform_dma IS
  -----------------------------------------------------------------------------
  SIGNAL DMAIn                : DMA_In_Type;
  SIGNAL DMAOut               : DMA_OUt_Type;
  -----------------------------------------------------------------------------
  TYPE   state_DMAWriteBurst IS (IDLE,
                                 SEND_TIME_0, WAIT_TIME_0,
                                 SEND_TIME_1, WAIT_TIME_1,
                                 SEND_5_TIME,
                                 SEND_DATA, WAIT_DATA);
  SIGNAL state                : state_DMAWriteBurst;
  -----------------------------------------------------------------------------
  -- CONTROL 
  SIGNAL sel_data_s           : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL sel_data             : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL update               : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL time_select          : STD_LOGIC;
  SIGNAL time_write           : STD_LOGIC;
  SIGNAL time_already_send : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL time_already_send_s : STD_LOGIC;
  -----------------------------------------------------------------------------
  -- SEND TIME MODULE
  SIGNAL time_dmai            : DMA_In_Type;
  SIGNAL time_send            : STD_LOGIC;
  SIGNAL time_send_ok         : STD_LOGIC;
  SIGNAL time_send_ko         : STD_LOGIC;
  SIGNAL time_fifo_ren        : STD_LOGIC;
  SIGNAL time_ren             : STD_LOGIC;
  -----------------------------------------------------------------------------
  -- SEND DATA MODULE
  SIGNAL data_dmai            : DMA_In_Type;
  SIGNAL data_send            : STD_LOGIC;
  SIGNAL data_send_ok         : STD_LOGIC;
  SIGNAL data_send_ko         : STD_LOGIC;
  SIGNAL data_fifo_ren        : STD_LOGIC;
  SIGNAL data_ren             : STD_LOGIC;
  -----------------------------------------------------------------------------
  -- SELECT ADDRESS
  SIGNAL data_address         : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL update_and_sel       : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL addr_data_reg_vector : STD_LOGIC_VECTOR(32*4-1 DOWNTO 0);
  SIGNAL addr_data_vector     : STD_LOGIC_VECTOR(32*4-1 DOWNTO 0);
  -----------------------------------------------------------------------------
  SIGNAL send_16_3_time : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL count_send_time : INTEGER;
BEGIN

  -----------------------------------------------------------------------------
  -- DMA to AHB interface
  DMA2AHB_1 : DMA2AHB
    GENERIC MAP (
      hindex   => hindex,
      vendorid => VENDOR_LPP,
      deviceid => 10,
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
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- This module memorises when the Times info are write. When FSM send
  -- the Times info, the "reg" is set and when a full_ack is received the "reg" is reset.
  all_time_write: FOR I IN 3 DOWNTO 0 GENERATE
    PROCESS (HCLK, HRESETn)
    BEGIN  -- PROCESS
      IF HRESETn = '0' THEN                  -- asynchronous reset (active low)
        time_already_send(I) <= '0';
      ELSIF HCLK'EVENT AND HCLK = '1' THEN  -- rising clock edge
        IF time_write = '1' AND UNSIGNED(sel_data) = I THEN
          time_already_send(I) <= '1';
        ELSIF status_full_ack(I) = '1' THEN
          time_already_send(I) <= '0';
        END IF;
      END IF;
    END PROCESS;
  END GENERATE all_time_write;
  
  -----------------------------------------------------------------------------
  sel_data_s <= "00" WHEN data_ready(0) = '1' ELSE
                "01" WHEN data_ready(1) = '1' ELSE
                "10" WHEN data_ready(2) = '1' ELSE
                "11";
  
  time_already_send_s <= time_already_send(0) WHEN data_ready(0) = '1' ELSE
                         time_already_send(1) WHEN data_ready(1) = '1' ELSE
                         time_already_send(2) WHEN data_ready(2) = '1' ELSE
                         time_already_send(3);

  -- DMA control
  DMAWriteFSM_p : PROCESS (HCLK, HRESETn)
  BEGIN  -- PROCESS DMAWriteBurst_p
    IF HRESETn = '0' THEN
      state         <= IDLE;
      
      sel_data      <= "00";
      update        <= "00";
      time_select   <= '0';
      time_fifo_ren <= '1';
      data_send     <= '0';
      time_send     <= '0';
      time_write    <= '0';
      send_16_3_time <= "001";
      
    ELSIF HCLK'EVENT AND HCLK = '1' THEN

      CASE state IS
        WHEN IDLE =>
          count_send_time <= 0;
          sel_data      <= "00";
          update        <= "00";
          time_select   <= '0';
          time_fifo_ren <= '1';
          data_send     <= '0';
          time_send     <= '0';
          time_write    <= '0';
          
          IF data_ready = "0000" THEN
            state    <= IDLE;
          ELSE
            sel_data <= sel_data_s;
            send_16_3_time <= send_16_3_time(1 DOWNTO 0) & send_16_3_time(2);
            IF send_16_3_time(0) = '1' THEN
              state    <= SEND_TIME_0;
            ELSE
              state    <= SEND_5_TIME;
            END IF;
          END IF;
          
        WHEN SEND_TIME_0 =>
          time_select   <= '1';
          IF time_already_send_s = '0' THEN
            time_send <= '1';
            state     <= WAIT_TIME_0;
          ELSE
            time_send <= '0';
            state     <= SEND_TIME_1;
          END IF;
          time_fifo_ren <= '0';

        WHEN WAIT_TIME_0 =>
          time_fifo_ren <= '1';
          update    <= "00";
          time_send <= '0';
          IF time_send_ok = '1' OR time_send_ko = '1' THEN
            update    <= "01";
            state     <= SEND_TIME_1;            
          END IF;
          
        WHEN SEND_TIME_1 =>
          time_select   <= '1';
          IF time_already_send_s = '0' THEN
            time_send <= '1';
            state     <= WAIT_TIME_1;
          ELSE
            time_send <= '0';
            state     <= SEND_5_TIME;
          END IF;
          time_fifo_ren <= '0';

        WHEN WAIT_TIME_1 =>
          time_fifo_ren <= '1';
          update    <= "00";
          time_send <= '0';
          IF time_send_ok = '1' OR time_send_ko = '1' THEN
            time_write <=  '1';
            update    <= "01";
            state     <= SEND_5_TIME;            
          END IF;

        WHEN SEND_5_TIME =>
          update    <= "00";
          time_select   <= '1';
          time_fifo_ren <= '0';
          count_send_time <= count_send_time + 1;
          IF count_send_time = 10 THEN
            state     <= SEND_DATA;
          END IF;          
          
        WHEN SEND_DATA =>
          time_fifo_ren <= '1';
          time_write    <= '0';
          time_send     <= '0';
          
          time_select   <= '0';
          data_send     <= '1';
          update        <= "00";
          state         <= WAIT_DATA;

        WHEN WAIT_DATA =>
          data_send     <= '0';
          
          IF data_send_ok = '1' OR data_send_ko = '1' THEN
            state  <= IDLE;
            update <= "10";
          END IF;
          
        WHEN OTHERS => NULL;
      END CASE;
      
    END IF;
  END PROCESS DMAWriteFSM_p;
  -----------------------------------------------------------------------------



  -----------------------------------------------------------------------------
  -- SEND 1 word by DMA
  -----------------------------------------------------------------------------
  lpp_dma_send_1word_1 : lpp_dma_send_1word
    PORT MAP (
      HCLK    => HCLK,
      HRESETn => HRESETn,
      DMAIn   => time_dmai,
      DMAOut  => DMAOut,

      send    => time_send,
      address => data_address,
      data    => data,
      send_ok => time_send_ok,
      send_ko => time_send_ko
      );

  -----------------------------------------------------------------------------
  -- SEND 16 word by DMA (in burst mode)
  -----------------------------------------------------------------------------
  lpp_dma_send_16word_1 : lpp_dma_send_16word
    PORT MAP (
      HCLK    => HCLK,
      HRESETn => HRESETn,
      DMAIn   => data_dmai,
      DMAOut  => DMAOut,

      send    => data_send,
      address => data_address,
      data    => data,
      ren     => data_fifo_ren,
      send_ok => data_send_ok,
      send_ko => data_send_ko);         

  DMAIn    <= time_dmai     WHEN time_select = '1' ELSE data_dmai;
  data_ren <= '1'           WHEN time_select = '1' ELSE data_fifo_ren;
  time_ren <= time_fifo_ren WHEN time_select = '1' ELSE '1';

  all_data_ren : FOR I IN 3 DOWNTO 0 GENERATE
    data_data_ren(I) <= data_ren WHEN UNSIGNED(sel_data) = I ELSE '1';
    data_time_ren(I) <= time_ren WHEN UNSIGNED(sel_data) = I ELSE '1';
  END GENERATE all_data_ren;

  -----------------------------------------------------------------------------
  -- SELECT ADDRESS
  addr_data_reg_vector <= addr_data_f3 & addr_data_f2 & addr_data_f1 & addr_data_f0;

  gen_select_address : FOR I IN 3 DOWNTO 0 GENERATE
    
    update_and_sel((2*I)+1 DOWNTO 2*I) <= update WHEN UNSIGNED(sel_data) = I ELSE "00";

    lpp_waveform_dma_selectaddress_I : lpp_waveform_dma_selectaddress
      GENERIC MAP (
        nb_burst_available_size => nb_burst_available_size)
      PORT MAP (
        HCLK               => HCLK,
        HRESETn            => HRESETn,
        update             => update_and_sel((2*I)+1 DOWNTO 2*I),
        nb_burst_available => nb_burst_available,
        addr_data_reg      => addr_data_reg_vector(32*I+31 DOWNTO 32*I),
        addr_data          => addr_data_vector(32*I+31 DOWNTO 32*I),
        status_full        => status_full(I),
        status_full_ack    => status_full_ack(I),
        status_full_err    => status_full_err(I));

  END GENERATE gen_select_address;

  data_address <= addr_data_vector(31 DOWNTO 0) WHEN UNSIGNED(sel_data) = 0 ELSE
                  addr_data_vector(32*1+31 DOWNTO 32*1) WHEN UNSIGNED(sel_data) = 1 ELSE
                  addr_data_vector(32*2+31 DOWNTO 32*2) WHEN UNSIGNED(sel_data) = 2 ELSE
                  addr_data_vector(32*3+31 DOWNTO 32*3);
  -----------------------------------------------------------------------------

  
END Behavioral;