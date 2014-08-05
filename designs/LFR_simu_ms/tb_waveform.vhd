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

ENTITY testbench IS
END;

ARCHITECTURE behav OF testbench IS

  SIGNAL clk25MHz : STD_LOGIC;
  SIGNAL rstn     : STD_LOGIC := '0';
  -----------------------------------------------------------------------------
  SIGNAL apbi  : apb_slv_in_type;
  SIGNAL apbo  : apb_slv_out_vector := (OTHERS => apb_none);
  SIGNAL ahbsi : ahb_slv_in_type;
  SIGNAL ahbso : ahb_slv_out_vector := (OTHERS => ahbs_none);
  SIGNAL ahbmi : ahb_mst_in_type;
  SIGNAL ahbmo : ahb_mst_out_vector := (OTHERS => ahbm_none);
  -----------------------------------------------------------------------------
  SIGNAL memi       : memory_in_type;
  SIGNAL memo       : memory_out_type;
  SIGNAL wpo        : wprot_out_type;
  SIGNAL sdo        : sdram_out_type;
  -----------------------------------------------------------------------------
  SIGNAL address   : STD_LOGIC_VECTOR(19 DOWNTO 0) := "00000000000000000000";
  SIGNAL data      : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL nSRAM_BE0 : STD_LOGIC;
  SIGNAL nSRAM_BE1 : STD_LOGIC;
  SIGNAL nSRAM_BE2 : STD_LOGIC;
  SIGNAL nSRAM_BE3 : STD_LOGIC;
  SIGNAL nSRAM_WE  : STD_LOGIC;
  SIGNAL nSRAM_CE  : STD_LOGIC;
  SIGNAL nSRAM_OE  : STD_LOGIC;
  -----------------------------------------------------------------------------
  
BEGIN

  -----------------------------------------------------------------------------
  clk25MHz     <= NOT clk25MHz     AFTER 5 ns;      -- 100 MHz
  -----------------------------------------------------------------------------



  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  ahb0 : ahbctrl 
    GENERIC MAP (defmast => 0, split => 0, rrobin  => 1, ioaddr => 16#FFF#, ioen => 0, nahbm => 2, nahbs => 1)
    PORT MAP (rstn, clk25MHz, ahbmi, ahbmo, ahbsi, ahbso);
  
  ----------------------------------------------------------------------
  memctrlr : mctrl
    GENERIC MAP (hindex => 0, pindex => 0, paddr => 0, srbanks => 1)
    PORT    MAP (rstn, clk25MHz, memi, memo, ahbsi, ahbso(0), apbi, apbo(0), wpo, sdo);

  memi.brdyn  <= '1';
  memi.bexcn  <= '1';
  memi.writen <= '1';
  memi.wrn    <= "1111";
  memi.bwidth <= "10";

  bdr : FOR i IN 0 TO 3 GENERATE
    data_pad : iopadv GENERIC MAP (tech => padtech, width => 8)
      PORT MAP (
        data(31-i*8 DOWNTO 24-i*8),
        memo.data(31-i*8 DOWNTO 24-i*8),
        memo.bdrive(i),
        memi.data(31-i*8 DOWNTO 24-i*8));
  END GENERATE;
 
  address   <= memo.address(21 DOWNTO 2);
  nSRAM_CE  <= NOT(memo.ramsn(0));
  nSRAM_OE  <= memo.ramoen(0);
  nSRAM_WE  <= memo.writen;
  nSRAM_BE0 <= memo.mben(3);
  nSRAM_BE1 <= memo.mben(2);
  nSRAM_BE2 <= memo.mben(1); 
  nSRAM_BE3 <= memo.mben(0);
  
  async_1Mx16_0: CY7C1061DV33
    GENERIC MAP (
      ADDR_BITS         => 20,
      DATA_BITS         => 16,
      depth 	        => 1048576,
      MEM_ARRAY_DEBUG   => 32,
      TimingInfo        => TRUE,
      TimingChecks	=> '1')
    PORT MAP (
      CE1_b => '0',
      CE2   => nSRAM_CE,
      WE_b  => nSRAM_WE,
      OE_b  => nSRAM_OE,
      BHE_b => nSRAM_BE1,
      BLE_b => nSRAM_BE0,
      A     => address,
      DQ    => data(15 DOWNTO 0));
  
  async_1Mx16_1: CY7C1061DV33
    GENERIC MAP (
      ADDR_BITS         => 20,
      DATA_BITS         => 16,
      depth 	        => 1048576,
      MEM_ARRAY_DEBUG   => 32,
      TimingInfo        => TRUE,
      TimingChecks	=> '1')
    PORT MAP (
      CE1_b => '0',
      CE2   => nSRAM_CE,
      WE_b  => nSRAM_WE,
      OE_b  => nSRAM_OE,
      BHE_b => nSRAM_BE3,
      BLE_b => nSRAM_BE2,
      A     => address,
      DQ    => data(31 DOWNTO 16));
  -----------------------------------------------------------------------------
  
END;
