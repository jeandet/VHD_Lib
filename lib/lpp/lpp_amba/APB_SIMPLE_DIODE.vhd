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
-- APB_SIMPLE_DIODE.vhd

library ieee;
use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;
library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;
library lpp;
use lpp.lpp_amba.all;


entity APB_SIMPLE_DIODE is
  generic (
    pindex   : integer := 0;
    paddr    : integer := 0;
    pmask    : integer := 16#fff#;
    pirq     : integer := 0;
    abits    : integer := 8);
  port (
    rst    : in  std_ulogic;
    clk    : in  std_ulogic;
    apbi   : in  apb_slv_in_type;
    apbo   : out apb_slv_out_type;
    LED    : out std_ulogic
    );
end;


architecture AR_APB_SIMPLE_DIODE of APB_SIMPLE_DIODE is 

constant REVISION : integer := 1;

constant pconfig : apb_config_type := (
  0 => ahb_device_reg (VENDOR_LPP, LPP_SIMPLE_DIODE, 0, REVISION, 0),
  1 => apb_iobar(paddr, pmask));



type LEDregs is record
  DATAin    :   std_logic_vector(31 downto 0);
  DATAout   :   std_logic_vector(31 downto 0);
end record;

signal r : LEDregs;
signal Rdata     : std_logic_vector(31 downto 0);


begin

r.DATAout   <=  r.DATAin xor X"FFFFFFFF";

process(rst,clk)
begin
    if rst = '0' then
        LED <=  '0';
        r.DATAin <= (others => '0');
    elsif clk'event and clk = '1' then

            LED <= r.DATAin(0);

--APB Write OP
        if (apbi.psel(pindex) and apbi.penable and apbi.pwrite) = '1' then
            case apbi.paddr(abits-1 downto 2) is
                when "000000" =>
                    r.DATAin <= apbi.pwdata;
                when others =>
                    null;
            end case;
        end if;

--APB READ OP
        if (apbi.psel(pindex) and apbi.penable and (not apbi.pwrite)) = '1' then
            case apbi.paddr(abits-1 downto 2) is
                when "000000" =>
                    Rdata <= r.DATAin;
                when others =>
                    Rdata <= r.DATAout;
            end case;
        end if;
    
    end if;
    apbo.pconfig <= pconfig;
end process;

apbo.prdata     <=   Rdata when apbi.penable = '1';

-- pragma translate_off
--    bootmsg : report_version
--    generic map ("apbuart" & tost(pindex) &
--	": Generic UART rev " & tost(REVISION) & ", fifo " & tost(fifosize) &
--	", irq " & tost(pirq));
-- pragma translate_on



end ar_APB_SIMPLE_DIODE;













