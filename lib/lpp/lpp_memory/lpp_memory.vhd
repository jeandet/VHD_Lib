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
------------------------------------------------------------------------------
--                    Author : Martin Morlot
--                     Mail : martin.morlot@lpp.polytechnique.fr
------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
LIBRARY grlib;
USE grlib.amba.ALL;
USE std.textio.ALL;
LIBRARY lpp;
USE lpp.lpp_amba.ALL;
USE lpp.iir_filter.ALL;
LIBRARY gaisler;
USE gaisler.misc.ALL;
USE gaisler.memctrl.ALL;
LIBRARY techmap;
USE techmap.gencomp.ALL;

--! Package contenant tous les programmes qui forment le composant intégré dans le léon 

PACKAGE lpp_memory IS

  COMPONENT lpp_fifo
    GENERIC (
      tech                  : INTEGER;
      Mem_use               : INTEGER;
      EMPTY_THRESHOLD_LIMIT : INTEGER;
      FULL_THRESHOLD_LIMIT  : INTEGER;
      DataSz                : INTEGER RANGE 1 TO 32;
      AddrSz                : INTEGER RANGE 2 TO 12);
    PORT (
      clk             : IN  STD_LOGIC;
      rstn            : IN  STD_LOGIC;
      reUse           : IN  STD_LOGIC;
      run             : IN  STD_LOGIC;
      ren             : IN  STD_LOGIC;
      rdata           : OUT STD_LOGIC_VECTOR(DataSz-1 DOWNTO 0);
      wen             : IN  STD_LOGIC;
      wdata           : IN  STD_LOGIC_VECTOR(DataSz-1 DOWNTO 0);
      empty           : OUT STD_LOGIC;
      full            : OUT STD_LOGIC;
      full_almost     : OUT STD_LOGIC;
      empty_threshold : OUT STD_LOGIC;
      full_threshold  : OUT STD_LOGIC);
  END COMPONENT;

  COMPONENT lpp_fifo_4_shared
    GENERIC (
      tech                  : INTEGER;
      Mem_use               : INTEGER;
      EMPTY_THRESHOLD_LIMIT : INTEGER;
      FULL_THRESHOLD_LIMIT  : INTEGER;
      DataSz                : INTEGER RANGE 1 TO 32;
      AddrSz                : INTEGER RANGE 3 TO 12);
    PORT (
      clk             : IN  STD_LOGIC;
      rstn            : IN  STD_LOGIC;
      run             : IN  STD_LOGIC;
      empty_threshold : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      empty           : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      r_en            : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      r_data          : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      full_threshold  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      full_almost     : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      full            : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      w_en            : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      w_data          : IN  STD_LOGIC_VECTOR(31 DOWNTO 0));
  END COMPONENT;

  COMPONENT lpp_fifo_4_shared_headreg_latency_0
    PORT (
      clk            : IN  STD_LOGIC;
      rstn           : IN  STD_LOGIC;
      run            : IN  STD_LOGIC;
      o_empty_almost : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      o_empty        : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      o_data_ren     : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      o_rdata_0      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      o_rdata_1      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      o_rdata_2      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      o_rdata_3      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      i_empty_almost : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      i_empty        : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      i_data_ren     : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      i_rdata        : IN  STD_LOGIC_VECTOR(31 DOWNTO 0));
  END COMPONENT;

  COMPONENT lpp_fifo_4_shared_headreg_latency_1
    PORT (
      clk            : IN  STD_LOGIC;
      rstn           : IN  STD_LOGIC;
      run            : IN  STD_LOGIC;
      o_empty_almost : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      o_empty        : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      o_data_ren     : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      o_rdata_0      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      o_rdata_1      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      o_rdata_2      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      o_rdata_3      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      i_empty_almost : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      i_empty        : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      i_data_ren     : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      i_rdata        : IN  STD_LOGIC_VECTOR(31 DOWNTO 0));
  END COMPONENT;

  COMPONENT lpp_fifo_control
    GENERIC (
      AddrSz                : INTEGER RANGE 2 TO 12;
      EMPTY_THRESHOLD_LIMIT : INTEGER;
      FULL_THRESHOLD_LIMIT  : INTEGER);
    PORT (
      clk             : IN  STD_LOGIC;
      rstn            : IN  STD_LOGIC;
      reUse           : IN  STD_LOGIC;
      run             : IN  STD_LOGIC;
      fifo_r_en       : IN  STD_LOGIC;
      fifo_w_en       : IN  STD_LOGIC;
      mem_r_en        : OUT STD_LOGIC;
      mem_w_en        : OUT STD_LOGIC;
      mem_r_addr      : OUT STD_LOGIC_VECTOR(AddrSz -1 DOWNTO 0);
      mem_w_addr      : OUT STD_LOGIC_VECTOR(AddrSz -1 DOWNTO 0);
      empty           : OUT STD_LOGIC;
      full            : OUT STD_LOGIC;
      full_almost     : OUT STD_LOGIC;
      empty_threshold : OUT STD_LOGIC;
      full_threshold  : OUT STD_LOGIC);
  END COMPONENT;

  COMPONENT lppFIFOxN
    GENERIC (
      tech    : INTEGER;
      Mem_use : INTEGER;
      Data_sz : INTEGER RANGE 1 TO 32;
      Addr_sz : INTEGER RANGE 2 TO 12;
      FifoCnt : INTEGER);
    PORT (
      clk         : IN  STD_LOGIC;
      rstn        : IN  STD_LOGIC;
      ReUse       : IN  STD_LOGIC_VECTOR(FifoCnt-1 DOWNTO 0);
      run         : IN  STD_LOGIC_VECTOR(FifoCnt-1 DOWNTO 0);
      wen         : IN  STD_LOGIC_VECTOR(FifoCnt-1 DOWNTO 0);
      wdata       : IN  STD_LOGIC_VECTOR((FifoCnt*Data_sz)-1 DOWNTO 0);
      ren         : IN  STD_LOGIC_VECTOR(FifoCnt-1 DOWNTO 0);
      rdata       : OUT STD_LOGIC_VECTOR((FifoCnt*Data_sz)-1 DOWNTO 0);
      empty       : OUT STD_LOGIC_VECTOR(FifoCnt-1 DOWNTO 0);
      full        : OUT STD_LOGIC_VECTOR(FifoCnt-1 DOWNTO 0);
      almost_full : OUT STD_LOGIC_VECTOR(FifoCnt-1 DOWNTO 0));
  END COMPONENT;


  

  COMPONENT APB_FIFO IS
    GENERIC (
      tech         : INTEGER   := apa3;
      pindex       : INTEGER   := 0;
      paddr        : INTEGER   := 0;
      pmask        : INTEGER   := 16#fff#;
      pirq         : INTEGER   := 0;
      abits        : INTEGER   := 8;
      FifoCnt      : INTEGER   := 2;
      Data_sz      : INTEGER   := 16;
      Addr_sz      : INTEGER   := 9;
      Enable_ReUse : STD_LOGIC := '0';
      Mem_use      : INTEGER   := use_RAM;
      R            : INTEGER   := 1;
      W            : INTEGER   := 1
      );
    PORT (
      clk   : IN  STD_LOGIC;            --! Horloge du composant
      rst   : IN  STD_LOGIC;            --! Reset general du composant
      rclk  : IN  STD_LOGIC;
      wclk  : IN  STD_LOGIC;
      ReUse : IN  STD_LOGIC_VECTOR(FifoCnt-1 DOWNTO 0);
      REN   : IN  STD_LOGIC_VECTOR(FifoCnt-1 DOWNTO 0);  --! Instruction de lecture en mémoire
      WEN   : IN  STD_LOGIC_VECTOR(FifoCnt-1 DOWNTO 0);  --! Instruction d'écriture en mémoire
      Empty : OUT STD_LOGIC_VECTOR(FifoCnt-1 DOWNTO 0);  --! Flag, Mémoire vide
      Full  : OUT STD_LOGIC_VECTOR(FifoCnt-1 DOWNTO 0);  --! Flag, Mémoire pleine
      RDATA : OUT STD_LOGIC_VECTOR((FifoCnt*Data_sz)-1 DOWNTO 0);  --! Registre de données en entrée
      WDATA : IN  STD_LOGIC_VECTOR((FifoCnt*Data_sz)-1 DOWNTO 0);  --! Registre de données en sortie
      WADDR : OUT STD_LOGIC_VECTOR((FifoCnt*Addr_sz)-1 DOWNTO 0);  --! Registre d'addresse (écriture)
      RADDR : OUT STD_LOGIC_VECTOR((FifoCnt*Addr_sz)-1 DOWNTO 0);  --! Registre d'addresse (lecture)
      apbi  : IN  apb_slv_in_type;  --! Registre de gestion des entrées du bus
      apbo  : OUT apb_slv_out_type  --! Registre de gestion des sorties du bus
      );
  END COMPONENT;

  COMPONENT FIFO_pipeline IS
    GENERIC(
      tech      : INTEGER               := 0;
      Mem_use   : INTEGER               := use_RAM;
      fifoCount : INTEGER RANGE 2 TO 32 := 8;
      DataSz    : INTEGER RANGE 1 TO 32 := 8;
      abits     : INTEGER RANGE 2 TO 12 := 8
      );
    PORT(
      rstn  : IN  STD_LOGIC;
      ReUse : IN  STD_LOGIC;
      rclk  : IN  STD_LOGIC;
      ren   : IN  STD_LOGIC;
      rdata : OUT STD_LOGIC_VECTOR(DataSz-1 DOWNTO 0);
      empty : OUT STD_LOGIC;
      raddr : OUT STD_LOGIC_VECTOR(abits-1 DOWNTO 0);
      wclk  : IN  STD_LOGIC;
      wen   : IN  STD_LOGIC;
      wdata : IN  STD_LOGIC_VECTOR(DataSz-1 DOWNTO 0);
      full  : OUT STD_LOGIC;
      waddr : OUT STD_LOGIC_VECTOR(abits-1 DOWNTO 0)
      );
  END COMPONENT;

  COMPONENT FillFifo IS
    GENERIC(
      Data_sz  : INTEGER RANGE 1 TO 32 := 16;
      Fifo_cnt : INTEGER RANGE 1 TO 8  := 5
      );
    PORT(
      clk   : IN  STD_LOGIC;
      raz   : IN  STD_LOGIC;
      write : OUT STD_LOGIC_VECTOR(Fifo_cnt-1 DOWNTO 0);
      reuse : OUT STD_LOGIC_VECTOR(Fifo_cnt-1 DOWNTO 0);
      data  : OUT STD_LOGIC_VECTOR(Fifo_cnt*Data_sz-1 DOWNTO 0)
      );
  END COMPONENT;

  COMPONENT Bridge IS
    PORT(
      clk      : IN  STD_LOGIC;
      raz      : IN  STD_LOGIC;
      EmptyUp  : IN  STD_LOGIC;
      FullDwn  : IN  STD_LOGIC;
      WriteDwn : OUT STD_LOGIC;
      ReadUp   : OUT STD_LOGIC
      );
  END COMPONENT;

  COMPONENT ssram_plugin IS
    GENERIC (tech : INTEGER := 0);
    PORT
      (
        clk         : IN  STD_LOGIC;
        mem_ctrlr_o : IN  memory_out_type;
        SSRAM_CLK   : OUT STD_LOGIC;
        nBWa        : OUT STD_LOGIC;
        nBWb        : OUT STD_LOGIC;
        nBWc        : OUT STD_LOGIC;
        nBWd        : OUT STD_LOGIC;
        nBWE        : OUT STD_LOGIC;
        nADSC       : OUT STD_LOGIC;
        nADSP       : OUT STD_LOGIC;
        nADV        : OUT STD_LOGIC;
        nGW         : OUT STD_LOGIC;
        nCE1        : OUT STD_LOGIC;
        CE2         : OUT STD_LOGIC;
        nCE3        : OUT STD_LOGIC;
        nOE         : OUT STD_LOGIC;
        MODE        : OUT STD_LOGIC;
        ZZ          : OUT STD_LOGIC
        );
  END COMPONENT;

END;
