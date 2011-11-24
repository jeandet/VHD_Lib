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
use lpp.lpp_matrix.all;

--! Driver APB, va faire le lien entre l'IP VHDL du convertisseur et le bus Amba

entity APB_Matrix is
  generic (
    pindex   : integer := 0;
    paddr    : integer := 0;
    pmask    : integer := 16#fff#;
    pirq     : integer := 0;
    abits    : integer := 8;
    Input_SZ : integer := 16;
    Result_SZ : integer := 32);
  port (
    clk     : in  std_logic;           --! Horloge du composant
    rst     : in  std_logic;           --! Reset general du composant
    FIFO1       : in std_logic_vector(Input_SZ-1 downto 0);
    FIFO2       : in std_logic_vector(Input_SZ-1 downto 0);
    Full   : in std_logic_vector(1 downto 0);
    Empty   : in std_logic_vector(1 downto 0);
    ReadFIFO : out std_logic_vector(1 downto 0);
    WriteFIFO : out std_logic;
    Result       : out std_logic_vector(Result_SZ-1 downto 0);
    Start : out std_logic;
--    Read : out std_logic;
--    Take : out std_logic;
--    Valid : out std_logic;
--    Received : out std_logic;
--    Conjugate : out std_logic;
--    OP1 : out std_logic_vector(3 downto 0);
--    OP2 : out std_logic_vector(3 downto 0);
    apbi    : in  apb_slv_in_type;     --! Registre de gestion des entrées du bus
    apbo    : out apb_slv_out_type     --! Registre de gestion des sorties du bus
);
end APB_Matrix;


architecture ar_APB_Matrix of APB_Matrix is

constant REVISION : integer := 1;

constant pconfig : apb_config_type := (
  0 => ahb_device_reg (VENDOR_LPP, LPP_MATRIX, 0, REVISION, 0),
  1 => apb_iobar(paddr, pmask));

type MATRIX_ctrlr_Reg is record
     MATRIX_Statu : std_logic_vector(3 downto 0);
end record;

signal Rec : MATRIX_ctrlr_Reg;
signal Rdata : std_logic_vector(31 downto 0);

begin

Mspec0 : SpectralMatrix
    generic map (Input_SZ,Result_SZ)
    port map(clk,rst,FIFO1,FIFO2,Full,Empty,Rec.MATRIX_Statu,ReadFIFO,WriteFIFO,Start,Result);       --Start,Read,Take,Valid,Received,Conjugate,OP1,OP2

    process(rst,clk)
    begin
        if(rst='0')then
            Rec.MATRIX_Statu <= (others => '0');
            
        elsif(clk'event and clk='1')then 

    --APB Write OP
            if (apbi.psel(pindex) and apbi.penable and apbi.pwrite) = '1' then
                case apbi.paddr(abits-1 downto 2) is
                    when "000000" =>                         
                         Rec.MATRIX_Statu <= apbi.pwdata(3 downto 0);                   
                    when others =>
                        null;
                end case;
            end if;

    --APB READ OP
            if (apbi.psel(pindex) and (not apbi.pwrite)) = '1' then
                case apbi.paddr(abits-1 downto 2) is
                    when "000000" =>
                         Rdata(31 downto 4) <= (others => '0');
                         Rdata(3 downto 0) <= Rec.MATRIX_Statu;
                    --when "000001" =>
                    --     Rdata(3 downto 0) <= "000" & Rec.MATRIX_Cfg(0);
                    --     Rdata(7 downto 4) <= "000" & Rec.MATRIX_Cfg(1);
                    --     Rdata(11 downto 8) <= "000" & Rec.MATRIX_Cfg(2);
                    --     Rdata(15 downto 12) <= "000" & Rec.MATRIX_Cfg(3);
                    --     Rdata(19 downto 16) <= "000" & Rec.MATRIX_Cfg(4);
                    --     Rdata(23 downto 20) <= "000" & Rec.MATRIX_Cfg(5);
                    --     Rdata(31 downto 24) <= X"CC";
                    when others =>
                        Rdata <= (others => '0');
                end case;
            end if;

        end if;
        apbo.pconfig <= pconfig;
    end process;

apbo.prdata     <=   Rdata when apbi.penable = '1';

end ar_APB_MATRIX;