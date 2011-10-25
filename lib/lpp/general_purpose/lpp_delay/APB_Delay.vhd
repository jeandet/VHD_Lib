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
use lpp.lpp_delay.all;

--! Driver APB, va faire le lien entre l'IP VHDL du convertisseur et le bus Amba

entity APB_Delay is
  generic (
    pindex   : integer := 0;
    paddr    : integer := 0;
    pmask    : integer := 16#fff#;
    pirq     : integer := 0;
    abits    : integer := 8);
  port (
    clk     : in  std_logic;           --! Horloge du composant
    rst     : in  std_logic;           --! Reset general du composant
    apbi    : in  apb_slv_in_type;     --! Registre de gestion des entrées du bus
    apbo    : out apb_slv_out_type     --! Registre de gestion des sorties du bus
);
end APB_Delay;


architecture ar_APB_Delay of APB_Delay is

constant REVISION : integer := 1;

constant pconfig : apb_config_type := (
  0 => ahb_device_reg (VENDOR_LPP, LPP_DELAY, 0, REVISION, 0),
  1 => apb_iobar(paddr, pmask));

type DELAY_ctrlr_Reg is record
    Delay_CFG : std_logic_vector(2 downto 0);
    Delay_FreqBoard : std_logic_vector(25 downto 0);
    Delay_Timer : std_logic_vector(25 downto 0);
end record;

signal Rec : DELAY_ctrlr_Reg;
signal Rdata : std_logic_vector(31 downto 0);

signal Flag_st : std_logic;
signal Flag_end : std_logic;
signal Rz : std_logic;
signal Raz : std_logic;

begin

Flag_st <= Rec.Delay_CFG(1);
Rec.Delay_CFG(2) <= Flag_end;
Rz <= Rec.Delay_CFG(0);

Raz <= rst and Rz;

Delay0 : TimerDelay
    port map(clk,Raz,Flag_st,Flag_end,Rec.Delay_Timer);

    process(rst,clk)
    begin
        if(rst='0')then
            Rec.Delay_FreqBoard <= (others => '0');
            Rec.Delay_Timer <= (others => '0');
            
        elsif(clk'event and clk='1')then 

    --APB Write OP
            if (apbi.psel(pindex) and apbi.penable and apbi.pwrite) = '1' then
                case apbi.paddr(abits-1 downto 2) is
                    when "000000" =>
                        Rec.Delay_CFG(0) <= apbi.pwdata(0); 
                        Rec.Delay_CFG(1) <= apbi.pwdata(4);
                    when "000001" =>                             
                        Rec.Delay_FreqBoard <= apbi.pwdata(25 downto 0); 
                    when "000010" =>                             
                        Rec.Delay_Timer <= apbi.pwdata(25 downto 0);                      
                    when others =>
                        null;
                end case;
            end if;

    --APB READ OP
            if (apbi.psel(pindex) and (not apbi.pwrite)) = '1' then
                case apbi.paddr(abits-1 downto 2) is
                    when "000000" =>
                        Rdata(31 downto 12) <= (others => '0');
                        Rdata(11 downto 8) <= "000" & Rec.Delay_CFG(2);
                        Rdata(7 downto 4) <= "000" & Rec.Delay_CFG(1);
                        Rdata(3 downto 0) <= "000" & Rec.Delay_CFG(0);
                    when "000001" =>
                         Rdata(31 downto 26) <= X"0" & "00";
                         Rdata(25 downto 0) <= Rec.Delay_FreqBoard;
                    when "000010" =>
                         Rdata(31 downto 26) <= X"0" & "00";
                         Rdata(25 downto 0) <= Rec.Delay_Timer;
                    when others =>
                        Rdata <= (others => '0');
                end case;
            end if;

        end if;
        apbo.pconfig <= pconfig;
    end process;

apbo.prdata     <=   Rdata when apbi.penable = '1';

end ar_APB_Delay;