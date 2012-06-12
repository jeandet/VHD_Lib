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



entity  TestbenshMAC is 
end TestbenshMAC;




architecture ar_TestbenshMAC of TestbenshMAC is 



constant    OP1sz   :   integer :=  16;
constant    OP2sz   :   integer :=  12;
--IDLE =00 MAC =01 MULT =10 ADD =11
constant    IDLE    :   std_logic_vector(1 downto 0) := "00";
constant    MAC     :   std_logic_vector(1 downto 0) := "01";
constant    MULT    :   std_logic_vector(1 downto 0) := "10";
constant    ADD     :   std_logic_vector(1 downto 0) := "11";

signal      clk         :   std_logic:='0';
signal      reset       :   std_logic:='0';
signal      clrMAC      :   std_logic:='0';
signal      MAC_MUL_ADD :   std_logic_vector(1 downto 0):=IDLE;
signal      Operand1    :   std_logic_vector(OP1sz-1 downto 0):=(others => '0');
signal      Operand2    :   std_logic_vector(OP2sz-1 downto 0):=(others => '0');
signal      Resultat    :   std_logic_vector(OP1sz+OP2sz-1 downto 0);




begin


MAC1    :  entity  LPP_IIR_FILTER.MAC
generic map(
    Input_SZ_A     =>   OP1sz,
    Input_SZ_B     =>   OP2sz

)
port map(
    clk             =>  clk,
    reset           =>  reset,
    clr_MAC         =>  clrMAC,
    MAC_MUL_ADD     =>  MAC_MUL_ADD,
    OP1             =>  Operand1,
    OP2             =>  Operand2,
    RES             =>  Resultat
);

clk     <=  not clk after 25 ns;

process
begin
wait for 40 ns;
reset   <=  '1';
wait for 11 ns;
Operand1 <=  X"0001";
Operand2 <=  X"001";
MAC_MUL_ADD <=  ADD;
wait for 50 ns;
Operand1 <=  X"0001";
Operand2 <=  X"100";
wait for 50 ns;
Operand1 <=  X"0001";
Operand2 <=  X"001";
MAC_MUL_ADD <=  MULT;
wait for 50 ns;
Operand1 <=  X"0002";
Operand2 <=  X"002";
wait for 50 ns;
clrMAC     <=  '1';
wait for 50 ns;
clrMAC     <=  '0';
Operand1 <=  X"0001";
Operand2 <=  X"003";
MAC_MUL_ADD <=  MAC;
wait;
end process;
end ar_TestbenshMAC;











