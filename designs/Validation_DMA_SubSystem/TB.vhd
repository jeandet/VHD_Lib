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
USE lpp.lpp_ad_conv.ALL;
USE lpp.iir_filter.ALL;
USE lpp.FILTERcfg.ALL;
USE lpp.lpp_memory.ALL;
USE lpp.lpp_waveform_pkg.ALL;
USE lpp.lpp_dma_pkg.ALL;
USE lpp.lpp_top_lfr_pkg.ALL;
USE lpp.lpp_lfr_pkg.ALL;
USE lpp.general_purpose.ALL;
USE lpp.lpp_lfr_pkg.ALL;
USE lpp.lpp_memory.ALL;
USE lpp.iir_filter.ALL;
USE lpp.spectral_matrix_package.ALL;
USE lpp.lpp_fft.ALL;
USE lpp.fft_components.ALL;
USE lpp.CY7C1061DV33_pkg.ALL;
USE lpp.testbench_package.ALL;


LIBRARY grlib;
USE grlib.amba.ALL;
USE grlib.stdlib.ALL;
USE grlib.devices.ALL;
USE GRLIB.DMA2AHB_Package.ALL;

LIBRARY gaisler;
USE gaisler.memctrl.ALL;
USE gaisler.misc.ALL;

LIBRARY techmap;
USE techmap.gencomp.ALL;

LIBRARY esa;
USE esa.memoryctrl.ALL;


ENTITY TB IS
END TB;


ARCHITECTURE beh OF TB IS

  COMPONENT lpp_lfr_apbreg_tb
    GENERIC (
      pindex : INTEGER;
      paddr  : INTEGER;
      pmask  : INTEGER);
    PORT (
      HCLK                 : IN  STD_ULOGIC;
      HRESETn              : IN  STD_ULOGIC;
      apbi                 : IN  apb_slv_in_type;
      apbo                 : OUT apb_slv_out_type;
      fifo_wen             : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
      fifo_wdata           : OUT STD_LOGIC_VECTOR(32*5-1 DOWNTO 0);
      fifo_full            : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
      fifo_full_almost     : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
      fifo_empty           : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
      fifo_empty_threshold : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
      buffer_new           : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
      buffer_length        : OUT STD_LOGIC_VECTOR(26*5-1 DOWNTO 0);
      buffer_addr          : OUT STD_LOGIC_VECTOR(32*5-1 DOWNTO 0);
      buffer_full          : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
      buffer_full_err      : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
      grant_error          : IN  STD_LOGIC);
  END COMPONENT;

  COMPONENT DMA_SubSystem
    GENERIC (
      hindex : INTEGER);
    PORT (
      clk              : IN  STD_LOGIC;
      rstn             : IN  STD_LOGIC;
      run              : IN  STD_LOGIC;
      ahbi             : IN  AHB_Mst_In_Type;
      ahbo             : OUT AHB_Mst_Out_Type;
      fifo_burst_valid : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
      fifo_data        : IN  STD_LOGIC_VECTOR(32*5-1 DOWNTO 0);
      fifo_ren         : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
      buffer_new       : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
      buffer_addr      : IN  STD_LOGIC_VECTOR(32*5-1 DOWNTO 0);
      buffer_length    : IN  STD_LOGIC_VECTOR(26*5-1 DOWNTO 0);
      buffer_full      : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
      buffer_full_err  : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
      grant_error      : OUT STD_LOGIC);
  END COMPONENT;
  
  CONSTANT INDEX_DMA_SUBSYSTEM                   : INTEGER                       := 15;
  CONSTANT ADDR_DMA_SUBSYSTEM                    : INTEGER                       := 15;

  
  -- REG DMA_SubSystem
  CONSTANT ADDR_DMA_SUBSYSTEM_F0_wDATA_rSTATUS   : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F00";
  CONSTANT ADDR_DMA_SUBSYSTEM_F0_ADDR            : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F04";
  CONSTANT ADDR_DMA_SUBSYSTEM_F0_LENGTH          : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F08";
  
  CONSTANT ADDR_DMA_SUBSYSTEM_F1_wDATA_rSTATUS   : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F10";
  CONSTANT ADDR_DMA_SUBSYSTEM_F1_ADDR            : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F14";
  CONSTANT ADDR_DMA_SUBSYSTEM_F1_LENGTH          : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F18";
  
  CONSTANT ADDR_DMA_SUBSYSTEM_F2_wDATA_rSTATUS   : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F20";
  CONSTANT ADDR_DMA_SUBSYSTEM_F2_ADDR            : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F24";
  CONSTANT ADDR_DMA_SUBSYSTEM_F2_LENGTH          : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F28";
  
  CONSTANT ADDR_DMA_SUBSYSTEM_F3_wDATA_rSTATUS   : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F30";
  CONSTANT ADDR_DMA_SUBSYSTEM_F3_ADDR            : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F34";
  CONSTANT ADDR_DMA_SUBSYSTEM_F3_LENGTH          : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F38";
  
  CONSTANT ADDR_DMA_SUBSYSTEM_F4_wDATA_rSTATUS   : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F40";
  CONSTANT ADDR_DMA_SUBSYSTEM_F4_ADDR            : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F44";
  CONSTANT ADDR_DMA_SUBSYSTEM_F4_LENGTH          : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000F48";
  -- RAM ADDRESS
  CONSTANT AHB_RAM_ADDR_0                         : INTEGER                       := 16#000#;
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
  SIGNAL sample_s   : Samples(7 DOWNTO 0);
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
  SIGNAL memi : memory_in_type;
  SIGNAL memo : memory_out_type;
  SIGNAL wpo  : wprot_out_type;
  SIGNAL sdo  : sdram_out_type;

  SIGNAL address   : STD_LOGIC_VECTOR(19 DOWNTO 0) := "00000000000000000000";
  SIGNAL data      : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL nSRAM_BE0 : STD_LOGIC;
  SIGNAL nSRAM_BE1 : STD_LOGIC;
  SIGNAL nSRAM_BE2 : STD_LOGIC;
  SIGNAL nSRAM_BE3 : STD_LOGIC;
  SIGNAL nSRAM_WE  : STD_LOGIC;
  SIGNAL nSRAM_CE  : STD_LOGIC;
  SIGNAL nSRAM_OE  : STD_LOGIC;

  CONSTANT padtech     : INTEGER := inferred;
  SIGNAL   not_ramsn_0 : STD_LOGIC;

  -----------------------------------------------------------------------------
  SIGNAL   status                     : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL   read_buffer                : STD_LOGIC;
  -----------------------------------------------------------------------------
  SIGNAL   run_test_waveform_picker   : STD_LOGIC := '1';
  SIGNAL   state_read_buffer_on_going : STD_LOGIC;
  CONSTANT hindex                     : INTEGER   := 1;
  SIGNAL   time_mem_f0                : STD_LOGIC_VECTOR(63 DOWNTO 0);
  SIGNAL   time_mem_f1                : STD_LOGIC_VECTOR(63 DOWNTO 0);
  SIGNAL   time_mem_f2                : STD_LOGIC_VECTOR(63 DOWNTO 0);
  SIGNAL   time_mem_f3                : STD_LOGIC_VECTOR(63 DOWNTO 0);

  SIGNAL data_mem_f0 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_mem_f1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_mem_f2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_mem_f3 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  -----------------------------------------------------------------------------


  
  -----------------------------------------------------------------------------
  SIGNAL run : STD_LOGIC;
  
  SIGNAL fifo_wen   :  STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL fifo_wdata :  STD_LOGIC_VECTOR(32*5-1 DOWNTO 0);
  SIGNAL fifo_ren   :  STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL fifo_rdata :  STD_LOGIC_VECTOR(32*5-1 DOWNTO 0);

  SIGNAL fifo_full            :  STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL fifo_full_almost     :  STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL fifo_empty           :  STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL fifo_empty_threshold :  STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL fifo_burst_valid          :  STD_LOGIC_VECTOR(4 DOWNTO 0);

  SIGNAL  buffer_new      :  STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL  buffer_length   :  STD_LOGIC_VECTOR(26*5-1 DOWNTO 0);
  SIGNAL  buffer_addr     :  STD_LOGIC_VECTOR(32*5-1 DOWNTO 0);
  SIGNAL  buffer_full     :  STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL  buffer_full_err :  STD_LOGIC_VECTOR(4 DOWNTO 0);

  SIGNAL  grant_error :STD_LOGIC;
  
BEGIN

  -----------------------------------------------------------------------------
  
  clk49_152MHz <= NOT clk49_152MHz AFTER 10173 ps;  -- 49.152/2 MHz
  clk25MHz     <= NOT clk25MHz     AFTER 5 ns;      -- 100 MHz



  -----------------------------------------------------------------------------
  -- DMA SUBSYSTEM
  -----------------------------------------------------------------------------
  lpp_lfr_apbreg_tb_1: lpp_lfr_apbreg_tb
    GENERIC MAP (
      pindex => INDEX_DMA_SUBSYSTEM,
      paddr  => ADDR_DMA_SUBSYSTEM,
      pmask  => 16#fff#)
    PORT MAP (
      HCLK                 => clk25MHz,
      HRESETn              => rstn,
      apbi                 => apbi,
      apbo                 => apbo(INDEX_DMA_SUBSYSTEM),
      
      fifo_wen             => fifo_wen,
      fifo_wdata           => fifo_wdata,
      fifo_full            => fifo_full,
      fifo_full_almost     => fifo_full_almost,
      fifo_empty           => fifo_empty,
      fifo_empty_threshold => fifo_empty_threshold,
      
      buffer_new           => buffer_new,
      buffer_length        => buffer_length,
      buffer_addr          => buffer_addr,
      buffer_full          => buffer_full,
      buffer_full_err      => buffer_full_err,
      
      grant_error          => grant_error);
  
  all_fifo: FOR I IN 4 DOWNTO 0 GENERATE
    lpp_fifo_I: lpp_fifo
      GENERIC MAP (
        tech                  => inferred,
        Mem_use               => use_RAM,
        EMPTY_THRESHOLD_LIMIT => 15,
        FULL_THRESHOLD_LIMIT  => 1,
        DataSz                => 32,
        AddrSz                => 7)
      PORT MAP (
        clk             => clk25MHz,
        rstn            => rstn,
        reUse           => '0',
        run             => run,

        ren             => fifo_ren(I),                 
        rdata           => fifo_rdata(32*(I+1)-1 DOWNTO 32*i),
        
        wen             => fifo_wen(I),                           
        wdata           => fifo_wdata(32*(I+1)-1 DOWNTO 32*i),                         
        
        empty           => fifo_empty(I),                
        full            => fifo_full(I),                         
        full_almost     => fifo_full_almost(I),                   
        empty_threshold => fifo_empty_threshold(I),      
                                                        
        full_threshold  => OPEN);
    
    fifo_burst_valid(I) <= NOT fifo_empty_threshold(I);
    
  END GENERATE all_fifo;

  
  
  DMA_SubSystem_1: DMA_SubSystem
    GENERIC MAP (
      hindex => 0)
    PORT MAP (
      clk              => clk25MHz,
      rstn             => rstn,
      run              => run,
      ahbi             => ahbmi,
      ahbo             => ahbmo(0),
      
      fifo_burst_valid => fifo_burst_valid,
      fifo_data        => fifo_rdata,
      fifo_ren         => fifo_ren,
      buffer_new       => buffer_new,
      buffer_addr      => buffer_addr,
      buffer_length    => buffer_length,
      buffer_full      => buffer_full,
      buffer_full_err  => buffer_full_err,
      grant_error      => grant_error);
  

  -----------------------------------------------------------------------------
  ---  AHB CONTROLLER  -------------------------------------------------
  ahb0 : ahbctrl                        -- AHB arbiter/multiplexer
    GENERIC MAP (defmast => 0, split => 0,
                 rrobin  => 1, ioaddr => 16#FFF#,
                 ioen    => 0, nahbm => 2, nahbs => 1)
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

  async_1Mx16_0 : CY7C1061DV33
    GENERIC MAP (
      ADDR_BITS       => 20,
      DATA_BITS       => 16,
      depth           => 1048576,
      MEM_ARRAY_DEBUG => 32,
      TimingInfo      => true,
      TimingChecks    => '1')
    PORT MAP (
      CE1_b => '0',
      CE2   => nSRAM_CE,
      WE_b  => nSRAM_WE,
      OE_b  => nSRAM_OE,
      BHE_b => nSRAM_BE1,
      BLE_b => nSRAM_BE0,
      A     => address,
      DQ    => data(15 DOWNTO 0));

  async_1Mx16_1 : CY7C1061DV33
    GENERIC MAP (
      ADDR_BITS       => 20,
      DATA_BITS       => 16,
      depth           => 1048576,
      MEM_ARRAY_DEBUG => 32,
      TimingInfo      => true,
      TimingChecks    => '1')
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
    run <= '0';
    rstn          <= '0';
    apbi.psel(15) <= '0';
    apbi.pwrite   <= '0';
    apbi.penable  <= '0';
    apbi.paddr    <= (OTHERS => '0');
    apbi.pwdata   <= (OTHERS => '0');
    fine_time     <= (OTHERS => '0');
    coarse_time   <= (OTHERS => '0');
    WAIT UNTIL clk25MHz = '1';

    WAIT UNTIL clk25MHz = '1';
    WAIT UNTIL clk25MHz = '1';
    rstn <= '1';
    WAIT UNTIL clk25MHz = '1';
    WAIT UNTIL clk25MHz = '1';
    WAIT UNTIL clk25MHz = '1';
    WAIT UNTIL clk25MHz = '1';
    run <= '1';
    WAIT UNTIL clk25MHz = '1';
    WAIT UNTIL clk25MHz = '1';
    WAIT UNTIL clk25MHz = '1';
    WAIT UNTIL clk25MHz = '1';
    
    WAIT UNTIL clk25MHz = '1';
    
    APB_WRITE(clk25MHz, INDEX_DMA_SUBSYSTEM, apbi, ADDR_DMA_SUBSYSTEM_F0_ADDR   , X"40000000");
    APB_WRITE(clk25MHz, INDEX_DMA_SUBSYSTEM, apbi, ADDR_DMA_SUBSYSTEM_F0_LENGTH , X"00000002");

    APB_WRITE(clk25MHz, INDEX_DMA_SUBSYSTEM, apbi, ADDR_DMA_SUBSYSTEM_F0_wDATA_rSTATUS , X"00000001");    --1
    APB_WRITE(clk25MHz, INDEX_DMA_SUBSYSTEM, apbi, ADDR_DMA_SUBSYSTEM_F0_wDATA_rSTATUS , X"00000002");
    APB_WRITE(clk25MHz, INDEX_DMA_SUBSYSTEM, apbi, ADDR_DMA_SUBSYSTEM_F0_wDATA_rSTATUS , X"00000003");
    APB_WRITE(clk25MHz, INDEX_DMA_SUBSYSTEM, apbi, ADDR_DMA_SUBSYSTEM_F0_wDATA_rSTATUS , X"00000004");
    APB_WRITE(clk25MHz, INDEX_DMA_SUBSYSTEM, apbi, ADDR_DMA_SUBSYSTEM_F0_wDATA_rSTATUS , X"00000005");
    APB_WRITE(clk25MHz, INDEX_DMA_SUBSYSTEM, apbi, ADDR_DMA_SUBSYSTEM_F0_wDATA_rSTATUS , X"00000006");
    APB_WRITE(clk25MHz, INDEX_DMA_SUBSYSTEM, apbi, ADDR_DMA_SUBSYSTEM_F0_wDATA_rSTATUS , X"00000007");
    APB_WRITE(clk25MHz, INDEX_DMA_SUBSYSTEM, apbi, ADDR_DMA_SUBSYSTEM_F0_wDATA_rSTATUS , X"00000008");
    APB_WRITE(clk25MHz, INDEX_DMA_SUBSYSTEM, apbi, ADDR_DMA_SUBSYSTEM_F0_wDATA_rSTATUS , X"00000009");
    APB_WRITE(clk25MHz, INDEX_DMA_SUBSYSTEM, apbi, ADDR_DMA_SUBSYSTEM_F0_wDATA_rSTATUS , X"0000000A");
    APB_WRITE(clk25MHz, INDEX_DMA_SUBSYSTEM, apbi, ADDR_DMA_SUBSYSTEM_F0_wDATA_rSTATUS , X"0000000B");
    APB_WRITE(clk25MHz, INDEX_DMA_SUBSYSTEM, apbi, ADDR_DMA_SUBSYSTEM_F0_wDATA_rSTATUS , X"0000000C");
    APB_WRITE(clk25MHz, INDEX_DMA_SUBSYSTEM, apbi, ADDR_DMA_SUBSYSTEM_F0_wDATA_rSTATUS , X"0000000D");
    APB_WRITE(clk25MHz, INDEX_DMA_SUBSYSTEM, apbi, ADDR_DMA_SUBSYSTEM_F0_wDATA_rSTATUS , X"0000000E");
    APB_WRITE(clk25MHz, INDEX_DMA_SUBSYSTEM, apbi, ADDR_DMA_SUBSYSTEM_F0_wDATA_rSTATUS , X"0000000F");
    APB_WRITE(clk25MHz, INDEX_DMA_SUBSYSTEM, apbi, ADDR_DMA_SUBSYSTEM_F0_wDATA_rSTATUS , X"00000010");    --16
    APB_WRITE(clk25MHz, INDEX_DMA_SUBSYSTEM, apbi, ADDR_DMA_SUBSYSTEM_F0_wDATA_rSTATUS , X"00000011");
    APB_WRITE(clk25MHz, INDEX_DMA_SUBSYSTEM, apbi, ADDR_DMA_SUBSYSTEM_F0_wDATA_rSTATUS , X"00000012");
    APB_WRITE(clk25MHz, INDEX_DMA_SUBSYSTEM, apbi, ADDR_DMA_SUBSYSTEM_F0_wDATA_rSTATUS , X"00000013");
    APB_WRITE(clk25MHz, INDEX_DMA_SUBSYSTEM, apbi, ADDR_DMA_SUBSYSTEM_F0_wDATA_rSTATUS , X"00000014");
    APB_WRITE(clk25MHz, INDEX_DMA_SUBSYSTEM, apbi, ADDR_DMA_SUBSYSTEM_F0_wDATA_rSTATUS , X"00000015");
    APB_WRITE(clk25MHz, INDEX_DMA_SUBSYSTEM, apbi, ADDR_DMA_SUBSYSTEM_F0_wDATA_rSTATUS , X"00000016");
    APB_WRITE(clk25MHz, INDEX_DMA_SUBSYSTEM, apbi, ADDR_DMA_SUBSYSTEM_F0_wDATA_rSTATUS , X"00000017");
    APB_WRITE(clk25MHz, INDEX_DMA_SUBSYSTEM, apbi, ADDR_DMA_SUBSYSTEM_F0_wDATA_rSTATUS , X"00000018");
    APB_WRITE(clk25MHz, INDEX_DMA_SUBSYSTEM, apbi, ADDR_DMA_SUBSYSTEM_F0_wDATA_rSTATUS , X"00000019");
    APB_WRITE(clk25MHz, INDEX_DMA_SUBSYSTEM, apbi, ADDR_DMA_SUBSYSTEM_F0_wDATA_rSTATUS , X"0000001A");
    APB_WRITE(clk25MHz, INDEX_DMA_SUBSYSTEM, apbi, ADDR_DMA_SUBSYSTEM_F0_wDATA_rSTATUS , X"0000001B");
    APB_WRITE(clk25MHz, INDEX_DMA_SUBSYSTEM, apbi, ADDR_DMA_SUBSYSTEM_F0_wDATA_rSTATUS , X"0000001C");
    APB_WRITE(clk25MHz, INDEX_DMA_SUBSYSTEM, apbi, ADDR_DMA_SUBSYSTEM_F0_wDATA_rSTATUS , X"0000001D");
    APB_WRITE(clk25MHz, INDEX_DMA_SUBSYSTEM, apbi, ADDR_DMA_SUBSYSTEM_F0_wDATA_rSTATUS , X"0000001E");
    APB_WRITE(clk25MHz, INDEX_DMA_SUBSYSTEM, apbi, ADDR_DMA_SUBSYSTEM_F0_wDATA_rSTATUS , X"0000001F");
    APB_WRITE(clk25MHz, INDEX_DMA_SUBSYSTEM, apbi, ADDR_DMA_SUBSYSTEM_F0_wDATA_rSTATUS , X"00000020");    --32
    

    WAIT FOR 1 ms;
    REPORT "*** END simulation ***" SEVERITY failure;


    WAIT;

  END PROCESS WaveGen_Proc;
  -----------------------------------------------------------------------------

END beh;

