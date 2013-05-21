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
USE lpp.lpp_amba.ALL;
USE lpp.apb_devices_list.ALL;
USE lpp.lpp_memory.ALL;
LIBRARY techmap;
USE techmap.gencomp.ALL;

ENTITY lpp_top_apbreg IS
  GENERIC (
    nb_burst_available_size : INTEGER := 11;
    nb_snapshot_param_size  : INTEGER := 11;
    delta_snapshot_size     : INTEGER := 16;
    delta_f2_f0_size        : INTEGER := 10;
    delta_f2_f1_size        : INTEGER := 10;

    pindex : INTEGER := 4;
    paddr  : INTEGER := 4;
    pmask  : INTEGER := 16#fff#;
    pirq   : INTEGER := 0);
  PORT (
    -- AMBA AHB system signals
    HCLK    : IN STD_ULOGIC;
    HRESETn : IN STD_ULOGIC;

    -- AMBA APB Slave Interface
    apbi : IN  apb_slv_in_type;
    apbo : OUT apb_slv_out_type;

    ---------------------------------------------------------------------------
    -- Spectral Matrix Reg
    -- IN
    ready_matrix_f0_0             : IN STD_LOGIC;
    ready_matrix_f0_1             : IN STD_LOGIC;
    ready_matrix_f1               : IN STD_LOGIC;
    ready_matrix_f2               : IN STD_LOGIC;
    error_anticipating_empty_fifo : IN STD_LOGIC;
    error_bad_component_error     : IN STD_LOGIC;
    debug_reg                     : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

    -- OUT
    status_ready_matrix_f0_0             : OUT STD_LOGIC;
    status_ready_matrix_f0_1             : OUT STD_LOGIC;
    status_ready_matrix_f1               : OUT STD_LOGIC;
    status_ready_matrix_f2               : OUT STD_LOGIC;
    status_error_anticipating_empty_fifo : OUT STD_LOGIC;
    status_error_bad_component_error     : OUT STD_LOGIC;

    config_active_interruption_onNewMatrix : OUT STD_LOGIC;
    config_active_interruption_onError     : OUT STD_LOGIC;
    addr_matrix_f0_0                       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_matrix_f0_1                       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_matrix_f1                         : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_matrix_f2                         : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------
    -- WaveForm picker Reg
    status_full                            : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    status_full_ack                        : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    status_full_err                        : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    status_new_err                         : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);

    -- OUT
    data_shaping_BW  : OUT STD_LOGIC;
    data_shaping_SP0 : OUT STD_LOGIC;
    data_shaping_SP1 : OUT STD_LOGIC;
    data_shaping_R0  : OUT STD_LOGIC;
    data_shaping_R1  : OUT STD_LOGIC;

    delta_snapshot     : OUT STD_LOGIC_VECTOR(delta_snapshot_size-1 DOWNTO 0);
    delta_f2_f1        : OUT STD_LOGIC_VECTOR(delta_f2_f1_size-1 DOWNTO 0);
    delta_f2_f0        : OUT STD_LOGIC_VECTOR(delta_f2_f0_size-1 DOWNTO 0);
    nb_burst_available : OUT STD_LOGIC_VECTOR(nb_burst_available_size-1 DOWNTO 0);
    nb_snapshot_param  : OUT STD_LOGIC_VECTOR(nb_snapshot_param_size-1 DOWNTO 0);

    enable_f0 : OUT STD_LOGIC;
    enable_f1 : OUT STD_LOGIC;
    enable_f2 : OUT STD_LOGIC;
    enable_f3 : OUT STD_LOGIC;

    burst_f0 : OUT STD_LOGIC;
    burst_f1 : OUT STD_LOGIC;
    burst_f2 : OUT STD_LOGIC;

    addr_data_f0 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_data_f1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_data_f2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_data_f3 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)

    ---------------------------------------------------------------------------
    );

END lpp_top_apbreg;

ARCHITECTURE beh OF lpp_top_apbreg IS
  
  CONSTANT REVISION : INTEGER := 1;
  
  CONSTANT pconfig : apb_config_type := (
    0 => ahb_device_reg (VENDOR_LPP, LPP_DMA_TYPE, 0, REVISION, pirq),
    1 => apb_iobar(paddr, pmask));

  TYPE lpp_SpectralMatrix_regs IS RECORD
    config_active_interruption_onNewMatrix : STD_LOGIC;
    config_active_interruption_onError     : STD_LOGIC;
    status_ready_matrix_f0_0               : STD_LOGIC;
    status_ready_matrix_f0_1               : STD_LOGIC;
    status_ready_matrix_f1                 : STD_LOGIC;
    status_ready_matrix_f2                 : STD_LOGIC;
    status_error_anticipating_empty_fifo   : STD_LOGIC;
    status_error_bad_component_error       : STD_LOGIC;
    addr_matrix_f0_0                       : STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_matrix_f0_1                       : STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_matrix_f1                         : STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_matrix_f2                         : STD_LOGIC_VECTOR(31 DOWNTO 0);
  END RECORD;
  SIGNAL reg_sp : lpp_SpectralMatrix_regs;

  TYPE lpp_WaveformPicker_regs IS RECORD
    status_full        : STD_LOGIC_VECTOR(3 DOWNTO 0);
    status_full_err    : STD_LOGIC_VECTOR(3 DOWNTO 0);
    status_new_err     : STD_LOGIC_VECTOR(3 DOWNTO 0);
    data_shaping_BW    : STD_LOGIC;
    data_shaping_SP0   : STD_LOGIC;
    data_shaping_SP1   : STD_LOGIC;
    data_shaping_R0    : STD_LOGIC;
    data_shaping_R1    : STD_LOGIC;
    delta_snapshot     : STD_LOGIC_VECTOR(delta_snapshot_size-1 DOWNTO 0);
    delta_f2_f1        : STD_LOGIC_VECTOR(delta_f2_f1_size-1 DOWNTO 0);
    delta_f2_f0        : STD_LOGIC_VECTOR(delta_f2_f0_size-1 DOWNTO 0);
    nb_burst_available : STD_LOGIC_VECTOR(nb_burst_available_size-1 DOWNTO 0);
    nb_snapshot_param  : STD_LOGIC_VECTOR(nb_snapshot_param_size-1 DOWNTO 0);
    enable_f0          : STD_LOGIC;
    enable_f1          : STD_LOGIC;
    enable_f2          : STD_LOGIC;
    enable_f3          : STD_LOGIC;
    burst_f0           : STD_LOGIC;
    burst_f1           : STD_LOGIC;
    burst_f2           : STD_LOGIC;
    addr_data_f0       : STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_data_f1       : STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_data_f2       : STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_data_f3       : STD_LOGIC_VECTOR(31 DOWNTO 0);
  END RECORD;
  SIGNAL reg_wp : lpp_WaveformPicker_regs;

  SIGNAL prdata : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN  -- beh

  status_ready_matrix_f0_0             <= reg_sp.status_ready_matrix_f0_0;
  status_ready_matrix_f0_1             <= reg_sp.status_ready_matrix_f0_1;
  status_ready_matrix_f1               <= reg_sp.status_ready_matrix_f1;
  status_ready_matrix_f2               <= reg_sp.status_ready_matrix_f2;
  status_error_anticipating_empty_fifo <= reg_sp.status_error_anticipating_empty_fifo;
  status_error_bad_component_error     <= reg_sp.status_error_bad_component_error;

  config_active_interruption_onNewMatrix <= reg_sp.config_active_interruption_onNewMatrix;
  config_active_interruption_onError     <= reg_sp.config_active_interruption_onError;
  addr_matrix_f0_0                       <= reg_sp.addr_matrix_f0_0;
  addr_matrix_f0_1                       <= reg_sp.addr_matrix_f0_1;
  addr_matrix_f1                         <= reg_sp.addr_matrix_f1;
  addr_matrix_f2                         <= reg_sp.addr_matrix_f2;




  data_shaping_BW  <= reg_wp.data_shaping_BW;
  data_shaping_SP0 <= reg_wp.data_shaping_SP0;
  data_shaping_SP1 <= reg_wp.data_shaping_SP1;
  data_shaping_R0  <= reg_wp.data_shaping_R0;
  data_shaping_R1  <= reg_wp.data_shaping_R1;

  delta_snapshot     <= reg_wp.delta_snapshot;
  delta_f2_f1        <= reg_wp.delta_f2_f1;
  delta_f2_f0        <= reg_wp.delta_f2_f0;
  nb_burst_available <= reg_wp.nb_burst_available;
  nb_snapshot_param  <= reg_wp.nb_snapshot_param;

  enable_f0 <= reg_wp.enable_f0;
  enable_f1 <= reg_wp.enable_f1;
  enable_f2 <= reg_wp.enable_f2;
  enable_f3 <= reg_wp.enable_f3;

  burst_f0 <= reg_wp.burst_f0;
  burst_f1 <= reg_wp.burst_f1;
  burst_f2 <= reg_wp.burst_f2;

  addr_data_f0 <= reg_wp.addr_data_f0;
  addr_data_f1 <= reg_wp.addr_data_f1;
  addr_data_f2 <= reg_wp.addr_data_f2;
  addr_data_f3 <= reg_wp.addr_data_f3;

  lpp_top_apbreg : PROCESS (HCLK, HRESETn)
    VARIABLE paddr : STD_LOGIC_VECTOR(7 DOWNTO 2);
  BEGIN  -- PROCESS lpp_dma_top
    IF HRESETn = '0' THEN               -- asynchronous reset (active low)
      reg_sp.config_active_interruption_onNewMatrix <= '0';
      reg_sp.config_active_interruption_onError     <= '0';
      reg_sp.status_ready_matrix_f0_0               <= '0';
      reg_sp.status_ready_matrix_f0_1               <= '0';
      reg_sp.status_ready_matrix_f1                 <= '0';
      reg_sp.status_ready_matrix_f2                 <= '0';
      reg_sp.status_error_anticipating_empty_fifo   <= '0';
      reg_sp.status_error_bad_component_error       <= '0';
      reg_sp.addr_matrix_f0_0                       <= (OTHERS => '0');
      reg_sp.addr_matrix_f0_1                       <= (OTHERS => '0');
      reg_sp.addr_matrix_f1                         <= (OTHERS => '0');
      reg_sp.addr_matrix_f2                         <= (OTHERS => '0');
      prdata                                        <= (OTHERS => '0');

      apbo.pirq <= (OTHERS => '0');

      status_full_ack <= (OTHERS => '0');

      reg_wp.data_shaping_BW    <= '0';
      reg_wp.data_shaping_SP0   <= '0';
      reg_wp.data_shaping_SP1   <= '0';
      reg_wp.data_shaping_R0    <= '0';
      reg_wp.data_shaping_R1    <= '0';
      reg_wp.enable_f0          <= '0';
      reg_wp.enable_f1          <= '0';
      reg_wp.enable_f2          <= '0';
      reg_wp.enable_f3          <= '0';
      reg_wp.burst_f0           <= '0';
      reg_wp.burst_f1           <= '0';
      reg_wp.burst_f2           <= '0';
      reg_wp.addr_data_f0       <= (OTHERS => '0');
      reg_wp.addr_data_f1       <= (OTHERS => '0');
      reg_wp.addr_data_f2       <= (OTHERS => '0');
      reg_wp.addr_data_f3       <= (OTHERS => '0');
      reg_wp.status_full        <= (OTHERS => '0');
      reg_wp.status_full_err    <= (OTHERS => '0');
      reg_wp.status_new_err     <= (OTHERS => '0');
      reg_wp.delta_snapshot     <= (OTHERS => '0');
      reg_wp.delta_f2_f1        <= (OTHERS => '0');
      reg_wp.delta_f2_f0        <= (OTHERS => '0');
      reg_wp.nb_burst_available <= (OTHERS => '0');
      reg_wp.nb_snapshot_param  <= (OTHERS => '0');
      
    ELSIF HCLK'EVENT AND HCLK = '1' THEN  -- rising clock edge
      status_full_ack <= (OTHERS => '0');

      reg_sp.status_ready_matrix_f0_0 <= reg_sp.status_ready_matrix_f0_0 OR ready_matrix_f0_0;
      reg_sp.status_ready_matrix_f0_1 <= reg_sp.status_ready_matrix_f0_1 OR ready_matrix_f0_1;
      reg_sp.status_ready_matrix_f1   <= reg_sp.status_ready_matrix_f1 OR ready_matrix_f1;
      reg_sp.status_ready_matrix_f2   <= reg_sp.status_ready_matrix_f2 OR ready_matrix_f2;

      reg_sp.status_error_anticipating_empty_fifo <= reg_sp.status_error_anticipating_empty_fifo OR error_anticipating_empty_fifo;
      reg_sp.status_error_bad_component_error     <= reg_sp.status_error_bad_component_error OR error_bad_component_error;

      reg_wp.status_full     <= reg_wp.status_full     OR status_full;
      reg_wp.status_full_err <= reg_wp.status_full_err OR status_full_err;
      reg_wp.status_new_err  <= reg_wp.status_new_err  OR status_new_err;

      paddr             := "000000";
      paddr(7 DOWNTO 2) := apbi.paddr(7 DOWNTO 2);
      prdata            <= (OTHERS => '0');
      IF apbi.psel(pindex) = '1' THEN
        -- APB DMA READ  --
        CASE paddr(7 DOWNTO 2) IS
          --
          WHEN "000000" => prdata(0) <= reg_sp.config_active_interruption_onNewMatrix;
                           prdata(1) <= reg_sp.config_active_interruption_onError;
          WHEN "000001" => prdata(0) <= reg_sp.status_ready_matrix_f0_0;
                           prdata(1) <= reg_sp.status_ready_matrix_f0_1;
                           prdata(2) <= reg_sp.status_ready_matrix_f1;
                           prdata(3) <= reg_sp.status_ready_matrix_f2;
                           prdata(4) <= reg_sp.status_error_anticipating_empty_fifo;
                           prdata(5) <= reg_sp.status_error_bad_component_error;
          WHEN "000010" => prdata    <= reg_sp.addr_matrix_f0_0;
          WHEN "000011" => prdata    <= reg_sp.addr_matrix_f0_1;
          WHEN "000100" => prdata    <= reg_sp.addr_matrix_f1;
          WHEN "000101" => prdata    <= reg_sp.addr_matrix_f2;
          WHEN "000110" => prdata    <= debug_reg;
                           --
          WHEN "001000" => prdata(0) <= reg_wp.data_shaping_BW;
                           prdata(1) <= reg_wp.data_shaping_SP0;
                           prdata(2) <= reg_wp.data_shaping_SP1;
                           prdata(3) <= reg_wp.data_shaping_R0;
                           prdata(4) <= reg_wp.data_shaping_R1;
          WHEN "001001" => prdata(0) <= reg_wp.enable_f0;
                           prdata(1) <= reg_wp.enable_f1;
                           prdata(2) <= reg_wp.enable_f2;
                           prdata(3) <= reg_wp.enable_f3;
                           prdata(4) <= reg_wp.burst_f0;
                           prdata(5) <= reg_wp.burst_f1;
                           prdata(6) <= reg_wp.burst_f2;
          WHEN "001010" => prdata             <= reg_wp.addr_data_f0;
          WHEN "001011" => prdata             <= reg_wp.addr_data_f1;
          WHEN "001100" => prdata             <= reg_wp.addr_data_f2;
          WHEN "001101" => prdata             <= reg_wp.addr_data_f3;
          WHEN "001110" => prdata(3 DOWNTO 0) <= reg_wp.status_full;
                           prdata(7 DOWNTO 4)  <= reg_wp.status_full_err;
                           prdata(11 DOWNTO 8) <= reg_wp.status_new_err;
          WHEN "001111" => prdata(delta_snapshot_size-1 DOWNTO 0)     <= reg_wp.delta_snapshot;
          WHEN "010000" => prdata(delta_f2_f1_size-1 DOWNTO 0)        <= reg_wp.delta_f2_f1;
          WHEN "010001" => prdata(delta_f2_f0_size-1 DOWNTO 0)        <= reg_wp.delta_f2_f0;
          WHEN "010010" => prdata(nb_burst_available_size-1 DOWNTO 0) <= reg_wp.nb_burst_available;
          WHEN "010011" => prdata(nb_snapshot_param_size-1 DOWNTO 0)  <= reg_wp.nb_snapshot_param;
                           --
          WHEN OTHERS   => NULL;
        END CASE;
        IF (apbi.pwrite AND apbi.penable) = '1' THEN
          -- APB DMA WRITE --
          CASE paddr(7 DOWNTO 2) IS
            --
            WHEN "000000" => reg_sp.config_active_interruption_onNewMatrix <= apbi.pwdata(0);
                             reg_sp.config_active_interruption_onError <= apbi.pwdata(1);
            WHEN "000001" => reg_sp.status_ready_matrix_f0_0 <= apbi.pwdata(0);
                             reg_sp.status_ready_matrix_f0_1             <= apbi.pwdata(1);
                             reg_sp.status_ready_matrix_f1               <= apbi.pwdata(2);
                             reg_sp.status_ready_matrix_f2               <= apbi.pwdata(3);
                             reg_sp.status_error_anticipating_empty_fifo <= apbi.pwdata(4);
                             reg_sp.status_error_bad_component_error     <= apbi.pwdata(5);
            WHEN "000010" => reg_sp.addr_matrix_f0_0 <= apbi.pwdata;
            WHEN "000011" => reg_sp.addr_matrix_f0_1 <= apbi.pwdata;
            WHEN "000100" => reg_sp.addr_matrix_f1   <= apbi.pwdata;
            WHEN "000101" => reg_sp.addr_matrix_f2   <= apbi.pwdata;
                             --
            WHEN "001000" => reg_wp.data_shaping_BW  <= apbi.pwdata(0);
                             reg_wp.data_shaping_SP0 <= apbi.pwdata(1);
                             reg_wp.data_shaping_SP1 <= apbi.pwdata(2);
                             reg_wp.data_shaping_R0  <= apbi.pwdata(3);
                             reg_wp.data_shaping_R1  <= apbi.pwdata(4);
            WHEN "001001" => reg_wp.enable_f0 <= apbi.pwdata(0);
                             reg_wp.enable_f1 <= apbi.pwdata(1);
                             reg_wp.enable_f2 <= apbi.pwdata(2);
                             reg_wp.enable_f3 <= apbi.pwdata(3);
                             reg_wp.burst_f0  <= apbi.pwdata(4);
                             reg_wp.burst_f1  <= apbi.pwdata(5);
                             reg_wp.burst_f2  <= apbi.pwdata(6);
            WHEN "001010" => reg_wp.addr_data_f0 <= apbi.pwdata;
            WHEN "001011" => reg_wp.addr_data_f1 <= apbi.pwdata;
            WHEN "001100" => reg_wp.addr_data_f2 <= apbi.pwdata;
            WHEN "001101" => reg_wp.addr_data_f3 <= apbi.pwdata;
            WHEN "001110" => reg_wp.status_full  <= apbi.pwdata(3 DOWNTO 0);
                             reg_wp.status_full_err <= apbi.pwdata(7 DOWNTO 4);
                             reg_wp.status_new_err  <= apbi.pwdata(11 DOWNTO 8);
                             status_full_ack(0)     <= reg_wp.status_full(0) AND NOT apbi.pwdata(0);
                             status_full_ack(1)     <= reg_wp.status_full(1) AND NOT apbi.pwdata(1);
                             status_full_ack(2)     <= reg_wp.status_full(2) AND NOT apbi.pwdata(2);
                             status_full_ack(3)     <= reg_wp.status_full(3) AND NOT apbi.pwdata(3);
            WHEN "001111" => reg_wp.delta_snapshot     <= apbi.pwdata(delta_snapshot_size-1 DOWNTO 0);
            WHEN "010000" => reg_wp.delta_f2_f1        <= apbi.pwdata(delta_f2_f1_size-1 DOWNTO 0);
            WHEN "010001" => reg_wp.delta_f2_f0        <= apbi.pwdata(delta_f2_f0_size-1 DOWNTO 0);
            WHEN "010010" => reg_wp.nb_burst_available <= apbi.pwdata(nb_burst_available_size-1 DOWNTO 0);
            WHEN "010011" => reg_wp.nb_snapshot_param  <= apbi.pwdata(nb_snapshot_param_size-1 DOWNTO 0);
                             --
            WHEN OTHERS   => NULL;
          END CASE;
        END IF;
      END IF;

      apbo.pirq(pirq) <= (reg_sp.config_active_interruption_onNewMatrix AND (ready_matrix_f0_0 OR
                                                                             ready_matrix_f0_1 OR
                                                                             ready_matrix_f1 OR
                                                                             ready_matrix_f2)
                          )
                         OR
                         (reg_sp.config_active_interruption_onError AND (error_anticipating_empty_fifo OR
                                                                         error_bad_component_error)
                          )
                         OR
                         (status_full(0) OR status_full_err(0) OR status_new_err(0) OR
                          status_full(1) OR status_full_err(1) OR status_new_err(1) OR
                          status_full(2) OR status_full_err(2) OR status_new_err(2) OR
                          status_full(3) OR status_full_err(3) OR status_new_err(3)
                          );

      
    END IF;
  END PROCESS lpp_top_apbreg;

  apbo.pindex  <= pindex;
  apbo.pconfig <= pconfig;
  apbo.prdata  <= prdata;


END beh;