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

ENTITY lpp_waveform_valid_ack IS
  PORT(
    clk  : IN STD_LOGIC;
    rstn : IN STD_LOGIC;

    data_valid_in  : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    data_valid_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    error_valid    : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END ENTITY;


ARCHITECTURE ar_lpp_waveform_valid_ack OF lpp_waveform_valid_ack IS

  SIGNAL data_valid_temp : STD_LOGIC_VECTOR(3 DOWNTO 0);
  
BEGIN

  all_input: FOR I IN 3 DOWNTO 0 GENERATE
    
    PROCESS (clk, rstn)
    BEGIN
      IF rstn = '0' THEN 
        data_valid_temp(I) <= '0';
      ELSIF clk'event AND clk = '1' THEN
        data_valid_temp(I) <= data_valid_in(I);
        data_valid_out(I)  <= data_valid_in(I) AND ;
        
      END IF;
    END PROCESS;
    
  END GENERATE all_input;
  
END ARCHITECTURE;


























