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
--                    Author : Martin Morlot
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
use lpp.lpp_uart.all;

--! Driver APB, va faire le lien entre l'IP VHDL de l'UART et le bus Amba

entity APB_UART is
  generic (
    pindex   : integer := 0;
    paddr    : integer := 0;
    pmask    : integer := 16#fff#;
    pirq     : integer := 0;
    abits    : integer := 8;
    Data_sz  : integer := 8);
  port (
    clk     : in  std_logic;            --! Horloge du composant
    rst     : in  std_logic;            --! Reset general du composant
    apbi    : in  apb_slv_in_type;      --! Registre de gestion des entrées du bus
    apbo    : out apb_slv_out_type;     --! Registre de gestion des sorties du bus
    TXD    :   out std_logic;           --! Transmission série, côté composant
    RXD    :   in  std_logic            --! Reception série, côté composant
    );
end APB_UART;


architecture ar_APB_UART of APB_UART is

constant REVISION : integer := 1;

constant pconfig : apb_config_type := (
  0 => ahb_device_reg (VENDOR_LPP, LPP_UART, 0, REVISION, 0),
  1 => apb_iobar(paddr, pmask));

signal NwData   : std_logic;
signal ACK      : std_logic;
signal Capture  : std_logic;
signal Send     : std_logic;
signal Sended   : std_logic;

type UART_ctrlr_Reg is record
     UART_Cfg  : std_logic_vector(2 downto 0);
     UART_Wdata : std_logic_vector(7 downto 0);
     UART_Rdata : std_logic_vector(7 downto 0);
     UART_BTrig : std_logic_vector(11 downto 0);
end record;

signal Rec : UART_ctrlr_Reg;
signal Rdata     : std_logic_vector(31 downto 0);
signal temp_ND : std_logic;

begin

Capture <= Rec.UART_Cfg(0);
--ACK <= Rec.UART_Cfg(1);
--Send <= Rec.UART_Cfg(1);
Rec.UART_Cfg(1) <= Sended;
Rec.UART_Cfg(2) <= NwData;


    COM0 : entity work.UART
        generic map (Data_sz)
        port map (clk,rst,TXD,RXD,Capture,NwData,ACK,Send,Sended,Rec.UART_BTrig,Rec.UART_Rdata,Rec.UART_Wdata);


    process(rst,clk)
    begin
        if(rst='0')then
            Rec.UART_Wdata <=  (others => '0');
            

        elsif(clk'event and clk='1')then
           temp_ND <= NwData;
            if(NwData='1' and temp_ND='1')then
                ACK <= '1';
            else
                ACK <= '0';
            end if;

    --APB Write OP
            if (apbi.psel(pindex) and apbi.penable and apbi.pwrite) = '1' then
                case apbi.paddr(7 downto 2) is
                    when "000000" =>
                        Rec.UART_Cfg(0) <= apbi.pwdata(0);
                        --Rec.UART_Cfg(1) <= apbi.pwdata(4);
                    when "000001" =>
                        Rec.UART_Wdata(7 downto 0) <= apbi.pwdata(7 downto 0);
			Send <=	'1';
                    when others =>
                        null;
                end case;
	    else
	        Send <=	'0';
            end if;

    --APB READ OP
            if (apbi.psel(pindex) and (not apbi.pwrite)) = '1' then
                case apbi.paddr(7 downto 2) is
                    when "000000" =>
                        Rdata(3 downto 0) <= "000" & Rec.UART_Cfg(0);
                        Rdata(7 downto 4) <= "000" & Rec.UART_Cfg(1);
                        Rdata(11 downto 8) <= "000" & Rec.UART_Cfg(2);
                        Rdata(19 downto 12) <= X"EE";
                        Rdata(31 downto 20) <= Rec.UART_BTrig;
                    when "000001" =>
                        Rdata(31 downto 8) <= X"EEEEEE";     
                        Rdata(7 downto 0) <= Rec.UART_Wdata;
                    when "000010" =>
                        Rdata(31 downto 8) <= X"EEEEEE";
                        Rdata(7 downto 0) <= Rec.UART_Rdata;
								--Ack               <= '1';
                    when others =>
                        Rdata <= (others => '0');
                end case;
				--else
				    --Ack               <= '0';
            end if;

        end if;
        apbo.pconfig <= pconfig;
    end process;

    apbo.prdata     <=   Rdata when apbi.penable = '1';

end ar_APB_UART;
