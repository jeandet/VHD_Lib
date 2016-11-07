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
------------------------------------------------------------------------------
--                    Author : Alexis Jeandet
--                     Mail : alexis.jeandet@lpp.polytechnique.fr
------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_textio.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY std;
USE std.textio.ALL;


ENTITY RAM_CEL IS
  GENERIC(
    DataSz : INTEGER RANGE 1 TO 32 := 8;
    abits  : INTEGER RANGE 2 TO 12 := 8;
    FILENAME : string:= ""
    );
  PORT(
    WD           : IN  STD_LOGIC_VECTOR(DataSz-1 DOWNTO 0);
    RD           : OUT STD_LOGIC_VECTOR(DataSz-1 DOWNTO 0);
    WEN, REN     : IN  STD_LOGIC;
    WADDR        : IN  STD_LOGIC_VECTOR(abits-1 DOWNTO 0);
    RADDR        : IN  STD_LOGIC_VECTOR(abits-1 DOWNTO 0);
    RWCLK, RESET : IN  STD_LOGIC
    ) ;
END RAM_CEL;



ARCHITECTURE ar_RAM_CEL OF RAM_CEL IS

  CONSTANT VectInit : STD_LOGIC_VECTOR(DataSz-1 DOWNTO 0) := (OTHERS => '0');
  CONSTANT MAX      : INTEGER                             := 2**(abits);

  TYPE RAMarrayT IS ARRAY (0 TO MAX-1) OF STD_LOGIC_VECTOR(DataSz-1 DOWNTO 0);

  SIGNAL RD_int   : STD_LOGIC_VECTOR(DataSz-1 DOWNTO 0);

  SIGNAL RADDR_reg        :  STD_LOGIC_VECTOR(abits-1 DOWNTO 0);


  -- Read a *.hex file
    impure function ReadMemFile(FileName : STRING) return RAMarrayT is
      file FileHandle       : TEXT open READ_MODE is FileName;
      variable CurrentLine  : LINE;
      variable TempWord     : STD_LOGIC_VECTOR(DataSz-1 DOWNTO 0);
      variable Result       : RAMarrayT    := (others => (others => '0'));

    begin
      for i in 0 to MAX - 1 loop
        exit when endfile(FileHandle);
        readline(FileHandle, CurrentLine);
        hread(CurrentLine, TempWord);
        Result(i)    := TempWord;
      end loop;

      return Result;
    end function;

    impure function InitMem(FileName : STRING) return RAMarrayT is
        variable Result       : RAMarrayT    := (others => (others => '0'));
    begin
        if FileName /= "" then
            report "initialysing RAM CEL From file "& FileName;
            Result := ReadMemFile(FileName);
        end if;
        report "initialysing RAM CEL To 0";
        return Result;
    end function;

    SIGNAL RAMarray : RAMarrayT := InitMem(FILENAME);
BEGIN

  RD_int <= RAMarray(to_integer(UNSIGNED(RADDR)));

  PROCESS(RWclk, reset)
  BEGIN
    IF reset = '0' THEN
      RD <= VectInit;
--      rst : FOR i IN 0 TO MAX-1 LOOP
--        RAMarray(i) <= (OTHERS => '0');
--      END LOOP;

    ELSIF RWclk'EVENT AND RWclk = '1' THEN
      RD <= RD_int;
      IF REN = '0' THEN
        RADDR_reg <= RADDR;
      END IF;

      IF WEN = '0' THEN
        RAMarray(to_integer(UNSIGNED(WADDR))) <= WD;
      END IF;

    END IF;
  END PROCESS;
END ar_RAM_CEL;




























