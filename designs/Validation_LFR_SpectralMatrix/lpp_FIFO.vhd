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
LIBRARY lpp;
USE lpp.lpp_memory.ALL;
USE lpp.iir_filter.ALL;
LIBRARY techmap;
USE techmap.gencomp.ALL;

ENTITY lpp_fifo IS
  GENERIC(
    tech         : INTEGER               := 0;
    Mem_use      : INTEGER               := use_RAM;
    Enable_ReUse : STD_LOGIC             := '0';
    DataSz       : INTEGER RANGE 1 TO 32 := 8;
    AddrSz       : INTEGER RANGE 2 TO 12 := 8
    );
  PORT(
    rstn        : IN  STD_LOGIC;
    ReUse       : IN  STD_LOGIC;
    rclk        : IN  STD_LOGIC;
    ren         : IN  STD_LOGIC;
    rdata       : OUT STD_LOGIC_VECTOR(DataSz-1 DOWNTO 0);
    empty       : OUT STD_LOGIC;
    raddr       : OUT STD_LOGIC_VECTOR(AddrSz-1 DOWNTO 0);
    wclk        : IN  STD_LOGIC;
    wen         : IN  STD_LOGIC;
    wdata       : IN  STD_LOGIC_VECTOR(DataSz-1 DOWNTO 0);
    full        : OUT STD_LOGIC;
    almost_full : OUT STD_LOGIC;        -- TODO
    waddr       : OUT STD_LOGIC_VECTOR(AddrSz-1 DOWNTO 0)
    );
END ENTITY;


ARCHITECTURE ar_lpp_fifo OF lpp_fifo IS

  SIGNAL sFull    : STD_LOGIC;
  SIGNAL sFull_s  : STD_LOGIC;
  SIGNAL sEmpty_s : STD_LOGIC;

  SIGNAL sEmpty : STD_LOGIC;
  SIGNAL sREN   : STD_LOGIC;
  SIGNAL sWEN   : STD_LOGIC;
  SIGNAL sRE    : STD_LOGIC;
  SIGNAL sWE    : STD_LOGIC;

  SIGNAL Waddr_vect   : STD_LOGIC_VECTOR(AddrSz-1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL Raddr_vect   : STD_LOGIC_VECTOR(AddrSz-1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL Waddr_vect_s : STD_LOGIC_VECTOR(AddrSz-1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL Raddr_vect_s : STD_LOGIC_VECTOR(AddrSz-1 DOWNTO 0) := (OTHERS => '0');

  SIGNAL almost_full_s : STD_LOGIC;
  SIGNAL almost_full_r   : STD_LOGIC;
BEGIN

--==================================================================================
-- /!\ syncram_2p Write et Read actif a l'état haut /!\
-- A l'inverse de RAM_CEL !!!
--==================================================================================
  memRAM : IF Mem_use = use_RAM GENERATE
    SRAM : syncram_2p
      GENERIC MAP(tech, AddrSz, DataSz)
      PORT MAP(RCLK, sRE, Raddr_vect, rdata, WCLK, sWE, Waddr_vect, wdata);
  END GENERATE;
--================================================================================== 
  memCEL : IF Mem_use = use_CEL GENERATE
    CRAM : RAM_CEL
      GENERIC MAP(DataSz, AddrSz)
      PORT MAP(wdata, rdata, sWEN, sREN, Waddr_vect, Raddr_vect, WCLK, rstn);
  END GENERATE;
--================================================================================== 

--=============================
--     Read section
--=============================
  sREN <= REN OR sEmpty;
  sRE  <= NOT sREN;

  sEmpty_s <= '0' WHEN ReUse = '1' AND Enable_ReUse = '1' else
              '1' WHEN sEmpty = '1' AND Wen = '1'                                               ELSE
              '1' WHEN sEmpty = '0' AND (Wen = '1' AND Ren = '0' AND Raddr_vect_s = Waddr_vect) ELSE
              '0';

  Raddr_vect_s <= STD_LOGIC_VECTOR(UNSIGNED(Raddr_vect) +1);

  PROCESS (rclk, rstn)
  BEGIN
    IF(rstn = '0')then
      Raddr_vect <= (OTHERS => '0');
      sempty     <= '1';
    ELSIF(rclk'EVENT AND rclk = '1')then
      sEmpty <= sempty_s;

      IF(sREN = '0' and sempty = '0')then
        Raddr_vect <= Raddr_vect_s;
      END IF;

    END IF;
  END PROCESS;

--=============================
--     Write section
--=============================
  sWEN <= WEN OR sFull;
  sWE  <= NOT sWEN;

  sFull_s <= '1' WHEN ReUse = '1' AND Enable_ReUse = '1' else
             '1' WHEN Waddr_vect_s = Raddr_vect AND REN = '1' AND WEN = '0' ELSE
             '1' WHEN sFull = '1' AND REN = '1'                             ELSE
             '0';

  almost_full_s <= '1' WHEN STD_LOGIC_VECTOR(UNSIGNED(Waddr_vect) +2) = Raddr_vect AND REN = '1' AND WEN = '0' ELSE
                   '1' WHEN almost_full_r = '1' AND WEN = REN ELSE
                   '0';
  
  Waddr_vect_s <= STD_LOGIC_VECTOR(UNSIGNED(Waddr_vect) +1);

  PROCESS (wclk, rstn)
  BEGIN
    IF(rstn = '0')then
      Waddr_vect <= (OTHERS => '0');
      sfull      <= '0';
      almost_full_r <= '0';
    ELSIF(wclk'EVENT AND wclk = '1')then
      sfull <= sfull_s;
      almost_full_r      <= almost_full_s;

      IF(sWEN = '0' and sfull = '0')THEN
        Waddr_vect <= Waddr_vect_s;
      END IF;
      
    END IF;
  END PROCESS;

  almost_full <= almost_full_s;
  full        <= sFull_s;
  empty       <= sEmpty_s;
  waddr       <= Waddr_vect;
  raddr       <= Raddr_vect;

END ARCHITECTURE;

























