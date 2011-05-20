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
use lpp.lpp_fft.all;
use lpp.lpp_memory.all;
use work.fft_components.all;

--! Driver APB, va faire le lien entre l'IP VHDL de la FFT et le bus Amba

entity APB_FFT is
  generic (
    pindex       : integer := 0;
    paddr        : integer := 0;
    pmask        : integer := 16#fff#;
    pirq         : integer := 0;
    abits        : integer := 8;    
    Data_sz      : integer := 32;
    Addr_sz      : integer := 8;    
    addr_max_int : integer := 256);
  port (
    clk     : in  std_logic;           --! Horloge du composant
    rst     : in  std_logic;           --! Reset general du composant
    apbi    : in  apb_slv_in_type;     --! Registre de gestion des entrées du bus
    apbo    : out apb_slv_out_type     --! Registre de gestion des sorties du bus
    );
end APB_FFT;


architecture ar_APB_FFT of APB_FFT is

signal ReadEnable      : std_logic;
signal WriteEnable     : std_logic;
signal FlagEmpty       : std_logic;
signal FlagFull        : std_logic;
signal DataIn_re       : std_logic_vector(gWSIZE-1 downto 0);
signal DataOut_re      : std_logic_vector(gWSIZE-1 downto 0);
signal DataIn_im       : std_logic_vector(gWSIZE-1 downto 0);
signal DataOut_im      : std_logic_vector(gWSIZE-1 downto 0);
signal DataIn          : std_logic_vector(Data_sz-1 downto 0);
signal DataOut         : std_logic_vector(Data_sz-1 downto 0);
signal AddrIn          : std_logic_vector(Addr_sz-1 downto 0);
signal AddrOut         : std_logic_vector(Addr_sz-1 downto 0);

signal start   : std_logic;
signal load    : std_logic;
signal rdy     : std_logic;
signal zero    : std_logic;

begin

    APB : ApbDriver
        generic map(pindex,paddr,pmask,pirq,abits,LPP_FFT,Data_sz,Addr_sz,addr_max_int)
        port map(clk,rst,ReadEnable,WriteEnable,FlagEmpty,FlagFull,zero,DataIn,DataOut,AddrIn,AddrOut,apbi,apbo);


    Extremum : Flag_Extremum
        port map(clk,rst,load,rdy,FlagFull,FlagEmpty);


    DEVICE : CoreFFT
        generic map(
        LOGPTS      => gLOGPTS,
        LOGLOGPTS   => gLOGLOGPTS,
        WSIZE       => gWSIZE,
        TWIDTH      => gTWIDTH,
        DWIDTH      => gDWIDTH,
        TDWIDTH     => gTDWIDTH,
        RND_MODE    => gRND_MODE,
        SCALE_MODE  => gSCALE_MODE,
        PTS         => gPTS,
        HALFPTS     => gHALFPTS,
        inBuf_RWDLY => gInBuf_RWDLY)        
        port map(clk,start,rst,WriteEnable,ReadEnable,DataIn_im,DataIn_re,load,open,DataOut_im,DataOut_re,open,rdy);

start <= not rst;
zero  <= '0';

DataIn_re <= DataIn(31 downto 16);
DataIn_im <= DataIn(15 downto 0);
DataOut   <= DataOut_re & DataOut_im;

end ar_APB_FFT;