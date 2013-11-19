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

type etat is (idle0,idle1,pong0,pong1);
signal ect : etat;

begin

 process (clkm,rstn)
    begin
        if(rstn='0')then
            ect <= idle0;
            Valid <= '0';
            header_val <= '0';
            header(5 downto 0) <= (others => '0');
            Write_reg    <= '0';
            Data_cpt <= 0;
            MAX <= 128;

            
        elsif(clkm' event and clkm='1')then
            Write_reg <= Matrix_Write;

            if(Statu="0001" or Statu="0011" or Statu="0110" or Statu="1010" or Statu="1111")then
                MAX <= 128;
            else
                MAX <= 256;
            end if;

            if(Write_reg = '0' and Matrix_Write = '1')then     
                Data_cpt <= Data_cpt + 1;
                Valid <= '0';
            elsif(Data_cpt = MAX)then
                Data_cpt <= 0;
                Valid <= '1';
                header_val <= '1';
            else
                Valid <= '0';
            end if; 


            case ect is

                when idle0 =>
                    if(header_ack = '1')then
                        header_val <= '0';
                        ect <= pong0;
                    end if;

                when pong0 =>
                    header(1 downto 0) <= Matrix_Type;
                    header(5 downto 2) <= Matrix_Param;
                    if(emptyIN(0) = '1')then
                        ect <= idle1;
                    end if;                  

                when idle1 =>
                     if(header_ack = '1')then
                        header_val <= '0';
                        ect <= pong1;
                     end if;

                when pong1 =>
                    header(1 downto 0) <= Matrix_Type;
                    header(5 downto 2) <= Matrix_Param;
                    if(emptyIN(1) = '1')then
                        ect <= idle0;
                    end if;

            end case;
        end if;
    end process;

Matrix_Param <= std_logic_vector(to_unsigned(to_integer(unsigned(Statu))-1,4));

header(31 downto 6) <= (others => '0');

with ect select
    dataOUT <= dataIN(Data_sz-1 downto 0)           when pong0,
               dataIN(Data_sz-1 downto 0)           when idle0,
               dataIN((2*Data_sz)-1 downto Data_sz) when pong1,
               dataIN((2*Data_sz)-1 downto Data_sz) when idle1,
               (others => '0')                      when others;

with ect select
    emptyOUT    <= emptyIN(0)   when pong0,
                   emptyIN(0)   when idle0,
                   emptyIN(1)   when pong1,
                   emptyIN(1)   when idle1,
                   '1'          when others;

with ect select 
    RenOUT  <= '1' & RenIN  when pong0,
               '1' & RenIN  when idle0,
               RenIN & '1'  when pong1,
               RenIN & '1'  when idle1,
               "11"         when others;

end architecture;
