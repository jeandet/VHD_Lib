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
USE lpp.lpp_waveform_pkg.ALL;
USE lpp.general_purpose.ALL;

ENTITY lpp_waveform_fifo_arbiter_reg IS
  GENERIC(
    data_size : INTEGER;
    data_nb   : INTEGER
    );
  PORT(
    clk               : IN  STD_LOGIC;
    rstn              : IN  STD_LOGIC;
    ---------------------------------------------------------------------------
    run               : IN  STD_LOGIC;

    max_count : IN STD_LOGIC_VECTOR(data_size -1 DOWNTO 0);

    enable : IN STD_LOGIC;
    sel    : IN STD_LOGIC_VECTOR(data_nb-1 DOWNTO 0);
    
    data   : OUT STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
    data_s : OUT STD_LOGIC_VECTOR(data_size-1 DOWNTO 0)
    );
END ENTITY;


ARCHITECTURE ar_lpp_waveform_fifo_arbiter_reg OF lpp_waveform_fifo_arbiter_reg IS
  
  TYPE   Counter_Vector IS ARRAY (NATURAL RANGE <>) OF INTEGER;
  SIGNAL reg : Counter_Vector(data_nb-1 DOWNTO 0);

  SIGNAL reg_sel   : INTEGER;
  SIGNAL reg_sel_s : INTEGER;

BEGIN
  
  all_reg: FOR I IN data_nb-1 DOWNTO 0 GENERATE
    PROCESS (clk, rstn)
    BEGIN  -- PROCESS
      IF rstn = '0' THEN                  -- asynchronous reset (active low)
        reg(I) <= 0;
      ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
        IF run = '0' THEN
          reg(I) <= 0;
        ELSE
          IF sel(I) = '1' THEN
            reg(I) <= reg_sel_s;
          END IF;
        END IF;      
      END IF;
    END PROCESS;
  END GENERATE all_reg;

  reg_sel <= reg(0) WHEN sel(0) = '1' ELSE
             reg(1) WHEN sel(1) = '1' ELSE
             reg(2) WHEN sel(2) = '1' ELSE
             reg(3);

  reg_sel_s <= reg_sel     WHEN enable = '0' ELSE
               reg_sel + 1 WHEN reg_sel < UNSIGNED(max_count) ELSE
               0;

  data   <= STD_LOGIC_VECTOR(to_unsigned(reg_sel  ,data_size));
  data_s <= STD_LOGIC_VECTOR(to_unsigned(reg_sel_s,data_size));
  
END ARCHITECTURE;


























