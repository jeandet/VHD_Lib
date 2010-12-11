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

entity AD7688_spi_if is
	 generic(ChanelCount	:	integer);
    Port(    clk      : in  STD_LOGIC;
             reset    : in  STD_LOGIC;
             cnv      : in  STD_LOGIC;
				 DataReady:	out std_logic;
             sdi      : in	AD7688_in(ChanelCount-1 downto 0);
             smpout   :  out Samples_out(ChanelCount-1 downto 0)
     );
end AD7688_spi_if;

architecture ar_AD7688_spi_if of AD7688_spi_if is

signal	shift_reg	:	Samples_out(ChanelCount-1 downto 0);
signal	i	:	integer range 0 to 15 :=0;
signal	cnv_reg	:	std_logic := '0';

begin



process(clk,reset)
begin
	if reset = '0' then
		for l in 0 to ChanelCount-1 loop
					shift_reg(l)	<=	(others => '0');
		end loop;
		i				<=	0;
		cnv_reg		<=	'0';
	elsif clk'event and clk = '1' then
		if cnv = '0' and cnv_reg = '0' then
			if i = 15 then
				i				<=	0;
				cnv_reg		<=	'1';
			else
				DataReady	<=	'0';
				i				<=	i+1;
				for l in 0 to ChanelCount-1 loop
					shift_reg(l)(0)					<=	sdi(l).SDI;
					shift_reg(l)(15 downto 1)	<=	shift_reg(l)(14 downto 0);
				end loop;
			end if;
		else 
			cnv_reg		<=	not cnv;
			smpout		<=	shift_reg;
			DataReady	<=	'1';
		end if;
	end if;
end process;

end ar_AD7688_spi_if;
