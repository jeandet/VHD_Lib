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
----------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
LIBRARY grlib;
USE grlib.amba.ALL;
USE grlib.stdlib.ALL;
USE grlib.devices.ALL;
LIBRARY lpp;
USE lpp.lpp_lfr_pkg.ALL;
--USE lpp.lpp_amba.ALL;
USE lpp.apb_devices_list.ALL;
USE lpp.lpp_memory.ALL;
LIBRARY techmap;
USE techmap.gencomp.ALL;

ENTITY lpp_lfr_apbreg IS
  GENERIC (
    nb_data_by_buffer_size : INTEGER := 11;
    nb_word_by_buffer_size : INTEGER := 11;
    nb_snapshot_param_size : INTEGER := 11;
    delta_vector_size      : INTEGER := 20;
    delta_vector_size_f0_2 : INTEGER := 3;

    pindex          : INTEGER                       := 4;
    paddr           : INTEGER                       := 4;
    pmask           : INTEGER                       := 16#fff#;
    pirq_ms         : INTEGER                       := 0;
    pirq_wfp        : INTEGER                       := 1;
    top_lfr_version : STD_LOGIC_VECTOR(23 DOWNTO 0) := X"000000");
  PORT (
    -- AMBA AHB system signals
    HCLK    : IN STD_ULOGIC;
    HRESETn : IN STD_ULOGIC;

    -- AMBA APB Slave Interface
    apbi : IN  apb_slv_in_type;
    apbo : OUT apb_slv_out_type;

    ---------------------------------------------------------------------------
    -- Spectral Matrix Reg
    run_ms          : OUT STD_LOGIC;
    -- IN
    ready_matrix_f0 : IN  STD_LOGIC;
    ready_matrix_f1 : IN  STD_LOGIC;
    ready_matrix_f2 : IN  STD_LOGIC;

    error_bad_component_error : IN STD_LOGIC;
    error_buffer_full         : IN STD_LOGIC;                     --  TODO
    error_input_fifo_write    : IN STD_LOGIC_VECTOR(2 DOWNTO 0);  --  TODO

--    debug_reg : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

    -- OUT
    status_ready_matrix_f0 : OUT STD_LOGIC;
    status_ready_matrix_f1 : OUT STD_LOGIC;
    status_ready_matrix_f2 : OUT STD_LOGIC;

    config_active_interruption_onNewMatrix : OUT STD_LOGIC;
    config_active_interruption_onError     : OUT STD_LOGIC;

    addr_matrix_f0 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_matrix_f1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_matrix_f2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

    matrix_time_f0 : IN STD_LOGIC_VECTOR(47 DOWNTO 0);
    matrix_time_f1 : IN STD_LOGIC_VECTOR(47 DOWNTO 0);
    matrix_time_f2 : IN STD_LOGIC_VECTOR(47 DOWNTO 0);

    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------
    -- WaveForm picker Reg
    status_full     : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    status_full_ack : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    status_full_err : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    status_new_err  : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);

    -- OUT
    data_shaping_BW  : OUT STD_LOGIC;
    data_shaping_SP0 : OUT STD_LOGIC;
    data_shaping_SP1 : OUT STD_LOGIC;
    data_shaping_R0  : OUT STD_LOGIC;
    data_shaping_R1  : OUT STD_LOGIC;
    data_shaping_R2  : OUT STD_LOGIC;

    delta_snapshot    : OUT STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
    delta_f0          : OUT STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
    delta_f0_2        : OUT STD_LOGIC_VECTOR(delta_vector_size_f0_2-1 DOWNTO 0);
    delta_f1          : OUT STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
    delta_f2          : OUT STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
    nb_data_by_buffer : OUT STD_LOGIC_VECTOR(nb_data_by_buffer_size-1 DOWNTO 0);
    nb_word_by_buffer : OUT STD_LOGIC_VECTOR(nb_word_by_buffer_size-1 DOWNTO 0);
    nb_snapshot_param : OUT STD_LOGIC_VECTOR(nb_snapshot_param_size-1 DOWNTO 0);

    enable_f0 : OUT STD_LOGIC;
    enable_f1 : OUT STD_LOGIC;
    enable_f2 : OUT STD_LOGIC;
    enable_f3 : OUT STD_LOGIC;

    burst_f0 : OUT STD_LOGIC;
    burst_f1 : OUT STD_LOGIC;
    burst_f2 : OUT STD_LOGIC;

    run : OUT STD_LOGIC;

    addr_data_f0 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_data_f1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_data_f2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_data_f3 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    start_date   : OUT STD_LOGIC_VECTOR(30 DOWNTO 0);
    ---------------------------------------------------------------------------
    debug_signal : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    ---------------------------------------------------------------------------
    );

END lpp_lfr_apbreg;

ARCHITECTURE beh OF lpp_lfr_apbreg IS
  
  CONSTANT REVISION : INTEGER := 1;

  CONSTANT pconfig : apb_config_type := (
    0 => ahb_device_reg (VENDOR_LPP, LPP_LFR, 0, REVISION, pirq_wfp),
    1 => apb_iobar(paddr, pmask));

  TYPE lpp_SpectralMatrix_regs IS RECORD
    config_active_interruption_onNewMatrix : STD_LOGIC;
    config_active_interruption_onError     : STD_LOGIC;
    config_ms_run                          : STD_LOGIC;
    status_ready_matrix_f0_0               : STD_LOGIC;
    status_ready_matrix_f1_0               : STD_LOGIC;
    status_ready_matrix_f2_0               : STD_LOGIC;
    status_ready_matrix_f0_1               : STD_LOGIC;
    status_ready_matrix_f1_1               : STD_LOGIC;
    status_ready_matrix_f2_1               : STD_LOGIC;
    status_error_bad_component_error       : STD_LOGIC;
    status_error_buffer_full               : STD_LOGIC;
    status_error_input_fifo_write          : STD_LOGIC_VECTOR(2 DOWNTO 0);

    addr_matrix_f0_0 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_matrix_f0_1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_matrix_f1_0 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_matrix_f1_1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_matrix_f2_0 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_matrix_f2_1 : STD_LOGIC_VECTOR(31 DOWNTO 0);

    time_matrix_f0_0 : STD_LOGIC_VECTOR(47 DOWNTO 0);
    time_matrix_f0_1 : STD_LOGIC_VECTOR(47 DOWNTO 0);
    time_matrix_f1_0 : STD_LOGIC_VECTOR(47 DOWNTO 0);
    time_matrix_f1_1 : STD_LOGIC_VECTOR(47 DOWNTO 0);
    time_matrix_f2_0 : STD_LOGIC_VECTOR(47 DOWNTO 0);
    time_matrix_f2_1 : STD_LOGIC_VECTOR(47 DOWNTO 0);
  END RECORD;
  SIGNAL reg_sp : lpp_SpectralMatrix_regs;

  TYPE lpp_WaveformPicker_regs IS RECORD
    status_full       : STD_LOGIC_VECTOR(3 DOWNTO 0);
    status_full_err   : STD_LOGIC_VECTOR(3 DOWNTO 0);
    status_new_err    : STD_LOGIC_VECTOR(3 DOWNTO 0);
    data_shaping_BW   : STD_LOGIC;
    data_shaping_SP0  : STD_LOGIC;
    data_shaping_SP1  : STD_LOGIC;
    data_shaping_R0   : STD_LOGIC;
    data_shaping_R1   : STD_LOGIC;
    data_shaping_R2   : STD_LOGIC;
    delta_snapshot    : STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
    delta_f0          : STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
    delta_f0_2        : STD_LOGIC_VECTOR(delta_vector_size_f0_2-1 DOWNTO 0);
    delta_f1          : STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
    delta_f2          : STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
    nb_data_by_buffer : STD_LOGIC_VECTOR(nb_data_by_buffer_size-1 DOWNTO 0);
    nb_word_by_buffer : STD_LOGIC_VECTOR(nb_word_by_buffer_size-1 DOWNTO 0);
    nb_snapshot_param : STD_LOGIC_VECTOR(nb_snapshot_param_size-1 DOWNTO 0);
    enable_f0         : STD_LOGIC;
    enable_f1         : STD_LOGIC;
    enable_f2         : STD_LOGIC;
    enable_f3         : STD_LOGIC;
    burst_f0          : STD_LOGIC;
    burst_f1          : STD_LOGIC;
    burst_f2          : STD_LOGIC;
    run               : STD_LOGIC;
    addr_data_f0      : STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_data_f1      : STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_data_f2      : STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_data_f3      : STD_LOGIC_VECTOR(31 DOWNTO 0);
    start_date        : STD_LOGIC_VECTOR(30 DOWNTO 0);
  END RECORD;
  SIGNAL reg_wp : lpp_WaveformPicker_regs;

  SIGNAL prdata : STD_LOGIC_VECTOR(31 DOWNTO 0);

  -----------------------------------------------------------------------------
  -- IRQ
  -----------------------------------------------------------------------------
  CONSTANT IRQ_WFP_SIZE  : INTEGER := 12;
  SIGNAL   irq_wfp_ZERO  : STD_LOGIC_VECTOR(IRQ_WFP_SIZE-1 DOWNTO 0);
  SIGNAL   irq_wfp_reg_s : STD_LOGIC_VECTOR(IRQ_WFP_SIZE-1 DOWNTO 0);
  SIGNAL   irq_wfp_reg   : STD_LOGIC_VECTOR(IRQ_WFP_SIZE-1 DOWNTO 0);
  SIGNAL   irq_wfp       : STD_LOGIC_VECTOR(IRQ_WFP_SIZE-1 DOWNTO 0);
  SIGNAL   ored_irq_wfp  : STD_LOGIC;

  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  SIGNAL reg0_ready_matrix_f0 : STD_LOGIC;
  SIGNAL reg0_addr_matrix_f0  : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL reg0_matrix_time_f0  : STD_LOGIC_VECTOR(47 DOWNTO 0);

  SIGNAL reg1_ready_matrix_f0 : STD_LOGIC;
  SIGNAL reg1_addr_matrix_f0  : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL reg1_matrix_time_f0  : STD_LOGIC_VECTOR(47 DOWNTO 0);

  SIGNAL reg0_ready_matrix_f1 : STD_LOGIC;
  SIGNAL reg0_addr_matrix_f1  : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL reg0_matrix_time_f1  : STD_LOGIC_VECTOR(47 DOWNTO 0);

  SIGNAL reg1_ready_matrix_f1 : STD_LOGIC;
  SIGNAL reg1_addr_matrix_f1  : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL reg1_matrix_time_f1  : STD_LOGIC_VECTOR(47 DOWNTO 0);

  SIGNAL reg0_ready_matrix_f2 : STD_LOGIC;
  SIGNAL reg0_addr_matrix_f2  : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL reg0_matrix_time_f2  : STD_LOGIC_VECTOR(47 DOWNTO 0);

  SIGNAL reg1_ready_matrix_f2 : STD_LOGIC;
  SIGNAL reg1_addr_matrix_f2  : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL reg1_matrix_time_f2  : STD_LOGIC_VECTOR(47 DOWNTO 0);
  SIGNAL apbo_irq_ms : STD_LOGIC;
  SIGNAL apbo_irq_wfp : STD_LOGIC;
  
BEGIN  -- beh

--  status_ready_matrix_f0 <= reg_sp.status_ready_matrix_f0;
--  status_ready_matrix_f1 <= reg_sp.status_ready_matrix_f1;
--  status_ready_matrix_f2 <= reg_sp.status_ready_matrix_f2;

  config_active_interruption_onNewMatrix <= reg_sp.config_active_interruption_onNewMatrix;
  config_active_interruption_onError     <= reg_sp.config_active_interruption_onError;


--  addr_matrix_f0                         <= reg_sp.addr_matrix_f0;
--  addr_matrix_f1                         <= reg_sp.addr_matrix_f1;
--  addr_matrix_f2                         <= reg_sp.addr_matrix_f2;


  data_shaping_BW  <= NOT reg_wp.data_shaping_BW;
  data_shaping_SP0 <= reg_wp.data_shaping_SP0;
  data_shaping_SP1 <= reg_wp.data_shaping_SP1;
  data_shaping_R0  <= reg_wp.data_shaping_R0;
  data_shaping_R1  <= reg_wp.data_shaping_R1;
  data_shaping_R2  <= reg_wp.data_shaping_R2;

  delta_snapshot    <= reg_wp.delta_snapshot;
  delta_f0          <= reg_wp.delta_f0;
  delta_f0_2        <= reg_wp.delta_f0_2;
  delta_f1          <= reg_wp.delta_f1;
  delta_f2          <= reg_wp.delta_f2;
  nb_data_by_buffer <= reg_wp.nb_data_by_buffer;
  nb_word_by_buffer <= reg_wp.nb_word_by_buffer;
  nb_snapshot_param <= reg_wp.nb_snapshot_param;

  enable_f0 <= reg_wp.enable_f0;
  enable_f1 <= reg_wp.enable_f1;
  enable_f2 <= reg_wp.enable_f2;
  enable_f3 <= reg_wp.enable_f3;

  burst_f0 <= reg_wp.burst_f0;
  burst_f1 <= reg_wp.burst_f1;
  burst_f2 <= reg_wp.burst_f2;

  run <= reg_wp.run;

  addr_data_f0 <= reg_wp.addr_data_f0;
  addr_data_f1 <= reg_wp.addr_data_f1;
  addr_data_f2 <= reg_wp.addr_data_f2;
  addr_data_f3 <= reg_wp.addr_data_f3;

  start_date <= reg_wp.start_date;

  lpp_lfr_apbreg : PROCESS (HCLK, HRESETn)
    VARIABLE paddr : STD_LOGIC_VECTOR(7 DOWNTO 2);
  BEGIN  -- PROCESS lpp_dma_top
    IF HRESETn = '0' THEN               -- asynchronous reset (active low)
      reg_sp.config_active_interruption_onNewMatrix <= '0';
      reg_sp.config_active_interruption_onError     <= '0';
      reg_sp.config_ms_run                          <= '1';
      reg_sp.status_ready_matrix_f0_0               <= '0';
      reg_sp.status_ready_matrix_f1_0               <= '0';
      reg_sp.status_ready_matrix_f2_0               <= '0';
      reg_sp.status_ready_matrix_f0_1               <= '0';
      reg_sp.status_ready_matrix_f1_1               <= '0';
      reg_sp.status_ready_matrix_f2_1               <= '0';
      reg_sp.status_error_bad_component_error       <= '0';
      reg_sp.status_error_buffer_full               <= '0';
      reg_sp.status_error_input_fifo_write          <= (OTHERS => '0');

      reg_sp.addr_matrix_f0_0 <= (OTHERS => '0');
      reg_sp.addr_matrix_f1_0 <= (OTHERS => '0');
      reg_sp.addr_matrix_f2_0 <= (OTHERS => '0');

      reg_sp.addr_matrix_f0_1 <= (OTHERS => '0');
      reg_sp.addr_matrix_f1_1 <= (OTHERS => '0');
      reg_sp.addr_matrix_f2_1 <= (OTHERS => '0');

--      reg_sp.time_matrix_f0_0 <= (OTHERS => '0');  -- ok
--      reg_sp.time_matrix_f1_0 <= (OTHERS => '0');  -- ok
--      reg_sp.time_matrix_f2_0 <= (OTHERS => '0');  -- ok

--      reg_sp.time_matrix_f0_1 <= (OTHERS => '0');  -- ok
      --reg_sp.time_matrix_f1_1 <= (OTHERS => '0');  -- ok
--      reg_sp.time_matrix_f2_1 <= (OTHERS => '0');  -- ok

      prdata <= (OTHERS => '0');

      
      apbo_irq_ms <= '0';
      apbo_irq_wfp <= '0';
      

      status_full_ack <= (OTHERS => '0');

      reg_wp.data_shaping_BW   <= '0';
      reg_wp.data_shaping_SP0  <= '0';
      reg_wp.data_shaping_SP1  <= '0';
      reg_wp.data_shaping_R0   <= '0';
      reg_wp.data_shaping_R1   <= '0';
      reg_wp.data_shaping_R2   <= '0';
      reg_wp.enable_f0         <= '0';
      reg_wp.enable_f1         <= '0';
      reg_wp.enable_f2         <= '0';
      reg_wp.enable_f3         <= '0';
      reg_wp.burst_f0          <= '0';
      reg_wp.burst_f1          <= '0';
      reg_wp.burst_f2          <= '0';
      reg_wp.run               <= '0';
      reg_wp.addr_data_f0      <= (OTHERS => '0');
      reg_wp.addr_data_f1      <= (OTHERS => '0');
      reg_wp.addr_data_f2      <= (OTHERS => '0');
      reg_wp.addr_data_f3      <= (OTHERS => '0');
      reg_wp.status_full       <= (OTHERS => '0');
      reg_wp.status_full_err   <= (OTHERS => '0');
      reg_wp.status_new_err    <= (OTHERS => '0');
      reg_wp.delta_snapshot    <= (OTHERS => '0');
      reg_wp.delta_f0          <= (OTHERS => '0');
      reg_wp.delta_f0_2        <= (OTHERS => '0');
      reg_wp.delta_f1          <= (OTHERS => '0');
      reg_wp.delta_f2          <= (OTHERS => '0');
      reg_wp.nb_data_by_buffer <= (OTHERS => '0');
      reg_wp.nb_snapshot_param <= (OTHERS => '0');
      reg_wp.start_date        <= (OTHERS => '0');
      
    ELSIF HCLK'EVENT AND HCLK = '1' THEN  -- rising clock edge

      status_full_ack <= (OTHERS => '0');

      reg_sp.status_ready_matrix_f0_0 <= reg_sp.status_ready_matrix_f0_0 OR reg0_ready_matrix_f0;
      reg_sp.status_ready_matrix_f1_0 <= reg_sp.status_ready_matrix_f1_0 OR reg0_ready_matrix_f1;
      reg_sp.status_ready_matrix_f2_0 <= reg_sp.status_ready_matrix_f2_0 OR reg0_ready_matrix_f2;

      reg_sp.status_ready_matrix_f0_1 <= reg_sp.status_ready_matrix_f0_1 OR reg1_ready_matrix_f0;
      reg_sp.status_ready_matrix_f1_1 <= reg_sp.status_ready_matrix_f1_1 OR reg1_ready_matrix_f1;
      reg_sp.status_ready_matrix_f2_1 <= reg_sp.status_ready_matrix_f2_1 OR reg1_ready_matrix_f2;

      reg_sp.status_error_bad_component_error <= reg_sp.status_error_bad_component_error OR error_bad_component_error;

      reg_sp.status_error_buffer_full         <= reg_sp.status_error_buffer_full OR error_buffer_full;
      reg_sp.status_error_input_fifo_write(0) <= reg_sp.status_error_input_fifo_write(0) OR error_input_fifo_write(0);
      reg_sp.status_error_input_fifo_write(1) <= reg_sp.status_error_input_fifo_write(1) OR error_input_fifo_write(1);
      reg_sp.status_error_input_fifo_write(2) <= reg_sp.status_error_input_fifo_write(2) OR error_input_fifo_write(2);



      all_status : FOR I IN 3 DOWNTO 0 LOOP
        reg_wp.status_full(I)     <= status_full(I) AND reg_wp.run;
        reg_wp.status_full_err(I) <= status_full_err(I) AND reg_wp.run;
        reg_wp.status_new_err(I)  <= status_new_err(I) AND reg_wp.run;
      END LOOP all_status;

      paddr             := "000000";
      paddr(7 DOWNTO 2) := apbi.paddr(7 DOWNTO 2);
      prdata            <= (OTHERS => '0');
      IF apbi.psel(pindex) = '1' THEN
        -- APB DMA READ  --
        CASE paddr(7 DOWNTO 2) IS
          --0
          WHEN "000000" => prdata(0) <= reg_sp.config_active_interruption_onNewMatrix;
                           prdata(1) <= reg_sp.config_active_interruption_onError;
                           prdata(2) <= reg_sp.config_ms_run;
                           --1
          WHEN "000001" => prdata(0) <= reg_sp.status_ready_matrix_f0_0;
                           prdata(1)  <= reg_sp.status_ready_matrix_f0_1;
                           prdata(2)  <= reg_sp.status_ready_matrix_f1_0;
                           prdata(3)  <= reg_sp.status_ready_matrix_f1_1;
                           prdata(4)  <= reg_sp.status_ready_matrix_f2_0;
                           prdata(5)  <= reg_sp.status_ready_matrix_f2_1;
                           prdata(6)  <= reg_sp.status_error_bad_component_error;
                           prdata(7)  <= reg_sp.status_error_buffer_full;
                           prdata(8)  <= reg_sp.status_error_input_fifo_write(0);
                           prdata(9)  <= reg_sp.status_error_input_fifo_write(1);
                           prdata(10) <= reg_sp.status_error_input_fifo_write(2);
                           --2
          WHEN "000010" => prdata              <= reg_sp.addr_matrix_f0_0;
                           --3
          WHEN "000011" => prdata              <= reg_sp.addr_matrix_f0_1;
                           --4
          WHEN "000100" => prdata              <= reg_sp.addr_matrix_f1_0;
                           --5
          WHEN "000101" => prdata              <= reg_sp.addr_matrix_f1_1;
                           --6
          WHEN "000110" => prdata              <= reg_sp.addr_matrix_f2_0;
                           --7
          WHEN "000111" => prdata              <= reg_sp.addr_matrix_f2_1;
                           --8
          WHEN "001000" => prdata              <= reg_sp.time_matrix_f0_0(47 DOWNTO 16);
                           --9
          WHEN "001001" => prdata(15 DOWNTO 0) <= reg_sp.time_matrix_f0_0(15 DOWNTO 0);
                           --10
          WHEN "001010" => prdata              <= reg_sp.time_matrix_f0_1(47 DOWNTO 16);
                           --11
          WHEN "001011" => prdata(15 DOWNTO 0) <= reg_sp.time_matrix_f0_1(15 DOWNTO 0);
                           --12
          WHEN "001100" => prdata              <= reg_sp.time_matrix_f1_0(47 DOWNTO 16);
                           --13
          WHEN "001101" => prdata(15 DOWNTO 0) <= reg_sp.time_matrix_f1_0(15 DOWNTO 0);
                           --14
          WHEN "001110" => prdata              <= reg_sp.time_matrix_f1_1(47 DOWNTO 16);
                           --15
          WHEN "001111" => prdata(15 DOWNTO 0) <= reg_sp.time_matrix_f1_1(15 DOWNTO 0);
                           --16
          WHEN "010000" => prdata              <= reg_sp.time_matrix_f2_0(47 DOWNTO 16);
                           --17
          WHEN "010001" => prdata(15 DOWNTO 0) <= reg_sp.time_matrix_f2_0(15 DOWNTO 0);
                           --18
          WHEN "010010" => prdata              <= reg_sp.time_matrix_f2_1(47 DOWNTO 16);
                           --19
          WHEN "010011" => prdata(15 DOWNTO 0) <= reg_sp.time_matrix_f2_1(15 DOWNTO 0);
                           ---------------------------------------------------------------------
                           --20
          WHEN "010100" => prdata(0)           <= reg_wp.data_shaping_BW;
                           prdata(1) <= reg_wp.data_shaping_SP0;
                           prdata(2) <= reg_wp.data_shaping_SP1;
                           prdata(3) <= reg_wp.data_shaping_R0;
                           prdata(4) <= reg_wp.data_shaping_R1;
                           prdata(5) <= reg_wp.data_shaping_R2;
                           --21
          WHEN "010101" => prdata(0) <= reg_wp.enable_f0;
                           prdata(1) <= reg_wp.enable_f1;
                           prdata(2) <= reg_wp.enable_f2;
                           prdata(3) <= reg_wp.enable_f3;
                           prdata(4) <= reg_wp.burst_f0;
                           prdata(5) <= reg_wp.burst_f1;
                           prdata(6) <= reg_wp.burst_f2;
                           prdata(7) <= reg_wp.run;
                           --22
          WHEN "010110" => prdata             <= reg_wp.addr_data_f0;
                           --23
          WHEN "010111" => prdata             <= reg_wp.addr_data_f1;
                           --24
          WHEN "011000" => prdata             <= reg_wp.addr_data_f2;
                           --25
          WHEN "011001" => prdata             <= reg_wp.addr_data_f3;
                           --26
          WHEN "011010" => prdata(3 DOWNTO 0) <= reg_wp.status_full;
                           prdata(7 DOWNTO 4)  <= reg_wp.status_full_err;
                           prdata(11 DOWNTO 8) <= reg_wp.status_new_err;
                           --27
          WHEN "011011" => prdata(delta_vector_size-1 DOWNTO 0)      <= reg_wp.delta_snapshot;
                           --28
          WHEN "011100" => prdata(delta_vector_size-1 DOWNTO 0)      <= reg_wp.delta_f0;
                           --29
          WHEN "011101" => prdata(delta_vector_size_f0_2-1 DOWNTO 0) <= reg_wp.delta_f0_2;
                           --30
          WHEN "011110" => prdata(delta_vector_size-1 DOWNTO 0)      <= reg_wp.delta_f1;
                           --31
          WHEN "011111" => prdata(delta_vector_size-1 DOWNTO 0)      <= reg_wp.delta_f2;
                           --32
          WHEN "100000" => prdata(nb_data_by_buffer_size-1 DOWNTO 0) <= reg_wp.nb_data_by_buffer;
                           --33
          WHEN "100001" => prdata(nb_snapshot_param_size-1 DOWNTO 0) <= reg_wp.nb_snapshot_param;
                           --34
          WHEN "100010" => prdata(30 DOWNTO 0)                       <= reg_wp.start_date;
                           --35
          WHEN "100011" => prdata(nb_word_by_buffer_size-1 DOWNTO 0) <= reg_wp.nb_word_by_buffer;
                           ----------------------------------------------------
          WHEN "111100" => prdata(23 DOWNTO 0)                       <= top_lfr_version(23 DOWNTO 0);
          WHEN OTHERS   => NULL;
                           
        END CASE;
        IF (apbi.pwrite AND apbi.penable) = '1' THEN
          -- APB DMA WRITE --
          CASE paddr(7 DOWNTO 2) IS
            --
            WHEN "000000" => reg_sp.config_active_interruption_onNewMatrix <= apbi.pwdata(0);
                             reg_sp.config_active_interruption_onError <= apbi.pwdata(1);
                             reg_sp.config_ms_run                      <= apbi.pwdata(2);
                             
            WHEN "000001" =>
              reg_sp.status_ready_matrix_f0_0         <= ((NOT apbi.pwdata(0) ) AND reg_sp.status_ready_matrix_f0_0        ) OR reg0_ready_matrix_f0;
              reg_sp.status_ready_matrix_f0_1         <= ((NOT apbi.pwdata(1) ) AND reg_sp.status_ready_matrix_f0_1        ) OR reg1_ready_matrix_f0;
              reg_sp.status_ready_matrix_f1_0         <= ((NOT apbi.pwdata(2) ) AND reg_sp.status_ready_matrix_f1_0        ) OR reg0_ready_matrix_f1;
              reg_sp.status_ready_matrix_f1_1         <= ((NOT apbi.pwdata(3) ) AND reg_sp.status_ready_matrix_f1_1        ) OR reg1_ready_matrix_f1;
              reg_sp.status_ready_matrix_f2_0         <= ((NOT apbi.pwdata(4) ) AND reg_sp.status_ready_matrix_f2_0        ) OR reg0_ready_matrix_f2;
              reg_sp.status_ready_matrix_f2_1         <= ((NOT apbi.pwdata(5) ) AND reg_sp.status_ready_matrix_f2_1        ) OR reg1_ready_matrix_f2;
              reg_sp.status_error_bad_component_error <= ((NOT apbi.pwdata(6) ) AND reg_sp.status_error_bad_component_error) OR error_bad_component_error;
              reg_sp.status_error_buffer_full         <= ((NOT apbi.pwdata(7) ) AND reg_sp.status_error_buffer_full        ) OR error_buffer_full;
              reg_sp.status_error_input_fifo_write(0) <= ((NOT apbi.pwdata(8) ) AND reg_sp.status_error_input_fifo_write(0)) OR error_input_fifo_write(0);
              reg_sp.status_error_input_fifo_write(1) <= ((NOT apbi.pwdata(9) ) AND reg_sp.status_error_input_fifo_write(1)) OR error_input_fifo_write(1);
              reg_sp.status_error_input_fifo_write(2) <= ((NOT apbi.pwdata(10)) AND reg_sp.status_error_input_fifo_write(2)) OR error_input_fifo_write(2);
              --2
            WHEN "000010" => reg_sp.addr_matrix_f0_0 <= apbi.pwdata;
            WHEN "000011" => reg_sp.addr_matrix_f0_1 <= apbi.pwdata;
            WHEN "000100" => reg_sp.addr_matrix_f1_0 <= apbi.pwdata;
            WHEN "000101" => reg_sp.addr_matrix_f1_1 <= apbi.pwdata;
            WHEN "000110" => reg_sp.addr_matrix_f2_0 <= apbi.pwdata;
            WHEN "000111" => reg_sp.addr_matrix_f2_1 <= apbi.pwdata;
                             --8 to 19
                             --20
            WHEN "010100" => reg_wp.data_shaping_BW  <= apbi.pwdata(0);
                             reg_wp.data_shaping_SP0 <= apbi.pwdata(1);
                             reg_wp.data_shaping_SP1 <= apbi.pwdata(2);
                             reg_wp.data_shaping_R0  <= apbi.pwdata(3);
                             reg_wp.data_shaping_R1  <= apbi.pwdata(4);
                             reg_wp.data_shaping_R2  <= apbi.pwdata(5);
            WHEN "010101" => reg_wp.enable_f0 <= apbi.pwdata(0);
                             reg_wp.enable_f1 <= apbi.pwdata(1);
                             reg_wp.enable_f2 <= apbi.pwdata(2);
                             reg_wp.enable_f3 <= apbi.pwdata(3);
                             reg_wp.burst_f0  <= apbi.pwdata(4);
                             reg_wp.burst_f1  <= apbi.pwdata(5);
                             reg_wp.burst_f2  <= apbi.pwdata(6);
                             reg_wp.run       <= apbi.pwdata(7);
                             --22
            WHEN "010110" => reg_wp.addr_data_f0 <= apbi.pwdata;
            WHEN "010111" => reg_wp.addr_data_f1 <= apbi.pwdata;
            WHEN "011000" => reg_wp.addr_data_f2 <= apbi.pwdata;
            WHEN "011001" => reg_wp.addr_data_f3 <= apbi.pwdata;
                             --26
            WHEN "011010" => reg_wp.status_full  <= apbi.pwdata(3 DOWNTO 0);
                             reg_wp.status_full_err <= apbi.pwdata(7 DOWNTO 4);
                             reg_wp.status_new_err  <= apbi.pwdata(11 DOWNTO 8);
                             status_full_ack(0)     <= reg_wp.status_full(0) AND NOT apbi.pwdata(0);
                             status_full_ack(1)     <= reg_wp.status_full(1) AND NOT apbi.pwdata(1);
                             status_full_ack(2)     <= reg_wp.status_full(2) AND NOT apbi.pwdata(2);
                             status_full_ack(3)     <= reg_wp.status_full(3) AND NOT apbi.pwdata(3);
            WHEN "011011" => reg_wp.delta_snapshot    <= apbi.pwdata(delta_vector_size-1 DOWNTO 0);
            WHEN "011100" => reg_wp.delta_f0          <= apbi.pwdata(delta_vector_size-1 DOWNTO 0);
            WHEN "011101" => reg_wp.delta_f0_2        <= apbi.pwdata(delta_vector_size_f0_2-1 DOWNTO 0);
            WHEN "011110" => reg_wp.delta_f1          <= apbi.pwdata(delta_vector_size-1 DOWNTO 0);
            WHEN "011111" => reg_wp.delta_f2          <= apbi.pwdata(delta_vector_size-1 DOWNTO 0);
            WHEN "100000" => reg_wp.nb_data_by_buffer <= apbi.pwdata(nb_data_by_buffer_size-1 DOWNTO 0);
            WHEN "100001" => reg_wp.nb_snapshot_param <= apbi.pwdata(nb_snapshot_param_size-1 DOWNTO 0);
            WHEN "100010" => reg_wp.start_date        <= apbi.pwdata(30 DOWNTO 0);
            WHEN "100011" => reg_wp.nb_word_by_buffer <= apbi.pwdata(nb_word_by_buffer_size-1 DOWNTO 0);
                             --
            WHEN OTHERS   => NULL;
          END CASE;
        END IF;
      END IF;
      --apbo.pirq(pirq_ms) <=
      apbo_irq_ms <= ((reg_sp.config_active_interruption_onNewMatrix AND (ready_matrix_f0 OR
                                                                                 ready_matrix_f1 OR
                                                                                 ready_matrix_f2)
                              )
                             OR
                             (reg_sp.config_active_interruption_onError AND (
                               error_bad_component_error
                               OR error_buffer_full
                               OR error_input_fifo_write(0)
                               OR error_input_fifo_write(1)
                               OR error_input_fifo_write(2))
                              ));
      -- apbo.pirq(pirq_wfp)
      apbo_irq_wfp<= ored_irq_wfp;
      
    END IF;
  END PROCESS lpp_lfr_apbreg;
  
  apbo.pirq(pirq_ms)  <= apbo_irq_ms;
  apbo.pirq(pirq_wfp) <= apbo_irq_wfp;
  
  apbo.pindex  <= pindex;
  apbo.pconfig <= pconfig;
  apbo.prdata  <= prdata;

  -----------------------------------------------------------------------------
  -- IRQ
  -----------------------------------------------------------------------------
  irq_wfp_reg_s <= status_full & status_full_err & status_new_err;

  PROCESS (HCLK, HRESETn)
  BEGIN  -- PROCESS
    IF HRESETn = '0' THEN                 -- asynchronous reset (active low)
      irq_wfp_reg <= (OTHERS => '0');
    ELSIF HCLK'EVENT AND HCLK = '1' THEN  -- rising clock edge
      irq_wfp_reg <= irq_wfp_reg_s;
    END IF;
  END PROCESS;

  all_irq_wfp : FOR I IN IRQ_WFP_SIZE-1 DOWNTO 0 GENERATE
    irq_wfp(I) <= (NOT irq_wfp_reg(I)) AND irq_wfp_reg_s(I);
  END GENERATE all_irq_wfp;

  irq_wfp_ZERO <= (OTHERS => '0');
  ored_irq_wfp <= '0' WHEN irq_wfp = irq_wfp_ZERO ELSE '1';

  run_ms <= reg_sp.config_ms_run;

  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  lpp_apbreg_ms_pointer_f0 : lpp_apbreg_ms_pointer
    PORT MAP (
      clk  => HCLK,
      rstn => HRESETn,

      reg0_status_ready_matrix => reg_sp.status_ready_matrix_f0_0,
      reg0_ready_matrix        => reg0_ready_matrix_f0,
      reg0_addr_matrix         => reg_sp.addr_matrix_f0_0,  --reg0_addr_matrix_f0,            
      reg0_matrix_time         => reg_sp.time_matrix_f0_0,  --reg0_matrix_time_f0,          

      reg1_status_ready_matrix => reg_sp.status_ready_matrix_f0_1,
      reg1_ready_matrix        => reg1_ready_matrix_f0,
      reg1_addr_matrix         => reg_sp.addr_matrix_f0_1,  --reg1_addr_matrix_f0,          
      reg1_matrix_time         => reg_sp.time_matrix_f0_1,  --reg1_matrix_time_f0,          

      ready_matrix        => ready_matrix_f0,
      status_ready_matrix => status_ready_matrix_f0,
      addr_matrix         => addr_matrix_f0,
      matrix_time         => matrix_time_f0);             

  lpp_apbreg_ms_pointer_f1 : lpp_apbreg_ms_pointer
    PORT MAP (
      clk  => HCLK,
      rstn => HRESETn,

      reg0_status_ready_matrix => reg_sp.status_ready_matrix_f1_0,
      reg0_ready_matrix        => reg0_ready_matrix_f1,
      reg0_addr_matrix         => reg_sp.addr_matrix_f1_0,  --reg0_addr_matrix_f1,
      reg0_matrix_time         => reg_sp.time_matrix_f1_0,  --reg0_matrix_time_f1,

      reg1_status_ready_matrix => reg_sp.status_ready_matrix_f1_1,
      reg1_ready_matrix        => reg1_ready_matrix_f1,
      reg1_addr_matrix         => reg_sp.addr_matrix_f1_1,  --reg1_addr_matrix_f1,
      reg1_matrix_time         => reg_sp.time_matrix_f1_1,  --reg1_matrix_time_f1,

      ready_matrix        => ready_matrix_f1,
      status_ready_matrix => status_ready_matrix_f1,
      addr_matrix         => addr_matrix_f1,
      matrix_time         => matrix_time_f1);

  lpp_apbreg_ms_pointer_f2 : lpp_apbreg_ms_pointer
    PORT MAP (
      clk  => HCLK,
      rstn => HRESETn,

      reg0_status_ready_matrix => reg_sp.status_ready_matrix_f2_0,
      reg0_ready_matrix        => reg0_ready_matrix_f2,
      reg0_addr_matrix         => reg_sp.addr_matrix_f2_0,  --reg0_addr_matrix_f2,
      reg0_matrix_time         => reg_sp.time_matrix_f2_0,  --reg0_matrix_time_f2,

      reg1_status_ready_matrix => reg_sp.status_ready_matrix_f2_1,
      reg1_ready_matrix        => reg1_ready_matrix_f2,
      reg1_addr_matrix         => reg_sp.addr_matrix_f2_1,  --reg1_addr_matrix_f2,
      reg1_matrix_time         => reg_sp.time_matrix_f2_1,  --reg1_matrix_time_f2,

      ready_matrix        => ready_matrix_f2,
      status_ready_matrix => status_ready_matrix_f2,
      addr_matrix         => addr_matrix_f2,
      matrix_time         => matrix_time_f2);

  -----------------------------------------------------------------------------
  debug_signal(31 DOWNTO 12) <= (OTHERS => '0');
  debug_signal(11 DOWNTO  0) <= apbo_irq_ms &  --11
                               reg_sp.status_error_input_fifo_write(2) &--10
                               reg_sp.status_error_input_fifo_write(1) &--9
                               reg_sp.status_error_input_fifo_write(0) &--8
                               reg_sp.status_error_buffer_full         & reg_sp.status_error_bad_component_error & --7 6
                               reg_sp.status_ready_matrix_f2_1         & reg_sp.status_ready_matrix_f2_0 &--5 4
                               reg_sp.status_ready_matrix_f1_1         & reg_sp.status_ready_matrix_f1_0 &--3 2
                               reg_sp.status_ready_matrix_f0_1         & reg_sp.status_ready_matrix_f0_0; --1 0
        
END beh;
