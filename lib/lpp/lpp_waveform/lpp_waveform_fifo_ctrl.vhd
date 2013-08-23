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
--                    Author : Jean-christophe PELLION
--                    Mail   : jean-christophe.pellion@lpp.polytechnique.fr
------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY lpp;
USE lpp.lpp_memory.ALL;
USE lpp.iir_filter.ALL;
USE lpp.lpp_waveform_pkg.ALL;

LIBRARY techmap;
USE techmap.gencomp.ALL;

ENTITY lpp_waveform_fifo_ctrl IS
  generic(
    offset        : INTEGER := 0;
    length        : INTEGER := 20;
    enable_ready  : STD_LOGIC := '1'    
    );
  PORT(
    clk  : IN STD_LOGIC;
    rstn : IN STD_LOGIC;

    ren : IN STD_LOGIC;
    wen : IN STD_LOGIC;

    mem_re : OUT STD_LOGIC;
    mem_we : OUT STD_LOGIC;
    
    mem_addr_ren : out STD_LOGIC_VECTOR(6 DOWNTO 0);
    mem_addr_wen : out STD_LOGIC_VECTOR(6 DOWNTO 0);

    ready : OUT STD_LOGIC
    );
END ENTITY;


ARCHITECTURE ar_lpp_waveform_fifo_ctrl OF lpp_waveform_fifo_ctrl IS

  SIGNAL sFull    : STD_LOGIC;
  SIGNAL sFull_s  : STD_LOGIC;
  SIGNAL sEmpty_s : STD_LOGIC;

  SIGNAL sEmpty : STD_LOGIC;
  SIGNAL sREN   : STD_LOGIC;
  SIGNAL sWEN   : STD_LOGIC;
  SIGNAL sRE    : STD_LOGIC;
  SIGNAL sWE    : STD_LOGIC;

  SIGNAL Waddr_vect   : INTEGER RANGE 0 TO length := 0;
  SIGNAL Raddr_vect   : INTEGER RANGE 0 TO length := 0;
  SIGNAL Waddr_vect_s : INTEGER RANGE 0 TO length := 0;
  SIGNAL Raddr_vect_s : INTEGER RANGE 0 TO length := 0;

BEGIN
  mem_re <= sRE;
  mem_we <= sWE;
--=============================
--     Read section
--=============================
  sREN <= REN OR sEmpty;
  sRE  <= NOT sREN;

  sEmpty_s <= '1' WHEN sEmpty = '1' AND Wen = '1'                                               ELSE
              '1' WHEN sEmpty = '0' AND (Wen = '1' AND Ren = '0' AND Raddr_vect_s = Waddr_vect) ELSE
              '0';

  Raddr_vect_s <= Raddr_vect +1 WHEN Raddr_vect < length -1 ELSE 0 ;

  PROCESS (clk, rstn)
  BEGIN
    IF(rstn = '0')then
      Raddr_vect <= 0;
      sempty     <= '1';
    ELSIF(clk'EVENT AND clk = '1')then
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

  sFull_s <= '1' WHEN Waddr_vect_s = Raddr_vect AND REN = '1' AND WEN = '0' ELSE
             '1' WHEN sFull = '1' AND REN = '1'                             ELSE
             '0';

  Waddr_vect_s <= Waddr_vect +1 WHEN Waddr_vect < length -1 ELSE 0 ;

  PROCESS (clk, rstn)
  BEGIN
    IF(rstn = '0')then
      Waddr_vect <= 0;
      sfull      <= '0';
    ELSIF(clk'EVENT AND clk = '1')then
      sfull <= sfull_s;

      IF(sWEN = '0' and sfull = '0')THEN
        Waddr_vect <= Waddr_vect_s;
      END IF;
      
    END IF;
  END PROCESS;

  
  mem_addr_wen <= std_logic_vector(to_unsigned((Waddr_vect + offset), mem_addr_wen'length));
  mem_addr_ren <= std_logic_vector(to_unsigned((Raddr_vect + offset), mem_addr_ren'length));

  ready_gen: IF enable_ready = '1' GENERATE
    ready <= '1' WHEN Waddr_vect > Raddr_vect AND (Waddr_vect - Raddr_vect) > 15 ELSE
             '1' WHEN Waddr_vect < Raddr_vect AND (length + Waddr_vect - Raddr_vect) > 15 ELSE
             '0';
  END GENERATE ready_gen;
  
  ready_not_gen: IF enable_ready = '0' GENERATE
    ready <= '0';
  END GENERATE ready_not_gen;
  
END ARCHITECTURE;


























