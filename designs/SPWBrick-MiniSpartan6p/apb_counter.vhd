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
--                    Author : Alexis Jeandet
--                     Mail : alexis.jeandet@lpp.polytechnique.fr
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;
library lpp;
use lpp.apb_devices_list.all;
use lpp.lpp_amba.all;
use lpp.general_purpose.all;


entity APB_counter is
  generic (
    pindex   : integer := 0;
    paddr    : integer := 0
    );
  port (
    rstn   : in  std_ulogic;
    clk    : in  std_ulogic;
    apbi   : in  apb_slv_in_type;
    apbo   : out apb_slv_out_type;

    SPW_Tickout : IN STD_LOGIC;
    GPS_PPS     : IN STD_LOGIC;
    gene_in     : IN STD_LOGIC
    );
end;


architecture beh of APB_counter is

constant REVISION : integer := 1;

constant pconfig : apb_config_type := (
  0 => ahb_device_reg (VENDOR_LPP, 16#A7#, 0, REVISION, 0),
  1 => apb_iobar(paddr,  16#fff#));

signal Rdata        : std_logic_vector(31 downto 0);

signal gene_in_reg     : std_logic_vector(3 downto 0);
signal gene_in_pulse   : std_logic;
signal GPS_PPS_in_reg  : std_logic_vector(3 downto 0);
signal GPS_PPS_pulse   : std_logic;

signal CNTR_CLK  : std_logic_vector(31 downto 0);
signal CNTR_GENE : std_logic_vector(31 downto 0);

signal SPW_TICK_CNTR_CLK  : std_logic_vector(31 downto 0);
signal SPW_TICK_CNTR_GENE : std_logic_vector(31 downto 0);
signal GPS_CNTR_CLK       : std_logic_vector(31 downto 0);
signal GPS_CNTR_GENE      : std_logic_vector(31 downto 0);


begin

CNTR_CLK_INST: general_counter
  GENERIC MAP(
    NB_BITS_COUNTER => 32
    )
  PORT MAP(
    clk      => clk,
    rstn     => rstn,
    --
    MAX_VALUE => (others => '1'),
    --
    set       => '0',
    set_value => (others => '1'),
    add1      => '1',
    counter   => CNTR_CLK
    );

CNTR_GENE_INST: general_counter
  GENERIC MAP(
    NB_BITS_COUNTER => 32
    )
  PORT MAP(
    clk      => clk,
    rstn     => rstn,
    --
    MAX_VALUE => (others => '1'),
    --
    set       => '0',
    set_value => (others => '1'),
    add1      => gene_in_pulse,
    counter   => CNTR_GENE
    );

SPW_TICK_CNTR_CLK_INST: D_FF_v
  generic map(size => 32)
  port map(
      rstn    => rstn,
      clk     => clk,
      enable  => SPW_Tickout,
      D       => CNTR_CLK,
      Q       => SPW_TICK_CNTR_CLK
  );

SPW_TICK_CNTR_GENE_INST: D_FF_v
  generic map(size => 32)
  port map(
      rstn    => rstn,
      clk     => clk,
      enable  => SPW_Tickout,
      D       => CNTR_GENE,
      Q       => SPW_TICK_CNTR_GENE
  );

GPS_CNTR_CLK_INST: D_FF_v
  generic map(size => 32)
  port map(
      rstn    => rstn,
      clk     => clk,
      enable  => GPS_PPS_pulse,
      D       => CNTR_CLK,
      Q       => GPS_CNTR_CLK
  );

GPS_CNTR_GENE_INST: D_FF_v
  generic map(size => 32)
  port map(
      rstn    => rstn,
      clk     => clk,
      enable  => GPS_PPS_pulse,
      D       => CNTR_GENE,
      Q       => GPS_CNTR_GENE
  );

process(rstn,clk)
begin
    if rstn = '0' then
      Rdata <= (others => '0');
    elsif clk'event and clk = '1' then
        gene_in_reg(3 downto 0) <= gene_in_reg(2 downto 0) & gene_in;
        GPS_PPS_in_reg(3 downto 0) <= GPS_PPS_in_reg(2 downto 0) & GPS_PPS;
        if gene_in_reg(3) = '0' and gene_in_reg(2) = '1' then
          gene_in_pulse <= '1';
        else
          gene_in_pulse <= '0';
        end if;
        if GPS_PPS_in_reg(3) = '0' and GPS_PPS_in_reg(2) = '1' then
          GPS_PPS_pulse <= '1';
        else
          GPS_PPS_pulse <= '0';
        end if;

--APB Write OP
        if (apbi.psel(pindex) and apbi.penable and apbi.pwrite) = '1' then
            case apbi.paddr(8-1 downto 2) is
                when "000000" =>
                    null;
                when others =>
                    null;
            end case;
        end if;

--APB READ OP
        if (apbi.psel(pindex) and (not apbi.pwrite)) = '1' then
            case apbi.paddr(8-1 downto 2) is
                when "000000" =>
                    Rdata <= SPW_TICK_CNTR_CLK;
                when "000001" =>
                    Rdata <= SPW_TICK_CNTR_GENE;
                when "000010" =>
                    Rdata <= GPS_CNTR_CLK;
                when "000011" =>
                    Rdata <= GPS_CNTR_GENE;
                when others =>
                    Rdata <= (others => '0');
            end case;
        end if;

    end if;
end process;

apbo.pconfig    <=   pconfig;
apbo.prdata     <=   Rdata when apbi.penable = '1';
apbo.pirq    <= (OTHERS => '0');
apbo.pindex  <= pindex;
end beh;
