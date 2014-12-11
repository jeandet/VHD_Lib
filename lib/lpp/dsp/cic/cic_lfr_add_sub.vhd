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
--                    Author : Jean-christophe Pellion
--                    Mail   : jean-christophe.pellion@lpp.polytechnique.fr
--                             jean-christophe.pellion@easii-ic.com
----------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.all;

LIBRARY lpp;
USE lpp.cic_pkg.ALL;
USE lpp.data_type_pkg.ALL;

ENTITY cic_lfr_add_sub IS 
  PORT (
    clk            : IN  STD_LOGIC;
    rstn           : IN  STD_LOGIC;
    run            : IN  STD_LOGIC;

    OP   : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    -- 00 A + B
    -- 01 A - B
    -- 10 A + B + Carry
    -- 11 A - B - Carry
    
    data_in_A      : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    data_in_B      : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    data_in_Carry  : IN STD_LOGIC;

    data_out       : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    data_out_Carry : OUT STD_LOGIC
    );
END cic_lfr_add_sub;

ARCHITECTURE beh OF cic_lfr_add_sub IS

  SIGNAL data_carry : STD_LOGIC;
  SIGNAL STD_LOGIC_VECTOR_ZERO : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL data_add       : STD_LOGIC_VECTOR(16 DOWNTO 0);
  SIGNAL data_sub       : STD_LOGIC_VECTOR(16 DOWNTO 0);
  
  SIGNAL data       : STD_LOGIC_VECTOR(16 DOWNTO 0);
  
BEGIN

  STD_LOGIC_VECTOR_ZERO <= (OTHERS => '0');
  data_carry <= '0' WHEN OP(1) = '0' ELSE data_in_Carry;

  data_add <= STD_LOGIC_VECTOR(  SIGNED('0' & data_in_A)
                               + SIGNED('0' & data_in_B)
                               + SIGNED(STD_LOGIC_VECTOR_ZERO & data_carry));
  
  data_sub <= STD_LOGIC_VECTOR(  SIGNED('0' & data_in_A)
                               - SIGNED('0' & data_in_B)
                               - SIGNED(STD_LOGIC_VECTOR_ZERO & data_carry));

  data <= data_add WHEN OP(0) = '0' ELSE data_sub;
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN 
      data_out_Carry <= '0';
      data_out <= (OTHERS => '0');
    ELSIF clk'event AND clk = '1' THEN
      IF run = '0' THEN
        data_out_Carry <= '0';
        data_out <= (OTHERS => '0');
      ELSE
        data_out_Carry  <= data(16);
        data_out        <= data(15 DOWNTO 0);
      END IF;      
    END IF;
  END PROCESS;
  
  
END beh;

