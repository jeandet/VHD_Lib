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

ENTITY UT8ER1M32_test_board_top IS
  
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

    -- SRAM
    SRAM_nWE : OUT   STD_LOGIC;
    SRAM_nCE1  : OUT   STD_LOGIC;
    SRAM_nCE2  : OUT   STD_LOGIC;
    SRAM_nOE : OUT   STD_LOGIC;
    SRAM_MBE    : INOUT    STD_LOGIC;
    SRAM_nBUSY  : IN    STD_LOGIC;
    --SRAM_nSCRUB : IN    STD_LOGIC;
    SRAM_A   : OUT   STD_LOGIC_VECTOR(18 DOWNTO 0);
    SRAM_DQ  : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );

END UT8ER1M32_test_board_top;


ARCHITECTURE beh OF UT8ER1M32_test_board_top IS
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
  --SRAM-----------------------------------------------------------------------
  SIGNAL  SRAM_CE    :   STD_LOGIC_VECTOR(1 downto 0);
  
BEGIN  -- beh

  -----------------------------------------------------------------------------
  -- CLK
  -----------------------------------------------------------------------------

  
  PROCESS(clk_50)
  BEGIN
    IF clk_50'EVENT AND clk_50 = '1' THEN
      clk_25 <= NOT clk_25;
    END IF;
  END PROCESS;

  -----------------------------------------------------------------------------
  
  
  PROCESS (clk_49, reset)
  BEGIN  -- PROCESS
    IF reset = '0' THEN                 -- asynchronous reset (active low)
      I00_s  <= '0';            
    ELSIF clk_49'event AND clk_49 = '1' THEN  -- rising clock edge
        I00_s  <= NOT I00_s;
      END IF;
  END PROCESS;

  nCTS1  <= '1';

  SRAM_nCE1    <=  SRAM_CE(0);
  SRAM_nCE2    <=  SRAM_CE(1);



  leon3_soc_1 : leon3_soc
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
      NB_APB_SLAVE    => NB_APB_SLAVE,
      ADDRESS_SIZE    => 19,
      USES_IAP_MEMCTRLR => 1)
    PORT MAP (
      clk         => clk_25,
      reset       => reset,
      errorn      => errorn,
      ahbrxd      => TXD1,
      ahbtxd      => RXD1,
      urxd1       => TXD2,
      utxd1       => RXD2,
      address     => SRAM_A,     
      data        => SRAM_DQ,    
      nSRAM_BE0   => LED0,
      nSRAM_BE1   => LED1,
      nSRAM_BE2   => LED2,
      nSRAM_BE3   => open,
      nSRAM_WE    => SRAM_nWE,   
      nSRAM_CE    => SRAM_CE,    
      nSRAM_OE    => SRAM_nOE,
      nSRAM_READY => SRAM_nBUSY,
      SRAM_MBE    => SRAM_MBE,

      apbi_ext   => apbi_ext,
      apbo_ext   => apbo_ext,
      ahbi_s_ext => ahbi_s_ext,
      ahbo_s_ext => ahbo_s_ext,
      ahbi_m_ext => ahbi_m_ext,
      ahbo_m_ext => ahbo_m_ext);
  


END beh;