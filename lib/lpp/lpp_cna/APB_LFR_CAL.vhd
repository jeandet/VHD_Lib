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
library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;
library lpp;
use lpp.lpp_amba.all;
use lpp.lpp_cna.all;
use lpp.apb_devices_list.all;

entity apb_lfr_cal is
  generic (
    pindex   : integer := 0;
    paddr    : integer := 0;
    pmask    : integer := 16#fff#;
    tech     : integer := 0;
    PRESZ    : integer := 8;
    CPTSZ    : integer := 16;
    datawidth : integer := 18;
    dacresolution : integer := 12;
    abits     : integer := 8
    );
  port (
    rstn    : in  std_logic;
    clk     : in  std_logic;
    apbi    : in  apb_slv_in_type;
    apbo    : out apb_slv_out_type;
    SDO     : out  std_logic;
    SCK     : out  std_logic;
    SYNC    : out  std_logic;
    SMPCLK  : out  std_logic
    );
end entity;

--! @details Les deux registres (apbi,apbo) permettent de gérer la communication sur le bus
--! et les sorties seront cablées vers le convertisseur.

architecture ar_apb_lfr_cal of apb_lfr_cal is

constant REVISION : integer := 1;

constant pconfig : apb_config_type := (
  0 => ahb_device_reg (VENDOR_LPP, LPP_CNA, 0, REVISION, 0),
  1 => apb_iobar(paddr, pmask));

signal pre             : STD_LOGIC_VECTOR(PRESZ-1 downto 0);
signal N               : STD_LOGIC_VECTOR(CPTSZ-1 downto 0);
signal Reload          : std_logic;
signal DATA_IN         : STD_LOGIC_VECTOR(datawidth-1 downto 0);
signal WEN             : STD_LOGIC;
signal LOAD_ADDRESSN   : STD_LOGIC;
signal ADDRESS_IN      : STD_LOGIC_VECTOR(abits-1 downto 0);
signal ADDRESS_OUT     : STD_LOGIC_VECTOR(abits-1 downto 0);
signal INTERLEAVED     : STD_LOGIC;
signal DAC_CFG         : STD_LOGIC_VECTOR(3 downto 0);
signal Rdata           : std_logic_vector(31 downto 0);

begin

cal: lfr_cal_driver
    generic map(
        tech      => tech,
        PRESZ     => PRESZ,
        CPTSZ     => CPTSZ,
        datawidth => datawidth,
        abits     => abits
     )
    Port map(
        clk             => clk,
        rstn            => rstn,
        pre             => pre,
        N               => N,
        Reload          => Reload,
        DATA_IN         => DATA_IN,
        WEN             => WEN,
        LOAD_ADDRESSN   => LOAD_ADDRESSN,
        ADDRESS_IN      => ADDRESS_IN,
        ADDRESS_OUT     => ADDRESS_OUT,
        INTERLEAVED     => INTERLEAVED,
        DAC_CFG         => DAC_CFG,
        SYNC            => SYNC,
        DOUT            => SDO,
        SCLK            => SCK,
        SMPCLK          => SMPCLK
              );

    process(rstn,clk)
    begin
        if(rstn='0')then
           pre           <= (others=>'1');
           N             <= (others=>'1');
           Reload        <= '1';
           DATA_IN       <= (others=>'0');
           WEN           <= '1';
           LOAD_ADDRESSN <= '1';
           ADDRESS_IN    <= (others=>'1');
           INTERLEAVED   <= '0';
           DAC_CFG       <= (others=>'0');
           Rdata         <= (others=>'0');
        elsif(clk'event and clk='1')then 
        

    --APB Write OP
            if (apbi.psel(pindex) and apbi.penable and apbi.pwrite) = '1' then
                case apbi.paddr(abits-1 downto 2) is
                    when "000000" =>
                        DAC_CFG     <= apbi.pwdata(3 downto 0);
                        Reload      <= apbi.pwdata(4);
                        INTERLEAVED <= apbi.pwdata(5);
                    when "000001" =>
                         pre        <= apbi.pwdata(PRESZ-1 downto 0);
                    when "000010" =>
                         N          <= apbi.pwdata(CPTSZ-1 downto 0);
                    when "000011" =>
                         ADDRESS_IN <= apbi.pwdata(abits-1 downto 0);
                         LOAD_ADDRESSN <= '0';
                    when "000100" =>
                         DATA_IN    <= apbi.pwdata(datawidth-1 downto 0);
                         WEN        <= '0';
                    when others =>
                        null;
                end case;
            else
                LOAD_ADDRESSN <= '1';
                WEN           <= '1';
            end if;

    --APB Read OP
            if (apbi.psel(pindex) and (not apbi.pwrite)) = '1' then
                case apbi.paddr(abits-1 downto 2) is
                    when "000000" =>
                         Rdata(3 downto 0)  <= DAC_CFG;
                         Rdata(4)           <= Reload;
                         Rdata(5)           <= INTERLEAVED;
                         Rdata(31 downto 6) <= (others => '0');
                    when "000001" =>
                         Rdata(PRESZ-1 downto 0)  <= pre;
                         Rdata(31 downto PRESZ)   <= (others => '0');
                    when "000010" =>
                         Rdata(CPTSZ-1 downto 0)  <= N;
                         Rdata(31 downto CPTSZ)   <= (others => '0');
                    when "000011" =>
                         Rdata(abits-1 downto 0)  <= ADDRESS_OUT;
                         Rdata(31 downto abits)   <= (others => '0');
                    when "000100" =>
                         Rdata(datawidth-1 downto 0)  <= DATA_IN;
                         Rdata(31 downto datawidth)   <= (others => '0');
                    when others =>
                         Rdata <= (others => '0');
                end case;
            end if;

        end if;
        apbo.pconfig <= pconfig;
    end process;

apbo.prdata     <=   Rdata when apbi.penable = '1';
end architecture ar_apb_lfr_cal;