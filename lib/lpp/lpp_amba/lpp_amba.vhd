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
library ieee;
use ieee.std_logic_1164.all;
library grlib;
use grlib.amba.all;
-- pragma translate_off
use std.textio.all;
-- pragma translate_on
  


package lpp_amba is

constant VENDOR_LPP        : amba_vendor_type := 16#19#;

-- LPP device ids

constant ROCKET_TM	                : amba_device_type := 16#001#;
constant otherCore         	        : amba_device_type := 16#002#;
constant LPP_SIMPLE_DIODE	        : amba_device_type := 16#003#;
constant LPP_MULTI_DIODE	        : amba_device_type := 16#004#;
constant LPP_LCD_CTRLR		        : amba_device_type := 16#005#;
constant LPP_UART                       : amba_device_type := 16#006#;
constant LPP_CNA                        : amba_device_type := 16#007#;
constant LPP_ADC_7688                   : amba_device_type := 16#008#;

component APB_SIMPLE_DIODE is
  generic (
    pindex   : integer := 0;
    paddr    : integer := 0;
    pmask    : integer := 16#fff#;
    pirq     : integer := 0;
    abits    : integer := 8);
  port (
    rst    : in  std_ulogic;
    clk    : in  std_ulogic;
    apbi   : in  apb_slv_in_type;
    apbo   : out apb_slv_out_type;
    LED    : out std_ulogic
    );
end component;


component APB_MULTI_DIODE is
  generic (
    pindex   : integer := 0;
    paddr    : integer := 0;
    pmask    : integer := 16#fff#;
    pirq     : integer := 0;
    abits    : integer := 8);
  port (
    rst    : in  std_ulogic;
    clk    : in  std_ulogic;
    apbi   : in  apb_slv_in_type;
    apbo   : out apb_slv_out_type;
    LED    : out std_logic_vector(2 downto 0)
    );
end component;

end;
