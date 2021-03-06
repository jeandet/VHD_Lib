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
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

PACKAGE data_type_pkg IS

  TYPE array_integer IS ARRAY (NATURAL RANGE <>) OF INTEGER;
  TYPE array_real    IS ARRAY (NATURAL RANGE <>) OF REAL;
  TYPE array_std_logic_vector_16b IS ARRAY (NATURAL RANGE <>) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
  
  TYPE sample_vector IS ARRAY(NATURAL RANGE <>, NATURAL RANGE <>) OF STD_LOGIC;

  FUNCTION to_array_std_logic_vector_16b (
    array_in : array_real)
    RETURN array_std_logic_vector_16b;
  
END data_type_pkg;

PACKAGE BODY data_type_pkg IS

  FUNCTION to_array_std_logic_vector_16b (
    array_in : array_real)
    RETURN array_std_logic_vector_16b IS
    VARIABLE array_out : array_std_logic_vector_16b(array_in'RANGE);
  BEGIN
    all_value: FOR I IN array_in'RANGE LOOP
      array_out(I) := STD_LOGIC_VECTOR(to_signed(INTEGER(array_in(I) * 2.0**15),16));
    END LOOP all_value;
    RETURN array_out;
  END to_array_std_logic_vector_16b;

END data_type_pkg;
