
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


ENTITY lpp_dma_singleOrBurst IS
  GENERIC (
    tech                    : INTEGER := inferred;
    hindex                  : INTEGER := 2
    );
  PORT (
    -- AMBA AHB system signals
    HCLK               : IN  STD_ULOGIC;
    HRESETn            : IN  STD_ULOGIC;
    --
    run : IN STD_LOGIC;
    -- AMBA AHB Master Interface
    AHB_Master_In      : IN  AHB_Mst_In_Type;
    AHB_Master_Out     : OUT AHB_Mst_Out_Type;
    --
    send               : IN  STD_LOGIC;
    valid_burst        : IN  STD_LOGIC;  -- (1 => BURST , 0 => SINGLE)
    done               : OUT STD_LOGIC;
    ren                : OUT STD_LOGIC;
    address            : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    data               : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    --
    debug_dmaout_okay : OUT STD_LOGIC
    
    );                                      
END;

ARCHITECTURE Behavioral OF lpp_dma_singleOrBurst IS
  -----------------------------------------------------------------------------
  SIGNAL DMAIn  : DMA_In_Type;
  SIGNAL DMAOut : DMA_OUt_Type;
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -- CONTROL
  SIGNAL single_send : STD_LOGIC;
  SIGNAL burst_send  : STD_LOGIC;
  
  -----------------------------------------------------------------------------
  -- SEND SINGLE MODULE
  SIGNAL single_dmai            : DMA_In_Type;
  
  SIGNAL single_send_ok         : STD_LOGIC;
  SIGNAL single_send_ko         : STD_LOGIC;
  SIGNAL single_ren             : STD_LOGIC;
  -----------------------------------------------------------------------------
  -- SEND SINGLE MODULE  
  SIGNAL burst_dmai            : DMA_In_Type;
  
  SIGNAL burst_send_ok         : STD_LOGIC;
  SIGNAL burst_send_ko         : STD_LOGIC;
  SIGNAL burst_ren             : STD_LOGIC;
  -----------------------------------------------------------------------------
  SIGNAL data_2_halfword      : STD_LOGIC_VECTOR(31 DOWNTO 0);
  -----------------------------------------------------------------------------
  -- \/ -- 20/02/2014 -- JC Pellion
  SIGNAL send_reg : STD_LOGIC;
  SIGNAL send_s   : STD_LOGIC;
  -- /\ --
  
  
BEGIN

  debug_dmaout_okay <= DMAOut.OKAY;

  
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
  -- \/ -- 20/02/2014 -- JC Pellion
  PROCESS (HCLK, HRESETn)
  BEGIN 
    IF HRESETn = '0' THEN
      send_reg <= '0';
    ELSIF HCLK'event AND HCLK = '1' THEN 
      send_reg <= send;      
    END IF;
  END PROCESS;
  send_s <= send_reg;
  
  single_send   <= send_s  WHEN valid_burst = '0' ELSE '0';
  burst_send    <= send_s  WHEN valid_burst = '1' ELSE '0';
  -- /\ --

  DMAIn         <= single_dmai      WHEN valid_burst = '0' ELSE burst_dmai;

  -- TODO : verifier
  done  <= single_send_ok OR single_send_ko OR burst_send_ok  OR burst_send_ko;
  --done  <= single_send_ok OR single_send_ko WHEN valid_burst = '0' ELSE
  --         burst_send_ok  OR burst_send_ko;

  --ren   <= burst_ren     WHEN valid_burst = '1' ELSE
  --         NOT single_send_ok;
  --ren   <= burst_ren AND single_ren;

  -- \/ JC - 20/01/2014 \/
  ren   <= burst_ren    WHEN valid_burst = '1' ELSE
           single_ren;

  
  --ren <= '0' WHEN DMAOut.OKAY = '1' ELSE
  --       '1';
  -- /\ JC - 20/01/2014 /\
  
  -----------------------------------------------------------------------------
  -- SEND 1 word by DMA
  -----------------------------------------------------------------------------
  lpp_dma_send_1word_1 : lpp_dma_send_1word
    PORT MAP (
      HCLK    => HCLK,
      HRESETn => HRESETn,
      DMAIn   => single_dmai,  
      DMAOut  => DMAOut,

      send    => single_send,
      address => address,
      data    => data_2_halfword,
      ren     => single_ren,
      
      send_ok => single_send_ok,        -- TODO
      send_ko => single_send_ko         -- TODO
      );

  -----------------------------------------------------------------------------
  -- SEND 16 word by DMA (in burst mode)
  -----------------------------------------------------------------------------
  --data_2_halfword(31 DOWNTO 0) <= data(15 DOWNTO 0) & data (31 DOWNTO 16);
  data_2_halfword(31 DOWNTO 0) <= data(31 DOWNTO 0);
  
  lpp_dma_send_16word_1 : lpp_dma_send_16word
    PORT MAP (
      HCLK    => HCLK,
      HRESETn => HRESETn,
      DMAIn   => burst_dmai,      
      DMAOut  => DMAOut,

      send    => burst_send,
      address => address,
      data    => data_2_halfword,
      ren     => burst_ren,
      
      send_ok => burst_send_ok,
      send_ko => burst_send_ko);
  
END Behavioral;
