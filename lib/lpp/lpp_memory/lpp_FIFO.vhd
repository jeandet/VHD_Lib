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
    tech                  : INTEGER               := 0;
    Mem_use               : INTEGER               := use_RAM;
    EMPTY_THRESHOLD_LIMIT : INTEGER               := 16;
    FULL_THRESHOLD_LIMIT  : INTEGER               := 5;
    DataSz                : INTEGER RANGE 1 TO 32 := 8;
    AddrSz                : INTEGER RANGE 2 TO 12 := 8
    );
  PORT(
    clk   : IN STD_LOGIC;
    rstn  : IN STD_LOGIC;
    --
    reUse : IN STD_LOGIC;
    run   : IN STD_LOGIC;

    --IN
    ren   : IN  STD_LOGIC;
    rdata : OUT STD_LOGIC_VECTOR(DataSz-1 DOWNTO 0);

    --OUT
    wen   : IN STD_LOGIC;
    wdata : IN STD_LOGIC_VECTOR(DataSz-1 DOWNTO 0);

    empty           : OUT STD_LOGIC;
    full            : OUT STD_LOGIC;
    full_almost     : OUT STD_LOGIC;
    empty_threshold : OUT STD_LOGIC;
    full_threshold  : OUT STD_LOGIC
    );
END ENTITY;


ARCHITECTURE ar_lpp_fifo OF lpp_fifo IS

  SIGNAL sREN : STD_LOGIC;
  SIGNAL sWEN : STD_LOGIC;
  SIGNAL sRE  : STD_LOGIC;
  SIGNAL sWE  : STD_LOGIC;

  SIGNAL Waddr_vect : STD_LOGIC_VECTOR(AddrSz-1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL Raddr_vect : STD_LOGIC_VECTOR(AddrSz-1 DOWNTO 0) := (OTHERS => '0');

BEGIN

--==================================================================================
-- /!\ syncram_2p Write et Read actif a l'état haut /!\
-- A l'inverse de RAM_CEL !!!
--==================================================================================
  memRAM : IF Mem_use = use_RAM GENERATE
    SRAM : syncram_2p
      GENERIC MAP(tech, AddrSz, DataSz)
      PORT MAP(CLK, sRE, Raddr_vect, rdata, CLK, sWE, Waddr_vect, wdata);
  END GENERATE;
--================================================================================== 
  memCEL : IF Mem_use = use_CEL GENERATE
    CRAM : RAM_CEL
      GENERIC MAP(DataSz, AddrSz)
      PORT MAP(wdata, rdata, sWEN, sREN, Waddr_vect, Raddr_vect, CLK, rstn);
  END GENERATE;
--================================================================================== 
  sRE <= NOT sREN;
  sWE <= NOT sWEN;


  lpp_fifo_control_1 : lpp_fifo_control
    GENERIC MAP (
      AddrSz                => AddrSz,
      EMPTY_THRESHOLD_LIMIT => EMPTY_THRESHOLD_LIMIT,
      FULL_THRESHOLD_LIMIT  => FULL_THRESHOLD_LIMIT)
    PORT MAP (
      clk             => clk,
      rstn            => rstn,
      run             => run,
      reUse           => reUse,
      fifo_r_en       => ren,
      fifo_w_en       => wen,
      mem_r_en        => sREN,
      mem_w_en        => SWEN,
      mem_r_addr      => Raddr_vect,
      mem_w_addr      => Waddr_vect,
      empty           => empty,
      full            => full,
      full_almost     => full_almost,
      empty_threshold => empty_threshold,
      full_threshold  => full_threshold);


END ARCHITECTURE;

























