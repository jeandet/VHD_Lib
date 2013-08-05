------------------------------------------------------------------------------
--  This file is a part of the LPP VHDL IP LIBRARY
--  Copyright (C) 2009 - 2012, Laboratory of Plasmas Physic - CNRS
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
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library lpp;
use lpp.lpp_fft.all;
use lpp.fft_components.all;

-- Update possible lecture (ren) de fifo en continu, pendant un Load, au lieu d'une lecture "créneau"

entity FFT is
    generic(
        Data_sz : integer := 16;
        NbData : integer := 256);
    port(
        clkm            : in std_logic;
        rstn            : in std_logic;
        FifoIN_Empty    : in std_logic_vector(4 downto 0);
        FifoIN_Data     : in std_logic_vector(79 downto 0);
        FifoOUT_Full    : in std_logic_vector(4 downto 0);
        Load            : out std_logic;
        Read            : out std_logic_vector(4 downto 0);
        Write           : out std_logic_vector(4 downto 0);
        ReUse           : out std_logic_vector(4 downto 0);
        Data            : out std_logic_vector(79 downto 0)
        );
end entity;


architecture ar_FFT of FFT is

signal Drive_Write      : std_logic;
signal Drive_DataRE     : std_logic_vector(15 downto 0);
signal Drive_DataIM     : std_logic_vector(15 downto 0);

signal Start            : std_logic;
signal FFT_Load         : std_logic;
signal FFT_Ready        : std_logic;
signal FFT_Valid        : std_logic;
signal FFT_DataRE       : std_logic_vector(15 downto 0);
signal FFT_DataIM       : std_logic_vector(15 downto 0);

signal Link_Read        : std_logic;

begin

Start <= '0';
Load <= FFT_Load;

    DRIVE : Driver_FFT
        generic map(Data_sz,NbData)
        port map(clkm,rstn,FFT_Load,FifoIN_Empty,FifoIN_Data,Drive_Write,Read,Drive_DataRE,Drive_DataIM);    

    FFT0 : CoreFFT
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
        port map(clkm,start,rstn,Drive_Write,Link_Read,Drive_DataIM,Drive_DataRE,FFT_Load,open,FFT_DataIM,FFT_DataRE,FFT_Valid,FFT_Ready); 


    LINK : Linker_FFT
        generic map(Data_sz,NbData)
        port map(clkm,rstn,FFT_Ready,FFT_Valid,FifoOUT_Full,FFT_DataRE,FFT_DataIM,Link_Read,Write,ReUse,Data);


end architecture;