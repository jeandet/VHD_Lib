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

  SUBTYPE Samples24 IS STD_LOGIC_VECTOR(23 DOWNTO 0);

  SUBTYPE Samples16 IS STD_LOGIC_VECTOR(15 DOWNTO 0);

  SUBTYPE Samples14 IS STD_LOGIC_VECTOR(13 DOWNTO 0);

  SUBTYPE Samples12 IS STD_LOGIC_VECTOR(11 DOWNTO 0);

  SUBTYPE Samples10 IS STD_LOGIC_VECTOR(9 DOWNTO 0);

  SUBTYPE Samples8 IS STD_LOGIC_VECTOR(7 DOWNTO 0);

  TYPE Samples24v IS ARRAY(NATURAL RANGE <>) OF Samples24;

  TYPE Samples16v IS ARRAY(NATURAL RANGE <>) OF Samples16;

  TYPE Samples14v IS ARRAY(NATURAL RANGE <>) OF Samples14;

  TYPE Samples12v IS ARRAY(NATURAL RANGE <>) OF Samples12;

  TYPE Samples10v IS ARRAY(NATURAL RANGE <>) OF Samples10;

  TYPE Samples8v IS ARRAY(NATURAL RANGE <>) OF Samples8;

  COMPONENT AD7688_drvr
    GENERIC (
      ChanelCount     : INTEGER;
      ncycle_cnv_high : INTEGER := 79;
      ncycle_cnv      : INTEGER := 500);
    PORT (
      cnv_clk    : IN  STD_LOGIC;
      cnv_rstn   : IN  STD_LOGIC;
      cnv_run    : IN  STD_LOGIC;
      cnv        : OUT STD_LOGIC;
      clk        : IN  STD_LOGIC;
      rstn       : IN  STD_LOGIC;
      sck        : OUT STD_LOGIC;
      sdo        : IN  STD_LOGIC_VECTOR(ChanelCount-1 DOWNTO 0);
      sample     : OUT Samples(ChanelCount-1 DOWNTO 0);
      sample_val : OUT STD_LOGIC);
  END COMPONENT;

  COMPONENT RHF1401_drvr IS
    GENERIC(
      ChanelCount : INTEGER := 8);
    PORT (
      cnv_clk    : IN  STD_LOGIC;
      clk        : IN  STD_LOGIC;
      rstn       : IN  STD_LOGIC;
      ADC_data   : IN  Samples14;
      --ADC_smpclk : OUT STD_LOGIC;
      ADC_nOE    : OUT STD_LOGIC_VECTOR(ChanelCount-1 DOWNTO 0);
      sample     : OUT Samples14v(ChanelCount-1 DOWNTO 0);
      sample_val : OUT STD_LOGIC
      );
  END COMPONENT;

  COMPONENT top_ad_conv_RHF1401
    GENERIC (
      ChanelCount : INTEGER;
      ncycle_cnv_high : INTEGER := 79;
      ncycle_cnv      : INTEGER := 500);
    PORT (
      cnv_clk    : IN  STD_LOGIC;
      cnv_rstn   : IN  STD_LOGIC;
      cnv        : OUT STD_LOGIC;
      clk        : IN  STD_LOGIC;
      rstn       : IN  STD_LOGIC;
      ADC_data   : IN  Samples14;
      ADC_nOE    : OUT STD_LOGIC_VECTOR(ChanelCount-1 DOWNTO 0);
      sample     : OUT Samples14v(ChanelCount-1 DOWNTO 0);
      sample_val : OUT STD_LOGIC);
  END COMPONENT;


  COMPONENT AD7688_drvr_sync
    GENERIC (
      ChanelCount     : INTEGER;
      ncycle_cnv_high : INTEGER;
      ncycle_cnv      : INTEGER);
    PORT (
      cnv_clk    : IN  STD_LOGIC;
      cnv_rstn   : IN  STD_LOGIC;
      cnv_run    : IN  STD_LOGIC;
      cnv        : OUT STD_LOGIC;
      sck        : OUT STD_LOGIC;
      sdo        : IN  STD_LOGIC_VECTOR(ChanelCount-1 DOWNTO 0);
      sample     : OUT Samples(ChanelCount-1 DOWNTO 0);
      sample_val : OUT STD_LOGIC);
  END COMPONENT;

  COMPONENT TestModule_RHF1401
    GENERIC (
      freq      : INTEGER;
      amplitude : INTEGER;
      impulsion : INTEGER);
    PORT (
      ADC_smpclk  : IN  STD_LOGIC;
      ADC_OEB_bar : IN  STD_LOGIC;
      ADC_data    : OUT STD_LOGIC_VECTOR(13 DOWNTO 0));
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

  TYPE     ADS127X_FORMAT_Type IS ARRAY(2 DOWNTO 0) OF STD_LOGIC;
  CONSTANT ADS127X_SPI_FORMAT   : ADS127X_FORMAT_Type := "010";
  CONSTANT ADS127X_FSYNC_FORMAT : ADS127X_FORMAT_Type := "101";

  TYPE     ADS127X_MODE_Type IS ARRAY(1 DOWNTO 0) OF STD_LOGIC;
  CONSTANT ADS127X_MODE_low_power       : ADS127X_MODE_Type := "10";
  CONSTANT ADS127X_MODE_low_speed       : ADS127X_MODE_Type := "11";
  CONSTANT ADS127X_MODE_high_resolution : ADS127X_MODE_Type := "01";

  TYPE ADS127X_config IS
  RECORD
    SYNC   : STD_LOGIC;
    CLKDIV : STD_LOGIC;
    FORMAT : ADS127X_FORMAT_Type;
    MODE   : ADS127X_MODE_Type;
  END RECORD;

  COMPONENT ADS1274_DRIVER IS
    GENERIC(modeCfg : ADS127X_MODE_Type := ADS127X_MODE_low_power; formatCfg : ADS127X_FORMAT_Type := ADS127X_FSYNC_FORMAT);
    PORT(
      Clk     : IN  STD_LOGIC;
      reset   : IN  STD_LOGIC;
      SpiClk  : OUT STD_LOGIC;
      DIN     : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      Ready   : IN  STD_LOGIC;
      Format  : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      Mode    : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      ClkDiv  : OUT STD_LOGIC;
      PWDOWN  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      SmplClk : IN  STD_LOGIC;
      OUT0    : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
      OUT1    : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
      OUT2    : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
      OUT3    : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
      FSynch  : OUT STD_LOGIC;
      test    : OUT STD_LOGIC
      );
  END COMPONENT;

-- todo clean file
  COMPONENT DUAL_ADS1278_DRIVER IS
    PORT(
      Clk     : IN  STD_LOGIC;
      reset   : IN  STD_LOGIC;
      SpiClk  : OUT STD_LOGIC;
      DIN     : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
      SmplClk : IN  STD_LOGIC;
      OUT00   : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
      OUT01   : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
      OUT02   : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
      OUT03   : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
      OUT04   : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
      OUT05   : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
      OUT06   : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
      OUT07   : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
      OUT10   : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
      OUT11   : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
      OUT12   : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
      OUT13   : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
      OUT14   : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
      OUT15   : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
      OUT16   : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
      OUT17   : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
      FSynch  : OUT STD_LOGIC
      );
  END COMPONENT;

--===========================================================|
-- DRIVER ADS7886
--===========================================================|
COMPONENT top_ad_conv_ADS7886_v2 IS
  GENERIC(
    ChannelCount 	: INTEGER := 8;
	SampleNbBits	: INTEGER := 14;
    ncycle_cnv_high : INTEGER := 40;	-- at least 32 cycles
    ncycle_cnv      : INTEGER := 500);
  PORT (
	-- CONV
    cnv_clk  	: IN STD_LOGIC;
    cnv_rstn 	: IN STD_LOGIC;
    cnv 		: OUT STD_LOGIC;
	-- DATA
    clk        	: IN  STD_LOGIC;
    rstn       	: IN  STD_LOGIC;
	sck			: OUT STD_LOGIC;
	sdo			: IN  STD_LOGIC_VECTOR(ChannelCount-1 DOWNTO 0);
	-- SAMPLE
    sample     : OUT Samples14v(ChannelCount-1 DOWNTO 0);
    sample_val : OUT STD_LOGIC
    );
END COMPONENT;

COMPONENT ADS7886_drvr_v2 IS
  GENERIC(
    ChannelCount	: INTEGER	:= 8;
    NbBitsSamples	: INTEGER	:= 16);
  PORT (
    -- CONV --
    cnv_clk   : IN  STD_LOGIC;
    cnv_rstn  : IN  STD_LOGIC;
    -- DATA --
    clk  : IN  STD_LOGIC;
    rstn : IN  STD_LOGIC;
    sck  : OUT STD_LOGIC;
    sdo  : IN  STD_LOGIC_VECTOR(ChannelCount-1 DOWNTO 0);
	-- SAMPLE --
    sample     : OUT Samples(ChannelCount-1 DOWNTO 0);
    sample_val : OUT STD_LOGIC
    );    
END COMPONENT;

COMPONENT top_ad_conv_RHF1401_withFilter
  GENERIC (
    ChanelCount     : INTEGER;
    ncycle_cnv_high : INTEGER;
    ncycle_cnv      : INTEGER);
  PORT (
    cnv_clk    : IN  STD_LOGIC;
    cnv_rstn   : IN  STD_LOGIC;
    cnv        : OUT STD_LOGIC;
    clk        : IN  STD_LOGIC;
    rstn       : IN  STD_LOGIC;
    ADC_data   : IN  Samples14;
    ADC_nOE    : OUT STD_LOGIC_VECTOR(ChanelCount-1 DOWNTO 0);
    sample     : OUT Samples14v(ChanelCount-1 DOWNTO 0);
    sample_val : OUT STD_LOGIC);
END COMPONENT;

  
END lpp_ad_conv;








