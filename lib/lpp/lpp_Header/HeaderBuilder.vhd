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

entity HeaderBuilder is
  generic(
      Data_sz  : integer := 32);
    port(
        clkm            : in std_logic;
        rstn            : in std_logic;

        pong : in std_logic;
        Statu : in std_logic_vector(3 downto 0);
        Matrix_Type : in std_logic_vector(1 downto 0);
        Matrix_Write : in std_logic;
        Valid : out std_logic;               

        dataIN : in std_logic_vector((2*Data_sz)-1 downto 0);
        emptyIN : in std_logic_vector(1 downto 0);
        RenOUT : out std_logic_vector(1 downto 0);

        dataOUT  : out std_logic_vector(Data_sz-1 downto 0);
        emptyOUT : out std_logic;
        RenIN : in std_logic;

        header     : out  std_logic_vector(Data_sz-1 DOWNTO 0);
        header_val : out  std_logic;
        header_ack : in std_logic
        );
end entity;


architecture ar_HeaderBuilder of HeaderBuilder is

signal Matrix_Param     : std_logic_vector(3 downto 0);
signal Write_reg : std_logic;
signal Data_cpt : integer;
signal MAX : integer;


begin

 process (clkm,rstn)
    begin
        if(rstn='0')then
            Valid <= '0';
            Write_reg    <= '0';
            Data_cpt <= 0;
            MAX <= 0;

            
        elsif(clkm' event and clkm='1')then
            Write_reg <= Matrix_Write;

            if(Statu="0001" or Statu="0011" or Statu="0110" or Statu="1010" or Statu="1111")then
                MAX <= 128;
            else
                MAX <= 256;
            end if;

            if(Write_reg = '0' and Matrix_Write = '1')then
                if(Data_cpt = MAX)then
                    Data_cpt <= 0;
                    Valid <= '1';
                    header_val <= '1';
                else
                    Data_cpt <= Data_cpt + 1;
                    Valid <= '0';
                end if;
            end if;

            if(header_ack = '1')then
                header_val <= '0';
            end if;
              
        end if;
    end process;

Matrix_Param <= std_logic_vector(to_unsigned(to_integer(unsigned(Statu))-1,4));

header(1 downto 0) <= Matrix_Type;
header(5 downto 2) <= Matrix_Param;

dataOUT <= dataIN(Data_sz-1 downto 0) when pong = '0' else dataIN((2*Data_sz)-1 downto Data_sz);
emptyOUT <= emptyIN(0) when pong = '0' else emptyIN(1);

RenOUT <= '1' & RenIN when pong = '0' else RenIN & '1';

end architecture;
