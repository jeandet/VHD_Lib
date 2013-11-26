-- FIFO_pipeline.vhd
------------------------------------------------------------------------------
--  This file is a part of the LPP VHDL IP LIBRARY
--  Copyright (C) 2009 - 2012, Laboratory of Plasmas Physic - CNRS
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
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library lpp;
use lpp.lpp_memory.all;
use lpp.iir_filter.all;
library techmap;
use techmap.gencomp.all;

entity FIFO_pipeline is
generic(
    tech          :   integer := 0;
    Mem_use       :   integer := use_RAM;
    fifoCount     :   integer range 2 to 100 := 8;
    DataSz        :   integer range 1 to 32 := 8;
    abits         :   integer range 2 to 12 := 8
    );
port(
    rstn    :   in std_logic;
    ReUse   :   in std_logic;
    rclk    :   in std_logic;
    ren     :   in std_logic;
    rdata   :   out std_logic_vector(DataSz-1 downto 0);
    empty   :   out std_logic;
    raddr   :   out std_logic_vector(abits-1 downto 0);
    wclk    :   in std_logic;
    wen     :   in std_logic;
    wdata   :   in std_logic_vector(DataSz-1 downto 0);
    full    :   out std_logic;
    waddr   :   out std_logic_vector(abits-1 downto 0)
);
end entity;

architecture Ar_FIFO_pipeline of FIFO_pipeline is

type    FIFO_DATA_t  is   array(NATURAL RANGE <>) of   std_logic_vector(DataSz-1 downto 0);


Signal  DATAi      :  FIFO_DATA_t(fifoCount downto 0);
Signal  FULL_RENi,WEN_EMPTYi      :   std_logic_vector(fifoCount downto 0);

begin


fifos : for i in 0 to fifoCount-1 generate
      fifo0 : lpp_fifo
      generic map(
        tech          => tech,
        Mem_use       => Mem_use,
        Enable_ReUse  => '0',
        DataSz        =>  DataSz,
        abits         =>  abits
        )
      port map(
        rstn    =>   rstn,
        ReUse   =>   '0',
        rclk    =>   rclk,
        ren     =>   FULL_RENi(i+1),
        rdata   =>   DATAi(i+1),
        empty   =>   WEN_EMPTYi(i+1),
        raddr   =>   open,
        wclk    =>   wclk,
        wen     =>   WEN_EMPTYi(i),
        wdata   =>   DATAi(i),
        full    =>   FULL_RENi(i),
        waddr   =>   open
        );

end generate;

WEN_EMPTYi(0)  <= wen;
DATAi(0)       <= wdata;
full           <= FULL_RENi(0);


empty                  <= WEN_EMPTYi(fifoCount);
rdata                  <= DATAi(fifoCount);
FULL_RENi(fifoCount)   <= ren;

end ar_FIFO_pipeline; 



