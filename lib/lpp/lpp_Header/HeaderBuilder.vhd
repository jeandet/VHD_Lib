------------------------------------------------------------------------------
--  This file is a part of the LPP VHDL IP LIBRARY
--  Copyright (C) 2009 - 2012, Laboratory of Plasmas Physic - CNRS
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
------------------------------------------------------------------------------
--                    Author : Martin Morlot
--                     Mail : martin.morlot@lpp.polytechnique.fr
------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY HeaderBuilder IS
  GENERIC(
    Data_sz : INTEGER := 32);
  PORT(
    clkm : IN STD_LOGIC;
    rstn : IN STD_LOGIC;

    Statu        : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    Matrix_Type  : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
    Matrix_Write : IN  STD_LOGIC;
    Valid        : OUT STD_LOGIC;

    dataIN  : IN  STD_LOGIC_VECTOR((2*Data_sz)-1 DOWNTO 0);
    emptyIN : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
    RenOUT  : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);

    dataOUT  : OUT STD_LOGIC_VECTOR(Data_sz-1 DOWNTO 0);
    emptyOUT : OUT STD_LOGIC;
    RenIN    : IN  STD_LOGIC;

    header     : OUT STD_LOGIC_VECTOR(Data_sz-1 DOWNTO 0);
    header_val : OUT STD_LOGIC;
    header_ack : IN  STD_LOGIC
    );
END ENTITY;


ARCHITECTURE ar_HeaderBuilder OF HeaderBuilder IS

  SIGNAL Matrix_Param : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL Write_reg    : STD_LOGIC;
  SIGNAL Data_cpt     : INTEGER;
  SIGNAL MAX          : INTEGER;

  TYPE   etat IS (idle0, idle1, pong0, pong1);
  SIGNAL ect : etat;

BEGIN

  PROCESS (clkm, rstn)
  BEGIN
    IF(rstn = '0')then
      ect                <= idle0;
      Valid              <= '0';
      header_val         <= '0';
      header(5 DOWNTO 0) <= (OTHERS => '0');
      Write_reg          <= '0';
      Data_cpt           <= 0;
      MAX                <= 128;

      
    ELSIF(clkm' event AND clkm = '1')then
      Write_reg <= Matrix_Write;

      IF(Statu = "0001" OR Statu="0011" OR Statu="0110" OR Statu="1010" OR Statu="1111")THEN
        MAX <= 128;
      ELSE
        MAX <= 256;
      END IF;

      IF(Write_reg = '0' AND Matrix_Write = '1')THEN
        Data_cpt <= Data_cpt + 1;
        Valid    <= '0';
      ELSIF(Data_cpt = MAX)THEN
        Data_cpt   <= 0;
        Valid      <= '1';
        header_val <= '1';
      ELSE
        Valid <= '0';
      END IF;


      CASE ect IS

        WHEN idle0 =>
          IF(header_ack = '1')THEN
            header_val <= '0';
            ect        <= pong0;
          END IF;

        WHEN pong0 =>
          header(1 DOWNTO 0) <= Matrix_Type;
          header(5 DOWNTO 2) <= Matrix_Param;
          IF(emptyIN(0) = '1')THEN
            ect <= idle1;
          END IF;

        WHEN idle1 =>
          IF(header_ack = '1')THEN
            header_val <= '0';
            ect        <= pong1;
          END IF;

        WHEN pong1 =>
          header(1 DOWNTO 0) <= Matrix_Type;
          header(5 DOWNTO 2) <= Matrix_Param;
          IF(emptyIN(1) = '1')THEN
            ect <= idle0;
          END IF;

      END CASE;
    END IF;
  END PROCESS;

  Matrix_Param <= STD_LOGIC_VECTOR(to_unsigned(to_integer(UNSIGNED(Statu))-1, 4));

  header(31 DOWNTO 6) <= (OTHERS => '0');

  WITH ect SELECT
    dataOUT <= dataIN(Data_sz-1 DOWNTO 0) WHEN pong0,
    dataIN(Data_sz-1 DOWNTO 0)            WHEN idle0,
    dataIN((2*Data_sz)-1 DOWNTO Data_sz)  WHEN pong1,
    dataIN((2*Data_sz)-1 DOWNTO Data_sz)  WHEN idle1,
    (OTHERS => '0')                       WHEN OTHERS;

  WITH ect SELECT
    emptyOUT <= emptyIN(0) WHEN pong0,
    emptyIN(0)             WHEN idle0,
    emptyIN(1)             WHEN pong1,
    emptyIN(1)             WHEN idle1,
    '1'                    WHEN OTHERS;

  WITH ect SELECT
    RenOUT <= '1' & RenIN WHEN pong0,
    '1' & RenIN           WHEN idle0,
    RenIN & '1'           WHEN pong1,
    RenIN & '1'           WHEN idle1,
    "11"                  WHEN OTHERS;

END ARCHITECTURE;
