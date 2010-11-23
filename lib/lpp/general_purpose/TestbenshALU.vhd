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
library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;



entity  TestbenshALU is 
end TestbenshALU;




architecture ar_TestbenshALU of TestbenshALU is 



constant    OP1sz   :   integer :=  16;
constant    OP2sz   :   integer :=  12;
--IDLE =00 MAC =01 MULT =10 ADD =11
constant    IDLE    :   std_logic_vector(3 downto 0) := "0000";
constant    MAC     :   std_logic_vector(3 downto 0) := "0001";
constant    MULT    :   std_logic_vector(3 downto 0) := "0010";
constant    ADD     :   std_logic_vector(3 downto 0) := "0011";
constant    clr_mac :   std_logic_vector(3 downto 0) := "0100";

signal      clk         :   std_logic:='0';
signal      reset       :   std_logic:='0';
signal      ctrl        :   std_logic_vector(3 downto 0):=IDLE;
signal      Operand1    :   std_logic_vector(OP1sz-1 downto 0):=(others => '0');
signal      Operand2    :   std_logic_vector(OP2sz-1 downto 0):=(others => '0');
signal      Resultat    :   std_logic_vector(OP1sz+OP2sz-1 downto 0);




begin

ALU1 : entity LPP_IIR_FILTER.ALU 
generic map(
    Arith_en        =>    1,
    Logic_en        =>    0,
    Input_SZ_1      =>   OP1sz,
    Input_SZ_2      =>   OP2sz

)
port map(
    clk     =>  clk,
    reset   =>  reset,
    ctrl    =>  ctrl,
    OP1     =>  Operand1,
    OP2     =>  Operand2,
    RES     =>  Resultat
);




clk     <=  not clk after 25 ns;

process
begin
wait for 40 ns;
reset   <=  '1';
wait for 11 ns;
Operand1 <=  X"0001";
Operand2 <=  X"001";
ctrl <=  ADD;
wait for 50 ns;
Operand1 <=  X"0001";
Operand2 <=  X"100";
wait for 50 ns;
Operand1 <=  X"0001";
Operand2 <=  X"001";
ctrl <=  MULT;
wait for 50 ns;
Operand1 <=  X"0002";
Operand2 <=  X"002";
wait for 50 ns;
ctrl <=  clr_mac;
wait for 50 ns;
Operand1 <=  X"0001";
Operand2 <=  X"003";
ctrl <=  MAC;
wait for 50 ns;
Operand1 <=  X"0001";
Operand2 <=  X"001";
wait for 50 ns;
Operand1 <=  X"0011";
Operand2 <=  X"003";
wait for 50 ns;
Operand1 <=  X"1001";
Operand2 <=  X"003";
wait for 50 ns;
Operand1 <=  X"0001";
Operand2 <=  X"000";
wait for 50 ns;
Operand1 <=  X"0001";
Operand2 <=  X"003";
wait for 50 ns;
Operand1 <=  X"0101";
Operand2 <=  X"053";
wait for 50 ns;
ctrl <= clr_mac;
wait;
end process;
end ar_TestbenshALU;











