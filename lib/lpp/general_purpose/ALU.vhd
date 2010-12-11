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
library lpp;
use lpp.general_purpose.all;
--IDLE =0000 MAC =0001 MULT =0010 ADD =0011 CLRMAC =0100
--NOT =0101 AND =0110 OR =0111 XOR =1000 
--SHIFTleft =1001 SHIFTright =1010

entity ALU is
generic(
    Arith_en        :   integer := 1;
    Logic_en        :   integer := 1;
    Input_SZ_1      :   integer := 16;
    Input_SZ_2      :   integer := 9

);
port(
    clk     :   in  std_logic;
    reset   :   in  std_logic;
    ctrl    :   in  std_logic_vector(3 downto 0);
    OP1     :   in  std_logic_vector(Input_SZ_1-1 downto 0);
    OP2     :   in  std_logic_vector(Input_SZ_2-1 downto 0);
    RES     :   out std_logic_vector(Input_SZ_1+Input_SZ_2-1 downto 0)
);
end entity;



architecture    ar_ALU of ALU is



signal clr_MAC          :   std_logic:='1';


begin

clr_MAC     <=  '1' when    ctrl = "0100" else '0';


arith : if Arith_en = 1 generate
MACinst : MAC  
generic map(Input_SZ_1,Input_SZ_2)
port map(clk,reset,clr_MAC,ctrl(1 downto 0),OP1,OP2,RES);
end generate;

end architecture;












