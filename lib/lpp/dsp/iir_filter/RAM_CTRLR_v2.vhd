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
LIBRARY IEEE;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_1164.ALL;
LIBRARY lpp;
USE lpp.iir_filter.ALL;
USE lpp.FILTERcfg.ALL;
USE lpp.general_purpose.ALL;
LIBRARY techmap;
USE techmap.gencomp.ALL;

ENTITY RAM_CTRLR_v2 IS
  GENERIC(
    tech       : INTEGER := 0;
    Input_SZ_1 : INTEGER := 16;
    Mem_use    : INTEGER := use_RAM
    );
  PORT(
    rstn : IN STD_LOGIC;
    clk  : IN STD_LOGIC;
    -- R/W Ctrl
    ram_write : IN STD_LOGIC;
    ram_read  : IN STD_LOGIC;
    -- ADDR Ctrl
    raddr_rst  : IN STD_LOGIC;
    raddr_add1 : IN STD_LOGIC;
    waddr_previous : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    -- Data
    sample_in  : IN  STD_LOGIC_VECTOR(Input_SZ_1-1 DOWNTO 0);
    sample_out : OUT STD_LOGIC_VECTOR(Input_SZ_1-1 DOWNTO 0)
    );
END RAM_CTRLR_v2;


ARCHITECTURE ar_RAM_CTRLR_v2 OF RAM_CTRLR_v2 IS

  SIGNAL WD       : STD_LOGIC_VECTOR(Input_SZ_1-1 DOWNTO 0);
  SIGNAL RD       : STD_LOGIC_VECTOR(Input_SZ_1-1 DOWNTO 0);
	SIGNAL WEN, REN : STD_LOGIC;
  SIGNAL RADDR    : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL WADDR    : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL counter  : STD_LOGIC_VECTOR(7 DOWNTO 0);
  
BEGIN

  sample_out                <= RD(Input_SZ_1-1 DOWNTO 0);
  WD(Input_SZ_1-1 DOWNTO 0) <= sample_in;
  -----------------------------------------------------------------------------
  -- RAM
  -----------------------------------------------------------------------------

  memCEL : IF Mem_use = use_CEL GENERATE
    WEN <= NOT ram_write;
    REN <= NOT ram_read;
--    RAMblk : RAM_CEL_N
--       GENERIC MAP(Input_SZ_1)
    RAMblk : RAM_CEL
      GENERIC MAP(Input_SZ_1, 8)
      PORT MAP(
        WD    => WD,
        RD    => RD,
        WEN   => WEN,
        REN   => REN,
        WADDR => WADDR,
        RADDR => RADDR,
        RWCLK => clk,
        RESET => rstn
        ) ;
  END GENERATE;

  memRAM : IF Mem_use = use_RAM GENERATE
    SRAM : syncram_2p
      GENERIC MAP(tech, 8, Input_SZ_1)
      PORT MAP(clk, ram_read, RADDR, RD, clk, ram_write, WADDR, WD);
  END GENERATE;

  -----------------------------------------------------------------------------
  -- RADDR
  -----------------------------------------------------------------------------
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      counter <= (OTHERS => '0');
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
      IF raddr_rst = '1' THEN
        counter <= (OTHERS => '0');
      ELSIF raddr_add1 = '1' THEN
        counter <= STD_LOGIC_VECTOR(UNSIGNED(counter)+1);
      END IF;
    END IF;
  END PROCESS;
  RADDR <= counter;

  -----------------------------------------------------------------------------
  -- WADDR
  -----------------------------------------------------------------------------
  WADDR <= STD_LOGIC_VECTOR(UNSIGNED(counter)-2) WHEN waddr_previous = "10" ELSE
           STD_LOGIC_VECTOR(UNSIGNED(counter)-1) WHEN waddr_previous = "01" ELSE
           STD_LOGIC_VECTOR(UNSIGNED(counter));
  
  
END ar_RAM_CTRLR_v2;
