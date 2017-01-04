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
use grlib.stdlib.all;
use grlib.devices.all;
library gaisler;
use gaisler.libdcom.all;
use gaisler.uart.all;
library lpp;
use lpp.lpp_usb.all;


entity ftdi_async_fifo is
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
end ftdi_async_fifo;

architecture beh of ftdi_async_fifo is

type fifo_fsm_st is (idle,waitForTXE,preWrite,Write,postWrite,preRead,Read,postRead);
signal state : fifo_fsm_st:=idle;
signal output_en : std_logic;
signal dready : std_logic;

begin

acthi: if oepol = 1 generate
  output_en <= '1';
end generate;
actlow: if oepol = 0 generate
  output_en <= '0';
end generate;

dcom_out.dready <= dready;
FTDI_SIWUA <= '1';

process(rstn,clk)
begin
if rstn = '0' then
  FTDI_RD    <= '1';
  FTDI_WR    <= '1';
  FTDI_D_drive  <= not output_en;
  dready  <= '0';
  dcom_out.tsempty <= '0';
  dcom_out.thempty <= '1';
  dcom_out.lock    <= '1';
  dcom_out.data    <= (others => '0');
elsif clk'event and clk='1' then
  case state is
    when idle =>
      if dcom_in.read = '1' then
        dready <= '0';
      end if;
      FTDI_D_drive  <= not output_en;
      FTDI_WR       <= '1';
      dcom_out.thempty <= '1';
      if dcom_in.write = '1' then
        dcom_out.thempty <= '0';
        state <= waitForTXE;
      elsif FTDI_RXF = '0' and dready = '0' then
        state   <= preRead;
        FTDI_RD <= '0';
      end if;
    when waitForTXE =>
      if FTDI_TXE = '0' then
        state   <= preWrite;
        FTDI_D_drive  <= output_en;
        FTDI_D_out    <= dcom_in.data;
      end if;
    when preWrite =>
        FTDI_WR <= '0';
        state   <= Write;
    when Write =>
        FTDI_D_drive  <= not output_en;
        state   <= idle;
    when preRead =>
      state <= Read;
      dcom_out.data <= FTDI_D_in;
    when Read =>
      FTDI_RD  <= '1';
      dready <= '1';
      state    <= idle;
    when others => NULL;
  end case;
end if;
end process;

end beh;

-- type dcom_uart_in_type is record
--   read    	: std_ulogic;
--   write   	: std_ulogic;
--   data		: std_logic_vector(7 downto 0);
-- end record;

-- type dcom_uart_out_type is record
--   dready 	: std_ulogic;   -> data from ftdi to DCOM
--   tsempty	: std_ulogic;   -> not used by decom -> set to 0
--   thempty	: std_ulogic;   -> tels dcom that ready to write to ftdi
--   lock    	: std_ulogic;   -> set to 1
--   enable 	: std_ulogic;   -> unused
--   data		: std_logic_vector(7 downto 0);
-- end record;

