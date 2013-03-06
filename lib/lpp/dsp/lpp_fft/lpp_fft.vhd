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
use lpp.lpp_memory.all;
use work.fft_components.all;

--! Package contenant tous les programmes qui forment le composant intégré dans le léon 

package lpp_fft is

component APB_FFT is
  generic (
    pindex       : integer := 0;
    paddr        : integer := 0;
    pmask        : integer := 16#fff#;
    pirq         : integer := 0;
    abits        : integer := 8;    
    Data_sz      : integer := 16
    );
  port (
    clk     : in  std_logic;
    rst     : in  std_logic;           --! Reset general du composant
    apbi    : in  apb_slv_in_type;
    apbo    : out apb_slv_out_type
    );
end component;


component APB_FFT_half is
  generic (
    pindex       : integer := 0;
    paddr        : integer := 0;
    pmask        : integer := 16#fff#;
    pirq         : integer := 0;
    abits        : integer := 8;    
    Data_sz      : integer := 16
    );
  port (
    clk     : in  std_logic;           --! Horloge du composant
    rst     : in  std_logic;           --! Reset general du composant
    Ren     : in std_logic;
    ready   : out std_logic;
    valid   : out std_logic;
    DataOut_re   : out std_logic_vector(Data_sz-1 downto 0);
    DataOut_im   : out std_logic_vector(Data_sz-1 downto 0);
    OUTfill : out std_logic;
    OUTwrite : out std_logic;
    apbi    : in  apb_slv_in_type;     --! Registre de gestion des entrées du bus
    apbo    : out apb_slv_out_type     --! Registre de gestion des sorties du bus
    );
end component;


component Flag_Extremum is
  port(
    clk,raz    : in std_logic;    --! Horloge et Reset général du composant
    load       : in std_logic;    --! Signal en provenance de CoreFFT
    y_rdy      : in std_logic;    --! Signal en provenance de CoreFFT
    fill       : out std_logic;   --! Flag, Va permettre d'autoriser l'écriture (Driver C)
    ready      : out std_logic    --! Flag, Va permettre d'autoriser la lecture (Driver C)
    );
end component;


component Linker_FFT is
generic(
    Data_sz  : integer range 1 to 32 := 16;
    NbData : integer range 1 to 512 := 256
    );
port(
    clk         : in std_logic;
    rstn        : in std_logic;
    Ready       : in std_logic;
    Valid       : in std_logic;
    Full        : in std_logic_vector(4 downto 0);
    Data_re     : in std_logic_vector(Data_sz-1 downto 0);
    Data_im     : in std_logic_vector(Data_sz-1 downto 0);
    Read        : out std_logic;
    Write       : out std_logic_vector(4 downto 0);
    ReUse       : out std_logic_vector(4 downto 0);
    DATA        : out std_logic_vector((5*Data_sz)-1 downto 0)
);
end component;


component Driver_FFT is
generic(
    Data_sz  : integer range 1 to 32 := 16;
    NbData : integer range 1 to 512 := 256
    );
port(
    clk         : in std_logic;
    rstn        : in std_logic;
    Load        : in std_logic;
    Empty       : in std_logic_vector(4 downto 0);
    DATA        : in std_logic_vector((5*Data_sz)-1 downto 0);
    Valid       : out std_logic;
    Read        : out std_logic_vector(4 downto 0);
    Data_re     : out std_logic_vector(Data_sz-1 downto 0);
    Data_im     : out std_logic_vector(Data_sz-1 downto 0)
);
end component;

component FFTamont is
generic(
    Data_sz  : integer range 1 to 32 := 16;
    NbData : integer range 1 to 512 := 256
    );
port(
    clk         : in std_logic;
    rstn        : in std_logic;
    Load        : in std_logic;
    Empty       : in std_logic;
    DATA        : in std_logic_vector(Data_sz-1 downto 0);
    Valid       : out std_logic;
    Read        : out std_logic;
    Data_re     : out std_logic_vector(Data_sz-1 downto 0);
    Data_im     : out std_logic_vector(Data_sz-1 downto 0)
);
end component;

component FFTaval is
generic(
    Data_sz  : integer range 1 to 32 := 8;
    NbData : integer range 1 to 512 := 256
    );
port(
    clk         : in std_logic;
    rstn        : in std_logic;
    Ready       : in std_logic;
    Valid       : in std_logic;
    Full        : in std_logic;
    Data_re     : in std_logic_vector(Data_sz-1 downto 0);
    Data_im     : in std_logic_vector(Data_sz-1 downto 0);
    Read        : out std_logic;
    Write       : out std_logic;
    ReUse       : out std_logic;
    DATA        : out std_logic_vector(Data_sz-1 downto 0)
);
end component;
--==============================================================|
--================== IP VHDL de la FFT actel ===================|
--================ non partagé dans la VHD_Lib =================|
--==============================================================|

component CoreFFT IS
  GENERIC (
    LOGPTS      : integer := gLOGPTS;
    LOGLOGPTS   : integer := gLOGLOGPTS;
    WSIZE       : integer := gWSIZE;
    TWIDTH      : integer := gTWIDTH;
    DWIDTH      : integer := gDWIDTH;
    TDWIDTH     : integer := gTDWIDTH;
    RND_MODE    : integer := gRND_MODE;
    SCALE_MODE  : integer := gSCALE_MODE;
    PTS         : integer := gPTS;
    HALFPTS     : integer := gHALFPTS;
    inBuf_RWDLY : integer := gInBuf_RWDLY  );
  PORT (
    clk,ifiStart,ifiNreset : IN std_logic;
    ifiD_valid, ifiRead_y  : IN std_logic;
    ifiD_im, ifiD_re       : IN std_logic_vector(WSIZE-1 DOWNTO 0);
    ifoLoad, ifoPong       : OUT std_logic;
    ifoY_im, ifoY_re       : OUT std_logic_vector(WSIZE-1 DOWNTO 0);
    ifoY_valid, ifoY_rdy   : OUT std_logic);
END component;


    component actar is
        port( DataA : in std_logic_vector(15 downto 0); DataB : in 
            std_logic_vector(15 downto 0); Mult : out 
            std_logic_vector(31 downto 0);Clock : in std_logic) ;
    end component;

    component actram is
        port( DI : in std_logic_vector(31 downto 0); DO : out
            std_logic_vector(31 downto 0);WRB, RDB : in std_logic; 
            WADDR : in std_logic_vector(6 downto 0); RADDR : in
            std_logic_vector(6 downto 0);WCLOCK, RCLOCK : in 
            std_logic) ;
    end component;

    component switch IS
        GENERIC ( DWIDTH  : integer := 32 );
        PORT (
          clk, sel, validIn       : IN std_logic;
          inP, inQ                : IN std_logic_vector(DWIDTH-1 DOWNTO 0);
          outP, outQ              : OUT std_logic_vector(DWIDTH-1 DOWNTO 0);
          validOut                : OUT std_logic);
    END component;

   component twid_rA IS
       GENERIC (LOGPTS    : integer := 8;
           LOGLOGPTS : integer := 3  );
       PORT (clk     : IN std_logic;
           timer   : IN std_logic_vector(LOGPTS-2 DOWNTO 0);
           stage   : IN std_logic_vector(LOGLOGPTS-1 DOWNTO 0);
           tA      : OUT std_logic_vector(LOGPTS-2 DOWNTO 0));
   END component;

   component counter IS
       GENERIC (
           WIDTH           : integer := 7;
           TERMCOUNT       : integer := 127 );
       PORT (
           clk, nGrst, rst, cntEn : IN std_logic;
           tc                     : OUT std_logic;
           Q                      : OUT std_logic_vector(WIDTH-1 DOWNTO 0) );
   END component;


   component twiddle IS
      PORT (
          A : IN std_logic_vector(gLOGPTS-2 DOWNTO 0);
          T : OUT std_logic_vector(gTDWIDTH-1 DOWNTO 0));
   END component;


end;