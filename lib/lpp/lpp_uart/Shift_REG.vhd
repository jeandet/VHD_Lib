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
-------------------------------------------------------------------------------
--                    Author : Alexis Jeandet
--                     Mail : alexis.jeandet@lpp.polytechnique.fr
----------------------------------------------------------------------------
library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;

--! \brief Universal shift register can be used to serialize or deserialize data.
--!
--! \Author Alexis Jeandet alexis.jeandet@lpp.polytechnique.fr
--! \todo move to general purpose library, explain more in detail the code and add some schematic in doc.

entity Shift_REG is
generic(
        Data_sz     :   integer :=  10 --! Width of the shift register
);
port(
    clk         :   in  std_logic; --! System clock
    Sclk        :   in  std_logic; --! Serial clock
    reset       :   in  std_logic; --! System reset
    SIN         :   in  std_logic; --! Serial data in
    SOUT        :   out std_logic; --! Serial data out
    Serialize   :   in  std_logic; --! Launch serialization
    Serialized  :   out std_logic; --! Serialization complete
    D           :   in  std_logic_vector(Data_sz-1 downto 0); --! Parallel data to be shifted out
    Q           :   out std_logic_vector(Data_sz-1 downto 0)  --! Unserialized data
);
end entity;


architecture ar_Shift_REG of Shift_REG is 

signal   REG                :   std_logic_vector(Data_sz-1 downto 0);
signal   Serialized_int     :   std_logic;
signal   Serialize_reg      :   std_logic;
signal   Serial_reg         :   std_logic;
signal   CptBits            :   std_logic_vector(Data_sz-1 downto 0);
constant CptBits_trig       :   std_logic_vector(Data_sz-1 downto 0) := (others => '1');
signal   CptBits_flag       :   std_logic;
signal   CptBits_flag_reg   :   std_logic;

begin

Serialized          <=  Serialized_int;
CptBits_flag        <=  '1' when CptBits = CptBits_trig else '0';

process(reset,clk)
begin
    if reset = '0' then
        Serialized_int  <=  '1';
        CptBits_flag_reg    <=  '0';
        Serial_reg    <=   '0';
        Q               <=  (others => '0');
    elsif clk'event and clk = '1' then
        CptBits_flag_reg    <=  CptBits_flag;
        Serial_reg   <=    Serialize;
        
        if CptBits_flag = '1' and CptBits_flag_reg = '0' then
            Serialized_int  <=  '1';
            Q               <=  REG;
        elsif(Serial_reg='0' and Serialize='1')then
            Serialized_int  <=  '0';
        end if;
    end if;
end process;


process(reset,Sclk)
begin
    if reset = '0' then
        CptBits <=  (others =>  '0');
        REG     <=  (others =>  '0');
        SOUT    <=  '1';
        Serialize_reg  <=  '0';
    elsif Sclk'event and Sclk = '1' then
        Serialize_reg       <=  Serialized_int;
        if (Serialized_int = '0' and Serialize_reg ='1') then
            REG          <=  SIN & D(Data_sz-1 downto 1);
            SOUT         <=  D(0);
        elsif Serialized_int = '0' then
            REG          <=  SIN & REG(Data_sz-1 downto 1);
            SOUT         <=  REG(0);
        else
            SOUT         <=  '1';
        end if;
        if Serialized_int = '0' then
            if CptBits_flag = '1' then
                CptBits <=  (others =>  '0');
            else
                CptBits <=  '1' & CptBits(Data_sz-1 downto 1);
            end if;
        else
            CptBits <=  (others =>  '0');
        end if;
        
    end if;
end process;

end ar_Shift_REG;
