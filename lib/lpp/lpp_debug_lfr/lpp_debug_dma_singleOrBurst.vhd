
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


ENTITY lpp_debug_dma_singleOrBurst IS
  GENERIC (
    tech   : INTEGER := inferred;
    hindex : INTEGER := 2;
    pindex : INTEGER := 4;
    paddr  : INTEGER := 4;
    pmask  : INTEGER := 16#fff#
    );
  PORT (
    -- AMBA AHB system signals
    HCLK    : IN  STD_ULOGIC;
    HRESETn : IN  STD_ULOGIC;
    -- AMBA AHB Master Interface
    ahbmi   : IN  AHB_Mst_In_Type;
    ahbmo   : OUT AHB_Mst_Out_Type;
    -- AMBA AHB Master Interface
    apbi    : IN  apb_slv_in_type;
    apbo    : OUT apb_slv_out_type;
    -- observation SIGNAL
    out_ren  : OUT STD_LOGIC;
    out_send : OUT STD_LOGIC;
    out_done : OUT STD_LOGIC;
    out_dmaout_okay : OUT STD_LOGIC
    );                                      
END;

ARCHITECTURE Behavioral OF lpp_debug_dma_singleOrBurst IS
  SIGNAL run         : STD_LOGIC;
  SIGNAL send        : STD_LOGIC;
  SIGNAL valid_burst : STD_LOGIC;
  SIGNAL done        : STD_LOGIC;
  SIGNAL ren         : STD_LOGIC;
  SIGNAL address     : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data        : STD_LOGIC_VECTOR(31 DOWNTO 0);
  --

  CONSTANT REVISION : INTEGER := 1;
  
  CONSTANT pconfig : apb_config_type := (
    0 => ahb_device_reg (VENDOR_LPP, LPP_DEBUG_DMA, 2, REVISION, 0),
    1 => apb_iobar(paddr, pmask));

  TYPE lpp_debug_dma_regs IS RECORD
    run         : STD_LOGIC;
    send        : STD_LOGIC;
    valid_burst : STD_LOGIC;
    done        : STD_LOGIC;
    ren         : STD_LOGIC;
    addr        : STD_LOGIC_VECTOR(31 DOWNTO 0);
    data        : STD_LOGIC_VECTOR(31 DOWNTO 0);
    nb_ren      : STD_LOGIC_VECTOR(31 DOWNTO 0);
  END RECORD;
  SIGNAL reg : lpp_debug_dma_regs;

  SIGNAL prdata : STD_LOGIC_VECTOR(31 DOWNTO 0);
  
BEGIN
  out_ren  <= ren;
  out_send <= send;
  out_done <= done;
  
  lpp_dma_singleOrBurst_1 : lpp_dma_singleOrBurst
    GENERIC MAP (
      tech   => tech,
      hindex => hindex)
    PORT MAP (
      HCLK           => HCLK,
      HRESETn        => HRESETn,
      run            => run,            --
      AHB_Master_In  => ahbmi,
      AHB_Master_Out => ahbmo,
      send           => send,           --
      valid_burst    => valid_burst,    --
      done           => done,           -- out
      ren            => ren,            -- out
      address        => address,
      data           => data,
      debug_dmaout_okay => out_dmaout_okay);


  run         <= reg.run;
  valid_burst <= reg.valid_burst;
  send        <= reg.send;
  address     <= reg.addr;
  data        <= reg.data;

  lpp_lfr_apbreg : PROCESS (HCLK, HRESETn)
    VARIABLE paddr : STD_LOGIC_VECTOR(7 DOWNTO 2);
  BEGIN  -- PROCESS lpp_dma_top
    IF HRESETn = '0' THEN               -- asynchronous reset (active low)
      reg.run         <= '0';
      reg.send        <= '0';
      reg.valid_burst <= '0';
      reg.done        <= '0';
      reg.ren         <= '0';
      reg.addr        <= (OTHERS => '0');
      reg.data        <= (OTHERS => '0');
      reg.nb_ren      <= (OTHERS => '0');

      apbo.pirq <= (OTHERS => '0');
    ELSIF HCLK'EVENT AND HCLK = '1' THEN  -- rising clock edge
      paddr             := "000000";
      paddr(7 DOWNTO 2) := apbi.paddr(7 DOWNTO 2);
      prdata            <= (OTHERS => '0');
      ------------------------------------
      reg.send          <= '0';
      IF done = '1' THEN
        reg.done <= '1';
      END IF;
      IF ren = '0' THEN
        reg.ren <= '1';
        reg.nb_ren  <= STD_LOGIC_VECTOR(UNSIGNED(reg.nb_ren) + 1);
      END IF;
      ------------------------------------

      IF apbi.psel(pindex) = '1' THEN
        -- APB DMA READ  --
        CASE paddr(7 DOWNTO 2) IS
          --
          WHEN "000000" => prdata(0) <= reg.run;
                           prdata(1) <= reg.send;
                           prdata(2) <= reg.valid_burst;
                           prdata(3) <= reg.done;
                           prdata(4) <= reg.ren;
          WHEN "000001" => prdata <= reg.addr;
          WHEN "000010" => prdata <= reg.data;
          WHEN "000011" => prdata <= reg.nb_ren;

          WHEN OTHERS => NULL;
        END CASE;
        IF (apbi.pwrite AND apbi.penable) = '1' THEN
          -- APB DMA WRITE --
          CASE paddr(7 DOWNTO 2) IS
            --
            WHEN "000000" => reg.run         <= apbi.pwdata(0);
                             reg.send        <= apbi.pwdata(1);
                             reg.valid_burst <= apbi.pwdata(2);
                             reg.done        <= apbi.pwdata(3);
                             reg.ren         <= apbi.pwdata(4);
            WHEN "000001" => reg.addr   <= apbi.pwdata;
            WHEN "000010" => reg.data   <= apbi.pwdata;
            --WHEN "000011" => reg.nb_ren <= apbi.pwdata;
            WHEN OTHERS   => NULL;
          END CASE;
        END IF;
      END IF;
      
    END IF;
  END PROCESS lpp_lfr_apbreg;

  apbo.pindex  <= pindex;
  apbo.pconfig <= pconfig;
  apbo.prdata  <= prdata;

  
  
END Behavioral;
