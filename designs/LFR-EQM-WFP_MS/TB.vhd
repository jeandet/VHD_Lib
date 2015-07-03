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

LIBRARY techmap;
USE techmap.gencomp.ALL;

LIBRARY lpp;
USE lpp.lpp_sim_pkg.ALL;
USE lpp.lpp_lfr_sim_pkg.ALL;
USE lpp.lpp_lfr_apbreg_pkg.ALL;
USE lpp.lpp_lfr_management_apbreg_pkg.ALL;
USE lpp.iir_filter.ALL;
USE lpp.FILTERcfg.ALL;
USE lpp.lpp_memory.ALL;
USE lpp.lpp_waveform_pkg.ALL;
USE lpp.lpp_dma_pkg.ALL;
USE lpp.lpp_top_lfr_pkg.ALL;
USE lpp.lpp_lfr_pkg.ALL;
USE lpp.general_purpose.ALL;
--LIBRARY lpp;
USE lpp.lpp_ad_conv.ALL;
--USE lpp.lpp_lfr_management_apbreg_pkg.ALL;
--USE lpp.lpp_lfr_apbreg_pkg.ALL;

--USE work.debug.ALL;

LIBRARY gaisler;
USE gaisler.libdcom.ALL;
USE gaisler.sim.ALL;
USE gaisler.memctrl.ALL;
USE gaisler.leon3.ALL;
USE gaisler.uart.ALL;
USE gaisler.misc.ALL;
USE gaisler.spacewire.ALL;

ENTITY TB IS

END TB;

ARCHITECTURE beh OF TB IS
  CONSTANT sramfile  : STRING  := "prom.srec";
--  CONSTANT sramfile  : STRING;

  CONSTANT USE_ESA_MEMCTRL : INTEGER := 0;
  
  COMPONENT LFR_EQM
    GENERIC (
      Mem_use        : INTEGER;
      USE_BOOTLOADER : INTEGER;
      USE_ADCDRIVER  : INTEGER;
      tech           : INTEGER;
      tech_leon      : INTEGER;
      DEBUG_FORCE_DATA_DMA   : INTEGER;
      USE_DEBUG_VECTOR       : INTEGER );
    PORT (
      clk50MHz       : IN    STD_ULOGIC;
      clk49_152MHz   : IN    STD_ULOGIC;
      reset          : IN    STD_ULOGIC;
      --TAG1           : IN    STD_ULOGIC;
      --TAG3           : OUT   STD_ULOGIC;
      --TAG2           : IN    STD_ULOGIC;
      --TAG4           : OUT   STD_ULOGIC;
      TAG          : INOUT STD_LOGIC_VECTOR(9 DOWNTO 1);
      address        : OUT   STD_LOGIC_VECTOR(18 DOWNTO 0);
      data           : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      nSRAM_MBE      : INOUT STD_LOGIC;
      nSRAM_E1       : OUT   STD_LOGIC;
      nSRAM_E2       : OUT   STD_LOGIC;
      nSRAM_W        : OUT   STD_LOGIC;
      nSRAM_G        : OUT   STD_LOGIC;
      nSRAM_BUSY     : IN    STD_LOGIC;
      spw1_en        : OUT   STD_LOGIC;
      spw1_din       : IN    STD_LOGIC;
      spw1_sin       : IN    STD_LOGIC;
      spw1_dout      : OUT   STD_LOGIC;
      spw1_sout      : OUT   STD_LOGIC;
      spw2_en        : OUT   STD_LOGIC;
      spw2_din       : IN    STD_LOGIC;
      spw2_sin       : IN    STD_LOGIC;
      spw2_dout      : OUT   STD_LOGIC;
      spw2_sout      : OUT   STD_LOGIC;
      bias_fail_sw   : OUT   STD_LOGIC;
      ADC_OEB_bar_CH : OUT   STD_LOGIC_VECTOR(7 DOWNTO 0);
      ADC_smpclk     : OUT   STD_LOGIC;
      ADC_data       : IN    STD_LOGIC_VECTOR(13 DOWNTO 0);
      DAC_SDO        : OUT   STD_LOGIC;
      DAC_SCK        : OUT   STD_LOGIC;
      DAC_SYNC       : OUT   STD_LOGIC;
      DAC_CAL_EN     : OUT   STD_LOGIC;
      HK_smpclk      : OUT   STD_LOGIC;
      ADC_OEB_bar_HK : OUT   STD_LOGIC;
      HK_SEL         : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0));
  END COMPONENT;

  SIGNAL clk50MHz       : STD_ULOGIC := '0';
  SIGNAL clk49_152MHz   : STD_ULOGIC := '0';
  SIGNAL reset          : STD_ULOGIC;
  SIGNAL TAG            : STD_LOGIC_VECTOR(9 DOWNTO 1);
  --SIGNAL TAG3           : STD_ULOGIC;
  --SIGNAL TAG2           : STD_ULOGIC := '1';
  --SIGNAL TAG4           : STD_ULOGIC;
  SIGNAL address        : STD_LOGIC_VECTOR(18 DOWNTO 0);
  SIGNAL data           : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_ram       : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL nSRAM_MBE      : STD_LOGIC;
  SIGNAL nSRAM_E1       : STD_LOGIC;
  SIGNAL nSRAM_E2       : STD_LOGIC;
  SIGNAL nSRAM_W        : STD_LOGIC;
  SIGNAL nSRAM_G        : STD_LOGIC;
  SIGNAL nSRAM_BUSY     : STD_LOGIC;
  SIGNAL spw1_en        : STD_LOGIC;
  SIGNAL spw1_din       : STD_LOGIC  := '1';
  SIGNAL spw1_sin       : STD_LOGIC  := '1';
  SIGNAL spw1_dout      : STD_LOGIC;
  SIGNAL spw1_sout      : STD_LOGIC;
  SIGNAL spw2_en        : STD_LOGIC;
  SIGNAL spw2_din       : STD_LOGIC  := '1';
  SIGNAL spw2_sin       : STD_LOGIC  := '1';
  SIGNAL spw2_dout      : STD_LOGIC;
  SIGNAL spw2_sout      : STD_LOGIC;
  SIGNAL bias_fail_sw   : STD_LOGIC;
  SIGNAL ADC_OEB_bar_CH   : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL ADC_OEB_bar_CH_r : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL ADC_OEB_bar_CH_s : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL ADC_smpclk     : STD_LOGIC;
  SIGNAL ADC_data       : STD_LOGIC_VECTOR(13 DOWNTO 0);
  SIGNAL ADC_data_s     : STD_LOGIC_VECTOR(13 DOWNTO 0);
  SIGNAL DAC_SDO        : STD_LOGIC;
  SIGNAL DAC_SCK        : STD_LOGIC;
  SIGNAL DAC_SYNC       : STD_LOGIC;
  SIGNAL DAC_CAL_EN     : STD_LOGIC;
  SIGNAL HK_smpclk      : STD_LOGIC;
  SIGNAL ADC_OEB_bar_HK : STD_LOGIC;
  SIGNAL HK_SEL         : STD_LOGIC_VECTOR(1 DOWNTO 0);
--  SIGNAL TAG8           : STD_LOGIC;

  CONSTANT SCRUB_RATE_PERIOD    : INTEGER := 1800/20;
  CONSTANT SCRUB_PERIOD         : INTEGER :=  200/20;
  CONSTANT SCRUB_BUSY_TO_SCRUB  : INTEGER :=  700/20;
  CONSTANT SCRUB_SCRUB_TO_BUSY  : INTEGER :=   60/20;
  SIGNAL   counter_scrub_period : INTEGER;


  --CONSTANT AHBADDR_APB            : STD_LOGIC_VECTOR(11 DOWNTO 0) := X"800";
  --CONSTANT AHBADDR_LFR_MANAGEMENT : STD_LOGIC_VECTOR(23 DOWNTO 0) := AHBADDR_APB & X"006";
  --CONSTANT AHBADDR_LFR            : STD_LOGIC_VECTOR(23 DOWNTO 0) := AHBADDR_APB & X"00F";

  CONSTANT ADDR_BASE_DSU            : STD_LOGIC_VECTOR(31 DOWNTO 24) := X"90";
  CONSTANT ADDR_BASE_LFR            : STD_LOGIC_VECTOR(31 DOWNTO 8) := X"80000F";
  CONSTANT ADDR_BASE_LFR_2          : STD_LOGIC_VECTOR(31 DOWNTO 8) := X"80000E";
  CONSTANT ADDR_BASE_TIME_MANAGMENT : STD_LOGIC_VECTOR(31 DOWNTO 8) := X"800006";
  CONSTANT ADDR_BASE_GPIO           : STD_LOGIC_VECTOR(31 DOWNTO 8) := X"80000B";
  CONSTANT ADDR_BASE_ESA_MEMCTRL    : STD_LOGIC_VECTOR(31 DOWNTO 8) := X"800000";

  SIGNAL message_simu : STRING(1 TO 15)               := "---------------";
  SIGNAL data_message : STRING(1 TO 15)               := "---------------";
  SIGNAL data_read    : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
  SIGNAL TXD1         : STD_LOGIC;
  SIGNAL RXD1         : STD_LOGIC;

  -----------------------------------------------------------------------------
  CONSTANT ADDR_BUFFER_WFP_F0_0 : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"40100000";
  CONSTANT ADDR_BUFFER_WFP_F0_1 : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"40110000";
  CONSTANT ADDR_BUFFER_WFP_F1_0 : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"40120000";
  CONSTANT ADDR_BUFFER_WFP_F1_1 : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"40130000";
  CONSTANT ADDR_BUFFER_WFP_F2_0 : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"40140000";
  CONSTANT ADDR_BUFFER_WFP_F2_1 : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"40150000";
  CONSTANT ADDR_BUFFER_WFP_F3_0 : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"40160000";
  CONSTANT ADDR_BUFFER_WFP_F3_1 : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"40170000";
  CONSTANT ADDR_BUFFER_MS_F0_0  : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"40180000";
  CONSTANT ADDR_BUFFER_MS_F0_1  : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"40190000";
  CONSTANT ADDR_BUFFER_MS_F1_0  : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"401A0000";
  CONSTANT ADDR_BUFFER_MS_F1_1  : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"401B0000";
  CONSTANT ADDR_BUFFER_MS_F2_0  : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"401C0000";
  CONSTANT ADDR_BUFFER_MS_F2_1  : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"401D0000";


  TYPE sample_vector_16b IS ARRAY (NATURAL RANGE <> , NATURAL RANGE <>) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL sample : sample_vector_16b(2 DOWNTO 0, 5 DOWNTO 0);

  TYPE counter_vector IS ARRAY (NATURAL RANGE <>) OF INTEGER;
  SIGNAL sample_counter : counter_vector( 2 DOWNTO 0);
  
  SIGNAL data_pre_f0 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_pre_f1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_pre_f2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL error_wfp   : STD_LOGIC_VECTOR(2 DOWNTO 0);

  SIGNAL addr_pre_f0 : STD_LOGIC_VECTOR(13 DOWNTO 0);
  SIGNAL addr_pre_f1 : STD_LOGIC_VECTOR(13 DOWNTO 0);
  SIGNAL addr_pre_f2 : STD_LOGIC_VECTOR(13 DOWNTO 0);


  SIGNAL error_wfp_addr : STD_LOGIC_VECTOR(2 DOWNTO 0);
  -----------------------------------------------------------------------------
  CONSTANT srambanks : INTEGER := 2;
  CONSTANT sramwidth : INTEGER := 32;
  CONSTANT sramdepth : INTEGER := 19;
  SIGNAL   ramsn     : STD_LOGIC_VECTOR(srambanks-1 DOWNTO 0);
  -----------------------------------------------------------------------------
  
BEGIN  -- beh

  LFR_EQM_1 : LFR_EQM
    GENERIC MAP (
      Mem_use           => use_RAM,
      USE_BOOTLOADER    => 0,
      USE_ADCDRIVER     => 1,
      tech              => apa3e,
      tech_leon         => apa3e,
      DEBUG_FORCE_DATA_DMA   => 0,
      USE_DEBUG_VECTOR       => 0)
    PORT MAP (
      clk50MHz     => clk50MHz,  --IN    --ok
      clk49_152MHz => clk49_152MHz,  --in    --ok
      reset        => reset,  --IN    --ok

      TAG => TAG,
      --TAG1 => TAG1,                     --in
      --TAG3 => TAG3,                     --out
      --TAG2 => TAG2,  --IN    --ok
      --TAG4 => TAG4,  --out   --ok

      address    => address,            --out
      data       => data,               --inout
      nSRAM_MBE  => nSRAM_MBE,          --inout
      nSRAM_E1   => nSRAM_E1,           --out
      nSRAM_E2   => nSRAM_E2,           --out
      nSRAM_W    => nSRAM_W,            --out
      nSRAM_G    => nSRAM_G,            --out
      nSRAM_BUSY => nSRAM_BUSY,         --in

      spw1_en   => spw1_en,  --out   --ok
      spw1_din  => spw1_din,  --in    --ok
      spw1_sin  => spw1_sin,  --in    --ok
      spw1_dout => spw1_dout,  --out   --ok
      spw1_sout => spw1_sout,  --out   --ok

      spw2_en   => spw2_en,  --out   --ok
      spw2_din  => spw2_din,  --in    --ok
      spw2_sin  => spw2_sin,  --in    --ok
      spw2_dout => spw2_dout,  --out   --ok
      spw2_sout => spw2_sout,  --out   --ok

      bias_fail_sw => bias_fail_sw,  --OUT   --ok

      ADC_OEB_bar_CH => ADC_OEB_bar_CH,  --out   --ok
      ADC_smpclk     => ADC_smpclk,  --out   --ok
      ADC_data       => ADC_data,  --IN    --ok

      DAC_SDO    => DAC_SDO,  --out   --ok
      DAC_SCK    => DAC_SCK,  --out   --ok   
      DAC_SYNC   => DAC_SYNC,  --out   --ok
      DAC_CAL_EN => DAC_CAL_EN,  --out   --ok

      HK_smpclk      => HK_smpclk,  --out   --ok
      ADC_OEB_bar_HK => ADC_OEB_bar_HK,  --out   --ok
      HK_SEL         => HK_SEL);          --out   --ok


  -----------------------------------------------------------------------------
  clk49_152MHz <= NOT clk49_152MHz AFTER 10173 ps;  -- 49.152/2 MHz
  clk50MHz     <= NOT clk50MHz     AFTER 10 ns;     -- 50 MHz
  -----------------------------------------------------------------------------
    
  MODULE_RHF1401 : FOR I IN 0 TO 7 GENERATE
    TestModule_RHF1401_1 : TestModule_RHF1401
      GENERIC MAP (
        freq      => 2400,--24*(I*5+1),
        amplitude => 4000,--8000/(I*5+1),
        impulsion => 0)
      PORT MAP (
        ADC_smpclk  => ADC_smpclk,
        ADC_OEB_bar => ADC_OEB_bar_CH_s(I),
        ADC_data    => ADC_data_s);
    --ADC_data_s <= "00" & X"190";
  END GENERATE MODULE_RHF1401;

  ADC_OEB_bar_CH_s <= TRANSPORT ADC_OEB_bar_CH AFTER 10 ns;
  ADC_data         <= TRANSPORT ADC_data_s     AFTER 35 ns;
  -----------------------------------------------------------------------------
  PROCESS (clk50MHz, reset)
  BEGIN  -- PROCESS
    IF reset = '0' THEN                 -- asynchronous reset (active low)
      nSRAM_BUSY           <= '1';
      counter_scrub_period <= 0;
    ELSIF clk50MHz'EVENT AND clk50MHz = '1' THEN  -- rising clock edge
      IF SCRUB_RATE_PERIOD + SCRUB_PERIOD  < counter_scrub_period THEN
        counter_scrub_period <= 0;
      ELSE
        counter_scrub_period <= counter_scrub_period + 1;
      END IF;

      IF counter_scrub_period < (SCRUB_RATE_PERIOD + SCRUB_PERIOD) - (SCRUB_PERIOD + SCRUB_BUSY_TO_SCRUB + SCRUB_SCRUB_TO_BUSY) THEN
        nSRAM_BUSY <= '1';
      ELSE
        nSRAM_BUSY <= '0';
      END IF;
    END IF;
  END PROCESS;

  -----------------------------------------------------------------------------
  -- TB
  -----------------------------------------------------------------------------
  TAG(1) <= TXD1;
  TAG(2) <= '1';
  RXD1   <= TAG(3);

  PROCESS
    CONSTANT txp         : TIME := 320 ns;
    VARIABLE data_read_v : STD_LOGIC_VECTOR(31 DOWNTO 0);
  BEGIN  -- PROCESS
    TXD1         <= '1';
    reset        <= '0';
    WAIT FOR 500 ns;
    reset        <= '1';
    WAIT FOR 100 us;
    message_simu <= "0 - UART init  ";
    UART_INIT(TXD1, txp);

    ---------------------------------------------------------------------------
    -- LAUNCH leon 3 software
    ---------------------------------------------------------------------------
    message_simu <= "2- GO Leon3....";

    -- bool dsu3plugin::configureTarget() ---------------------------------------------------------------------------------------------------------------------------
    --Force a debug break
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"0000" & X"0" & "00", X"0000002f"); --WriteRegs(uIntlist()<<,(unsigned int)DSUBASEADDRESS);
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"0000" & X"2" & "00", X"0000ffff"); --WriteRegs(uIntlist()<<0x0000ffff,(unsigned int)DSUBASEADDRESS+0x20);
    --Clear time tag counter
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"0000" & X"0" & "10", X"00000000"); --WriteRegs(uIntlist()<<0,(unsigned int)DSUBASEADDRESS+0x8);
    --Clear ASR registers
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"4000" & X"4" & "00", X"00000000"); --WriteRegs(uIntlist()<<0<<0<<0,(unsigned int)DSUBASEADDRESS+0x400040);
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"4000" & X"4" & "01", X"00000000");
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"4000" & X"4" & "10", X"00000000");
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"4000" & X"2" & "01", X"00000002"); --WriteRegs(uIntlist()<<0x2,(unsigned int)DSUBASEADDRESS+0x400024);
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"4000" & X"6" & "00", X"00000000"); --WriteRegs(uIntlist()<<0<<0<<0<<0<<0<<0<<0<<0,(unsigned int)DSUBASEADDRESS+0x400060);
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"4000" & X"6" & "01", X"00000000");
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"4000" & X"6" & "10", X"00000000");
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"4000" & X"6" & "11", X"00000000");    
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"4000" & X"7" & "00", X"00000000");
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"4000" & X"7" & "01", X"00000000");
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"4000" & X"7" & "10", X"00000000");
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"4000" & X"7" & "11", X"00000000");
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"0000" & X"4" & "10", X"00000000"); --WriteRegs(uIntlist()<<0,(unsigned int)DSUBASEADDRESS+0x48);
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"0000" & X"4" & "11", X"00000000"); --WriteRegs(uIntlist()<<0,(unsigned int)DSUBASEADDRESS+0x000004C);
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"4000" & X"4" & "00", X"00000000"); --WriteRegs(uIntlist()<<0,(unsigned int)DSUBASEADDRESS+0x400040);

    IF USE_ESA_MEMCTRL = 1 THEN
      UART_WRITE(TXD1, txp, ADDR_BASE_ESA_MEMCTRL & "000000", X"000002FF");     --WriteRegs(uIntlist()<<0x2FF<<0xE60<<0,(unsigned int)MCTRLBASEADDRESS);
      UART_WRITE(TXD1, txp, ADDR_BASE_ESA_MEMCTRL & "000001", X"00000E60");
      UART_WRITE(TXD1, txp, ADDR_BASE_ESA_MEMCTRL & "000010", X"00000000");
    END IF;

    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"4000" & X"6" & "00", X"00000000"); --WriteRegs(uIntlist()<<0<<0<<0<<0,(unsigned int)DSUBASEADDRESS+0x400060);
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"4000" & X"6" & "01", X"00000000");
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"4000" & X"6" & "10", X"00000000");
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"4000" & X"6" & "11", X"00000000");
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"0000" & X"2" & "01", X"0000ffff"); --WriteRegs(uIntlist()<<0x0000FFFF,(unsigned int)DSUBASEADDRESS+0x24);

                                                                                --memSet(DSUBASEADDRESS+0x300000,0,1567);

    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"4000" & X"0" & "00", X"00000000"); --WriteRegs(uIntlist()<<0<<0xF30000E0<<0x00000002<<0x40000000<<0x40000000<<0x40000004<<0x1000000,(unsigned int)DSUBASEADDRESS+0x400000);
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"4000" & X"0" & "01", X"F30000E0");
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"4000" & X"0" & "10", X"00000002");
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"4000" & X"0" & "11", X"40000000");
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"4000" & X"1" & "00", X"40000000");
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"4000" & X"1" & "01", X"40000004");
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"4000" & X"1" & "10", X"10000000");
    
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"3000" & X"2" & "00", X"00000000"); --WriteRegs(uIntlist()<<0<<0<<0<<0<<0<<0<<0x403ffff0<<0<<0<<0<<0<<0<<0<<0<<0<<0<<0<<0<<0<<0<<0<<0<<0<<0,(unsigned int)DSUBASEADDRESS+0x300020);
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"3000" & X"2" & "01", X"00000000");
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"3000" & X"2" & "10", X"00000000");
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"3000" & X"2" & "11", X"00000000");
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"3000" & X"3" & "00", X"00000000");
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"3000" & X"3" & "01", X"00000000");
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"3000" & X"3" & "10", X"403ffff0");
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"3000" & X"3" & "11", X"00000000");
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"3000" & X"4" & "00", X"00000000");
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"3000" & X"4" & "01", X"00000000");
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"3000" & X"4" & "10", X"00000000");
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"3000" & X"4" & "11", X"00000000");
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"3000" & X"5" & "00", X"00000000");
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"3000" & X"5" & "01", X"00000000");
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"3000" & X"5" & "10", X"00000000");
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"3000" & X"5" & "11", X"00000000");
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"3000" & X"6" & "00", X"00000000");
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"3000" & X"6" & "01", X"00000000");
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"3000" & X"6" & "10", X"00000000");
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"3000" & X"6" & "11", X"00000000");
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"3000" & X"7" & "00", X"00000000");
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"3000" & X"7" & "01", X"00000000");
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"3000" & X"7" & "10", X"00000000");
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"3000" & X"7" & "11", X"00000000");
    
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"0000" & X"0" & "00", X"000002EF"); --WriteRegs(uIntlist()<<0x000002EF,(unsigned int)DSUBASEADDRESS);

                                                                                --//Disable interrupts
                                                                                --unsigned int APBIRQCTRLRBASEADD = (unsigned int)SocExplorerEngine::self()->getEnumDeviceBaseAddress(this,1,0x0d,0);
                                                                                --if(APBIRQCTRLRBASEADD == (unsigned int)-1)
                                                                                --    return false;
                                                                                --WriteRegs(uIntlist()<<0x00000000,APBIRQCTRLRBASEADD+0x040);
                                                                                --WriteRegs(uIntlist()<<0xFFFE0000,APBIRQCTRLRBASEADD+0x080);
                                                                                --WriteRegs(uIntlist()<<0<<0,APBIRQCTRLRBASEADD);

                                                                               -- //Set up timer
                                                                                --unsigned int APBTIMERBASEADD = (unsigned int)SocExplorerEngine::self()->getEnumDeviceBaseAddress(this,1,0x11,0);
                                                                                --if(APBTIMERBASEADD == (unsigned int)-1)
                                                                                --    return false;
                                                                                --WriteRegs(uIntlist()<<0xffffffff,APBTIMERBASEADD+0x014);
                                                                                --WriteRegs(uIntlist()<<0x00000018,APBTIMERBASEADD+0x04);
                                                                                --WriteRegs(uIntlist()<<0x00000007,APBTIMERBASEADD+0x018);


    ---------------------------------------------------------------------------
    --bool dsu3plugin::setCacheEnable(bool enabled)
                                                                                --unsigned int DSUBASEADDRESS = SocExplorerEngine::self()->getEnumDeviceBaseAddress(this,0x01 , 0x004,0);
                                                                                --if(DSUBASEADDRESS == (unsigned int)-1) DSUBASEADDRESS = 0x90000000;
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"4000" & X"2" & "01", X"00000002"); --WriteRegs(uIntlist()<<2,DSUBASEADDRESS+0x400024);
    UART_READ(TXD1, RXD1, txp, ADDR_BASE_DSU & X"7000" & X"0" & "00", data_read_v);--unsigned int reg = ReadReg(DSUBASEADDRESS+0x700000);
    data_read    <= data_read_v;
                                                                                               --if(enabled){
    UART_WRITE(TXD1, txp, ADDR_BASE_DSU & X"7000" & X"0" & "00" , data_read_v OR X"0001000F"); --WriteRegs(uIntlist()<<(0x0001000F|reg),DSUBASEADDRESS+0x700000);
    UART_WRITE(TXD1, txp, ADDR_BASE_DSU & X"7000" & X"0" & "00" , data_read_v OR X"0061000F"); --WriteRegs(uIntlist()<<(0x0061000F|reg),DSUBASEADDRESS+0x700000);        
                                                                                               --}else{
                                                                                               --WriteRegs(uIntlist()<<((!0x0001000F)&reg),DSUBASEADDRESS+0x700000);
                                                                                               --WriteRegs(uIntlist()<<(0x00600000|reg),DSUBASEADDRESS+0x700000);
                                                                                               --}

    
    -- void dsu3plugin::run() ---------------------------------------------------------------------------------------------------------------------------------------
    UART_WRITE(TXD1 , txp, ADDR_BASE_DSU & X"0000" & X"2" & "00", X"00000000"); --WriteRegs(uIntlist()<<0,DSUBASEADDRESS+0x020);
    
    ---------------------------------------------------------------------------
    --message_simu <= "1 - UART test  ";
    --UART_WRITE(TXD1, txp, ADDR_BASE_GPIO & "000010", X"0000FFFF");
    --UART_WRITE(TXD1, txp, ADDR_BASE_GPIO & "000001", X"00000A0A");
    --UART_WRITE(TXD1, txp, ADDR_BASE_GPIO & "000001", X"00000B0B");
    --UART_READ(TXD1, RXD1, txp, ADDR_BASE_GPIO & "000001", data_read_v);
    --data_read    <= data_read_v;
    --data_message <= "GPIO_data_write";

    -- UNSET the LFR reset
    message_simu <= "2 - LFR UNRESET";
    UNRESET_LFR(TXD1, txp, ADDR_BASE_TIME_MANAGMENT);
    --
    message_simu <= "3 - LFR CONFIG ";
    LAUNCH_SPECTRAL_MATRIX(TXD1, RXD1, txp, ADDR_BASE_LFR,
                           ADDR_BUFFER_MS_F0_0,
                           ADDR_BUFFER_MS_F0_1,
                           ADDR_BUFFER_MS_F1_0,
                           ADDR_BUFFER_MS_F1_1,
                           ADDR_BUFFER_MS_F2_0,
                           ADDR_BUFFER_MS_F2_1);

    
    LAUNCH_WAVEFORM_PICKER(TXD1, RXD1, txp,
                           LFR_MODE_SBM1,
                           X"7FFFFFFF",  -- START DATE

                           "00000",      --DATA_SHAPING  ( 4 DOWNTO 0)
                           X"00012BFF",  --DELTA_SNAPSHOT(31 DOWNTO 0)
                           X"0001280A",  --DELTA_F0      (31 DOWNTO 0)
                           X"00000007",  --DELTA_F0_2    (31 DOWNTO 0)
                           X"0001283F",  --DELTA_F1      (31 DOWNTO 0)
                           X"000127FF",  --DELTA_F2      (31 DOWNTO 0)

                           ADDR_BASE_LFR,
                           ADDR_BUFFER_WFP_F0_0,
                           ADDR_BUFFER_WFP_F0_1,
                           ADDR_BUFFER_WFP_F1_0,
                           ADDR_BUFFER_WFP_F1_1,
                           ADDR_BUFFER_WFP_F2_0,
                           ADDR_BUFFER_WFP_F2_1,
                           ADDR_BUFFER_WFP_F3_0,
                           ADDR_BUFFER_WFP_F3_1);

    UART_WRITE(TXD1 , txp, ADDR_BASE_LFR & ADDR_LFR_WP_LENGTH, X"0000000F");
    UART_WRITE(TXD1 , txp, ADDR_BASE_LFR & ADDR_LFR_WP_DATA_IN_BUFFER, X"00000050");


    ---------------------------------------------------------------------------
    -- CONFIG LFR 2
    ---------------------------------------------------------------------------
    --message_simu <= "3 - LFR2 CONFIG";
    --LAUNCH_SPECTRAL_MATRIX(TXD1,RXD1,txp,ADDR_BASE_LFR_2,
    --                       X"40000000",
    --                       X"40001000",
    --                       X"40002000",
    --                       X"40003000",
    --                       X"40004000",
    --                       X"40005000");


    --LAUNCH_WAVEFORM_PICKER(TXD1,RXD1,txp,
    --                       LFR_MODE_SBM1,
    --                       X"7FFFFFFF",  -- START DATE

    --                       "00000",--DATA_SHAPING  ( 4 DOWNTO 0)
    --                       X"00012BFF",--DELTA_SNAPSHOT(31 DOWNTO 0)
    --                       X"0001280A",--DELTA_F0      (31 DOWNTO 0)
    --                       X"00000007",--DELTA_F0_2    (31 DOWNTO 0)
    --                       X"0001283F",--DELTA_F1      (31 DOWNTO 0)
    --                       X"000127FF",--DELTA_F2      (31 DOWNTO 0)

    --                       ADDR_BASE_LFR_2,
    --                       X"40006000",
    --                       X"40007000",
    --                       X"40008000",
    --                       X"40009000",
    --                       X"4000A000",
    --                       X"4000B000",
    --                       X"4000C000",
    --                       X"4000D000");

    --UART_WRITE(TXD1   ,txp,ADDR_BASE_LFR_2 & ADDR_LFR_WP_LENGTH,         X"0000000F");
    --UART_WRITE(TXD1   ,txp,ADDR_BASE_LFR_2 & ADDR_LFR_WP_DATA_IN_BUFFER, X"00000050");

    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------
    UART_WRITE (TXD1 , txp, ADDR_BASE_LFR & X"5" & "10", X"FFFFFFFF");


    message_simu <= "4 - GO GO GO !!";
    data_message <= "---------------";
    UART_WRITE (TXD1 , txp, ADDR_BASE_LFR & ADDR_LFR_WP_START_DATE, X"00000000");
 --   UART_WRITE (TXD1 , txp, ADDR_BASE_LFR_2 & ADDR_LFR_WP_START_DATE, X"00000000");


    data_read_v := (OTHERS => '1');
    READ_STATUS : LOOP
      data_message <= "---------------";
      WAIT FOR 2 ms;
      data_message <= "READ_STATUS_SM_";
      --UART_READ(TXD1, RXD1, txp, ADDR_BASE_LFR & ADDR_LFR_SM_STATUS, data_read_v);
      --data_message <= "--------------r";
      --data_read    <= data_read_v;
      UART_WRITE(TXD1, txp, ADDR_BASE_LFR & ADDR_LFR_SM_STATUS, data_read_v);

      data_message <= "READ_STATUS_WF_";
      --UART_READ(TXD1, RXD1, txp, ADDR_BASE_LFR & ADDR_LFR_WP_STATUS, data_read_v);
      --data_message <= "--------------r";
      --data_read <= data_read_v;
      UART_WRITE(TXD1, txp, ADDR_BASE_LFR & ADDR_LFR_WP_STATUS, data_read_v);
    END LOOP READ_STATUS;

    WAIT;
  END PROCESS;


  -----------------------------------------------------------------------------
  PROCESS (nSRAM_W, reset)
  BEGIN  -- PROCESS
    IF reset = '0' THEN                 -- asynchronous reset (active low)
      data_pre_f0 <= X"00020001";
      data_pre_f1 <= X"00020001";
      data_pre_f2 <= X"00020001";

      addr_pre_f0 <= (OTHERS => '0');
      addr_pre_f1 <= (OTHERS => '0');
      addr_pre_f2 <= (OTHERS => '0');

      error_wfp      <= "000";
      error_wfp_addr <= "000";

      sample_counter <= (0,0,0);
      
    ELSIF nSRAM_W'EVENT AND nSRAM_W = '0' THEN  -- rising clock edge
      error_wfp      <= "000";
      error_wfp_addr <= "000";
      -------------------------------------------------------------------------
      IF address(18 DOWNTO 14) = ADDR_BUFFER_WFP_F0_0(20 DOWNTO 16) OR
        address(18 DOWNTO 14) = ADDR_BUFFER_WFP_F0_1(20 DOWNTO 16) THEN

        addr_pre_f0 <= address(13 DOWNTO 0);
        IF to_integer(UNSIGNED(address(13 DOWNTO 0))) /= (to_integer(UNSIGNED(addr_pre_f0))+1) THEN
          IF to_integer(UNSIGNED(address(13 DOWNTO 0))) /= 0 THEN
            error_wfp_addr(0) <= '1';
          END IF;
        END IF;

        data_pre_f0 <= data;
        CASE data_pre_f0 IS
          WHEN X"00200010" => IF data /= X"00080004" THEN error_wfp(0) <= '1'; END IF;
          WHEN X"00080004" => IF data /= X"00020001" THEN error_wfp(0) <= '1'; END IF;
          WHEN X"00020001" => IF data /= X"00200010" THEN error_wfp(0) <= '1'; END IF;
          WHEN OTHERS      => error_wfp(0)                             <= '1';
        END CASE;

        
      END IF;
      -------------------------------------------------------------------------
      IF address(18 DOWNTO 14) = ADDR_BUFFER_WFP_F1_0(20 DOWNTO 16) OR
        address(18 DOWNTO 14) = ADDR_BUFFER_WFP_F1_1(20 DOWNTO 16) THEN

        addr_pre_f1 <= address(13 DOWNTO 0);
        IF to_integer(UNSIGNED(address(13 DOWNTO 0))) /= (to_integer(UNSIGNED(addr_pre_f1))+1) THEN
          IF to_integer(UNSIGNED(address(13 DOWNTO 0))) /= 0 THEN
            error_wfp_addr(1) <= '1';
          END IF;
        END IF;

        data_pre_f1 <= data;
        CASE data_pre_f1 IS
          WHEN X"00200010" => IF data /= X"00080004" THEN error_wfp(1) <= '1'; END IF;
          WHEN X"00080004" => IF data /= X"00020001" THEN error_wfp(1) <= '1'; END IF;
          WHEN X"00020001" => IF data /= X"00200010" THEN error_wfp(1) <= '1'; END IF;
          WHEN OTHERS      => error_wfp(1)                             <= '1';
        END CASE;

        sample(1,0 + sample_counter(1)*2) <= data(31 DOWNTO 16);
        sample(1,1 + sample_counter(1)*2) <= data(15 DOWNTO 0);
        sample_counter(1) <= (sample_counter(1) + 1) MOD 3;
        
      END IF;
      -------------------------------------------------------------------------
      IF address(18 DOWNTO 14) = ADDR_BUFFER_WFP_F2_0(20 DOWNTO 16) OR
        address(18 DOWNTO 14) = ADDR_BUFFER_WFP_F2_1(20 DOWNTO 16) THEN

        addr_pre_f2 <= address(13 DOWNTO 0);
        IF to_integer(UNSIGNED(address(13 DOWNTO 0))) /= (to_integer(UNSIGNED(addr_pre_f2))+1) THEN
          IF to_integer(UNSIGNED(address(13 DOWNTO 0))) /= 0 THEN
            error_wfp_addr(2) <= '1';
          END IF;
        END IF;

        data_pre_f2 <= data;
        CASE data_pre_f2 IS
          WHEN X"00200010" => IF data /= X"00080004" THEN error_wfp(2) <= '1'; END IF;
          WHEN X"00080004" => IF data /= X"00020001" THEN error_wfp(2) <= '1'; END IF;
          WHEN X"00020001" => IF data /= X"00200010" THEN error_wfp(2) <= '1'; END IF;
          WHEN OTHERS      => error_wfp(2)                             <= '1';
        END CASE;

        sample(2,0 + sample_counter(2)*2) <= data(31 DOWNTO 16);
        sample(2,1 + sample_counter(2)*2) <= data(15 DOWNTO 0);
        sample_counter(2) <= (sample_counter(2) + 1) MOD 3;
      
      END IF;
    END IF;
  END PROCESS;
  -----------------------------------------------------------------------------
  ramsn(1 DOWNTO 0) <= nSRAM_E2 & nSRAM_E1;
  
  sbanks : FOR k IN 0 TO srambanks-1 GENERATE
    sram0 : FOR i IN 0 TO (sramwidth/8)-1 GENERATE
      sr0 : sram
        GENERIC MAP (
          index => i,
          abits => sramdepth,
          fname => sramfile)
        PORT MAP (
          address,
          data(31-i*8 DOWNTO 24-i*8),
          ramsn(k),
          nSRAM_W,
          nSRAM_G
          );
    END GENERATE;
  END GENERATE;
  
END beh;

