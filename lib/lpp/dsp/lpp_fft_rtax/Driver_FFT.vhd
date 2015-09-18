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

ENTITY Driver_FFT IS
  GENERIC(
    Data_sz : INTEGER RANGE 1 TO 32  := 16;
    NbData  : INTEGER RANGE 1 TO 512 := 256
    );
  PORT(
    clk     : IN  STD_LOGIC;
    rstn    : IN  STD_LOGIC;
    Load    : IN  STD_LOGIC;                                    -- (CoreFFT) FFT_Load
                                                                -- Load
    Empty   : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);                 -- FifoIN_Empty
    DATA    : IN  STD_LOGIC_VECTOR((5*Data_sz)-1 DOWNTO 0);     -- FifoIN_Data
    Valid   : OUT STD_LOGIC;                                    --(CoreFFT) Drive_write 
    Read    : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);                 -- Read
    Data_re : OUT STD_LOGIC_VECTOR(Data_sz-1 DOWNTO 0);         --(CoreFFT) Drive_DataRE
    Data_im : OUT STD_LOGIC_VECTOR(Data_sz-1 DOWNTO 0)          --(CoreFFT) Drive_DataIM
    );
END ENTITY;


ARCHITECTURE ar_Driver OF Driver_FFT IS

  TYPE   etat IS (eX, e0, e1, e2);
  SIGNAL ect : etat;

  SIGNAL DataCount : INTEGER RANGE 0 TO 255 := 0;
  SIGNAL FifoCpt   : INTEGER RANGE 0 TO 4   := 0;

  SIGNAL sLoad : STD_LOGIC;

BEGIN

  PROCESS(clk, rstn)
  BEGIN
    IF(rstn = '0')then
      ect       <= e0;
      Read      <= (OTHERS => '1');
      Valid     <= '0';
      Data_re   <= (OTHERS => '0');
      Data_im   <= (OTHERS => '0');
      DataCount <= 0;
      FifoCpt   <= 0;
      sLoad     <= '0';
      
    ELSIF(clk'EVENT AND clk = '1')then
      sLoad <= Load;

      IF(sLoad = '1' and Load = '0')THEN
        IF(FifoCpt = 4)THEN
          FifoCpt <= 0;
        ELSE
          FifoCpt <= FifoCpt + 1;
        END IF;
      END IF;

      CASE ect IS

        WHEN e0 =>
          IF(Load = '1' and Empty(FifoCpt) = '0')THEN
            Read(FifoCpt) <= '0';
            ect           <= e1;
          END IF;

        WHEN e1 =>
          Valid         <= '0';
          Read(FifoCpt) <= '1';
          ect           <= e2;
          
        WHEN e2 =>
          Data_re <= DATA(((FifoCpt+1)*Data_sz)-1 DOWNTO (FifoCpt*Data_sz));
          Data_im <= (OTHERS => '0');
          Valid   <= '1';
          IF(DataCount = NbData-1)THEN
            DataCount <= 0;
            ect       <= eX;
          ELSE
            DataCount <= DataCount + 1;
            IF(Load = '1' and Empty(FifoCpt) = '0')THEN
              Read(FifoCpt) <= '0';
              ect           <= e1;
            ELSE
              ect <= eX;
            END IF;
          END IF;

        WHEN eX =>
          Valid <= '0';
          ect   <= e0;

        WHEN OTHERS =>
          NULL;

      END CASE;
    END IF;
  END PROCESS;

END ARCHITECTURE;
