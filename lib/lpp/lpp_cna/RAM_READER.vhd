------------------------------------------------------------------------------
--  This file is a part of the LPP VHDL IP LIBRARY
--  Copyright (C) 2009 - 2015, Laboratory of Plasmas Physic - CNRS
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
--                     Mail : alexis.jeandet@member.fsf.org
------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RAM_READER is
    Generic(
        datawidth     : integer := 18;
        dacresolution : integer := 12;
        abits         : integer := 8
    );
    Port ( 
        clk         : in  STD_LOGIC;                                    --! clock input
        rstn        : in  STD_LOGIC;                                    --! Active low restet input
        DATA_IN     : in  STD_LOGIC_VECTOR (datawidth-1 downto 0);      --! DATA input vector -> connect to RAM DATA output
        ADDRESS     : out STD_LOGIC_VECTOR (abits-1 downto 0);          --! ADDRESS output vector -> connect to RAM read ADDRESS input
        REN         : out STD_LOGIC;                                    --! Active low read enable -> connect to RAM read enable
        DATA_OUT    : out STD_LOGIC_VECTOR (dacresolution-1 downto 0);  --! DATA output vector
        SMP_CLK     : in  STD_LOGIC;                                    --! Sampling clock input, each rising edge will provide a DATA to the output and read a new one in RAM
        INTERLEAVED : in  STD_LOGIC                                     --! When 1, interleaved mode is actived.
              );
end RAM_READER;

architecture Behavioral of RAM_READER is
CONSTANT interleaved_sz   : integer := dacresolution/(datawidth-dacresolution);

signal ADDRESS_R             :  STD_LOGIC_VECTOR (abits-1 downto 0);--:=(others=>'0');
signal SAMPLE_R              :  STD_LOGIC_VECTOR (dacresolution-1 downto 0):=(others=>'0');
signal INTERLEAVED_SAMPLE_R  :  STD_LOGIC_VECTOR (dacresolution-1 downto 0):=(others=>'0');
signal SMP_CLK_R             :  STD_LOGIC;
signal interleavedCNTR       :  integer range 0 to interleaved_sz;
signal REN_R                 :  STD_LOGIC:='1';
signal interleave            :  STD_LOGIC:='0';
signal loadEvent             :  STD_LOGIC:='0';
signal loadEvent_R           :  STD_LOGIC:='0';
signal loadEvent_R2          :  STD_LOGIC:='0';
begin

REN         <=  REN_R;
DATA_OUT    <=  SAMPLE_R;
ADDRESS     <=  ADDRESS_R;
interleave  <= '1' when interleavedCNTR=interleaved_sz else '0';

loadEvent   <= SMP_CLK and not SMP_CLK_R ;

process(clk,rstn)
begin
    if rstn='0' then
        SMP_CLK_R               <= '0';
        loadEvent_R             <= '0';
        loadEvent_R2            <= '0';
    elsif clk'event and clk='1' then
        SMP_CLK_R    <= SMP_CLK;
        loadEvent_R  <= loadEvent;
        loadEvent_R2 <= loadEvent_R;
    end if;
end process;

process(clk,rstn)
begin
    if rstn='0' then
        ADDRESS_R               <= (others=>'0');
        SAMPLE_R                <= (others=>'0');
        INTERLEAVED_SAMPLE_R    <= (others=>'0');
        REN_R                   <= '1';
        interleavedCNTR 		<= 0;
    elsif clk'event and clk='1' then
        if loadEvent = '1' then
            if(interleave='0') then
                REN_R           <= '0';
            end if;
        else
            REN_R   <= '1';
        end if;
        
        if REN_R = '0' then
            ADDRESS_R       <= std_logic_vector(UNSIGNED(ADDRESS_R) + 1); --Automatic increment on each read 
        end if;
        
        if loadEvent_R2='1' then
            if(interleave='1') then
                interleavedCNTR <= 0;
                SAMPLE_R        <= INTERLEAVED_SAMPLE_R;
            else
                if interleaved='1' then
                    interleavedCNTR     <= interleavedCNTR + 1;
                else 
                    interleavedCNTR     <= 0;
                end if;
                SAMPLE_R            <= DATA_IN(dacresolution-1 downto 0);
                INTERLEAVED_SAMPLE_R(dacresolution-1 downto 0) <= INTERLEAVED_SAMPLE_R(datawidth-dacresolution-1 downto 0) & DATA_IN(datawidth-1 downto dacresolution);
            end if;
        end if;
    end if;
end process;

end Behavioral;