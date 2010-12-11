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
--                    Author : Alexis Jeandet
--                     Mail : alexis.jeandet@lpp.polytechnique.fr
----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library lpp;
use lpp.lpp_ad_conv.all;
use lpp.general_purpose.Clk_divider;

entity ADS7886_drvr is
    generic(ChanelCount	:	integer; 
				clkkHz		:	integer);
		 Port ( clk 	: in  STD_LOGIC;
				  reset 	: in  STD_LOGIC;
				  smplClk: in	STD_LOGIC;
				  DataReady : out std_logic;
				  smpout : out Samples_out(ChanelCount-1 downto 0);	
				  AD_in	: in	AD7688_in(ChanelCount-1 downto 0);	
				  AD_out : out AD7688_out);
end ADS7886_drvr;

architecture ar_ADS7886_drvr of ADS7886_drvr is

constant		convTrigger	:	integer:=  clkkHz*1/1000;  --tconv = 1.6µs

signal i		:       integer range 0 to convTrigger :=0;
signal clk_int		:       std_logic;
signal smplClk_reg	:       std_logic;
signal cnv_int		:       std_logic;
signal smpout_int       :       Samples_out(ChanelCount-1 downto 0);


begin


clkdiv: if clkkHz>=20000 generate 
	clkdivider: Clk_divider
       generic map(clkkHz*1000,19000000)
		 Port map( clk ,reset,clk_int);
end generate;
		

clknodiv: if clkkHz<20000 generate 
nodiv:		 clk_int <=	clk;
end generate;

AD_out.CNV	<=	cnv_int;	
AD_out.SCK	<=	clk_int;


sckgen: process(clk,reset)
begin
	if reset = '0' then
		i <= 0;
		cnv_int		<=	'0';
		smplClk_reg	<=	'0';
	elsif clk'event and clk = '1' then
		if smplClk = '1' and smplClk_reg = '0' then
			if i = convTrigger then
				smplClk_reg	<=	'1';
				i	<=	0;
				cnv_int	<=	'0';
			else
				i	<=	i+1;
				cnv_int	<=	'1';
			end if;
		elsif smplClk = '0' and smplClk_reg = '1' then
			smplClk_reg	<=	'0';
		end if;
	end if;
end process;


NDMSK: for i in 0 to ChanelCount-1
generate
	smpout(i)     <=    smpout_int(i) and X"0FFF";
end generate;


spidrvr: AD7688_spi_if 
   generic map(ChanelCount)
   Port map(clk_int,reset,cnv_int,DataReady,AD_in,smpout_int);



end ar_ADS7886_drvr;

