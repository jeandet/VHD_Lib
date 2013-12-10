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
use IEEE.numeric_std.all;
library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;
library lpp;
use lpp.lpp_amba.all;
use lpp.apb_devices_list.all;
use lpp.general_purpose.all;
use lpp.lpp_cna.all;

--! Driver APB, va faire le lien entre l'IP VHDL du convertisseur et le bus Amba

entity APB_DAC is
  generic (
    pindex   : integer := 0;
    paddr    : integer := 0;
    pmask    : integer := 16#fff#;
    pirq     : integer := 0;
    abits    : integer := 8;
    Nmax     : integer := 7;
    cpt_serial : integer := 6);
  port (
    clk     : in  std_logic;           --! Horloge du composant
    rst     : in  std_logic;           --! Reset general du composant
    apbi    : in  apb_slv_in_type;     --! Registre de gestion des entrées du bus
    apbo    : out apb_slv_out_type;    --! Registre de gestion des sorties du bus
    DataIN  : in std_logic_vector(15 downto 0);
    Cal_EN  : out std_logic;           --! Signal Enable du multiplex pour la CAL
    Readn   : out std_logic;
    SYNC    : out std_logic;           --! Signal de synchronisation du convertisseur
    SCLK    : out std_logic;           --! Horloge systeme du convertisseur
    CLK_VAR : out std_logic;
    DATA    : out std_logic            --! Donnée numérique sérialisé
    );
end entity;

--! @details Les deux registres (apbi,apbo) permettent de gérer la communication sur le bus
--! et les sorties seront cablées vers le convertisseur. 

architecture ar_APB_DAC of APB_DAC is

constant REVISION : integer := 1;

constant pconfig : apb_config_type := (
  0 => ahb_device_reg (VENDOR_LPP, LPP_CNA, 0, REVISION, 0),
  1 => apb_iobar(paddr, pmask));

signal clkdiv   : std_logic;
signal clkvar    : std_logic;
signal enable   : std_logic;
signal Ready    : std_logic;
signal N        : integer range 0 to Nmax;

type DAC_ctrlr_Reg is record
     DAC_Cfg  : std_logic_vector(0 downto 0);
     CLK_Cfg  : std_logic_vector(2 downto 0);
end record;

signal Rec : DAC_ctrlr_Reg;
signal Rdata     : std_logic_vector(31 downto 0);

begin

enable <= Rec.DAC_Cfg(0);

N <= to_integer(unsigned(Rec.CLK_Cfg));

    CLK0 : Clock_Divider
        generic map (308)        --clkdiv = 80KHz
        port map (clk,rst,clkdiv);

    CLKSET : ClkSetting
        generic map(Nmax)
        port map(clkdiv,rst,N,clkvar);

    CONV0 : DacDriver
--        generic map (cpt_serial)
        port map(clk,rst,clkvar,enable,DataIN,SYNC,SCLK,Readn,Data);

 CLK_VAR <=  clkvar;

    process(rst,clk)
    begin
        if(rst='0')then
            Rec.CLK_Cfg <=  (others => '0');

        elsif(clk'event and clk='1')then 
        

    --APB Write OP
            if (apbi.psel(pindex) and apbi.penable and apbi.pwrite) = '1' then
                case apbi.paddr(abits-1 downto 2) is
                    when "000000" =>
                        Rec.DAC_Cfg(0) <= apbi.pwdata(0);
                        Rec.CLK_Cfg    <= apbi.pwdata(6 downto 4);
                    when others =>
                        null;
                end case;
            end if;

    --APB Read OP
            if (apbi.psel(pindex) and (not apbi.pwrite)) = '1' then
                case apbi.paddr(abits-1 downto 2) is
                    when "000000" =>
                        Rdata(31 downto 7) <= (others => '0');
                        Rdata(6 downto 4)  <= Rec.CLK_Cfg;
                        Rdata(0 downto 0)  <= Rec.DAC_Cfg;
                    when others =>
                        Rdata <= (others => '0');
                end case;
            end if;

        end if;
        apbo.pconfig <= pconfig;
    end process;

apbo.prdata     <=   Rdata when apbi.penable = '1';
Cal_EN <= enable;
end architecture;