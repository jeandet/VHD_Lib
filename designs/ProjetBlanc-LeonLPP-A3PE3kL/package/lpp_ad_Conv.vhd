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
use IEEE.STD_LOGIC_1164.all;
library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;


package lpp_ad_conv is


  constant    AD7688    : integer := 0;
  constant    ADS7886   : integer := 1;

  
  type AD7688_out is
    record
        CNV        : std_logic;
        SCK        : std_logic;
    end record;
	 
  type AD7688_in_element is
    record
        SDI        : std_logic;
    end record;
	 
	 type AD7688_in is array(natural range <>) of AD7688_in_element;

	type Samples_out is array(natural range <>) of std_logic_vector(15 downto 0);

	component  AD7688_drvr is
		    generic(ChanelCount	:	integer; 
				clkkHz		:	integer);
		 Port ( clk 	: in  STD_LOGIC;
                                rstn        :      in  STD_LOGIC;
                                enable      :      in  std_logic;
				  smplClk: in	STD_LOGIC;
				  DataReady : out std_logic;
				  smpout : out Samples_out(ChanelCount-1 downto 0);	
				  AD_in	: in	AD7688_in(ChanelCount-1 downto 0);	
				  AD_out : out AD7688_out);
	end component;


component AD7688_spi_if is
	 generic(ChanelCount	:	integer);
    Port(    clk      : in  STD_LOGIC;
             reset    : in  STD_LOGIC;
             cnv      : in  STD_LOGIC;
	     DataReady:	out std_logic;
             sdi      : in	AD7688_in(ChanelCount-1 downto 0);
             smpout   :  out Samples_out(ChanelCount-1 downto 0)
     );
end component;


component lpp_apb_ad_conv
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
end component;

component ADS7886_drvr is
    generic(ChanelCount :      integer; 
            clkkHz      :      integer);
    Port ( 
            clk         :      in  STD_LOGIC;
             reset 	: in  STD_LOGIC;
            smplClk     :      in  STD_LOGIC;
            DataReady   :      out std_logic;
            smpout      :      out Samples_out(ChanelCount-1 downto 0);	
            AD_in       :      in  AD7688_in(ChanelCount-1 downto 0);	
            AD_out      :      out AD7688_out
           );
end component;

component WriteGen_ADC is
    port(
        clk         : in std_logic;
        rstn        : in std_logic;
        SmplCLK     : in std_logic;
        DataReady   : in std_logic;
        Full        : in std_logic_vector(4 downto 0);
        ReUse       : out std_logic_vector(4 downto 0);
        Write       : out std_logic_vector(4 downto 0)
    );
end component;

end lpp_ad_conv;


