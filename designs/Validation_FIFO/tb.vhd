
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.MATH_REAL.ALL;
USE ieee.numeric_std.ALL;

LIBRARY lpp;
USE lpp.lpp_memory.ALL;
USE lpp.iir_filter.ALL;


ENTITY testbench IS
END;

ARCHITECTURE behav OF testbench IS
  
  COMPONENT fifo_verif
    PORT (
      verif_clk         : OUT STD_LOGIC;
      verif_rstn        : OUT STD_LOGIC;
      verif_ren         : OUT STD_LOGIC;
      verif_rdata       : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      verif_wen         : OUT STD_LOGIC;
      verif_wdata       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      verif_empty       : IN  STD_LOGIC;
      verif_full        : IN  STD_LOGIC;
      verif_almost_full : IN  STD_LOGIC;
      error_now         : OUT STD_LOGIC;
      error_new         : OUT STD_LOGIC);
  END COMPONENT;

  -----------------------------------------------------------------------------
  SIGNAL CEL_clk  : STD_LOGIC := '0';
  SIGNAL CEL_rstn : STD_LOGIC := '0';
  -----------------------------------------------------------------------------
  SIGNAL CEL_data_ren    : STD_LOGIC;
  SIGNAL CEL_data_out    : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL CEL_data_wen    : STD_LOGIC;
  SIGNAL CEL_wdata       : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL CEL_full_almost : STD_LOGIC;
  SIGNAL CEL_full        : STD_LOGIC;
  SIGNAL CEL_empty       : STD_LOGIC;
  -----------------------------------------------------------------------------
  SIGNAL CEL_error_now : STD_LOGIC;
  SIGNAL CEL_error_new : STD_LOGIC;
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  SIGNAL RAM_clk  : STD_LOGIC := '0';
  SIGNAL RAM_rstn : STD_LOGIC := '0';
  -----------------------------------------------------------------------------
  SIGNAL RAM_data_ren    : STD_LOGIC;
  SIGNAL RAM_data_out    : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL RAM_data_wen    : STD_LOGIC;
  SIGNAL RAM_wdata       : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL RAM_full_almost : STD_LOGIC;
  SIGNAL RAM_full        : STD_LOGIC;
  SIGNAL RAM_empty       : STD_LOGIC;
  -----------------------------------------------------------------------------
  SIGNAL RAM_error_now : STD_LOGIC;
  SIGNAL RAM_error_new : STD_LOGIC;
  -----------------------------------------------------------------------------
  
BEGIN


  -----------------------------------------------------------------------------
  lpp_fifo_CEL : lpp_fifo
    GENERIC MAP (
      tech    => 0,
      Mem_use => use_CEL,
    EMPTY_THRESHOLD_LIMIT => 1,
    FULL_THRESHOLD_LIMIT  => 1,
      DataSz  => 32,
      AddrSz  => 8)
    PORT MAP (
      clk         => CEL_clk,
      rstn        => CEL_rstn,
      reUse       => '0',
      ren         => CEL_data_ren,
      rdata       => CEL_data_out,
      wen         => CEL_data_wen,
      wdata       => CEL_wdata,
      empty       => CEL_empty,
      full        => CEL_full,
      full_almost => CEL_full_almost,
      empty_threshold => OPEN,
      full_threshold  => OPEN);
  -----------------------------------------------------------------------------
  fifo_verif_CEL : fifo_verif
    PORT MAP (
      verif_clk         => CEL_clk,
      verif_rstn        => CEL_rstn,
      verif_ren         => CEL_data_ren,
      verif_rdata       => CEL_data_out,
      verif_wen         => CEL_data_wen,
      verif_wdata       => CEL_wdata,
      verif_empty       => CEL_empty,
      verif_full        => CEL_full,
      verif_almost_full => CEL_full_almost,
      error_now         => CEL_error_now,
      error_new         => CEL_error_new
      );
  -----------------------------------------------------------------------------

  
  -----------------------------------------------------------------------------
  lpp_fifo_RAM : lpp_fifo
    GENERIC MAP (
      tech    => 0,
      Mem_use => use_RAM,
      EMPTY_THRESHOLD_LIMIT => 1,
      FULL_THRESHOLD_LIMIT  => 1,
      DataSz  => 32,
      AddrSz  => 8)
    PORT MAP (
      clk         => RAM_clk,
      rstn        => RAM_rstn,
      reUse       => '0',
      ren         => RAM_data_ren,
      rdata       => RAM_data_out,
      wen         => RAM_data_wen,
      wdata       => RAM_wdata,
      empty       => RAM_empty,
      full        => RAM_full,
      full_almost => RAM_full_almost,
      empty_threshold => OPEN,
      full_threshold  => OPEN);
  -----------------------------------------------------------------------------
  fifo_verif_RAM : fifo_verif
    PORT MAP (
      verif_clk         => RAM_clk,
      verif_rstn        => RAM_rstn,
      verif_ren         => RAM_data_ren,
      verif_rdata       => RAM_data_out,
      verif_wen         => RAM_data_wen,
      verif_wdata       => RAM_wdata,
      verif_empty       => RAM_empty,
      verif_full        => RAM_full,
      verif_almost_full => RAM_full_almost,
      error_now         => RAM_error_now,
      error_new         => RAM_error_new
      );
  -----------------------------------------------------------------------------


END;
