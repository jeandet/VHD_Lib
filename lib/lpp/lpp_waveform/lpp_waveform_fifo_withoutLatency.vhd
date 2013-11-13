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

ENTITY lpp_waveform_fifo_withoutLatency IS
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
    rdata_0      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    rdata_1      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    rdata_2      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    rdata_3      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    
    ---------------------------------------------------------------------------
    full_almost : OUT STD_LOGIC_VECTOR( 3 DOWNTO 0); --occupancy is greater than MAX - 5 * 32b
    full        : OUT STD_LOGIC_VECTOR( 3 DOWNTO 0);
    data_wen    : IN  STD_LOGIC_VECTOR( 3 DOWNTO 0);
    wdata       : IN  STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY;


ARCHITECTURE ar_lpp_waveform_fifo_withoutLatency OF lpp_waveform_fifo_withoutLatency IS
  SIGNAL empty_almost_s : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  SIGNAL empty_s        : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  SIGNAL data_ren_s     : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  SIGNAL rdata_s        : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN




  lpp_waveform_fifo_latencyCorrection_0: lpp_waveform_fifo_latencyCorrection
    GENERIC MAP (
      tech => tech)
    PORT MAP (
      clk               => clk,
      rstn              => rstn,      
      run               => run,
      
      empty_almost      => empty_almost(0),
      empty             => empty(0),
      data_ren          => data_ren(0),
      rdata             => rdata_0,
      
      empty_almost_fifo => empty_almost_s(0),
      empty_fifo        => empty_s(0),
      data_ren_fifo     => data_ren_s(0),
      rdata_fifo        => rdata_s);

  lpp_waveform_fifo_latencyCorrection_1: lpp_waveform_fifo_latencyCorrection
    GENERIC MAP (
      tech => tech)
    PORT MAP (
      clk               => clk,
      rstn              => rstn,      
      run               => run,
      
      empty_almost      => empty_almost(1),
      empty             => empty(1),
      data_ren          => data_ren(1),
      rdata             => rdata_1,
      
      empty_almost_fifo => empty_almost_s(1),
      empty_fifo        => empty_s(1),
      data_ren_fifo     => data_ren_s(1),
      rdata_fifo        => rdata_s);

  lpp_waveform_fifo_latencyCorrection_2: lpp_waveform_fifo_latencyCorrection
    GENERIC MAP (
      tech => tech)
    PORT MAP (
      clk               => clk,
      rstn              => rstn,
      run               => run,
      
      empty_almost      => empty_almost(2),
      empty             => empty(2),
      data_ren          => data_ren(2),
      rdata             => rdata_2,
      
      empty_almost_fifo => empty_almost_s(2),
      empty_fifo        => empty_s(2),
      data_ren_fifo     => data_ren_s(2),
      rdata_fifo        => rdata_s);

  lpp_waveform_fifo_latencyCorrection_3: lpp_waveform_fifo_latencyCorrection
    GENERIC MAP (
      tech => tech)
    PORT MAP (
      clk               => clk,
      rstn              => rstn,
      run               => run,
      
      empty_almost      => empty_almost(3),
      empty             => empty(3),
      data_ren          => data_ren(3),
      rdata             => rdata_3,
      
      empty_almost_fifo => empty_almost_s(3),
      empty_fifo        => empty_s(3),
      data_ren_fifo     => data_ren_s(3),
      rdata_fifo        => rdata_s);
    
  lpp_waveform_fifo_1: lpp_waveform_fifo
    GENERIC MAP (
      tech => tech)
    PORT MAP (
      clk          => clk,
      rstn         => rstn,
      run          => run,

      empty_almost => empty_almost_s,
      empty        => empty_s,
      data_ren     => data_ren_s,
      rdata        => rdata_s,
      
      full_almost  => full_almost,
      full         => full,
      data_wen     => data_wen,
      wdata        => wdata);
  
END ARCHITECTURE;


























