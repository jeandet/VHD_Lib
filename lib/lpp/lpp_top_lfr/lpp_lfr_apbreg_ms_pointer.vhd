------------------------------------------------------------------------------
--  This file is a part of the LPP VHDL IP LIBRARY
--  Copyright (C) 2009 - 2010, Laboratory of Plasmas Physic - CNRS
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
-------------------------------------------------------------------------------
-- Author : Jean-christophe Pellion
-- Mail   : jean-christophe.pellion@lpp.polytechnique.fr
--          jean-christophe.pellion@easii-ic.com
----------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY lpp_apbreg_ms_pointer IS
  
  PORT (
    clk  : IN STD_LOGIC;
    rstn : IN STD_LOGIC;
    run  : IN STD_LOGIC;

    -- REG 0
    reg0_status_ready_matrix : IN  STD_LOGIC;
    reg0_ready_matrix        : OUT STD_LOGIC;
    reg0_addr_matrix         : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    reg0_matrix_time         : OUT STD_LOGIC_VECTOR(47 DOWNTO 0);

    -- REG 1
    reg1_status_ready_matrix : IN  STD_LOGIC;
    reg1_ready_matrix        : OUT STD_LOGIC;
    reg1_addr_matrix         : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    reg1_matrix_time         : OUT STD_LOGIC_VECTOR(47 DOWNTO 0);

    -- SpectralMatrix
    ready_matrix        : IN  STD_LOGIC;
    status_ready_matrix : OUT STD_LOGIC;
    addr_matrix         : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    matrix_time         : IN  STD_LOGIC_VECTOR(47 DOWNTO 0)
    );

END lpp_apbreg_ms_pointer;

ARCHITECTURE beh OF lpp_apbreg_ms_pointer IS

  SIGNAL current_reg : STD_LOGIC;
  
BEGIN  -- beh

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      current_reg      <= '0';
      reg0_matrix_time <= (OTHERS => '0');
      reg1_matrix_time <= (OTHERS => '0');
      
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
      IF run = '0' THEN
        current_reg      <= '0';
        reg0_matrix_time <= (OTHERS => '0');
        reg1_matrix_time <= (OTHERS => '0');
      ELSE
        IF ready_matrix = '1' THEN
          current_reg <= NOT current_reg;

          IF current_reg = '0' THEN
            reg0_matrix_time <= matrix_time;
          END IF;

          IF current_reg = '1' THEN
            reg1_matrix_time <= matrix_time;
          END IF;
          
        END IF;
      END IF;
      
    END IF;
  END PROCESS;

  addr_matrix <= reg0_addr_matrix WHEN current_reg = '0' ELSE
                 reg1_addr_matrix;

  status_ready_matrix <= reg0_status_ready_matrix WHEN current_reg = '0' ELSE
                         reg1_status_ready_matrix;

  reg0_ready_matrix <= ready_matrix WHEN current_reg = '0' ELSE '0';
  reg1_ready_matrix <= ready_matrix WHEN current_reg = '1' ELSE '0';

  
  

END beh;
