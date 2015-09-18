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

ENTITY Linker_FFT IS
  GENERIC(
    Data_sz : INTEGER RANGE 1 TO 32  := 16;
    NbData  : INTEGER RANGE 1 TO 512 := 256
    );
  PORT(
    clk     : IN STD_LOGIC;
    rstn    : IN STD_LOGIC;
    Ready   : IN STD_LOGIC;                             --
    Valid   : IN STD_LOGIC;                             --
    Full    : IN STD_LOGIC_VECTOR(4 DOWNTO 0);          --
    Data_re : IN STD_LOGIC_VECTOR(Data_sz-1 DOWNTO 0);  --
    Data_im : IN STD_LOGIC_VECTOR(Data_sz-1 DOWNTO 0);  --

    Read  : OUT STD_LOGIC;                     -- Link_Read
    Write : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);  --
    ReUse : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
    DATA  : OUT STD_LOGIC_VECTOR((5*Data_sz)-1 DOWNTO 0)
    );
END ENTITY;


ARCHITECTURE ar_Linker OF Linker_FFT IS

  TYPE   etat IS (eX, e0, e1, e2);
  SIGNAL ect : etat;

  SIGNAL DataTmp : STD_LOGIC_VECTOR(Data_sz-1 DOWNTO 0);

  SIGNAL sRead  : STD_LOGIC;
  SIGNAL sReady : STD_LOGIC;

  SIGNAL FifoCpt : INTEGER RANGE 0 TO 4 := 0;

BEGIN

  PROCESS(clk, rstn)
  BEGIN
    IF(rstn = '0')then
      ect     <= e0;
      sRead   <= '0';
      sReady  <= '0';
      Write   <= (OTHERS => '1');
      Reuse   <= (OTHERS => '0');
      FifoCpt <= 0;
      
    ELSIF(clk'EVENT AND clk = '1')then
      sReady <= Ready;

      IF(sReady = '1' and Ready = '0')THEN
        IF(FifoCpt = 4)THEN
          FifoCpt <= 0;
        ELSE
          FifoCpt <= FifoCpt + 1;
        END IF;
      ELSIF(Ready = '1')then
        sRead <= NOT sRead;
      ELSE
        sRead <= '0';
      END IF;

      CASE ect IS

        WHEN e0 =>
          Write(FifoCpt) <= '1';
          IF(Valid = '1' and Full(FifoCpt) = '0')THEN
            DataTmp                                                <= Data_im;
            DATA(((FifoCpt+1)*Data_sz)-1 DOWNTO (FifoCpt*Data_sz)) <= Data_re;
            Write(FifoCpt)                                         <= '0';
            ect                                                    <= e1;
          ELSIF(Full(FifoCpt) = '1')then
            ReUse(FifoCpt) <= '1';
          END IF;

        WHEN e1 =>
          DATA(((FifoCpt+1)*Data_sz)-1 DOWNTO (FifoCpt*Data_sz)) <= DataTmp;
          ect                                                    <= e0;
          
        WHEN OTHERS =>
          NULL;

      END CASE;
    END IF;
  END PROCESS;

  Read <= sRead;

END ARCHITECTURE;
