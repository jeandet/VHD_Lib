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
-- APB_FIFO.vhd
library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
library techmap;
use techmap.gencomp.all;
library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;
library lpp;
use lpp.lpp_amba.all;
use lpp.apb_devices_list.all;
use lpp.lpp_memory.all;


entity APB_FIFO is
generic (
    tech         : integer := apa3;
    pindex       : integer := 0;
    paddr        : integer := 0;
    pmask        : integer := 16#fff#;
    pirq         : integer := 0;
    abits        : integer := 8;
    FifoCnt      : integer := 2;
    Data_sz      : integer := 16;
    Addr_sz      : integer := 9;
    R            : integer := 1;
    W            : integer := 1
    );
  port (
    clk          : in  std_logic;                              --! Horloge du composant
    rst          : in  std_logic;                              --! Reset general du composant
    rclk         : in  std_logic; 
    wclk         : in  std_logic; 
    REN          : in std_logic_vector(FifoCnt-1 downto 0);   --! Instruction de lecture en mémoire
    WEN          : in std_logic_vector(FifoCnt-1 downto 0);   --! Instruction d'écriture en mémoire
    Empty        : out std_logic_vector(FifoCnt-1 downto 0);    --! Flag, Mémoire vide
    Full         : out std_logic_vector(FifoCnt-1 downto 0);    --! Flag, Mémoire pleine
    RDATA        : out std_logic_vector((FifoCnt*Data_sz)-1 downto 0);   --! Registre de données en entrée
    WDATA        : in std_logic_vector((FifoCnt*Data_sz)-1 downto 0);    --! Registre de données en sortie
    WADDR        : out std_logic_vector((FifoCnt*Addr_sz)-1 downto 0);    --! Registre d'addresse (écriture)
    RADDR        : out std_logic_vector((FifoCnt*Addr_sz)-1 downto 0);    --! Registre d'addresse (lecture)
    apbi         : in  apb_slv_in_type;                        --! Registre de gestion des entrées du bus
    apbo         : out apb_slv_out_type                        --! Registre de gestion des sorties du bus
    );
end entity;

architecture ar_APB_FIFO of APB_FIFO is

constant REVISION : integer := 1;

constant pconfig : apb_config_type := (
  0 => ahb_device_reg (VENDOR_LPP, LPP_FIFO_PID, 0, REVISION, 0),
  1 => apb_iobar(paddr, pmask));

type FIFO_ctrlr_Reg is record
     FIFO_Ctrl  : std_logic_vector(31 downto 0);
     FIFO_Wdata : std_logic_vector(Data_sz-1 downto 0);
     FIFO_Rdata : std_logic_vector(Data_sz-1 downto 0);
end record;

type FIFO_ctrlr_Reg_Vec is array(FifoCnt-1 downto 0) of FIFO_ctrlr_Reg;
type fifodatabus is array(FifoCnt-1 downto 0) of std_logic_vector(Data_sz-1 downto 0); 
type fifoaddressbus is array(FifoCnt-1 downto 0) of std_logic_vector(Addr_sz-1 downto 0); 

signal Rec      : FIFO_ctrlr_Reg_Vec;
signal PRdata    : std_logic_vector(31 downto 0);
signal FIFO_ID  : std_logic_vector(31 downto 0);
signal autoloaded : std_logic_vector(FifoCnt-1 downto 0);
signal sFull     : std_logic_vector(FifoCnt-1 downto 0);
signal sEmpty    : std_logic_vector(FifoCnt-1 downto 0);
signal sEmpty_d  : std_logic_vector(FifoCnt-1 downto 0);
signal sWen      : std_logic_vector(FifoCnt-1 downto 0);
signal sRen      : std_logic_vector(FifoCnt-1 downto 0);
signal sRclk     : std_logic;
signal sWclk     : std_logic;
signal sWen_APB  : std_logic_vector(FifoCnt-1 downto 0);
signal sRen_APB  : std_logic_vector(FifoCnt-1 downto 0);
signal sRDATA    : fifodatabus;   
signal sWDATA    : fifodatabus;    
signal sWADDR    : fifoaddressbus;   
signal sRADDR    : fifoaddressbus;
signal ReUse     : std_logic_vector(FifoCnt-1 downto 0);   --27/01/12

type state_t is (idle,Read);
signal fiforeadfsmst : state_t;

begin

FIFO_ID(3 downto 0) <= std_logic_vector(to_unsigned(FifoCnt,4));
FIFO_ID(15 downto 8) <= std_logic_vector(to_unsigned(Data_sz,8));
FIFO_ID(23 downto 16) <= std_logic_vector(to_unsigned(Addr_sz,8));


Write : if W /= 0 generate 
    FIFO_ID(4) <= '1';
    sWen   <= sWen_APB;
    sWclk  <=  clk;
    Wrapb: for i in 0 to FifoCnt-1 generate
        sWDATA(i) <= Rec(i).FIFO_Wdata;
    end generate;
end generate;

Writeext : if W = 0 generate 
    FIFO_ID(4) <= '0';
    sWen   <=  WEN;
    sWclk  <=  Wclk;
    Wrext: for i in 0 to FifoCnt-1 generate
        sWDATA(i) <= WDATA((Data_sz*(i+1)-1) downto (Data_sz)*i);
    end generate;
end generate;

Read : if R /= 0 generate 
 FIFO_ID(5) <= '1';
 sRen   <=  sRen_APB;
 srclk  <=  clk;
 Rdapb: for i in 0 to FifoCnt-1 generate
        Rec(i).FIFO_Rdata  <= sRDATA(i);
 end generate;
end generate;

Readext : if R = 0 generate 
    FIFO_ID(5) <= '0';
    sRen   <=  REN;
    srclk  <=  rclk;
    Drext: for i in 0 to FifoCnt-1 generate
        RDATA((Data_sz*(i+1))-1 downto (Data_sz)*i)  <= sRDATA(i);
    end generate;
end generate;

ctrlregs: for i in 0 to FifoCnt-1 generate
    RADDR((Addr_sz*(i+1))-1 downto (Addr_sz)*i) <= sRADDR(i);
    WADDR((Addr_sz*(i+1))-1 downto (Addr_sz)*i) <= sWADDR(i);
    Rec(i).FIFO_Ctrl(16) <= sFull(i);
    --Rec(i).FIFO_Ctrl(17) <= Rec(i).FIFO_Ctrl(1); --27/01/12
    ReUse(i) <= Rec(i).FIFO_Ctrl(1); --27/01/12
    Rec(i).FIFO_Ctrl(3 downto 2) <= "00"; --27/01/12
    Rec(i).FIFO_Ctrl(19 downto 17) <= "000"; --27/01/12
    Rec(i).FIFO_Ctrl(Addr_sz+3 downto 4) <= sRADDR(i);
    Rec(i).FIFO_Ctrl((Addr_sz+19) downto 20) <= sWADDR(i);  ---|free|Waddrs|Full||free|Raddrs|empty|
end generate;                                               -- 31         17  16 15          1     0

Empty <= sEmpty;
Full <= sFull;


fifos: for i in 0 to FifoCnt-1 generate
    FIFO0 : lpp_fifo
        generic map (tech,Data_sz,Addr_sz)
        port map(rst,ReUse(i),srclk,sRen(i),sRDATA(i),sEmpty(i),sRADDR(i),swclk,sWen(i),sWDATA(i),sFull(i),sWADDR(i));
end generate;

    process(rst,clk)
    begin
        if(rst='0')then
        rstloop1: for i in 0 to FifoCnt-1 loop
            Rec(i).FIFO_Wdata <=  (others => '0');
            Rec(i).FIFO_Ctrl(1) <= '0'; --27/01/12
            --Rec(i).FIFO_Ctrl(17) <= '0';
            sWen_APB(i) <= '1';
        end loop;
        elsif(clk'event and clk='1')then
    --APB Write OP
            if (apbi.psel(pindex) and apbi.penable and apbi.pwrite) = '1' then
                   writelp: for i in 0 to FifoCnt-1 loop
                        if(conv_integer(apbi.paddr(abits-1 downto 2))=((2*i)+1)) then
                            Rec(i).FIFO_Ctrl(1) <= apbi.pwdata(1);
                            --Rec(i).FIFO_Ctrl(17) <= apbi.pwdata(17);
                        elsif(conv_integer(apbi.paddr(abits-1 downto 2))=((2*i)+2)) then
                            Rec(i).FIFO_Wdata <= apbi.pwdata(Data_sz-1 downto 0);
                            sWen_APB(i) <= '0';
                        end if;
                   end loop; 
            else
                sWen_APB <= (others =>'1');
            end if;
 --APB Read OP
            if (apbi.psel(pindex) and (not apbi.pwrite)) = '1' then
               if(apbi.paddr(abits-1 downto 2)="000000") then
                    PRdata   <= FIFO_ID;
                else
                   readlp: for i in 0 to FifoCnt-1 loop  
                        if(conv_integer(apbi.paddr(abits-1 downto 2))=((2*i)+1)) then
                            PRdata   <= Rec(i).FIFO_Ctrl;
                        elsif(conv_integer(apbi.paddr(abits-1 downto 2))=((2*i)+2)) then
                            PRdata(Data_sz-1 downto 0)  <= Rec(i).FIFO_rdata;
                        end if;
                   end loop; 
                end if;       
            end if;
    end if;
    apbo.pconfig <= pconfig;
end process;
apbo.prdata     <=   PRdata when apbi.penable = '1';



process(rst,clk)
    begin
        if(rst='0')then
            fiforeadfsmst   <= idle;
            rstloop: for i in 0 to FifoCnt-1 loop
                sRen_APB(i) <= '1';
                autoloaded(i)  <= '1';
                Rec(i).FIFO_Ctrl(0) <= sEmpty(i);
            end loop;
        elsif clk'event and clk = '1' then
            sEmpty_d    <= sEmpty;
            case fiforeadfsmst is
                when idle =>
                    idlelp: for i in 0 to FifoCnt-1 loop
                        if((sEmpty_d(i) = '1' and sEmpty(i) = '0' and autoloaded(i) = '1')or((conv_integer(apbi.paddr(abits-1 downto 2))=((2*i)+2)) and (apbi.psel(pindex)='1' and apbi.penable='1' and apbi.pwrite='0'))) then
                            if(sEmpty_d(i) = '1' and sEmpty(i) = '0') then
                                 autoloaded(i)  <= '0';
                            else 
                                 autoloaded(i)  <= '1';
                            end if;
                            sRen_APB(i) <= '0';
                            fiforeadfsmst   <= read;
                            Rec(i).FIFO_Ctrl(0) <= sEmpty(i);
                        else
                            sRen_APB(i) <= '1';
                        end if;
                    end loop;
                when read =>
                    sRen_APB        <= (others => '1');
                    fiforeadfsmst   <= idle;
                when others =>
                    fiforeadfsmst <= idle;
            end case;
        end if;
end process;


end ar_APB_FIFO;




























