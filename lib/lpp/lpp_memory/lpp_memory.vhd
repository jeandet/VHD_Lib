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


--! Package contenant tous les programmes qui forment le composant intégré dans le léon 

package lpp_memory is

--===========================================================|
--================= FIFOW SRAM FIFOR ========================|
--===========================================================| 

component APB_FIFO is
  generic (
    pindex       : integer := 0;
    paddr        : integer := 0;
    pmask        : integer := 16#fff#;
    pirq         : integer := 0;
    abits        : integer := 8;
    Data_sz      : integer := 16;
    Addr_sz      : integer := 8;
    addr_max_int : integer := 256);
  port (
    clk          : in  std_logic;
    rst          : in  std_logic;
    apbi         : in  apb_slv_in_type;
    apbo         : out apb_slv_out_type
    );
end component;


component ApbDriver is
  generic (
    pindex       : integer := 0;
    paddr        : integer := 0;
    pmask        : integer := 16#fff#;
    pirq         : integer := 0;
    abits        : integer := 8;
    LPP_DEVICE   : integer;
    Data_sz      : integer := 16;
    Addr_sz      : integer := 8;    
    addr_max_int : integer := 256);
  port (
    clk          : in  std_logic;     
    rst          : in  std_logic;
    RZ : out std_logic;
    ReadEnable   : in std_logic;
    WriteEnable  : in std_logic;
    FlagEmpty    : in std_logic;
    FlagFull     : in std_logic;
    DataIn       : out std_logic_vector(Data_sz-1 downto 0);
    DataOut      : in std_logic_vector(Data_sz-1 downto 0);
    AddrIn       : in std_logic_vector(Addr_sz-1 downto 0);
    AddrOut      : in std_logic_vector(Addr_sz-1 downto 0);
    apbi         : in  apb_slv_in_type;
    apbo         : out apb_slv_out_type
    );
end component;


component Top_FIFO is
  generic(
    Data_sz      : integer := 16;
    Addr_sz      : integer := 8;    
    addr_max_int : integer := 256
    );
  port(
    clk,raz  : in std_logic;                             --! Horloge et reset general du composant
    flag_RE  : in std_logic;                             --! Flag, Demande la lecture de la mémoire
    flag_WR  : in std_logic;                             --! Flag, Demande l'écriture dans la mémoire
    Data_in  : in std_logic_vector(Data_sz-1 downto 0);  --! Data en entrée du composant
    Addr_RE  : out std_logic_vector(addr_sz-1 downto 0); --! Adresse d'écriture
    Addr_WR  : out std_logic_vector(addr_sz-1 downto 0); --! Adresse de lecture
    full     : out std_logic;                            --! Flag, Mémoire pleine
    empty    : out std_logic;                            --! Flag, Mémoire vide
    Data_out : out std_logic_vector(Data_sz-1 downto 0)  --! Data en sortie du composant
    );
end component;


component Fifo_Read is
  generic(
    Addr_sz      : integer := 8;
    addr_max_int : integer := 256);
  port(
    clk          : in std_logic;
    raz          : in std_logic;
    flag_RE      : in std_logic;
    Waddr        : in std_logic_vector(addr_sz-1 downto 0);
    empty        : out std_logic;
    Raddr        : out std_logic_vector(addr_sz-1 downto 0)
    );
end component;


component Fifo_Write is
  generic(
    Addr_sz      : integer := 8;
    addr_max_int : integer := 256);
  port(
    clk          : in std_logic;
    raz          : in std_logic;
    flag_WR      : in std_logic;
    Raddr        : in std_logic_vector(addr_sz-1 downto 0);
    full         : out std_logic;
    Waddr        : out std_logic_vector(addr_sz-1 downto 0)
    );
end component;


component Link_Reg is
  generic(Data_sz : integer := 16);
  port(
    clk,raz       : in std_logic;
    Data_one      : in std_logic_vector(Data_sz-1 downto 0);
    Data_two      : in std_logic_vector(Data_sz-1 downto 0);
    flag_RE       : in std_logic;
    flag_WR       : in std_logic;
    empty         : in std_logic;
    Data_out      : out std_logic_vector(Data_sz-1 downto 0)
    );
end component;

--===========================================================|
--===================== FIFOW SRAM ==========================|
--===========================================================|

component APB_FifoWrite is
  generic (
    pindex       : integer := 0;
    paddr        : integer := 0;
    pmask        : integer := 16#fff#;
    pirq         : integer := 0;
    abits        : integer := 8;
    Data_sz      : integer := 16;
    Addr_sz      : integer := 8;
    addr_max_int : integer := 256);
  port (
    clk          : in  std_logic;
    rst          : in  std_logic;
    apbi         : in  apb_slv_in_type;
    apbo         : out apb_slv_out_type
    );
end component;


component Top_FifoWrite is
  generic(
    Data_sz      : integer := 16;
    Addr_sz      : integer := 8;
    addr_max_int : integer := 256);
  port(
    clk          : in std_logic;
    raz          : in std_logic;
    flag_RE      : in std_logic;
    flag_WR      : in std_logic;
    Data_in      : in std_logic_vector(Data_sz-1 downto 0);
    Raddr        : in std_logic_vector(addr_sz-1 downto 0);
    full         : out std_logic;
    empty        : out std_logic;
    Waddr        : out std_logic_vector(addr_sz-1 downto 0);
    Data_out     : out std_logic_vector(Data_sz-1 downto 0)
    );
end component;

--===========================================================|
--===================== SRAM FIFOR ==========================|
--===========================================================|

component APB_FifoRead is
  generic (
    pindex       : integer := 0;
    paddr        : integer := 0;
    pmask        : integer := 16#fff#;
    pirq         : integer := 0;
    abits        : integer := 8;
    Data_sz      : integer := 16;
    Addr_sz      : integer := 8;
    addr_max_int : integer := 256);
  port (
    clk          : in  std_logic;
    rst          : in  std_logic;
    apbi         : in  apb_slv_in_type;
    apbo         : out apb_slv_out_type
    );
end component;


component Top_FifoRead is
  generic(
    Data_sz      : integer := 16;
    Addr_sz      : integer := 8;
    addr_max_int : integer := 256);
  port(
    clk          : in std_logic;
    raz          : in std_logic;
    flag_RE      : in std_logic;
    flag_WR      : in std_logic;
    Data_in      : in std_logic_vector(Data_sz-1 downto 0);
    Waddr        : in std_logic_vector(addr_sz-1 downto 0);
    full         : out std_logic;
    empty        : out std_logic;
    Raddr        : out std_logic_vector(addr_sz-1 downto 0);
    Data_out     : out std_logic_vector(Data_sz-1 downto 0)
    );
end component;

end;
