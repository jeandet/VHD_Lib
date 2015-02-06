------------------------------------------------------------------------------
--  This file is a part of the LPP VHDL IP LIBRARY
--  Copyright (C) 2009 - 2015, Laboratory of Plasmas Physic - CNRS
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
LIBRARY techmap;
USE techmap.gencomp.ALL;

library lpp;
use lpp.lpp_cna.all;


entity lfr_cal_driver is
    generic(
        tech   :  integer := 0;
        PRESZ  :  integer range 1 to 32:=4;
        PREMAX :  integer := 16#FFFFFF#;
        CPTSZ  :  integer range 1 to 32:=16;
        datawidth     : integer := 18;
        abits         : integer := 8
     );
    Port ( 
        clk             : in  STD_LOGIC;
        rstn            : in  STD_LOGIC;
        pre             : in  STD_LOGIC_VECTOR(PRESZ-1 downto 0);
        N               : in  STD_LOGIC_VECTOR(CPTSZ-1 downto 0);
        Reload          : in  std_logic;
        DATA_IN         : in  STD_LOGIC_VECTOR(datawidth-1 downto 0);
        WEN             : in  STD_LOGIC;
        LOAD_ADDRESSN   : IN  STD_LOGIC;
        ADDRESS_IN      : IN  STD_LOGIC_VECTOR(abits-1 downto 0);
        ADDRESS_OUT     : OUT STD_LOGIC_VECTOR(abits-1 downto 0);
        INTERLEAVED     : IN  STD_LOGIC;
        DAC_CFG         : IN  STD_LOGIC_VECTOR(3 downto 0);
        SYNC            : out STD_LOGIC;
        DOUT            : out STD_LOGIC;
        SCLK            : out STD_LOGIC;
        SMPCLK          : out STD_lOGIC
              );
end lfr_cal_driver;

architecture Behavioral of lfr_cal_driver is
constant dacresolution   : integer := 12;
signal  RAM_DATA_IN      :  STD_LOGIC_VECTOR(datawidth-1 downto 0);
signal  RAM_WEN          :  STD_LOGIC;
signal  RAM_WADDR        :  STD_LOGIC_VECTOR(abits-1 downto 0);
signal  RAM_DATA_OUT     :  STD_LOGIC_VECTOR(datawidth-1 downto 0);
signal  RAM_RADDR        :  STD_LOGIC_VECTOR(abits-1 downto 0);
signal  RAM_REN          :  STD_LOGIC;
signal  DAC_DATA         :  STD_LOGIC_VECTOR(dacresolution-1 downto 0);
signal  SMP_CLK          :  STD_LOGIC;
signal  DAC_INPUT        :  STD_LOGIC_VECTOR(15 downto 0);

begin

ADDRESS_OUT <= RAM_WADDR;
DAC_INPUT   <= DAC_CFG &  DAC_DATA;
SMPCLK      <= SMP_CLK;

dac_drv: SPI_DAC_DRIVER
    Generic map(
        datawidth     => 16,
        MSBFIRST      => 1
    )
    Port map(
        clk        => clk,
        rstn       => rstn,
        DATA       =>  DAC_INPUT,
        SMP_CLK    => SMP_CLK,
        SYNC       => SYNC,
        DOUT       => DOUT,
        SCLK       => SCLK
         );

freqGen: dynamic_freq_div 
    generic map(
        PRESZ  => PRESZ,
        PREMAX => PREMAX,
        CPTSZ     => CPTSZ
     )
    Port map( clk => clk,
           rstn => rstn,
           pre => pre,
           N => N,
           Reload => Reload,
           clk_out => SMP_CLK
           );
           
         
ramWr: RAM_WRITER
    Generic map(
        datawidth     => datawidth,
        abits         => abits
    )
    Port map( 
        clk            => clk,
        rstn           => rstn,
        DATA_IN        => DATA_IN,
        DATA_OUT       => RAM_DATA_IN,
        WEN_IN         => WEN,
        WEN_OUT        => RAM_WEN,
        LOAD_ADDRESSN  => LOAD_ADDRESSN,
        ADDRESS_IN     => ADDRESS_IN,
        ADDRESS_OUT    => RAM_WADDR
   );
   
ramRd: RAM_READER 
    Generic map(
        datawidth     => datawidth,
        dacresolution => dacresolution,
        abits         => abits
    )
    Port map( 
        clk         => clk,
        rstn        => rstn,
        DATA_IN     => RAM_DATA_OUT,
        ADDRESS     => RAM_RADDR,
        REN         => RAM_REN,
        DATA_OUT    => DAC_DATA,
        SMP_CLK     => SMP_CLK,
        INTERLEAVED => INTERLEAVED
              );

SRAM : syncram_2p
      GENERIC MAP(tech, abits, datawidth)
      PORT MAP(clk, RAM_REN, RAM_RADDR, RAM_DATA_OUT, clk, RAM_WEN, RAM_WADDR, RAM_DATA_IN);

end Behavioral;
