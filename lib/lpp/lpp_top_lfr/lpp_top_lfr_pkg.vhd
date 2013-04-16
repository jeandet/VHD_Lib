LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
LIBRARY lpp;
USE lpp.lpp_ad_conv.ALL;
USE lpp.iir_filter.ALL;
USE lpp.FILTERcfg.ALL;
USE lpp.lpp_memory.ALL;
LIBRARY techmap;
USE techmap.gencomp.ALL;

PACKAGE lpp_top_lfr_pkg IS

  COMPONENT lpp_top_acq
    GENERIC (
      tech : integer);
    PORT (
      cnv_run         : IN  STD_LOGIC;
      cnv             : OUT STD_LOGIC;
      sck             : OUT STD_LOGIC;
      sdo             : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
      cnv_clk         : IN  STD_LOGIC;
      cnv_rstn        : IN  STD_LOGIC;
      clk             : IN  STD_LOGIC;
      rstn            : IN  STD_LOGIC;
      sample_f0_0_wen : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
      sample_f0_1_wen : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
      sample_f0_wdata : OUT STD_LOGIC_VECTOR((5*18)-1 DOWNTO 0);
      sample_f1_wen   : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
      sample_f1_wdata : OUT STD_LOGIC_VECTOR((5*18)-1 DOWNTO 0);
      sample_f2_wen   : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
      sample_f2_wdata : OUT STD_LOGIC_VECTOR((5*18)-1 DOWNTO 0);
      sample_f3_wen   : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
      sample_f3_wdata : OUT STD_LOGIC_VECTOR((5*18)-1 DOWNTO 0));
  END COMPONENT;

  COMPONENT lpp_top_apbreg
    GENERIC (
      pindex : INTEGER;
      paddr  : INTEGER;
      pmask  : INTEGER;
      pirq   : INTEGER);
    PORT (
      HCLK                                   : IN  STD_ULOGIC;
      HRESETn                                : IN  STD_ULOGIC;
      apbi                                   : IN  apb_slv_in_type;
      apbo                                   : OUT apb_slv_out_type;
      ready_matrix_f0_0                      : IN  STD_LOGIC;
      ready_matrix_f0_1                      : IN  STD_LOGIC;
      ready_matrix_f1                        : IN  STD_LOGIC;
      ready_matrix_f2                        : IN  STD_LOGIC;
      error_anticipating_empty_fifo          : IN  STD_LOGIC;
      error_bad_component_error              : IN  STD_LOGIC;
      debug_reg                              : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      status_ready_matrix_f0_0               : OUT STD_LOGIC;
      status_ready_matrix_f0_1               : OUT STD_LOGIC;
      status_ready_matrix_f1                 : OUT STD_LOGIC;
      status_ready_matrix_f2                 : OUT STD_LOGIC;
      status_error_anticipating_empty_fifo   : OUT STD_LOGIC;
      status_error_bad_component_error       : OUT STD_LOGIC;
      config_active_interruption_onNewMatrix : OUT STD_LOGIC;
      config_active_interruption_onError     : OUT STD_LOGIC;
      addr_matrix_f0_0                       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      addr_matrix_f0_1                       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      addr_matrix_f1                         : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      addr_matrix_f2                         : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
  END COMPONENT;

END lpp_top_lfr_pkg;
