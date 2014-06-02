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
--                    Author : Jean-christophe Pellion
--                     Mail : jean-christophe.pellion@lpp.polytechnique.fr
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY lpp;
USE lpp.lpp_lfr_pkg.ALL;
USE lpp.lpp_memory.ALL;
USE lpp.iir_filter.ALL;
USE lpp.spectral_matrix_package.ALL;
use lpp.lpp_fft.all;
use lpp.fft_components.all;

LIBRARY grlib;
USE grlib.amba.ALL;
USE grlib.stdlib.ALL;
USE grlib.devices.ALL;
USE GRLIB.DMA2AHB_Package.ALL;

ENTITY TB IS
  

END TB;


ARCHITECTURE beh OF TB IS
  
  -----------------------------------------------------------------------------
  SIGNAL clk25MHz : STD_LOGIC := '0';
  SIGNAL rstn     : STD_LOGIC := '0';

  -----------------------------------------------------------------------------
  SIGNAL coarse_time                            : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL fine_time                              : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL sample_f0_wen                          : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f0_wdata                        : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
  SIGNAL sample_f1_wen                          : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f1_wdata                        : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
  SIGNAL sample_f2_wen                          : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f2_wdata                        : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
  SIGNAL dma_addr                               : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL dma_data                               : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL dma_valid                              : STD_LOGIC;
  SIGNAL dma_valid_burst                        : STD_LOGIC;
  SIGNAL dma_ren                                : STD_LOGIC;
  SIGNAL dma_done                               : STD_LOGIC;
  SIGNAL ready_matrix_f0                      : STD_LOGIC;
--  SIGNAL ready_matrix_f0_1                      : STD_LOGIC;
  SIGNAL ready_matrix_f1                        : STD_LOGIC;
  SIGNAL ready_matrix_f2                        : STD_LOGIC;
--  SIGNAL error_anticipating_empty_fifo          : STD_LOGIC;
  SIGNAL error_bad_component_error              : STD_LOGIC;
  SIGNAL debug_reg                              : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL status_ready_matrix_f0               : STD_LOGIC;
--  SIGNAL status_ready_matrix_f0_1               : STD_LOGIC;
  SIGNAL status_ready_matrix_f1                 : STD_LOGIC;
  SIGNAL status_ready_matrix_f2                 : STD_LOGIC;
--  SIGNAL status_error_anticipating_empty_fifo   : STD_LOGIC;
--  SIGNAL status_error_bad_component_error       : STD_LOGIC;
  SIGNAL config_active_interruption_onNewMatrix : STD_LOGIC;
  SIGNAL config_active_interruption_onError     : STD_LOGIC;
  SIGNAL addr_matrix_f0                       : STD_LOGIC_VECTOR(31 DOWNTO 0);
--  SIGNAL addr_matrix_f0_1                       : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL addr_matrix_f1                         : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL addr_matrix_f2                         : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL matrix_time_f0                       : STD_LOGIC_VECTOR(47 DOWNTO 0);
--  SIGNAL matrix_time_f0_1                       : STD_LOGIC_VECTOR(47 DOWNTO 0);
  SIGNAL matrix_time_f1                         : STD_LOGIC_VECTOR(47 DOWNTO 0);
  SIGNAL matrix_time_f2                         : STD_LOGIC_VECTOR(47 DOWNTO 0);

  -----------------------------------------------------------------------------
  SIGNAL clk49_152MHz : STD_LOGIC := '0';
  SIGNAL sample_counter_24k : INTEGER;
  SIGNAL s_24576Hz : STD_LOGIC;

  SIGNAL s_24_sync_reg_0 : STD_LOGIC;
  SIGNAL s_24_sync_reg_1 : STD_LOGIC;

  SIGNAL s_24576Hz_sync : STD_LOGIC;
  
  SIGNAL sample_counter_f1 : INTEGER;
  SIGNAL sample_counter_f2 : INTEGER;
  --
  SIGNAL sample_f0_val    : STD_LOGIC;
  SIGNAL sample_f1_val    : STD_LOGIC;
  SIGNAL sample_f2_val    : STD_LOGIC;

  -----------------------------------------------------------------------------
  SIGNAL ren_counter : INTEGER;
  
  SIGNAL error_buffer_full         :  STD_LOGIC;
  SIGNAL error_input_fifo_write    :  STD_LOGIC_VECTOR(2 DOWNTO 0);
  -----------------------------------------------------------------------------
  SIGNAL apbi :  apb_slv_in_type;
  SIGNAL status_full     : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL status_full_ack : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL status_full_err : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL status_new_err  : STD_LOGIC_VECTOR(3 DOWNTO 0);
  
BEGIN  -- beh
  
  clk25MHz      <= NOT clk25MHz     AFTER 20 ns;  
  clk25MHz      <= NOT clk25MHz     AFTER 20 ns;  
  clk49_152MHz  <= NOT clk49_152MHz AFTER 10173 ps;  -- 49.152/2 MHz

  PROCESS
  BEGIN  -- PROCESS
    WAIT UNTIL clk25MHz = '1';
    WAIT UNTIL clk25MHz = '1';
    WAIT UNTIL clk25MHz = '1';
    rstn <= '1';
    WAIT UNTIL clk25MHz = '1';
    

    WAIT FOR 100 ms;
        
    REPORT "*** END simulation ***" SEVERITY failure;
    WAIT;   
    
  END PROCESS;


  -----------------------------------------------------------------------------
  PROCESS (clk49_152MHz, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      sample_counter_24k <= 0;
      s_24576Hz          <= '0';
    ELSIF clk49_152MHz'event AND clk49_152MHz = '1' THEN  -- rising clock edge
      IF sample_counter_24k = 0 THEN
        sample_counter_24k <= 2000;
        s_24576Hz <= NOT s_24576Hz;
      ELSE
        sample_counter_24k <= sample_counter_24k - 1;
      END IF;
    END IF;
  END PROCESS;

  PROCESS (clk25MHz, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      s_24_sync_reg_0 <= '0';
      s_24_sync_reg_1 <= '0';
      s_24576Hz_sync  <= '0';
    ELSIF clk25MHz'event AND clk25MHz = '1' THEN  -- rising clock edge
      s_24_sync_reg_0 <= s_24576Hz;
      s_24_sync_reg_1 <= s_24_sync_reg_0;
      s_24576Hz_sync  <= s_24_sync_reg_0 XOR s_24_sync_reg_1;      
    END IF;
  END PROCESS;
    
  PROCESS (clk25MHz, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      sample_f0_val <= '0';
      sample_f1_val <= '0';
      sample_f2_val <= '0';
      
      sample_counter_f1 <= 0;
      sample_counter_f2 <= 0;
    ELSIF clk25MHz'event AND clk25MHz = '1' THEN  -- rising clock edge
      IF s_24576Hz_sync = '1' THEN
        sample_f0_val <= '1';
        IF sample_counter_f1 = 0 THEN
          sample_f1_val <= '1';
          sample_counter_f1 <= 5;
        ELSE
          sample_f1_val <= '0';
          sample_counter_f1 <= sample_counter_f1 -1;
        END IF;
        IF sample_counter_f2 = 0 THEN
          sample_f2_val <= '1';
          sample_counter_f2 <= 95;
        ELSE
          sample_f2_val <= '0';
          sample_counter_f2 <= sample_counter_f2 -1;
        END IF;          
      ELSE
        sample_f0_val <= '0';
        sample_f1_val <= '0';        
        sample_f2_val <= '0';
      END IF;      
    END IF;
  END PROCESS;



  -----------------------------------------------------------------------------
  coarse_time <= (OTHERS => '0');
  fine_time   <= (OTHERS => '0');
  
  sample_f0_wdata <= X"A000" & X"A111" & X"A222" & X"A333" & X"A444";
  sample_f1_wdata <= X"B000" & X"B111" & X"B222" & X"B333" & X"B444";
  sample_f2_wdata <= X"C000" & X"C111" & X"C222" & X"C333" & X"C444";

  sample_f0_wen <= NOT(sample_f0_val) & NOT(sample_f0_val) & NOT(sample_f0_val) & NOT(sample_f0_val) & NOT(sample_f0_val);
  sample_f1_wen <= NOT(sample_f1_val) & NOT(sample_f1_val) & NOT(sample_f1_val) & NOT(sample_f1_val) & NOT(sample_f1_val);
  sample_f2_wen <= NOT(sample_f2_val) & NOT(sample_f2_val) & NOT(sample_f2_val) & NOT(sample_f2_val) & NOT(sample_f2_val);
  -----------------------------------------------------------------------------
  
  lpp_lfr_ms_1: lpp_lfr_ms
    GENERIC MAP (
      Mem_use => use_CEL)
    PORT MAP (
      clk                                    => clk25MHz,
      rstn                                   => rstn,
      --
      coarse_time                            => coarse_time,
      fine_time                              => fine_time,
      --
      sample_f0_wen                          => sample_f0_wen,
      sample_f0_wdata                        => sample_f0_wdata,
      sample_f1_wen                          => sample_f1_wen,
      sample_f1_wdata                        => sample_f1_wdata,
      sample_f2_wen                          => sample_f2_wen,
      sample_f2_wdata                        => sample_f2_wdata,
      --
      dma_addr                               => dma_addr,
      dma_data                               => dma_data,
      dma_valid                              => dma_valid,
      dma_valid_burst                        => dma_valid_burst,
      dma_ren                                => dma_ren,
      dma_done                               => dma_done,
      
      ready_matrix_f0                      => ready_matrix_f0,
--      ready_matrix_f0_1                      => ready_matrix_f0_1,
      ready_matrix_f1                        => ready_matrix_f1,
      ready_matrix_f2                        => ready_matrix_f2,
--      error_anticipating_empty_fifo          => error_anticipating_empty_fifo,
      error_bad_component_error              => error_bad_component_error,
      error_buffer_full                      => error_buffer_full,
      error_input_fifo_write                 => error_input_fifo_write,
      
      debug_reg                              => debug_reg,
      status_ready_matrix_f0               => status_ready_matrix_f0,
--      status_ready_matrix_f0               => status_ready_matrix_f0_1,
      status_ready_matrix_f1                 => status_ready_matrix_f1,
      status_ready_matrix_f2                 => status_ready_matrix_f2,
--      status_error_anticipating_empty_fifo   => status_error_anticipating_empty_fifo,
--      status_error_bad_component_error       => status_error_bad_component_error,
      config_active_interruption_onNewMatrix => config_active_interruption_onNewMatrix,
      config_active_interruption_onError     => config_active_interruption_onError,
      addr_matrix_f0                       => addr_matrix_f0,
--      addr_matrix_f0_1                       => addr_matrix_f0_1,
      addr_matrix_f1                         => addr_matrix_f1,
      addr_matrix_f2                         => addr_matrix_f2,
      matrix_time_f0                       => matrix_time_f0,
--      matrix_time_f0_1                       => matrix_time_f0_1,
      matrix_time_f1                         => matrix_time_f1,
      matrix_time_f2                         => matrix_time_f2);



  
  lpp_lfr_apbreg_1 : lpp_lfr_apbreg
    GENERIC MAP (
      nb_data_by_buffer_size => 11,
      nb_word_by_buffer_size => 11,
      nb_snapshot_param_size => 11,
      delta_vector_size      => 20,
      delta_vector_size_f0_2 => 7,
      pindex                 => 4,
      paddr                  => 4,
      pmask                  => 16#fff#,
      pirq_ms                => 0,
      pirq_wfp               => 1,
      top_lfr_version        => (OTHERS => '0')
      )
    PORT MAP (
      HCLK    => clk25MHz,
      HRESETn => rstn,
      apbi    => apbi,
      apbo    => OPEN,

      run_ms => OPEN,

      ready_matrix_f0                        => ready_matrix_f0,
      ready_matrix_f1                        => ready_matrix_f1,
      ready_matrix_f2                        => ready_matrix_f2,
      error_bad_component_error              => error_bad_component_error,
      error_buffer_full                      => error_buffer_full,      -- TODO
      error_input_fifo_write                 => error_input_fifo_write, -- TODO
      status_ready_matrix_f0                 => status_ready_matrix_f0,
      status_ready_matrix_f1                 => status_ready_matrix_f1,
      status_ready_matrix_f2                 => status_ready_matrix_f2,
      config_active_interruption_onNewMatrix => config_active_interruption_onNewMatrix,
      config_active_interruption_onError     => config_active_interruption_onError,

      matrix_time_f0    => matrix_time_f0,
      matrix_time_f1    => matrix_time_f1,
      matrix_time_f2     => matrix_time_f2,

      addr_matrix_f0    => addr_matrix_f0,
      addr_matrix_f1    => addr_matrix_f1,
      addr_matrix_f2    => addr_matrix_f2,
      -------------------------------------------------------------------------
      status_full       => status_full,
      status_full_ack   => status_full_ack,
      status_full_err   => status_full_err,
      status_new_err    => status_new_err,
      data_shaping_BW   => OPEN,
      data_shaping_SP0  => OPEN,
      data_shaping_SP1  => OPEN,
      data_shaping_R0   => OPEN,
      data_shaping_R1   => OPEN,
      delta_snapshot    => OPEN,
      delta_f0          => OPEN,
      delta_f0_2        => OPEN,
      delta_f1          => OPEN,
      delta_f2          => OPEN,
      nb_data_by_buffer => OPEN,
      nb_word_by_buffer => OPEN,
      nb_snapshot_param => OPEN,
      enable_f0         => OPEN,
      enable_f1         => OPEN,
      enable_f2         => OPEN,
      enable_f3         => OPEN,
      burst_f0          => OPEN,
      burst_f1          => OPEN,
      burst_f2          => OPEN,
      run               => OPEN,
      addr_data_f0      => OPEN,
      addr_data_f1      => OPEN,
      addr_data_f2      => OPEN,
      addr_data_f3      => OPEN,
      start_date        => OPEN);










  

  

  

--  PROCESS (clk25MHz, rstn)
--  BEGIN  -- PROCESS
--    IF rstn = '0' THEN                  -- asynchronous reset (active low)
--      status_ready_matrix_f0             <= '0';
----      status_ready_matrix_f0_1             <= '0';
--      status_ready_matrix_f1               <= '0';
--      status_ready_matrix_f2               <= '0';
--    ELSIF clk25MHz'event AND clk25MHz = '1' THEN  -- rising clock edge
--      status_ready_matrix_f0             <= status_ready_matrix_f0 OR ready_matrix_f0;
----      status_ready_matrix_f0_1             <= status_ready_matrix_f0_1 OR ready_matrix_f0_1;
--      status_ready_matrix_f1               <= status_ready_matrix_f1 OR ready_matrix_f1;
--      status_ready_matrix_f2               <= status_ready_matrix_f2 OR ready_matrix_f2;
--    END IF;
--  END PROCESS;      


  
--  status_error_anticipating_empty_fifo <= '0';
--  status_error_bad_component_error     <= '0';

--  config_active_interruption_onNewMatrix <= '0';
--  config_active_interruption_onError     <= '0';
--  addr_matrix_f0                         <= (OTHERS => '0');
--  addr_matrix_f0_1                       <= (OTHERS => '0');
--  addr_matrix_f1                         <= (OTHERS => '0');
--  addr_matrix_f2                         <= (OTHERS => '0');


  PROCESS (clk25MHz, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      
      dma_ren  <= '1';
      dma_done <= '0';
      ren_counter <= 0;
    ELSIF clk25MHz'event AND clk25MHz = '1' THEN  -- rising clock edge
      dma_ren  <= '1';
      dma_done <= '0';
      
      IF dma_valid_burst = '1' THEN
        ren_counter <= 17;
      END IF;
      
      IF ren_counter > 1 THEN
        ren_counter <= ren_counter - 1;
        dma_ren <= '0';
      END IF;
      
      IF ren_counter = 1 THEN
        ren_counter <= 0;
        dma_done <= '1';
      END IF;
      
    END IF;
  END PROCESS;

  
END beh;
 
