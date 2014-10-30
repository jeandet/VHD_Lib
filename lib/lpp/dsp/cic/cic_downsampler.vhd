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

ENTITY cic_downsampler IS
  
  GENERIC (
    R_downsampling_decimation_factor : INTEGER := 16;
    b_data_size                      : INTEGER := 16
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

END cic_downsampler;

ARCHITECTURE beh OF cic_downsampler IS

  SUBTYPE INTEGER_downsampler IS INTEGER RANGE 0 TO R_downsampling_decimation_factor-1;
  
  SIGNAL counter_downsampler : INTEGER_downsampler;
  
BEGIN  -- beh

  PROCESS (clk, rstn)
    BEGIN  -- PROCESS
      IF rstn = '0' THEN                -- asynchronous reset (active low)
        data_out            <= (OTHERS => '0');
        data_out_valid      <= '0';
        counter_downsampler <= 0;     
      ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
        IF run = '0' THEN
          data_out       <= (OTHERS => '0');
          data_out_valid <= '0';
          counter_downsampler <= 0;
        ELSE
          data_out_valid <= '0';
          IF data_in_valid = '1' THEN
            IF counter_downsampler = R_downsampling_decimation_factor-1  THEN
              counter_downsampler <= 0;
            ELSE
              counter_downsampler <= counter_downsampler + 1;
            END IF;

            IF counter_downsampler = 0 THEN
              data_out_valid <= '1';
              data_out       <= data_in;
            END IF;
            
          END IF;
        END IF;
      END IF;
    END PROCESS;  

END beh;

