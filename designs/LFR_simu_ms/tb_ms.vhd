LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

LIBRARY grlib;
USE grlib.amba.ALL;
USE grlib.stdlib.ALL;
USE grlib.AMBA_TestPackage.ALL;

LIBRARY gaisler;
USE gaisler.memctrl.ALL;
USE gaisler.leon3.ALL;
USE gaisler.uart.ALL;
USE gaisler.misc.ALL;
USE gaisler.libdcom.ALL;
USE gaisler.sim.ALL;
USE gaisler.jtagtst.ALL;
USE gaisler.misc.ALL;

LIBRARY techmap;
USE techmap.gencomp.ALL;

LIBRARY esa;
USE esa.memoryctrl.ALL;

LIBRARY lpp;
USE lpp.lpp_waveform_pkg.ALL;
USE lpp.lpp_memory.ALL;
USE lpp.lpp_ad_conv.ALL;
USE lpp.testbench_package.ALL;
USE lpp.lpp_lfr_pkg.ALL;
USE lpp.iir_filter.ALL;
USE lpp.general_purpose.ALL;
USE lpp.CY7C1061DV33_pkg.ALL;

USE lpp.FILTERcfg.ALL;
USE lpp.lpp_dma_pkg.ALL;
USE lpp.lpp_top_lfr_pkg.ALL;

ENTITY testbench IS
END;

ARCHITECTURE behav OF testbench IS

  SIGNAL clk  : STD_LOGIC := '0';
  SIGNAL rstn : STD_LOGIC := '0';
  -----------------------------------------------------------------------------
  SIGNAL apbi  : apb_slv_in_type;
  SIGNAL apbo  : apb_slv_out_vector := (OTHERS => apb_none);
  SIGNAL ahbsi : ahb_slv_in_type;
  SIGNAL ahbso : ahb_slv_out_vector := (OTHERS => ahbs_none);
  SIGNAL ahbmi : ahb_mst_in_type;
  SIGNAL ahbmo : ahb_mst_out_vector := (OTHERS => ahbm_none);
  -----------------------------------------------------------------------------
  
  -----------------------------------------------------------------------------
  -- DMA
  -----------------------------------------------------------------------------
  SIGNAL dma_send        : STD_LOGIC;
  SIGNAL dma_valid_burst : STD_LOGIC;   -- (1 => BURST , 0 => SINGLE)
  SIGNAL dma_done        : STD_LOGIC;
  SIGNAL dma_ren         : STD_LOGIC;
  SIGNAL dma_address     : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL dma_data        : STD_LOGIC_VECTOR(31 DOWNTO 0);

  -----------------------------------------------------------------------------
  -- WFP
  -----------------------------------------------------------------------------
  SIGNAL data_f0_addr_out             : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
  SIGNAL data_f0_data_out             : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
  SIGNAL data_f0_data_out_valid       : STD_LOGIC := '0';
  SIGNAL data_f0_data_out_valid_burst : STD_LOGIC := '0';
  SIGNAL data_f0_data_out_ren         : STD_LOGIC;
  SIGNAL data_f1_addr_out             : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
  SIGNAL data_f1_data_out             : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
  SIGNAL data_f1_data_out_valid       : STD_LOGIC := '0';
  SIGNAL data_f1_data_out_valid_burst : STD_LOGIC := '0';
  SIGNAL data_f1_data_out_ren         : STD_LOGIC;
  SIGNAL data_f2_addr_out             : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
  SIGNAL data_f2_data_out             : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
  SIGNAL data_f2_data_out_valid       : STD_LOGIC := '0';
  SIGNAL data_f2_data_out_valid_burst : STD_LOGIC := '0';
  SIGNAL data_f2_data_out_ren         : STD_LOGIC;
  SIGNAL data_f3_addr_out             : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
  SIGNAL data_f3_data_out             : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
  SIGNAL data_f3_data_out_valid       : STD_LOGIC := '0';
  SIGNAL data_f3_data_out_valid_burst : STD_LOGIC := '0';
  SIGNAL data_f3_data_out_ren         : STD_LOGIC;
  
  -----------------------------------------------------------------------------
  -- ARBITER
  -----------------------------------------------------------------------------
  SIGNAL dma_sel_valid   : STD_LOGIC;
  SIGNAL dma_rr_valid    : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL dma_rr_grant_s  : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL dma_rr_grant_ms : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL dma_rr_valid_ms : STD_LOGIC_VECTOR(3 DOWNTO 0);

  SIGNAL dma_rr_grant : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL dma_sel      : STD_LOGIC_VECTOR(4 DOWNTO 0);

  -----------------------------------------------------------------------------
  SIGNAL coarse_time : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
  SIGNAL fine_time   : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- MS
  -----------------------------------------------------------------------------
  SIGNAL ready_matrix_f0_0                      : STD_LOGIC;
  SIGNAL ready_matrix_f0_1                      : STD_LOGIC;
  SIGNAL ready_matrix_f1                        : STD_LOGIC;
  SIGNAL ready_matrix_f2                        : STD_LOGIC;
  SIGNAL error_anticipating_empty_fifo          : STD_LOGIC;
  SIGNAL error_bad_component_error              : STD_LOGIC;
  SIGNAL debug_reg                              : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL status_ready_matrix_f0_0               : STD_LOGIC;
  SIGNAL status_ready_matrix_f0_1               : STD_LOGIC;
  SIGNAL status_ready_matrix_f1                 : STD_LOGIC;
  SIGNAL status_ready_matrix_f2                 : STD_LOGIC;
  SIGNAL status_error_anticipating_empty_fifo   : STD_LOGIC;
  SIGNAL status_error_bad_component_error       : STD_LOGIC;
  SIGNAL config_active_interruption_onNewMatrix : STD_LOGIC;
  SIGNAL config_active_interruption_onError     : STD_LOGIC;
  SIGNAL addr_matrix_f0_0                       : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL addr_matrix_f0_1                       : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL addr_matrix_f1                         : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL addr_matrix_f2                         : STD_LOGIC_VECTOR(31 DOWNTO 0);
  -----------------------------------------------------------------------------
  SIGNAL sample_f0_wen    : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f1_wen    : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f3_wen    : STD_LOGIC_VECTOR(4 DOWNTO 0);
  --
  SIGNAL sample_f0_val    : STD_LOGIC;
  SIGNAL sample_f1_val    : STD_LOGIC;
  SIGNAL sample_f3_val    : STD_LOGIC;
  --
  SIGNAL sample_f0_data   : STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
  SIGNAL sample_f1_data   : STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
  SIGNAL sample_f3_data   : STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
  --
  SIGNAL sample_f0_wdata  : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
  SIGNAL sample_f1_wdata  : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
  SIGNAL sample_f3_wdata  : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
  -----------------------------------------------------------------------------
  SIGNAL data_ms_addr        : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_ms_data        : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_ms_valid       : STD_LOGIC;
  SIGNAL data_ms_valid_burst : STD_LOGIC;
  SIGNAL data_ms_ren         : STD_LOGIC;
  SIGNAL data_ms_done        : STD_LOGIC;
  -----------------------------------------------------------------------------
  SIGNAL matrix_time_f0_0    : STD_LOGIC_VECTOR(47 DOWNTO 0);
  SIGNAL matrix_time_f0_1    : STD_LOGIC_VECTOR(47 DOWNTO 0);
  SIGNAL matrix_time_f1      : STD_LOGIC_VECTOR(47 DOWNTO 0);
  SIGNAL matrix_time_f2      : STD_LOGIC_VECTOR(47 DOWNTO 0);

  SIGNAL observation_reg : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL run : STD_LOGIC := '1';
  -----------------------------------------------------------------------------
  SIGNAL dma_counter : INTEGER;
  SIGNAL dma_done_reg : STD_LOGIC;
  -----------------------------------------------------------------------------
  SIGNAL sample_counter_24k : INTEGER;
  SIGNAL s_24576Hz : STD_LOGIC;
  SIGNAL clk49_152MHz : STD_LOGIC := '0';

  SIGNAL s_24_sync_reg_0 : STD_LOGIC;
  SIGNAL s_24_sync_reg_1 : STD_LOGIC;

  SIGNAL s_24576Hz_sync : STD_LOGIC;
  
  
  SIGNAL sample_counter_f1 : INTEGER;
  SIGNAL sample_counter_f2 : INTEGER;
  -----------------------------------------------------------------------------
BEGIN

  -----------------------------------------------------------------------------
  clk49_152MHz  <= NOT clk49_152MHz AFTER 10173 ps;  -- 49.152/2 MHz
  clk           <= NOT clk AFTER 5  ns;      -- 100 MHz
  rstn          <= '1'     AFTER 30 ns;
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

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      s_24_sync_reg_0 <= '0';
      s_24_sync_reg_1 <= '0';
      s_24576Hz_sync  <= '0';
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      s_24_sync_reg_0 <= s_24576Hz;
      s_24_sync_reg_1 <= s_24_sync_reg_0;
      s_24576Hz_sync  <= s_24_sync_reg_0 XOR s_24_sync_reg_1;      
    END IF;
  END PROCESS;
    
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      sample_f0_val <= '0';
      sample_f1_val <= '0';
      sample_f3_val <= '0';
      
      sample_counter_f1 <= 0;
      sample_counter_f2 <= 0;
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
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
          sample_f3_val <= '1';
          sample_counter_f2 <= 95;
        ELSE
          sample_f3_val <= '0';
          sample_counter_f2 <= sample_counter_f2 -1;
        END IF;          
      ELSE
        sample_f0_val <= '0';
        sample_f1_val <= '0';        
        sample_f3_val <= '0';
      END IF;      
    END IF;
  END PROCESS;
  
  sample_f0_data <= (OTHERS => '0');
  sample_f1_data <= (OTHERS => '0');
  sample_f3_data <= (OTHERS => '0');
  -----------------------------------------------------------------------------
  sample_f0_wen <= NOT(sample_f0_val) & NOT(sample_f0_val) & NOT(sample_f0_val) & NOT(sample_f0_val) & NOT(sample_f0_val);
  sample_f1_wen <= NOT(sample_f1_val) & NOT(sample_f1_val) & NOT(sample_f1_val) & NOT(sample_f1_val) & NOT(sample_f1_val);
  sample_f3_wen <= NOT(sample_f3_val) & NOT(sample_f3_val) & NOT(sample_f3_val) & NOT(sample_f3_val) & NOT(sample_f3_val);

  -- (MSB) E2 E1 B2 B1 B0 (LSB)
  sample_f0_wdata <= sample_f0_data((3*16)-1 DOWNTO (1*16)) & sample_f0_data((6*16)-1 DOWNTO (3*16));
  sample_f1_wdata <= sample_f1_data((3*16)-1 DOWNTO (1*16)) & sample_f1_data((6*16)-1 DOWNTO (3*16));
  sample_f3_wdata <= sample_f3_data((3*16)-1 DOWNTO (1*16)) & sample_f3_data((6*16)-1 DOWNTO (3*16));

  -----------------------------------------------------------------------------
  tb: PROCESS 
  BEGIN
    WAIT UNTIL rstn = '1';
    WAIT UNTIL clk  = '1';
    WAIT UNTIL clk  = '1';
    status_ready_matrix_f0_0             <= '0';
    status_ready_matrix_f0_1             <= '0';
    status_ready_matrix_f1               <= '0';
    status_ready_matrix_f2               <= '0';
    status_error_anticipating_empty_fifo <= '0';
    status_error_bad_component_error     <= '0';
    config_active_interruption_onNewMatrix <= '1';
    config_active_interruption_onError     <= '0';

    addr_matrix_f0_0 <= X"40000000";
    addr_matrix_f0_1 <= X"40020000";
    addr_matrix_f1   <= X"40040000";
    addr_matrix_f2   <= X"40060000";
    WAIT UNTIL clk  = '1';    
  END PROCESS tb;
  
  -----------------------------------------------------------------------------
  -- MS
  -----------------------------------------------------------------------------
  lpp_lfr_ms_1 : lpp_lfr_ms
    GENERIC MAP (
      Mem_use => use_RAM)
    PORT MAP (
      clk  => clk,
      rstn => rstn,

      coarse_time     => coarse_time,
      fine_time       => fine_time,

      sample_f0_wen   => sample_f0_wen,
      sample_f0_wdata => sample_f0_wdata,
      sample_f1_wen   => sample_f1_wen,
      sample_f1_wdata => sample_f1_wdata,
      sample_f3_wen   => sample_f3_wen,
      sample_f3_wdata => sample_f3_wdata,

      dma_addr        => data_ms_addr,         --
      dma_data        => data_ms_data,         --
      dma_valid       => data_ms_valid,        --
      dma_valid_burst => data_ms_valid_burst,  --
      dma_ren         => data_ms_ren,          --
      dma_done        => data_ms_done,         --

      -- reg out
      ready_matrix_f0_0                      => ready_matrix_f0_0,
      ready_matrix_f0_1                      => ready_matrix_f0_1,
      ready_matrix_f1                        => ready_matrix_f1,
      ready_matrix_f2                        => ready_matrix_f2,
      error_anticipating_empty_fifo          => error_anticipating_empty_fifo,
      error_bad_component_error              => error_bad_component_error,
      debug_reg                              => observation_reg,  --debug_reg,

      -- reg in
      status_ready_matrix_f0_0               => status_ready_matrix_f0_0,
      status_ready_matrix_f0_1               => status_ready_matrix_f0_1,
      status_ready_matrix_f1                 => status_ready_matrix_f1,
      status_ready_matrix_f2                 => status_ready_matrix_f2,
      status_error_anticipating_empty_fifo   => status_error_anticipating_empty_fifo,
      status_error_bad_component_error       => status_error_bad_component_error,
      config_active_interruption_onNewMatrix => config_active_interruption_onNewMatrix,
      config_active_interruption_onError     => config_active_interruption_onError,
      addr_matrix_f0_0                       => addr_matrix_f0_0,
      addr_matrix_f0_1                       => addr_matrix_f0_1,
      addr_matrix_f1                         => addr_matrix_f1,
      addr_matrix_f2                         => addr_matrix_f2,

      matrix_time_f0_0                       => matrix_time_f0_0,
      matrix_time_f0_1                       => matrix_time_f0_1,
      matrix_time_f1                         => matrix_time_f1,
      matrix_time_f2                         => matrix_time_f2);

  -----------------------------------------------------------------------------
  -- ARBITER
  -----------------------------------------------------------------------------
  dma_rr_valid(0) <= data_f0_data_out_valid OR data_f0_data_out_valid_burst;
  dma_rr_valid(1) <= data_f1_data_out_valid OR data_f1_data_out_valid_burst;
  dma_rr_valid(2) <= data_f2_data_out_valid OR data_f2_data_out_valid_burst;
  dma_rr_valid(3) <= data_f3_data_out_valid OR data_f3_data_out_valid_burst;

  RR_Arbiter_4_1 : RR_Arbiter_4
    PORT MAP (
      clk       => clk,
      rstn      => rstn,
      in_valid  => dma_rr_valid,
      out_grant => dma_rr_grant_s);

  dma_rr_valid_ms(0) <= data_ms_valid OR data_ms_valid_burst;
  dma_rr_valid_ms(1) <= '0' WHEN dma_rr_grant_s = "0000" ELSE '1';
  dma_rr_valid_ms(2) <= '0';
  dma_rr_valid_ms(3) <= '0';

  RR_Arbiter_4_2 : RR_Arbiter_4
    PORT MAP (
      clk       => clk,
      rstn      => rstn,
      in_valid  => dma_rr_valid_ms,
      out_grant => dma_rr_grant_ms);

  dma_rr_grant <= dma_rr_grant_ms(0) & "0000" WHEN dma_rr_grant_ms(0) = '1' ELSE '0' & dma_rr_grant_s;
  
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      dma_sel         <= (OTHERS => '0');
      dma_send        <= '0';
      dma_valid_burst <= '0';
      data_ms_done    <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
      IF run = '1' THEN
        data_ms_done <= '0';
        IF dma_sel = "00000" OR dma_done = '1' THEN
          dma_sel <= dma_rr_grant;
          IF dma_rr_grant(0) = '1' THEN
            dma_send        <= '1';
            dma_valid_burst <= data_f0_data_out_valid_burst;
            dma_sel_valid   <= data_f0_data_out_valid;
          ELSIF dma_rr_grant(1) = '1' THEN
            dma_send        <= '1';
            dma_valid_burst <= data_f1_data_out_valid_burst;
            dma_sel_valid   <= data_f1_data_out_valid;
          ELSIF dma_rr_grant(2) = '1' THEN
            dma_send        <= '1';
            dma_valid_burst <= data_f2_data_out_valid_burst;
            dma_sel_valid   <= data_f2_data_out_valid;
          ELSIF dma_rr_grant(3) = '1' THEN
            dma_send        <= '1';
            dma_valid_burst <= data_f3_data_out_valid_burst;
            dma_sel_valid   <= data_f3_data_out_valid;
          ELSIF dma_rr_grant(4) = '1' THEN
            dma_send        <= '1';
            dma_valid_burst <= data_ms_valid_burst;
            dma_sel_valid   <= data_ms_valid;
          END IF;

          IF dma_sel(4) = '1' THEN
            data_ms_done <= '1';
          END IF;
        ELSE
          dma_sel  <= dma_sel;
          dma_send <= '0';
        END IF;
      ELSE
        data_ms_done    <= '0';
        dma_sel         <= (OTHERS => '0');
        dma_send        <= '0';
        dma_valid_burst <= '0';
      END IF;
    END IF;
  END PROCESS;


  dma_address <= data_f0_addr_out WHEN dma_sel(0) = '1' ELSE
                 data_f1_addr_out WHEN dma_sel(1) = '1' ELSE
                 data_f2_addr_out WHEN dma_sel(2) = '1' ELSE
                 data_f3_addr_out WHEN dma_sel(3) = '1' ELSE
                 data_ms_addr;
  
  dma_data <= data_f0_data_out WHEN dma_sel(0) = '1' ELSE
              data_f1_data_out WHEN dma_sel(1) = '1' ELSE
              data_f2_data_out WHEN dma_sel(2) = '1' ELSE
              data_f3_data_out WHEN dma_sel(3) = '1' ELSE
              data_ms_data;
  
  data_f0_data_out_ren <= dma_ren WHEN dma_sel(0) = '1' ELSE '1';
  data_f1_data_out_ren <= dma_ren WHEN dma_sel(1) = '1' ELSE '1';
  data_f2_data_out_ren <= dma_ren WHEN dma_sel(2) = '1' ELSE '1';
  data_f3_data_out_ren <= dma_ren WHEN dma_sel(3) = '1' ELSE '1';
  data_ms_ren          <= dma_ren WHEN dma_sel(4) = '1' ELSE '1';

  -----------------------------------------------------------------------------
  -- DMA
  -----------------------------------------------------------------------------
  --lpp_dma_singleOrBurst_1 : lpp_dma_singleOrBurst
  --  GENERIC MAP (
  --    tech   => inferred,
  --    hindex => 0)
  --  PORT MAP (
  --    HCLK           => clk,
  --    HRESETn        => rstn,
  --    run            => run,
  --    AHB_Master_In  => ahbmi,
  --    AHB_Master_Out => ahbmo(0),

  --    send        => dma_send,
  --    valid_burst => dma_valid_burst,
  --    done        => dma_done,
  --    ren         => dma_ren,
  --    address     => dma_address,
  --    data        => dma_data);

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      dma_counter <= 0;
      dma_done_reg    <= '0';
      dma_done    <= '0';
      dma_ren     <= '1';
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      dma_done_reg    <= '0';
      dma_ren         <= '1';
      
      IF dma_send = '1' THEN
        dma_counter     <= 15;
        dma_done_reg    <= '0';
        dma_ren         <= '0';  
      END IF;
      
      IF dma_counter > 0 THEN
        IF dma_counter = 1 THEN
          dma_done_reg <= '1';
        END IF;
        dma_ren <= '0';
        dma_counter <= dma_counter - 1;
      END IF;
      
      dma_done <= dma_done_reg;
    END IF;
  END PROCESS;
  
  -----------------------------------------------------------------------------
  -- MEMORY + AHB CTRL
  -----------------------------------------------------------------------------
  --tb_memory_1: tb_memory
  --  GENERIC MAP (
  --    n_ahb_m => 2,
  --    n_ahb_s => 1)
  --  PORT MAP (
  --    clk   => clk,
  --    rstn  => rstn,
  --    ahbsi => ahbsi,
  --    ahbso => ahbso,
  --    ahbmi => ahbmi,
  --    ahbmo => ahbmo);
  -----------------------------------------------------------------------------
END;
