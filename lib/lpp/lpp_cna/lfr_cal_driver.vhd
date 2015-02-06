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
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
LIBRARY techmap;
USE techmap.gencomp.ALL;

LIBRARY lpp;
USE lpp.lpp_cna.ALL;


ENTITY lfr_cal_driver IS
  GENERIC(
    tech      : INTEGER               := 0;
    PRESZ     : INTEGER RANGE 1 TO 32 := 4;
    PREMAX    : INTEGER               := 16#FFFFFF#;
    CPTSZ     : INTEGER RANGE 1 TO 32 := 16;
    datawidth : INTEGER               := 18;
    abits     : INTEGER               := 8
    );
  PORT (
    clk           : IN  STD_LOGIC;
    rstn          : IN  STD_LOGIC;
    pre           : IN  STD_LOGIC_VECTOR(PRESZ-1 DOWNTO 0);
    N             : IN  STD_LOGIC_VECTOR(CPTSZ-1 DOWNTO 0);
    Reload        : IN  STD_LOGIC;
    DATA_IN       : IN  STD_LOGIC_VECTOR(datawidth-1 DOWNTO 0);
    WEN           : IN  STD_LOGIC;
    LOAD_ADDRESSN : IN  STD_LOGIC;
    ADDRESS_IN    : IN  STD_LOGIC_VECTOR(abits-1 DOWNTO 0);
    ADDRESS_OUT   : OUT STD_LOGIC_VECTOR(abits-1 DOWNTO 0);
    INTERLEAVED   : IN  STD_LOGIC;
    DAC_CFG       : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    SYNC          : OUT STD_LOGIC;
    DOUT          : OUT STD_LOGIC;
    SCLK          : OUT STD_LOGIC;
    SMPCLK        : OUT STD_LOGIC
    );
END lfr_cal_driver;

ARCHITECTURE Behavioral OF lfr_cal_driver IS
  CONSTANT dacresolution : INTEGER := 12;
  SIGNAL   RAM_DATA_IN   : STD_LOGIC_VECTOR(datawidth-1 DOWNTO 0);
  SIGNAL   RAM_WEN       : STD_LOGIC;
  SIGNAL   RAM_WADDR     : STD_LOGIC_VECTOR(abits-1 DOWNTO 0);
  SIGNAL   RAM_DATA_OUT  : STD_LOGIC_VECTOR(datawidth-1 DOWNTO 0);
  SIGNAL   RAM_RADDR     : STD_LOGIC_VECTOR(abits-1 DOWNTO 0);
  SIGNAL   RAM_REN       : STD_LOGIC;
  SIGNAL   DAC_DATA      : STD_LOGIC_VECTOR(dacresolution-1 DOWNTO 0);
  SIGNAL   SMP_CLK       : STD_LOGIC;
  SIGNAL   DAC_INPUT     : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN

  ADDRESS_OUT <= RAM_WADDR;
  DAC_INPUT   <= DAC_CFG & DAC_DATA;
  SMPCLK      <= SMP_CLK;

  dac_drv : SPI_DAC_DRIVER
    GENERIC MAP(
      datawidth => 16,
      MSBFIRST  => 1
      )
    PORT MAP(
      clk     => clk,
      rstn    => rstn,
      DATA    => DAC_INPUT,
      SMP_CLK => SMP_CLK,
      SYNC    => SYNC,
      DOUT    => DOUT,
      SCLK    => SCLK
      );

  freqGen : dynamic_freq_div
    GENERIC MAP(
      PRESZ  => PRESZ,
      PREMAX => PREMAX,
      CPTSZ  => CPTSZ
      )
    PORT MAP(clk      => clk,
              rstn    => rstn,
              pre     => pre,
              N       => N,
              Reload  => Reload,
              clk_out => SMP_CLK
              );


  ramWr : RAM_WRITER
    GENERIC MAP(
      datawidth => datawidth,
      abits     => abits
      )
    PORT MAP(
      clk           => clk,
      rstn          => rstn,
      DATA_IN       => DATA_IN,
      DATA_OUT      => RAM_DATA_IN,
      WEN_IN        => WEN,
      WEN_OUT       => RAM_WEN,
      LOAD_ADDRESSN => LOAD_ADDRESSN,
      ADDRESS_IN    => ADDRESS_IN,
      ADDRESS_OUT   => RAM_WADDR
      );

  ramRd : RAM_READER
    GENERIC MAP(
      datawidth     => datawidth,
      dacresolution => dacresolution,
      abits         => abits
      )
    PORT MAP(
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

END Behavioral;