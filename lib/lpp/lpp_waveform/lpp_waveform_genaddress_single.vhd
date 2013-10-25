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
-- Author : Jean-christophe Pellion
-- Mail   : jean-christophe.pellion@lpp.polytechnique.fr
--          jean-christophe.pellion@easii-ic.com
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY grlib;
USE grlib.amba.ALL;
USE grlib.stdlib.ALL;
USE grlib.devices.ALL;
USE GRLIB.DMA2AHB_Package.ALL;

LIBRARY lpp;
USE lpp.lpp_waveform_pkg.ALL;

LIBRARY techmap;
USE techmap.gencomp.ALL;

ENTITY lpp_waveform_genaddress_single IS
  
  GENERIC (
    nb_burst_available_size : INTEGER);

  PORT (
    clk               : IN STD_LOGIC;
    rstn              : IN STD_LOGIC;
    run               : IN STD_LOGIC;
    -------------------------------------------------------------------------
    -- CONFIG
    -------------------------------------------------------------------------
    nb_data_by_buffer : IN STD_LOGIC_VECTOR(nb_burst_available_size-1 DOWNTO 0);
    addr_data_f3      : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    -------------------------------------------------------------------------
    -- CTRL
    -------------------------------------------------------------------------
    empty             : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    empty_almost      : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    data_ren          : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    --burst             : IN STD_LOGIC_VECTOR(3 DOWNTO 0);

    -------------------------------------------------------------------------
    -- STATUS
    -------------------------------------------------------------------------
    status_full     : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    status_full_ack : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    status_full_err : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);

    -------------------------------------------------------------------------
    -- ADDR DATA OUT
    -------------------------------------------------------------------------
    data_f0_data_out_valid_burst : OUT STD_LOGIC;
    data_f1_data_out_valid_burst : OUT STD_LOGIC;
    data_f2_data_out_valid_burst : OUT STD_LOGIC;
    data_f3_data_out_valid_burst : OUT STD_LOGIC;

    data_f0_data_out_valid : OUT STD_LOGIC;
    data_f1_data_out_valid : OUT STD_LOGIC;
    data_f2_data_out_valid : OUT STD_LOGIC;
    data_f3_data_out_valid : OUT STD_LOGIC;

    data_f0_addr_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    data_f1_addr_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    data_f2_addr_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    data_f3_addr_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)

    );

END lpp_waveform_genaddress_single;

ARCHITECTURE beh OF lpp_waveform_genaddress_single IS

BEGIN  -- beh

  
  

END beh;
