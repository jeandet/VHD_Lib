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
------------------------------------------------------------------------------
--                    Author : Martin Morlot
--                     Mail : martin.morlot@lpp.polytechnique.fr
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library grlib;
use grlib.amba.all;
use std.textio.all;
library lpp;
use lpp.lpp_amba.all;

--! Package contenant tous les programmes qui forment le composant intégré dans le léon 

package lpp_Header is

component HeaderBuilder is
  generic(
      Data_sz  : integer := 32);
    port(
        clkm            : in std_logic;
        rstn            : in std_logic;

        Statu : in std_logic_vector(3 downto 0);
        Matrix_Type : in std_logic_vector(1 downto 0);
        Matrix_Write : in std_logic;
        Valid : out std_logic;               

        dataIN : in std_logic_vector((2*Data_sz)-1 downto 0);
        emptyIN : in std_logic_vector(1 downto 0);
        RenOUT : out std_logic_vector(1 downto 0);

        dataOUT  : out std_logic_vector(Data_sz-1 downto 0);
        emptyOUT : out std_logic;
        RenIN : in std_logic;

        header     : out  std_logic_vector(Data_sz-1 DOWNTO 0);
        header_val : out  std_logic;
        header_ack : in std_logic
        );
end component;

end;