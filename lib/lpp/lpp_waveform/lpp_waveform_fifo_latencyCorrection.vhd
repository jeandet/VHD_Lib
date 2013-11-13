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

ENTITY lpp_waveform_fifo_latencyCorrection IS
  GENERIC(
    tech : INTEGER := 0
    );
  PORT(
    clk  : IN STD_LOGIC;
    rstn : IN STD_LOGIC;
    ---------------------------------------------------------------------------
    run  : IN STD_LOGIC;

    ---------------------------------------------------------------------------
    empty_almost      : OUT STD_LOGIC;  --occupancy is lesser than 16 * 32b
    empty             : OUT STD_LOGIC;
    data_ren          : IN  STD_LOGIC;
    rdata             : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    ---------------------------------------------------------------------------
    empty_almost_fifo : IN  STD_LOGIC;
    empty_fifo        : IN  STD_LOGIC;
    data_ren_fifo     : OUT STD_LOGIC;
    rdata_fifo        : IN  STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY;


ARCHITECTURE ar_lpp_waveform_fifo_latencyCorrection OF lpp_waveform_fifo_latencyCorrection IS
  SIGNAL data_ren_fifo_s : STD_LOGIC;
--  SIGNAL rdata_s         : STD_LOGIC;

  SIGNAL reg_full         : STD_LOGIC;
  SIGNAL empty_almost_reg : STD_LOGIC;
BEGIN

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      empty_almost_reg <= '1';
      empty            <= '1';
      data_ren_fifo_s  <= '1';
      rdata            <= (OTHERS => '0');
      reg_full         <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
      IF run = '0' THEN
        empty_almost_reg <= '1';
        empty            <= '1';
        data_ren_fifo_s  <= '1';
        rdata            <= (OTHERS => '0');
        reg_full         <= '0';
      ELSE
        
        IF data_ren_fifo_s = '0' THEN   
          reg_full <= '1';
        ELSIF data_ren = '0' THEN
          reg_full <= '0';
        END IF;

        IF data_ren_fifo_s = '0' THEN
          rdata <= rdata_fifo;
        END IF;

        IF (reg_full = '0' OR data_ren = '0') AND empty_fifo = '0' THEN
          data_ren_fifo_s <= '0';
        ELSE
          data_ren_fifo_s <= '1';
        END IF;

        IF empty_fifo = '1' AND ((reg_full = '0') OR ( data_ren = '0')) THEN
          empty <= '1';
        ELSE
          empty <= '0';
        END IF;

        IF empty_almost_reg = '0' AND data_ren = '0' AND empty_almost_fifo = '1' THEN
          empty_almost_reg <= '1';
        ELSIF empty_almost_reg = '1' AND empty_almost_fifo = '0' THEN
          empty_almost_reg <= '0';
        END IF;
        
      END IF;
    END IF;
  END PROCESS;

  empty_almost  <= empty_almost_reg;
  data_ren_fifo <= data_ren_fifo_s;
  
END ARCHITECTURE;


























