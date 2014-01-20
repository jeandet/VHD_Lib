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
LIBRARY lpp;
USE lpp.lpp_lfr_pkg.ALL;
USE lpp.lpp_ad_conv.ALL;

PACKAGE lpp_debug_lfr_pkg IS

  COMPONENT lpp_debug_dma_singleOrBurst
    GENERIC (
      tech   : INTEGER;
      hindex : INTEGER;
      pindex : INTEGER;
      paddr  : INTEGER;
      pmask  : INTEGER);
    PORT (
      HCLK    : IN  STD_ULOGIC;
      HRESETn : IN  STD_ULOGIC;
      ahbmi   : IN  AHB_Mst_In_Type;
      ahbmo   : OUT AHB_Mst_Out_Type;
      apbi    : IN  apb_slv_in_type;
      apbo    : OUT apb_slv_out_type;
      out_ren  : OUT STD_LOGIC;
      out_send : OUT STD_LOGIC;
      out_done : OUT STD_LOGIC;
      out_dmaout_okay : OUT STD_LOGIC
      );
  END COMPONENT;

  COMPONENT lpp_debug_lfr
    GENERIC (
      tech   : INTEGER;
      hindex : INTEGER;
      pindex : INTEGER;
      paddr  : INTEGER;
      pmask  : INTEGER);
    PORT (
      HCLK     : IN  STD_ULOGIC;
      HRESETn  : IN  STD_ULOGIC;
      apbi     : IN  apb_slv_in_type;
      apbo     : OUT apb_slv_out_type;
      sample_B : OUT Samples14v(2 DOWNTO 0);
      sample_E : OUT Samples14v(4 DOWNTO 0));
  END COMPONENT;

  
END;