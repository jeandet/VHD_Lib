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

ENTITY lppFIFOxN IS
  GENERIC(
    tech         : INTEGER               := 0;
    Mem_use      : INTEGER               := use_RAM;
    Data_sz      : INTEGER RANGE 1 TO 32 := 8;
    Addr_sz      : INTEGER RANGE 2 TO 12 := 8;
    FifoCnt      : INTEGER               := 1
    );
  PORT(
    clk  : IN STD_LOGIC;
    rstn : IN STD_LOGIC;

    ReUse : IN STD_LOGIC_VECTOR(FifoCnt-1 DOWNTO 0);

    run : IN STD_LOGIC_VECTOR(FifoCnt-1 DOWNTO 0);

    wen   : IN STD_LOGIC_VECTOR(FifoCnt-1 DOWNTO 0);
    wdata : IN STD_LOGIC_VECTOR((FifoCnt*Data_sz)-1 DOWNTO 0);

    ren   : IN  STD_LOGIC_VECTOR(FifoCnt-1 DOWNTO 0);
    rdata : OUT STD_LOGIC_VECTOR((FifoCnt*Data_sz)-1 DOWNTO 0);

    empty       : OUT STD_LOGIC_VECTOR(FifoCnt-1 DOWNTO 0);
    full        : OUT STD_LOGIC_VECTOR(FifoCnt-1 DOWNTO 0);
    almost_full : OUT STD_LOGIC_VECTOR(FifoCnt-1 DOWNTO 0)
    );
END ENTITY;


ARCHITECTURE ar_lppFIFOxN OF lppFIFOxN IS

BEGIN

  fifos : FOR i IN 0 TO FifoCnt-1 GENERATE
    lpp_fifo_1: lpp_fifo
      GENERIC MAP (
        tech         => tech,
        Mem_use      => Mem_use,
        EMPTY_THRESHOLD_LIMIT => 1,
        FULL_THRESHOLD_LIMIT  => 1,
        DataSz       => Data_sz,
        AddrSz       => Addr_sz)
      PORT MAP (
        clk         => clk,
        rstn        => rstn,
        reUse       => reUse(I),
        run       => run(I),
        ren         => ren(I),
        rdata       => rdata( ((I+1)*Data_sz)-1 DOWNTO (I*Data_sz) ),
        wen         => wen(I),
        wdata       => wdata(((I+1)*Data_sz)-1 DOWNTO (I*Data_sz)),
        empty       => empty(I),
        full        => full(I),
        full_almost => almost_full(I),
        empty_threshold => OPEN,
        full_threshold  => OPEN
        );
  END GENERATE;

END ARCHITECTURE;
