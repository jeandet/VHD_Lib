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
    ready      : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);  -- FIFO_DATA occupancy is greater than 16 * 32b
    
    ---------------------------------------------------------------------------
    time_ren   : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    data_ren   : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    
    rdata      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    
    ---------------------------------------------------------------------------
    time_wen   : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    data_wen   : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    
    wdata      : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY;


ARCHITECTURE ar_lpp_waveform_fifo OF lpp_waveform_fifo IS

  
  SIGNAL time_mem_addr_r : LPP_TYPE_ADDR_FIFO_WAVEFORM(3 DOWNTO 0);
  SIGNAL time_mem_addr_w : LPP_TYPE_ADDR_FIFO_WAVEFORM(3 DOWNTO 0);
  SIGNAL time_mem_ren    : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL time_mem_wen    : STD_LOGIC_VECTOR(3 DOWNTO 0);

  SIGNAL data_mem_addr_r : LPP_TYPE_ADDR_FIFO_WAVEFORM(3 DOWNTO 0);
  SIGNAL data_mem_addr_w : LPP_TYPE_ADDR_FIFO_WAVEFORM(3 DOWNTO 0);
  SIGNAL data_mem_ren    : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL data_mem_wen    : STD_LOGIC_VECTOR(3 DOWNTO 0);
  
  SIGNAL data_addr_r : STD_LOGIC_VECTOR(6 DOWNTO 0);
  SIGNAL data_addr_w : STD_LOGIC_VECTOR(6 DOWNTO 0);
  SIGNAL ren : STD_LOGIC;
  SIGNAL wen : STD_LOGIC;
  
BEGIN
  
  SRAM : syncram_2p
    GENERIC MAP(tech, 7, 32)
    PORT MAP(clk, ren, data_addr_r, rdata,       
             clk, wen, data_addr_w, wdata);      


  ren <= time_mem_ren(3) OR data_mem_ren(3) OR
         time_mem_ren(2) OR data_mem_ren(2) OR
         time_mem_ren(1) OR data_mem_ren(1) OR
         time_mem_ren(0) OR data_mem_ren(0);

  wen <= time_mem_wen(3) OR data_mem_wen(3) OR
         time_mem_wen(2) OR data_mem_wen(2) OR
         time_mem_wen(1) OR data_mem_wen(1) OR
         time_mem_wen(0) OR data_mem_wen(0);

  data_addr_r <= time_mem_addr_r(0) WHEN time_mem_ren(0) = '1' ELSE
                 time_mem_addr_r(1) WHEN time_mem_ren(1) = '1' ELSE
                 time_mem_addr_r(2) WHEN time_mem_ren(2) = '1' ELSE
                 time_mem_addr_r(3) WHEN time_mem_ren(3) = '1' ELSE
                 data_mem_addr_r(0) WHEN data_mem_ren(0) = '1' ELSE
                 data_mem_addr_r(1) WHEN data_mem_ren(1) = '1' ELSE
                 data_mem_addr_r(2) WHEN data_mem_ren(2) = '1' ELSE
                 data_mem_addr_r(3);
  
  data_addr_w <= time_mem_addr_w(0) WHEN time_mem_wen(0) = '1' ELSE
                 time_mem_addr_w(1) WHEN time_mem_wen(1) = '1' ELSE
                 time_mem_addr_w(2) WHEN time_mem_wen(2) = '1' ELSE
                 time_mem_addr_w(3) WHEN time_mem_wen(3) = '1' ELSE
                 data_mem_addr_w(0) WHEN data_mem_wen(0) = '1' ELSE
                 data_mem_addr_w(1) WHEN data_mem_wen(1) = '1' ELSE
                 data_mem_addr_w(2) WHEN data_mem_wen(2) = '1' ELSE
                 data_mem_addr_w(3);   
  
  gen_fifo_ctrl_time: FOR I IN 3 DOWNTO 0 GENERATE
    lpp_waveform_fifo_ctrl_time: lpp_waveform_fifo_ctrl
      GENERIC MAP (
        offset       => 32*I + 20,
        length       => 10,
        enable_ready => '0')
      PORT MAP (
        clk          => clk,
        rstn         => rstn,
        ren          => time_ren(I), 
        wen          => time_wen(I),
        mem_re       => time_mem_ren(I),
        mem_we       => time_mem_wen(I),
        mem_addr_ren => time_mem_addr_r(I),
        mem_addr_wen => time_mem_addr_w(I),
        ready        => OPEN);
  END GENERATE gen_fifo_ctrl_time;

  gen_fifo_ctrl_data: FOR I IN 3 DOWNTO 0 GENERATE
    lpp_waveform_fifo_ctrl_data: lpp_waveform_fifo_ctrl
      GENERIC MAP (
        offset       => 32*I,
        length       => 20,
        enable_ready => '1')
      PORT MAP (
        clk          => clk,
        rstn         => rstn,
        ren          => data_ren(I), 
        wen          => data_wen(I),
        mem_re       => data_mem_ren(I),
        mem_we       => data_mem_wen(I),
        mem_addr_ren => data_mem_addr_r(I),
        mem_addr_wen => data_mem_addr_w(I),
        ready        => ready(I));
  END GENERATE gen_fifo_ctrl_data;

  
END ARCHITECTURE;


























