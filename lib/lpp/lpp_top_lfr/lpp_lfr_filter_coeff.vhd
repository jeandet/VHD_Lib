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

PACKAGE lpp_lfr_filter_coeff IS

  --REAL
  TYPE COEFF_CEL_REAL       IS ARRAY (1 TO 6) OF REAL;  -- b0, b1, b2, a0, a1, a2
  TYPE COEFF_CEL_ARRAY_REAL IS ARRAY (INTEGER RANGE <>) OF COEFF_CEL_REAL;
  --INTEGER
  TYPE COEFF_CEL_INTEGER       IS ARRAY (1 TO 6) OF INTEGER;  -- b0, b1, b2, a0, a1, a2
  TYPE COEFF_CEL_ARRAY_INTEGER IS ARRAY (INTEGER RANGE <>) OF COEFF_CEL_INTEGER;

  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  FUNCTION get_IIR_CEL_FILTER_CONFIG (
    COEFFICIENT_SIZE , POINT_POSITION, CEL_NUMBER  : INTEGER;
    SOS_array          : COEFF_CEL_ARRAY_REAL;--(INTEGER RANGE <>);
    GAIN_array         : COEFF_CEL_REAL
    ) RETURN STD_LOGIC_VECTOR;
  
  
END lpp_lfr_filter_coeff;

PACKAGE BODY lpp_lfr_filter_coeff IS
  
  FUNCTION get_IIR_CEL_FILTER_CONFIG (
    COEFFICIENT_SIZE , POINT_POSITION, CEL_NUMBER : INTEGER;
    SOS_array                                     : COEFF_CEL_ARRAY_REAL;--(INTEGER RANGE <>);
    GAIN_array                                    : COEFF_CEL_REAL
    ) RETURN STD_LOGIC_VECTOR IS

    VARIABLE config_vector : STD_LOGIC_VECTOR((CEL_NUMBER * 5 * COEFFICIENT_SIZE)-1 DOWNTO 0);
    VARIABLE SOS_with_gain_array : COEFF_CEL_ARRAY_REAL(1 TO CEL_NUMBER);
    
    VARIABLE SOS_with_gain_array_integer : COEFF_CEL_ARRAY_INTEGER(1 TO CEL_NUMBER);
  BEGIN

    all_cel: FOR I IN 1 TO CEL_NUMBER LOOP
      all_param_b : FOR J IN 1 TO 3 LOOP        
        SOS_with_gain_array(I)(J) := SOS_array(I)(J) * GAIN_array(I);
      END LOOP all_param_b;
      all_param_a : FOR J IN 4 TO 6 LOOP        
        SOS_with_gain_array(I)(J) := SOS_array(I)(J);
      END LOOP all_param_a;
    END LOOP all_cel;

    all_cel_int: FOR I IN 1 TO CEL_NUMBER LOOP
      all_param_int: FOR J IN 1 TO 6 LOOP
        SOS_with_gain_array_integer(I)(J) := INTEGER( SOS_with_gain_array(I)(J) * REAL(2**(POINT_POSITION)) );
      END LOOP all_param_int;
    END LOOP all_cel_int;

    all_cel_output: FOR I IN 1 TO CEL_NUMBER LOOP
      all_param_b_out: FOR J IN 1 TO 3 LOOP
        config_vector( (((I-1)*5)+3-J)*COEFFICIENT_SIZE + COEFFICIENT_SIZE -1 DOWNTO (((I-1)*5)+3-J)*COEFFICIENT_SIZE )
          := std_logic_vector(TO_SIGNED(SOS_with_gain_array_integer(I)(J),COEFFICIENT_SIZE ));
      END LOOP all_param_b_out;
      config_vector( (((I-1)*5)+3)*COEFFICIENT_SIZE + COEFFICIENT_SIZE -1 DOWNTO (((I-1)*5)+3)*COEFFICIENT_SIZE )
          := std_logic_vector(TO_SIGNED(SOS_with_gain_array_integer(I)(6),COEFFICIENT_SIZE));
      config_vector( (((I-1)*5)+4)*COEFFICIENT_SIZE + COEFFICIENT_SIZE -1 DOWNTO (((I-1)*5)+4)*COEFFICIENT_SIZE )
          := std_logic_vector(TO_SIGNED(SOS_with_gain_array_integer(I)(5),COEFFICIENT_SIZE));
    END LOOP all_cel_output;

    RETURN config_vector;
    
  END FUNCTION;
  
END lpp_lfr_filter_coeff;
