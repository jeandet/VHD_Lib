------------------------------------------------------------------------------
--  This file is a part of the LPP VHDL IP LIBRARY
--  Copyright (C) 2009 - 2012, Laboratory of Plasmas Physic - CNRS
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
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Linker_FFT_FIFO is
generic(
    Data_sz  : integer range 1 to 32 := 8
    );
port(
    clk         : in std_logic;
    rstn        : in std_logic;
    Ready       : in std_logic;
    Valid       : in std_logic;
    Full        : in std_logic_vector(4 downto 0);
    Data_re     : in std_logic_vector(Data_sz-1 downto 0);
    Data_im     : in std_logic_vector(Data_sz-1 downto 0);
    Read        : out std_logic;
    Write       : out std_logic_vector(4 downto 0);
    ReUse       : out std_logic_vector(4 downto 0);
    DATA        : out std_logic_vector((5*Data_sz)-1 downto 0)
);
end entity;


architecture ar_Linker of Linker_FFT_FIFO is

type etat is (eX,e0,e1,e2,e3);
signal ect : etat;

signal FifoCpt  : integer;
signal DataTmp    : std_logic_vector(Data_sz-1 downto 0);

signal sFull    : std_logic;
signal sData    : std_logic_vector(Data_sz-1 downto 0);
signal sReady   : std_logic;

begin

    process(clk,rstn)
    begin
        if(rstn='0')then 
            ect <= e0;
            Read <= '1';
            Write <= (others => '1');
            Reuse <= (others => '0');
            FifoCpt <= 1;
            sDATA <= (others => '0');
            
        elsif(clk'event and clk='1')then
            sReady <= Ready;

            case ect is

                when e0 =>
                    Write(FifoCpt-1) <= '1';
                    if(sReady='0' and Ready='1' and sfull='0')then
                        Read <= '0';
                        ect <= e1;
                    end if;

                when e1 =>
                    Read <= '1';
                    if(Valid='1' and sfull='0')then
                        DataTmp <= Data_im;
                        sDATA <= Data_re;
                        Write(FifoCpt-1) <= '0';
                        ect <= e2;
                    elsif(sfull='1')then
                        ReUse(FifoCpt-1) <= '1';
                        ect <= eX;
                    end if;                    

                 when e2 =>
                    sDATA <= DataTmp;
                    ect <= e3;            
 
                when e3 =>
                    Write(FifoCpt-1) <= '1';
                    if(Ready='1' and sfull='0')then
                        Read <= '0';
                        ect <= e1;
                    end if;
                               
                when eX =>
                    if(FifoCpt=6)then
                        FifoCpt <= 1;
                    else
                        FifoCpt <= FifoCpt+1;
                    end if;
                    ect <= e0;                    

            end case;
        end if;
    end process;

DATA <= sData & sData & sData & sData & sData;

with FifoCpt select
    sFull <=    Full(0) when 1,
                Full(1) when 2,
                Full(2) when 3,
                Full(3) when 4,
                Full(4) when 5,
                '1' when others;

end architecture;




