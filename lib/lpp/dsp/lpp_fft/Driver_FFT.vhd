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

entity Driver_FFT is
generic(
    Data_sz  : integer range 1 to 32 := 16
    );
port(
    clk         : in std_logic;
    rstn        : in std_logic;
    Load        : in std_logic;
    Empty       : in std_logic_vector(4 downto 0);
    Full        : in std_logic_vector(4 downto 0);
    DATA        : in std_logic_vector((5*Data_sz)-1 downto 0);
    Valid       : out std_logic;
    Read        : out std_logic_vector(4 downto 0);
    Data_re     : out std_logic_vector(Data_sz-1 downto 0);
    Data_im     : out std_logic_vector(Data_sz-1 downto 0)
);
end entity;


architecture ar_Driver of Driver_FFT is

type etat is (eX,e0,e1,e2);
signal ect : etat;

signal FifoCpt  : integer;
--signal DataTmp    : std_logic_vector(Data_sz-1 downto 0);

signal sEmpty    : std_logic;
signal sFull    : std_logic;
signal sData    : std_logic_vector(Data_sz-1 downto 0);

begin

    process(clk,rstn)
    begin
        if(rstn='0')then 
            ect <= eX;
            Read <= (others => '1');
            Valid <= '0';
            FifoCpt <= 1;
            
        elsif(clk'event and clk='1')then

            case ect is

                when eX => 
                    if(sFull='1')then
                        ect <= e0;
                    end if;

                when e0 =>
                    Valid <= '0';
                    if(Load='1' and sEmpty='0')then
                        Read(FifoCpt-1) <= '0';
                        ect <= e2;
--                        ect <= e1;
                    elsif(sEmpty='1')then
                        if(FifoCpt=6)then
                            FifoCpt <= 1;
                        else
                            FifoCpt <= FifoCpt+1;
                        end if;
                        ect <= eX;                        
                    end if;

                when e1 =>
                    null;
--                    DataTmp <= sData;
--                    ect <= e2;    
               
                when e2 =>
                    Read(FifoCpt-1) <= '1';
                    Data_re <= sData;
                    Data_im <= (others => '0');
--                    Data_re <= DataTmp;
--                    Data_im <= sData;
                    Valid <= '1';
                    ect <= e0;
                                           

            end case;
        end if;
    end process;

with FifoCpt select
    sFull <=        Full(0) when 1,
                    Full(1) when 2,
                    Full(2) when 3,
                    Full(3) when 4,
                    Full(4) when 5,
                    '1' when others; 
                                      
with FifoCpt select
    sEmpty <=       Empty(0) when 1,
                    Empty(1) when 2,
                    Empty(2) when 3,
                    Empty(3) when 4,
                    Empty(4) when 5,
                    '1' when others;

with FifoCpt select
    sData <=        DATA(Data_sz-1 downto 0) when 1,
                    DATA((2*Data_sz)-1 downto Data_sz) when 2,
                    DATA((3*Data_sz)-1 downto (2*Data_sz)) when 3,
                    DATA((4*Data_sz)-1 downto (3*Data_sz)) when 4,
                    DATA((5*Data_sz)-1 downto (4*Data_sz)) when 5,
                    (others => '0') when others;

end architecture;





















