------------------------------------------------------------------------------
--  This file is a part of the LPP VHDL IP LIBRARY
--  Copyright (C) 2009 - 2018, Laboratory of Plasmas Physic - CNRS
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
--                    Author : Alexis Jeandet
--                     Mail : alexis.jeandet@member.fsf.org
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;
library grlib;
use grlib.amba.all;
library LPP;
USE lpp.apb_devices_list.ALL;

entity ADC_DMA_APBREGS is
GENERIC (
    pindex   : INTEGER := 6;
    paddr    : INTEGER := 6;
    pmask    : INTEGER := 16#fff#;
    pirq     : INTEGER := 0;
    vendorid : INTEGER := 100;
    deviceid : INTEGER := 10;
    version  : INTEGER := 0
    );
  PORT (
    clk  : IN STD_LOGIC;
    rstn : IN STD_LOGIC;

    -- AMBA APB Slave Interface
    apbi : IN  apb_slv_in_type;
    apbo : OUT apb_slv_out_type;

    DMA_start   : out std_logic;
    DMA_Address : out std_logic_vector(31 downto 0);
    DMA_Size    : out std_logic_vector(31 downto 0);

    DMA_done    : in  std_logic
    );
end entity;

architecture behave of ADC_DMA_APBREGS is

constant pconfig : apb_config_type := (
    0 => ahb_device_reg (lpp.apb_devices_list.VENDOR_LPP, 32, 0, 1, 0),
    1 => apb_iobar(paddr, pmask));

type ADC_DMA_reg is record
     Ctrl  : std_logic_vector(31 downto 0);
     Address : std_logic_vector(31 downto 0);
     Size : std_logic_vector(31 downto 0);
end record;

    signal Rec : ADC_DMA_reg;
    signal PRdata :  STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');

begin

    DMA_start   <= Rec.CTRL(0);
    DMA_Address <= Rec.address;
    DMA_Size    <= Rec.size;
    Rec.CTRL(1) <= DMA_done;

    process(rstn,clk)
    begin
        if(rstn = '0')then
            Rec.CTRL <= (others => '0');
        elsif(clk'event and clk='1')then
		        if Rec.CTRL(0) = '1' then
			        Rec.CTRL(0) <= '0';
		        end if;
    --APB Write OP
            if (apbi.psel(pindex) and apbi.penable and apbi.pwrite) = '1' then
                case apbi.paddr(7 downto 2) is
                    when "000000" =>
                        Rec.CTRL(0) <= apbi.pwdata(0);
                    when "000001" =>
                        Rec.Address <= apbi.pwdata;
                    when "000010" =>
                        Rec.Size <= apbi.pwdata;
                    when others =>
                        null;
                end case;
            end if;
    --APB READ OP
            if (apbi.psel(pindex) and (not apbi.pwrite)) = '1' then
                case apbi.paddr(7 downto 2) is
                    when "000000" =>
                        PRdata <= Rec.CTRL;
                    when "000001" =>
                        PRdata <= Rec.Address;
                    when "000010" =>
                        PRdata <= Rec.Size;
                    when others =>
                        PRdata <= (others => '0');
                end case;
            end if;
        end if;
end process;

apbo.pconfig    <= pconfig;
apbo.pindex     <= pindex;
apbo.prdata     <= PRdata when apbi.penable = '1';

end architecture;