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
--                    Author : Martin Morlot
--                   Mail : martin.morlot@lpp.polytechnique.fr
-------------------------------------------------------------------------------
library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;

entity ReUse_CTRLR is
    port(
        clk         : in std_logic;
        reset       : in std_logic;

        SetReUse    : in std_logic_vector(4 downto 0);
        Statu       : in std_logic_vector(3 downto 0);

        ReUse       : out std_logic_vector(4 downto 0)
    );
end entity;


architecture ar_ReUse_CTRLR of ReUse_CTRLR is

signal ResetReUse       : std_logic_vector(4 downto 0);
signal MatrixParam : integer;
signal MatrixParam_Reg : integer;

begin



 process (clk,reset)
--    variable MatrixParam : integer;
    begin
--        MatrixParam := to_integer(unsigned(Statu));

        if(reset='0')then
            ResetReUse <= (others => '1');
            MatrixParam_Reg <= 0;
 
            
        elsif(clk' event and clk='1')then
            MatrixParam_Reg <= MatrixParam;

            if(MatrixParam_Reg = 7 and MatrixParam = 8)then         -- On videra FIFO(B1) a sa dernière utilisation PARAM = 11
                ResetReUse(0) <= '0';
            elsif(MatrixParam_Reg = 8 and MatrixParam = 9)then      -- On videra FIFO(B2) a sa dernière utilisation PARAM = 12
                ResetReUse(1) <= '0';
            elsif(MatrixParam_Reg = 9 and MatrixParam = 10)then     -- On videra FIFO(B3) a sa dernière utilisation PARAM = 13
                ResetReUse(2) <= '0';
            elsif(MatrixParam_Reg = 10 and MatrixParam = 11)then    -- On videra FIFO(E1) a sa dernière utilisation PARAM = 14
                ResetReUse(3) <= '0';
            elsif(MatrixParam_Reg = 14 and MatrixParam = 15)then    -- On videra FIFO(E2) a sa dernière utilisation PARAM = 15
                ResetReUse(4) <= '0';
            end if; 

        end if;
    end process;

    MatrixParam <= to_integer(unsigned(Statu));
    ReUse <= SetReUse and ResetReUse;
                    
end architecture;