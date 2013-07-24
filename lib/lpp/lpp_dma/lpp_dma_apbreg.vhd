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

ENTITY lpp_dma_apbreg IS
  GENERIC (
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

    -- IN
    ready_matrix_f0_0             : IN STD_LOGIC;
    ready_matrix_f0_1             : IN STD_LOGIC;
    ready_matrix_f1               : IN STD_LOGIC;
    ready_matrix_f2               : IN STD_LOGIC;
    error_anticipating_empty_fifo : IN STD_LOGIC;
    error_bad_component_error     : IN STD_LOGIC;
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

END lpp_dma_apbreg;

ARCHITECTURE beh OF lpp_dma_apbreg IS
  
  CONSTANT REVISION : INTEGER := 1;
  
  CONSTANT pconfig : apb_config_type := (
    0 => ahb_device_reg (VENDOR_LPP, LPP_DMA_TYPE, 0, REVISION, pirq),
    1 => apb_iobar(paddr, pmask));

  TYPE lpp_dma_regs IS RECORD
    config_active_interruption_onNewMatrix : STD_LOGIC;
    config_active_interruption_onError     : STD_LOGIC;
    status_ready_matrix_f0_0               : STD_LOGIC;
    status_ready_matrix_f0_1               : STD_LOGIC;
    status_ready_matrix_f1                 : STD_LOGIC;
    status_ready_matrix_f2                 : STD_LOGIC;
    status_error_anticipating_empty_fifo   : STD_LOGIC;
    status_error_bad_component_error       : STD_LOGIC;
    addr_matrix_f0_0                       : STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_matrix_f0_1                       : STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_matrix_f1                         : STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_matrix_f2                         : STD_LOGIC_VECTOR(31 DOWNTO 0);
  END RECORD;

  SIGNAL reg : lpp_dma_regs;

  SIGNAL prdata : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN  -- beh

  status_ready_matrix_f0_0             <= reg.status_ready_matrix_f0_0;
  status_ready_matrix_f0_1             <= reg.status_ready_matrix_f0_1;
  status_ready_matrix_f1               <= reg.status_ready_matrix_f1;
  status_ready_matrix_f2               <= reg.status_ready_matrix_f2;
  status_error_anticipating_empty_fifo <= reg.status_error_anticipating_empty_fifo;
  status_error_bad_component_error     <= reg.status_error_bad_component_error;

  config_active_interruption_onNewMatrix <= reg.config_active_interruption_onNewMatrix;
  config_active_interruption_onError     <= reg.config_active_interruption_onError;
  addr_matrix_f0_0                       <= reg.addr_matrix_f0_0;
  addr_matrix_f0_1                       <= reg.addr_matrix_f0_1;
  addr_matrix_f1                         <= reg.addr_matrix_f1;
  addr_matrix_f2                         <= reg.addr_matrix_f2;

  lpp_dma_apbreg : PROCESS (HCLK, HRESETn)
    VARIABLE paddr : STD_LOGIC_VECTOR(7 DOWNTO 2);
  BEGIN  -- PROCESS lpp_dma_top
    IF HRESETn = '0' THEN                 -- asynchronous reset (active low)
      reg.config_active_interruption_onNewMatrix <= '0';
      reg.config_active_interruption_onError     <= '0';
      reg.status_ready_matrix_f0_0               <= '0';
      reg.status_ready_matrix_f0_1               <= '0';
      reg.status_ready_matrix_f1                 <= '0';
      reg.status_ready_matrix_f2                 <= '0';
      reg.status_error_anticipating_empty_fifo   <= '0';
      reg.status_error_bad_component_error       <= '0';
      reg.addr_matrix_f0_0                       <= (OTHERS => '0');
      reg.addr_matrix_f0_1                       <= (OTHERS => '0');
      reg.addr_matrix_f1                         <= (OTHERS => '0');
      reg.addr_matrix_f2                         <= (OTHERS => '0');
      prdata                                     <= (OTHERS => '0');
    ELSIF HCLK'EVENT AND HCLK = '1' THEN  -- rising clock edge

      reg.status_ready_matrix_f0_0 <= reg.status_ready_matrix_f0_0 OR ready_matrix_f0_0;
      reg.status_ready_matrix_f0_1 <= reg.status_ready_matrix_f0_1 OR ready_matrix_f0_1;
      reg.status_ready_matrix_f1   <= reg.status_ready_matrix_f1 OR ready_matrix_f1;
      reg.status_ready_matrix_f2   <= reg.status_ready_matrix_f2 OR ready_matrix_f2;

      reg.status_error_anticipating_empty_fifo <= reg.status_error_anticipating_empty_fifo OR error_anticipating_empty_fifo;
      reg.status_error_bad_component_error     <= reg.status_error_bad_component_error OR error_bad_component_error;

      paddr             := "000000";
      paddr(7 DOWNTO 2) := apbi.paddr(7 DOWNTO 2);
      prdata            <= (OTHERS => '0');
      IF apbi.psel(pindex) = '1' THEN
        -- APB DMA READ  --
        CASE paddr(7 DOWNTO 2) IS
          WHEN "000000" => prdata(0) <= reg.config_active_interruption_onNewMatrix;
                           prdata(1) <= reg.config_active_interruption_onError;
          WHEN "000001" => prdata(0) <= reg.status_ready_matrix_f0_0;
                           prdata(1) <= reg.status_ready_matrix_f0_1;
                           prdata(2) <= reg.status_ready_matrix_f1;
                           prdata(3) <= reg.status_ready_matrix_f2;
                           prdata(4) <= reg.status_error_anticipating_empty_fifo;
                           prdata(5) <= reg.status_error_bad_component_error;
          WHEN "000010" => prdata <= reg.addr_matrix_f0_0;
          WHEN "000011" => prdata <= reg.addr_matrix_f0_1;
          WHEN "000100" => prdata <= reg.addr_matrix_f1;
          WHEN "000101" => prdata <= reg.addr_matrix_f2;
          WHEN "000110" => prdata <= debug_reg;
          WHEN OTHERS   => NULL;
        END CASE;
        IF (apbi.pwrite AND apbi.penable) = '1' THEN
          -- APB DMA WRITE --
          CASE paddr(7 DOWNTO 2) IS
            WHEN "000000" => reg.config_active_interruption_onNewMatrix <= apbi.pwdata(0);
                             reg.config_active_interruption_onError <= apbi.pwdata(1);
            WHEN "000001" => reg.status_ready_matrix_f0_0 <= apbi.pwdata(0);
                             reg.status_ready_matrix_f0_1             <= apbi.pwdata(1);
                             reg.status_ready_matrix_f1               <= apbi.pwdata(2);
                             reg.status_ready_matrix_f2               <= apbi.pwdata(3);
                             reg.status_error_anticipating_empty_fifo <= apbi.pwdata(4);
                             reg.status_error_bad_component_error     <= apbi.pwdata(5);
            WHEN "000010" => reg.addr_matrix_f0_0 <= apbi.pwdata;
            WHEN "000011" => reg.addr_matrix_f0_1 <= apbi.pwdata;
            WHEN "000100" => reg.addr_matrix_f1   <= apbi.pwdata;
            WHEN "000101" => reg.addr_matrix_f2   <= apbi.pwdata;
            WHEN OTHERS   => NULL;
          END CASE;
        END IF;
      END IF;
    END IF;
  END PROCESS lpp_dma_apbreg;

  apbo.pirq(pirq)    <= (reg.config_active_interruption_onNewMatrix AND (ready_matrix_f0_0 OR
                                                                  ready_matrix_f0_1 OR
                                                                   ready_matrix_f1   OR
                                                                   ready_matrix_f2)
                   )
                  OR
                  (reg.config_active_interruption_onError AND (error_anticipating_empty_fifo OR
                                                              error_bad_component_error)
                  );
  



  
  apbo.pindex  <= pindex;
  apbo.pconfig <= pconfig;
  apbo.prdata  <= prdata;


END beh;