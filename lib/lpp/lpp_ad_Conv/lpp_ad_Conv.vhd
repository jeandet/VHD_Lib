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
--                    Author : Alexis Jeandet
--                     Mail : alexis.jeandet@lpp.polytechnique.fr
----------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
LIBRARY grlib;
USE grlib.amba.ALL;
USE grlib.stdlib.ALL;
USE grlib.devices.ALL;


PACKAGE lpp_ad_conv IS


  --CONSTANT AD7688  : INTEGER := 0;
  --CONSTANT ADS7886 : INTEGER := 1;


  --TYPE AD7688_out IS
  --RECORD
  --  CNV : STD_LOGIC;
  --  SCK : STD_LOGIC;
  --END RECORD;

  --TYPE AD7688_in_element IS
  --RECORD
  --  SDI : STD_LOGIC;
  --END RECORD;

  --TYPE AD7688_in IS ARRAY(NATURAL RANGE <>) OF AD7688_in_element;

  TYPE Samples IS ARRAY(NATURAL RANGE <>) OF STD_LOGIC_VECTOR(15 DOWNTO 0);

  COMPONENT ADS7886_drvr
    GENERIC (
      ChanelCount     : INTEGER;
      ncycle_cnv_high : INTEGER := 79;
      ncycle_cnv      : INTEGER := 500);
    PORT (
      cnv_clk    : IN  STD_LOGIC;
      cnv_rstn   : IN  STD_LOGIC;
      cnv_run  : IN  STD_LOGIC;
      cnv        : OUT STD_LOGIC;
      clk        : IN  STD_LOGIC;
      rstn       : IN  STD_LOGIC;
      sck        : OUT STD_LOGIC;
      sdo        : IN  STD_LOGIC_VECTOR(ChanelCount-1 DOWNTO 0);
      sample     : OUT Samples(ChanelCount-1 DOWNTO 0);
      sample_val : OUT STD_LOGIC);
  END COMPONENT;
  
  --COMPONENT AD7688_drvr IS
  --  GENERIC(ChanelCount : INTEGER;
  --          clkkHz      : INTEGER);
  --  PORT (clk        : IN  STD_LOGIC;
  --         rstn      : IN  STD_LOGIC;
  --         enable    : IN  STD_LOGIC;
  --         smplClk   : IN  STD_LOGIC;
  --         DataReady : OUT STD_LOGIC;
  --         smpout    : OUT Samples_out(ChanelCount-1 DOWNTO 0);
  --         AD_in     : IN  AD7688_in(ChanelCount-1 DOWNTO 0);
  --         AD_out    : OUT AD7688_out);
  --END COMPONENT;


  --COMPONENT AD7688_spi_if IS
  --  GENERIC(ChanelCount : INTEGER);
  --  PORT(clk           : IN  STD_LOGIC;
  --           reset     : IN  STD_LOGIC;
  --           cnv       : IN  STD_LOGIC;
  --           DataReady : OUT STD_LOGIC;
  --           sdi       : IN  AD7688_in(ChanelCount-1 DOWNTO 0);
  --           smpout    : OUT Samples_out(ChanelCount-1 DOWNTO 0)
  --           );
  --END COMPONENT;


  --COMPONENT lpp_apb_ad_conv
  --  GENERIC(
  --    pindex      : INTEGER := 0;
  --    paddr       : INTEGER := 0;
  --    pmask       : INTEGER := 16#fff#;
  --    pirq        : INTEGER := 0;
  --    abits       : INTEGER := 8;
  --    ChanelCount : INTEGER := 1;
  --    clkkHz      : INTEGER := 50000;
  --    smpClkHz    : INTEGER := 100;
  --    ADCref      : INTEGER := AD7688);
  --  PORT (
  --    clk    : IN  STD_LOGIC;
  --    reset  : IN  STD_LOGIC;
  --    apbi   : IN  apb_slv_in_type;
  --    apbo   : OUT apb_slv_out_type;
  --    AD_in  : IN  AD7688_in(ChanelCount-1 DOWNTO 0);
  --    AD_out : OUT AD7688_out);
  --END COMPONENT;

  --COMPONENT ADS7886_drvr IS
  --  GENERIC(ChanelCount : INTEGER;
  --          clkkHz      : INTEGER);
  --  PORT (
  --    clk       : IN  STD_LOGIC;
  --    reset     : IN  STD_LOGIC;
  --    smplClk   : IN  STD_LOGIC;
  --    DataReady : OUT STD_LOGIC;
  --    smpout    : OUT Samples_out(ChanelCount-1 DOWNTO 0);
  --    AD_in     : IN  AD7688_in(ChanelCount-1 DOWNTO 0);
  --    AD_out    : OUT AD7688_out
  --    );
  --END COMPONENT;

  --COMPONENT WriteGen_ADC IS
  --  PORT(
  --    clk       : IN  STD_LOGIC;
  --    rstn      : IN  STD_LOGIC;
  --    SmplCLK   : IN  STD_LOGIC;
  --    DataReady : IN  STD_LOGIC;
  --    Full      : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
  --    ReUse     : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
  --    Write     : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
  --    );
  --END COMPONENT;

END lpp_ad_conv;


