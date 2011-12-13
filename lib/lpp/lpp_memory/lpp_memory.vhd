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

--! Package contenant tous les programmes qui forment le composant int�gr� dans le l�on 

package lpp_memory is

--===========================================================|
--=================== FIFO Compl�te =========================|
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
    Full    : out std_logic;
    Empty   : out std_logic;
    WR : out std_logic;
    RE : out std_logic;
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
    ReadEnable   : out std_logic;
    WriteEnable  : out std_logic;
    FlagEmpty    : in std_logic;
    FlagFull     : in std_logic;
--    ReUse        : out std_logic;
--    Lock         : out std_logic;
    RstMem       : out std_logic;
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
    clk,raz  : in std_logic;
    flag_RE  : in std_logic;
    flag_WR  : in std_logic;
--    ReUse    : in std_logic;
--    Lock     : in std_logic;
    RstMem   : in std_logic;
    Data_in  : in std_logic_vector(Data_sz-1 downto 0);
    Addr_RE  : out std_logic_vector(addr_sz-1 downto 0);
    Addr_WR  : out std_logic_vector(addr_sz-1 downto 0);
    full     : out std_logic;
    empty    : out std_logic;
    Data_out : out std_logic_vector(Data_sz-1 downto 0)
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


component PipeLine is
  generic(Data_sz : integer := 16);
  port(
    clk,raz  : in std_logic;                             --! Horloge et reset general du composant
    Data_in  : in std_logic_vector(Data_sz-1 downto 0);  --! Donn�e en entr�e de la FIFO, cot� �criture
    flag_RE  : in std_logic;                             --! Flag, Demande la lecture de la m�moire
    flag_WR  : in std_logic;                             --! Flag, Demande l'�criture dans la m�moire
    empty    : in std_logic;                             --! Flag, M�moire vide
    Data_svg : out std_logic_vector(Data_sz-1 downto 0);
    Data1 : out std_logic;
    Data2 : out std_logic
    );
end component;


component LocalReset is
    port(
        clk         : in  std_logic;
        raz         : in std_logic;
        Rz          : in  std_logic;
        rstf        : out  std_logic        
    );
end component;
--===========================================================|
--================= Demi FIFO Ecriture ======================|
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
    ReadEnable   : in  std_logic;
    Empty        : out std_logic;
    Full         : out std_logic;
    DATA         : out std_logic_vector(Data_sz-1 downto 0);
    apbo         : out apb_slv_out_type
    );
end component;


--component Top_FifoWrite is
--  generic(
--    Data_sz      : integer := 16;
--    Addr_sz      : integer := 8;
--    addr_max_int : integer := 256);
--  port(
--    clk          : in std_logic;
--    raz          : in std_logic;
--    flag_RE      : in std_logic;
--    flag_WR      : in std_logic;
--    Data_in      : in std_logic_vector(Data_sz-1 downto 0);
--    Raddr        : in std_logic_vector(addr_sz-1 downto 0);
--    full         : out std_logic;
--    empty        : out std_logic;
--    Waddr        : out std_logic_vector(addr_sz-1 downto 0);
--    Data_out     : out std_logic_vector(Data_sz-1 downto 0)
--    );
--end component;

--===========================================================|
--================== Demi FIFO Lecture ======================|
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
    WriteEnable  : in std_logic;
    RE           : out std_logic;
    Full         : out std_logic;
    Empty        : out std_logic;
    DATA         : in std_logic_vector(Data_sz-1 downto 0);
    dataTEST : out std_logic_vector(Data_sz-1 downto 0);
    apbo         : out apb_slv_out_type
    );
end component;


--component Top_FifoRead is
--  generic(
--    Data_sz      : integer := 16;
--    Addr_sz      : integer := 8;
--    addr_max_int : integer := 256);
--  port(
--    clk          : in std_logic;
--    raz          : in std_logic;
--    flag_RE      : in std_logic;
--    flag_WR      : in std_logic;
--    Data_in      : in std_logic_vector(Data_sz-1 downto 0);
--    Waddr        : in std_logic_vector(addr_sz-1 downto 0);
--    full         : out std_logic;
--    empty        : out std_logic;
--    Raddr        : out std_logic_vector(addr_sz-1 downto 0);
--    Data_out     : out std_logic_vector(Data_sz-1 downto 0)
--    );
--end component;

end;
