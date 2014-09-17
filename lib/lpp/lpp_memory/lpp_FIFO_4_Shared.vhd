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

LIBRARY techmap;
USE techmap.gencomp.ALL;

ENTITY lpp_fifo_4_shared IS
  GENERIC(
    tech                  : INTEGER               := 0;
    Mem_use               : INTEGER               := use_RAM;
    EMPTY_THRESHOLD_LIMIT : INTEGER               := 16;
    FULL_THRESHOLD_LIMIT  : INTEGER               := 5;
    DataSz                : INTEGER RANGE 1 TO 32 := 8;
    AddrSz                : INTEGER RANGE 3 TO 12 := 8
    );
  PORT(
    clk  : IN STD_LOGIC;
    rstn : IN STD_LOGIC;
    ---------------------------------------------------------------------------
    run  : IN STD_LOGIC;

    ---------------------------------------------------------------------------
    empty_threshold : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);  --occupancy is lesser than 16 * 32b
    empty           : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    r_en            : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    r_data          : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

    ---------------------------------------------------------------------------
    full_threshold : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);  --occupancy is greater than MAX - 5 * 32b
    full_almost    : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);  --occupancy is greater than MAX - 5 * 32b
    full           : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    w_en           : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    w_data         : IN  STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY;


ARCHITECTURE beh OF lpp_fifo_4_shared IS

  SIGNAL full_s : STD_LOGIC_VECTOR(3 DOWNTO 0);

  TYPE   LPP_TYPE_ADDR_FIFO_SHARED IS ARRAY (3 DOWNTO 0) OF STD_LOGIC_VECTOR(AddrSz-3 DOWNTO 0);
  SIGNAL mem_r_addr_v : LPP_TYPE_ADDR_FIFO_SHARED;
  SIGNAL mem_w_addr_v : LPP_TYPE_ADDR_FIFO_SHARED;
  SIGNAL mem_r_addr   : STD_LOGIC_VECTOR(AddrSz-1 DOWNTO 0);
  SIGNAL mem_w_addr   : STD_LOGIC_VECTOR(AddrSz-1 DOWNTO 0);

  SIGNAL fifo_r_en_v : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL fifo_w_en_v : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL mem_r_en_v  : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL mem_w_en_v  : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL mem_r_e     : STD_LOGIC;
  SIGNAL mem_w_e     : STD_LOGIC;

  SIGNAL NB_DATA_IN_FIFO : INTEGER;


  CONSTANT length           : INTEGER := 2**(AddrSz-2);
  TYPE     INTEGER_ARRAY_4 IS ARRAY (3 DOWNTO 0) OF INTEGER;
  SIGNAL   mem_r_addr_v_int : INTEGER_ARRAY_4;
  SIGNAL   mem_w_addr_v_int : INTEGER_ARRAY_4;
  SIGNAL   space_busy       : INTEGER_ARRAY_4;
  SIGNAL   space_free       : INTEGER_ARRAY_4;
  
BEGIN

  -----------------------------------------------------------------------------
  SRAM : syncram_2p
    GENERIC MAP(tech, AddrSz, DataSz)
    PORT MAP(clk, mem_r_e, mem_r_addr, r_data,
             clk, mem_w_e, mem_w_addr, w_data);
  -----------------------------------------------------------------------------

  mem_r_addr <= "00" & mem_r_addr_v(0) WHEN fifo_r_en_v(0) = '0' ELSE
                "01" & mem_r_addr_v(1) WHEN fifo_r_en_v(1) = '0' ELSE
                "10" & mem_r_addr_v(2) WHEN fifo_r_en_v(2) = '0' ELSE
                "11" & mem_r_addr_v(3);  -- WHEN fifo_r_en(2) = '0' ELSE

  mem_w_addr <= "00" & mem_w_addr_v(0) WHEN fifo_w_en_v(0) = '0' ELSE
                "01" & mem_w_addr_v(1) WHEN fifo_w_en_v(1) = '0' ELSE
                "10" & mem_w_addr_v(2) WHEN fifo_w_en_v(2) = '0' ELSE
                "11" & mem_w_addr_v(3);  -- WHEN fifo_r_en(2) = '0' ELSE

  mem_r_e <= '0' WHEN mem_r_en_v = "1111" ELSE '1';
  mem_w_e <= '0' WHEN mem_w_en_v = "1111" ELSE '1';

  ----------------------------------------------------------------------------  
  all_fifo : FOR I IN 3 DOWNTO 0 GENERATE
    fifo_r_en_v(I) <= r_en(I);
    fifo_w_en_v(I) <= w_en(I);

    lpp_fifo_control_1 : lpp_fifo_control
      GENERIC MAP (
        AddrSz                => AddrSz-2,
        EMPTY_THRESHOLD_LIMIT => EMPTY_THRESHOLD_LIMIT,
        FULL_THRESHOLD_LIMIT  => FULL_THRESHOLD_LIMIT)
      PORT MAP (
        clk            => clk,
        rstn           => rstn,
        reUse          => '0',
        run            => run,
        fifo_r_en      => fifo_r_en_v(I),
        fifo_w_en      => fifo_w_en_v(I),
        mem_r_en       => mem_r_en_v(I),
        mem_w_en       => mem_w_en_v(I),
        mem_r_addr     => mem_r_addr_v(I),
        mem_w_addr     => mem_w_addr_v(I),
        empty          => empty(I),
        full           => full_s(I),
        full_almost    => full_almost(I),
        empty_threshold => empty_threshold(I),
        full_threshold => full_threshold(I)
        );

    --full(I) <= full_s(I);

    --mem_w_addr_v_int(I) <= to_integer(UNSIGNED(mem_w_addr_v(I)));
    --mem_r_addr_v_int(I) <= to_integer(UNSIGNED(mem_r_addr_v(I)));

    --space_busy(I) <= length                                              WHEN full_s(I) = '1' ELSE
    --                 length + mem_w_addr_v_int(I)  - mem_r_addr_v_int(I) WHEN mem_w_addr_v_int(I) < mem_r_addr_v_int(I) ELSE
    --                 mem_w_addr_v_int(I)  - mem_r_addr_v_int(I);

    --space_free(I) <= length - space_busy(I);

    --empty_threshold(I) <= '0' WHEN space_busy(I) > EMPTY_THRESHOLD_LIMIT ELSE '1';
    --full_threshold(I)  <= '0' WHEN space_free(I) > FULL_THRESHOLD_LIMIT ELSE '1';

  END GENERATE all_fifo;

  
  
END ARCHITECTURE;


























