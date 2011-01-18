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
use work.FIFO_Config.all;

--! Package contenant tous les programmes qui forment le composant intégré dans le léon 

package lpp_fifo is

component APB_FIFO is
  generic (
    pindex   : integer := 0;
    paddr    : integer := 0;
    pmask    : integer := 16#fff#;
    pirq     : integer := 0;
    abits    : integer := 8);
  port (
    clk     : in  std_logic;
    rst     : in  std_logic;
    apbi    : in  apb_slv_in_type;
    apbo    : out apb_slv_out_type
    );
end component;


component Top_FIFO is
  port(
    clk      : in std_logic;
    raz      : in std_logic;
    flag_RE  : in std_logic;
    flag_WR  : in std_logic;
    Data_in  : in std_logic_vector(Data_sz-1 downto 0);
    full     : out std_logic;
    empty    : out std_logic;
    Data_out : out std_logic_vector(Data_sz-1 downto 0)
    );
end component;


component Fifo_Read is
  port(
    clk      : in std_logic;
    raz      : in std_logic;
    flag_RE  : in std_logic;
    WAD      : in integer range 0 to addr_max_int;
    empty    : out std_logic;
    RAD      : out integer range 0 to addr_max_int;
    Raddr    : out std_logic_vector(addr_sz-1 downto 0)
    );
end component;


component Fifo_Write is
  port(
    clk     : in std_logic;
    raz     : in std_logic;
    flag_WR : in std_logic;
    RAD     : in integer range 0 to addr_max_int;
    full    : out std_logic;
    WAD     : out integer range 0 to addr_max_int;
    Waddr   : out std_logic_vector(addr_sz-1 downto 0)
    );
end component;

end;
