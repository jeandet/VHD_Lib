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
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY grlib;
USE grlib.amba.ALL;
USE grlib.stdlib.ALL;
USE grlib.devices.ALL;

LIBRARY lpp;
USE lpp.lpp_lfr_pkg.ALL;
USE lpp.apb_devices_list.ALL;
USE lpp.lpp_memory.ALL;
USE lpp.lpp_lfr_apbreg_pkg.ALL;

LIBRARY techmap;
USE techmap.gencomp.ALL;

ENTITY lpp_lfr_apbreg IS
  GENERIC (
    nb_data_by_buffer_size : INTEGER := 32;
    nb_snapshot_param_size : INTEGER := 32;
    delta_vector_size      : INTEGER := 32;
    delta_vector_size_f0_2 : INTEGER := 7;

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
--    run_ms          : OUT STD_LOGIC;
    -- IN
    ready_matrix_f0 : IN  STD_LOGIC;
    ready_matrix_f1 : IN  STD_LOGIC;
    ready_matrix_f2 : IN  STD_LOGIC;

--    error_bad_component_error : IN STD_LOGIC;
    error_buffer_full      : IN STD_LOGIC;                     --  TODO
    error_input_fifo_write : IN STD_LOGIC_VECTOR(2 DOWNTO 0);  --  TODO

--    debug_reg : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

    -- OUT
    status_ready_matrix_f0 : OUT STD_LOGIC;
    status_ready_matrix_f1 : OUT STD_LOGIC;
    status_ready_matrix_f2 : OUT STD_LOGIC;

    --config_active_interruption_onNewMatrix : OUT STD_LOGIC;
    --config_active_interruption_onError     : OUT STD_LOGIC;

    addr_matrix_f0 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_matrix_f1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_matrix_f2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

    length_matrix_f0 : OUT STD_LOGIC_VECTOR(25 DOWNTO 0);
    length_matrix_f1 : OUT STD_LOGIC_VECTOR(25 DOWNTO 0);
    length_matrix_f2 : OUT STD_LOGIC_VECTOR(25 DOWNTO 0);

    matrix_time_f0 : IN STD_LOGIC_VECTOR(47 DOWNTO 0);
    matrix_time_f1 : IN STD_LOGIC_VECTOR(47 DOWNTO 0);
    matrix_time_f2 : IN STD_LOGIC_VECTOR(47 DOWNTO 0);

    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------
    -- WaveForm picker Reg
    --status_full     : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    --status_full_ack : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    --status_full_err : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    status_new_err : IN STD_LOGIC_VECTOR(3 DOWNTO 0);

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
    --nb_word_by_buffer : OUT STD_LOGIC_VECTOR(nb_word_by_buffer_size-1 DOWNTO 0);
    nb_snapshot_param : OUT STD_LOGIC_VECTOR(nb_snapshot_param_size-1 DOWNTO 0);

    enable_f0 : OUT STD_LOGIC;
    enable_f1 : OUT STD_LOGIC;
    enable_f2 : OUT STD_LOGIC;
    enable_f3 : OUT STD_LOGIC;

    burst_f0 : OUT STD_LOGIC;
    burst_f1 : OUT STD_LOGIC;
    burst_f2 : OUT STD_LOGIC;

    run : OUT STD_LOGIC;

    start_date : OUT STD_LOGIC_VECTOR(30 DOWNTO 0);

    wfp_status_buffer_ready : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    wfp_addr_buffer         : OUT STD_LOGIC_VECTOR(32*4-1 DOWNTO 0);
    wfp_length_buffer       : OUT STD_LOGIC_VECTOR(25 DOWNTO 0);
    wfp_ready_buffer        : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    wfp_buffer_time         : IN  STD_LOGIC_VECTOR(48*4-1 DOWNTO 0);
    wfp_error_buffer_full   : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    ---------------------------------------------------------------------------
    sample_f3_v             : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
    sample_f3_e1            : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
    sample_f3_e2            : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
    sample_f3_valid         : IN  STD_LOGIC;
    ---------------------------------------------------------------------------
    debug_vector            : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)

    );

END lpp_lfr_apbreg;

ARCHITECTURE beh OF lpp_lfr_apbreg IS
  
  CONSTANT REVISION : INTEGER := 1;

  CONSTANT pconfig : apb_config_type := (
    0 => ahb_device_reg (lpp.apb_devices_list.VENDOR_LPP, lpp.apb_devices_list.LPP_LFR, 0, REVISION, pirq_wfp),
    1 => apb_iobar(paddr, pmask));

  --CONSTANT pconfig : apb_config_type := (
  --  0 => ahb_device_reg (16#19#, 16#19#, 0, REVISION, pirq_wfp),
  --  1 => apb_iobar(paddr, pmask));
  
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
--    status_error_bad_component_error       : STD_LOGIC;
    status_error_buffer_full               : STD_LOGIC;
    status_error_input_fifo_write          : STD_LOGIC_VECTOR(2 DOWNTO 0);

    addr_matrix_f0_0 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_matrix_f0_1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_matrix_f1_0 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_matrix_f1_1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_matrix_f2_0 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_matrix_f2_1 : STD_LOGIC_VECTOR(31 DOWNTO 0);

    length_matrix : STD_LOGIC_VECTOR(25 DOWNTO 0);

    time_matrix_f0_0 : STD_LOGIC_VECTOR(47 DOWNTO 0);
    time_matrix_f0_1 : STD_LOGIC_VECTOR(47 DOWNTO 0);
    time_matrix_f1_0 : STD_LOGIC_VECTOR(47 DOWNTO 0);
    time_matrix_f1_1 : STD_LOGIC_VECTOR(47 DOWNTO 0);
    time_matrix_f2_0 : STD_LOGIC_VECTOR(47 DOWNTO 0);
    time_matrix_f2_1 : STD_LOGIC_VECTOR(47 DOWNTO 0);
  END RECORD;
  SIGNAL reg_sp : lpp_SpectralMatrix_regs;

  TYPE lpp_WaveformPicker_regs IS RECORD
--    status_full       : STD_LOGIC_VECTOR(3 DOWNTO 0);
--    status_full_err   : STD_LOGIC_VECTOR(3 DOWNTO 0);
    status_new_err        : STD_LOGIC_VECTOR(3 DOWNTO 0);
    data_shaping_BW       : STD_LOGIC;
    data_shaping_SP0      : STD_LOGIC;
    data_shaping_SP1      : STD_LOGIC;
    data_shaping_R0       : STD_LOGIC;
    data_shaping_R1       : STD_LOGIC;
    data_shaping_R2       : STD_LOGIC;
    delta_snapshot        : STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
    delta_f0              : STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
    delta_f0_2            : STD_LOGIC_VECTOR(delta_vector_size_f0_2-1 DOWNTO 0);
    delta_f1              : STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
    delta_f2              : STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
    nb_data_by_buffer     : STD_LOGIC_VECTOR(nb_data_by_buffer_size-1 DOWNTO 0);
--    nb_word_by_buffer : STD_LOGIC_VECTOR(nb_word_by_buffer_size-1 DOWNTO 0);
    nb_snapshot_param     : STD_LOGIC_VECTOR(nb_snapshot_param_size-1 DOWNTO 0);
    enable_f0             : STD_LOGIC;
    enable_f1             : STD_LOGIC;
    enable_f2             : STD_LOGIC;
    enable_f3             : STD_LOGIC;
    burst_f0              : STD_LOGIC;
    burst_f1              : STD_LOGIC;
    burst_f2              : STD_LOGIC;
    run                   : STD_LOGIC;
    status_ready_buffer_f : STD_LOGIC_VECTOR(4*2-1 DOWNTO 0);
    addr_buffer_f         : STD_LOGIC_VECTOR(4*2*32-1 DOWNTO 0);
    time_buffer_f         : STD_LOGIC_VECTOR(4*2*48-1 DOWNTO 0);
    length_buffer         : STD_LOGIC_VECTOR(25 DOWNTO 0);
    error_buffer_full     : STD_LOGIC_VECTOR(3 DOWNTO 0);
    start_date            : STD_LOGIC_VECTOR(30 DOWNTO 0);
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
--  SIGNAL reg0_addr_matrix_f0  : STD_LOGIC_VECTOR(31 DOWNTO 0);
--  SIGNAL reg0_matrix_time_f0  : STD_LOGIC_VECTOR(47 DOWNTO 0);

  SIGNAL reg1_ready_matrix_f0 : STD_LOGIC;
--  SIGNAL reg1_addr_matrix_f0  : STD_LOGIC_VECTOR(31 DOWNTO 0);
--  SIGNAL reg1_matrix_time_f0  : STD_LOGIC_VECTOR(47 DOWNTO 0);

  SIGNAL reg0_ready_matrix_f1 : STD_LOGIC;
--  SIGNAL reg0_addr_matrix_f1  : STD_LOGIC_VECTOR(31 DOWNTO 0);
--  SIGNAL reg0_matrix_time_f1  : STD_LOGIC_VECTOR(47 DOWNTO 0);

  SIGNAL reg1_ready_matrix_f1 : STD_LOGIC;
--  SIGNAL reg1_addr_matrix_f1  : STD_LOGIC_VECTOR(31 DOWNTO 0);
--  SIGNAL reg1_matrix_time_f1  : STD_LOGIC_VECTOR(47 DOWNTO 0);

  SIGNAL reg0_ready_matrix_f2 : STD_LOGIC;
--  SIGNAL reg0_addr_matrix_f2  : STD_LOGIC_VECTOR(31 DOWNTO 0);
--  SIGNAL reg0_matrix_time_f2  : STD_LOGIC_VECTOR(47 DOWNTO 0);

  SIGNAL reg1_ready_matrix_f2 : STD_LOGIC;
--  SIGNAL reg1_addr_matrix_f2  : STD_LOGIC_VECTOR(31 DOWNTO 0);
--  SIGNAL reg1_matrix_time_f2  : STD_LOGIC_VECTOR(47 DOWNTO 0);
  SIGNAL apbo_irq_ms          : STD_LOGIC;
  SIGNAL apbo_irq_wfp         : STD_LOGIC;
  -----------------------------------------------------------------------------
  SIGNAL reg_ready_buffer_f   : STD_LOGIC_VECTOR(2*4-1 DOWNTO 0);

  SIGNAL pirq_temp : STD_LOGIC_VECTOR(31 DOWNTO 0);

  SIGNAL sample_f3_v_reg  : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL sample_f3_e1_reg : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL sample_f3_e2_reg : STD_LOGIC_VECTOR(15 DOWNTO 0);
  
BEGIN  -- beh

  debug_vector(0)          <= error_buffer_full;
  debug_vector(1)          <= reg_sp.status_error_buffer_full;
  debug_vector(4 DOWNTO 2) <= error_input_fifo_write;
  debug_vector(7 DOWNTO 5) <= reg_sp.status_error_input_fifo_write;
  debug_vector(8)          <= ready_matrix_f2;
  debug_vector(9)          <= reg0_ready_matrix_f2;
  debug_vector(10)         <= reg1_ready_matrix_f2;
  debug_vector(11)         <= HRESETn;

--  status_ready_matrix_f0 <= reg_sp.status_ready_matrix_f0;
--  status_ready_matrix_f1 <= reg_sp.status_ready_matrix_f1;
--  status_ready_matrix_f2 <= reg_sp.status_ready_matrix_f2;

--  config_active_interruption_onNewMatrix <= reg_sp.config_active_interruption_onNewMatrix;
--  config_active_interruption_onError     <= reg_sp.config_active_interruption_onError;


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
  delta_f0          <= reg_wp.delta_f0;         --<= X"0001280A";
  delta_f0_2        <= reg_wp.delta_f0_2;       --<= "0110000";  
  delta_f1          <= reg_wp.delta_f1;         --<= X"0001283F";
  delta_f2          <= reg_wp.delta_f2;         --<= X"000127FF";
  nb_data_by_buffer <= reg_wp.nb_data_by_buffer;--<= X"00000A7F";
  nb_snapshot_param <= reg_wp.nb_snapshot_param;--<= X"00000A80";

  enable_f0 <= reg_wp.enable_f0;
  enable_f1 <= reg_wp.enable_f1;
  enable_f2 <= reg_wp.enable_f2;
  enable_f3 <= reg_wp.enable_f3;

  burst_f0 <= reg_wp.burst_f0;
  burst_f1 <= reg_wp.burst_f1;
  burst_f2 <= reg_wp.burst_f2;

  run <= reg_wp.run;

  --addr_data_f0 <= reg_wp.addr_data_f0;
  --addr_data_f1 <= reg_wp.addr_data_f1;
  --addr_data_f2 <= reg_wp.addr_data_f2;
  --addr_data_f3 <= reg_wp.addr_data_f3;

  start_date <= reg_wp.start_date;

  length_matrix_f0  <= "00" & X"0000C8";--reg_sp.length_matrix;
  length_matrix_f1  <= "00" & X"0000C8";--reg_sp.length_matrix;
  length_matrix_f2  <= "00" & X"0000C8";--reg_sp.length_matrix;
  wfp_length_buffer <= "00" & X"0001F8"; --<= reg_wp.length_buffer;



  PROCESS (HCLK, HRESETn)
  BEGIN  -- PROCESS
    IF HRESETn = '0' THEN                 -- asynchronous reset (active low)
      sample_f3_v_reg  <= (OTHERS => '0');
      sample_f3_e1_reg <= (OTHERS => '0');
      sample_f3_e2_reg <= (OTHERS => '0');
    ELSIF HCLK'EVENT AND HCLK = '1' THEN  -- rising clock edge
      IF sample_f3_valid = '1' THEN
        sample_f3_v_reg  <= sample_f3_v;
        sample_f3_e1_reg <= sample_f3_e1;
        sample_f3_e2_reg <= sample_f3_e2;
      END IF;
    END IF;
  END PROCESS;

  
--  reg_sp.length_matrix                          <= "00" & X"0000C8";
--  reg_sp.config_active_interruption_onError     <= '0';
  --reg_wp.delta_f0                               <= X"0001280A";
  --reg_wp.delta_f0_2                             <= "0110000";  
  --reg_wp.delta_f1                               <= X"0001283F";
  --reg_wp.delta_f2                               <= X"000127FF";
  --reg_wp.nb_data_by_buffer                      <= X"00000A7F";
  --reg_wp.nb_snapshot_param                      <= X"00000A80";
  --reg_wp.length_buffer                          <= "00" & X"0001F8";  --25 .. 0

  lpp_lfr_apbreg : PROCESS (HCLK, HRESETn)
    VARIABLE paddr : STD_LOGIC_VECTOR(7 DOWNTO 2);
  BEGIN  -- PROCESS lpp_dma_top
    IF HRESETn = '0' THEN               -- asynchronous reset (active low)
      reg_sp.config_active_interruption_onNewMatrix <= '0';
      reg_sp.config_active_interruption_onError     <= '0';
      reg_sp.config_ms_run                          <= '0';
      reg_sp.status_ready_matrix_f0_0               <= '0';
      reg_sp.status_ready_matrix_f1_0               <= '0';
      reg_sp.status_ready_matrix_f2_0               <= '0';
      reg_sp.status_ready_matrix_f0_1               <= '0';
      reg_sp.status_ready_matrix_f1_1               <= '0';
      reg_sp.status_ready_matrix_f2_1               <= '0';
      reg_sp.status_error_buffer_full               <= '0';
      reg_sp.status_error_input_fifo_write          <= (OTHERS => '0');

      reg_sp.addr_matrix_f0_0 <= (OTHERS => '0');
      reg_sp.addr_matrix_f1_0 <= (OTHERS => '0');
      reg_sp.addr_matrix_f2_0 <= (OTHERS => '0');

      reg_sp.addr_matrix_f0_1 <= (OTHERS => '0');
      reg_sp.addr_matrix_f1_1 <= (OTHERS => '0');
      reg_sp.addr_matrix_f2_1 <= (OTHERS => '0');

      reg_sp.length_matrix <= (OTHERS => '0');

--      reg_sp.time_matrix_f0_0 <= (OTHERS => '0');  -- ok
--      reg_sp.time_matrix_f1_0 <= (OTHERS => '0');  -- ok
--      reg_sp.time_matrix_f2_0 <= (OTHERS => '0');  -- ok

--      reg_sp.time_matrix_f0_1 <= (OTHERS => '0');  -- ok
      --reg_sp.time_matrix_f1_1 <= (OTHERS => '0');  -- ok
--      reg_sp.time_matrix_f2_1 <= (OTHERS => '0');  -- ok

      prdata <= (OTHERS => '0');


      apbo_irq_ms  <= '0';
      apbo_irq_wfp <= '0';


--      status_full_ack <= (OTHERS => '0');

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
--      reg_wp.status_full       <= (OTHERS => '0');
--      reg_wp.status_full_err   <= (OTHERS => '0');
      reg_wp.status_new_err    <= (OTHERS => '0');
      reg_wp.error_buffer_full <= (OTHERS => '0');
      reg_wp.delta_snapshot    <= (OTHERS => '0');
      reg_wp.delta_f0          <= (OTHERS => '0');
      reg_wp.delta_f0_2        <= (OTHERS => '0');
      reg_wp.delta_f1          <= (OTHERS => '0');
      reg_wp.delta_f2          <= (OTHERS => '0');
      reg_wp.nb_data_by_buffer <= (OTHERS => '0');
      reg_wp.nb_snapshot_param <= (OTHERS => '0');
      reg_wp.start_date        <= (OTHERS => '1');

      reg_wp.status_ready_buffer_f <= (OTHERS => '0');
      reg_wp.length_buffer         <= (OTHERS => '0');

      pirq_temp <= (OTHERS => '0');

      reg_wp.addr_buffer_f <= (OTHERS => '0');
      
    ELSIF HCLK'EVENT AND HCLK = '1' THEN  -- rising clock edge

--      status_full_ack <= (OTHERS => '0');

      reg_sp.status_ready_matrix_f0_0 <= reg_sp.status_ready_matrix_f0_0 OR reg0_ready_matrix_f0;
      reg_sp.status_ready_matrix_f1_0 <= reg_sp.status_ready_matrix_f1_0 OR reg0_ready_matrix_f1;
      reg_sp.status_ready_matrix_f2_0 <= reg_sp.status_ready_matrix_f2_0 OR reg0_ready_matrix_f2;

      reg_sp.status_ready_matrix_f0_1 <= reg_sp.status_ready_matrix_f0_1 OR reg1_ready_matrix_f0;
      reg_sp.status_ready_matrix_f1_1 <= reg_sp.status_ready_matrix_f1_1 OR reg1_ready_matrix_f1;
      reg_sp.status_ready_matrix_f2_1 <= reg_sp.status_ready_matrix_f2_1 OR reg1_ready_matrix_f2;

      all_status_ready_buffer_bit : FOR I IN 4*2-1 DOWNTO 0 LOOP
        reg_wp.status_ready_buffer_f(I) <= reg_wp.status_ready_buffer_f(I) OR reg_ready_buffer_f(I);
      END LOOP all_status_ready_buffer_bit;


      reg_sp.status_error_buffer_full         <= reg_sp.status_error_buffer_full OR error_buffer_full;
      reg_sp.status_error_input_fifo_write(0) <= reg_sp.status_error_input_fifo_write(0) OR error_input_fifo_write(0);
      reg_sp.status_error_input_fifo_write(1) <= reg_sp.status_error_input_fifo_write(1) OR error_input_fifo_write(1);
      reg_sp.status_error_input_fifo_write(2) <= reg_sp.status_error_input_fifo_write(2) OR error_input_fifo_write(2);



      all_status : FOR I IN 3 DOWNTO 0 LOOP
        reg_wp.error_buffer_full(I) <= reg_wp.error_buffer_full(I) OR wfp_error_buffer_full(I);
        reg_wp.status_new_err(I)    <= reg_wp.status_new_err(I) OR status_new_err(I);
      END LOOP all_status;

      paddr             := "000000";
      paddr(7 DOWNTO 2) := apbi.paddr(7 DOWNTO 2);
      prdata            <= (OTHERS => '0');
      IF apbi.psel(pindex) = '1' THEN
        -- APB DMA READ  --
        CASE paddr(7 DOWNTO 2) IS

          WHEN ADDR_LFR_SM_CONFIG =>
            prdata(0) <= reg_sp.config_active_interruption_onNewMatrix;
            prdata(1) <= reg_sp.config_active_interruption_onError;
            prdata(2) <= reg_sp.config_ms_run;

          WHEN ADDR_LFR_SM_STATUS =>
            prdata(0)  <= reg_sp.status_ready_matrix_f0_0;
            prdata(1)  <= reg_sp.status_ready_matrix_f0_1;
            prdata(2)  <= reg_sp.status_ready_matrix_f1_0;
            prdata(3)  <= reg_sp.status_ready_matrix_f1_1;
            prdata(4)  <= reg_sp.status_ready_matrix_f2_0;
            prdata(5)  <= reg_sp.status_ready_matrix_f2_1;
            -- prdata(6)  <= reg_sp.status_error_bad_component_error;
            prdata(7)  <= reg_sp.status_error_buffer_full;
            prdata(8)  <= reg_sp.status_error_input_fifo_write(0);
            prdata(9)  <= reg_sp.status_error_input_fifo_write(1);
            prdata(10) <= reg_sp.status_error_input_fifo_write(2);
            
          WHEN ADDR_LFR_SM_F0_0_ADDR        => prdata              <= reg_sp.addr_matrix_f0_0;
          WHEN ADDR_LFR_SM_F0_1_ADDR        => prdata              <= reg_sp.addr_matrix_f0_1;
          WHEN ADDR_LFR_SM_F1_0_ADDR        => prdata              <= reg_sp.addr_matrix_f1_0;
          WHEN ADDR_LFR_SM_F1_1_ADDR        => prdata              <= reg_sp.addr_matrix_f1_1;
          WHEN ADDR_LFR_SM_F2_0_ADDR        => prdata              <= reg_sp.addr_matrix_f2_0;
          WHEN ADDR_LFR_SM_F2_1_ADDR        => prdata              <= reg_sp.addr_matrix_f2_1;
          WHEN ADDR_LFR_SM_F0_0_TIME_COARSE => prdata              <= reg_sp.time_matrix_f0_0(47 DOWNTO 16);
          WHEN ADDR_LFR_SM_F0_0_TIME_FINE   => prdata(15 DOWNTO 0) <= reg_sp.time_matrix_f0_0(15 DOWNTO 0);
          WHEN ADDR_LFR_SM_F0_1_TIME_COARSE => prdata              <= reg_sp.time_matrix_f0_1(47 DOWNTO 16);
          WHEN ADDR_LFR_SM_F0_1_TIME_FINE   => prdata(15 DOWNTO 0) <= reg_sp.time_matrix_f0_1(15 DOWNTO 0);
          WHEN ADDR_LFR_SM_F1_0_TIME_COARSE => prdata              <= reg_sp.time_matrix_f1_0(47 DOWNTO 16);
          WHEN ADDR_LFR_SM_F1_0_TIME_FINE   => prdata(15 DOWNTO 0) <= reg_sp.time_matrix_f1_0(15 DOWNTO 0);
          WHEN ADDR_LFR_SM_F1_1_TIME_COARSE => prdata              <= reg_sp.time_matrix_f1_1(47 DOWNTO 16);
          WHEN ADDR_LFR_SM_F1_1_TIME_FINE   => prdata(15 DOWNTO 0) <= reg_sp.time_matrix_f1_1(15 DOWNTO 0);
          WHEN ADDR_LFR_SM_F2_0_TIME_COARSE => prdata              <= reg_sp.time_matrix_f2_0(47 DOWNTO 16);
          WHEN ADDR_LFR_SM_F2_0_TIME_FINE   => prdata(15 DOWNTO 0) <= reg_sp.time_matrix_f2_0(15 DOWNTO 0);
          WHEN ADDR_LFR_SM_F2_1_TIME_COARSE => prdata              <= reg_sp.time_matrix_f2_1(47 DOWNTO 16);
          WHEN ADDR_LFR_SM_F2_1_TIME_FINE   => prdata(15 DOWNTO 0) <= reg_sp.time_matrix_f2_1(15 DOWNTO 0);
          WHEN ADDR_LFR_SM_LENGTH           => prdata(25 DOWNTO 0) <= reg_sp.length_matrix;
                                                                                             ---------------------------------------------------------------------
          WHEN ADDR_LFR_WP_DATASHAPING      =>
            prdata(0) <= reg_wp.data_shaping_BW;
            prdata(1) <= reg_wp.data_shaping_SP0;
            prdata(2) <= reg_wp.data_shaping_SP1;
            prdata(3) <= reg_wp.data_shaping_R0;
            prdata(4) <= reg_wp.data_shaping_R1;
            prdata(5) <= reg_wp.data_shaping_R2;
          WHEN ADDR_LFR_WP_CONTROL =>
            prdata(0) <= reg_wp.enable_f0;
            prdata(1) <= reg_wp.enable_f1;
            prdata(2) <= reg_wp.enable_f2;
            prdata(3) <= reg_wp.enable_f3;
            prdata(4) <= reg_wp.burst_f0;
            prdata(5) <= reg_wp.burst_f1;
            prdata(6) <= reg_wp.burst_f2;
            prdata(7) <= reg_wp.run;
          WHEN ADDR_LFR_WP_F0_0_ADDR => prdata <= reg_wp.addr_buffer_f(32*1-1 DOWNTO 32*0);  --0
          WHEN ADDR_LFR_WP_F0_1_ADDR => prdata <= reg_wp.addr_buffer_f(32*2-1 DOWNTO 32*1);
          WHEN ADDR_LFR_WP_F1_0_ADDR => prdata <= reg_wp.addr_buffer_f(32*3-1 DOWNTO 32*2);  --1
          WHEN ADDR_LFR_WP_F1_1_ADDR => prdata <= reg_wp.addr_buffer_f(32*4-1 DOWNTO 32*3);
          WHEN ADDR_LFR_WP_F2_0_ADDR => prdata <= reg_wp.addr_buffer_f(32*5-1 DOWNTO 32*4);  --2
          WHEN ADDR_LFR_WP_F2_1_ADDR => prdata <= reg_wp.addr_buffer_f(32*6-1 DOWNTO 32*5);
          WHEN ADDR_LFR_WP_F3_0_ADDR => prdata <= reg_wp.addr_buffer_f(32*7-1 DOWNTO 32*6);  --3
          WHEN ADDR_LFR_WP_F3_1_ADDR => prdata <= reg_wp.addr_buffer_f(32*8-1 DOWNTO 32*7);

          WHEN ADDR_LFR_WP_STATUS =>
            prdata(7 DOWNTO 0)   <= reg_wp.status_ready_buffer_f;
            prdata(11 DOWNTO 8)  <= reg_wp.error_buffer_full;
            prdata(15 DOWNTO 12) <= reg_wp.status_new_err;
            
          WHEN ADDR_LFR_WP_DELTASNAPSHOT  => prdata(delta_vector_size-1 DOWNTO 0)      <= reg_wp.delta_snapshot;
          WHEN ADDR_LFR_WP_DELTA_F0       => prdata(delta_vector_size-1 DOWNTO 0)      <= reg_wp.delta_f0;
          WHEN ADDR_LFR_WP_DELTA_F0_2     => prdata(delta_vector_size_f0_2-1 DOWNTO 0) <= reg_wp.delta_f0_2;
          WHEN ADDR_LFR_WP_DELTA_F1       => prdata(delta_vector_size-1 DOWNTO 0)      <= reg_wp.delta_f1;
          WHEN ADDR_LFR_WP_DELTA_F2       => prdata(delta_vector_size-1 DOWNTO 0)      <= reg_wp.delta_f2;
          WHEN ADDR_LFR_WP_DATA_IN_BUFFER => prdata(nb_data_by_buffer_size-1 DOWNTO 0) <= reg_wp.nb_data_by_buffer;
          WHEN ADDR_LFR_WP_NBSNAPSHOT     => prdata(nb_snapshot_param_size-1 DOWNTO 0) <= reg_wp.nb_snapshot_param;
          WHEN ADDR_LFR_WP_START_DATE     => prdata(30 DOWNTO 0)                       <= reg_wp.start_date;

          WHEN ADDR_LFR_WP_F0_0_TIME_COARSE => prdata(31 DOWNTO 0) <= reg_wp.time_buffer_f(48*0 + 31 DOWNTO 48*0);
          WHEN ADDR_LFR_WP_F0_0_TIME_FINE   => prdata(15 DOWNTO 0) <= reg_wp.time_buffer_f(48*0 + 47 DOWNTO 48*0 + 32);
          WHEN ADDR_LFR_WP_F0_1_TIME_COARSE => prdata(31 DOWNTO 0) <= reg_wp.time_buffer_f(48*1 + 31 DOWNTO 48*1);
          WHEN ADDR_LFR_WP_F0_1_TIME_FINE   => prdata(15 DOWNTO 0) <= reg_wp.time_buffer_f(48*1 + 47 DOWNTO 48*1 + 32);

          WHEN ADDR_LFR_WP_F1_0_TIME_COARSE => prdata(31 DOWNTO 0) <= reg_wp.time_buffer_f(48*2 + 31 DOWNTO 48*2);
          WHEN ADDR_LFR_WP_F1_0_TIME_FINE   => prdata(15 DOWNTO 0) <= reg_wp.time_buffer_f(48*2 + 47 DOWNTO 48*2 + 32);
          WHEN ADDR_LFR_WP_F1_1_TIME_COARSE => prdata(31 DOWNTO 0) <= reg_wp.time_buffer_f(48*3 + 31 DOWNTO 48*3);
          WHEN ADDR_LFR_WP_F1_1_TIME_FINE   => prdata(15 DOWNTO 0) <= reg_wp.time_buffer_f(48*3 + 47 DOWNTO 48*3 + 32);

          WHEN ADDR_LFR_WP_F2_0_TIME_COARSE => prdata(31 DOWNTO 0) <= reg_wp.time_buffer_f(48*4 + 31 DOWNTO 48*4);
          WHEN ADDR_LFR_WP_F2_0_TIME_FINE   => prdata(15 DOWNTO 0) <= reg_wp.time_buffer_f(48*4 + 47 DOWNTO 48*4 + 32);
          WHEN ADDR_LFR_WP_F2_1_TIME_COARSE => prdata(31 DOWNTO 0) <= reg_wp.time_buffer_f(48*5 + 31 DOWNTO 48*5);
          WHEN ADDR_LFR_WP_F2_1_TIME_FINE   => prdata(15 DOWNTO 0) <= reg_wp.time_buffer_f(48*5 + 47 DOWNTO 48*5 + 32);

          WHEN ADDR_LFR_WP_F3_0_TIME_COARSE => prdata(31 DOWNTO 0) <= reg_wp.time_buffer_f(48*6 + 31 DOWNTO 48*6);
          WHEN ADDR_LFR_WP_F3_0_TIME_FINE   => prdata(15 DOWNTO 0) <= reg_wp.time_buffer_f(48*6 + 47 DOWNTO 48*6 + 32);
          WHEN ADDR_LFR_WP_F3_1_TIME_COARSE => prdata(31 DOWNTO 0) <= reg_wp.time_buffer_f(48*7 + 31 DOWNTO 48*7);
          WHEN ADDR_LFR_WP_F3_1_TIME_FINE   => prdata(15 DOWNTO 0) <= reg_wp.time_buffer_f(48*7 + 47 DOWNTO 48*7 + 32);

          WHEN ADDR_LFR_WP_LENGTH => prdata(25 DOWNTO 0) <= reg_wp.length_buffer;

          WHEN ADDR_LFR_WP_F3_V => prdata(15 DOWNTO 0) <= sample_f3_v_reg;
                                     prdata(31 DOWNTO 16) <= (OTHERS => '0');
          WHEN ADDR_LFR_WP_F3_E1 => prdata(15 DOWNTO 0) <= sample_f3_e1_reg;
                                     prdata(31 DOWNTO 16) <= (OTHERS => '0');
          WHEN ADDR_LFR_WP_F3_E2 => prdata(15 DOWNTO 0) <= sample_f3_e2_reg;
                                     prdata(31 DOWNTO 16) <= (OTHERS => '0');
                                     ---------------------------------------------------------------------            
          WHEN ADDR_LFR_VERSION => prdata(23 DOWNTO 0) <= top_lfr_version(23 DOWNTO 0);
          WHEN OTHERS           => NULL;
                           
        END CASE;
        IF (apbi.pwrite AND apbi.penable) = '1' THEN
          -- APB DMA WRITE --
          CASE paddr(7 DOWNTO 2) IS
            --
            WHEN ADDR_LFR_SM_CONFIG =>
              reg_sp.config_active_interruption_onNewMatrix <= apbi.pwdata(0);
              reg_sp.config_active_interruption_onError     <= apbi.pwdata(1);
              reg_sp.config_ms_run                          <= apbi.pwdata(2);
              
            WHEN ADDR_LFR_SM_STATUS =>
              reg_sp.status_ready_matrix_f0_0         <= ((NOT apbi.pwdata(0)) AND reg_sp.status_ready_matrix_f0_0) OR reg0_ready_matrix_f0;
              reg_sp.status_ready_matrix_f0_1         <= ((NOT apbi.pwdata(1)) AND reg_sp.status_ready_matrix_f0_1) OR reg1_ready_matrix_f0;
              reg_sp.status_ready_matrix_f1_0         <= ((NOT apbi.pwdata(2)) AND reg_sp.status_ready_matrix_f1_0) OR reg0_ready_matrix_f1;
              reg_sp.status_ready_matrix_f1_1         <= ((NOT apbi.pwdata(3)) AND reg_sp.status_ready_matrix_f1_1) OR reg1_ready_matrix_f1;
              reg_sp.status_ready_matrix_f2_0         <= ((NOT apbi.pwdata(4)) AND reg_sp.status_ready_matrix_f2_0) OR reg0_ready_matrix_f2;
              reg_sp.status_ready_matrix_f2_1         <= ((NOT apbi.pwdata(5)) AND reg_sp.status_ready_matrix_f2_1) OR reg1_ready_matrix_f2;
              reg_sp.status_error_buffer_full         <= ((NOT apbi.pwdata(7)) AND reg_sp.status_error_buffer_full) OR error_buffer_full;
              reg_sp.status_error_input_fifo_write(0) <= ((NOT apbi.pwdata(8)) AND reg_sp.status_error_input_fifo_write(0)) OR error_input_fifo_write(0);
              reg_sp.status_error_input_fifo_write(1) <= ((NOT apbi.pwdata(9)) AND reg_sp.status_error_input_fifo_write(1)) OR error_input_fifo_write(1);
              reg_sp.status_error_input_fifo_write(2) <= ((NOT apbi.pwdata(10)) AND reg_sp.status_error_input_fifo_write(2)) OR error_input_fifo_write(2);
            WHEN ADDR_LFR_SM_F0_0_ADDR => reg_sp.addr_matrix_f0_0 <= apbi.pwdata;
            WHEN ADDR_LFR_SM_F0_1_ADDR => reg_sp.addr_matrix_f0_1 <= apbi.pwdata;
            WHEN ADDR_LFR_SM_F1_0_ADDR => reg_sp.addr_matrix_f1_0 <= apbi.pwdata;
            WHEN ADDR_LFR_SM_F1_1_ADDR => reg_sp.addr_matrix_f1_1 <= apbi.pwdata;
            WHEN ADDR_LFR_SM_F2_0_ADDR => reg_sp.addr_matrix_f2_0 <= apbi.pwdata;
            WHEN ADDR_LFR_SM_F2_1_ADDR => reg_sp.addr_matrix_f2_1 <= apbi.pwdata;

            WHEN ADDR_LFR_SM_LENGTH      => reg_sp.length_matrix <= apbi.pwdata(25 DOWNTO 0);
                                       ---------------------------------------------------------------------     
            WHEN ADDR_LFR_WP_DATASHAPING =>
              reg_wp.data_shaping_BW  <= apbi.pwdata(0);
              reg_wp.data_shaping_SP0 <= apbi.pwdata(1);
              reg_wp.data_shaping_SP1 <= apbi.pwdata(2);
              reg_wp.data_shaping_R0  <= apbi.pwdata(3);
              reg_wp.data_shaping_R1  <= apbi.pwdata(4);
              reg_wp.data_shaping_R2  <= apbi.pwdata(5);
            WHEN ADDR_LFR_WP_CONTROL =>
              reg_wp.enable_f0 <= apbi.pwdata(0);
              reg_wp.enable_f1 <= apbi.pwdata(1);
              reg_wp.enable_f2 <= apbi.pwdata(2);
              reg_wp.enable_f3 <= apbi.pwdata(3);
              reg_wp.burst_f0  <= apbi.pwdata(4);
              reg_wp.burst_f1  <= apbi.pwdata(5);
              reg_wp.burst_f2  <= apbi.pwdata(6);
              reg_wp.run       <= apbi.pwdata(7);
            WHEN ADDR_LFR_WP_F0_0_ADDR => reg_wp.addr_buffer_f(32*1-1 DOWNTO 32*0) <= apbi.pwdata;
            WHEN ADDR_LFR_WP_F0_1_ADDR => reg_wp.addr_buffer_f(32*2-1 DOWNTO 32*1) <= apbi.pwdata;
            WHEN ADDR_LFR_WP_F1_0_ADDR => reg_wp.addr_buffer_f(32*3-1 DOWNTO 32*2) <= apbi.pwdata;
            WHEN ADDR_LFR_WP_F1_1_ADDR => reg_wp.addr_buffer_f(32*4-1 DOWNTO 32*3) <= apbi.pwdata;
            WHEN ADDR_LFR_WP_F2_0_ADDR => reg_wp.addr_buffer_f(32*5-1 DOWNTO 32*4) <= apbi.pwdata;
            WHEN ADDR_LFR_WP_F2_1_ADDR => reg_wp.addr_buffer_f(32*6-1 DOWNTO 32*5) <= apbi.pwdata;
            WHEN ADDR_LFR_WP_F3_0_ADDR => reg_wp.addr_buffer_f(32*7-1 DOWNTO 32*6) <= apbi.pwdata;
            WHEN ADDR_LFR_WP_F3_1_ADDR => reg_wp.addr_buffer_f(32*8-1 DOWNTO 32*7) <= apbi.pwdata;
            WHEN ADDR_LFR_WP_STATUS    =>
              all_reg_wp_status_bit : FOR I IN 3 DOWNTO 0 LOOP
                reg_wp.status_ready_buffer_f(I*2)   <= ((NOT apbi.pwdata(I*2)) AND reg_wp.status_ready_buffer_f(I*2)) OR reg_ready_buffer_f(I*2);
                reg_wp.status_ready_buffer_f(I*2+1) <= ((NOT apbi.pwdata(I*2+1)) AND reg_wp.status_ready_buffer_f(I*2+1)) OR reg_ready_buffer_f(I*2+1);
                reg_wp.error_buffer_full(I)         <= ((NOT apbi.pwdata(I+8)) AND reg_wp.error_buffer_full(I)) OR wfp_error_buffer_full(I);
                reg_wp.status_new_err(I)            <= ((NOT apbi.pwdata(I+12)) AND reg_wp.status_new_err(I)) OR status_new_err(I);
              END LOOP all_reg_wp_status_bit;

            WHEN ADDR_LFR_WP_DELTASNAPSHOT => reg_wp.delta_snapshot <= apbi.pwdata(delta_vector_size-1 DOWNTO 0);
            WHEN ADDR_LFR_WP_DELTA_F0      => reg_wp.delta_f0       <= apbi.pwdata(delta_vector_size-1 DOWNTO 0);
            WHEN ADDR_LFR_WP_DELTA_F0_2    => reg_wp.delta_f0_2     <= apbi.pwdata(delta_vector_size_f0_2-1 DOWNTO 0);
            WHEN ADDR_LFR_WP_DELTA_F1       => reg_wp.delta_f1          <= apbi.pwdata(delta_vector_size-1 DOWNTO 0);
            WHEN ADDR_LFR_WP_DELTA_F2       => reg_wp.delta_f2          <= apbi.pwdata(delta_vector_size-1 DOWNTO 0);
            WHEN ADDR_LFR_WP_DATA_IN_BUFFER => reg_wp.nb_data_by_buffer <= apbi.pwdata(nb_data_by_buffer_size-1 DOWNTO 0);
            WHEN ADDR_LFR_WP_NBSNAPSHOT     => reg_wp.nb_snapshot_param <= apbi.pwdata(nb_snapshot_param_size-1 DOWNTO 0);
            WHEN ADDR_LFR_WP_START_DATE     => reg_wp.start_date        <= apbi.pwdata(30 DOWNTO 0);

            WHEN ADDR_LFR_WP_LENGTH => reg_wp.length_buffer <= apbi.pwdata(25 DOWNTO 0);

            WHEN OTHERS => NULL;
          END CASE;
        END IF;
      END IF;
      --apbo.pirq(pirq_ms) <=
      pirq_temp(pirq_ms)  <= apbo_irq_ms;
      pirq_temp(pirq_wfp) <= apbo_irq_wfp;
      apbo_irq_ms <= ((reg_sp.config_active_interruption_onNewMatrix AND (ready_matrix_f0 OR
                                                                          ready_matrix_f1 OR
                                                                          ready_matrix_f2)
                       )
                      --OR
                      --(reg_sp.config_active_interruption_onError AND
                      -- (
                      --   error_buffer_full
                      --   OR error_input_fifo_write(0)
                      --   OR error_input_fifo_write(1)
                      --   OR error_input_fifo_write(2))
                      -- )
                      );
      -- apbo.pirq(pirq_wfp)
      apbo_irq_wfp <= ored_irq_wfp;
      
    END IF;
  END PROCESS lpp_lfr_apbreg;

  apbo.pirq <= pirq_temp;


  --all_irq: FOR I IN 31 DOWNTO 0 GENERATE
  --  IRQ_is_PIRQ_MS: IF I = pirq_ms GENERATE
  --    apbo.pirq(I)  <= apbo_irq_ms;
  --  END GENERATE IRQ_is_PIRQ_MS;
  --  IRQ_is_PIRQ_WFP: IF I = pirq_wfp GENERATE
  --    apbo.pirq(I) <= apbo_irq_wfp;
  --  END GENERATE IRQ_is_PIRQ_WFP;
  --  IRQ_OTHERS: IF I /= pirq_ms AND pirq_wfp /= pirq_wfp GENERATE
  --    apbo.pirq(I) <= '0';
  --  END GENERATE IRQ_OTHERS;

  --END GENERATE all_irq;



  apbo.pindex  <= pindex;
  apbo.pconfig <= pconfig;
  apbo.prdata  <= prdata;

  -----------------------------------------------------------------------------
  -- IRQ
  -----------------------------------------------------------------------------
  irq_wfp_reg_s <= wfp_ready_buffer & wfp_error_buffer_full & status_new_err;

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

--  run_ms <= reg_sp.config_ms_run;

  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  lpp_apbreg_ms_pointer_f0 : lpp_apbreg_ms_pointer
    PORT MAP (
      clk  => HCLK,
      rstn => HRESETn,

      run => '1',                       --reg_sp.config_ms_run,

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

      run => '1',                       --reg_sp.config_ms_run,

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

      run => '1',                       --reg_sp.config_ms_run,

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
  all_wfp_pointer : FOR I IN 3 DOWNTO 0 GENERATE
    lpp_apbreg_wfp_pointer_fi : lpp_apbreg_ms_pointer
      PORT MAP (
        clk  => HCLK,
        rstn => HRESETn,

        run => '1',                     --reg_wp.run,

        reg0_status_ready_matrix => reg_wp.status_ready_buffer_f(2*I),
        reg0_ready_matrix        => reg_ready_buffer_f(2*I),
        reg0_addr_matrix         => reg_wp.addr_buffer_f((2*I+1)*32-1 DOWNTO (2*I)*32),
        reg0_matrix_time         => reg_wp.time_buffer_f((2*I+1)*48-1 DOWNTO (2*I)*48),

        reg1_status_ready_matrix => reg_wp.status_ready_buffer_f(2*I+1),
        reg1_ready_matrix        => reg_ready_buffer_f(2*I+1),
        reg1_addr_matrix         => reg_wp.addr_buffer_f((2*I+2)*32-1 DOWNTO (2*I+1)*32),
        reg1_matrix_time         => reg_wp.time_buffer_f((2*I+2)*48-1 DOWNTO (2*I+1)*48),

        ready_matrix        => wfp_ready_buffer(I),
        status_ready_matrix => wfp_status_buffer_ready(I),
        addr_matrix         => wfp_addr_buffer((I+1)*32-1 DOWNTO I*32),
        matrix_time         => wfp_buffer_time((I+1)*48-1 DOWNTO I*48)
        );

  END GENERATE all_wfp_pointer;
  -----------------------------------------------------------------------------
  
END beh;

------------------------------------------------------------------------------
