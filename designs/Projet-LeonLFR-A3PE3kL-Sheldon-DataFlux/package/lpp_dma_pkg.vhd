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
USE std.textio.ALL;
LIBRARY grlib;
USE grlib.amba.ALL;
USE grlib.stdlib.ALL;
USE GRLIB.DMA2AHB_Package.ALL;
LIBRARY techmap;
USE techmap.gencomp.ALL;
LIBRARY lpp;
USE lpp.lpp_amba.ALL;
USE lpp.apb_devices_list.ALL;
USE lpp.lpp_memory.ALL;

PACKAGE lpp_dma_pkg IS

  COMPONENT lpp_dma
    GENERIC (
      tech   : INTEGER;
      hindex : INTEGER;
      pindex : INTEGER;
      paddr  : INTEGER;
      pmask  : INTEGER;
      pirq   : INTEGER);
    PORT (
      HCLK           : IN  STD_ULOGIC;
      HRESETn        : IN  STD_ULOGIC;
      apbi           : IN  apb_slv_in_type;
      apbo           : OUT apb_slv_out_type;
      AHB_Master_In  : IN  AHB_Mst_In_Type;
      AHB_Master_Out : OUT AHB_Mst_Out_Type;
      -- fifo interface
      fifo_data      : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      fifo_empty     : IN  STD_LOGIC;
      fifo_ren       : OUT STD_LOGIC;
      -- header
      header         : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      header_val     : IN  STD_LOGIC;
      header_ack     : OUT STD_LOGIC);
  END COMPONENT;

  COMPONENT fifo_test_dma
    GENERIC (
      tech   : INTEGER;
      pindex : INTEGER;
      paddr  : INTEGER;
      pmask  : INTEGER);
    PORT (
      HCLK       : IN  STD_ULOGIC;
      HRESETn    : IN  STD_ULOGIC;
      apbi       : IN  apb_slv_in_type;
      apbo       : OUT apb_slv_out_type;
      -- fifo interface
      fifo_data  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      fifo_empty : OUT STD_LOGIC;
      fifo_ren   : IN  STD_LOGIC;
      -- header
      header     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      header_val : OUT STD_LOGIC;
      header_ack : IN  STD_LOGIC
      );
  END COMPONENT;

  COMPONENT lpp_dma_apbreg
    GENERIC (
      pindex : INTEGER;
      paddr  : INTEGER;
      pmask  : INTEGER;
      pirq   : INTEGER);
    PORT (
      HCLK                          : IN  STD_ULOGIC;
      HRESETn                       : IN  STD_ULOGIC;
      apbi                          : IN  apb_slv_in_type;
      apbo                          : OUT apb_slv_out_type;
      -- IN
      ready_matrix_f0_0             : IN  STD_LOGIC;
      ready_matrix_f0_1             : IN  STD_LOGIC;
      ready_matrix_f1               : IN  STD_LOGIC;
      ready_matrix_f2               : IN  STD_LOGIC;
      error_anticipating_empty_fifo : IN  STD_LOGIC;
      error_bad_component_error     : IN  STD_LOGIC;
      debug_reg                     : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

      -- OUT
      status_ready_matrix_f0_0             : OUT STD_LOGIC;
      status_ready_matrix_f0_1             : OUT STD_LOGIC;
      status_ready_matrix_f1               : OUT STD_LOGIC;
      status_ready_matrix_f2               : OUT STD_LOGIC;
      status_error_anticipating_empty_fifo : OUT STD_LOGIC;
      status_error_bad_component_error     : OUT STD_LOGIC;

      config_active_interruption_onNewMatrix : OUT STD_LOGIC;
      config_active_interruption_onError     : OUT STD_LOGIC;
      addr_matrix_f0_0                       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      addr_matrix_f0_1                       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      addr_matrix_f1                         : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      addr_matrix_f2                         : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
      );
  END COMPONENT;
  
  COMPONENT lpp_dma_send_1word
    PORT (
      HCLK    : IN  STD_ULOGIC;
      HRESETn : IN  STD_ULOGIC;
      DMAIn   : OUT DMA_In_Type;
      DMAOut  : IN  DMA_OUt_Type;
      send    : IN  STD_LOGIC;
      address : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      data    : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      send_ok : OUT STD_LOGIC;
      send_ko : OUT STD_LOGIC);
  END COMPONENT;

  COMPONENT lpp_dma_send_16word
    PORT (
      HCLK    : IN  STD_ULOGIC;
      HRESETn : IN  STD_ULOGIC;
      DMAIn   : OUT DMA_In_Type;
      DMAOut  : IN  DMA_OUt_Type;
      send    : IN  STD_LOGIC;
      address : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      data    : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      ren     : OUT STD_LOGIC;
      send_ok : OUT STD_LOGIC;
      send_ko : OUT STD_LOGIC);
  END COMPONENT;

  COMPONENT fifo_latency_correction
    PORT (
      HCLK       : IN  STD_ULOGIC;
      HRESETn    : IN  STD_ULOGIC;
      fifo_data  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      fifo_empty : IN  STD_LOGIC;
      fifo_ren   : OUT STD_LOGIC;
      dma_data   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      dma_empty  : OUT STD_LOGIC;
      dma_ren    : IN  STD_LOGIC);
  END COMPONENT;

  COMPONENT lpp_dma_ip
    GENERIC (
      tech   : INTEGER;
      hindex : INTEGER);
    PORT (
      HCLK                                   : IN  STD_ULOGIC;
      HRESETn                                : IN  STD_ULOGIC;
      AHB_Master_In                          : IN  AHB_Mst_In_Type;
      AHB_Master_Out                         : OUT AHB_Mst_Out_Type;
      fifo_data                              : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      fifo_empty                             : IN  STD_LOGIC;
      fifo_ren                               : OUT STD_LOGIC;
      header                                 : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      header_val                             : IN  STD_LOGIC;
      header_ack                             : OUT STD_LOGIC;
      ready_matrix_f0_0                      : OUT STD_LOGIC;
      ready_matrix_f0_1                      : OUT STD_LOGIC;
      ready_matrix_f1                        : OUT STD_LOGIC;
      ready_matrix_f2                        : OUT STD_LOGIC;
      error_anticipating_empty_fifo          : OUT STD_LOGIC;
      error_bad_component_error              : OUT STD_LOGIC;
      debug_reg                              : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      status_ready_matrix_f0_0               : IN  STD_LOGIC;
      status_ready_matrix_f0_1               : IN  STD_LOGIC;
      status_ready_matrix_f1                 : IN  STD_LOGIC;
      status_ready_matrix_f2                 : IN  STD_LOGIC;
      status_error_anticipating_empty_fifo   : IN  STD_LOGIC;
      status_error_bad_component_error       : IN  STD_LOGIC;
      config_active_interruption_onNewMatrix : IN  STD_LOGIC;
      config_active_interruption_onError     : IN  STD_LOGIC;
      addr_matrix_f0_0                       : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      addr_matrix_f0_1                       : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      addr_matrix_f1                         : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      addr_matrix_f2                         : IN  STD_LOGIC_VECTOR(31 DOWNTO 0));
  END COMPONENT;
  
END;