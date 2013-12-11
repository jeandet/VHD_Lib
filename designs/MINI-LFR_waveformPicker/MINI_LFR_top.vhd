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
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_1164.ALL;
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
LIBRARY lpp;
USE lpp.lpp_memory.ALL;
USE lpp.lpp_ad_conv.ALL;
USE lpp.lpp_lfr_pkg.ALL;
USE lpp.iir_filter.ALL;
USE lpp.general_purpose.ALL;
USE lpp.lpp_lfr_time_management.ALL;
USE lpp.lpp_leon3_soc_pkg.ALL;
USE lpp.lpp_debug_lfr_pkg.ALL;

ENTITY MINI_LFR_top IS
  
  PORT (
    clk_50 : IN  STD_LOGIC;
    clk_49 : IN  STD_LOGIC;
    reset  : IN  STD_LOGIC;
    --BPs
    BP0    : IN  STD_LOGIC;
    BP1    : IN  STD_LOGIC;
    --LEDs
    LED0   : OUT STD_LOGIC;
    LED1   : OUT STD_LOGIC;
    LED2   : OUT STD_LOGIC;
    --UARTs
    TXD1   : IN  STD_LOGIC;
    RXD1   : OUT STD_LOGIC;
    nCTS1  : OUT STD_LOGIC;          
    nRTS1  : IN  STD_LOGIC;          

    TXD2  : IN  STD_LOGIC;
    RXD2  : OUT STD_LOGIC;
    nCTS2 : OUT STD_LOGIC;           
    nDTR2 : IN  STD_LOGIC;           
    nRTS2 : IN  STD_LOGIC;           
    nDCD2 : OUT STD_LOGIC;           

    --EXT CONNECTOR
    IO0  : INOUT STD_LOGIC;
    IO1  : INOUT STD_LOGIC;
    IO2  : INOUT STD_LOGIC;
    IO3  : INOUT STD_LOGIC;
    IO4  : INOUT STD_LOGIC;
    IO5  : INOUT STD_LOGIC;
    IO6  : INOUT STD_LOGIC;
    IO7  : INOUT STD_LOGIC;
    IO8  : INOUT STD_LOGIC;
    IO9  : INOUT STD_LOGIC;
    IO10 : INOUT STD_LOGIC;
    IO11 : INOUT STD_LOGIC;

    --SPACE WIRE
    SPW_EN       : OUT STD_LOGIC;                     -- 0 => off
    SPW_NOM_DIN  : IN  STD_LOGIC;                     -- NOMINAL LINK
    SPW_NOM_SIN  : IN  STD_LOGIC;
    SPW_NOM_DOUT : OUT STD_LOGIC;
    SPW_NOM_SOUT : OUT STD_LOGIC;
    SPW_RED_DIN  : IN  STD_LOGIC;                     -- REDUNDANT LINK 
    SPW_RED_SIN  : IN  STD_LOGIC;
    SPW_RED_DOUT : OUT STD_LOGIC;
    SPW_RED_SOUT : OUT STD_LOGIC;
    -- MINI LFR ADC INPUTS
    ADC_nCS      : OUT STD_LOGIC;
    ADC_CLK      : OUT STD_LOGIC;
    ADC_SDO      : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); 

    -- SRAM
    SRAM_nWE : OUT   STD_LOGIC;
    SRAM_CE  : OUT   STD_LOGIC;
    SRAM_nOE : OUT   STD_LOGIC;
    SRAM_nBE : OUT   STD_LOGIC_VECTOR(3 DOWNTO 0);
    SRAM_A   : OUT   STD_LOGIC_VECTOR(19 DOWNTO 0);
    SRAM_DQ  : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );

END MINI_LFR_top;


ARCHITECTURE beh OF MINI_LFR_top IS
  SIGNAL clk_50_s : STD_LOGIC := '0';
  SIGNAL clk_25 : STD_LOGIC := '0';
  -----------------------------------------------------------------------------
  SIGNAL coarse_time  :  STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL fine_time    :  STD_LOGIC_VECTOR(15 DOWNTO 0);
  --
  SIGNAL errorn : STD_LOGIC;
  -- UART AHB ---------------------------------------------------------------
  SIGNAL  ahbrxd : STD_ULOGIC;            -- DSU rx data  
  SIGNAL  ahbtxd : STD_ULOGIC;            -- DSU tx data

  -- UART APB ---------------------------------------------------------------
  SIGNAL  urxd1 :  STD_ULOGIC;             -- UART1 rx data
  SIGNAL  utxd1 :  STD_ULOGIC;             -- UART1 tx data
                                           --
  SIGNAL I00_s : STD_LOGIC;
  --
  CONSTANT NB_APB_SLAVE  : INTEGER := 1;
  CONSTANT NB_AHB_SLAVE  : INTEGER := 1;
  CONSTANT NB_AHB_MASTER : INTEGER := 1;
  
  SIGNAL  apbi_ext    :  apb_slv_in_type;
  SIGNAL  apbo_ext    :  soc_apb_slv_out_vector(NB_APB_SLAVE-1+5  DOWNTO 5):= (OTHERS => apb_none);
  SIGNAL  ahbi_s_ext  :  ahb_slv_in_type;
  SIGNAL  ahbo_s_ext  :  soc_ahb_slv_out_vector(NB_AHB_SLAVE-1+3  DOWNTO 3):= (OTHERS => ahbs_none);
  SIGNAL  ahbi_m_ext  :  AHB_Mst_In_Type;
  SIGNAL  ahbo_m_ext  :  soc_ahb_mst_out_vector(NB_AHB_MASTER-1+1 DOWNTO 1):= (OTHERS => ahbm_none);
  --
  SIGNAL IO_s : STD_LOGIC_VECTOR(11 DOWNTO 0);
  
BEGIN  -- beh

  -----------------------------------------------------------------------------
  -- CLK
  -----------------------------------------------------------------------------

  PROCESS(clk_50)
  BEGIN
    IF clk_50'EVENT AND clk_50 = '1' THEN
      clk_50_s <= NOT clk_50_s;
    END IF;
  END PROCESS;
  
  PROCESS(clk_50_s)
  BEGIN
    IF clk_50_s'EVENT AND clk_50_s = '1' THEN
      clk_25 <= NOT clk_25;
    END IF;
  END PROCESS;

  -----------------------------------------------------------------------------
  
  PROCESS (clk_25, reset)
  BEGIN  -- PROCESS
    IF reset = '0' THEN                 -- asynchronous reset (active low)
      LED0 <= '0';
      LED1 <= '0';
      LED2 <= '0';
      IO1  <= '0';
      IO2  <= '1';  
      IO3  <= '0';
      IO4  <= '0';
      IO5  <= '0';
      IO6  <= '0';
      IO7  <= '0';
      IO8  <= '0';
      IO9  <= '0';
      IO10 <= '0';
      IO11 <= '0';
    ELSIF clk_25'event AND clk_25 = '1' THEN  -- rising clock edge
      LED0 <= '0';
      LED1 <= '1';
      LED2 <= BP0;
      IO1  <= '1';
      IO2  <= SPW_NOM_DIN OR SPW_NOM_SIN OR SPW_RED_DIN OR SPW_RED_SIN;  
      IO3  <= ADC_SDO(0) OR ADC_SDO(1);
      IO4  <= ADC_SDO(2) OR ADC_SDO(1);
      IO5  <= ADC_SDO(3) OR ADC_SDO(4);
      IO6  <= ADC_SDO(5) OR ADC_SDO(6) OR ADC_SDO(7);
      IO7  <= BP1 OR  nDTR2 OR nRTS2 OR nRTS1;
      IO8  <= IO_s(8);
      IO9  <= IO_s(9);
      IO10 <= IO_s(10);
      IO11 <= IO_s(11);
    END IF;
  END PROCESS;
  
  PROCESS (clk_49, reset)
  BEGIN  -- PROCESS
    IF reset = '0' THEN                 -- asynchronous reset (active low)
      I00_s  <= '0';            
    ELSIF clk_49'event AND clk_49 = '1' THEN  -- rising clock edge
        I00_s  <= NOT I00_s;
      END IF;
  END PROCESS;
  IO0 <= I00_s;

  --UARTs
  nCTS1  <= '1';
  nCTS2  <= '1';           
  nDCD2  <= '1';      

  --SPACE WIRE
  SPW_EN       <= '0';                     -- 0 => off

  SPW_NOM_DOUT <= '0';
  SPW_NOM_SOUT <= '0';
  SPW_RED_DOUT <= '0';
  SPW_RED_SOUT <= '0';
  
  ADC_nCS      <= '0';
  ADC_CLK      <= '0';

 
  -----------------------------------------------------------------------------
  lpp_debug_dma_singleOrBurst_1: lpp_debug_dma_singleOrBurst
    GENERIC MAP (
      tech   => apa3e,
      hindex => 1,
      pindex => 5,
      paddr  => 5,
      pmask  => 16#fff#)
    PORT MAP (
      HCLK    => clk_25,
      HRESETn => reset ,
      ahbmi   => ahbi_m_ext ,
      ahbmo   => ahbo_m_ext(1),
      apbi    => apbi_ext,
      apbo    => apbo_ext(5),
      out_ren           => IO_s(11),
      out_send          => IO_s(10),
      out_done          => IO_s(9),
      out_dmaout_okay   => IO_s(8)
      );
  
  -----------------------------------------------------------------------------

  leon3_soc_1: leon3_soc
    GENERIC MAP (
      fabtech         => apa3e,
      memtech         => apa3e,
      padtech         => inferred,
      clktech         => inferred,
      disas           => 0,
      dbguart         => 0,
      pclow           => 2,
      clk_freq        => 25000,
      NB_CPU          => 1,
      ENABLE_FPU      => 0,
      FPU_NETLIST     => 0,
      ENABLE_DSU      => 1,
      ENABLE_AHB_UART => 1,
      ENABLE_APB_UART => 1,
      ENABLE_IRQMP    => 1,
      ENABLE_GPT      => 1,
      NB_AHB_MASTER   => NB_AHB_MASTER,
      NB_AHB_SLAVE    => NB_AHB_SLAVE,
      NB_APB_SLAVE    =>  NB_APB_SLAVE)
    PORT MAP (
      clk        => clk_25,
      reset      => reset,
      errorn     => errorn,
      ahbrxd     => TXD1,
      ahbtxd     => RXD1,
      urxd1      => TXD2,
      utxd1      => RXD2,
      address    => SRAM_A,     
      data       => SRAM_DQ,    
      nSRAM_BE0  => SRAM_nBE(0),
      nSRAM_BE1  => SRAM_nBE(1),
      nSRAM_BE2  => SRAM_nBE(2),
      nSRAM_BE3  => SRAM_nBE(3),
      nSRAM_WE   => SRAM_nWE,   
      nSRAM_CE   => SRAM_CE,    
      nSRAM_OE   => SRAM_nOE,
      
      apbi_ext   => apbi_ext,
      apbo_ext   => apbo_ext,
      ahbi_s_ext => ahbi_s_ext,
      ahbo_s_ext => ahbo_s_ext,
      ahbi_m_ext => ahbi_m_ext,
      ahbo_m_ext => ahbo_m_ext);
  
END beh;
