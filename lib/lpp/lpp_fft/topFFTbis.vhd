-- topFFTbis.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
USE work.fft_components.all;

entity topFFTbis is
  port(
    clk,raz : in std_logic;    
    y_valid : out std_logic;
    y_rdy   : out std_logic;    
    y_re    : out std_logic_vector(15 downto 0);
    y_im    : out std_logic_vector(15 downto 0)
    );
end topFFTbis;


architecture ar_topFFTbis of topFFTbis is

signal load    : std_logic;
signal pong    : std_logic;
signal start   : std_logic;
signal read_y  : std_logic;
signal d_valid : std_logic;
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
        port map(clk,start,raz,d_valid,read_y,d_im,d_re,load,pong,y_im,y_re,y_valid,y_rdy);
    

    Input : entity work.Sinus_In
        port map(clk,raz,load,pong,start,read_y,d_valid,d_re,d_im);        

end ar_topFFTbis;