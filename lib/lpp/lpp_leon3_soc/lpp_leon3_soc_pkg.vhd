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
-- Author : Jean-christophe Pellion
-- Mail   : jean-christophe.pellion@lpp.polytechnique.fr
--          jean-christophe.pellion@easii-ic.com
----------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
LIBRARY grlib;
USE grlib.amba.ALL;

PACKAGE lpp_leon3_soc_pkg IS

  type soc_ahb_mst_out_vector is array (natural range <>) of ahb_mst_out_type;
  type soc_ahb_slv_out_vector is array (natural range <>) of ahb_slv_out_type;
  type soc_apb_slv_out_vector is array (natural range <>) of apb_slv_out_type;  

  COMPONENT leon3_soc
    GENERIC (
      fabtech         : INTEGER;
      memtech         : INTEGER;
      padtech         : INTEGER;
      clktech         : INTEGER;
      disas           : INTEGER;
      dbguart         : INTEGER;
      pclow           : INTEGER;
      clk_freq        : INTEGER;
      NB_CPU          : INTEGER;
      ENABLE_FPU      : INTEGER;
      FPU_NETLIST     : INTEGER;
      ENABLE_DSU      : INTEGER;
      ENABLE_AHB_UART : INTEGER;
      ENABLE_APB_UART : INTEGER;
      ENABLE_IRQMP    : INTEGER;
      ENABLE_GPT      : INTEGER;
      NB_AHB_MASTER   : INTEGER;
      NB_AHB_SLAVE    : INTEGER;
      NB_APB_SLAVE    : INTEGER;
      ADDRESS_SIZE    : INTEGER;
      USES_IAP_MEMCTRLR : INTEGER
    );
  PORT (
    clk    : IN STD_ULOGIC;
    reset  : IN STD_ULOGIC;

    errorn : OUT STD_ULOGIC;

    -- UART AHB ---------------------------------------------------------------
    ahbrxd : IN  STD_ULOGIC;            -- DSU rx data  
    ahbtxd : OUT STD_ULOGIC;            -- DSU tx data

    -- UART APB ---------------------------------------------------------------
    urxd1 : IN  STD_ULOGIC;             -- UART1 rx data
    utxd1 : OUT STD_ULOGIC;             -- UART1 tx data    

    -- RAM --------------------------------------------------------------------
    address     : OUT   STD_LOGIC_VECTOR(ADDRESS_SIZE-1 DOWNTO 0);
    data        : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    nSRAM_BE0   : OUT   STD_LOGIC;
    nSRAM_BE1   : OUT   STD_LOGIC;
    nSRAM_BE2   : OUT   STD_LOGIC;
    nSRAM_BE3   : OUT   STD_LOGIC;
    nSRAM_WE    : OUT   STD_LOGIC;
    nSRAM_CE    : OUT   STD_LOGIC_VECTOR(1 downto 0);
    nSRAM_OE    : OUT   STD_LOGIC;
    nSRAM_READY : IN    STD_LOGIC;
    SRAM_MBE    : INOUT STD_LOGIC;
    -- APB --------------------------------------------------------------------
    apbi_ext    : OUT apb_slv_in_type;
    apbo_ext    : IN  soc_apb_slv_out_vector(NB_APB_SLAVE-1+5  DOWNTO 5);
    -- AHB_Slave --------------------------------------------------------------
    ahbi_s_ext  : OUT ahb_slv_in_type;
    ahbo_s_ext  : IN  soc_ahb_slv_out_vector(NB_AHB_SLAVE-1+3  DOWNTO 3);
    -- AHB_Master -------------------------------------------------------------
    ahbi_m_ext  : OUT AHB_Mst_In_Type;
    ahbo_m_ext  : IN  soc_ahb_mst_out_vector(NB_AHB_MASTER-1+NB_CPU DOWNTO NB_CPU));
  END COMPONENT;
   

  COMPONENT leon3ft_soc
    GENERIC (
      fabtech         : INTEGER;
      memtech         : INTEGER;
      padtech         : INTEGER;
      clktech         : INTEGER;
      disas           : INTEGER;
      dbguart         : INTEGER;
      pclow           : INTEGER;
      clk_freq        : INTEGER;
      NB_CPU          : INTEGER;
      ENABLE_FPU      : INTEGER;
      FPU_NETLIST     : INTEGER;
      ENABLE_DSU      : INTEGER;
      ENABLE_AHB_UART : INTEGER;
      ENABLE_APB_UART : INTEGER;
      ENABLE_IRQMP    : INTEGER;
      ENABLE_GPT      : INTEGER;
      NB_AHB_MASTER   : INTEGER;
      NB_AHB_SLAVE    : INTEGER;
      NB_APB_SLAVE    : INTEGER);
    PORT (
      clk        : IN    STD_ULOGIC;
      reset      : IN    STD_ULOGIC;
      errorn     : OUT   STD_ULOGIC;
      ahbrxd     : IN    STD_ULOGIC;
      ahbtxd     : OUT   STD_ULOGIC;
      urxd1      : IN    STD_ULOGIC;
      utxd1      : OUT   STD_ULOGIC;
      address    : OUT   STD_LOGIC_VECTOR(19 DOWNTO 0);
      data       : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      nSRAM_BE0  : OUT   STD_LOGIC;
      nSRAM_BE1  : OUT   STD_LOGIC;
      nSRAM_BE2  : OUT   STD_LOGIC;
      nSRAM_BE3  : OUT   STD_LOGIC;
      nSRAM_WE   : OUT   STD_LOGIC;
      nSRAM_CE   : OUT   STD_LOGIC;
      nSRAM_OE   : OUT   STD_LOGIC;
      apbi_ext   : OUT   apb_slv_in_type;
      apbo_ext   : IN    soc_apb_slv_out_vector(NB_APB_SLAVE-1+5 DOWNTO 5);
      ahbi_s_ext : OUT   ahb_slv_in_type;
      ahbo_s_ext : IN    soc_ahb_slv_out_vector(NB_AHB_SLAVE-1+3 DOWNTO 3);
      ahbi_m_ext : OUT   AHB_Mst_In_Type;
      ahbo_m_ext : IN    soc_ahb_mst_out_vector(NB_AHB_MASTER-1+NB_CPU DOWNTO NB_CPU));
  END COMPONENT;
  
END;