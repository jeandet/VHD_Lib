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


ENTITY lpp_dma IS
  GENERIC (
    tech   : INTEGER := inferred;
    hindex : INTEGER := 2;
    pindex : INTEGER := 4;
    paddr  : INTEGER := 4;
    pmask  : INTEGER := 16#fff#;
    pirq   : INTEGER := 0);
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
    header_ack : OUT STD_LOGIC
    );
END;

ARCHITECTURE Behavioral OF lpp_dma IS

  SIGNAL ready_matrix_f0_0             : STD_LOGIC;
  SIGNAL ready_matrix_f0_1             : STD_LOGIC;
  SIGNAL ready_matrix_f1               : STD_LOGIC;
  SIGNAL ready_matrix_f2               : STD_LOGIC;
  SIGNAL error_anticipating_empty_fifo : STD_LOGIC;
  SIGNAL error_bad_component_error     : STD_LOGIC;

  SIGNAL debug_reg : STD_LOGIC_VECTOR(31 DOWNTO 0);
  
  SIGNAL config_active_interruption_onNewMatrix : STD_LOGIC;
  SIGNAL config_active_interruption_onError     : STD_LOGIC;
  SIGNAL status_ready_matrix_f0_0               : STD_LOGIC;
  SIGNAL status_ready_matrix_f0_1               : STD_LOGIC;
  SIGNAL status_ready_matrix_f1                 : STD_LOGIC;
  SIGNAL status_ready_matrix_f2                 : STD_LOGIC;
  SIGNAL status_error_anticipating_empty_fifo   : STD_LOGIC;
  SIGNAL status_error_bad_component_error       : STD_LOGIC;
  SIGNAL addr_matrix_f0_0                       : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL addr_matrix_f0_1                       : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL addr_matrix_f1                         : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL addr_matrix_f2                         : STD_LOGIC_VECTOR(31 DOWNTO 0);
  
BEGIN

  -----------------------------------------------------------------------------
  -- LPP DMA IP
  -----------------------------------------------------------------------------

  lpp_dma_ip_1: lpp_dma_ip
    GENERIC MAP (
      tech   => tech,
      hindex => hindex)
    PORT MAP (
      HCLK                                   => HCLK,
      HRESETn                                => HRESETn,
      AHB_Master_In                          => AHB_Master_In,
      AHB_Master_Out                         => AHB_Master_Out,
      fifo_data                              => fifo_data,
      fifo_empty                             => fifo_empty,
      fifo_ren                               => fifo_ren,
      header                                 => header,
      header_val                             => header_val,
      header_ack                             => header_ack,
      -------------------------------------------------------------------------
      -- REG
      ready_matrix_f0_0                      => ready_matrix_f0_0,
      ready_matrix_f0_1                      => ready_matrix_f0_1,
      ready_matrix_f1                        => ready_matrix_f1,
      ready_matrix_f2                        => ready_matrix_f2,
      error_anticipating_empty_fifo          => error_anticipating_empty_fifo,
      error_bad_component_error              => error_bad_component_error,

      debug_reg                              => debug_reg,

      status_ready_matrix_f0_0               => status_ready_matrix_f0_0,
      status_ready_matrix_f0_1               => status_ready_matrix_f0_1,
      status_ready_matrix_f1                 => status_ready_matrix_f1,
      status_ready_matrix_f2                 => status_ready_matrix_f2,
      status_error_anticipating_empty_fifo   => status_error_anticipating_empty_fifo,
      status_error_bad_component_error       => status_error_bad_component_error,
      config_active_interruption_onNewMatrix => config_active_interruption_onNewMatrix,
      config_active_interruption_onError     => config_active_interruption_onError,
      addr_matrix_f0_0                       => addr_matrix_f0_0,
      addr_matrix_f0_1                       => addr_matrix_f0_1,
      addr_matrix_f1                         => addr_matrix_f1,
      addr_matrix_f2                         => addr_matrix_f2);
  
  -----------------------------------------------------------------------------
  -- APB REGISTER
  -----------------------------------------------------------------------------

  lpp_dma_apbreg_1 : lpp_dma_apbreg
    GENERIC MAP (
      pindex => pindex,
      paddr  => paddr,
      pmask  => pmask,
      pirq   => pirq)
    PORT MAP (
      HCLK                                   => HCLK,
      HRESETn                                => HRESETn,
      apbi                                   => apbi,
      apbo                                   => apbo,
      -- IN
      ready_matrix_f0_0                      => ready_matrix_f0_0,  
      ready_matrix_f0_1                      => ready_matrix_f0_1,  
      ready_matrix_f1                        => ready_matrix_f1,    
      ready_matrix_f2                        => ready_matrix_f2,  
      error_anticipating_empty_fifo          => error_anticipating_empty_fifo,
      error_bad_component_error              => error_bad_component_error,
      --
      debug_reg                              => debug_reg,
      -- OUT
      status_ready_matrix_f0_0               => status_ready_matrix_f0_0,  
      status_ready_matrix_f0_1               => status_ready_matrix_f0_1,  
      status_ready_matrix_f1                 => status_ready_matrix_f1,    
      status_ready_matrix_f2                 => status_ready_matrix_f2,    
      status_error_anticipating_empty_fifo   => status_error_anticipating_empty_fifo,
      status_error_bad_component_error       => status_error_bad_component_error,        
      config_active_interruption_onNewMatrix => config_active_interruption_onNewMatrix,  -- TODO
      config_active_interruption_onError     => config_active_interruption_onError,      -- TODO
      addr_matrix_f0_0                       => addr_matrix_f0_0,   
      addr_matrix_f0_1                       => addr_matrix_f0_1,   
      addr_matrix_f1                         => addr_matrix_f1,     
      addr_matrix_f2                         => addr_matrix_f2);    

 -----------------------------------------------------------------------------

END Behavioral;
