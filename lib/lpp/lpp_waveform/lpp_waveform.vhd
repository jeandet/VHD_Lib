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
USE ieee.numeric_std.ALL;

LIBRARY grlib;
USE grlib.amba.ALL;
USE grlib.stdlib.ALL;
USE grlib.devices.ALL;
USE GRLIB.DMA2AHB_Package.ALL;

LIBRARY lpp;
USE lpp.lpp_waveform_pkg.ALL;
USE lpp.iir_filter.ALL;
USE lpp.lpp_memory.ALL;

LIBRARY techmap;
USE techmap.gencomp.ALL;

ENTITY lpp_waveform IS
  
  GENERIC (
    tech                   : INTEGER := inferred;
    data_size              : INTEGER := 96;  --16*6
    nb_data_by_buffer_size : INTEGER := 11;
--    nb_word_by_buffer_size : INTEGER := 11;
    nb_snapshot_param_size : INTEGER := 11;
    delta_vector_size      : INTEGER := 20;
    delta_vector_size_f0_2 : INTEGER := 3);

  PORT (
    clk  : IN STD_LOGIC;
    rstn : IN STD_LOGIC;

    ---- AMBA AHB Master Interface
    --AHB_Master_In  : IN  AHB_Mst_In_Type;   -- TODO
    --AHB_Master_Out : OUT AHB_Mst_Out_Type;  -- TODO

    --config
    reg_run            : IN STD_LOGIC;
    reg_start_date     : IN STD_LOGIC_VECTOR(30 DOWNTO 0);
    reg_delta_snapshot : IN STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
    reg_delta_f0       : IN STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
    reg_delta_f0_2     : IN STD_LOGIC_VECTOR(delta_vector_size_f0_2-1 DOWNTO 0);
    reg_delta_f1       : IN STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
    reg_delta_f2       : IN STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);

    enable_f0 : IN STD_LOGIC;
    enable_f1 : IN STD_LOGIC;
    enable_f2 : IN STD_LOGIC;
    enable_f3 : IN STD_LOGIC;

    burst_f0 : IN STD_LOGIC;
    burst_f1 : IN STD_LOGIC;
    burst_f2 : IN STD_LOGIC;

    nb_data_by_buffer : IN  STD_LOGIC_VECTOR(nb_data_by_buffer_size-1 DOWNTO 0);
--    nb_word_by_buffer : IN  STD_LOGIC_VECTOR(nb_word_by_buffer_size-1 DOWNTO 0);
    nb_snapshot_param : IN  STD_LOGIC_VECTOR(nb_snapshot_param_size-1 DOWNTO 0);

    status_new_err    : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);  -- New data f(i) before the current data is write by dma


    -- REG DMA
    status_buffer_ready : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    addr_buffer         : IN STD_LOGIC_VECTOR(32*4-1 DOWNTO 0);
    length_buffer       : IN STD_LOGIC_VECTOR(25 DOWNTO 0);
    
    ready_buffer        : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    buffer_time         : OUT STD_LOGIC_VECTOR(48*4-1 DOWNTO 0);
    error_buffer_full   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
           
    ---------------------------------------------------------------------------
    -- INPUT
    coarse_time       : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    fine_time         : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);

    --f0
    data_f0_in_valid : IN STD_LOGIC;
    data_f0_in       : IN STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
    --f1
    data_f1_in_valid : IN STD_LOGIC;
    data_f1_in       : IN STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
    --f2
    data_f2_in_valid : IN STD_LOGIC;
    data_f2_in       : IN STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
    --f3
    data_f3_in_valid : IN STD_LOGIC;
    data_f3_in       : IN STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
        
    ---------------------------------------------------------------------------
    -- DMA --------------------------------------------------------------------
    
    dma_fifo_valid_burst : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    dma_fifo_data        : OUT STD_LOGIC_VECTOR(32*4-1 DOWNTO 0);
    dma_fifo_ren         : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    dma_buffer_new       : OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
    dma_buffer_addr      : OUT STD_LOGIC_VECTOR(32*4-1 DOWNTO 0);
    dma_buffer_length    : OUT STD_LOGIC_VECTOR(26*4-1 DOWNTO 0);
    dma_buffer_full      : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    dma_buffer_full_err  : IN  STD_LOGIC_VECTOR(3 DOWNTO 0)

    );

END lpp_waveform;

ARCHITECTURE beh OF lpp_waveform IS
  SIGNAL start_snapshot_f0 : STD_LOGIC;
  SIGNAL start_snapshot_f1 : STD_LOGIC;
  SIGNAL start_snapshot_f2 : STD_LOGIC;

  SIGNAL data_f0_out : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
  SIGNAL data_f1_out : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
  SIGNAL data_f2_out : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
  SIGNAL data_f3_out : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);

  SIGNAL data_f0_out_swap : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
  SIGNAL data_f1_out_swap : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
  SIGNAL data_f2_out_swap : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
  SIGNAL data_f3_out_swap : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);

  SIGNAL data_f0_out_valid          : STD_LOGIC;
  SIGNAL data_f1_out_valid          : STD_LOGIC;
  SIGNAL data_f2_out_valid          : STD_LOGIC;
  SIGNAL data_f3_out_valid          : STD_LOGIC;
  SIGNAL nb_snapshot_param_more_one : STD_LOGIC_VECTOR(nb_snapshot_param_size DOWNTO 0);
  --
  SIGNAL valid_in                   : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL valid_out                  : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL valid_ack                  : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL time_ready                 : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL data_ready                 : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL ready_arb                  : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL data_wen                   : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL time_wen                   : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL wdata                      : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL full_almost                : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL full                       : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL empty_almost               : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL empty                      : STD_LOGIC_VECTOR(3 DOWNTO 0);
  --
  SIGNAL data_ren                   : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL time_ren                   : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL rdata                      : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL enable                     : STD_LOGIC_VECTOR(3 DOWNTO 0);
  --
  SIGNAL run                        : STD_LOGIC;
  --
  TYPE   TIME_VECTOR IS ARRAY (NATURAL RANGE <>) OF STD_LOGIC_VECTOR(47 DOWNTO 0);
  SIGNAL data_out                   : Data_Vector(3 DOWNTO 0, 95 DOWNTO 0);
  SIGNAL time_out_2                 : Data_Vector(3 DOWNTO 0, 47 DOWNTO 0);
  SIGNAL time_out                   : TIME_VECTOR(3 DOWNTO 0);
  SIGNAL time_out_debug             : TIME_VECTOR(3 DOWNTO 0);  -- TODO : debug
  SIGNAL time_reg1                  : STD_LOGIC_VECTOR(47 DOWNTO 0);
  SIGNAL time_reg2                  : STD_LOGIC_VECTOR(47 DOWNTO 0);
  --

  SIGNAL s_empty_almost : STD_LOGIC_VECTOR(3 DOWNTO 0);  --occupancy is lesser than 16 * 32b
  SIGNAL s_empty        : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL s_data_ren     : STD_LOGIC_VECTOR(3 DOWNTO 0);
--  SIGNAL s_rdata        : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL s_rdata_v        : STD_LOGIC_VECTOR(32*4-1 DOWNTO 0);

  --
  SIGNAL arbiter_time_out      : STD_LOGIC_VECTOR(47 DOWNTO 0);
  SIGNAL arbiter_time_out_new  : STD_LOGIC_VECTOR(3 DOWNTO 0);

  SIGNAL fifo_buffer_time : STD_LOGIC_VECTOR(48*4-1 DOWNTO 0);
  
BEGIN  -- beh

  -----------------------------------------------------------------------------
  
  lpp_waveform_snapshot_controler_1 : lpp_waveform_snapshot_controler
    GENERIC MAP (
      delta_vector_size      => delta_vector_size,
      delta_vector_size_f0_2 => delta_vector_size_f0_2
      )
    PORT MAP (
      clk                => clk,
      rstn               => rstn,
      reg_run            => reg_run,
      reg_start_date     => reg_start_date,
      reg_delta_snapshot => reg_delta_snapshot,
      reg_delta_f0       => reg_delta_f0,
      reg_delta_f0_2     => reg_delta_f0_2,
      reg_delta_f1       => reg_delta_f1,
      reg_delta_f2       => reg_delta_f2,
      coarse_time        => coarse_time(30 DOWNTO 0),
      data_f0_valid      => data_f0_in_valid,
      data_f2_valid      => data_f2_in_valid,
      start_snapshot_f0  => start_snapshot_f0,
      start_snapshot_f1  => start_snapshot_f1,
      start_snapshot_f2  => start_snapshot_f2,
      wfp_on             => run);

  lpp_waveform_snapshot_f0 : lpp_waveform_snapshot
    GENERIC MAP (
      data_size              => data_size,
      nb_snapshot_param_size => nb_snapshot_param_size)
    PORT MAP (
      clk               => clk,
      rstn              => rstn,
      run               => run,
      enable            => enable_f0,
      burst_enable      => burst_f0,
      nb_snapshot_param => nb_snapshot_param,
      start_snapshot    => start_snapshot_f0,
      data_in           => data_f0_in,
      data_in_valid     => data_f0_in_valid,
      data_out          => data_f0_out,
      data_out_valid    => data_f0_out_valid);

  nb_snapshot_param_more_one <= ('0' & nb_snapshot_param) ;--+ 1;

  lpp_waveform_snapshot_f1 : lpp_waveform_snapshot
    GENERIC MAP (
      data_size              => data_size,
      nb_snapshot_param_size => nb_snapshot_param_size+1)
    PORT MAP (
      clk               => clk,
      rstn              => rstn,
      run               => run,
      enable            => enable_f1,
      burst_enable      => burst_f1,
      nb_snapshot_param => nb_snapshot_param_more_one,
      start_snapshot    => start_snapshot_f1,
      data_in           => data_f1_in,
      data_in_valid     => data_f1_in_valid,
      data_out          => data_f1_out,
      data_out_valid    => data_f1_out_valid);

  lpp_waveform_snapshot_f2 : lpp_waveform_snapshot
    GENERIC MAP (
      data_size              => data_size,
      nb_snapshot_param_size => nb_snapshot_param_size+1)
    PORT MAP (
      clk               => clk,
      rstn              => rstn,
      run               => run,
      enable            => enable_f2,
      burst_enable      => burst_f2,
      nb_snapshot_param => nb_snapshot_param_more_one,
      start_snapshot    => start_snapshot_f2,
      data_in           => data_f2_in,
      data_in_valid     => data_f2_in_valid,
      data_out          => data_f2_out,
      data_out_valid    => data_f2_out_valid);

  lpp_waveform_burst_f3 : lpp_waveform_burst
    GENERIC MAP (
      data_size => data_size)
    PORT MAP (
      clk            => clk,
      rstn           => rstn,
      run            => run,
      enable         => enable_f3,
      data_in        => data_f3_in,
      data_in_valid  => data_f3_in_valid,
      data_out       => data_f3_out,
      data_out_valid => data_f3_out_valid);

  -----------------------------------------------------------------------------
  -- DEBUG -- SNAPSHOT OUT
  --debug_f0_data_valid <= data_f0_out_valid;
  --debug_f0_data       <= data_f0_out;
  --debug_f1_data_valid <= data_f1_out_valid;
  --debug_f1_data       <= data_f1_out;
  --debug_f2_data_valid <= data_f2_out_valid;
  --debug_f2_data       <= data_f2_out;
  --debug_f3_data_valid <= data_f3_out_valid;
  --debug_f3_data       <= data_f3_out;
  -----------------------------------------------------------------------------

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      time_reg1 <= (OTHERS => '0');
      time_reg2 <= (OTHERS => '0');
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
      time_reg1 <= fine_time & coarse_time;
      time_reg2 <= time_reg1;
    END IF;
  END PROCESS;

  valid_in <= data_f3_out_valid & data_f2_out_valid & data_f1_out_valid & data_f0_out_valid;
  all_input_valid : FOR i IN 3 DOWNTO 0 GENERATE
    lpp_waveform_dma_genvalid_I : lpp_waveform_dma_genvalid
      PORT MAP (
        HCLK      => clk,
        HRESETn   => rstn,
        run       => run,
        valid_in  => valid_in(I),
        ack_in    => valid_ack(I),
        time_in   => time_reg2,         -- Todo
        valid_out => valid_out(I),
        time_out  => time_out(I),       -- Todo
        error     => status_new_err(I));
  END GENERATE all_input_valid;

  data_f0_out_swap <= data_f0_out((16*5)-1 DOWNTO 16*4) &  
                      data_f0_out((16*6)-1 DOWNTO 16*5) &
                      data_f0_out((16*3)-1 DOWNTO 16*2) &
                      data_f0_out((16*4)-1 DOWNTO 16*3) &
                      data_f0_out((16*1)-1 DOWNTO 16*0) &
                      data_f0_out((16*2)-1 DOWNTO 16*1) ;  

  data_f1_out_swap <= data_f1_out((16*5)-1 DOWNTO 16*4) &  
                      data_f1_out((16*6)-1 DOWNTO 16*5) &
                      data_f1_out((16*3)-1 DOWNTO 16*2) &
                      data_f1_out((16*4)-1 DOWNTO 16*3) &
                      data_f1_out((16*1)-1 DOWNTO 16*0) &
                      data_f1_out((16*2)-1 DOWNTO 16*1) ;   

  data_f2_out_swap <= data_f2_out((16*5)-1 DOWNTO 16*4) &  
                      data_f2_out((16*6)-1 DOWNTO 16*5) &
                      data_f2_out((16*3)-1 DOWNTO 16*2) &
                      data_f2_out((16*4)-1 DOWNTO 16*3) &
                      data_f2_out((16*1)-1 DOWNTO 16*0) &
                      data_f2_out((16*2)-1 DOWNTO 16*1) ;   

  data_f3_out_swap <= data_f3_out((16*5)-1 DOWNTO 16*4) &  
                      data_f3_out((16*6)-1 DOWNTO 16*5) &
                      data_f3_out((16*3)-1 DOWNTO 16*2) &
                      data_f3_out((16*4)-1 DOWNTO 16*3) &
                      data_f3_out((16*1)-1 DOWNTO 16*0) &
                      data_f3_out((16*2)-1 DOWNTO 16*1) ;  
  
  all_bit_of_data_out : FOR I IN 95 DOWNTO 0 GENERATE
    data_out(0, I) <= data_f0_out_swap(I);
    data_out(1, I) <= data_f1_out_swap(I);
    data_out(2, I) <= data_f2_out_swap(I);
    data_out(3, I) <= data_f3_out_swap(I);
  END GENERATE all_bit_of_data_out;
  
  -----------------------------------------------------------------------------
  -- TODO : debug
  -----------------------------------------------------------------------------
  all_bit_of_time_out : FOR I IN 47 DOWNTO 0 GENERATE
    all_sample_of_time_out : FOR J IN 3 DOWNTO 0 GENERATE
      time_out_2(J, I) <= time_out(J)(I);
    END GENERATE all_sample_of_time_out;
  END GENERATE all_bit_of_time_out;

  lpp_waveform_fifo_arbiter_1 : lpp_waveform_fifo_arbiter
    GENERIC MAP (tech                   => tech,
                 nb_data_by_buffer_size => nb_data_by_buffer_size)
    PORT MAP (
      clk               => clk,
      rstn              => rstn,
      run               => run,
      nb_data_by_buffer => nb_data_by_buffer,
      data_in_valid     => valid_out,
      data_in_ack       => valid_ack,
      data_in           => data_out,
      time_in           => time_out_2,

      data_out     => wdata,
      data_out_wen => data_wen,
      full_almost  => full_almost,
      full         => full,

      time_out          => arbiter_time_out,                     
      time_out_new      => arbiter_time_out_new
      
      );

  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------

  generate_all_fifo: FOR I IN 0 TO 3 GENERATE
    lpp_fifo_1: lpp_fifo
      GENERIC MAP (
        tech                  => tech,
        Mem_use               => use_RAM,
        EMPTY_THRESHOLD_LIMIT => 15,
        FULL_THRESHOLD_LIMIT  => 3,
        DataSz                => 32,
        AddrSz                => 7)
      PORT MAP (
        clk             => clk,
        rstn            => rstn,
        reUse           => '0',
        run             => run,
        ren             => data_ren(I),
        rdata           => s_rdata_v((I+1)*32-1 downto I*32),
        wen             => data_wen(I),
        wdata           => wdata,
        empty           => empty(I),
        full            => full(I),
        full_almost     => OPEN,
        empty_threshold => empty_almost(I),
        full_threshold  => full_almost(I) );
    
  END GENERATE generate_all_fifo;

  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  
  all_channel: FOR I IN 3 DOWNTO 0 GENERATE

    PROCESS (clk, rstn)
    BEGIN
      IF rstn = '0' THEN
        fifo_buffer_time(48*(I+1)-1 DOWNTO 48*I) <= (OTHERS => '0');
      ELSIF clk'event AND clk = '1' THEN
        IF run = '0' THEN
          fifo_buffer_time(48*(I+1)-1 DOWNTO 48*I) <= (OTHERS => '0');
        ELSE
          IF arbiter_time_out_new(I) = '0' THEN
            fifo_buffer_time(48*(I+1)-1 DOWNTO 48*I) <= arbiter_time_out;
          END IF;
        END IF;
      END IF;
    END PROCESS;
        
    lpp_waveform_fsmdma_I: lpp_waveform_fsmdma
      PORT MAP (
        clk                  => clk,
        rstn                 => rstn,
        run                  => run,
        
        fifo_buffer_time     => fifo_buffer_time(48*(I+1)-1 DOWNTO 48*I),
        
        fifo_data            => s_rdata_v(32*(I+1)-1 DOWNTO 32*I),             
        fifo_empty           => empty(I),
        fifo_empty_threshold => empty_almost(I),
        fifo_ren             => data_ren(I),        
        
        dma_fifo_valid_burst => dma_fifo_valid_burst(I),
        dma_fifo_data        => dma_fifo_data(32*(I+1)-1 DOWNTO 32*I),
        dma_fifo_ren         => dma_fifo_ren(I),
        dma_buffer_new       => dma_buffer_new(I),
        dma_buffer_addr      => dma_buffer_addr(32*(I+1)-1 DOWNTO 32*I),
        dma_buffer_length    => dma_buffer_length(26*(I+1)-1 DOWNTO 26*I),
        dma_buffer_full      => dma_buffer_full(I),
        dma_buffer_full_err  => dma_buffer_full_err(I),
        
        status_buffer_ready  => status_buffer_ready(I),                 -- TODO
        addr_buffer          => addr_buffer(32*(I+1)-1 DOWNTO 32*I),    -- TODO
        length_buffer        => length_buffer,--(26*(I+1)-1 DOWNTO 26*I),  -- TODO
        ready_buffer         => ready_buffer(I),                        -- TODO
        buffer_time          => buffer_time(48*(I+1)-1 DOWNTO 48*I),    -- TODO
        error_buffer_full    => error_buffer_full(I));                  -- TODO
    
  END GENERATE all_channel;

  
END beh;
