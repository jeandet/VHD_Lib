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
USE work.config.ALL;
LIBRARY lpp;
USE lpp.lpp_memory.ALL;
USE lpp.lpp_ad_conv.ALL;
USE lpp.lpp_lfr_pkg.ALL;
USE lpp.iir_filter.ALL;
USE lpp.general_purpose.ALL;
USE lpp.lpp_lfr_time_management.ALL;

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

  COMPONENT leon3_soc
    GENERIC (
      fabtech : INTEGER;
      memtech : INTEGER;
      padtech : INTEGER;
      clktech : INTEGER;
      disas   : INTEGER;
      dbguart : INTEGER;
      pclow   : INTEGER);
    PORT (
      clk100MHz    : IN    STD_ULOGIC;
      clk49_152MHz : IN    STD_ULOGIC;
      reset        : IN    STD_ULOGIC;
      errorn       : OUT   STD_ULOGIC;
      ahbrxd       : IN    STD_ULOGIC;
      ahbtxd       : OUT   STD_ULOGIC;
      urxd1        : IN    STD_ULOGIC;
      utxd1        : OUT   STD_ULOGIC;
      address      : OUT   STD_LOGIC_VECTOR(19 DOWNTO 0);
      data         : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      nSRAM_BE0    : OUT   STD_LOGIC;
      nSRAM_BE1    : OUT   STD_LOGIC;
      nSRAM_BE2    : OUT   STD_LOGIC;
      nSRAM_BE3    : OUT   STD_LOGIC;
      nSRAM_WE     : OUT   STD_LOGIC;
      nSRAM_CE     : OUT   STD_LOGIC;
      nSRAM_OE     : OUT   STD_LOGIC;
      spw1_din     : IN    STD_LOGIC;
      spw1_sin     : IN    STD_LOGIC;
      spw1_dout    : OUT   STD_LOGIC;
      spw1_sout    : OUT   STD_LOGIC;
      spw2_din     : IN    STD_LOGIC;
      spw2_sin     : IN    STD_LOGIC;
      spw2_dout    : OUT   STD_LOGIC;
      spw2_sout    : OUT   STD_LOGIC;
      apbi_wfp     : OUT   apb_slv_in_type;
      apbo_wfp     : IN    apb_slv_out_type;
      ahbi_wfp     : OUT   AHB_Mst_In_Type;
      ahbo_wfp     : IN    AHB_Mst_Out_Type;
      coarse_time  : OUT   STD_LOGIC_VECTOR(31 DOWNTO 0);
      fine_time    : OUT   STD_LOGIC_VECTOR(15 DOWNTO 0));
  END COMPONENT;
  
BEGIN  -- beh

  PROCESS (clk_50, reset)
  BEGIN  -- PROCESS
    IF reset = '0' THEN                 -- asynchronous reset (active low)
      LED0 <= '0';
      LED1 <= '0';
      LED2 <= '0';
    ELSIF clk_50'event AND clk_50 = '1' THEN  -- rising clock edge
      LED0 <= '0';
      LED1 <= '1';
      LED2 <= BP0;
    END IF;
  END PROCESS;
  
  --UARTs
  RXD1   <= '0';
  nCTS1  <= '0';        
  RXD2   <= '0';
  nCTS2  <= '0';           
  nDCD2  <= '0';      

  --EXT CONNECTOR
  IO0  <= clk_49;
  IO1  <= clk_50;
  
  IO2 <= SPW_NOM_DIN OR
         SPW_NOM_SIN OR
         SPW_RED_DIN OR
         SPW_RED_SIN;
  
  IO3  <= ADC_SDO(0);
  IO4  <= ADC_SDO(1);
  IO5  <= ADC_SDO(2);
  IO6  <= ADC_SDO(3);
  IO7  <= ADC_SDO(4);
  IO8  <= ADC_SDO(5);
  IO9  <= ADC_SDO(6);
  IO10 <= ADC_SDO(7);
  IO11  <= BP1 OR TXD1 OR TXD2 OR nDTR2 OR nRTS2 OR nRTS1;

  --SPACE WIRE
  SPW_EN       <= '0';                     -- 0 => off
  SPW_NOM_DOUT <= '0';
  SPW_NOM_SOUT <= '0';
  SPW_RED_DOUT <= '0';
  SPW_RED_SOUT <= '0';
  ADC_nCS      <= '0';
  ADC_CLK      <= '0';
  
  -- SRAM
  SRAM_nWE <= '1';
  SRAM_CE  <= '0';
  SRAM_nOE <= '1';
  SRAM_nBE <= (OTHERS => '1');
  SRAM_A   <= (OTHERS => '0');
  SRAM_DQ  <= (OTHERS => '0');


  leon3mp_1: leon3_soc
    GENERIC MAP (
      fabtech => fabtech,
      memtech => memtech,
      padtech => padtech,
      clktech => clktech,
      disas   => disas,
      dbguart => dbguart,
      pclow   => pclow)
    PORT MAP (
      clk100MHz    => clk100MHz,
      clk49_152MHz => clk49_152MHz,
      reset        => reset,
      errorn       => errorn,
      ahbrxd       => ahbrxd,
      ahbtxd       => ahbtxd,
      urxd1        => urxd1,
      utxd1        => utxd1,
      address      => address,
      data         => data,
      nSRAM_BE0    => nSRAM_BE0,
      nSRAM_BE1    => nSRAM_BE1,
      nSRAM_BE2    => nSRAM_BE2,
      nSRAM_BE3    => nSRAM_BE3,
      nSRAM_WE     => nSRAM_WE,
      nSRAM_CE     => nSRAM_CE,
      nSRAM_OE     => nSRAM_OE,
      spw1_din     => spw1_din,
      spw1_sin     => spw1_sin,
      spw1_dout    => spw1_dout,
      spw1_sout    => spw1_sout,
      spw2_din     => spw2_din,
      spw2_sin     => spw2_sin,
      spw2_dout    => spw2_dout,
      spw2_sout    => spw2_sout,
      apbi_wfp     => apbi_wfp,
      apbo_wfp     => apbo_wfp,
      ahbi_wfp     => ahbi_wfp,
      ahbo_wfp     => ahbo_wfp,
      coarse_time  => coarse_time,
      fine_time    => fine_time);
  

END beh;
