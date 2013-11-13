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
--                    Author : Jean-christophe PELLION
--                    Mail   : jean-christophe.pellion@lpp.polytechnique.fr
------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY lpp;
USE lpp.lpp_memory.ALL;
USE lpp.iir_filter.ALL;
USE lpp.lpp_waveform_pkg.ALL;

LIBRARY techmap;
USE techmap.gencomp.ALL;

ENTITY lpp_waveform_fifo IS
  GENERIC(
    tech : INTEGER := 0
    );
  PORT(
    clk  : IN STD_LOGIC;
    rstn : IN STD_LOGIC;
    ---------------------------------------------------------------------------
    run  : IN STD_LOGIC;
    
    ---------------------------------------------------------------------------
    empty_almost : OUT STD_LOGIC_VECTOR( 3 DOWNTO 0); --occupancy is lesser than 16 * 32b
    empty        : OUT STD_LOGIC_VECTOR( 3 DOWNTO 0);
    data_ren     : IN  STD_LOGIC_VECTOR( 3 DOWNTO 0);
    rdata        : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    
    ---------------------------------------------------------------------------
    full_almost : OUT STD_LOGIC_VECTOR( 3 DOWNTO 0); --occupancy is greater than MAX - 5 * 32b
    full        : OUT STD_LOGIC_VECTOR( 3 DOWNTO 0);
    data_wen    : IN  STD_LOGIC_VECTOR( 3 DOWNTO 0);
    wdata       : IN  STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY;


ARCHITECTURE ar_lpp_waveform_fifo OF lpp_waveform_fifo IS

  SIGNAL data_mem_addr_r : LPP_TYPE_ADDR_FIFO_WAVEFORM(3 DOWNTO 0);
  SIGNAL data_mem_addr_w : LPP_TYPE_ADDR_FIFO_WAVEFORM(3 DOWNTO 0);
  SIGNAL data_mem_re    : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL data_mem_we    : STD_LOGIC_VECTOR(3 DOWNTO 0);
  
  SIGNAL data_addr_r : STD_LOGIC_VECTOR(6 DOWNTO 0);
  SIGNAL data_addr_w : STD_LOGIC_VECTOR(6 DOWNTO 0);
  SIGNAL re : STD_LOGIC;
  SIGNAL we : STD_LOGIC;
  
BEGIN
  
  SRAM : syncram_2p
    GENERIC MAP(tech, 7, 32)
    PORT MAP(clk, re, data_addr_r, rdata,       
             clk, we, data_addr_w, wdata);      

  re <=  data_mem_re(3) OR
         data_mem_re(2) OR
         data_mem_re(1) OR
         data_mem_re(0);

  we <= data_mem_we(3) OR
        data_mem_we(2) OR
        data_mem_we(1) OR
        data_mem_we(0);
  
  data_addr_r <= data_mem_addr_r(0) WHEN data_mem_re(0) = '1' ELSE
                 data_mem_addr_r(1) WHEN data_mem_re(1) = '1' ELSE
                 data_mem_addr_r(2) WHEN data_mem_re(2) = '1' ELSE
                 data_mem_addr_r(3);
  
  data_addr_w <= data_mem_addr_w(0) WHEN data_mem_we(0) = '1' ELSE
                 data_mem_addr_w(1) WHEN data_mem_we(1) = '1' ELSE
                 data_mem_addr_w(2) WHEN data_mem_we(2) = '1' ELSE
                 data_mem_addr_w(3); 

  gen_fifo_ctrl_data: FOR I IN 3 DOWNTO 0 GENERATE
    lpp_waveform_fifo_ctrl_data: lpp_waveform_fifo_ctrl
      GENERIC MAP (
        offset       => 32*I,
        length       => 32)
      PORT MAP (
        clk          => clk,
        rstn         => rstn,
        run          => run,
        ren          => data_ren(I), 
        wen          => data_wen(I),
        mem_re       => data_mem_re(I),
        mem_we       => data_mem_we(I),
        mem_addr_ren => data_mem_addr_r(I),
        mem_addr_wen => data_mem_addr_w(I),
        empty_almost => empty_almost(I),
        empty        => empty(I),
        full_almost  => full_almost(I),
        full         => full(I)
        );
  END GENERATE gen_fifo_ctrl_data;

  
END ARCHITECTURE;


























