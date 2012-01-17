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
--                        Author : Alexis Jeandet
--                     Mail : alexis.jeandet@lpp.polytechnique.fr
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

entity ApbFifoDriverV is
  generic (
    pindex       : integer := 0;
    paddr        : integer := 0;
    pmask        : integer := 16#fff#;
    pirq         : integer := 0;
    abits        : integer := 8;
    LPP_DEVICE   : integer;
    FifoCnt      : integer := 1;
    Data_sz      : integer := 16;
    Addr_sz      : integer := 8;    
    addr_max_int : integer := 256);
  port (
    clk          : in  std_logic;                              --! Horloge du composant
    rst          : in  std_logic;                              --! Reset general du composant
    ReadEnable   : out std_logic_vector(FifoCnt-1 downto 0);   --! Instruction de lecture en mémoire
    WriteEnable  : out std_logic_vector(FifoCnt-1 downto 0);   --! Instruction d'écriture en mémoire
    FlagEmpty    : in std_logic_vector(FifoCnt-1 downto 0);    --! Flag, Mémoire vide
    FlagFull     : in std_logic_vector(FifoCnt-1 downto 0);    --! Flag, Mémoire pleine
    ReUse        : out std_logic_vector(FifoCnt-1 downto 0);   --! Flag, Permet de relire la mémoire du début
    Lock         : out std_logic_vector(FifoCnt-1 downto 0);   --! Flag, Permet de bloquer l'écriture dans la mémoire
    DataIn       : out std_logic_vector((FifoCnt*Data_sz)-1 downto 0);   --! Registre de données en entrée
    DataOut      : in std_logic_vector((FifoCnt*Data_sz)-1 downto 0);    --! Registre de données en sortie
    AddrIn       : in std_logic_vector((FifoCnt*Addr_sz)-1 downto 0);    --! Registre d'addresse (écriture)
    AddrOut      : in std_logic_vector((FifoCnt*Addr_sz)-1 downto 0);    --! Registre d'addresse (lecture)
    apbi         : in  apb_slv_in_type;                        --! Registre de gestion des entrées du bus
    apbo         : out apb_slv_out_type                        --! Registre de gestion des sorties du bus
    );
end ApbFifoDriverV;

--! @details Utilisable avec n'importe quelle IP VHDL de type FIFO

architecture ar_ApbFifoDriverV of ApbFifoDriverV is

constant REVISION : integer := 1;

constant pconfig : apb_config_type := (
  0 => ahb_device_reg (VENDOR_LPP, LPP_DEVICE, 0, REVISION, 0),
  1 => apb_iobar(paddr, pmask));

type DEVICE_ctrlr_Reg is record
     DEVICE_Cfg   : std_logic_vector(5 downto 0);
     DEVICE_DataW : std_logic_vector(Data_sz-1 downto 0);
     DEVICE_DataR : std_logic_vector(Data_sz-1 downto 0);
     DEVICE_AddrW : std_logic_vector(Addr_sz-1 downto 0);
     DEVICE_AddrR : std_logic_vector(Addr_sz-1 downto 0);
end record;

type DEVICE_ctrlr_RegV is array(FifoCnt-1 downto 0) of DEVICE_ctrlr_Reg;

signal Rec    : DEVICE_ctrlr_RegV;
signal Rdata  : std_logic_vector(31 downto 0);

signal FlagRE : std_logic;
signal FlagWR : std_logic;

begin

fifoflags: for i in 0 to  FifoCnt-1 generate:

  Rec(i).DEVICE_Cfg(0) <= FlagRE(i);
  Rec(i).DEVICE_Cfg(1) <= FlagWR(i);
  Rec(i).DEVICE_Cfg(2) <= FlagEmpty(i);
  Rec(i).DEVICE_Cfg(3) <= FlagFull(i);
  
  ReUse(i) <= Rec(i).DEVICE_Cfg(4);
  Lock(i)  <= Rec(i).DEVICE_Cfg(5);

  DataIn(i*(Data_sz-1 downto 0)) <= Rec(i).DEVICE_DataW;

  Rec(i).DEVICE_DataR <= DataOut(i*(Data_sz-1 downto 0));
  Rec(i).DEVICE_AddrW <= AddrIn(i*(Addr_sz-1 downto 0));
  Rec(i).DEVICE_AddrR <= AddrOut(i*(Addr_sz-1 downto 0));

  WriteEnable(i)     <=   FlagWR(i);
  ReadEnable(i)      <=   FlagRE(i);

end generate;


    process(rst,clk)
    begin
        if(rst='0')then
            Rec.DEVICE_DataW <= (others => '0');
            FlagWR <= '0';
            FlagRE <= '0';
            Rec.DEVICE_Cfg(4)  <= '0';
            Rec.DEVICE_Cfg(5)  <= '0';

        elsif(clk'event and clk='1')then        

    --APB Write OP
            if (apbi.psel(pindex) and apbi.penable and apbi.pwrite) = '1' then
               case apbi.paddr(abits-1 downto 2) is
                    when "000000" =>
                         FlagWR <= '1';
                         Rec.DEVICE_DataW <= apbi.pwdata(Data_sz-1 downto 0);
                    when "000010" =>
                         Rec.DEVICE_Cfg(4) <= apbi.pwdata(16);
                         Rec.DEVICE_Cfg(5) <= apbi.pwdata(20);
                    when others =>
                         null;
               end case;
            else
                FlagWR <= (others => '0');
            end if;

    --APB Read OP
            if (apbi.psel(pindex) and (not apbi.pwrite)) = '1' then
               case apbi.paddr(abits-1 downto 2) is
                    for i in 0 to  FifoCnt-1  loop
                        if conv_integer(apbi.paddr(7 downto 3)) = i then
                            case apbi.paddr(2 downto 2) is
                                when "0" =>
                                    CoefsReg.numCoefs(i)(0)  <=  (apbi.pwdata(Coef_SZ-1 downto 0));
                                when "1" =>
                                    CoefsReg.numCoefs(i)(1)  <=  (apbi.pwdata(Coef_SZ-1 downto 0));
                                when others =>
                            end case;
                        end if;
                    end loop;
                    when "000000" =>
                         FlagRE <= '1';
                         Rdata(Data_sz-1 downto 0)  <= Rec.DEVICE_DataR;
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
                         Rdata(19 downto 16) <= "000" & Rec.DEVICE_Cfg(4); 
                         Rdata(23 downto 20) <= "000" & Rec.DEVICE_Cfg(5);  
                         Rdata(31 downto 24) <= X"CC";
                    when others =>
                         Rdata <= (others => '0');
               end case;
            else
                FlagRE <= (others => '0');
            end if;

        end if;
        apbo.pconfig <= pconfig;
    end process;

apbo.prdata     <=   Rdata when apbi.penable = '1';


end ar_ApbFifoDriverV;