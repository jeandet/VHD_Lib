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
    Data_sz  : integer range 1 to 32 := 16;
    NbData : integer range 1 to 512 := 256
    );
port(
    clk         : in std_logic;
    rstn        : in std_logic;
    Load        : in std_logic;
    Empty       : in std_logic_vector(4 downto 0);
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

signal DataCount : integer range 0 to 255 := 0;
signal FifoCpt  : integer range 0 to 4 := 0;

signal sLoad : std_logic;

begin

    process(clk,rstn)
    begin
        if(rstn='0')then 
            ect <= e0;
            Read <= (others => '1');
            Valid <= '0';
            Data_re <= (others => '0');
            Data_im <= (others => '0');
            DataCount <= 0;
            FifoCpt <= 0;
            sLoad <= '0';
            
        elsif(clk'event and clk='1')then
            sLoad <= Load;

            if(sLoad='1' and Load='0')then
                if(FifoCpt=4)then
                    FifoCpt <= 0;
                else
                    FifoCpt <= FifoCpt + 1;
                end if;
            end if;
                
            case ect is

                when e0 =>
                    if(Load='1' and Empty(FifoCpt)='0')then
                        Read(FifoCpt) <= '0';
                        ect <= e1;                       
                    end if;

                when e1 =>
                    Valid <= '0';
                    Read(FifoCpt) <= '1';
                    ect <= e2;
                    
                when e2 =>
                    Data_re <= DATA(((FifoCpt+1)*Data_sz)-1 downto (FifoCpt*Data_sz));
                    Data_im <= (others => '0');
                    Valid <= '1';
                    if(DataCount=NbData-1)then
                        DataCount <= 0;
                        ect <= eX;
                    else
                        DataCount <= DataCount + 1;
                        if(Load='1' and Empty(FifoCpt)='0')then
                            Read(FifoCpt) <= '0';
                            ect <= e1;
                        else
                            ect <= eX;
                        end if;                        
                    end if;

                when eX =>
                    Valid <= '0';
                    ect <= e0;

                when others =>
                    null; 

            end case;
        end if;
    end process;

end architecture;