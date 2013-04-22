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

--TODO amliorer la flexibilit de la config de la RAM.

ENTITY RAM_CTRLR2 IS
  GENERIC(
    tech       : INTEGER := 0;
    Input_SZ_1 : INTEGER := 16;
    Mem_use    : INTEGER := use_RAM

    );
  PORT(
    reset      : IN  STD_LOGIC;
    clk        : IN  STD_LOGIC;
    WD_sel     : IN  STD_LOGIC;
    Read       : IN  STD_LOGIC;
    WADDR_sel  : IN  STD_LOGIC;
    count      : IN  STD_LOGIC;
    SVG_ADDR   : IN  STD_LOGIC;
    Write      : IN  STD_LOGIC;
    GO_0       : IN  STD_LOGIC;
    sample_in  : IN  STD_LOGIC_VECTOR(Input_SZ_1-1 DOWNTO 0);
    sample_out : OUT STD_LOGIC_VECTOR(Input_SZ_1-1 DOWNTO 0)
    );
END RAM_CTRLR2;


ARCHITECTURE ar_RAM_CTRLR2 OF RAM_CTRLR2 IS

  SIGNAL WD           : STD_LOGIC_VECTOR(Input_SZ_1-1 DOWNTO 0);
  SIGNAL WD_D         : STD_LOGIC_VECTOR(Input_SZ_1-1 DOWNTO 0);
  SIGNAL RD           : STD_LOGIC_VECTOR(Input_SZ_1-1 DOWNTO 0);
  SIGNAL WEN, REN     : STD_LOGIC;
  SIGNAL WADDR_back   : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL WADDR_back_D : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL RADDR        : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL WADDR        : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL WADDR_D      : STD_LOGIC_VECTOR(7 DOWNTO 0);

  SIGNAL WADDR_back_s : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN

  sample_out <= RD(Input_SZ_1-1 DOWNTO 0);




--==============================================================
--=========================R A M================================
--==============================================================
--memRAM :   if (Mem_use = use_RAM or Mem_use = use_CEL)generate
--RAMblk : entity work.RAM
--    generic map
--    (
--        Input_SZ_1
--    )
--    port map(
--    WD      =>  WD_D,
--    RD      =>  RD,
--    WEN     =>  WEN,
--    REN     =>  REN,
--    WADDR   =>  WADDR,
--    RADDR   =>  RADDR,
--    RWCLK   =>  clk,
--    RESET   =>  reset
--        ) ;
--end generate;

  memCEL : IF Mem_use = use_CEL GENERATE
    WEN <=  not Write;
    REN <=  not read;
   RAMblk : RAM_CEL
      GENERIC MAP( Input_SZ_1)
      PORT MAP(
        WD    => WD_D,
        RD    => RD,
        WEN   => WEN,
        REN   => REN,
        WADDR => WADDR,
        RADDR => RADDR,
        RWCLK => clk,
        RESET => reset
        ) ;
  END GENERATE;

  memRAM : IF Mem_use = use_RAM GENERATE
    SRAM : syncram_2p
      GENERIC MAP(tech, 8, Input_SZ_1)
      PORT MAP(clk, read, RADDR, RD, clk, write, WADDR, WD_D);
  END GENERATE;

--       port map(clk,REN,RADDR,RD,clk,WEN,WADDR,WD_D);

--==============================================================
--==============================================================


  ADDRcntr_inst : ADDRcntr
    PORT MAP(
      clk   => clk,
      reset => reset,
      count => count,
      clr   => GO_0,
      Q     => RADDR
      );

  MUX2_inst1 : MUX2
    GENERIC MAP(Input_SZ => Input_SZ_1)
    PORT MAP(
      sel => WD_sel,
      IN1 => sample_in,
      IN2 => RD(Input_SZ_1-1 DOWNTO 0),
      RES => WD(Input_SZ_1-1 DOWNTO 0)
      );

  MUX2_inst2 : MUX2
    GENERIC MAP(Input_SZ => 8)
    PORT MAP(
      sel => WADDR_sel,
      IN1 => WADDR_D,
      IN2 => WADDR_back_D,
      RES => WADDR
      );

  WADDR_backreg : REG
    GENERIC MAP(size => 8, initial_VALUE => ChanelsCount*Cels_count*4-2)
    PORT MAP(
      reset => reset,
      clk   => clk,                     --SVG_ADDR,
      D     => WADDR_back_s,            --RADDR,
      Q     => WADDR_back
      );

  WADDR_back_s <= RADDR WHEN SVG_ADDR = '1' ELSE WADDR_back;

  WADDR_backreg2 : REG
    GENERIC MAP(size => 8)
    PORT MAP(
      reset => reset,
      clk   => clk,                     --SVG_ADDR,
      D     => WADDR_back,
      Q     => WADDR_back_D
      );

  WDRreg : REG
    GENERIC MAP(size => Input_SZ_1)
    PORT MAP(
      reset => reset,
      clk   => clk,
      D     => WD(Input_SZ_1-1 DOWNTO 0),
      Q     => WD_D(Input_SZ_1-1 DOWNTO 0)
      );

  ADDRreg : REG
    GENERIC MAP(size => 8)
    PORT MAP(
      reset => reset,
      clk   => clk,
      D     => RADDR,
      Q     => WADDR_D
      );

END ar_RAM_CTRLR2;
