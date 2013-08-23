-----------------------------------------------------------------------------
--  LEON3 Demonstration design
--  Copyright (C) 2004 Jiri Gaisler, Gaisler Research
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
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
------------------------------------------------------------------------------


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
LIBRARY grlib;
USE grlib.amba.ALL;
USE grlib.stdlib.ALL;
LIBRARY techmap;
USE techmap.gencomp.ALL;
LIBRARY gaisler;
USE gaisler.memctrl.ALL;
USE gaisler.leon3.ALL;
USE gaisler.uart.ALL;
USE gaisler.misc.ALL;
USE gaisler.spacewire.ALL;              -- PLE


LIBRARY esa;
USE esa.memoryctrl.ALL;
--USE work.config.ALL;
LIBRARY lpp;
USE lpp.lpp_memory.ALL;
USE lpp.lpp_ad_conv.ALL;
USE lpp.lpp_top_lfr_pkg.ALL;
USE lpp.iir_filter.ALL;
USE lpp.general_purpose.ALL;
use lpp.lpp_demux.all;
use lpp.lpp_dma_pkg.all;
use lpp.lpp_Header.all;
use lpp.lpp_fft.all;
use lpp.lpp_matrix.all;


ENTITY TestBench IS
END;

ARCHITECTURE Behavioral OF TestBench IS
  
  
  component TestModule_ADS7886 IS
    GENERIC (
      freq      : INTEGER ;
      amplitude : INTEGER ;
      impulsion : INTEGER 
      );
    PORT (
      -- CONV --
      cnv_run : IN STD_LOGIC;
      cnv : IN STD_LOGIC;
  
      -- DATA --
      sck : IN  STD_LOGIC;
      sdo : OUT STD_LOGIC
      );    
  END component;
  
  SIGNAL clk49_152MHz  : STD_LOGIC := '0';
  SIGNAL clkm          : STD_LOGIC := '0';
  SIGNAL rstn          : STD_LOGIC := '0';
  SIGNAL coarse_time_0 : STD_LOGIC := '0';

--  -- ADC interface
--  SIGNAL bias_fail_sw   : STD_LOGIC;                      -- OUT
--  SIGNAL ADC_OEB_bar_CH : STD_LOGIC_VECTOR(7 DOWNTO 0);   -- OUT
--  SIGNAL ADC_smpclk     : STD_LOGIC;                      -- OUT
--  SIGNAL ADC_data       : STD_LOGIC_VECTOR(13 DOWNTO 0);  -- IN

  --
  SIGNAL apbi  : apb_slv_in_type;
  SIGNAL apbo  : apb_slv_out_vector := (OTHERS => apb_none);
  SIGNAL ahbmi : ahb_mst_in_type;
  SIGNAL ahbmo : ahb_mst_out_vector := (OTHERS => ahbm_none);

--  -- internal
--  SIGNAL sample     : Samples14v(7 DOWNTO 0);
--  SIGNAL sample_val : STD_LOGIC;

-- ACQ
signal CNV_CH1     : STD_LOGIC;
signal SCK_CH1     :  STD_LOGIC;
signal SDO_CH1     :  STD_LOGIC_VECTOR(7 DOWNTO 0);
signal Bias_Fails  :  std_logic;
signal sample_val : STD_LOGIC;
signal sample : Samples(8-1 DOWNTO 0);

signal ACQ_WenF0 : STD_LOGIC_VECTOR(4 DOWNTO 0);
signal ACQ_DataF0 : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
signal ACQ_WenF1 : STD_LOGIC_VECTOR(4 DOWNTO 0);
signal ACQ_DataF1 : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
signal ACQ_WenF3 : STD_LOGIC_VECTOR(4 DOWNTO 0);
signal ACQ_DataF3 : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
 -- FIFOs
signal FifoF0_Empty     : std_logic_vector(4 downto 0);
signal FifoF0_Data      : std_logic_vector(79 downto 0);
signal FifoF1_Empty     : std_logic_vector(4 downto 0);
signal FifoF1_Data      : std_logic_vector(79 downto 0);
signal FifoF3_Empty     : std_logic_vector(4 downto 0);
signal FifoF3_Data      : std_logic_vector(79 downto 0);
signal FifoINT_Full     : std_logic_vector(4 downto 0);
signal FifoINT_Data     : std_logic_vector(79 downto 0);
signal FifoOUT_Full     : std_logic_vector(1 downto 0);
signal FifoOUT_Empty    : std_logic_vector(1 downto 0);
signal FifoOUT_Data     : std_logic_vector(63 downto 0);
-- MATRICE SPECTRALE
signal SM_FlagError     : std_logic;
signal SM_Pong          : std_logic;
signal SM_Wen           : std_logic;
signal SM_Read          : std_logic_vector(4 downto 0);
signal SM_Write         : std_logic_vector(1 downto 0);
signal SM_ReUse         : std_logic_vector(4 downto 0);
signal SM_Param         : std_logic_vector(3 downto 0);
signal SM_Data          : std_logic_vector(63 downto 0);
-- FFT
signal FFT_Load         : std_logic;
signal FFT_Read         : std_logic_vector(4 downto 0);
signal FFT_Write        : std_logic_vector(4 downto 0);
signal FFT_ReUse        : std_logic_vector(4 downto 0);
signal FFT_Data         : std_logic_vector(79 downto 0);
-- DEMUX
signal DMUX_Read        : std_logic_vector(14 downto 0);
signal DMUX_Empty       : std_logic_vector(4 downto 0);
signal DMUX_Data        : std_logic_vector(79 downto 0);
signal DMUX_WorkFreq    : std_logic_vector(1 downto 0);
-- Header
signal Head_Read        : std_logic_vector(1 downto 0);
signal Head_Data        : std_logic_vector(31 downto 0);
signal Head_Empty       : std_logic;
signal Head_Header      : std_logic_vector(31 DOWNTO 0);
signal Head_Valid       : std_logic;
signal Head_Val         : std_logic;
--DMA
signal DMA_Read         : std_logic;
signal DMA_ack          : std_logic;
signal AHB_Master_In    : AHB_Mst_In_Type;
signal AHB_Master_Out   : AHB_Mst_Out_Type;


BEGIN

  -----------------------------------------------------------------------------
  
--  MODULE_RHF1401: FOR I IN 0 TO 7 GENERATE
--    TestModule_RHF1401_1: TestModule_RHF1401
--      GENERIC MAP (
--        freq      => 24*(I+1),
--        amplitude => 8000/(I+1),
--        impulsion => 0)
--      PORT MAP (
--        ADC_smpclk  => ADC_smpclk,
--        ADC_OEB_bar => ADC_OEB_bar_CH(I),
--        ADC_data    => ADC_data);
--  END GENERATE MODULE_RHF1401;

MODULE_ADS7886: FOR I IN 0 TO 7 GENERATE
TestModule_ADS7886_0 : TestModule_ADS7886
  GENERIC MAP (
    freq      => 24*(I+1),
    amplitude => 8000/(I+1),
    impulsion => 0)
  PORT MAP(
    -- CONV --
    cnv_run => '1',
    cnv => CNV_CH1,
    -- DATA --
    sck => SCK_CH1,
    sdo => SDO_CH1(I));
  END GENERATE MODULE_ADS7886;

   
  -----------------------------------------------------------------------------
  
  clk49_152MHz  <= NOT clk49_152MHz  AFTER 10173 ps;  -- 49.152/2 MHz
  clkm          <= NOT clkm          AFTER 20 ns;     -- 25 MHz
  coarse_time_0 <= NOT coarse_time_0 AFTER 100 ms;

  -----------------------------------------------------------------------------
  -- waveform generation
  WaveGen_Proc : PROCESS
  BEGIN   
  WAIT UNTIL clkm = '1';
    apbi                     <= apb_slv_in_none;
    rstn                     <= '0';
--    cnv_rstn                 <= '0';
--    run_cnv                  <= '0';
    WAIT UNTIL clkm = '1';
    WAIT UNTIL clkm = '1';
    WAIT UNTIL clkm = '1';
    rstn                     <= '1';
--    cnv_rstn                 <= '1';
    WAIT UNTIL clkm = '1';
    WAIT UNTIL clkm = '1';
    WAIT UNTIL clkm = '1';

    WAIT;

  END PROCESS WaveGen_Proc;


  ahbmi.HGRANT(2)       <= '1';
  ahbmi.HREADY          <= '1';
  ahbmi.HRESP           <= HRESP_OKAY;
  


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- DUT ------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
 ACQ0 : lpp_top_acq
        port map('1',CNV_CH1,SCK_CH1,SDO_CH1,clk49_152MHz,rstn,clkm,rstn,ACQ_WenF0,ACQ_DataF0,ACQ_WenF1,ACQ_DataF1,open,open,ACQ_WenF3,ACQ_DataF3);
          
          Bias_Fails <= '0';
--- FIFO IN -------------------------------------------------------------

    Memf0 : lppFIFOxN
        generic map(Data_sz => 16, Addr_sz => 9, FifoCnt => 5, Enable_ReUse => '0')
        port map(rstn,clkm,clkm,(others => '0'),ACQ_WenF0,DMUX_Read(4 downto 0),ACQ_DataF0,FifoF0_Data,open,FifoF0_Empty);

    Memf1 : lppFIFOxN
        generic map(Data_sz => 16, Addr_sz => 8, FifoCnt => 5, Enable_ReUse => '0')
        port map(rstn,clkm,clkm,(others => '0'),ACQ_WenF1,DMUX_Read(9 downto 5),ACQ_DataF1,FifoF1_Data,open,FifoF1_Empty);

    Memf3 : lppFIFOxN
        generic map(Data_sz => 16, Addr_sz => 8, FifoCnt => 5, Enable_ReUse => '0')
        port map(rstn,clkm,clkm,(others => '0'),ACQ_WenF3,DMUX_Read(14 downto 10),ACQ_DataF3,FifoF3_Data,open,FifoF3_Empty);

--- DEMUX -------------------------------------------------------------

    DMUX0 : DEMUX
        generic map(Data_sz => 16)
        port map(clkm,rstn,FFT_Read,FFT_Load,FifoF0_Empty,FifoF1_Empty,FifoF3_Empty,FifoF0_Data,FifoF1_Data,FifoF3_Data,DMUX_WorkFreq,DMUX_Read,DMUX_Empty,DMUX_Data);

--- FFT -------------------------------------------------------------

    FFT0 : FFT
        generic map(Data_sz => 16,NbData => 256)
        port map(clkm,rstn,DMUX_Empty,DMUX_Data,FifoINT_Full,FFT_Load,FFT_Read,FFT_Write,FFT_ReUse,FFT_Data);

----- LINK MEMORY -------------------------------------------------------

    MemInt : lppFIFOxN
        generic map(Data_sz => 16, Addr_sz => 8, FifoCnt => 5, Enable_ReUse => '1')
        port map(rstn,clkm,clkm,SM_ReUse,FFT_Write,SM_Read,FFT_Data,FifoINT_Data,FifoINT_Full,open);

----- MATRICE SPECTRALE ---------------------5 FIFO Input---------------

    SM0 : MatriceSpectrale
        generic map(Input_SZ => 16,Result_SZ => 32)
        port map(clkm,rstn,FifoINT_Full,FFT_ReUse,Head_Valid,FifoINT_Data,DMA_ack,SM_Wen,SM_FlagError,SM_Pong,SM_Param,SM_Write,SM_Read,SM_ReUse,SM_Data);

    MemOut : lppFIFOxN
        generic map(Data_sz => 32, Addr_sz => 8, FifoCnt => 2, Enable_ReUse => '0')
        port map(rstn,clkm,clkm,(others => '0'),SM_Write,Head_Read,SM_Data,FifoOUT_Data,FifoOUT_Full,FifoOUT_Empty);

----- Header -------------------------------------------------------

    Head0 : HeaderBuilder
        generic map(Data_sz => 32)
        port map(clkm,rstn,SM_Pong,SM_Param,DMUX_WorkFreq,SM_Wen,Head_Valid,FifoOUT_Data,FifoOUT_Empty,Head_Read,Head_Data,Head_Empty,DMA_Read,Head_Header,Head_Val,DMA_ack);

----- DMA -------------------------------------------------------

    DMA0 : lpp_dma
        generic map(
    tech   =>inferred,
    hindex => 2,
    pindex => 9,
    paddr => 9,
    pmask  => 16#fff#,
    pirq  => 0)
        port map(clkm,rstn,apbi,apbo(9),AHB_Master_In,AHB_Master_Out,Head_Data,Head_Empty,DMA_Read,Head_Header,Head_Val,DMA_ack);

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

END Behavioral;