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
--                        Author : Martin Morlot
--                     Mail : martin.morlot@lpp.polytechnique.fr
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;
library lpp;
use lpp.lpp_amba.all;
use lpp.apb_devices_list.all;
use lpp.lpp_usb.all;

--! Driver APB, va faire le lien entre l'IP VHDL du convertisseur et le bus Amba

entity APB_USB is
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
end entity;


architecture ar_APB_USB of APB_USB is

constant REVISION : integer := 1;

constant pconfig : apb_config_type := (
  0 => ahb_device_reg (VENDOR_LPP, LPP_USB, 0, REVISION, 0),
  1 => apb_iobar(paddr, pmask));

type USB_ctrlr_Reg is record
     USB_RWselect : std_logic;
end record;

signal Rec : USB_ctrlr_Reg;
signal Rdata : std_logic_vector(31 downto 0);

begin


    BUF0 : RWbuf
        generic map(DataMax)
        port map(clk,rst,flagC,flagB,Rec.USB_RWselect,ifclk,sloe,slrd,slwr,pktend,fifoadr,fdbusrw);


    process(rst,clk)
    begin
        if(rst='0')then
            Rec.USB_RWselect <= '0';

        elsif(clk'event and clk='1')then

    --APB Write OP
            if (apbi.psel(pindex) and apbi.penable and apbi.pwrite) = '1' then
                case apbi.paddr(abits-1 downto 2) is
                    when "000000" =>                         
                         Rec.USB_RWselect <= apbi.pwdata(0);
                    when others =>
                        null;
                end case;
            end if;

    --APB READ OP
            if (apbi.psel(pindex) and (not apbi.pwrite)) = '1' then
                case apbi.paddr(abits-1 downto 2) is
                    when "000000" =>
                         Rdata(31 downto 1) <= (others => '0');
                         Rdata(0) <= Rec.USB_RWselect;
                    when others =>
                        Rdata <= (others => '0');
                end case;
            end if;

        end if;
        apbo.pconfig <= pconfig;
    end process;

apbo.prdata     <=   Rdata when apbi.penable = '1';

end architecture;