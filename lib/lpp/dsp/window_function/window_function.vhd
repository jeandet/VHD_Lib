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
USE ieee.numeric_std.ALL;

LIBRARY lpp;
USE lpp.window_function_pkg.ALL;

ENTITY window_function IS
  GENERIC (
    SIZE_DATA  : INTEGER := 16;
    SIZE_PARAM : INTEGER := 10;
    NB_POINT_BY_WINDOW : INTEGER := 256
    );

  PORT (
    clk  : IN STD_LOGIC;
    rstn : IN STD_LOGIC;
    --ctrl
    restart_window : IN STD_LOGIC;
    --data_in
    data_in       : IN STD_LOGIC_VECTOR(SIZE_DATA-1 DOWNTO 0);
    data_in_valid : IN STD_LOGIC;
    --data_out
    data_out       : OUT STD_LOGIC_VECTOR(SIZE_DATA-1 DOWNTO 0);
    data_out_valid : OUT STD_LOGIC
    );

END window_function;

ARCHITECTURE beh OF window_function IS
  
  SIGNAL param_in       : STD_LOGIC_VECTOR(SIZE_PARAM-1 DOWNTO 0);
  SIGNAL param_index    : INTEGER RANGE 0 TO NB_POINT_BY_WINDOW-1;
  
  SIGNAL PARAM_ALL_POSITIVE : STD_LOGIC;
  
BEGIN

  WF_rom_1: WF_rom
    GENERIC MAP (
      SIZE_PARAM         => SIZE_PARAM,
      NB_POINT_BY_WINDOW => NB_POINT_BY_WINDOW)
    PORT MAP (
      data               => param_in,
      index              => param_index,
      PARAM_ALL_POSITIVE => PARAM_ALL_POSITIVE );
  
  WF_processing_1: WF_processing
    GENERIC MAP (
      SIZE_DATA          => SIZE_DATA,
      SIZE_PARAM         => SIZE_PARAM,
      NB_POINT_BY_WINDOW => NB_POINT_BY_WINDOW)
    PORT MAP (
      clk            => clk,
      rstn           => rstn,
      restart_window => restart_window,
      data_in        => data_in,
      data_in_valid  => data_in_valid,
      data_out       => data_out,
      data_out_valid => data_out_valid,
      param_in       => param_in,
      param_index    => param_index,
      PARAM_ALL_POSITIVE => PARAM_ALL_POSITIVE );
  
END beh;