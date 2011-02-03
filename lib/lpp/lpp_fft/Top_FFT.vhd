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
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
USE work.fft_components.all;

entity Top_FFT is
  port(
    clk,raz : in std_logic;
    data    : in std_logic_vector(15 downto 0);   
    y_valid : out std_logic;
    d_valid : out std_logic;    
    y_re    : out std_logic_vector(15 downto 0);
    y_im    : out std_logic_vector(15 downto 0)
    );
end Top_FFT;


architecture ar_Top_FFT of Top_FFT is

signal load    : std_logic;
signal start   : std_logic;
signal read_y  : std_logic;
signal val     : std_logic;
signal d_re    : std_logic_vector(15 downto 0);
signal d_im    : std_logic_vector(15 downto 0);

begin

   FFT : entity work.CoreFFT
        GENERIC map(
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
        port map(clk,start,raz,val,read_y,d_im,d_re,load,open,y_im,y_re,y_valid,open);
    

    Input : entity work.Driver_IN
        port map(clk,raz,load,data,start,read_y,val,d_re,d_im);        

d_valid <= val;

end ar_Top_FFT;