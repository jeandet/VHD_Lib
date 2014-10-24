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
-- Author : Jean-christophe Pellion
-- Mail   : jean-christophe.pellion@lpp.polytechnique.fr
--          jean-christophe.pellion@easii-ic.com
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY grlib;
USE grlib.amba.ALL;
USE grlib.stdlib.ALL;
USE grlib.devices.ALL;
USE GRLIB.DMA2AHB_Package.ALL;

LIBRARY techmap;
USE techmap.gencomp.ALL;

PACKAGE lpp_waveform_pkg IS

  TYPE LPP_TYPE_ADDR_FIFO_WAVEFORM IS ARRAY (NATURAL RANGE <>) OF STD_LOGIC_VECTOR(6 DOWNTO 0);

  TYPE Data_Vector IS ARRAY (NATURAL RANGE <>, NATURAL RANGE <>) OF STD_LOGIC;

  -----------------------------------------------------------------------------
  -- SNAPSHOT 
  -----------------------------------------------------------------------------

  COMPONENT lpp_waveform_snapshot
    GENERIC (
      data_size              : INTEGER;
      nb_snapshot_param_size : INTEGER);
    PORT (
      clk               : IN  STD_LOGIC;
      rstn              : IN  STD_LOGIC;
      run               : IN  STD_LOGIC;
      enable            : IN  STD_LOGIC;
      burst_enable      : IN  STD_LOGIC;
      nb_snapshot_param : IN  STD_LOGIC_VECTOR(nb_snapshot_param_size-1 DOWNTO 0);
      start_snapshot    : IN  STD_LOGIC;
      data_in           : IN  STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
      data_in_valid     : IN  STD_LOGIC;
      data_out          : OUT STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
      data_out_valid    : OUT STD_LOGIC);
  END COMPONENT;

  COMPONENT lpp_waveform_burst
    GENERIC (
      data_size : INTEGER);
    PORT (
      clk            : IN  STD_LOGIC;
      rstn           : IN  STD_LOGIC;
      run            : IN  STD_LOGIC;
      enable         : IN  STD_LOGIC;
      data_in        : IN  STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
      data_in_valid  : IN  STD_LOGIC;
      data_out       : OUT STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
      data_out_valid : OUT STD_LOGIC);
  END COMPONENT;

  COMPONENT lpp_waveform_snapshot_controler
    GENERIC (
      delta_vector_size      : INTEGER;
      delta_vector_size_f0_2 : INTEGER);
    PORT (
      clk                : IN  STD_LOGIC;
      rstn               : IN  STD_LOGIC;
      reg_run            : IN  STD_LOGIC;
      reg_start_date     : IN  STD_LOGIC_VECTOR(30 DOWNTO 0);
      reg_delta_snapshot : IN  STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
      reg_delta_f0       : IN  STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
      reg_delta_f0_2     : IN  STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
      reg_delta_f1       : IN  STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
      reg_delta_f2       : IN  STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
      coarse_time        : IN  STD_LOGIC_VECTOR(30 DOWNTO 0);
      data_f0_valid      : IN  STD_LOGIC;
      data_f2_valid      : IN  STD_LOGIC;
      start_snapshot_f0  : OUT STD_LOGIC;
      start_snapshot_f1  : OUT STD_LOGIC;
      start_snapshot_f2  : OUT STD_LOGIC;
      wfp_on             : OUT STD_LOGIC);
  END COMPONENT;

  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  COMPONENT lpp_waveform
    GENERIC (
      tech                   : INTEGER;
      data_size              : INTEGER;
      nb_data_by_buffer_size : INTEGER;
      nb_snapshot_param_size : INTEGER;
      delta_vector_size      : INTEGER;
      delta_vector_size_f0_2 : INTEGER);
    PORT (
      clk                          : IN  STD_LOGIC;
      rstn                         : IN  STD_LOGIC;
      reg_run                      : IN  STD_LOGIC;
      reg_start_date               : IN  STD_LOGIC_VECTOR(30 DOWNTO 0);
      reg_delta_snapshot           : IN  STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
      reg_delta_f0                 : IN  STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
      reg_delta_f0_2               : IN  STD_LOGIC_VECTOR(delta_vector_size_f0_2-1 DOWNTO 0);
      reg_delta_f1                 : IN  STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
      reg_delta_f2                 : IN  STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
      enable_f0                    : IN  STD_LOGIC;
      enable_f1                    : IN  STD_LOGIC;
      enable_f2                    : IN  STD_LOGIC;
      enable_f3                    : IN  STD_LOGIC;
      burst_f0                     : IN  STD_LOGIC;
      burst_f1                     : IN  STD_LOGIC;
      burst_f2                     : IN  STD_LOGIC;
      nb_data_by_buffer            : IN  STD_LOGIC_VECTOR(nb_data_by_buffer_size-1 DOWNTO 0);
      nb_snapshot_param            : IN  STD_LOGIC_VECTOR(nb_snapshot_param_size-1 DOWNTO 0);
      status_new_err               : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      status_buffer_ready : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      addr_buffer         : IN STD_LOGIC_VECTOR(32*4 DOWNTO 0);
      length_buffer       : IN STD_LOGIC_VECTOR(25 DOWNTO 0);
      ready_buffer        : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      buffer_time         : OUT STD_LOGIC_VECTOR(48*4-1 DOWNTO 0);
      error_buffer_full   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      coarse_time                  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      fine_time                    : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
      data_f0_in_valid             : IN  STD_LOGIC;
      data_f0_in                   : IN  STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
      data_f1_in_valid             : IN  STD_LOGIC;
      data_f1_in                   : IN  STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
      data_f2_in_valid             : IN  STD_LOGIC;
      data_f2_in                   : IN  STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
      data_f3_in_valid             : IN  STD_LOGIC;
      data_f3_in                   : IN  STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
    
      dma_fifo_valid_burst : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      dma_fifo_data        : OUT STD_LOGIC_VECTOR(32*4-1 DOWNTO 0);
      dma_fifo_ren         : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      dma_buffer_new       : OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
      dma_buffer_addr      : OUT STD_LOGIC_VECTOR(32*4-1 DOWNTO 0);
      dma_buffer_length    : OUT STD_LOGIC_VECTOR(26*4-1 DOWNTO 0);
      dma_buffer_full      : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      dma_buffer_full_err  : IN  STD_LOGIC_VECTOR(3 DOWNTO 0)
      );
  END COMPONENT;

  COMPONENT lpp_waveform_dma_genvalid
    PORT (
      HCLK      : IN  STD_LOGIC;
      HRESETn   : IN  STD_LOGIC;
      run       : IN  STD_LOGIC;
      valid_in  : IN  STD_LOGIC;
      ack_in    : IN  STD_LOGIC;
      time_in   : IN  STD_LOGIC_VECTOR(47 DOWNTO 0);
      valid_out : OUT STD_LOGIC;
      time_out  : OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
      error     : OUT STD_LOGIC);
  END COMPONENT;

  -----------------------------------------------------------------------------
  -- FIFO
  -----------------------------------------------------------------------------
  COMPONENT lpp_waveform_fifo_ctrl
    GENERIC (
      offset : INTEGER;
      length : INTEGER);
    PORT (
      clk          : IN  STD_LOGIC;
      rstn         : IN  STD_LOGIC;
      run          : IN  STD_LOGIC;
      ren          : IN  STD_LOGIC;
      wen          : IN  STD_LOGIC;
      mem_re       : OUT STD_LOGIC;
      mem_we       : OUT STD_LOGIC;
      mem_addr_ren : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
      mem_addr_wen : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
      empty_almost : OUT STD_LOGIC;
      empty        : OUT STD_LOGIC;
      full_almost  : OUT STD_LOGIC;
      full         : OUT STD_LOGIC);
  END COMPONENT;

  COMPONENT lpp_waveform_fifo_arbiter
    GENERIC (
      tech                   : INTEGER;
      nb_data_by_buffer_size : INTEGER);
    PORT (
      clk               : IN  STD_LOGIC;
      rstn              : IN  STD_LOGIC;
      run               : IN  STD_LOGIC;
      nb_data_by_buffer : IN  STD_LOGIC_VECTOR(nb_data_by_buffer_size - 1 DOWNTO 0);
      data_in_valid     : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      data_in_ack       : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      data_in           : IN  Data_Vector(3 DOWNTO 0, 95 DOWNTO 0);
      time_in           : IN  Data_Vector(3 DOWNTO 0, 47 DOWNTO 0);
      data_out          : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      data_out_wen      : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      full_almost       : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      full              : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      time_out     : OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
      time_out_new : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)    
      );
  END COMPONENT;

  COMPONENT lpp_waveform_fifo
    GENERIC (
      tech : INTEGER);
    PORT (
      clk          : IN  STD_LOGIC;
      rstn         : IN  STD_LOGIC;
      run          : IN  STD_LOGIC;
      empty_almost : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      empty        : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      data_ren     : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      rdata        : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      full_almost  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      full         : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      data_wen     : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      wdata        : IN  STD_LOGIC_VECTOR(31 DOWNTO 0));
  END COMPONENT;

  COMPONENT lpp_waveform_fifo_headreg
    GENERIC (
      tech : INTEGER);
    PORT (
      clk            : IN  STD_LOGIC;
      rstn           : IN  STD_LOGIC;
      run            : IN  STD_LOGIC;
      o_empty_almost : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      o_empty        : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      o_data_ren     : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      o_rdata_0      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      o_rdata_1      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      o_rdata_2      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      o_rdata_3      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      i_empty_almost : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      i_empty        : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      i_data_ren     : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      i_rdata        : IN  STD_LOGIC_VECTOR(31 DOWNTO 0));
  END COMPONENT;

  COMPONENT lpp_waveform_fifo_latencyCorrection
    GENERIC (
      tech : INTEGER);
    PORT (
      clk               : IN  STD_LOGIC;
      rstn              : IN  STD_LOGIC;
      run               : IN  STD_LOGIC;
      empty_almost      : OUT STD_LOGIC;
      empty             : OUT STD_LOGIC;
      data_ren          : IN  STD_LOGIC;
      rdata             : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      empty_almost_fifo : IN  STD_LOGIC;
      empty_fifo        : IN  STD_LOGIC;
      data_ren_fifo     : OUT STD_LOGIC;
      rdata_fifo        : IN  STD_LOGIC_VECTOR(31 DOWNTO 0));
  END COMPONENT;

  COMPONENT lpp_waveform_fifo_withoutLatency
    GENERIC (
      tech : INTEGER);
    PORT (
      clk          : IN  STD_LOGIC;
      rstn         : IN  STD_LOGIC;
      run          : IN  STD_LOGIC;
      empty_almost : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      empty        : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      data_ren     : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      rdata_0      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      rdata_1      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      rdata_2      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      rdata_3      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      full_almost  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      full         : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      data_wen     : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      wdata        : IN  STD_LOGIC_VECTOR(31 DOWNTO 0));
  END COMPONENT;

  -----------------------------------------------------------------------------
  -- GEN ADDRESS
  -----------------------------------------------------------------------------
  COMPONENT lpp_waveform_genaddress
    GENERIC (
      nb_data_by_buffer_size : INTEGER);
    PORT (
      clk                          : IN  STD_LOGIC;
      rstn                         : IN  STD_LOGIC;
      run                          : IN  STD_LOGIC;
      nb_data_by_buffer            : IN  STD_LOGIC_VECTOR(nb_data_by_buffer_size-1 DOWNTO 0);
      addr_data_f0                 : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      addr_data_f1                 : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      addr_data_f2                 : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      addr_data_f3                 : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      empty                        : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      empty_almost                 : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      data_ren                     : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      status_full                  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      status_full_ack              : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      status_full_err              : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      data_f0_data_out_valid_burst : OUT STD_LOGIC;
      data_f1_data_out_valid_burst : OUT STD_LOGIC;
      data_f2_data_out_valid_burst : OUT STD_LOGIC;
      data_f3_data_out_valid_burst : OUT STD_LOGIC;
      data_f0_data_out_valid       : OUT STD_LOGIC;
      data_f1_data_out_valid       : OUT STD_LOGIC;
      data_f2_data_out_valid       : OUT STD_LOGIC;
      data_f3_data_out_valid       : OUT STD_LOGIC;
      data_f0_addr_out             : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      data_f1_addr_out             : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      data_f2_addr_out             : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      data_f3_addr_out             : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
  END COMPONENT;

  -----------------------------------------------------------------------------
  -- lpp_waveform_fifo_arbiter_reg
  -----------------------------------------------------------------------------
  COMPONENT lpp_waveform_fifo_arbiter_reg
    GENERIC (
      data_size : INTEGER;
      data_nb   : INTEGER);
    PORT (
      clk       : IN  STD_LOGIC;
      rstn      : IN  STD_LOGIC;
      run       : IN  STD_LOGIC;
      max_count : IN  STD_LOGIC_VECTOR(data_size -1 DOWNTO 0);
      enable    : IN  STD_LOGIC;
      sel       : IN  STD_LOGIC_VECTOR(data_nb-1 DOWNTO 0);
      data      : OUT STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
      data_s    : OUT STD_LOGIC_VECTOR(data_size-1 DOWNTO 0));
  END COMPONENT;

  COMPONENT lpp_waveform_fsmdma
    PORT (
      clk                  : IN  STD_ULOGIC;
      rstn                 : IN  STD_ULOGIC;
      run                  : IN  STD_LOGIC;
      fifo_buffer_time     : IN  STD_LOGIC_VECTOR(47 DOWNTO 0);
      fifo_data            : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      fifo_empty           : IN  STD_LOGIC;
      fifo_empty_threshold : IN  STD_LOGIC;
      fifo_ren             : OUT STD_LOGIC;
      dma_fifo_valid_burst : OUT STD_LOGIC;
      dma_fifo_data        : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      dma_fifo_ren         : IN  STD_LOGIC;
      dma_buffer_new       : OUT STD_LOGIC;
      dma_buffer_addr      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      dma_buffer_length    : OUT STD_LOGIC_VECTOR(25 DOWNTO 0);
      dma_buffer_full      : IN  STD_LOGIC;
      dma_buffer_full_err  : IN  STD_LOGIC;
      status_buffer_ready  : IN  STD_LOGIC;
      addr_buffer          : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      length_buffer        : IN  STD_LOGIC_VECTOR(25 DOWNTO 0);
      ready_buffer         : OUT STD_LOGIC;
      buffer_time          : OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
      error_buffer_full    : OUT STD_LOGIC);
  END COMPONENT;
  
END lpp_waveform_pkg;
