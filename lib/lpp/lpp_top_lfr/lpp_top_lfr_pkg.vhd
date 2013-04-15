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
      sample_f0_0_wen : OUT  STD_LOGIC_VECTOR(4 DOWNTO 0);
      sample_f0_1_wen : OUT  STD_LOGIC_VECTOR(4 DOWNTO 0);
      sample_f0_wdata : OUT STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
      sample_f1_wen   : OUT  STD_LOGIC_VECTOR(4 DOWNTO 0);
      sample_f1_wdata : OUT STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
      sample_f2_wen   : OUT  STD_LOGIC_VECTOR(4 DOWNTO 0);
      sample_f2_wdata : OUT STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
      sample_f3_wen   : OUT  STD_LOGIC_VECTOR(4 DOWNTO 0);
      sample_f3_wdata : OUT STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0));
  END COMPONENT;

END lpp_top_lfr_pkg;