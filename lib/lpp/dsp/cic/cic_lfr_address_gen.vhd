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
--                    Author : Jean-christophe Pellion
--                    Mail   : jean-christophe.pellion@lpp.polytechnique.fr
--                             jean-christophe.pellion@easii-ic.com
----------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.all;

LIBRARY lpp;
USE lpp.cic_pkg.ALL;
USE lpp.data_type_pkg.ALL;

ENTITY cic_lfr_address_gen IS 
  PORT (
    clk            : IN  STD_LOGIC;
    rstn           : IN  STD_LOGIC;
    run            : IN  STD_LOGIC;

    addr_base       : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    addr_init       : IN STD_LOGIC;
    addr_add_1      : IN STD_LOGIC;
    
    addr            : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)    
    );
END cic_lfr_address_gen;

ARCHITECTURE beh OF cic_lfr_address_gen IS
  SIGNAL address_reg_s : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL address_reg   : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      address_reg <= (OTHERS => '0');
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      address_reg <= address_reg_s;
    END IF;
  END PROCESS;

  address_reg_s <= (OTHERS => '0')                                                        WHEN run = '0' ELSE
                   STD_LOGIC_VECTOR(to_unsigned(to_integer(UNSIGNED(address_reg)) + 1,8)) WHEN addr_add_1 = '1' AND addr_init = '0' ELSE
                   STD_LOGIC_VECTOR(to_unsigned(to_integer(UNSIGNED(addr_base)) + 1,8))   WHEN addr_add_1 = '1' AND addr_init = '1' ELSE
                   addr_base                                                              WHEN addr_add_1 = '0' AND addr_init = '1' ELSE
                   address_reg;

  addr <= address_reg WHEN addr_init = '0' ELSE addr_base;
                     
END beh;

