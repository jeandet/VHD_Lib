------------------------------------------------------------------------------
--  This file is a part of the LPP VHDL IP LIBRARY
--  Copyright (C) 2016, Laboratory of Plasmas Physic - CNRS
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
--                        Author : Alexis Jeandet
--                     Mail : alexis.jeandet@lpp.polytechnique.fr
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;
library gaisler;
use gaisler.libdcom.all;
use gaisler.uart.all;
library lpp;
use lpp.lpp_usb.all;
use lpp.lpp_amba.all;
use lpp.apb_devices_list.all;


entity ahb_ftdi_fifo is
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
end ahb_ftdi_fifo;

architecture beh of ahb_ftdi_fifo is

constant REVISION : integer := 0;

signal dmai : ahb_dma_in_type;
signal dmao : ahb_dma_out_type;
signal duarti : dcom_uart_in_type;
signal duarto : dcom_uart_out_type;

begin

  ahbmst0 : ahbmst
    generic map (hindex => hindex, venid => VENDOR_LPP, devid => LPP_AHB_FTDI_FIFO)
    port map (rstn, clk, dmai, dmao, ahbi, ahbo);

  dcom_fifo0 : ftdi_async_fifo generic map (oepol)
    port map (clk, rstn, duarti, duarto, FTDI_RXF, FTDI_TXE, FTDI_SIWUA,
       FTDI_WR, FTDI_RD, FTDI_D_in, FTDI_D_out, FTDI_D_drive);

  dcom0 : dcom port map (rstn, clk, dmai, dmao, duarti, duarto, ahbi);


end beh;

