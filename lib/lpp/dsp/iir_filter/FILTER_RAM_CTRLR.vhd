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

entity  FILTER_RAM_CTRLR is
port(
    reset       :   in  std_logic;
    clk         :   in  std_logic;
    run         :   in  std_logic;
    GO_0        :   in  std_logic;
    B_A         :   in  std_logic;
    writeForce  :   in  std_logic;
    next_blk    :   in  std_logic;
    sample_in   :   in  std_logic_vector(Smpl_SZ-1 downto 0);
    sample_out  :   out std_logic_vector(Smpl_SZ-1 downto 0)
);
end FILTER_RAM_CTRLR;


architecture ar_FILTER_RAM_CTRLR of FILTER_RAM_CTRLR is

signal  WD          :   std_logic_vector(35 downto 0); 
signal  WD_D        :   std_logic_vector(35 downto 0); 
signal  RD          :   std_logic_vector(35 downto 0);
signal  WEN, REN    :   std_logic; 
signal  WADDR_back  :   std_logic_vector(7 downto 0); 
signal  WADDR_back_D:   std_logic_vector(7 downto 0); 
signal  RADDR       :   std_logic_vector(7 downto 0); 
signal  WADDR       :   std_logic_vector(7 downto 0);
signal  WADDR_D     :   std_logic_vector(7 downto 0);
signal  run_D       :   std_logic;
signal  run_D_inv   :   std_logic;
signal  run_inv     :   std_logic;
signal  next_blk_D  :   std_logic;
signal  MUX2_inst1_sel  :   std_logic;


begin

sample_out  <=  RD(Smpl_SZ-1 downto 0);

MUX2_inst1_sel  <=  run_D and not next_blk;
run_D_inv   <=  not run_D;
run_inv     <=  not run;
WEN <=  run_D_inv and not writeForce;
REN <=  run_inv ;--and not next_blk;


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
    count   =>  run,
    clr     =>  GO_0,
    Q       =>  RADDR
);



MUX2_inst1 :MUX2 
generic map(Input_SZ    => Smpl_SZ)
port map(
    sel     =>  MUX2_inst1_sel,
    IN1     =>  sample_in,
    IN2     =>  RD(Smpl_SZ-1 downto 0),
    RES     =>  WD(Smpl_SZ-1 downto 0)
);


MUX2_inst2 :MUX2 
generic map(Input_SZ    => 8)
port map(
    sel     =>  next_blk_D,
    IN1     =>  WADDR_D,
    IN2     =>  WADDR_back_D,
    RES     =>  WADDR
);


next_blkRreg :REG
generic map(size    => 1)
port map(
    reset   =>  reset,
    clk     =>  clk,
    D(0)    =>  next_blk,
    Q(0)    =>  next_blk_D
);

WADDR_backreg :REG
generic map(size    => 8)
port map(
    reset   =>  reset,
    clk     =>  B_A,
    D       =>  RADDR,
    Q       =>  WADDR_back
);

WADDR_backreg2 :REG
generic map(size    => 8)
port map(
    reset   =>  reset,
    clk     =>  B_A,
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

RunRreg :REG
generic map(size    => 1)
port map(
    reset   =>  reset,
    clk     =>  clk,
    D(0)    =>  run,
    Q(0)    =>  run_D
);



ADDRreg :REG
generic map(size    => 8)
port map(
    reset   =>  reset,
    clk     =>  clk,
    D       =>  RADDR,
    Q       =>  WADDR_D
);



end ar_FILTER_RAM_CTRLR;





























