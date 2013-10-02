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
      delta_snapshot_size : INTEGER;
      delta_f2_f0_size    : INTEGER;
      delta_f2_f1_size    : INTEGER);
    PORT (
      clk               : IN STD_LOGIC;
      rstn              : IN STD_LOGIC;
      run               : IN STD_LOGIC;
      delta_snapshot    : IN STD_LOGIC_VECTOR(delta_snapshot_size-1 DOWNTO 0);
      delta_f2_f1       : IN STD_LOGIC_VECTOR(delta_f2_f1_size-1 DOWNTO 0);
      delta_f2_f0       : IN STD_LOGIC_VECTOR(delta_f2_f0_size-1 DOWNTO 0);
      coarse_time_0     : IN STD_LOGIC;
      data_f0_in_valid  : IN STD_LOGIC;
      data_f2_in_valid  : IN STD_LOGIC;
      start_snapshot_f0 : OUT STD_LOGIC;
      start_snapshot_f1 : OUT STD_LOGIC;
      start_snapshot_f2 : OUT STD_LOGIC);
  END COMPONENT;

  
  
  COMPONENT lpp_waveform
    GENERIC (
      hindex                 : INTEGER;
      tech                   : INTEGER;
      data_size              : INTEGER;
      nb_burst_available_size : INTEGER;
      nb_snapshot_param_size : INTEGER;
      delta_snapshot_size    : INTEGER;
      delta_f2_f0_size       : INTEGER;
      delta_f2_f1_size       : INTEGER);
    PORT (
      clk               : IN  STD_LOGIC;
      rstn              : IN  STD_LOGIC;
      AHB_Master_In     : IN  AHB_Mst_In_Type;
      AHB_Master_Out    : OUT AHB_Mst_Out_Type;
      coarse_time_0     : IN  STD_LOGIC;
      delta_snapshot    : IN  STD_LOGIC_VECTOR(delta_snapshot_size-1 DOWNTO 0);
      delta_f2_f1       : IN  STD_LOGIC_VECTOR(delta_f2_f1_size-1 DOWNTO 0);
      delta_f2_f0       : IN  STD_LOGIC_VECTOR(delta_f2_f0_size-1 DOWNTO 0);
      enable_f0         : IN  STD_LOGIC;
      enable_f1         : IN  STD_LOGIC;
      enable_f2         : IN  STD_LOGIC;
      enable_f3         : IN  STD_LOGIC;
      burst_f0          : IN  STD_LOGIC;
      burst_f1          : IN  STD_LOGIC;
      burst_f2          : IN  STD_LOGIC;
      run               : IN  STD_LOGIC;
      nb_burst_available : IN  STD_LOGIC_VECTOR(nb_burst_available_size-1 DOWNTO 0);
      nb_snapshot_param : IN  STD_LOGIC_VECTOR(nb_snapshot_param_size-1 DOWNTO 0);
      status_full       : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      status_full_ack   : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      status_full_err   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      status_new_err    : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      addr_data_f0      : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      addr_data_f1      : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      addr_data_f2      : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      addr_data_f3      : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      data_f0_in        : IN  STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
      data_f1_in        : IN  STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
      data_f2_in        : IN  STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
      data_f3_in        : IN  STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
      data_f0_in_valid  : IN  STD_LOGIC;
      data_f1_in_valid  : IN  STD_LOGIC;
      data_f2_in_valid  : IN  STD_LOGIC;
      data_f3_in_valid  : IN  STD_LOGIC);
  END COMPONENT;
  
  COMPONENT lpp_waveform_dma_send_Nword
    PORT (
      HCLK          : IN  STD_ULOGIC;
      HRESETn       : IN  STD_ULOGIC;
      DMAIn         : OUT DMA_In_Type;
      DMAOut        : IN  DMA_OUt_Type;
      Nb_word_less1 : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      send          : IN  STD_LOGIC;
      address       : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      data          : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      ren           : OUT STD_LOGIC;
      send_ok       : OUT STD_LOGIC;
      send_ko       : OUT STD_LOGIC);
  END COMPONENT;

  COMPONENT lpp_waveform_dma_selectaddress
    GENERIC (
      nb_burst_available_size : INTEGER);
    PORT (
      HCLK              : IN  STD_ULOGIC;
      HRESETn           : IN  STD_ULOGIC;
      run           : IN  STD_LOGIC;
      enable : IN STD_LOGIC;      
      update            : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
      nb_burst_available : IN  STD_LOGIC_VECTOR(nb_burst_available_size-1 DOWNTO 0);
      addr_data_reg     : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      addr_data         : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      status_full       : OUT STD_LOGIC;
      status_full_ack   : IN  STD_LOGIC;
      status_full_err   : OUT STD_LOGIC);
  END COMPONENT;

  COMPONENT lpp_waveform_dma_gen_valid
    PORT (
      HCLK      : IN  STD_LOGIC;
      HRESETn   : IN  STD_LOGIC;
      run       : IN  STD_LOGIC;
      valid_in  : IN  STD_LOGIC;
      ack_in    : IN  STD_LOGIC;
      valid_out : OUT STD_LOGIC;
      error     : OUT STD_LOGIC);
  END COMPONENT;

  COMPONENT lpp_waveform_dma
    GENERIC (
      data_size              : INTEGER;
      tech                   : INTEGER;
      hindex                 : INTEGER;
      nb_burst_available_size : INTEGER);
    PORT (
      HCLK              : IN  STD_ULOGIC;
      HRESETn           : IN  STD_ULOGIC;
      run : IN STD_LOGIC;
      AHB_Master_In     : IN  AHB_Mst_In_Type;
      AHB_Master_Out    : OUT AHB_Mst_Out_Type;
      enable             : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);   -- todo
      time_ready         : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);   -- todo
      data_ready        : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);  
      data              : IN  STD_LOGIC_VECTOR(31 DOWNTO 0); 
      data_data_ren     : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      data_time_ren     : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      --data_f0_in        : IN  STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
      --data_f1_in        : IN  STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
      --data_f2_in        : IN  STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
      --data_f3_in        : IN  STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
      --data_f0_in_valid  : IN  STD_LOGIC;
      --data_f1_in_valid  : IN  STD_LOGIC;
      --data_f2_in_valid  : IN  STD_LOGIC;
      --data_f3_in_valid  : IN  STD_LOGIC;
      nb_burst_available : IN  STD_LOGIC_VECTOR(nb_burst_available_size-1 DOWNTO 0);
      status_full       : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      status_full_ack   : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      status_full_err   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
--      status_new_err    : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      addr_data_f0      : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      addr_data_f1      : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      addr_data_f2      : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      addr_data_f3      : IN  STD_LOGIC_VECTOR(31 DOWNTO 0));
  END COMPONENT;
  
  COMPONENT lpp_waveform_fifo_ctrl
    GENERIC (
      offset       : INTEGER;
      length       : INTEGER;
      enable_ready : STD_LOGIC);
    PORT (
      clk          : IN  STD_LOGIC;
      rstn         : IN  STD_LOGIC;
      run          : IN  STD_LOGIC;
      ren          : IN  STD_LOGIC;
      wen          : IN  STD_LOGIC;
      mem_re       : OUT STD_LOGIC;
      mem_we       : OUT STD_LOGIC;
      mem_addr_ren : out STD_LOGIC_VECTOR(6 DOWNTO 0);
      mem_addr_wen : out STD_LOGIC_VECTOR(6 DOWNTO 0);
      ready        : OUT STD_LOGIC);
  END COMPONENT;

  COMPONENT lpp_waveform_fifo_arbiter
    GENERIC (
      tech : INTEGER);
    PORT (
      clk            : IN  STD_LOGIC;
      rstn           : IN  STD_LOGIC;
      run            : IN  STD_LOGIC;
      data_f0_valid  : IN  STD_LOGIC;
      data_f1_valid  : IN  STD_LOGIC;
      data_f2_valid  : IN  STD_LOGIC;
      data_f3_valid  : IN  STD_LOGIC;
      data_valid_ack : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      data_f0        : IN  STD_LOGIC_VECTOR(159 DOWNTO 0);
      data_f1        : IN  STD_LOGIC_VECTOR(159 DOWNTO 0);
      data_f2        : IN  STD_LOGIC_VECTOR(159 DOWNTO 0);
      data_f3        : IN  STD_LOGIC_VECTOR(159 DOWNTO 0);
      ready          : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      time_wen       : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      data_wen       : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      data           : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
  END COMPONENT;
  
  COMPONENT lpp_waveform_fifo
    GENERIC (
      tech : INTEGER);
    PORT (
      clk      : IN  STD_LOGIC;
      rstn     : IN  STD_LOGIC;
      run            : IN  STD_LOGIC;
      time_ready    : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      data_ready    : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      time_ren : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      data_ren : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      rdata    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      time_wen : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      data_wen : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      wdata    : IN STD_LOGIC_VECTOR(31 DOWNTO 0));
  END COMPONENT;


  
END lpp_waveform_pkg;
