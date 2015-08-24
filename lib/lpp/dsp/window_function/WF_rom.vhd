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

LIBRARY lpp;
USE lpp.general_purpose.ALL;
USE lpp.window_function_pkg.ALL;

ENTITY WF_rom IS
  GENERIC (
    SIZE_PARAM         : INTEGER := 10;
    NB_POINT_BY_WINDOW : INTEGER := 256
    );
  PORT (
    data  : OUT STD_LOGIC_VECTOR(SIZE_PARAM-1 DOWNTO 0);
    index : IN  INTEGER RANGE 0 TO NB_POINT_BY_WINDOW-1 ;
    PARAM_ALL_POSITIVE : OUT STD_LOGIC
    );
END WF_rom;

ARCHITECTURE beh OF WF_rom IS

  CONSTANT SIZE_ARRAY       : INTEGER := 256;  -- 
  CONSTANT SIZE_ARRAY_PARAM : INTEGER := 16;   -- bits
  TYPE array_std_logic_vector IS ARRAY (SIZE_ARRAY-1 DOWNTO 0) OF STD_LOGIC_VECTOR(SIZE_ARRAY_PARAM-1 DOWNTO 0);
  CONSTANT ROM_array : array_std_logic_vector := ( 
    X"0000",X"0004",X"0013",X"002C",X"004F",X"007C",X"00B2",X"00F3",
    X"013D",X"0191",X"01EE",X"0256",X"02C6",X"0341",X"03C5",X"0452",
    X"04E8",X"0588",X"0631",X"06E2",X"079D",X"0860",X"092C",X"0A01",
    X"0ADE",X"0BC3",X"0CB0",X"0DA5",X"0EA3",X"0FA7",X"10B4",X"11C7",
    X"12E2",X"1404",X"152C",X"165C",X"1792",X"18CE",X"1A10",X"1B58",
    X"1CA6",X"1DF9",X"1F51",X"20AF",X"2211",X"2379",X"24E4",X"2654",
    X"27C8",X"293F",X"2ABA",X"2C39",X"2DBA",X"2F3E",X"30C5",X"324E",
    X"33DA",X"3567",X"36F6",X"3886",X"3A18",X"3BAA",X"3D3D",X"3ED1",
    X"4064",X"41F8",X"438B",X"451E",X"46B0",X"4841",X"49D1",X"4B5F",
    X"4CEB",X"4E75",X"4FFE",X"5183",X"5306",X"5486",X"5603",X"577C",
    X"58F2",X"5A64",X"5BD1",X"5D3B",X"5E9F",X"5FFF",X"615B",X"62B1",
    X"6401",X"654C",X"6691",X"67D0",X"6909",X"6A3C",X"6B68",X"6C8D",
    X"6DAB",X"6EC3",X"6FD2",X"70DB",X"71DC",X"72D5",X"73C6",X"74B0",
    X"7591",X"7669",X"773A",X"7801",X"78C0",X"7977",X"7A24",X"7AC8",
    X"7B63",X"7BF5",X"7C7D",X"7CFD",X"7D72",X"7DDE",X"7E41",X"7E99",
    X"7EE9",X"7F2E",X"7F69",X"7F9B",X"7FC3",X"7FE0",X"7FF4",X"7FFE",
    X"7FFE",X"7FF4",X"7FE0",X"7FC3",X"7F9B",X"7F69",X"7F2E",X"7EE9",
    X"7E99",X"7E41",X"7DDE",X"7D72",X"7CFD",X"7C7D",X"7BF5",X"7B63",
    X"7AC8",X"7A24",X"7977",X"78C0",X"7801",X"773A",X"7669",X"7591",
    X"74B0",X"73C6",X"72D5",X"71DC",X"70DB",X"6FD2",X"6EC3",X"6DAB",
    X"6C8D",X"6B68",X"6A3C",X"6909",X"67D0",X"6691",X"654C",X"6401",
    X"62B1",X"615B",X"6000",X"5E9F",X"5D3B",X"5BD1",X"5A64",X"58F2",
    X"577C",X"5603",X"5486",X"5306",X"5183",X"4FFE",X"4E75",X"4CEB",
    X"4B5F",X"49D1",X"4841",X"46B0",X"451E",X"438B",X"41F8",X"4064",
    X"3ED1",X"3D3D",X"3BAA",X"3A18",X"3886",X"36F6",X"3567",X"33DA",
    X"324E",X"30C5",X"2F3E",X"2DBA",X"2C39",X"2ABA",X"293F",X"27C8",
    X"2654",X"24E4",X"2379",X"2211",X"20AF",X"1F51",X"1DF9",X"1CA6",
    X"1B58",X"1A10",X"18CE",X"1792",X"165C",X"152C",X"1404",X"12E2",
    X"11C7",X"10B4",X"0FA7",X"0EA3",X"0DA5",X"0CB0",X"0BC3",X"0ADE",
    X"0A01",X"092C",X"0860",X"079D",X"06E2",X"0631",X"0588",X"04E8",
    X"0452",X"03C5",X"0341",X"02C6",X"0256",X"01EE",X"0191",X"013D",
    X"00F3",X"00B2",X"007C",X"004F",X"002C",X"0013",X"0004",X"0000");

  SIGNAL data_selected : STD_LOGIC_VECTOR(SIZE_ARRAY_PARAM-1 DOWNTO 0);
BEGIN

  PARAM_ALL_POSITIVE <= '1';

  ALL_PARAM_DEFINE: IF NB_POINT_BY_WINDOW < SIZE_ARRAY + 1 GENERATE
    data_selected <= ROM_array(index);
  END GENERATE ALL_PARAM_DEFINE;
  
  HALF_PARAM_DEFINE: IF NB_POINT_BY_WINDOW > SIZE_ARRAY AND NB_POINT_BY_WINDOW < 2 * SIZE_ARRAY + 1 GENERATE
    data_selected <= ROM_array(index) WHEN index < SIZE_ARRAY ELSE 
                     ROM_array(2*SIZE_ARRAY-1-index);
  END GENERATE HALF_PARAM_DEFINE;

  data <= data_selected(SIZE_ARRAY_PARAM-1 DOWNTO SIZE_ARRAY_PARAM-SIZE_PARAM);
  
END beh;