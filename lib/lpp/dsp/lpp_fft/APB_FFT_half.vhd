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
use work.fft_components.all;

--! Driver APB, va faire le lien entre l'IP VHDL de la FFT et le bus Amba

entity APB_FFT_half is
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
end entity;


architecture ar_APB_FFT_half of APB_FFT_half is

constant REVISION : integer := 1;

constant pconfig : apb_config_type := (
  0 => ahb_device_reg (VENDOR_LPP, LPP_FFT, 0, REVISION, 0),
  1 => apb_iobar(paddr, pmask));

signal Wen          : std_logic;
signal load         : std_logic;
signal d_valid      : std_logic;
signal y_valid      : std_logic;
signal y_rdy        : std_logic;
signal read_y       : std_logic;
signal fill         : std_logic;
signal start        : std_logic;
signal DataIn_re    : std_logic_vector(Data_sz-1 downto 0);
signal DataIn_im    : std_logic_vector(Data_sz-1 downto 0);

type FFT_ctrlr_Reg is record
     FFT_Cfg   : std_logic;
     FFT_Wdata  : std_logic_vector((2*Data_sz)-1 downto 0);
end record;

signal Rec      : FFT_ctrlr_Reg;
signal Rdata    : std_logic_vector(31 downto 0);
 
begin

Rec.FFT_Cfg <= fill;

DataIn_im <= Rec.FFT_Wdata(Data_sz-1 downto 0);
DataIn_re <= Rec.FFT_Wdata((2*Data_sz)-1 downto Data_sz);

    Actel_FFT : CoreFFT       
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
        port map(clk,start,rst,d_valid,read_y,DataIn_im,DataIn_re,load,open,DataOut_im,DataOut_re,y_valid,y_rdy);

--    Flags : Flag_Extremum
--        port map(clk,rst,load,y_rdy,fill,ready);

    process(rst,clk)
    begin
        if(rst='0')then
            Rec.FFT_Wdata <= (others => '0');
            Wen <= '1';

        elsif(clk'event and clk='1')then        

    --APB Write OP
            if (apbi.psel(pindex) and apbi.penable and apbi.pwrite) = '1' then
                case apbi.paddr(abits-1 downto 2) is                            
                    when "000001" =>   
                        Wen <= '0';
                        Rec.FFT_Wdata(Data_sz-1 downto 0) <= (others => '0');
                        Rec.FFT_Wdata((2*Data_sz)-1 downto Data_sz) <= apbi.pwdata(Data_sz-1 downto 0);

                    when others =>
                        null;
               end case;
            else
                Wen <= '1';
            end if;

    --APB Read OP
            if (apbi.psel(pindex) and (not apbi.pwrite)) = '1' then
                case apbi.paddr(abits-1 downto 2) is
                    when "000000" =>
                        Rdata(3 downto 0)   <= "000" & Rec.FFT_Cfg;
                        Rdata(31 downto 4) <= (others => '0');

                    when others =>
                        Rdata <= (others => '0');
               end case;
            end if;

        end if;
        apbo.pconfig <= pconfig;
    end process;

apbo.prdata <= Rdata when apbi.penable = '1';
d_valid     <= not Wen;
read_y      <= not Ren;
fill <= Load;
Ready <= y_rdy;
valid <= y_valid;
start       <= not rst;

OUTfill <= Load;
OUTwrite <= not Wen;

end architecture;