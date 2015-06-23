LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use IEEE.std_logic_textio.all;
LIBRARY STD;
use std.textio.all;

LIBRARY grlib;
USE grlib.stdlib.ALL;
LIBRARY gaisler;
USE gaisler.libdcom.ALL;
USE gaisler.sim.ALL;
USE gaisler.jtagtst.ALL;
LIBRARY techmap;
USE techmap.gencomp.ALL;

LIBRARY lpp;
USE lpp.lpp_sim_pkg.ALL;
USE lpp.lpp_lfr_sim_pkg.ALL;
USE lpp.lpp_lfr_apbreg_pkg.ALL;
USE lpp.lpp_lfr_time_management_apbreg_pkg.ALL;


ENTITY testbench IS
END;

ARCHITECTURE behav OF testbench IS

  COMPONENT LFR_em
    PORT (
      clk100MHz      : IN    STD_ULOGIC;
      clk49_152MHz   : IN    STD_ULOGIC;
      reset          : IN    STD_ULOGIC;
      TAG1           : IN    STD_ULOGIC;
      TAG3           : OUT   STD_ULOGIC;
      TAG2           : IN    STD_ULOGIC;
      TAG4           : OUT   STD_ULOGIC;
      address        : OUT   STD_LOGIC_VECTOR(19 DOWNTO 0);
      data           : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      nSRAM_BE0      : OUT   STD_LOGIC;
      nSRAM_BE1      : OUT   STD_LOGIC;
      nSRAM_BE2      : OUT   STD_LOGIC;
      nSRAM_BE3      : OUT   STD_LOGIC;
      nSRAM_WE       : OUT   STD_LOGIC;
      nSRAM_CE       : OUT   STD_LOGIC;
      nSRAM_OE       : OUT   STD_LOGIC;
      spw1_din       : IN    STD_LOGIC;
      spw1_sin       : IN    STD_LOGIC;
      spw1_dout      : OUT   STD_LOGIC;
      spw1_sout      : OUT   STD_LOGIC;
      spw2_din       : IN    STD_LOGIC;
      spw2_sin       : IN    STD_LOGIC;
      spw2_dout      : OUT   STD_LOGIC;
      spw2_sout      : OUT   STD_LOGIC;
      bias_fail_sw   : OUT   STD_LOGIC;
      ADC_OEB_bar_CH : OUT   STD_LOGIC_VECTOR(7 DOWNTO 0);
      ADC_smpclk     : OUT   STD_LOGIC;
      ADC_data       : IN    STD_LOGIC_VECTOR(13 DOWNTO 0);
      HK_smpclk      : OUT   STD_LOGIC;
      ADC_OEB_bar_HK : OUT   STD_LOGIC;
      HK_SEL         : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
      TAG8           : OUT   STD_LOGIC;
      led            : OUT   STD_LOGIC_VECTOR(2 DOWNTO 0));
  END COMPONENT;

  
  --COMPONENT MINI_LFR_top
  --  PORT (
  --    clk_50       : IN    STD_LOGIC;
  --    clk_49       : IN    STD_LOGIC;
  --    reset        : IN    STD_LOGIC;
  --    BP0          : IN    STD_LOGIC;
  --    BP1          : IN    STD_LOGIC;
  --    LED0         : OUT   STD_LOGIC;
  --    LED1         : OUT   STD_LOGIC;
  --    LED2         : OUT   STD_LOGIC;
  --    TXD1         : IN    STD_LOGIC;
  --    RXD1         : OUT   STD_LOGIC;
  --    nCTS1        : OUT   STD_LOGIC;
  --    nRTS1        : IN    STD_LOGIC;
  --    TXD2         : IN    STD_LOGIC;
  --    RXD2         : OUT   STD_LOGIC;
  --    nCTS2        : OUT   STD_LOGIC;
  --    nDTR2        : IN    STD_LOGIC;
  --    nRTS2        : IN    STD_LOGIC;
  --    nDCD2        : OUT   STD_LOGIC;
  --    IO0          : INOUT STD_LOGIC;
  --    IO1          : INOUT STD_LOGIC;
  --    IO2          : INOUT STD_LOGIC;
  --    IO3          : INOUT STD_LOGIC;
  --    IO4          : INOUT STD_LOGIC;
  --    IO5          : INOUT STD_LOGIC;
  --    IO6          : INOUT STD_LOGIC;
  --    IO7          : INOUT STD_LOGIC;
  --    IO8          : INOUT STD_LOGIC;
  --    IO9          : INOUT STD_LOGIC;
  --    IO10         : INOUT STD_LOGIC;
  --    IO11         : INOUT STD_LOGIC;
  --    SPW_EN       : OUT   STD_LOGIC;
  --    SPW_NOM_DIN  : IN    STD_LOGIC;
  --    SPW_NOM_SIN  : IN    STD_LOGIC;
  --    SPW_NOM_DOUT : OUT   STD_LOGIC;
  --    SPW_NOM_SOUT : OUT   STD_LOGIC;
  --    SPW_RED_DIN  : IN    STD_LOGIC;
  --    SPW_RED_SIN  : IN    STD_LOGIC;
  --    SPW_RED_DOUT : OUT   STD_LOGIC;
  --    SPW_RED_SOUT : OUT   STD_LOGIC;
  --    ADC_nCS      : OUT   STD_LOGIC;
  --    ADC_CLK      : OUT   STD_LOGIC;
  --    ADC_SDO      : IN    STD_LOGIC_VECTOR(7 DOWNTO 0);
  --    SRAM_nWE     : OUT   STD_LOGIC;
  --    SRAM_CE      : OUT   STD_LOGIC;
  --    SRAM_nOE     : OUT   STD_LOGIC;
  --    SRAM_nBE     : OUT   STD_LOGIC_VECTOR(3 DOWNTO 0);
  --    SRAM_A       : OUT   STD_LOGIC_VECTOR(19 DOWNTO 0);
  --    SRAM_DQ      : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0));
  --END COMPONENT;

  -----------------------------------------------------------------------------
  SIGNAL clk_50 : STD_LOGIC := '0';
  SIGNAL clk_49 : STD_LOGIC := '0';
  SIGNAL reset        : STD_LOGIC;
  SIGNAL BP0          : STD_LOGIC;
  SIGNAL BP1          : STD_LOGIC;
  SIGNAL LED0         : STD_LOGIC;
  SIGNAL LED1         : STD_LOGIC;
  SIGNAL LED2         : STD_LOGIC;
  SIGNAL TXD1         : STD_LOGIC;
  SIGNAL RXD1         : STD_LOGIC;
  SIGNAL nCTS1        : STD_LOGIC;
  SIGNAL nRTS1        : STD_LOGIC;
  SIGNAL TXD2         : STD_LOGIC;
  SIGNAL RXD2         : STD_LOGIC;
  SIGNAL nCTS2        : STD_LOGIC;
  SIGNAL nDTR2        : STD_LOGIC;
  SIGNAL nRTS2        : STD_LOGIC;
  SIGNAL nDCD2        : STD_LOGIC;
  SIGNAL IO0          : STD_LOGIC;
  SIGNAL IO1          : STD_LOGIC;
  SIGNAL IO2          : STD_LOGIC;
  SIGNAL IO3          : STD_LOGIC;
  SIGNAL IO4          : STD_LOGIC;
  SIGNAL IO5          : STD_LOGIC;
  SIGNAL IO6          : STD_LOGIC;
  SIGNAL IO7          : STD_LOGIC;
  SIGNAL IO8          : STD_LOGIC;
  SIGNAL IO9          : STD_LOGIC;
  SIGNAL IO10         : STD_LOGIC;
  SIGNAL IO11         : STD_LOGIC;
  SIGNAL SPW_EN       : STD_LOGIC;
  SIGNAL SPW_NOM_DIN  : STD_LOGIC;
  SIGNAL SPW_NOM_SIN  : STD_LOGIC;
  SIGNAL SPW_NOM_DOUT : STD_LOGIC;
  SIGNAL SPW_NOM_SOUT : STD_LOGIC;
  SIGNAL SPW_RED_DIN  : STD_LOGIC;
  SIGNAL SPW_RED_SIN  : STD_LOGIC;
  SIGNAL SPW_RED_DOUT : STD_LOGIC;
  SIGNAL SPW_RED_SOUT : STD_LOGIC;
  SIGNAL ADC_nCS      : STD_LOGIC;
  SIGNAL ADC_CLK      : STD_LOGIC;
  SIGNAL ADC_SDO      : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL SRAM_nWE     : STD_LOGIC;
  SIGNAL SRAM_CE      : STD_LOGIC;
  SIGNAL SRAM_nOE     : STD_LOGIC;
  SIGNAL SRAM_nBE     : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL SRAM_A       : STD_LOGIC_VECTOR(19 DOWNTO 0);
  SIGNAL SRAM_DQ      : STD_LOGIC_VECTOR(31 DOWNTO 0);
  
  -----------------------------------------------------------------------------
  
  SIGNAL ADC_OEB_bar_CH : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL ADC_smpclk     : STD_LOGIC;
  SIGNAL ADC_data       : STD_LOGIC_VECTOR(13 DOWNTO 0);
  SIGNAL HK_smpclk      : STD_LOGIC;
  SIGNAL ADC_OEB_bar_HK : STD_LOGIC;
  SIGNAL HK_SEL         : STD_LOGIC_VECTOR(1 DOWNTO 0);

  SIGNAL all_OEB_bar : STD_LOGIC_VECTOR(8 DOWNTO 0);
  SIGNAL HK_SEL_DATA : STD_LOGIC_VECTOR(13 DOWNTO 0);
  
  -----------------------------------------------------------------------------

  CONSTANT ADDR_BASE_LFR            : STD_LOGIC_VECTOR(31 DOWNTO 8) := X"80000F";
  CONSTANT ADDR_BASE_TIME_MANAGMENT : STD_LOGIC_VECTOR(31 DOWNTO 8) := X"800006";
  CONSTANT ADDR_BASE_GPIO           : STD_LOGIC_VECTOR(31 DOWNTO 8) := X"80000B";


  SIGNAL message_simu : STRING(1 TO 15) := "---------------";
  SIGNAL data_message : STRING(1 TO 15) := "---------------";
  SIGNAL data_read    : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
  
BEGIN

  -----------------------------------------------------------------------------
  -- TB
  -----------------------------------------------------------------------------
  PROCESS
    CONSTANT txp : TIME := 320 ns;
    VARIABLE data_read_v : STD_LOGIC_VECTOR(31 DOWNTO 0);
  BEGIN  -- PROCESS
    TXD1  <= '1';
    reset <= '0';
    WAIT FOR 500 ns;
    reset <= '1';
    WAIT FOR 10000 ns;
    message_simu <= "0 - UART init  ";
    UART_INIT(TXD1,txp);
    
    message_simu <= "1 - UART test  ";
    UART_WRITE(TXD1,txp,ADDR_BASE_GPIO & "000010",X"0000FFFF");
    UART_WRITE(TXD1,txp,ADDR_BASE_GPIO & "000001",X"00000A0A");
    UART_WRITE(TXD1,txp,ADDR_BASE_GPIO & "000001",X"00000B0B");
    UART_READ(TXD1,RXD1,txp,ADDR_BASE_GPIO & "000001",data_read_v);
    data_read    <= data_read_v;
    data_message <= "GPIO_data_write";
    
    -- UNSET the LFR reset
    message_simu <= "2 - LFR UNRESET";
    UNRESET_LFR(TXD1,txp,ADDR_BASE_TIME_MANAGMENT);
    --UART_WRITE(TXD1,txp,ADDR_BASE_TIME_MANAGMENT & ADDR_LFR_TM_CONTROL   , X"00000000");
    --UART_WRITE(TXD1,txp,ADDR_BASE_TIME_MANAGMENT & ADDR_LFR_TM_TIME_LOAD , X"00000000");
    --
    message_simu <= "3 - LFR CONFIG ";
    --UART_WRITE(TXD1,txp,ADDR_BASE_LFR & ADDR_LFR_SM_F0_0_ADDR , X"00000B0B");
    LAUNCH_SPECTRAL_MATRIX(TXD1,RXD1,txp,ADDR_BASE_LFR,
                           X"40000000",
                           X"40001000",
                           X"40002000",
                           X"40003000",
                           X"40004000",
                           X"40005000");

    
    LAUNCH_WAVEFORM_PICKER(TXD1,RXD1,txp,
                           LFR_MODE_SBM1,
                           X"7FFFFFFF",  -- START DATE
    
                           "00000",--DATA_SHAPING  ( 4 DOWNTO 0)
                           X"00012BFF",--DELTA_SNAPSHOT(31 DOWNTO 0)
                           X"0001280A",--DELTA_F0      (31 DOWNTO 0)
                           X"00000007",--DELTA_F0_2    (31 DOWNTO 0)
                           X"0001283F",--DELTA_F1      (31 DOWNTO 0)
                           X"000127FF",--DELTA_F2      (31 DOWNTO 0)
                          
                           ADDR_BASE_LFR,
                           X"40006000",
                           X"40007000",
                           X"40008000",
                           X"40009000",
                           X"4000A000",
                           X"4000B000",
                           X"4000C000",
                           X"4000D000");

    UART_WRITE(TXD1   ,txp,ADDR_BASE_LFR & ADDR_LFR_WP_LENGTH,         X"0000000F");
    UART_WRITE(TXD1   ,txp,ADDR_BASE_LFR & ADDR_LFR_WP_DATA_IN_BUFFER, X"00000050");
        
    message_simu <= "4 - GO GO GO !!";
    UART_WRITE            (TXD1 ,txp,ADDR_BASE_LFR & ADDR_LFR_WP_START_DATE,X"00000000");

    READ_STATUS: LOOP
      WAIT FOR 2 ms;
      data_message <= "READ_NEW_STATUS";
      UART_READ(TXD1,RXD1,txp,ADDR_BASE_LFR & ADDR_LFR_SM_STATUS,data_read_v);
      data_read    <= data_read_v;
      UART_WRITE(TXD1,    txp,ADDR_BASE_LFR & ADDR_LFR_SM_STATUS,data_read_v);
      
      UART_READ(TXD1,RXD1,txp,ADDR_BASE_LFR & ADDR_LFR_WP_STATUS,data_read_v);
      data_read    <= data_read_v;
      UART_WRITE(TXD1,    txp,ADDR_BASE_LFR & ADDR_LFR_WP_STATUS,data_read_v);
    END LOOP READ_STATUS;
    
    WAIT;
  END PROCESS;

  -----------------------------------------------------------------------------
  -- CLOCK
  -----------------------------------------------------------------------------
  clk_50    <= NOT clk_50 AFTER 5 ns;
  clk_49    <= NOT clk_49 AFTER 10172 ps;
  
  -----------------------------------------------------------------------------
  -- DON'T CARE
  -----------------------------------------------------------------------------
  BP0   <= '0';
  BP1   <= '0';
  nRTS1 <= '0' ;

  TXD2  <= '1';
  nRTS2 <= '1';
  nDTR2 <= '1';
  
  SPW_NOM_DIN  <= '1';
  SPW_NOM_SIN  <= '1';
  SPW_RED_DIN  <= '1';
  SPW_RED_SIN  <= '1';
  
  ADC_SDO      <= x"AA";

  SRAM_DQ      <= (OTHERS => 'Z');
  --IO0          <= 'Z';
  --IO1          <= 'Z';
  --IO2          <= 'Z';
  --IO3          <= 'Z';
  --IO4          <= 'Z';
  --IO5          <= 'Z';
  --IO6          <= 'Z';
  --IO7          <= 'Z';
  --IO8          <= 'Z';
  --IO9          <= 'Z';
  --IO10         <= 'Z';
  --IO11         <= 'Z';

  -----------------------------------------------------------------------------
  -- DUT
  -----------------------------------------------------------------------------

  LFR_em_1: LFR_em
    PORT MAP (
      clk100MHz      => clk_50,
      clk49_152MHz   => clk_49,
      reset          => reset,
      
      TAG1           => TXD1,
      TAG3           => RXD1,
      TAG2           => TXD2,
      TAG4           => RXD2,
      
      address        => SRAM_A,
      data           => SRAM_DQ,
      nSRAM_BE0      => SRAM_nBE(0),
      nSRAM_BE1      => SRAM_nBE(1),
      nSRAM_BE2      => SRAM_nBE(2),
      nSRAM_BE3      => SRAM_nBE(3),
      nSRAM_WE       => SRAM_nWE,
      nSRAM_CE       => SRAM_CE,
      nSRAM_OE       => SRAM_nOE,
      
      spw1_din       => SPW_NOM_DIN, 
      spw1_sin       => SPW_NOM_SIN, 
      spw1_dout      => SPW_NOM_DOUT,
      spw1_sout      => SPW_NOM_SOUT,
      spw2_din       => SPW_RED_DIN, 
      spw2_sin       => SPW_RED_SIN, 
      spw2_dout      => SPW_RED_DOUT,
      spw2_sout      => SPW_RED_SOUT,
      
      bias_fail_sw   => OPEN,
      
      ADC_OEB_bar_CH => ADC_OEB_bar_CH,
      ADC_smpclk     => ADC_smpclk,
      ADC_data       => ADC_data,
      HK_smpclk      => HK_smpclk,
      ADC_OEB_bar_HK => ADC_OEB_bar_HK,
      HK_SEL         => HK_SEL,
      
      TAG8           => OPEN,
      led            => OPEN);

  all_OEB_bar <= ADC_OEB_bar_HK & ADC_OEB_bar_CH;
  
  WITH HK_SEL SELECT
    HK_SEL_DATA <=
    "00"&X"00F" WHEN "00",
    "00"&X"01F" WHEN "01",
    "00"&X"02F" WHEN "10",
    "XXXXXXXXXXXXXX" WHEN OTHERS;

  WITH all_OEB_bar SELECT
    ADC_data <=
    "00"&X"000" WHEN "111111110",
    "00"&X"001" WHEN "111111101",
    "00"&X"002" WHEN "111111011",
    "00"&X"003" WHEN "111110111",
    "00"&X"004" WHEN "111101111",
    "00"&X"005" WHEN "111011111",
    "00"&X"006" WHEN "110111111",
    "00"&X"007" WHEN "101111111",
    HK_SEL_DATA WHEN "011111111",
    "XXXXXXXXXXXXXX" WHEN OTHERS;
  
END;
