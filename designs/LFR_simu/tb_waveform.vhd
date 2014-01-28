------------------------------------------------------------------------------
--  LEON3 Demonstration design test bench
--  Copyright (C) 2004 Jiri Gaisler, Gaisler Research
------------------------------------------------------------------------------
--  This file is a part of the GRLIB VHDL IP LIBRARY
--  Copyright (C) 2013, Aeroflex Gaisler AB - all rights reserved.
--
-- ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN 
-- ACCORDANCE WITH THE GAISLER LICENSE AGREEMENT AND MUST BE APPROVED 
-- IN ADVANCE IN WRITING. 
------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

--LIBRARY std;
--USE std.textio.ALL;

LIBRARY grlib;
USE grlib.amba.ALL;
USE grlib.stdlib.ALL;
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
--LIBRARY micron;
--USE micron.components.ALL;
LIBRARY lpp;
USE lpp.lpp_waveform_pkg.ALL;
USE lpp.lpp_memory.ALL;
USE lpp.lpp_ad_conv.ALL;
USE lpp.testbench_package.ALL;
USE lpp.lpp_lfr_pkg.ALL;
USE lpp.iir_filter.ALL;
USE lpp.general_purpose.ALL;
USE lpp.CY7C1061DV33_pkg.ALL;

ENTITY testbenc h IS
END;

ARCHITECTURE behav OF testbench IS
  -- REG ADDRESS
  CONSTANT INDEX_WAVEFORM_PICKER                  : INTEGER                       := 15;
  CONSTANT ADDR_WAVEFORM_PICKER                   : INTEGER                       := 15;
  CONSTANT ADDR_WAVEFORM_PICKER_DATASHAPING       : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F20";
  CONSTANT ADDR_WAVEFORM_PICKER_CONTROL           : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F24";
  CONSTANT ADDR_WAVEFORM_PICKER_ADDRESS_F0        : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F28";
  CONSTANT ADDR_WAVEFORM_PICKER_ADDRESS_F1        : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F2C";
  CONSTANT ADDR_WAVEFORM_PICKER_ADDRESS_F2        : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F30";
  CONSTANT ADDR_WAVEFORM_PICKER_ADDRESS_F3        : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F34";
  CONSTANT ADDR_WAVEFORM_PICKER_STATUS            : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F38";
  CONSTANT ADDR_WAVEFORM_PICKER_DELTASNAPSHOT     : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F3C";
  CONSTANT ADDR_WAVEFORM_PICKER_DELTA_F0          : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F40";
  CONSTANT ADDR_WAVEFORM_PICKER_DELTA_F0_2        : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F44";
  CONSTANT ADDR_WAVEFORM_PICKER_DELTA_F1          : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F48";
  CONSTANT ADDR_WAVEFORM_PICKER_DELTA_F2          : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F4C";
  CONSTANT ADDR_WAVEFORM_PICKER_NB_DATA_IN_BUFFER : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F50";
  CONSTANT ADDR_WAVEFORM_PICKER_NBSNAPSHOT        : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F54";
  CONSTANT ADDR_WAVEFORM_PICKER_START_DATE        : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F58";
  CONSTANT ADDR_WAVEFORM_PICKER_NB_WORD_IN_BUFFER : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F5C";
  -- RAM ADDRESS
  CONSTANT AHB_RAM_ADDR_0                         : INTEGER                       := 16#100#;
  CONSTANT AHB_RAM_ADDR_1                         : INTEGER                       := 16#200#;
  CONSTANT AHB_RAM_ADDR_2                         : INTEGER                       := 16#300#;
  CONSTANT AHB_RAM_ADDR_3                         : INTEGER                       := 16#400#;


  -- Common signal
  SIGNAL clk49_152MHz : STD_LOGIC := '0';
  SIGNAL clk25MHz     : STD_LOGIC := '0';
  SIGNAL rstn         : STD_LOGIC := '0';

  -- ADC interface
  SIGNAL ADC_OEB_bar_CH : STD_LOGIC_VECTOR(7 DOWNTO 0);   -- OUT
  SIGNAL ADC_smpclk     : STD_LOGIC;                      -- OUT
  SIGNAL ADC_data       : STD_LOGIC_VECTOR(13 DOWNTO 0);  -- IN

  -- AD Converter RHF1401
  SIGNAL sample     : Samples14v(7 DOWNTO 0);
  SIGNAL sample_val : STD_LOGIC;

  -- AHB/APB SIGNAL
  SIGNAL apbi  : apb_slv_in_type;
  SIGNAL apbo  : apb_slv_out_vector := (OTHERS => apb_none);
  SIGNAL ahbsi : ahb_slv_in_type;
  SIGNAL ahbso : ahb_slv_out_vector := (OTHERS => ahbs_none);
  SIGNAL ahbmi : ahb_mst_in_type;
  SIGNAL ahbmo : ahb_mst_out_vector := (OTHERS => ahbm_none);

  SIGNAL bias_fail_bw : STD_LOGIC;

  -----------------------------------------------------------------------------
  -- LPP_WAVEFORM
  -----------------------------------------------------------------------------
  CONSTANT data_size               : INTEGER := 96;
  CONSTANT nb_burst_available_size : INTEGER := 50;
  CONSTANT nb_snapshot_param_size  : INTEGER := 2;
  CONSTANT delta_vector_size       : INTEGER := 2;
  CONSTANT delta_vector_size_f0_2  : INTEGER := 2;

  SIGNAL reg_run                      : STD_LOGIC;
  SIGNAL reg_start_date               : STD_LOGIC_VECTOR(30 DOWNTO 0);
  SIGNAL reg_delta_snapshot           : STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
  SIGNAL reg_delta_f0                 : STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
  SIGNAL reg_delta_f0_2               : STD_LOGIC_VECTOR(delta_vector_size_f0_2-1 DOWNTO 0);
  SIGNAL reg_delta_f1                 : STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
  SIGNAL reg_delta_f2                 : STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
  SIGNAL enable_f0                    : STD_LOGIC;
  SIGNAL enable_f1                    : STD_LOGIC;
  SIGNAL enable_f2                    : STD_LOGIC;
  SIGNAL enable_f3                    : STD_LOGIC;
  SIGNAL burst_f0                     : STD_LOGIC;
  SIGNAL burst_f1                     : STD_LOGIC;
  SIGNAL burst_f2                     : STD_LOGIC;
  SIGNAL nb_data_by_buffer            : STD_LOGIC_VECTOR(nb_burst_available_size-1 DOWNTO 0);
  SIGNAL nb_snapshot_param            : STD_LOGIC_VECTOR(nb_snapshot_param_size-1 DOWNTO 0);
  SIGNAL status_full                  : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL status_full_ack              : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL status_full_err              : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL status_new_err               : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL coarse_time                  : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL fine_time                    : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL addr_data_f0                 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_f0_in_valid             : STD_LOGIC;
  SIGNAL data_f0_in                   : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
  SIGNAL addr_data_f1                 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_f1_in_valid             : STD_LOGIC;
  SIGNAL data_f1_in                   : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
  SIGNAL addr_data_f2                 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_f2_in_valid             : STD_LOGIC;
  SIGNAL data_f2_in                   : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
  SIGNAL addr_data_f3                 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_f3_in_valid             : STD_LOGIC;
  SIGNAL data_f3_in                   : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
  SIGNAL data_f0_addr_out             : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_f0_data_out             : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_f0_data_out_valid       : STD_LOGIC;
  SIGNAL data_f0_data_out_valid_burst : STD_LOGIC;
  SIGNAL data_f0_data_out_ack         : STD_LOGIC;
  SIGNAL data_f1_addr_out             : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_f1_data_out             : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_f1_data_out_valid       : STD_LOGIC;
  SIGNAL data_f1_data_out_valid_burst : STD_LOGIC;
  SIGNAL data_f1_data_out_ack         : STD_LOGIC;
  SIGNAL data_f2_addr_out             : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_f2_data_out             : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_f2_data_out_valid       : STD_LOGIC;
  SIGNAL data_f2_data_out_valid_burst : STD_LOGIC;
  SIGNAL data_f2_data_out_ack         : STD_LOGIC;
  SIGNAL data_f3_addr_out             : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_f3_data_out             : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_f3_data_out_valid       : STD_LOGIC;
  SIGNAL data_f3_data_out_valid_burst : STD_LOGIC;
  SIGNAL data_f3_data_out_ack         : STD_LOGIC;

  --MEM CTRLR
  SIGNAL memi       : memory_in_type;
  SIGNAL memo       : memory_out_type;
  SIGNAL wpo        : wprot_out_type;
  SIGNAL sdo        : sdram_out_type;
  
  SIGNAL address   : STD_LOGIC_VECTOR(19 DOWNTO 0);
  SIGNAL data      : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL nSRAM_BE0 : STD_LOGIC;
  SIGNAL nSRAM_BE1 : STD_LOGIC;
  SIGNAL nSRAM_BE2 : STD_LOGIC;
  SIGNAL nSRAM_BE3 : STD_LOGIC;
  SIGNAL nSRAM_WE  : STD_LOGIC;
  SIGNAL nSRAM_CE  : STD_LOGIC;
  SIGNAL nSRAM_OE  : STD_LOGIC;

  CONSTANT padtech : INTEGER := inferred;
  SIGNAL not_ramsn_0 : STD_LOGIC;
  
  
BEGIN

  -----------------------------------------------------------------------------
  
  clk49_152MHz <= NOT clk49_152MHz AFTER 10173 ps;  -- 49.152/2 MHz
  clk25MHz     <= NOT clk25MHz     AFTER 5 ns;      -- 100 MHz

  -----------------------------------------------------------------------------

  MODULE_RHF1401 : FOR I IN 0 TO 7 GENERATE
    TestModule_RHF1401_1 : TestModule_RHF1401
      GENERIC MAP (
        freq      => 24*(I+1),
        amplitude => 8000/(I+1),
        impulsion => 0)
      PORT MAP (
        ADC_smpclk  => ADC_smpclk,
        ADC_OEB_bar => ADC_OEB_bar_CH(I),
        ADC_data    => ADC_data);
  END GENERATE MODULE_RHF1401;

  -----------------------------------------------------------------------------

  top_ad_conv_RHF1401_1 : top_ad_conv_RHF1401
    GENERIC MAP (
      ChanelCount     => 8,
      ncycle_cnv_high => 79,
      ncycle_cnv      => 500)
    PORT MAP (
      cnv_clk    => clk49_152MHz,
      cnv_rstn   => rstn,
      cnv        => ADC_smpclk,
      clk        => clk25MHz,
      rstn       => rstn,
      ADC_data   => ADC_data,
      ADC_nOE    => ADC_OEB_bar_CH,
      sample     => sample,
      sample_val => sample_val);

  -----------------------------------------------------------------------------

  lpp_lfr_1 : lpp_lfr
    GENERIC MAP (
      Mem_use                => use_CEL,  -- use_RAM
      nb_data_by_buffer_size => 32,
      nb_word_by_buffer_size => 30,
      nb_snapshot_param_size => 32,
      delta_vector_size      => 32,
      delta_vector_size_f0_2 => 32,
      pindex                 => INDEX_WAVEFORM_PICKER,
      paddr                  => ADDR_WAVEFORM_PICKER,
      pmask                  => 16#fff#,
      pirq_ms                => 6,
      pirq_wfp               => 14,
      hindex                 => 0,
      top_lfr_version        => X"00000001")
    PORT MAP (
      clk             => clk25MHz,
      rstn            => rstn,
      sample_B        => sample(2 DOWNTO 0),
      sample_E        => sample(7 DOWNTO 3),
      sample_val      => sample_val,
      apbi            => apbi,
      apbo            => apbo(15),
      ahbi            => ahbmi,
      ahbo            => ahbmo(0),
      coarse_time     => coarse_time,
      fine_time       => fine_time,
      data_shaping_BW => bias_fail_bw);

  -----------------------------------------------------------------------------
  ---  AHB CONTROLLER  -------------------------------------------------
  ahb0 : ahbctrl                        -- AHB arbiter/multiplexer
    GENERIC MAP (defmast => 0, split => 0,
                 rrobin  => 1, ioaddr => 16#FFF#,
                 ioen    => 0, nahbm => 1, nahbs => 1)
    PORT MAP (rstn, clk25MHz, ahbmi, ahbmo, ahbsi, ahbso);

  ---  AHB RAM ----------------------------------------------------------
  --ahbram0 : ahbram
  --  GENERIC MAP (hindex => 0, haddr => AHB_RAM_ADDR_0, tech => inferred, kbytes => 1, pipe => 0)
  --  PORT MAP (rstn, clk25MHz, ahbsi, ahbso(0));
  --ahbram1 : ahbram
  --  GENERIC MAP (hindex => 1, haddr => AHB_RAM_ADDR_1, tech => inferred, kbytes => 1, pipe => 0)
  --  PORT MAP (rstn, clk25MHz, ahbsi, ahbso(1));
  --ahbram2 : ahbram
  --  GENERIC MAP (hindex => 2, haddr => AHB_RAM_ADDR_2, tech => inferred, kbytes => 1, pipe => 0)
  --  PORT MAP (rstn, clk25MHz, ahbsi, ahbso(2));
  --ahbram3 : ahbram
  --  GENERIC MAP (hindex => 3, haddr => AHB_RAM_ADDR_3, tech => inferred, kbytes => 1, pipe => 0)
  --  PORT MAP (rstn, clk25MHz, ahbsi, ahbso(3));

  -----------------------------------------------------------------------------
----------------------------------------------------------------------
---  Memory controllers  ---------------------------------------------
----------------------------------------------------------------------
  memctrlr : mctrl GENERIC MAP (
    hindex  => 0,
    pindex  => 0,
    paddr   => 0,
    srbanks => 1
    )
    PORT MAP (rstn, clk25MHz, memi, memo, ahbsi, ahbso(0), apbi, apbo(0), wpo, sdo);

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

  addr_pad : outpadv GENERIC MAP (width => 20, tech => padtech)
    PORT MAP (address, memo.address(21 DOWNTO 2));

  not_ramsn_0 <= NOT(memo.ramsn(0));
  
  rams_pad : outpad GENERIC MAP (tech => padtech) PORT MAP (nSRAM_CE, not_ramsn_0);
  oen_pad  : outpad GENERIC MAP (tech => padtech) PORT MAP (nSRAM_OE, memo.ramoen(0));
  nBWE_pad : outpad GENERIC MAP (tech => padtech) PORT MAP (nSRAM_WE, memo.writen);
  nBWa_pad : outpad GENERIC MAP (tech => padtech) PORT MAP (nSRAM_BE0, memo.mben(3));
  nBWb_pad : outpad GENERIC MAP (tech => padtech) PORT MAP (nSRAM_BE1, memo.mben(2));
  nBWc_pad : outpad GENERIC MAP (tech => padtech) PORT MAP (nSRAM_BE2, memo.mben(1));
  nBWd_pad : outpad GENERIC MAP (tech => padtech) PORT MAP (nSRAM_BE3, memo.mben(0));
  
  async_1Mx16_0: CY7C1061DV33
    GENERIC MAP (
      ADDR_BITS         => 20,
      DATA_BITS         => 16,
      depth 	        => 1048576,
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

  WaveGen_Proc : PROCESS
  BEGIN

    -- insert signal assignments here
    WAIT UNTIL clk25MHz = '1';
    rstn          <= '0';
    apbi.psel(15) <= '0';
    apbi.pwrite   <= '0';
    apbi.penable  <= '0';
    apbi.paddr    <= (OTHERS => '0');
    apbi.pwdata   <= (OTHERS => '0');
    fine_time     <= (OTHERS => '0');
    coarse_time   <= (OTHERS => '0');
    WAIT UNTIL clk25MHz = '1';
--    ahbmi.HGRANT(2) <= '1';
--    ahbmi.HREADY    <= '1';
--    ahbmi.HRESP     <= HRESP_OKAY;

    WAIT UNTIL clk25MHz = '1';
    WAIT UNTIL clk25MHz = '1';
    rstn <= '1';
    WAIT UNTIL clk25MHz = '1';
    WAIT UNTIL clk25MHz = '1';
    ---------------------------------------------------------------------------
    -- CONFIGURATION STEP
    APB_WRITE(clk25MHz, INDEX_WAVEFORM_PICKER, apbi, ADDR_WAVEFORM_PICKER_ADDRESS_F0 , X"40000000");
    APB_WRITE(clk25MHz, INDEX_WAVEFORM_PICKER, apbi, ADDR_WAVEFORM_PICKER_ADDRESS_F1 , X"40020000");
    APB_WRITE(clk25MHz, INDEX_WAVEFORM_PICKER, apbi, ADDR_WAVEFORM_PICKER_ADDRESS_F2 , X"40040000");
    APB_WRITE(clk25MHz, INDEX_WAVEFORM_PICKER, apbi, ADDR_WAVEFORM_PICKER_ADDRESS_F3 , X"40060000");

    APB_WRITE(clk25MHz, INDEX_WAVEFORM_PICKER, apbi, ADDR_WAVEFORM_PICKER_DELTASNAPSHOT, X"00000020");--"00000020"
    APB_WRITE(clk25MHz, INDEX_WAVEFORM_PICKER, apbi, ADDR_WAVEFORM_PICKER_DELTA_F0     , X"00000019");--"00000019"
    APB_WRITE(clk25MHz, INDEX_WAVEFORM_PICKER, apbi, ADDR_WAVEFORM_PICKER_DELTA_F0_2   , X"00000007");--"00000007"
    APB_WRITE(clk25MHz, INDEX_WAVEFORM_PICKER, apbi, ADDR_WAVEFORM_PICKER_DELTA_F1     , X"00000019");--"00000019"
    APB_WRITE(clk25MHz, INDEX_WAVEFORM_PICKER, apbi, ADDR_WAVEFORM_PICKER_DELTA_F2     , X"00000001");--"00000001"

    APB_WRITE(clk25MHz, INDEX_WAVEFORM_PICKER, apbi, ADDR_WAVEFORM_PICKER_NB_DATA_IN_BUFFER , X"00000007"); -- X"00000010"
    -- 
    APB_WRITE(clk25MHz, INDEX_WAVEFORM_PICKER, apbi, ADDR_WAVEFORM_PICKER_NBSNAPSHOT , X"00000010");
    APB_WRITE(clk25MHz, INDEX_WAVEFORM_PICKER, apbi, ADDR_WAVEFORM_PICKER_START_DATE , X"00000001");
    APB_WRITE(clk25MHz, INDEX_WAVEFORM_PICKER, apbi, ADDR_WAVEFORM_PICKER_NB_WORD_IN_BUFFER , X"00000022");


    WAIT UNTIL clk25MHz = '1';
    WAIT UNTIL clk25MHz = '1';
    APB_WRITE(clk25MHz, INDEX_WAVEFORM_PICKER, apbi, ADDR_WAVEFORM_PICKER_CONTROL, X"00000087");
    WAIT UNTIL clk25MHz = '1';
    WAIT UNTIL clk25MHz = '1';
    WAIT UNTIL clk25MHz = '1';
    WAIT UNTIL clk25MHz = '1';
    WAIT UNTIL clk25MHz = '1';
    WAIT UNTIL clk25MHz = '1';
    WAIT FOR 1 us;
    coarse_time <= X"00000001";
    ---------------------------------------------------------------------------
    -- RUN STEP
    WAIT FOR 200 ms;
    APB_WRITE(clk25MHz, INDEX_WAVEFORM_PICKER, apbi, ADDR_WAVEFORM_PICKER_CONTROL, X"00000000");
    APB_WRITE(clk25MHz, INDEX_WAVEFORM_PICKER, apbi, ADDR_WAVEFORM_PICKER_START_DATE, X"00000010");
    WAIT FOR 10 us;
    WAIT UNTIL clk25MHz = '1';
    WAIT UNTIL clk25MHz = '1';
    APB_WRITE(clk25MHz, INDEX_WAVEFORM_PICKER, apbi, ADDR_WAVEFORM_PICKER_CONTROL, X"000000FF");
    WAIT UNTIL clk25MHz = '1';
    coarse_time <= X"00000010";
    WAIT FOR 100 ms;
    APB_WRITE(clk25MHz, INDEX_WAVEFORM_PICKER, apbi, ADDR_WAVEFORM_PICKER_CONTROL, X"00000000");
    WAIT FOR 10 us;
    APB_WRITE(clk25MHz, INDEX_WAVEFORM_PICKER, apbi, ADDR_WAVEFORM_PICKER_CONTROL, X"000000AF");
    WAIT FOR 200 ms;
    REPORT "*** END simulation ***" SEVERITY failure;


    WAIT;

  END PROCESS WaveGen_Proc;
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- IRQ
  -----------------------------------------------------------------------------
  PROCESS (clk25MHz, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)

    ELSIF clk25MHz'EVENT AND clk25MHz = '1' THEN  -- rising clock edge

    END IF;
  END PROCESS;
  -----------------------------------------------------------------------------

END;
