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

ENTITY lpp_waveform_fifo_headreg IS
  GENERIC(
    tech : INTEGER := 0
    );
  PORT(
    clk            : IN  STD_LOGIC;
    rstn           : IN  STD_LOGIC;
    ---------------------------------------------------------------------------
    run            : IN  STD_LOGIC;
    ---------------------------------------------------------------------------
    o_empty_almost : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);  --occupancy is lesser than 16 * 32b
    o_empty        : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    o_data_ren     : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    o_rdata_0      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0); --
    o_rdata_1      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0); --
    o_rdata_2      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0); --
    o_rdata_3      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);  --
    ---------------------------------------------------------------------------
    i_empty_almost : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    i_empty        : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    i_data_ren     : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);  --
    i_rdata        : IN  STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY;


ARCHITECTURE ar_lpp_waveform_fifo_headreg OF lpp_waveform_fifo_headreg IS
  SIGNAL reg_full             : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL s_ren                : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL s_ren_reg            : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL one_ren_and_notEmpty : STD_LOGIC;
  SIGNAL ren_and_notEmpty     : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL s_empty_almost       : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL s_rdata_0      : STD_LOGIC_VECTOR(31 DOWNTO 0); 
  SIGNAL s_rdata_1      : STD_LOGIC_VECTOR(31 DOWNTO 0); 
  SIGNAL s_rdata_2      : STD_LOGIC_VECTOR(31 DOWNTO 0); 
  SIGNAL s_rdata_3      : STD_LOGIC_VECTOR(31 DOWNTO 0); 
BEGIN

  -----------------------------------------------------------------------------
  -- DATA_REN_FIFO
  -----------------------------------------------------------------------------
  i_data_ren <= s_ren;
  PROCESS (clk, rstn)
  BEGIN
    IF rstn = '0' THEN
      s_ren_reg <= (OTHERS => '1');
    ELSIF clk'EVENT AND clk = '1' THEN
      IF run = '1' THEN
        s_ren_reg <= s_ren;
      ELSE
        s_ren_reg <= (OTHERS => '1');
      END IF;
    END IF;
  END PROCESS;

  s_ren(0) <= o_data_ren(0) WHEN one_ren_and_notEmpty = '1' ELSE
              NOT ((NOT i_empty(0)) AND (NOT reg_full(0)));
  s_ren(1) <= o_data_ren(1) WHEN one_ren_and_notEmpty = '1' ELSE
              '1' WHEN s_ren(0) = '0' ELSE
              NOT ((NOT i_empty(1)) AND (NOT reg_full(1)));
  s_ren(2) <= o_data_ren(2) WHEN one_ren_and_notEmpty = '1' ELSE
              '1' WHEN s_ren(0) = '0' ELSE
              '1' WHEN s_ren(1) = '0' ELSE
              NOT ((NOT i_empty(2)) AND (NOT reg_full(2)));
  s_ren(3) <= o_data_ren(3) WHEN one_ren_and_notEmpty = '1' ELSE
              '1' WHEN s_ren(0) = '0' ELSE
              '1' WHEN s_ren(1) = '0' ELSE
              '1' WHEN s_ren(2) = '0' ELSE
              NOT ((NOT i_empty(3)) AND (NOT reg_full(3)));
  -----------------------------------------------------------------------------
  all_ren : FOR I IN 3 DOWNTO 0 GENERATE
    ren_and_notEmpty(I) <= (NOT o_data_ren(I)) AND (NOT i_empty(I));
  END GENERATE all_ren;
  one_ren_and_notEmpty <= '0' WHEN ren_and_notEmpty = "0000" ELSE '1';

  -----------------------------------------------------------------------------
  -- DATA
  -----------------------------------------------------------------------------
  o_rdata_0 <= i_rdata WHEN s_ren_reg(0) = '0' AND s_ren(0) = '0' ELSE s_rdata_0;
  o_rdata_1 <= i_rdata WHEN s_ren_reg(1) = '0' AND s_ren(1) = '0' ELSE s_rdata_1;
  o_rdata_2 <= i_rdata WHEN s_ren_reg(2) = '0' AND s_ren(2) = '0' ELSE s_rdata_2;
  o_rdata_3 <= i_rdata WHEN s_ren_reg(3) = '0' AND s_ren(3) = '0' ELSE s_rdata_3;
  
  PROCESS (clk, rstn)
  BEGIN
    IF rstn = '0' THEN
      s_rdata_0 <= (OTHERS => '0');
      s_rdata_1 <= (OTHERS => '0');
      s_rdata_2 <= (OTHERS => '0');
      s_rdata_3 <= (OTHERS => '0');
    ELSIF clk'EVENT AND clk = '1' THEN
      IF run = '1' THEN
        IF s_ren_reg(0) = '0' THEN s_rdata_0 <= i_rdata; END IF; 
        IF s_ren_reg(1) = '0' THEN s_rdata_1 <= i_rdata; END IF; 
        IF s_ren_reg(2) = '0' THEN s_rdata_2 <= i_rdata; END IF; 
        IF s_ren_reg(3) = '0' THEN s_rdata_3 <= i_rdata; END IF; 
      ELSE
      s_rdata_0 <= (OTHERS => '0');
      s_rdata_1 <= (OTHERS => '0');
      s_rdata_2 <= (OTHERS => '0');
      s_rdata_3 <= (OTHERS => '0');
      END IF;
    END IF;
  END PROCESS;

  all_reg_full : FOR I IN 3 DOWNTO 0 GENERATE
    PROCESS (clk, rstn)
    BEGIN
      IF rstn = '0' THEN
        reg_full(I) <= '0';
      ELSIF clk'EVENT AND clk = '1' THEN
--        IF s_ren_reg(I) = '0' THEN
        IF run = '1' THEN
          IF s_ren(I) = '0' THEN
            reg_full(I) <= '1';
          ELSIF o_data_ren(I) = '0' THEN
            reg_full(I) <= '0';
          END IF;
        ELSE
          reg_full(I) <= '0';
        END IF;
      END IF;
    END PROCESS;
  END GENERATE all_reg_full;

  -----------------------------------------------------------------------------
  -- EMPTY
  -----------------------------------------------------------------------------
  o_empty <= NOT reg_full;

  -----------------------------------------------------------------------------
  -- EMPTY_ALMOST
  -----------------------------------------------------------------------------
  o_empty_almost <= s_empty_almost;
  
  all_empty_almost: FOR I IN 3 DOWNTO 0 GENERATE
    PROCESS (clk, rstn)
    BEGIN  -- PROCESS
      IF rstn = '0' THEN                  -- asynchronous reset (active low)
        s_empty_almost(I) <= '1';
      ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
        IF run = '1' THEN
          IF s_ren(I) = '0' THEN
            s_empty_almost(I) <= i_empty_almost(I);
          ELSIF o_data_ren(I) = '0' THEN
            s_empty_almost(I) <= '1';
          ELSE
            IF i_empty_almost(I) = '0' THEN
              s_empty_almost(I) <= '0';
            END IF;
          END IF;
        ELSE
          s_empty_almost(I) <= '1';
        END IF;
      END IF;
    END PROCESS;
  END GENERATE all_empty_almost;
  
END ARCHITECTURE;


























