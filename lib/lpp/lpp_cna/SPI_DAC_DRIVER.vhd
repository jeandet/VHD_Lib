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
USE IEEE.NUMERIC_STD.ALL;

ENTITY SPI_DAC_DRIVER IS
  GENERIC(
    datawidth : INTEGER := 16;
    MSBFIRST  : INTEGER := 1
    );
  PORT (
    clk     : IN  STD_LOGIC;
    rstn    : IN  STD_LOGIC;
    DATA    : IN  STD_LOGIC_VECTOR(datawidth-1 DOWNTO 0);
    SMP_CLK : IN  STD_LOGIC;
    SYNC    : OUT STD_LOGIC;
    DOUT    : OUT STD_LOGIC;
    SCLK    : OUT STD_LOGIC
    );
END ENTITY SPI_DAC_DRIVER;

ARCHITECTURE behav OF SPI_DAC_DRIVER IS
  SIGNAL DATA_s               : STD_LOGIC_VECTOR(datawidth-1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL SMP_CLK_R            : STD_LOGIC                              := '0';
  SIGNAL SMP_CLK_RisingEdge   : STD_LOGIC                              := '0';
  SIGNAL SMP_CLK_RisingEdge_1 : STD_LOGIC                              := '0';
  SIGNAL SMP_CLK_RisingEdge_2 : STD_LOGIC                              := '0';

  SIGNAL SHIFTREG : STD_LOGIC_VECTOR(datawidth-1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL shiftcnt : INTEGER                                := 0;
  SIGNAL shifting : STD_LOGIC                              := '0';

  SIGNAL SCLK_s : STD_LOGIC;
BEGIN

  -----------------------------------------------------------------------------
  -- Data Re-Orderng
  -----------------------------------------------------------------------------

  MSB : IF MSBFIRST = 1 GENERATE
    DATA_s <= DATA;
  END GENERATE;

  LSB : IF MSBFIRST = 0 GENERATE
    DATA_s(datawidth-1 DOWNTO 0) <= DATA(0 TO datawidth-1);
  END GENERATE;

  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  PROCESS(clk, rstn)
  BEGIN
    IF rstn = '0' THEN
      SMP_CLK_R            <= '0';
      SMP_CLK_RisingEdge_2 <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      SMP_CLK_R            <= SMP_CLK;
      SMP_CLK_RisingEdge_2 <= SMP_CLK_RisingEdge_1;
    END IF;
  END PROCESS;

  SMP_CLK_RisingEdge_1 <= '1' WHEN SMP_CLK = '1' AND SMP_CLK_R = '0'                        ELSE '0';
  SMP_CLK_RisingEdge   <= '1' WHEN SMP_CLK_RisingEdge_1 = '1' OR SMP_CLK_RisingEdge_2 = '1' ELSE '0';


  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  SCLK <= SCLK_s;
  DOUT <= SHIFTREG(datawidth-1);

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      SCLK_s <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
      SCLK_s <= NOT SCLK_s;
    END IF;
  END PROCESS;

  PROCESS(clk, rstn)
  BEGIN
    IF rstn = '0' THEN
      shifting <= '0';
      SHIFTREG <= (OTHERS => '0');
      SYNC     <= '0';
      shiftcnt <= 0;
    ELSIF clk'EVENT AND clk = '1' THEN

      IF SCLK_s = '0' THEN
        
        IF SMP_CLK_RisingEdge = '1' THEN
          SYNC     <= '1';
          shifting <= '1';
        ELSE
          SYNC <= '0';
          IF shiftcnt = datawidth-1 THEN
            shifting <= '0';
          END IF;
        END IF;

        IF shifting = '1' THEN
          shiftcnt <= shiftcnt + 1;
          SHIFTREG(datawidth-1 DOWNTO 1) <= SHIFTREG (datawidth-2 DOWNTO 0);
        ELSE
          SHIFTREG <= DATA_s;
          shiftcnt <= 0;
        END IF;        
        
      END IF;
    END IF;
  END PROCESS;

END ARCHITECTURE behav;
