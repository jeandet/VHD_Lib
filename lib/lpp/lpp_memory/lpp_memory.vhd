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
library ieee;
use ieee.std_logic_1164.all;
library grlib;
use grlib.amba.all;
use std.textio.all;
library lpp;
use lpp.lpp_amba.all;
use lpp.iir_filter.all;
library gaisler;
use gaisler.misc.all;
use gaisler.memctrl.all;
library techmap;
use techmap.gencomp.all;

--! Package contenant tous les programmes qui forment le composant intégré dans le léon 

package lpp_memory is

component APB_FIFO is
generic (
    tech         : integer := apa3;
    pindex       : integer := 0;
    paddr        : integer := 0;
    pmask        : integer := 16#fff#;
    pirq         : integer := 0;
    abits        : integer := 8;
    FifoCnt      : integer := 2;
    Data_sz      : integer := 16;
    Addr_sz        : integer := 9;
    Enable_ReUse   : std_logic := '0';
    Mem_use        : integer := use_RAM;
    R            : integer := 1;
    W            : integer := 1
    );
  port (
    clk          : in  std_logic;                              --! Horloge du composant
    rst          : in  std_logic;                              --! Reset general du composant
    rclk         : in  std_logic; 
    wclk         : in  std_logic;
    ReUse        : in  std_logic_vector(FifoCnt-1 downto 0);
    REN          : in std_logic_vector(FifoCnt-1 downto 0);   --! Instruction de lecture en mémoire
    WEN          : in std_logic_vector(FifoCnt-1 downto 0);   --! Instruction d'écriture en mémoire
    Empty        : out std_logic_vector(FifoCnt-1 downto 0);    --! Flag, Mémoire vide
    Full         : out std_logic_vector(FifoCnt-1 downto 0);    --! Flag, Mémoire pleine
    RDATA        : out std_logic_vector((FifoCnt*Data_sz)-1 downto 0);   --! Registre de données en entrée
    WDATA        : in std_logic_vector((FifoCnt*Data_sz)-1 downto 0);    --! Registre de données en sortie
    WADDR        : out std_logic_vector((FifoCnt*Addr_sz)-1 downto 0);    --! Registre d'addresse (écriture)
    RADDR        : out std_logic_vector((FifoCnt*Addr_sz)-1 downto 0);    --! Registre d'addresse (lecture)
    apbi         : in  apb_slv_in_type;                        --! Registre de gestion des entrées du bus
    apbo         : out apb_slv_out_type                        --! Registre de gestion des sorties du bus
    );
end component;

component FIFO_pipeline is
generic(
    tech          :   integer := 0;
    Mem_use       :   integer := use_RAM;
    fifoCount     :   integer range 2 to 32 := 8;
    DataSz        :   integer range 1 to 32 := 8;
    abits         :   integer range 2 to 12 := 8
    );
port(
    rstn    :   in std_logic;
    ReUse   :   in std_logic;
    rclk    :   in std_logic;
    ren     :   in std_logic;
    rdata   :   out std_logic_vector(DataSz-1 downto 0);
    empty   :   out std_logic;
    raddr   :   out std_logic_vector(abits-1 downto 0);
    wclk    :   in std_logic;
    wen     :   in std_logic;
    wdata   :   in std_logic_vector(DataSz-1 downto 0);
    full    :   out std_logic;
    waddr   :   out std_logic_vector(abits-1 downto 0)
);
end component;

component lpp_fifo is
generic(
    tech          :   integer := 0;
    Mem_use       :   integer := use_RAM;
    Enable_ReUse  :   std_logic := '0';
    DataSz        :   integer range 1 to 32 := 8;
    abits         :   integer range 2 to 12 := 8
    );
port(
    rstn    :   in std_logic;
    ReUse   :   in std_logic;   --27/01/12
    rclk    :   in std_logic;
    ren     :   in std_logic;
    rdata   :   out std_logic_vector(DataSz-1 downto 0);
    empty   :   out std_logic;
    raddr   :   out std_logic_vector(abits-1 downto 0);
    wclk    :   in std_logic;
    wen     :   in std_logic;
    wdata   :   in std_logic_vector(DataSz-1 downto 0);
    full    :   out std_logic;
    waddr   :   out std_logic_vector(abits-1 downto 0)
);
end component;


component lppFIFOxN is
generic(
    tech          :   integer := 0;
    Mem_use       :   integer := use_RAM;
    Data_sz       :   integer range 1 to 32 := 8;
    Addr_sz       :   integer range 1 to 32 := 8;
    FifoCnt : integer := 1;
    Enable_ReUse  :   std_logic := '0'
    );
port(
    rst     :   in std_logic;
    wclk    :   in std_logic;    
    rclk    :   in std_logic;
    ReUse   :   in std_logic_vector(FifoCnt-1 downto 0);
    wen     :   in std_logic_vector(FifoCnt-1 downto 0);
    ren     :   in std_logic_vector(FifoCnt-1 downto 0);
    wdata   :   in std_logic_vector((FifoCnt*Data_sz)-1 downto 0);
    rdata   :   out std_logic_vector((FifoCnt*Data_sz)-1 downto 0);
    full    :   out std_logic_vector(FifoCnt-1 downto 0);
    empty   :   out std_logic_vector(FifoCnt-1 downto 0)
);
end component;

component FillFifo is
generic(
    Data_sz  : integer range 1 to 32 := 16;
    Fifo_cnt : integer range 1 to 8 := 5
    );
port(
    clk         : in std_logic;
    raz        : in std_logic;
    write : out std_logic_vector(Fifo_cnt-1 downto 0);
    reuse : out std_logic_vector(Fifo_cnt-1 downto 0);
    data : out std_logic_vector(Fifo_cnt*Data_sz-1 downto 0)
);
end component;

component ssram_plugin is
generic (tech : integer := 0);
port
(
    clk             : in  std_logic;
    mem_ctrlr_o     : in  memory_out_type;
    SSRAM_CLK       : out std_logic;
    nBWa            : out std_logic;
    nBWb            : out std_logic;
    nBWc            : out std_logic;
    nBWd            : out std_logic;
    nBWE            : out std_logic;
    nADSC           : out std_logic;
    nADSP           : out std_logic;
    nADV            : out std_logic;
    nGW             : out std_logic;
    nCE1            : out std_logic;
    CE2             : out std_logic;
    nCE3            : out std_logic;
    nOE             : out std_logic;
    MODE            : out std_logic;
    ZZ              : out std_logic
);
end component;

end;
