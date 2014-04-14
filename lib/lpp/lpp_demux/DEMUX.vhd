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
-- Author : Martin Morlot
-- Mail   : martin.morlot@lpp.polytechnique.fr
-------------------------------------------------------------------------------
-- Update : Jean-christophe Pellion
-- Mail   : jean-christophe.pellion@lpp.polytechnique.fr
------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY DEMUX IS
  GENERIC(
    Data_sz : INTEGER RANGE 1 TO 32 := 16);
  PORT(
    clk  : IN STD_LOGIC;
    rstn : IN STD_LOGIC;

    Read : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    Load : IN STD_LOGIC;

    EmptyF0 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    EmptyF1 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    EmptyF2 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);

    DataF0 : IN STD_LOGIC_VECTOR((5*Data_sz)-1 DOWNTO 0);
    DataF1 : IN STD_LOGIC_VECTOR((5*Data_sz)-1 DOWNTO 0);
    DataF2 : IN STD_LOGIC_VECTOR((5*Data_sz)-1 DOWNTO 0);

    WorkFreq   : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    Read_DEMUX : OUT STD_LOGIC_VECTOR(14 DOWNTO 0);
    Empty      : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
    Data       : OUT STD_LOGIC_VECTOR((5*Data_sz)-1 DOWNTO 0)
    );
END ENTITY;


ARCHITECTURE ar_DEMUX OF DEMUX IS

  TYPE   etat IS (eX, e0, e1, e2, e3);
  SIGNAL ect : etat;


  SIGNAL   load_reg   : STD_LOGIC;
  CONSTANT Dummy_Read : STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '1');

  SIGNAL Countf0 : INTEGER;
  SIGNAL Countf1 : INTEGER;
  SIGNAL i       : INTEGER;

BEGIN
  PROCESS(clk, rstn)
  BEGIN
    IF(rstn = '0')then
      ect      <= e0;
      load_reg <= '0';
      Countf0  <= 0;
      Countf1  <= 0;
      i        <= 0;

    ELSIF(clk'EVENT AND clk = '1')then
      load_reg <= Load;

      CASE ect IS

        WHEN e0 =>
          IF(load_reg = '1' AND Load = '0')THEN
            IF(Countf0 = 24)THEN
              Countf0 <= 0;
              ect     <= e1;
            ELSE
              Countf0 <= Countf0 + 1;
              ect     <= e0;
            END IF;
          END IF;

        WHEN e1 =>
          IF(load_reg = '1' AND Load = '0')THEN
            IF(Countf1 = 74)THEN
              Countf1 <= 0;
              ect     <= e2;
            ELSE
              Countf1 <= Countf1 + 1;
              IF(i = 4)THEN
                i   <= 0;
                ect <= e0;
              ELSE
                i   <= i+1;
                ect <= e1;
              END IF;
            END IF;
          END IF;

        WHEN e2 =>
          IF(load_reg = '1' AND Load = '0')THEN
            IF(i = 4)THEN
              i   <= 0;
              ect <= e0;
            ELSE
              i   <= i+1;
              ect <= e2;
            END IF;
          END IF;
          
        WHEN OTHERS =>
          NULL;

      END CASE;
    END IF;
  END PROCESS;

  WITH ect SELECT
    Empty <= EmptyF0 WHEN e0,
    EmptyF1          WHEN e1,
    EmptyF2          WHEN e2,
    (OTHERS => '1')  WHEN OTHERS;

  WITH ect SELECT
    Data <= DataF0  WHEN e0,
    DataF1          WHEN e1,
    DataF2          WHEN e2,
    (OTHERS => '0') WHEN OTHERS;

  WITH ect SELECT
    Read_DEMUX <= Dummy_Read & Dummy_Read & Read WHEN e0,
    Dummy_Read & Read & Dummy_Read               WHEN e1,
    Read & Dummy_Read & Dummy_Read               WHEN e2,
    (OTHERS => '1')                              WHEN OTHERS;

  WITH ect SELECT
    WorkFreq <= "01" WHEN e0,
    "10"             WHEN e1,
    "11"             WHEN e2,
    "00"             WHEN OTHERS;

END ARCHITECTURE;




















