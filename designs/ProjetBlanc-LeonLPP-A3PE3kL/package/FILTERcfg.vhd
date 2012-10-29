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
-------------------------------------------------------------------------------
library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;


package FILTERcfg is




--===========================================================|
--========F I L T E R   C O N F I G  V A L U E S=============|
--===========================================================|
--____________________________
--Bus Width and chanels number|
--____________________________|
constant ChanelsCount :   integer :=  1;
constant Sample_SZ    :   integer := 20;
constant Coef_SZ    :   integer := 9;
constant CoefCntPerCel:   integer := 6;
constant Cels_count :   integer := 5;
constant virgPos      : integer := 7;
constant Mem_use    :   integer := 1;



--============================================================
--      create each initial values for each coefs ============
--!!!!!!!!!!It should be interfaced with a software !!!!!!!!!!
--============================================================
constant b0_0       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(58,Coef_SZ));
constant b0_1       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(-66,Coef_SZ));
constant b0_2       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(58,Coef_SZ));

constant b1_0       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(58,Coef_SZ));
constant b1_1       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(-57,Coef_SZ));
constant b1_2       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(58,Coef_SZ));

constant b2_0       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(29,Coef_SZ));
constant b2_1       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(-17,Coef_SZ));
constant b2_2       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(29,Coef_SZ));

constant b3_0       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(15,Coef_SZ));
constant b3_1       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(4,Coef_SZ));
constant b3_2       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(15,Coef_SZ));

constant b4_0       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(15,Coef_SZ));
constant b4_1       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(24,Coef_SZ));
constant b4_2       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(15,Coef_SZ));

constant b5_0       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(-81,Coef_SZ));
constant b5_1       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(-153,Coef_SZ));
constant b5_2       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(-171,Coef_SZ));

constant b6_0       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(-144,Coef_SZ));
constant b6_1       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(-72,Coef_SZ));
constant b6_2       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(-25,Coef_SZ));


constant a0_0       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(-128,Coef_SZ));
constant a0_1       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(189,Coef_SZ));
constant a0_2       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(-111,Coef_SZ));

constant a1_0       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(-128,Coef_SZ));
constant a1_1       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(162,Coef_SZ));
constant a1_2       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(-81,Coef_SZ));

constant a2_0       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(-128,Coef_SZ));
constant a2_1       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(136,Coef_SZ));
constant a2_2       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(-55,Coef_SZ));

constant a3_0       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(-128,Coef_SZ));
constant a3_1       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(114,Coef_SZ));
constant a3_2       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(-33,Coef_SZ));

constant a4_0       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(-128,Coef_SZ));
constant a4_1       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(100,Coef_SZ));
constant a4_2       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(-20,Coef_SZ));

constant a5_0       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(60,Coef_SZ));
constant a5_1       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(-128,Coef_SZ));
constant a5_2       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(87,Coef_SZ));
constant a6_0       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(60,Coef_SZ));
constant a6_1       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(-128,Coef_SZ));
constant a6_2       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(87,Coef_SZ));

constant CoefsInitValCst  :   std_logic_vector((Cels_count*CoefCntPerCel*Coef_SZ)-1 downto 0) := (a4_2 & a4_1 & a4_0 & b4_2 & b4_1 & b4_0 & a3_2 & a3_1 & a3_0 & b3_2 & b3_1 & b3_0 & a2_2 & a2_1 & a2_0 & b2_2 & b2_1 & b2_0 & a1_2 & a1_1 & a1_0 & b1_2 & b1_1 &  b1_0 & a0_2 & a0_1 & a0_0 & b0_2 & b0_1 & b0_0);


end;





































