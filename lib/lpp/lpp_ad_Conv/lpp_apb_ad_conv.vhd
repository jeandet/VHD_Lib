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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;
library lpp;
use lpp.lpp_ad_conv.all;
use lpp.lpp_amba.all;
use lpp.general_purpose.Clk_divider;

entity lpp_apb_ad_conv is
    generic(
          pindex      : integer := 0;
          paddr       : integer := 0;
          pmask       : integer := 16#fff#;
          pirq        : integer := 0;
          abits       : integer := 8;
          ChanelCount : integer := 1; 
          clkkHz      : integer := 50000;
	  smpClkHz    : integer := 100;
          ADCref      : integer := AD7688);
    Port ( 
          clk        : in   STD_LOGIC;
          reset      : in   STD_LOGIC;
          apbi       : in   apb_slv_in_type;
          apbo       : out  apb_slv_out_type;
          AD_in      : in   AD7688_in(ChanelCount-1 downto 0);	
          AD_out     : out  AD7688_out);
end lpp_apb_ad_conv;


architecture ar_lpp_apb_ad_conv of lpp_apb_ad_conv is
constant REVISION : integer := 1;

constant pconfig : apb_config_type := (
  0 => ahb_device_reg (VENDOR_LPP, LPP_ADC_7688, 0, REVISION, 0),
  1 => apb_iobar(paddr, pmask));

signal Rdata	  :  std_logic_vector(31 downto 0);
signal smpout    :  Samples_out(ChanelCount-1 downto 0);
signal smplClk   :  STD_LOGIC;	
signal DataReady :  STD_LOGIC;	

type lpp_apb_ad_conv_Reg is record
  CTRL_Reg     :   std_logic_vector(31 downto 0);
  sample       :   Samples_out(ChanelCount-1 downto 0);
end record;

signal r         :  lpp_apb_ad_conv_Reg;

begin


caseAD7688: if ADCref = AD7688 generate
AD7688: AD7688_drvr
    generic map(ChanelCount,clkkHz)
    Port map(clk,reset,smplClk,DataReady,smpout,AD_in,AD_out);
end generate;

caseADS786: if ADCref = ADS7886 generate
ADS7886: ADS7886_drvr
    generic map(ChanelCount,clkkHz)
    Port map(clk,reset,smplClk,DataReady,smpout,AD_in,AD_out);
end generate;


clkdivider: Clk_divider
		 generic map(clkkHz*1000,smpClkHz)
		 Port map( clk ,reset,smplClk);



r.CTRL_Reg(0)	<=	DataReady;

r.sample    <=    smpout;


process(reset,clk)
begin
  if reset = '0' then
        --r.CTRL_Reg(9 downto 0) <= (others => '0');
    elsif clk'event and clk = '1' then

--APB Write OP
      if (apbi.psel(pindex) and apbi.penable and apbi.pwrite) = '1' then
          case apbi.paddr(7 downto 2) is
              when "000000" =>
                  --r.CTRL_Reg(9 downto 0)    <=    apbi.pwdata(9 downto 0);
              when others =>
          end case;
      end if;

--APB READ OP
      if (apbi.psel(pindex) and (not apbi.pwrite)) = '1' then
          case apbi.paddr(7 downto 2) is
              when "000000" =>
                  Rdata <= r.CTRL_Reg;
              when others =>
                  readC:   for i in 1 to ChanelCount loop
                      if TO_INTEGER(unsigned(apbi.paddr(abits-1 downto 2))) =i then
                          Rdata(15 downto 0)    <=    r.sample(i-1)(15 downto 0);
                      end if;
                  end loop;
          end case;
      end if;  
  end if;
  apbo.pconfig <= pconfig;
end process;

apbo.prdata <=	Rdata when apbi.penable = '1' ;


end ar_lpp_apb_ad_conv;









