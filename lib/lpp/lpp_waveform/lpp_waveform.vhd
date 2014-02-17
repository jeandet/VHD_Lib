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

LIBRARY techmap;
USE techmap.gencomp.ALL;

ENTITY lpp_waveform IS
  
  GENERIC (
    tech                   : INTEGER := inferred;
    data_size              : INTEGER := 96;  --16*6
    nb_data_by_buffer_size : INTEGER := 11;
    nb_word_by_buffer_size : INTEGER := 11;
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
    nb_word_by_buffer : IN  STD_LOGIC_VECTOR(nb_word_by_buffer_size-1 DOWNTO 0);
    nb_snapshot_param : IN  STD_LOGIC_VECTOR(nb_snapshot_param_size-1 DOWNTO 0);
    status_full       : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    status_full_ack   : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    status_full_err   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    status_new_err    : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);  -- New data f(i) before the current data is write by dma
    ---------------------------------------------------------------------------
    -- INPUT
    coarse_time       : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    fine_time         : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);

    --f0
    addr_data_f0     : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    data_f0_in_valid : IN STD_LOGIC;
    data_f0_in       : IN STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
    --f1
    addr_data_f1     : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    data_f1_in_valid : IN STD_LOGIC;
    data_f1_in       : IN STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
    --f2
    addr_data_f2     : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    data_f2_in_valid : IN STD_LOGIC;
    data_f2_in       : IN STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
    --f3
    addr_data_f3     : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    data_f3_in_valid : IN STD_LOGIC;
    data_f3_in       : IN STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);

    ---------------------------------------------------------------------------
    -- OUTPUT
    --f0
    data_f0_addr_out             : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    data_f0_data_out             : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    data_f0_data_out_valid       : OUT STD_LOGIC;
    data_f0_data_out_valid_burst : OUT STD_LOGIC;
    data_f0_data_out_ren         : IN  STD_LOGIC;
    --f1
    data_f1_addr_out             : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    data_f1_data_out             : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    data_f1_data_out_valid       : OUT STD_LOGIC;
    data_f1_data_out_valid_burst : OUT STD_LOGIC;
    data_f1_data_out_ren         : IN  STD_LOGIC;
    --f2
    data_f2_addr_out             : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    data_f2_data_out             : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    data_f2_data_out_valid       : OUT STD_LOGIC;
    data_f2_data_out_valid_burst : OUT STD_LOGIC;
    data_f2_data_out_ren         : IN  STD_LOGIC;
    --f3
    data_f3_addr_out             : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    data_f3_data_out             : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    data_f3_data_out_valid       : OUT STD_LOGIC;
    data_f3_data_out_valid_burst : OUT STD_LOGIC;
    data_f3_data_out_ren         : IN  STD_LOGIC;

    ---------------------------------------------------------------------------
    --
    observation_reg : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    

    ----debug SNAPSHOT OUT
    --debug_f0_data       : OUT STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
    --debug_f0_data_valid : OUT STD_LOGIC;
    --debug_f1_data       : OUT STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
    --debug_f1_data_valid : OUT STD_LOGIC;
    --debug_f2_data       : OUT STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
    --debug_f2_data_valid : OUT STD_LOGIC;
    --debug_f3_data       : OUT STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
    --debug_f3_data_valid : OUT STD_LOGIC;

    ----debug FIFO IN
    --debug_f0_data_fifo_in       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    --debug_f0_data_fifo_in_valid : OUT STD_LOGIC;
    --debug_f1_data_fifo_in       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    --debug_f1_data_fifo_in_valid : OUT STD_LOGIC;
    --debug_f2_data_fifo_in       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    --debug_f2_data_fifo_in_valid : OUT STD_LOGIC;
    --debug_f3_data_fifo_in       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    --debug_f3_data_fifo_in_valid : OUT STD_LOGIC

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
  SIGNAL s_rdata        : STD_LOGIC_VECTOR(31 DOWNTO 0);

  --

  SIGNAL observation_reg_s : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL status_full_s       : STD_LOGIC_VECTOR(3 DOWNTO 0);
  
BEGIN  -- beh

  -----------------------------------------------------------------------------
  -- DEBUG
  -----------------------------------------------------------------------------
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      observation_reg <= (OTHERS => '0');
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      observation_reg <= observation_reg_s;
    END IF;
  END PROCESS;
  observation_reg_s( 2 DOWNTO  0) <= start_snapshot_f2 & start_snapshot_f1 & start_snapshot_f0;
  observation_reg_s( 5 DOWNTO  3) <= data_f2_out_valid & data_f1_out_valid & data_f0_out_valid;
  observation_reg_s( 8 DOWNTO  6) <= status_full_s(2 DOWNTO 0) ;
  observation_reg_s(11 DOWNTO  9) <= status_full_ack(2 DOWNTO 0);
  observation_reg_s(14 DOWNTO 12) <= data_wen(2 DOWNTO 0);
  observation_reg_s(31 DOWNTO 15) <= (OTHERS => '0');
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

  all_bit_of_data_out : FOR I IN 95 DOWNTO 0 GENERATE
    data_out(0, I) <= data_f0_out(I);
    data_out(1, I) <= data_f1_out(I);
    data_out(2, I) <= data_f2_out(I);
    data_out(3, I) <= data_f3_out(I);
  END GENERATE all_bit_of_data_out;

  -----------------------------------------------------------------------------
  -- TODO : debug
  -----------------------------------------------------------------------------
  all_bit_of_time_out : FOR I IN 47 DOWNTO 0 GENERATE
    all_sample_of_time_out : FOR J IN 3 DOWNTO 0 GENERATE
      time_out_2(J, I) <= time_out(J)(I);
    END GENERATE all_sample_of_time_out;
  END GENERATE all_bit_of_time_out;

  -- DEBUG --
  --time_out_debug(0) <= x"0A0A" & x"0A0A0A0A";
  --time_out_debug(1) <= x"1B1B" & x"1B1B1B1B";
  --time_out_debug(2) <= x"2C2C" & x"2C2C2C2C";
  --time_out_debug(3) <= x"3D3D" & x"3D3D3D3D";

  --all_bit_of_time_out : FOR I IN 47 DOWNTO 0 GENERATE
  --  all_sample_of_time_out : FOR J IN 3 DOWNTO 0 GENERATE
  --    time_out_2(J, I) <= time_out_debug(J)(I);
  --  END GENERATE all_sample_of_time_out;
  --END GENERATE all_bit_of_time_out;
  -- DEBUG --

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
      full         => full);

  -----------------------------------------------------------------------------
  -- DEBUG -- SNAPSHOT IN
  --debug_f0_data_fifo_in_valid <= NOT data_wen(0);
  --debug_f0_data_fifo_in       <= wdata;
  --debug_f1_data_fifo_in_valid <= NOT data_wen(1);
  --debug_f1_data_fifo_in       <= wdata;
  --debug_f2_data_fifo_in_valid <= NOT data_wen(2);
  --debug_f2_data_fifo_in       <= wdata;
  --debug_f3_data_fifo_in_valid <= NOT data_wen(3);
  --debug_f3_data_fifo_in       <= wdata;s
  -----------------------------------------------------------------------------

  lpp_waveform_fifo_1 : lpp_waveform_fifo
    GENERIC MAP (tech => tech)
    PORT MAP (
      clk  => clk,
      rstn => rstn,
      run  => run,

      empty        => s_empty,
      empty_almost => s_empty_almost,
      data_ren     => s_data_ren,
      rdata        => s_rdata,


      full_almost => full_almost,
      full        => full,
      data_wen    => data_wen,
      wdata       => wdata);

  lpp_waveform_fifo_headreg_1 : lpp_waveform_fifo_headreg
    GENERIC MAP (tech => tech)
    PORT MAP (
      clk            => clk,
      rstn           => rstn,
      run            => run,
      o_empty_almost => empty_almost,
      o_empty        => empty,

      o_data_ren => data_ren,
      o_rdata_0  => data_f0_data_out,
      o_rdata_1  => data_f1_data_out,
      o_rdata_2  => data_f2_data_out,
      o_rdata_3  => data_f3_data_out,

      i_empty_almost => s_empty_almost,
      i_empty        => s_empty,
      i_data_ren     => s_data_ren,
      i_rdata        => s_rdata);


  --data_f0_data_out <= rdata;
  --data_f1_data_out <= rdata;
  --data_f2_data_out <= rdata;
  --data_f3_data_out <= rdata;

  data_ren <= data_f3_data_out_ren &
              data_f2_data_out_ren &
              data_f1_data_out_ren &
              data_f0_data_out_ren;
  
  lpp_waveform_gen_address_1 : lpp_waveform_genaddress
    GENERIC MAP (
      nb_data_by_buffer_size => nb_word_by_buffer_size)
    PORT MAP (
      clk  => clk,
      rstn => rstn,
      run  => run,

      -------------------------------------------------------------------------
      -- CONFIG
      -------------------------------------------------------------------------
      nb_data_by_buffer => nb_word_by_buffer,

      addr_data_f0 => addr_data_f0,
      addr_data_f1 => addr_data_f1,
      addr_data_f2 => addr_data_f2,
      addr_data_f3 => addr_data_f3,
      -------------------------------------------------------------------------
      -- CTRL
      -------------------------------------------------------------------------
      -- IN
      empty        => empty,
      empty_almost => empty_almost,
      data_ren     => data_ren,

      -------------------------------------------------------------------------
      -- STATUS
      -------------------------------------------------------------------------
      status_full     => status_full_s,
      status_full_ack => status_full_ack,
      status_full_err => status_full_err,

      -------------------------------------------------------------------------
      -- ADDR DATA OUT
      -------------------------------------------------------------------------
      data_f0_data_out_valid_burst => data_f0_data_out_valid_burst,
      data_f1_data_out_valid_burst => data_f1_data_out_valid_burst,
      data_f2_data_out_valid_burst => data_f2_data_out_valid_burst,
      data_f3_data_out_valid_burst => data_f3_data_out_valid_burst,

      data_f0_data_out_valid => data_f0_data_out_valid,
      data_f1_data_out_valid => data_f1_data_out_valid,
      data_f2_data_out_valid => data_f2_data_out_valid,
      data_f3_data_out_valid => data_f3_data_out_valid,

      data_f0_addr_out => data_f0_addr_out,
      data_f1_addr_out => data_f1_addr_out,
      data_f2_addr_out => data_f2_addr_out,
      data_f3_addr_out => data_f3_addr_out
      );
  status_full <= status_full_s;
  
END beh;
