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

entity Linker_FFT is
generic(
    Data_sz  : integer range 1 to 32 := 16;
    NbData : integer range 1 to 512 := 256
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


architecture ar_Linker of Linker_FFT is

type etat is (eX,e0,e1,e2);
signal ect : etat;

signal DataTmp  : std_logic_vector(Data_sz-1 downto 0);

signal sRead   : std_logic;
signal sReady : std_logic;

signal FifoCpt  : integer range 0 to 4 := 0;

begin

    process(clk,rstn)
    begin
        if(rstn='0')then 
            ect <= e0;
            sRead <= '0';
            sReady <= '0';
            Write <= (others => '1');
            Reuse <= (others => '0');
            FifoCpt <= 0;
            
        elsif(clk'event and clk='1')then
            sReady <= Ready;

            if(sReady='1' and Ready='0')then
                if(FifoCpt=4)then
                    FifoCpt <= 0;
                else
                    FifoCpt <= FifoCpt + 1;
                end if;
            elsif(Ready='1')then
                sRead <= not sRead;               
            else
                sRead <= '0';
            end if;           

            case ect is

                when e0 =>
                    Write(FifoCpt) <= '1';
                    if(Valid='1' and Full(FifoCpt)='0')then
                        DataTmp <= Data_im;
                        DATA(((FifoCpt+1)*Data_sz)-1 downto (FifoCpt*Data_sz)) <= Data_re;
                        Write(FifoCpt) <= '0';
                        ect <= e1;
                    elsif(Full(FifoCpt)='1')then
                        ReUse(FifoCpt) <= '1';                        
                    end if;                    

                 when e1 =>
                    DATA(((FifoCpt+1)*Data_sz)-1 downto (FifoCpt*Data_sz)) <= DataTmp;
                    ect <= e0;
                               
                when others =>
                    null;

            end case;
        end if;
    end process;

Read <= sRead;

end architecture;