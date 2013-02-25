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

ENTITY fifo_test_dma IS
  GENERIC (
    tech   : INTEGER := apa3;
    pindex  : INTEGER := 0;
    paddr   : INTEGER := 0;
    pmask   : INTEGER := 16#fff#
    );
  PORT (
    -- AMBA AHB system signals
    HCLK    : IN STD_ULOGIC;
    HRESETn : IN STD_ULOGIC;

    -- AMBA APB Slave Interface
    apbi : IN  apb_slv_in_type;
    apbo : OUT apb_slv_out_type;

    -- FIFO Read interface
    fifo_data  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    fifo_empty : OUT STD_LOGIC;
    fifo_ren   : IN  STD_LOGIC;

    -- header
    header         : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    header_val     : OUT STD_LOGIC;
    header_ack     : IN  STD_LOGIC
    );
END;

ARCHITECTURE Behavioral OF fifo_test_dma IS
  CONSTANT REVISION : INTEGER := 1;
  CONSTANT pconfig : apb_config_type := (
    0 => ahb_device_reg (VENDOR_LPP, 0 , 0, REVISION, 0),
    1 => apb_iobar(paddr, pmask));

  TYPE lpp_test_dma_regs IS RECORD
    tt : STD_LOGIC;
  END RECORD;
  SIGNAL reg : lpp_test_dma_regs;

  SIGNAL prdata : STD_LOGIC_VECTOR(31 DOWNTO 0);
  -----------------------------------------------------------------------------
  SIGNAL fifo_empty_s : STD_LOGIC;
  SIGNAL fifo_raddr : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL fifo_wen   : STD_LOGIC;
  SIGNAL fifo_wdata : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL fifo_full  : STD_LOGIC;
  SIGNAL fifo_waddr : STD_LOGIC_VECTOR(7 DOWNTO 0);
  -----------------------------------------------------------------------------
  SIGNAL fifo_nb_data   : STD_LOGIC_VECTOR( 7 DOWNTO 0);
  SIGNAL fifo_nb_data_s : STD_LOGIC_VECTOR( 7 DOWNTO 0);
  -----------------------------------------------------------------------------
  SIGNAL header_s : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL header_val_s     :  STD_LOGIC;
BEGIN

  lpp_fifo_i : lpp_fifo
    GENERIC MAP (
      tech         => tech,
      Enable_ReUse => '0',
      DataSz       => 32,
      abits        => 8)
    PORT MAP (
      rstn  => HRESETn,
      ReUse => '0',

      rclk  => HCLK,
      ren   => fifo_ren,
      rdata => fifo_data,
      empty => fifo_empty_s,
      raddr => fifo_raddr,

      wclk  => HCLK,
      wen   => fifo_wen,
      wdata => fifo_wdata,
      full  => fifo_full,
      waddr => fifo_waddr);             -- OUT
  
  fifo_nb_data_s(7)          <= '1' WHEN (fifo_waddr < fifo_raddr) ELSE '0';
  fifo_nb_data_s(6 DOWNTO 0) <= (OTHERS => '0');
  fifo_nb_data               <= (fifo_waddr - fifo_raddr) + fifo_nb_data_s;

  fifo_empty    <= fifo_empty_s;
  header        <= header_s;
  header_val    <= header_val_s;
  -----------------------------------------------------------------------------
  
  apb_reg_p : PROCESS (HCLK, HRESETn)
    VARIABLE paddr : STD_LOGIC_VECTOR(7 DOWNTO 2);
  BEGIN  -- PROCESS lpp_dma_top
    IF HRESETn = '0' THEN                 -- asynchronous reset (active low)
      prdata             <= (OTHERS => '0');
      fifo_wdata             <= (OTHERS => '0');
      fifo_wen               <= '1';
      header_val_s           <= '0';
      header_s               <= (OTHERS => '0');
    ELSIF HCLK'EVENT AND HCLK = '1' THEN  -- rising clock edge
      paddr             := "000000";
      paddr(7 DOWNTO 2) := apbi.paddr(7 DOWNTO 2);
      fifo_wen          <= '1';
      header_val_s          <= header_val_s AND (NOT header_ack);
      IF (apbi.psel(pindex)) = '1' THEN
        -- APB DMA READ  --
        CASE paddr(7 DOWNTO 2) IS
          WHEN "000000" => prdata( 7 DOWNTO  0) <= fifo_waddr;
                           prdata(15 DOWNTO  8) <= fifo_raddr;
                           prdata(23 DOWNTO 16) <= fifo_nb_data;
                           prdata(24)           <= fifo_full;
                           prdata(25)           <= fifo_empty_s;
          WHEN "000001" => prdata(31 DOWNTO  0) <= header_s;
                           
          WHEN OTHERS => prdata <= (OTHERS => '0');
        END CASE;
        IF (apbi.pwrite AND apbi.penable) = '1' THEN
          -- APB DMA WRITE --
          CASE paddr(7 DOWNTO 2) IS
            WHEN "000000" => fifo_wdata         <= apbi.pwdata;
                             fifo_wen           <= '0';
            WHEN "000001" => header_s           <= apbi.pwdata;
                             header_val_s       <= '1';
            WHEN OTHERS => NULL;
          END CASE;
        END IF;
      END IF;
    END IF;
  END PROCESS apb_reg_p;
  apbo.pirq    <= (OTHERS => '0');
  apbo.pindex  <= pindex;
  apbo.pconfig <= pconfig;
  apbo.prdata  <= prdata;

END Behavioral;
