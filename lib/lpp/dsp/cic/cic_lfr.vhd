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
    
  PORT (
    clk            : IN  STD_LOGIC;
    rstn           : IN  STD_LOGIC;
    run            : IN  STD_LOGIC;
    
    data_in        : IN  sample_vector(5 DOWNTO 0,15 DOWNTO 0);
    data_in_valid  : IN  STD_LOGIC;

    data_out_16    : OUT sample_vector(5 DOWNTO 0,15 DOWNTO 0);
    data_out_256   : OUT sample_vector(5 DOWNTO 0,15 DOWNTO 0);
    data_out_valid : OUT STD_LOGIC
    );

END cic_lfr;

ARCHITECTURE beh OF cic_lfr IS
  
BEGIN

  
  
END beh;
