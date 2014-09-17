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

ENTITY lpp_fifo_control IS
  GENERIC(
    AddrSz                : INTEGER RANGE 2 TO 12 := 8;
    EMPTY_THRESHOLD_LIMIT : INTEGER               := 16;
    FULL_THRESHOLD_LIMIT  : INTEGER               := 5
    );
  PORT(
    clk   : IN STD_LOGIC;
    rstn  : IN STD_LOGIC;
    --
    reUse : IN STD_LOGIC;
    run   : IN STD_LOGIC;

    --IN
    fifo_r_en : IN STD_LOGIC;
    fifo_w_en : IN STD_LOGIC;

    mem_r_en   : OUT STD_LOGIC;
    mem_w_en   : OUT STD_LOGIC;
    mem_r_addr : OUT STD_LOGIC_VECTOR(AddrSz -1 DOWNTO 0);
    mem_w_addr : OUT STD_LOGIC_VECTOR(AddrSz -1 DOWNTO 0);

    empty           : OUT STD_LOGIC;
    full            : OUT STD_LOGIC;
    full_almost     : OUT STD_LOGIC;
    empty_threshold : OUT STD_LOGIC;
    full_threshold  : OUT STD_LOGIC

    );
END ENTITY;


ARCHITECTURE beh OF lpp_fifo_control IS

  SIGNAL sFull    : STD_LOGIC;
  SIGNAL sFull_s  : STD_LOGIC;
  SIGNAL sEmpty_s : STD_LOGIC;

  SIGNAL sEmpty : STD_LOGIC;
  SIGNAL sREN   : STD_LOGIC;
  SIGNAL sWEN   : STD_LOGIC;

  SIGNAL Waddr_vect   : STD_LOGIC_VECTOR(AddrSz-1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL Raddr_vect   : STD_LOGIC_VECTOR(AddrSz-1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL Waddr_vect_s : STD_LOGIC_VECTOR(AddrSz-1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL Raddr_vect_s : STD_LOGIC_VECTOR(AddrSz-1 DOWNTO 0) := (OTHERS => '0');

  SIGNAL almost_full_s : STD_LOGIC;
  SIGNAL almost_full_r : STD_LOGIC;

  SIGNAL mem_r_addr_int : INTEGER;
  SIGNAL mem_w_addr_int : INTEGER;
  SIGNAL space_busy     : INTEGER;
  SIGNAL space_free     : INTEGER;
  
  CONSTANT length           : INTEGER := 2**(AddrSz);
  
BEGIN
  
  mem_r_addr <= Raddr_vect;
  mem_w_addr <= Waddr_vect;


  mem_r_en <= sREN;
  mem_w_en <= sWEN;
--=============================
--     Read section
--=============================
  sREN     <= FIFO_R_EN OR sEmpty;
  --sRE  <= NOT sREN;

  sEmpty_s <= '0' WHEN ReUse = '1' ELSE
              '1' WHEN sEmpty = '1' AND Fifo_W_En = '1'                                                     ELSE
              '1' WHEN sEmpty = '0' AND (Fifo_W_En = '1' AND Fifo_R_en = '0' AND Raddr_vect_s = Waddr_vect) ELSE
              '0';

  Raddr_vect_s <= STD_LOGIC_VECTOR(UNSIGNED(Raddr_vect) +1);

  PROCESS (clk, rstn)
  BEGIN
    IF(rstn = '0')THEN
      Raddr_vect <= (OTHERS => '0');
      sempty     <= '1';
    ELSIF(clk'EVENT AND clk = '1')THEN

      IF run = '0' THEN
        Raddr_vect <= (OTHERS => '0');
        sempty     <= '1';
      ELSE
        sEmpty <= sempty_s;
        
        IF(sREN = '0' AND sempty = '0')THEN
          Raddr_vect <= Raddr_vect_s;
        END IF;
      END IF;

    END IF;
  END PROCESS;

--=============================
--     Write section
--=============================
  sWEN <= FIFO_W_EN OR sFull;
--  sWE  <= NOT sWEN;

  sFull_s <= '1' WHEN ReUse = '1' ELSE
             '1' WHEN Waddr_vect_s = Raddr_vect AND FIFO_R_EN = '1' AND FIFO_W_EN = '0' ELSE
             '1' WHEN sFull = '1' AND FIFO_R_EN = '1'                                   ELSE
             '0';

  almost_full_s <= '1' WHEN STD_LOGIC_VECTOR(UNSIGNED(Waddr_vect) +2) = Raddr_vect AND FIFO_R_EN = '1' AND FIFO_W_EN = '0' ELSE
                   '1' WHEN almost_full_r = '1' AND FIFO_W_EN = FIFO_R_EN ELSE
                   '0';
  
  Waddr_vect_s <= STD_LOGIC_VECTOR(UNSIGNED(Waddr_vect) +1);

  PROCESS (clk, rstn)
  BEGIN
    IF(rstn = '0')THEN
      Waddr_vect    <= (OTHERS => '0');
      sfull         <= '0';
      almost_full_r <= '0';
    ELSIF(clk'EVENT AND clk = '1')THEN
      IF run = '0' THEN
        Waddr_vect    <= (OTHERS => '0');
        sfull         <= '0';
        almost_full_r <= '0';
      ELSE
        sfull         <= sfull_s;
        almost_full_r <= almost_full_s;
        
        IF(sWEN = '0' AND sfull = '0')THEN
          Waddr_vect <= Waddr_vect_s;
        END IF;
      END IF;
    END IF;
  END PROCESS;

  full_almost <= almost_full_s;
  full        <= sFull_s;
  empty       <= sEmpty_s;

  -----------------------------------------------------------------------------
  mem_w_addr_int <= to_integer(UNSIGNED(Waddr_vect));
  mem_r_addr_int <= to_integer(UNSIGNED(Raddr_vect));

  space_busy <= length                                   WHEN sFull = '1' ELSE
                length + mem_w_addr_int - mem_r_addr_int WHEN mem_w_addr_int < mem_r_addr_int ELSE
                mem_w_addr_int - mem_r_addr_int;

  space_free <= length - space_busy;

  empty_threshold <= '0' WHEN space_busy > EMPTY_THRESHOLD_LIMIT ELSE '1';
  full_threshold  <= '0' WHEN space_free > FULL_THRESHOLD_LIMIT  ELSE '1';
  -----------------------------------------------------------------------------

  
END ARCHITECTURE;

























