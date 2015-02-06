------------------------------------------------------------------------------
--  This file is a part of the LPP VHDL IP LIBRARY
--  Copyright (C) 2009 - 2015, Laboratory of Plasmas Physic - CNRS
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
--                        Author : Alexis Jeandet
--                     Mail : alexis.jeandet@member.fsf.org
------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY grlib;
USE grlib.amba.ALL;
USE grlib.stdlib.ALL;
USE grlib.devices.ALL;
LIBRARY lpp;
USE lpp.lpp_amba.ALL;
USE lpp.lpp_cna.ALL;
USE lpp.apb_devices_list.ALL;

ENTITY apb_lfr_cal IS
  GENERIC (
    pindex        : INTEGER := 0;
    paddr         : INTEGER := 0;
    pmask         : INTEGER := 16#fff#;
    tech          : INTEGER := 0;
    PRESZ         : INTEGER := 8;
    CPTSZ         : INTEGER := 16;
    datawidth     : INTEGER := 18;
    dacresolution : INTEGER := 12;
    abits         : INTEGER := 8
    );
  PORT (
    rstn   : IN  STD_LOGIC;
    clk    : IN  STD_LOGIC;
    apbi   : IN  apb_slv_in_type;
    apbo   : OUT apb_slv_out_type;
    SDO    : OUT STD_LOGIC;
    SCK    : OUT STD_LOGIC;
    SYNC   : OUT STD_LOGIC;
    SMPCLK : OUT STD_LOGIC
    );
END ENTITY;

--! @details Les deux registres (apbi,apbo) permettent de gérer la communication sur le bus
--! et les sorties seront cablées vers le convertisseur.

ARCHITECTURE ar_apb_lfr_cal OF apb_lfr_cal IS

  CONSTANT REVISION : INTEGER := 1;

  CONSTANT pconfig : apb_config_type := (
    0 => ahb_device_reg (VENDOR_LPP, LPP_CNA, 0, REVISION, 0),
    1 => apb_iobar(paddr, pmask));

  SIGNAL pre           : STD_LOGIC_VECTOR(PRESZ-1 DOWNTO 0);
  SIGNAL N             : STD_LOGIC_VECTOR(CPTSZ-1 DOWNTO 0);
  SIGNAL Reload        : STD_LOGIC;
  SIGNAL DATA_IN       : STD_LOGIC_VECTOR(datawidth-1 DOWNTO 0);
  SIGNAL WEN           : STD_LOGIC;
  SIGNAL LOAD_ADDRESSN : STD_LOGIC;
  SIGNAL ADDRESS_IN    : STD_LOGIC_VECTOR(abits-1 DOWNTO 0);
  SIGNAL ADDRESS_OUT   : STD_LOGIC_VECTOR(abits-1 DOWNTO 0);
  SIGNAL INTERLEAVED   : STD_LOGIC;
  SIGNAL DAC_CFG       : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL Rdata         : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN

  cal : lfr_cal_driver
    GENERIC MAP(
      tech      => tech,
      PRESZ     => PRESZ,
      CPTSZ     => CPTSZ,
      datawidth => datawidth,
      abits     => abits
      )
    PORT MAP(
      clk           => clk,
      rstn          => rstn,
      
      pre           => pre,
      N             => N,
      Reload        => Reload,
      DATA_IN       => DATA_IN,
      WEN           => WEN,
      LOAD_ADDRESSN => LOAD_ADDRESSN,
      ADDRESS_IN    => ADDRESS_IN,
      ADDRESS_OUT   => ADDRESS_OUT,
      INTERLEAVED   => INTERLEAVED,
      DAC_CFG       => DAC_CFG,
      
      SYNC          => SYNC,
      DOUT          => SDO,
      SCLK          => SCK,
      SMPCLK        => SMPCLK           -- OPEN
      );

  PROCESS(rstn, clk)
  BEGIN
    IF(rstn = '0')then
      pre           <= (OTHERS => '1');
      N             <= (OTHERS => '1');
      Reload        <= '1';
      DATA_IN       <= (OTHERS => '0');
      WEN           <= '1';
      LOAD_ADDRESSN <= '1';
      ADDRESS_IN    <= (OTHERS => '1');
      INTERLEAVED   <= '0';
      DAC_CFG       <= (OTHERS => '0');
      Rdata         <= (OTHERS => '0');
    ELSIF(clk'EVENT AND clk = '1')then


      --APB Write OP
      IF (apbi.psel(pindex) AND apbi.penable AND apbi.pwrite) = '1' THEN
        CASE apbi.paddr(abits-1 DOWNTO 2) IS
          WHEN "000000" =>
            DAC_CFG     <= apbi.pwdata(3 DOWNTO 0);
            Reload      <= apbi.pwdata(4);
            INTERLEAVED <= apbi.pwdata(5);
          WHEN "000001" =>
            pre <= apbi.pwdata(PRESZ-1 DOWNTO 0);
          WHEN "000010" =>
            N <= apbi.pwdata(CPTSZ-1 DOWNTO 0);
          WHEN "000011" =>
            ADDRESS_IN    <= apbi.pwdata(abits-1 DOWNTO 0);
            LOAD_ADDRESSN <= '0';
          WHEN "000100" =>
            DATA_IN <= apbi.pwdata(datawidth-1 DOWNTO 0);
            WEN     <= '0';
          WHEN OTHERS =>
            NULL;
        END CASE;
      ELSE
        LOAD_ADDRESSN <= '1';
        WEN           <= '1';
      END IF;

      --APB Read OP
      IF (apbi.psel(pindex) AND (NOT apbi.pwrite)) = '1' THEN
        CASE apbi.paddr(abits-1 DOWNTO 2) IS
          WHEN "000000" =>
            Rdata(3 DOWNTO 0)  <= DAC_CFG;
            Rdata(4)           <= Reload;
            Rdata(5)           <= INTERLEAVED;
            Rdata(31 DOWNTO 6) <= (OTHERS => '0');
          WHEN "000001" =>
            Rdata(PRESZ-1 DOWNTO 0) <= pre;
            Rdata(31 DOWNTO PRESZ)  <= (OTHERS => '0');
          WHEN "000010" =>
            Rdata(CPTSZ-1 DOWNTO 0) <= N;
            Rdata(31 DOWNTO CPTSZ)  <= (OTHERS => '0');
          WHEN "000011" =>
            Rdata(abits-1 DOWNTO 0) <= ADDRESS_OUT;
            Rdata(31 DOWNTO abits)  <= (OTHERS => '0');
          WHEN "000100" =>
            Rdata(datawidth-1 DOWNTO 0) <= DATA_IN;
            Rdata(31 DOWNTO datawidth)  <= (OTHERS => '0');
          WHEN OTHERS =>
            Rdata <= (OTHERS => '0');
        END CASE;
      END IF;

    END IF;
    apbo.pconfig <= pconfig;
  END PROCESS;

  apbo.prdata <= Rdata WHEN apbi.penable = '1';
END ARCHITECTURE ar_apb_lfr_cal;
