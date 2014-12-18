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
USE lpp.lpp_lfr_apbreg_pkg.ALL;
USE lpp.lpp_lfr_time_management_apbreg_pkg.ALL;


ENTITY testbench IS
END;

ARCHITECTURE behav OF testbench IS

  COMPONENT MINI_LFR_top
    PORT (
      clk_50       : IN    STD_LOGIC;
      clk_49       : IN    STD_LOGIC;
      reset        : IN    STD_LOGIC;
      BP0          : IN    STD_LOGIC;
      BP1          : IN    STD_LOGIC;
      LED0         : OUT   STD_LOGIC;
      LED1         : OUT   STD_LOGIC;
      LED2         : OUT   STD_LOGIC;
      TXD1         : IN    STD_LOGIC;
      RXD1         : OUT   STD_LOGIC;
      nCTS1        : OUT   STD_LOGIC;
      nRTS1        : IN    STD_LOGIC;
      TXD2         : IN    STD_LOGIC;
      RXD2         : OUT   STD_LOGIC;
      nCTS2        : OUT   STD_LOGIC;
      nDTR2        : IN    STD_LOGIC;
      nRTS2        : IN    STD_LOGIC;
      nDCD2        : OUT   STD_LOGIC;
      IO0          : INOUT STD_LOGIC;
      IO1          : INOUT STD_LOGIC;
      IO2          : INOUT STD_LOGIC;
      IO3          : INOUT STD_LOGIC;
      IO4          : INOUT STD_LOGIC;
      IO5          : INOUT STD_LOGIC;
      IO6          : INOUT STD_LOGIC;
      IO7          : INOUT STD_LOGIC;
      IO8          : INOUT STD_LOGIC;
      IO9          : INOUT STD_LOGIC;
      IO10         : INOUT STD_LOGIC;
      IO11         : INOUT STD_LOGIC;
      SPW_EN       : OUT   STD_LOGIC;
      SPW_NOM_DIN  : IN    STD_LOGIC;
      SPW_NOM_SIN  : IN    STD_LOGIC;
      SPW_NOM_DOUT : OUT   STD_LOGIC;
      SPW_NOM_SOUT : OUT   STD_LOGIC;
      SPW_RED_DIN  : IN    STD_LOGIC;
      SPW_RED_SIN  : IN    STD_LOGIC;
      SPW_RED_DOUT : OUT   STD_LOGIC;
      SPW_RED_SOUT : OUT   STD_LOGIC;
      ADC_nCS      : OUT   STD_LOGIC;
      ADC_CLK      : OUT   STD_LOGIC;
      ADC_SDO      : IN    STD_LOGIC_VECTOR(7 DOWNTO 0);
      SRAM_nWE     : OUT   STD_LOGIC;
      SRAM_CE      : OUT   STD_LOGIC;
      SRAM_nOE     : OUT   STD_LOGIC;
      SRAM_nBE     : OUT   STD_LOGIC_VECTOR(3 DOWNTO 0);
      SRAM_A       : OUT   STD_LOGIC_VECTOR(19 DOWNTO 0);
      SRAM_DQ      : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0));
  END COMPONENT;

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

  CONSTANT ADDR_BASE_LFR            : STD_LOGIC_VECTOR(31 DOWNTO 8) := X"80000F";
  CONSTANT ADDR_BASE_TIME_MANAGMENT : STD_LOGIC_VECTOR(31 DOWNTO 8) := X"800006";
  CONSTANT ADDR_BASE_GPIO           : STD_LOGIC_VECTOR(31 DOWNTO 8) := X"80000B";


  SIGNAL message_simu : STRING(1 TO 15) := "---------------";
  
BEGIN

  -----------------------------------------------------------------------------
  -- TB
  -----------------------------------------------------------------------------
  PROCESS
    CONSTANT txp : TIME := 320 ns;
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

    -- UNSET the LFR reset
    message_simu <= "2 - LFR UNRESET";
    UART_WRITE(TXD1,txp,ADDR_BASE_TIME_MANAGMENT & ADDR_LFR_TM_CONTROL   , X"00000000");
    UART_WRITE(TXD1,txp,ADDR_BASE_TIME_MANAGMENT & ADDR_LFR_TM_TIME_LOAD , X"00000000");
    --
    message_simu <= "3 - LFR CONFIG ";
    UART_WRITE(TXD1,txp,ADDR_BASE_LFR & ADDR_LFR_SM_F0_0_ADDR , X"00000B0B");
    
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
  MINI_LFR_top_1: MINI_LFR_top
    PORT MAP (
      clk_50       => clk_50,
      clk_49       => clk_49,
      reset        => reset,
      
      BP0          => BP0,
      BP1          => BP1,

      LED0         => LED0,
      LED1         => LED1,
      LED2         => LED2,

      TXD1         => TXD1,
      RXD1         => RXD1,
      nCTS1        => nCTS1,
      nRTS1        => nRTS1,
      
      TXD2         => TXD2,
      RXD2         => RXD2,
      nCTS2        => nCTS2,
      nDTR2        => nDTR2,
      nRTS2        => nRTS2,
      nDCD2        => nDCD2,
      
      IO0          => IO0,
      IO1          => IO1,
      IO2          => IO2,
      IO3          => IO3,
      IO4          => IO4,
      IO5          => IO5,
      IO6          => IO6,
      IO7          => IO7,
      IO8          => IO8,
      IO9          => IO9,
      IO10         => IO10,
      IO11         => IO11,
      
      SPW_EN       => SPW_EN,
      SPW_NOM_DIN  => SPW_NOM_DIN,
      SPW_NOM_SIN  => SPW_NOM_SIN,
      SPW_NOM_DOUT => SPW_NOM_DOUT,
      SPW_NOM_SOUT => SPW_NOM_SOUT,
      SPW_RED_DIN  => SPW_RED_DIN,
      SPW_RED_SIN  => SPW_RED_SIN,
      SPW_RED_DOUT => SPW_RED_DOUT,
      SPW_RED_SOUT => SPW_RED_SOUT,
      
      ADC_nCS      => ADC_nCS,
      ADC_CLK      => ADC_CLK,
      ADC_SDO      => ADC_SDO,
      
      SRAM_nWE     => SRAM_nWE,
      SRAM_CE      => SRAM_CE,
      SRAM_nOE     => SRAM_nOE,
      SRAM_nBE     => SRAM_nBE,
      SRAM_A       => SRAM_A,
      SRAM_DQ      => SRAM_DQ);

  
END;
