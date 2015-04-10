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
LIBRARY lpp;
USE lpp.lpp_bootloader_pkg.ALL;
USE lpp.apb_devices_list.ALL;


ENTITY lpp_bootloader IS
  
  GENERIC (
    pindex : INTEGER := 1;
    paddr  : INTEGER := 1;
    pmask  : INTEGER := 16#fff#;
    hindex : INTEGER := 0;
    haddr  : INTEGER := 0;
    hmask  : INTEGER := 16#fff#
    );

  PORT (
    -- AMBA AHB system signals
    HCLK    : IN STD_ULOGIC;
    HRESETn : IN STD_ULOGIC;

    -- AMBA APB Slave Interface
    apbi : IN  apb_slv_in_type;
    apbo : OUT apb_slv_out_type;

    -- AMBA AHB Slave Interface
    ahbsi : IN  ahb_slv_in_type;
    ahbso : OUT ahb_slv_out_type
    );

END lpp_bootloader;

ARCHITECTURE Beh OF lpp_bootloader IS

  CONSTANT REVISION : INTEGER := 1;
  
  CONSTANT pconfig : apb_config_type := (
    0 => ahb_device_reg (VENDOR_LPP, LPP_BOOTLOADER_TYPE, 0, REVISION, 0),
    1 => apb_iobar(paddr, pmask));

  TYPE lpp_bootloader_regs IS RECORD
    config_wait_on_boot    : STD_LOGIC;
    config_start_execution : STD_LOGIC;
    addr_start_execution   : STD_LOGIC_VECTOR(31 DOWNTO 0);
--    addr_fp                : STD_LOGIC_VECTOR(31 DOWNTO 0);
  END RECORD;

  SIGNAL reg : lpp_bootloader_regs;

  SIGNAL prdata : STD_LOGIC_VECTOR(31 DOWNTO 0);

  
BEGIN  -- Beh

  -----------------------------------------------------------------------------
  -- AHBROM 
  -----------------------------------------------------------------------------
  ahbrom_1 : bootrom
    GENERIC MAP (
      hindex => hindex,
      haddr  => haddr,
      hmask  => hmask,
      pipe   => 0,
      tech   => 0,
      kbytes => 1)
    PORT MAP (
      rst   => HRESETn,
      clk   => HCLK,
      ahbsi => ahbsi,
      ahbso => ahbso);

  -----------------------------------------------------------------------------
  -- APB REG
  -----------------------------------------------------------------------------

  lpp_bootloader_apbreg : PROCESS (HCLK, HRESETn)
    VARIABLE paddr : STD_LOGIC_VECTOR(7 DOWNTO 2);
  BEGIN  -- PROCESS lpp_dma_top
    IF HRESETn = '0' THEN                 -- asynchronous reset (active low)
      reg.config_wait_on_boot    <= '1';
      reg.config_start_execution <= '0';
      reg.addr_start_execution   <= X"40000000";
      prdata                     <= (OTHERS => '0');
    ELSIF HCLK'EVENT AND HCLK = '1' THEN  -- rising clock edge

      paddr             := "000000";
      paddr(7 DOWNTO 2) := apbi.paddr(7 DOWNTO 2);
      prdata            <= (OTHERS => '0');
      IF apbi.psel(pindex) = '1' THEN
        -- APB DMA READ  --
        CASE paddr(7 DOWNTO 2) IS
          WHEN "000000" => prdata(0) <= reg.config_wait_on_boot;
                           prdata(31 DOWNTO 1) <= (OTHERS => '0');
          WHEN "000001" => prdata(0) <= reg.config_start_execution;
                           prdata(31 DOWNTO 1) <= (OTHERS => '0');
          WHEN "000010" => prdata <= reg.addr_start_execution;
          WHEN OTHERS   => NULL;
        END CASE;
        IF (apbi.pwrite AND apbi.penable) = '1' THEN
          -- APB DMA WRITE --
          CASE paddr(7 DOWNTO 2) IS
            WHEN "000000" => reg.config_wait_on_boot    <= apbi.pwdata(0);
            WHEN "000001" => reg.config_start_execution <= apbi.pwdata(0);
            WHEN "000010" => reg.addr_start_execution   <= apbi.pwdata;
            WHEN OTHERS   => NULL;
          END CASE;
        END IF;
      END IF;
    END IF;
  END PROCESS lpp_bootloader_apbreg;

  apbo.pirq    <= (OTHERS => '0');
  apbo.pindex  <= pindex;
  apbo.pconfig <= pconfig;
  apbo.prdata  <= prdata;
  
END Beh;
