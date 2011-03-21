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

--! Driver APB "Générique" qui va faire le lien entre le bus Amba et la FIFO

entity ApbDriver is
  generic (
    pindex       : integer := 0;
    paddr        : integer := 0;
    pmask        : integer := 16#fff#;
    pirq         : integer := 0;
    abits        : integer := 8;
    LPP_DEVICE   : integer;
    Data_sz      : integer := 16;
    Addr_sz      : integer := 8;    
    addr_max_int : integer := 256);
  port (
    clk          : in  std_logic;                              --! Horloge du composant
    rst          : in  std_logic;                              --! Reset general du composant
    ReadEnable   : out std_logic;                              --! Instruction de lecture en mémoire
    WriteEnable  : out std_logic;                              --! Instruction d'écriture en mémoire
    FlagEmpty    : in std_logic;                               --! Flag, Mémoire vide
    FlagFull     : in std_logic;                               --! Flag, Mémoire pleine
    DataIn       : out std_logic_vector(Data_sz-1 downto 0);   --! Registre de données en entrée
    DataOut      : in std_logic_vector(Data_sz-1 downto 0);    --! Registre de données en sortie
    AddrIn       : in std_logic_vector(Addr_sz-1 downto 0);    --! Registre d'addresse (écriture)
    AddrOut      : in std_logic_vector(Addr_sz-1 downto 0);    --! Registre d'addresse (lecture)
    apbi         : in  apb_slv_in_type;                        --! Registre de gestion des entrées du bus
    apbo         : out apb_slv_out_type                        --! Registre de gestion des sorties du bus
    );
end ApbDriver;

--! @details Utilisable avec n'importe quelle IP VHDL de type FIFO

architecture ar_ApbDriver of ApbDriver is

constant REVISION : integer := 1;

constant pconfig : apb_config_type := (
  0 => ahb_device_reg (VENDOR_LPP, LPP_DEVICE, 0, REVISION, 0),
  1 => apb_iobar(paddr, pmask));

type DEVICE_ctrlr_Reg is record
     DEVICE_Cfg   : std_logic_vector(3 downto 0);
     DEVICE_DataW : std_logic_vector(Data_sz-1 downto 0);
     DEVICE_DataR : std_logic_vector(Data_sz-1 downto 0);
     DEVICE_AddrW : std_logic_vector(Addr_sz-1 downto 0);
     DEVICE_AddrR : std_logic_vector(Addr_sz-1 downto 0);
end record;

signal Rec    : DEVICE_ctrlr_Reg;
signal Rdata  : std_logic_vector(31 downto 0);

signal FlagRE : std_logic;
signal FlagWR : std_logic;
begin

Rec.DEVICE_Cfg(0) <= FlagRE;
Rec.DEVICE_Cfg(1) <= FlagWR;
Rec.DEVICE_Cfg(2) <= FlagEmpty;
Rec.DEVICE_Cfg(3) <= FlagFull;

DataIn <= Rec.DEVICE_DataW;
Rec.DEVICE_DataR <= DataOut;
Rec.DEVICE_AddrW <= AddrIn;
Rec.DEVICE_AddrR <= AddrOut;



    process(rst,clk)
    begin
        if(rst='0')then
            Rec.DEVICE_DataW <= (others => '0');
            FlagWR <= '0';
            FlagRE <= '0';

        elsif(clk'event and clk='1')then        

    --APB Write OP
            if (apbi.psel(pindex) and apbi.penable and apbi.pwrite) = '1' then
               case apbi.paddr(abits-1 downto 2) is
                    when "000000" =>
                         FlagWR <= '1';
                         Rec.DEVICE_DataW <= apbi.pwdata(15 downto 0);
                    when others =>
                         null;
               end case;
            else
                FlagWR <= '0';
            end if;

    --APB Read OP
            if (apbi.psel(pindex) and (not apbi.pwrite)) = '1' then
               case apbi.paddr(abits-1 downto 2) is
                    when "000000" =>
                         FlagRE <= '1';
                         Rdata(31 downto 16) <= X"DDDD";
                         Rdata(15 downto 0)  <= Rec.DEVICE_DataR;
                    when "000001" =>
                         Rdata(31 downto 8) <= X"AAAAAA";
                         Rdata(7 downto 0)  <= Rec.DEVICE_AddrR;
                    when "000101" =>
                         Rdata(31 downto 8) <= X"AAAAAA";
                         Rdata(7 downto 0)  <= Rec.DEVICE_AddrW;
                    when "000010" =>
                         Rdata(3 downto 0)   <= "000" & Rec.DEVICE_Cfg(0);
                         Rdata(7 downto 4)   <= "000" & Rec.DEVICE_Cfg(1);
                         Rdata(11 downto 8)  <= "000" & Rec.DEVICE_Cfg(2);
                         Rdata(15 downto 12) <= "000" & Rec.DEVICE_Cfg(3);
                         Rdata(31 downto 16) <= X"CCCC";
                    when others =>
                         Rdata <= (others => '0');
               end case;
            else
                FlagRE <= '0';
            end if;

        end if;
        apbo.pconfig <= pconfig;
    end process;

apbo.prdata     <=   Rdata when apbi.penable = '1';
WriteEnable     <=   FlagWR;
ReadEnable      <=   FlagRE;

end ar_ApbDriver;