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

LIBRARY lpp;
USE lpp.cic_pkg.ALL;
USE lpp.data_type_pkg.ALL;

ENTITY cic_lfr IS
  GENERIC(
    tech         : INTEGER := 0;
    use_RAM_nCEL : INTEGER := 0         -- 1 => RAM(tech) , 0 => RAM_CEL
    );    
  PORT (
    clk            : IN  STD_LOGIC;
    rstn           : IN  STD_LOGIC;
    run            : IN  STD_LOGIC;
    
    data_in        : IN  sample_vector(5 DOWNTO 0,15 DOWNTO 0);
    data_in_valid  : IN  STD_LOGIC;

    data_out_16        : OUT sample_vector(5 DOWNTO 0,15 DOWNTO 0);
    data_out_16_valid  : OUT STD_LOGIC;
    data_out_256       : OUT sample_vector(5 DOWNTO 0,15 DOWNTO 0);
    data_out_256_valid : OUT STD_LOGIC
    );

END cic_lfr;

ARCHITECTURE beh OF cic_lfr IS
  SIGNAL sel_sample  : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL sample_temp : sample_vector(3 DOWNTO 0,15 DOWNTO 0);
  SIGNAL sample      : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN

  -----------------------------------------------------------------------------
  -- SEL_SAMPLE
  -----------------------------------------------------------------------------
  sample_temp(0) <= sample_vector(0) WHEN sel_sample(0) = '0' ELSE sample_vector(1);
  sample_temp(1) <= sample_vector(3) WHEN sel_sample(0) = '0' ELSE sample_vector(4);
  sample_temp(2) <= sample_temp(0)   WHEN sel_sample(1) = '0' ELSE sample_vector(2);
  sample_temp(3) <= sample_temp(1)   WHEN sel_sample(1) = '0' ELSE sample_vector(5);
  sample         <= sample_temp(2)   WHEN sel_sample(2) = '0' ELSE sample_temp(3);
  
  
END beh;

