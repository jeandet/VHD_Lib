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
library gaisler;
use gaisler.libdcom.all;
library lpp;
use lpp.lpp_amba.all;

--! Package contenant tous les programmes qui forment le composant intégré dans le léon 

package lpp_usb is

component ahb_ftdi_fifo is
generic (
  oepol : integer := 0;
  hindex  : integer := 0
);
port (
  clk         : in  std_logic;
  rstn        : in  std_logic;

  ahbi    : in  ahb_mst_in_type;
  ahbo    : out ahb_mst_out_type;

  FTDI_RXF     : in  std_logic;
  FTDI_TXE     : in  std_logic;
  FTDI_SIWUA   : out std_logic;
  FTDI_WR      : out std_logic;
  FTDI_RD      : out std_logic;
  FTDI_D_in    : in  std_logic_vector(7 downto 0);
  FTDI_D_out   : out std_logic_vector(7 downto 0);
  FTDI_D_drive : out std_logic
);
end component;

component ftdi_async_fifo is
generic (
  oepol : integer := 0
);
port (
  clk         : in  std_logic;
  rstn        : in  std_logic;

  dcom_in     : in  dcom_uart_in_type;
  dcom_out    : out dcom_uart_out_type;

  FTDI_RXF     : in  std_logic;
  FTDI_TXE     : in  std_logic;
  FTDI_SIWUA   : out std_logic;
  FTDI_WR      : out std_logic;
  FTDI_RD      : out std_logic;
  FTDI_D_in    : in  std_logic_vector(7 downto 0);
  FTDI_D_out   : out std_logic_vector(7 downto 0);
  FTDI_D_drive : out std_logic
);
end component;

component ftdi_async_fifo_loopback is
generic (
  oepol : integer := 0
);
port (
  clk         : in  std_logic;
  rstn        : in  std_logic;


  FTDI_RXF     : in  std_logic;
  FTDI_TXE     : in  std_logic;
  FTDI_SIWUA   : out std_logic;
  FTDI_WR      : out std_logic;
  FTDI_RD      : out std_logic;
  FTDI_D_in    : in  std_logic_vector(7 downto 0);
  FTDI_D_out   : out std_logic_vector(7 downto 0);
  FTDI_D_drive : out std_logic
);
end component;

component FX2_Driver is
port(
        clk         : in STD_LOGIC;
        if_clk      : out STD_LOGIC;
        reset       : in  std_logic;
        flagb       : in STD_LOGIC; 
        slwr        : out STD_LOGIC;
        slrd        : out std_logic;
        pktend      : out STD_LOGIC;
        sloe        : out STD_LOGIC;
        fdbusw      : out std_logic_vector (7 downto 0);
        fifoadr     : out std_logic_vector (1 downto 0);

        FULL        : out std_logic;
        Write       : in std_logic;
        Data        : in std_logic_vector(7 downto 0)
    ); 
end component;

component FX2_WithFIFO is
generic(
    tech          :   integer := 0;
    Mem_use       :   integer := 0;
    Enable_ReUse  :   std_logic := '0';
    fifoCount     :   integer range 2 to 100 := 8;
    abits         :   integer range 2 to 12 := 8
    );
port(
        clk         : in STD_LOGIC;
        if_clk      : out STD_LOGIC;
        reset       : in  std_logic;
        flagb       : in STD_LOGIC; 
        slwr        : out STD_LOGIC;
        slrd        : out std_logic;
        pktend      : out STD_LOGIC;
        sloe        : out STD_LOGIC;
        fdbusw      : out std_logic_vector (7 downto 0);
        fifoadr     : out std_logic_vector (1 downto 0);

        FULL        : out std_logic;
        Write       : in std_logic;
        Data        : in std_logic_vector(7 downto 0)
    ); 
end component;

component APB_USB is
    generic (
      pindex   : integer := 0;
      paddr    : integer := 0;
      pmask    : integer := 16#fff#;
      pirq     : integer := 0;
      abits    : integer := 8;
      DataMax  : integer := 1024);
    port (
      clk      : in  std_logic;           --! Horloge du composant
      rst      : in  std_logic;           --! Reset general du composant
      flagC    : in std_logic;
      flagB    : in std_logic;
      ifclk    : out std_logic;
      sloe     : out std_logic;
      slrd     : out std_logic;
      slwr     : out std_logic;
      pktend   : out std_logic;
      fifoadr  : out std_logic_vector(1 downto 0);
      fdbusrw  : inout std_logic_vector(7 downto 0);
      apbi     : in  apb_slv_in_type;     --! Registre de gestion des entrées du bus
      apbo     : out apb_slv_out_type     --! Registre de gestion des sorties du bus
  );
end component;


  component RWbuf is
      generic(DataMax : integer := 1024);
      port(
          clk         : in std_logic;
          rst         : in std_logic;
          flagC       : in std_logic;
          flagB       : in std_logic;
          IOselect    : in std_logic;
          ifclk       : out std_logic;
          sloe        : out std_logic;        
          slrd        : out std_logic;
          slwr        : out std_logic;
          pktend      : out std_logic;
          fifoadr     : out std_logic_vector(1 downto 0);
          fdbusrw     : inout std_logic_vector(7 downto 0)
      ); 
  end component;

end package;
