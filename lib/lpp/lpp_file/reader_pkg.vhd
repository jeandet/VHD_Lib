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
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

LIBRARY std;
USE std.textio.ALL;

LIBRARY lpp;
USE lpp.data_type_pkg.ALL;

PACKAGE reader_pkg IS

  CONSTANT CHARACTER_COMMENT : CHARACTER := '#';

  FUNCTION get_array_real (
    file_in      : TEXT;
    nb_data_read : INTEGER)
    RETURN array_real;
  
  FUNCTION get_array_integer (
    file_in      : TEXT;
    nb_data_read : INTEGER)
    RETURN array_integer;

  
END reader_pkg;

PACKAGE BODY reader_pkg IS
  
  FUNCTION get_array_real (
    file_name       : STRING;
    nb_data_to_read : INTEGER)
    RETURN array_real
  IS
  	VARIABLE GOOD : BOOLEAN;
    VARIABLE array_real_v : array_real(0 TO nb_data_to_read-1);
    VARIABLE real_p : REAL;
    VARIABLE nb_data_read : INTEGER := 0;
    FILE     file_p       : TEXT;
    VARIABLE line_p       : LINE;
  BEGIN
    GOOD := false;
    file_open(file_p, file_name, read_mode);
    WHILE (NOT endfile(file_p)) AND (nb_data_read <nb_data_to_read) LOOP
      readline(file_p, line_p);
      read(line_p, real_p, GOOD);
      IF GOOD THEN
        array_real_v(nb_data_read) := real_p;
        nb_data_read := nb_data_read + 1;
      END IF;      
    END LOOP;
    IF nb_data_read < nb_data_to_read THEN
      GOOD := false;
    ELSE
      GOOD := true;
    END IF;
    RETURN array_real_v;    
  END get_array_real;
  
  FUNCTION get_array_integer (
    file_name       : STRING;
    nb_data_to_read : INTEGER)
    RETURN array_integer
  IS
  	VARIABLE GOOD : BOOLEAN;
    VARIABLE array_integer_v : array_integer(0 TO nb_data_to_read-1);
    VARIABLE integer_p       : INTEGER;
    VARIABLE nb_data_read : INTEGER := 0;
    FILE     file_p       : TEXT;
    VARIABLE line_p       : LINE;
  BEGIN
    GOOD := false;
    file_open(file_p, file_name, read_mode);
    WHILE (NOT endfile(file_p)) AND (nb_data_read <nb_data_to_read) LOOP
      readline(file_p, line_p);
      read(line_p, integer_p, GOOD);
      IF GOOD THEN
        array_integer_v(nb_data_read) := integer_p;
        nb_data_read := nb_data_read + 1;
      END IF;      
    END LOOP;
    IF nb_data_read < nb_data_to_read THEN
      GOOD := false;
    ELSE
      GOOD := true;
    END IF;
    RETURN array_integer_v;    
  END get_array_integer;

  
  
END reader_pkg;