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
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
library lpp;
use lpp.iir_filter.all;
use lpp.FILTERcfg.all;
use lpp.general_purpose.all;

--TODO améliorer la flexibilité de la config de la RAM.

entity  RAM_CTRLR2 is
generic(
    Input_SZ_1      :   integer := 16
);
port(
    reset       :   in  std_logic;
    clk         :   in  std_logic;
    WD_sel      :   in  std_logic;
    Read        :   in  std_logic;
    WADDR_sel   :   in  std_logic;
    count       :   in  std_logic;
    SVG_ADDR    :   in  std_logic;
    Write       :   in  std_logic;
    GO_0        :   in  std_logic;
    sample_in   :   in  std_logic_vector(Input_SZ_1-1 downto 0);
    sample_out  :   out std_logic_vector(Input_SZ_1-1 downto 0)
);
end RAM_CTRLR2;


architecture ar_RAM_CTRLR2 of RAM_CTRLR2 is

signal  WD          :   std_logic_vector(35 downto 0); 
signal  WD_D        :   std_logic_vector(35 downto 0); 
signal  RD          :   std_logic_vector(35 downto 0);
signal  WEN, REN    :   std_logic; 
signal  WADDR_back  :   std_logic_vector(7 downto 0); 
signal  WADDR_back_D:   std_logic_vector(7 downto 0); 
signal  RADDR       :   std_logic_vector(7 downto 0); 
signal  WADDR       :   std_logic_vector(7 downto 0);
signal  WADDR_D     :   std_logic_vector(7 downto 0);



begin

sample_out  <=  RD(Smpl_SZ-1 downto 0);


WEN <=  not Write;
REN <=  not read;


--==============================================================
--=========================R A M================================
--==============================================================
memRAM :   if Mem_use = use_RAM generate
RAMblk :RAM 
    port map( 
    WD      =>  WD_D,
    RD      =>  RD,
    WEN     =>  WEN,
    REN     =>  REN,
    WADDR   =>  WADDR,
    RADDR   =>  RADDR,
    RWCLK   =>  clk,
    RESET   =>  reset
        ) ;
end generate;

memCEL :   if Mem_use = use_CEL generate
RAMblk :RAM_CEL
    port map( 
    WD      =>  WD_D,
    RD      =>  RD,
    WEN     =>  WEN,
    REN     =>  REN,
    WADDR   =>  WADDR,
    RADDR   =>  RADDR,
    RWCLK   =>  clk,
    RESET   =>  reset
        ) ;
end generate;
--==============================================================
--==============================================================


ADDRcntr_inst : ADDRcntr 
port map(
    clk     =>  clk,
    reset   =>  reset,
    count   =>  count,
    clr     =>  GO_0,
    Q       =>  RADDR
);



MUX2_inst1 :MUX2 
generic map(Input_SZ    => Smpl_SZ)
port map(
    sel     =>  WD_sel,
    IN1     =>  sample_in,
    IN2     =>  RD(Smpl_SZ-1 downto 0),
    RES     =>  WD(Smpl_SZ-1 downto 0)
);


MUX2_inst2 :MUX2 
generic map(Input_SZ    => 8)
port map(
    sel     =>  WADDR_sel,
    IN1     =>  WADDR_D,
    IN2     =>  WADDR_back_D,
    RES     =>  WADDR
);




WADDR_backreg :REG
generic map(size    => 8,initial_VALUE =>ChanelsCNT*Cels_count*4-2)
port map(
    reset   =>  reset,
    clk     =>  SVG_ADDR,
    D       =>  RADDR,
    Q       =>  WADDR_back
);

WADDR_backreg2 :REG
generic map(size    => 8)
port map(
    reset   =>  reset,
    clk     =>  SVG_ADDR,
    D       =>  WADDR_back,
    Q       =>  WADDR_back_D
);

WDRreg :REG
generic map(size    => Smpl_SZ)
port map(
    reset   =>  reset,
    clk     =>  clk,
    D       =>  WD(Smpl_SZ-1 downto 0),
    Q       =>  WD_D(Smpl_SZ-1 downto 0)
);




ADDRreg :REG
generic map(size    => 8)
port map(
    reset   =>  reset,
    clk     =>  clk,
    D       =>  RADDR,
    Q       =>  WADDR_D
);



end ar_RAM_CTRLR2;





























