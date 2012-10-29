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

package lpp_usb is

component APB_USB is
    generic (
      pindex   : integer := 0;
      paddr    : integer := 0;
      pmask    : integer := 16#fff#;
      pirq     : integer := 0;
      abits    : integer := 8;
      DataMax  : integer := 1024);
    port (
      clk      : in  std_logic;           --! Horloge du composant
      rst      : in  std_logic;           --! Reset general du composant
      flagC    : in std_logic;
      flagB    : in std_logic;
      ifclk    : out std_logic;
      sloe     : out std_logic;
      slrd     : out std_logic;
      slwr     : out std_logic;
      pktend   : out std_logic;
      fifoadr  : out std_logic_vector(1 downto 0);
      fdbusrw  : inout std_logic_vector(7 downto 0);
      apbi     : in  apb_slv_in_type;     --! Registre de gestion des entrées du bus
      apbo     : out apb_slv_out_type     --! Registre de gestion des sorties du bus
  );
end component;


  component RWbuf is
      generic(DataMax : integer := 1024);
      port(
          clk         : in std_logic;
          rst         : in std_logic;
          flagC       : in std_logic;
          flagB       : in std_logic;
          IOselect    : in std_logic;
          ifclk       : out std_logic;
          sloe        : out std_logic;        
          slrd        : out std_logic;
          slwr        : out std_logic;
          pktend      : out std_logic;
          fifoadr     : out std_logic_vector(1 downto 0);
          fdbusrw     : inout std_logic_vector(7 downto 0)
      ); 
  end component;

end package;