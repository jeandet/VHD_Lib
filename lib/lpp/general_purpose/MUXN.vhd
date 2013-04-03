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
--                    Mail   : Jean-christophe.pellion@lpp.polytechnique.fr
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_1164.ALL;
LIBRARY lpp;
USE lpp.general_purpose.ALL;

ENTITY MUXN IS
  GENERIC(
    Input_SZ : INTEGER := 16;
    NbStage  : INTEGER := 2);
  PORT(
    sel   : IN  STD_LOGIC_VECTOR(NbStage-1 DOWNTO 0);
    --INPUT : IN  ARRAY (0 TO (2**NbStage)-1) OF STD_LOGIC_VECTOR(Input_SZ-1 DOWNTO 0);
    INPUT : IN  MUX_INPUT_TYPE(0 TO (2**NbStage)-1,Input_SZ-1 DOWNTO 0);
    RES   : OUT MUX_OUTPUT_TYPE(Input_SZ-1 DOWNTO 0));
END ENTITY;

ARCHITECTURE ar_MUXN OF MUXN IS
  COMPONENT MUXN
    GENERIC (
      Input_SZ : INTEGER;
      NbStage  : INTEGER);
    PORT (
      sel   : IN  STD_LOGIC_VECTOR(NbStage-1 DOWNTO 0);
      INPUT : IN  MUX_INPUT_TYPE(0 TO (2**NbStage)-1,Input_SZ-1 DOWNTO 0);
      --INPUT : IN  ARRAY (0 TO (2**NbStage)-1) OF STD_LOGIC_VECTOR(Input_SZ-1 DOWNTO 0);
      RES   : OUT MUX_OUTPUT_TYPE(Input_SZ-1 DOWNTO 0));
  END COMPONENT;

  --SIGNAL S : ARRAY (0 TO (2**(NbStage-1)-1)) OF STD_LOGIC_VECTOR(Input_SZ-1 DOWNTO 0);
    SIGNAL S: MUX_INPUT_TYPE(0 TO (2**(NbStage-1))-1,Input_SZ-1 DOWNTO 0);
  
    
BEGIN

  all_input : FOR I IN 0 TO (2**(NbStage-1))-1 GENERATE
    all_input: FOR J IN Input_SZ-1 DOWNTO 0 GENERATE
      S(I,J) <= INPUT(2*I,J) WHEN sel(0) = '0' ELSE INPUT(2*I+1,J);
    END GENERATE all_input;
  END GENERATE all_input;

  NB_STAGE_1: IF NbStage = 1 GENERATE
    all_input: FOR J IN Input_SZ-1 DOWNTO 0 GENERATE
      RES(J) <= S(0,J);
    END GENERATE all_input;      
  END GENERATE NB_STAGE_1;

  NB_STAGE_2 : IF NbStage = 2 GENERATE
    all_input: FOR I IN Input_SZ-1 DOWNTO 0 GENERATE
      RES(I) <= S(0,I) WHEN sel(1) = '0' ELSE S(1,I);
    END GENERATE all_input;
  END GENERATE NB_STAGE_2;

  NB_STAGE_PLUS : IF NbStage > 2 GENERATE
    MUXN_1 : MUXN
      GENERIC MAP (
        Input_SZ => Input_SZ,
        NbStage  => NbStage-1)
      PORT MAP (
        sel   => sel(NbStage-1 DOWNTO 1),
        INPUT => S,
        RES   => RES);    
  END GENERATE NB_STAGE_PLUS;

END ar_MUXN;
