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
--                    Author :  Jean-christophe PELLION
--                     Mail :   jean-christophe.pellion@lpp.polytechnique.fr
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.std_logic_arith.ALL;
LIBRARY lpp;
use lpp.iir_filter.all;

ENTITY Downsampling IS
  
  GENERIC (
    ChanelCount : INTEGER;
    SampleSize  : INTEGER;
    DivideParam : INTEGER );
  PORT (
    clk            : IN  STD_LOGIC;
    rstn           : IN  STD_LOGIC;
    sample_in_val  : IN  STD_LOGIC;
    sample_in      : IN  samplT(ChanelCount-1 DOWNTO 0, SampleSize-1 DOWNTO 0);
    sample_out_val : OUT STD_LOGIC;
    sample_out     : OUT samplT(ChanelCount-1 DOWNTO 0, SampleSize-1 DOWNTO 0)
    );

END Downsampling;

ARCHITECTURE beh OF Downsampling IS

  SIGNAL counter : INTEGER RANGE 0 TO DivideParam-1;
  
BEGIN  -- beh

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      counter        <= 0;
      sample_out_val <= '0';
      all_sampl: FOR I IN ChanelCount-1 DOWNTO 0 LOOP
      	all_bit: FOR J IN SampleSize-1 DOWNTO 0 LOOP
	        sample_out(I,J)     <= '0'; 
        END LOOP all_bit;
      END LOOP all_sampl;
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      IF sample_in_val = '1' THEN
        IF counter = 0 THEN
          counter        <= DivideParam-1;
          sample_out_val <= '1';
          sample_out     <= sample_in;
        ELSE
          counter        <= counter-1;
          sample_out_val <= '0';
        END IF;
      ELSE
        sample_out_val <= '0';
      END IF;
    END IF;
  END PROCESS;

END beh;