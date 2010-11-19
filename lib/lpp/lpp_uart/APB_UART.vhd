------------------------------------------------------------------------------
--  This file is a part of the LPP VHDL IP LIBRARY
--  Copyright (C) 2009 - 2010, Laboratory of Plasmas Physic - CNRS
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
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
-- APB_UART.vhd

library ieee;
use ieee.std_logic_1164.all;
library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;
library lpp;
use lpp.lpp_amba.all;
use lpp.lpp_uart.all;

entity APB_UART is
  generic (
    pindex   : integer := 0;
    paddr    : integer := 0;
    pmask    : integer := 16#fff#;
    pirq     : integer := 0;
    abits    : integer := 8;
    Data_sz  : integer := 8);
  port (
    clk     : in  std_logic;
    rst     : in  std_logic;    
    apbi    : in  apb_slv_in_type;
    apbo    : out apb_slv_out_type;
    TXD    :   out std_logic;
    RXD    :   in  std_logic
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
     UART_Cfg  : std_logic_vector(4 downto 0);
     UART_Wdata : std_logic_vector(7 downto 0);
     UART_Rdata : std_logic_vector(7 downto 0);
     UART_BTrig : std_logic_vector(11 downto 0);
end record;

signal Rec : UART_ctrlr_Reg;

begin

Capture <= Rec.UART_Cfg(0);
ACK <= Rec.UART_Cfg(1);
Send <= Rec.UART_Cfg(2);
Rec.UART_Cfg(3) <= Sended;
Rec.UART_Cfg(4) <= NwData;


    COM0 : entity work.UART
        generic map (Data_sz)
        port map (clk,rst,TXD,RXD,Capture,NwData,ACK,Send,Sended,Rec.UART_BTrig,Rec.UART_Rdata,Rec.UART_Wdata);


    process(rst,clk)
    begin
        if(rst='0')then
            Rec.UART_Wdata <=  (others => '0');
            apbo.prdata <= (others => '0');

        elsif(clk'event and clk='1')then 
        

    --APB Write OP
            if (apbi.psel(pindex) and apbi.penable and apbi.pwrite) = '1' then
                case apbi.paddr(abits-1 downto 2) is
                    when "000000" =>
                        Rec.UART_Cfg(2 downto 0) <= apbi.pwdata(2 downto 0);
                    when "000001" =>
                        Rec.UART_Wdata <= apbi.pwdata(7 downto 0);
                    when others =>
                        null;
                end case;
            end if;

    --APB READ OP
            if (apbi.psel(pindex) and apbi.penable and (not apbi.pwrite)) = '1' then
                case apbi.paddr(abits-1 downto 2) is
                    when "000000" =>
                        apbo.prdata(31 downto 27) <= Rec.UART_Cfg;
                        apbo.prdata(26 downto 12) <= (others => '0');
                        apbo.prdata(11 downto 0) <= Rec.UART_BTrig;
                    when "000001" =>
                        apbo.prdata(7 downto 0) <= Rec.UART_Wdata;
                    when "000010" =>
                        apbo.prdata(7 downto 0) <= Rec.UART_Rdata;
                    when others =>
                        apbo.prdata <= (others => '0');
                end case;
            end if;

        end if;
        apbo.pconfig <= pconfig;
    end process;

end ar_APB_UART;