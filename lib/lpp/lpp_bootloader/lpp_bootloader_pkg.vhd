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

PACKAGE lpp_bootloader_pkg IS
  
  COMPONENT lpp_bootloader
    GENERIC (
      pindex : INTEGER;
      paddr  : INTEGER;
      pmask  : INTEGER;
      hindex : INTEGER;
      haddr  : INTEGER;
      hmask  : INTEGER);
    PORT (
      HCLK    : IN  STD_ULOGIC;
      HRESETn : IN  STD_ULOGIC;
      apbi    : IN  apb_slv_in_type;
      apbo    : OUT apb_slv_out_type;
      ahbsi : IN  ahb_slv_in_type;
      ahbso : OUT ahb_slv_out_type);
  END COMPONENT;
  
  COMPONENT bootrom
    GENERIC (
      hindex : INTEGER;
      haddr  : INTEGER;
      hmask  : INTEGER;
      pipe   : INTEGER;
      tech   : INTEGER;
      kbytes : INTEGER);
    PORT (
      rst   : IN  STD_ULOGIC;
      clk   : IN  STD_ULOGIC;
      ahbsi : IN  ahb_slv_in_type;
      ahbso : OUT ahb_slv_out_type);
  END COMPONENT;

END lpp_bootloader_pkg;
