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
use lpp.lpp_fifo.all;

--! Driver APB, va faire le lien entre l'IP VHDL de la FIFO et le bus Amba

entity APB_FifoWrite is
  generic (
    pindex       : integer := 0;
    paddr        : integer := 0;
    pmask        : integer := 16#fff#;
    pirq         : integer := 0;
    abits        : integer := 8;
    Data_sz      : integer := 16;
    Addr_sz      : integer := 8;
    addr_max_int : integer := 256);
  port (
    clk     : in std_logic;                             --! Horloge du composant
    rst     : in std_logic;                             --! Reset general du composant
    apbi    : in apb_slv_in_type;                       --! Registre de gestion des entrées du bus
    Flag_RE : in std_logic;                             --! Demande de lecture de la mémoire, géré hors de l'IP
    Raddr   : in std_logic_vector(addr_sz-1 downto 0);  --! Adresse du registre de lecture dans la mémoire
    apbo    : out apb_slv_out_type                      --! Registre de gestion des sorties du bus
    );
end APB_FifoWrite;


architecture ar_APB_FifoWrite of APB_FifoWrite is

constant REVISION : integer := 1;

constant pconfig : apb_config_type := (
  0 => ahb_device_reg (VENDOR_LPP, LPP_FIFO, 0, REVISION, 0),
  1 => apb_iobar(paddr, pmask));

type FIFO_ctrlr_Reg is record
     FIFO_Cfg   : std_logic_vector(1 downto 0);
     FIFO_DataW : std_logic_vector(15 downto 0);
     FIFO_DataR : std_logic_vector(15 downto 0);
     FIFO_AddrW : std_logic_vector(7 downto 0);
end record;

signal Rec    : FIFO_ctrlr_Reg;
signal Rdata  : std_logic_vector(31 downto 0);

signal flag_WR : std_logic;
signal full    : std_logic;

begin

Rec.FIFO_Cfg(0) <= flag_WR;
Rec.FIFO_Cfg(1) <= full;

    MEMORY_WRITE : entity Work.Top_FifoWrite
        generic map(Data_sz,Addr_sz,addr_max_int)
        port map(clk,rst,flag_RE,flag_WR,Rec.FIFO_DataW,Raddr,full,Rec.FIFO_AddrW,Rec.FIFO_DataR);


    process(rst,clk)
    begin
        if(rst='0')then
            Rec.FIFO_DataW <= (others => '0');

        elsif(clk'event and clk='1')then        

    --APB Write OP
            if (apbi.psel(pindex) and apbi.penable and apbi.pwrite) = '1' then
                case apbi.paddr(abits-1 downto 2) is
                    when "000000" =>
                        flag_WR        <= '1';
                        Rec.FIFO_DataW <= apbi.pwdata(15 downto 0);                    
                    when others =>
                        null;
                end case;
            else
                flag_WR <= '0';
            end if;

    --APB Read OP
            if (apbi.psel(pindex) and (not apbi.pwrite)) = '1' then
                case apbi.paddr(abits-1 downto 2) is
                    when "000000" =>
                        Rdata(31 downto 16) <= X"DDDD";
                        Rdata(15 downto 0)  <= Rec.FIFO_DataR;
                    when "000001" =>
                        Rdata(31 downto 8)  <= X"AAAAAA";
                        Rdata(7 downto 0)   <= Rec.FIFO_AddrW;
                    when "000010" =>
                        Rdata(3 downto 0)   <= "000" & Rec.FIFO_Cfg(0);
                        Rdata(7 downto 4)   <= "000" & Rec.FIFO_Cfg(1);                        
                        Rdata(31 downto 8)  <= X"CCCCCC";
                    when others =>
                        Rdata <= (others => '0');
                end case;
            end if;

        end if;
        apbo.pconfig <= pconfig;
    end process;

apbo.prdata <= Rdata when apbi.penable = '1';

end ar_APB_FifoWrite;