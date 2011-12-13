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
--                        Author : Martin Morlot
--                     Mail : martin.morlot@lpp.polytechnique.fr
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;
library lpp;
use lpp.lpp_amba.all;
use lpp.apb_devices_list.all;
use lpp.lpp_memory.all;

--! Driver APB, va faire le lien entre l'IP VHDL de la FIFO et le bus Amba

entity APB_FIFO is
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
    clk     : in  std_logic;           --! Horloge du composant
    rst     : in  std_logic;           --! Reset general du composant
    apbi    : in  apb_slv_in_type;     --! Registre de gestion des entrées du bus
    Full    : out std_logic;
    Empty   : out std_logic;
    WR : out std_logic;
    RE : out std_logic;
    apbo    : out apb_slv_out_type     --! Registre de gestion des sorties du bus
    );
end APB_FIFO;


architecture ar_APB_FIFO of APB_FIFO is

signal ReadEnable   : std_logic;
signal WriteEnable  : std_logic;
signal FlagEmpty    : std_logic;
signal FlagFull     : std_logic;
--signal ReUse        : std_logic;
--signal Lock         : std_logic;
signal RstMem       : std_logic;
signal DataIn       : std_logic_vector(Data_sz-1 downto 0);
signal DataOut      : std_logic_vector(Data_sz-1 downto 0);
signal AddrIn       : std_logic_vector(Addr_sz-1 downto 0);
signal AddrOut      : std_logic_vector(Addr_sz-1 downto 0);

begin

    APB : ApbDriver
        generic map(pindex,paddr,pmask,pirq,abits,LPP_FIFO,Data_sz,Addr_sz,addr_max_int)
        port map(clk,rst,ReadEnable,WriteEnable,FlagEmpty,FlagFull,RstMem,DataIn,DataOut,AddrIn,AddrOut,apbi,apbo);


    DEVICE : Top_FIFO
        generic map(Data_sz,Addr_sz,addr_max_int)
        port map(clk,rst,ReadEnable,WriteEnable,RstMem,DataIn,AddrOut,AddrIn,FlagFull,FlagEmpty,DataOut);

Empty <= FlagEmpty;
Full <= FlagFull;
WR <= WriteEnable;
RE <= ReadEnable;

end ar_APB_FIFO;