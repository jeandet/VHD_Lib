------------------------------------------------------------------------------
--  This file is a part of the LPP VHDL IP LIBRARY
--  Copyright (C) 2017, Laboratory of Plasmas Physic - CNRS
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
--                    Author : Alexis Jeandet
--                    Mail   : alexis.jeandet@member.fsf.org
-------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;


PACKAGE CY7C1061DV33_pkg IS

  COMPONENT CY7C1061DV33 IS
    GENERIC
      (ADDR_BITS : INTEGER := 20;
       DATA_BITS : INTEGER := 16;
       depth     : INTEGER := 1048576;

       MEM_ARRAY_DEBUG : INTEGER := 32;

       TimingInfo   : BOOLEAN   := true;
       TimingChecks : STD_LOGIC := '1'
       );
    PORT (
      CE1_b : IN    STD_LOGIC;            -- Chip Enable CE1#
      CE2   : IN    STD_LOGIC;            -- Chip Enable CE2
      WE_b  : IN    STD_LOGIC;            -- Write Enable WE#
      OE_b  : IN    STD_LOGIC;            -- Output Enable OE#
      BHE_b : IN    STD_LOGIC;            -- Byte Enable High BHE#
      BLE_b : IN    STD_LOGIC;            -- Byte Enable Low BLE#
      A     : IN    STD_LOGIC_VECTOR(addr_bits-1 DOWNTO 0);  -- Address Inputs A
      DQ    : INOUT STD_LOGIC_VECTOR(DATA_BITS-1 DOWNTO 0) := (OTHERS => 'Z')-- Read/Write Data IO;
      );
  END COMPONENT;

END CY7C1061DV33_pkg;
