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

LIBRARY lpp;
USE lpp.lpp_amba.ALL;
USE lpp.apb_devices_list.ALL;
USE lpp.lpp_memory.ALL;
USE lpp.lpp_dma_pkg.ALL;
USE lpp.general_purpose.ALL;
--USE lpp.lpp_waveform_pkg.ALL;
LIBRARY techmap;
USE techmap.gencomp.ALL;


ENTITY lpp_dma_SEND16B_FIFO2DMA IS
  GENERIC (
    hindex   :    INTEGER := 2;
    vendorid : IN INTEGER := 0;
    deviceid : IN INTEGER := 0;
    version  : IN INTEGER := 0
    );
  PORT (
    clk  : IN STD_LOGIC;
    rstn : IN STD_LOGIC;

    -- AMBA AHB Master Interface
    AHB_Master_In  : IN  AHB_Mst_In_Type;
    AHB_Master_Out : OUT AHB_Mst_Out_Type;

    -- FIFO Interface
    ren  : OUT STD_LOGIC;
    data : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);

    -- Controls
    send        : IN  STD_LOGIC;
    valid_burst : IN  STD_LOGIC;        -- (1 => BURST , 0 => SINGLE)
    done        : OUT STD_LOGIC;
    address     : IN  STD_LOGIC_VECTOR(31 DOWNTO 0)
    );                                      
END;

ARCHITECTURE Behavioral OF lpp_dma_SEND16B_FIFO2DMA IS
  
  CONSTANT HConfig : AHB_Config_Type := (
    0      => ahb_device_reg(vendorid, deviceid, 0, version, 0),
    OTHERS => (OTHERS => '0'));

  TYPE AHB_DMA_FSM_STATE IS (IDLE, s_ARBITER ,s_CTRL, s_CTRL_DATA, s_DATA);
  SIGNAL state : AHB_DMA_FSM_STATE;
  
  SIGNAL address_counter_reg : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL address_counter     : STD_LOGIC_VECTOR(3 DOWNTO 0);

  SIGNAL data_window : STD_LOGIC;
  SIGNAL ctrl_window : STD_LOGIC;

  SIGNAL bus_request : STD_LOGIC;
  SIGNAL bus_lock : STD_LOGIC;
  
BEGIN

  -----------------------------------------------------------------------------
  AHB_Master_Out.HCONFIG <= HConfig;
  AHB_Master_Out.HSIZE   <= "010";      --WORDS 32b
  AHB_Master_Out.HINDEX  <= hindex;
  AHB_Master_Out.HPROT   <= "0011";     --DATA ACCESS and PRIVILEDGED ACCESS
  AHB_Master_Out.HIRQ    <= (OTHERS => '0');
  AHB_Master_Out.HBURST  <= "111"; -- INCR --"111";      --INCR16
  AHB_Master_Out.HWRITE  <= '1';

  --AHB_Master_Out.HTRANS  <= HTRANS_NONSEQ WHEN ctrl_window = '1' OR data_window = '1' ELSE HTRANS_IDLE;

  --AHB_Master_Out.HBUSREQ <= bus_request;
  --AHB_Master_Out.HLOCK   <= data_window;

  --bus_request <= '0' WHEN address_counter_reg = "1111" AND AHB_Master_In.HREADY = '1' ELSE
  --               '1' WHEN ctrl_window = '1' ELSE
  --               '0';
  
  --bus_lock      <= '0' WHEN address_counter_reg = "1111" ELSE
  --                 '1' WHEN ctrl_window = '1' ELSE '0';
  
  -----------------------------------------------------------------------------
  AHB_Master_Out.HADDR  <= address(31 DOWNTO 6) & address_counter_reg & "00";
  AHB_Master_Out.HWDATA <= ahbdrivedata(data);

  -----------------------------------------------------------------------------
  --ren <= NOT ((AHB_Master_In.HGRANT(hindex) OR LAST_READ ) AND AHB_Master_In.HREADY );
  --ren <= NOT beat;
  -----------------------------------------------------------------------------
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      state <= IDLE;
      done <= '0';
      address_counter_reg <= (OTHERS => '0');
      AHB_Master_Out.HTRANS  <= HTRANS_IDLE;
      AHB_Master_Out.HBUSREQ <= '0';
      AHB_Master_Out.HLOCK   <= '0';
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      done <= '0';
      CASE state IS
        WHEN IDLE =>
          AHB_Master_Out.HBUSREQ <= '0';
          AHB_Master_Out.HLOCK   <= '0';
          AHB_Master_Out.HTRANS  <= HTRANS_IDLE;
          address_counter_reg <= (OTHERS => '0');
          IF send = '1' THEN
            AHB_Master_Out.HBUSREQ <= '1';
            AHB_Master_Out.HLOCK   <= '1';
            AHB_Master_Out.HTRANS  <= HTRANS_IDLE;
            state <= s_ARBITER;
          END IF;
          
        WHEN s_ARBITER =>
          AHB_Master_Out.HBUSREQ <= '1';
          AHB_Master_Out.HLOCK   <= '1';
          AHB_Master_Out.HTRANS  <= HTRANS_IDLE;
          address_counter_reg <= (OTHERS => '0');
          
          IF AHB_Master_In.HGRANT(hindex) = '1' THEN
            AHB_Master_Out.HTRANS  <= HTRANS_IDLE;
            state <= s_CTRL;
          END IF;
          
        WHEN s_CTRL =>
          AHB_Master_Out.HBUSREQ <= '1';
          AHB_Master_Out.HLOCK   <= '1';
          AHB_Master_Out.HTRANS  <= HTRANS_NONSEQ;
          IF AHB_Master_In.HREADY = '1' AND AHB_Master_In.HGRANT(hindex) = '1' THEN
            AHB_Master_Out.HTRANS  <= HTRANS_SEQ;
            state <= s_CTRL_DATA;
          END IF;
          
        WHEN s_CTRL_DATA =>
          AHB_Master_Out.HBUSREQ <= '1';
          AHB_Master_Out.HLOCK   <= '1';
          AHB_Master_Out.HTRANS  <= HTRANS_SEQ;
          IF AHB_Master_In.HREADY = '1' AND AHB_Master_In.HGRANT(hindex) = '1' THEN
            address_counter_reg <= STD_LOGIC_VECTOR(UNSIGNED(address_counter_reg) + 1);
          END IF;
          
          IF address_counter_reg = "1111" AND AHB_Master_In.HREADY = '1' THEN
            AHB_Master_Out.HBUSREQ <= '0';
            AHB_Master_Out.HLOCK   <= '1';--'0';
            AHB_Master_Out.HTRANS  <= HTRANS_IDLE;
            state <= s_DATA;
          END IF;
          
        WHEN s_DATA =>
          AHB_Master_Out.HBUSREQ <= '0';
          AHB_Master_Out.HLOCK   <= '0';
          AHB_Master_Out.HTRANS  <= HTRANS_IDLE;
          IF AHB_Master_In.HREADY = '1' THEN
            state <= IDLE;
            done <= '1';
          END IF;
          
        WHEN OTHERS => NULL;
      END CASE;
    END IF;
  END PROCESS;
  
  ctrl_window <= '1' WHEN state = s_CTRL OR state = s_CTRL_DATA ELSE '0';
  data_window <= '1' WHEN state = s_CTRL_DATA OR state = s_DATA ELSE '0';
  -----------------------------------------------------------------------------
  ren <= NOT(AHB_Master_In.HREADY) WHEN state = s_CTRL_DATA ELSE '1';

  -----------------------------------------------------------------------------
  --PROCESS (clk, rstn)
  --BEGIN  -- PROCESS
  --  IF rstn = '0' THEN                  -- asynchronous reset (active low)
  --    address_counter_reg <= (OTHERS => '0');
  --  ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
  --      address_counter_reg <= address_counter;
  --  END IF;
  --END PROCESS;
  
  --address_counter <= STD_LOGIC_VECTOR(UNSIGNED(address_counter_reg) + 1) WHEN data_window = '1' AND AHB_Master_In.HREADY = '1' AND AHB_Master_In.HGRANT(hindex) = '1' ELSE 
  --                   address_counter_reg;
  -----------------------------------------------------------------------------
 
  
END Behavioral;
