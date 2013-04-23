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

  COMPONENT AD7688_drvr
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


--===========================================================|
--=======================  ADS 127X =========================|
--===========================================================|

Type ADS127X_FORMAT_Type is array(2 downto 0) of std_logic;
constant ADS127X_SPI_FORMAT     : ADS127X_FORMAT_Type := "010";
constant ADS127X_FSYNC_FORMAT   : ADS127X_FORMAT_Type := "101";

Type ADS127X_MODE_Type is array(1 downto 0) of std_logic;
constant ADS127X_MODE_low_power         : ADS127X_MODE_Type := "10";
constant ADS127X_MODE_low_speed         : ADS127X_MODE_Type := "11";
constant ADS127X_MODE_high_resolution   : ADS127X_MODE_Type := "01";

Type ADS127X_config is
    record
        SYNC    : std_logic;
        CLKDIV  : std_logic;
        FORMAT  : ADS127X_FORMAT_Type;
        MODE    : ADS127X_MODE_Type;
end record;

COMPONENT ADS1274_DRIVER is 
generic(modeCfg : ADS127X_MODE_Type := ADS127X_MODE_low_power; formatCfg : ADS127X_FORMAT_Type := ADS127X_FSYNC_FORMAT);
port(
    Clk     :   in  std_logic;
    reset   :   in  std_logic;
    SpiClk  :   out std_logic;
    DIN     :   in  std_logic_vector(3 downto 0);
    Ready   :   in  std_logic;
    Format  :   out std_logic_vector(2 downto 0);
    Mode    :   out std_logic_vector(1 downto 0);
    ClkDiv  :   out std_logic;
    PWDOWN  :   out std_logic_vector(3 downto 0);
    SmplClk :   in  std_logic;
    OUT0    :   out std_logic_vector(23 downto 0);
    OUT1    :   out std_logic_vector(23 downto 0);
    OUT2    :   out std_logic_vector(23 downto 0);
    OUT3    :   out std_logic_vector(23 downto 0);
    FSynch  :   out std_logic;
    test    :   out std_logic
);
end COMPONENT;



END lpp_ad_conv;


