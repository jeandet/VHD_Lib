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

LIBRARY IEEE;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_1164.ALL;

ENTITY cic_comb IS
  
  GENERIC (
    b_data_size                      : INTEGER := 16;
    D_delay_number                   : INTEGER := 2   
    );

  PORT (
    clk            : IN  STD_LOGIC;
    rstn           : IN  STD_LOGIC;
    run            : IN  STD_LOGIC;
    
    data_in        : IN  STD_LOGIC_VECTOR(b_data_size-1 DOWNTO 0);
    data_in_valid  : IN  STD_LOGIC;

    data_out       : OUT STD_LOGIC_VECTOR(b_data_size-1 DOWNTO 0);
    data_out_valid : OUT STD_LOGIC
    );

END cic_comb;

ARCHITECTURE beh OF cic_comb IS

  TYPE data_vector IS ARRAY (NATURAL RANGE <>) OF STD_LOGIC_VECTOR(b_data_size - 1 DOWNTO 0);

  SIGNAL data_reg : data_vector(D_delay_number DOWNTO 0);
  
BEGIN  -- beh

  data_reg(0) <= data_in;
  
  all_D: FOR I IN D_delay_number DOWNTO 1 GENERATE
    PROCESS (clk, rstn)
    BEGIN
      IF rstn = '0' THEN
         data_reg(I) <= (OTHERS => '0');
      ELSIF clk'event AND clk = '1' THEN 
        IF run = '0' THEN
          data_reg(I) <= (OTHERS => '0');
        ELSIF data_in_valid = '1' THEN
          data_reg(I) <= data_reg(I-1);
        END IF;
      END IF;
    END PROCESS;
  END GENERATE all_D;

  PROCESS (clk, rstn)
  BEGIN
    IF rstn = '0' THEN
      data_out <= (OTHERS => '0');
      data_out_valid <= '0';
    ELSIF clk'event AND clk = '1' THEN
      IF run = '0' THEN
        data_out <= (OTHERS => '0');
        data_out_valid <= '0';
      ELSE
        data_out_valid <= data_in_valid;
        IF data_in_valid = '1' THEN
          data_out <= STD_LOGIC_VECTOR(resize(SIGNED(data_reg(0))-SIGNED(data_reg(D_delay_number)),b_data_size));
        END IF;
      END IF;
    END IF;
  END PROCESS;
  

END beh;

