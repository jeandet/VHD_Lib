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
constant ChanelsCNT :   integer :=  6;
constant Smpl_SZ    :   integer := 16;
constant Coef_SZ    :   integer := 9;
constant Scalefac_SZ:   integer := 3;
constant Cels_count :   integer := 5;

constant Mem_use    :   integer := 1;



--============================================================
--      create each initial values for each coefs ============
--!!!!!!!!!!It should be interfaced with a software !!!!!!!!!!
--============================================================
--constant b0         :   coefT := coefT(TO_SIGNED(-30,Coef_SZ));
--constant b1         :   coefT := coefT(TO_SIGNED(-81,Coef_SZ));
--constant b2         :   coefT := coefT(TO_SIGNED(-153,Coef_SZ));
--constant b3         :   coefT := coefT(TO_SIGNED(-171,Coef_SZ));
--constant b4         :   coefT := coefT(TO_SIGNED(-144,Coef_SZ));
--constant b5         :   coefT := coefT(TO_SIGNED(-72,Coef_SZ));
--constant b6         :   coefT := coefT(TO_SIGNED(-25,Coef_SZ));
--
--constant a0         :   coefT := coefT(TO_SIGNED(-128,Coef_SZ));
--constant a1         :   coefT := coefT(TO_SIGNED(87,Coef_SZ));
--constant a2         :   coefT := coefT(TO_SIGNED(-193,Coef_SZ));
--constant a3         :   coefT := coefT(TO_SIGNED(60,Coef_SZ));
--constant a4         :   coefT := coefT(TO_SIGNED(-62,Coef_SZ));
--
--
--constant b0_0       :   coefT := coefT(TO_SIGNED(58,Coef_SZ));
--constant b0_1       :   coefT := coefT(TO_SIGNED(-66,Coef_SZ));
--constant b0_2       :   coefT := coefT(TO_SIGNED(58,Coef_SZ));
--
--constant b1_0       :   coefT := coefT(TO_SIGNED(58,Coef_SZ));
--constant b1_1       :   coefT := coefT(TO_SIGNED(-57,Coef_SZ));
--constant b1_2       :   coefT := coefT(TO_SIGNED(58,Coef_SZ));
--
--constant b2_0       :   coefT := coefT(TO_SIGNED(29,Coef_SZ));
--constant b2_1       :   coefT := coefT(TO_SIGNED(-17,Coef_SZ));
--constant b2_2       :   coefT := coefT(TO_SIGNED(29,Coef_SZ));
--
--constant b3_0       :   coefT := coefT(TO_SIGNED(15,Coef_SZ));
--constant b3_1       :   coefT := coefT(TO_SIGNED(4,Coef_SZ));
--constant b3_2       :   coefT := coefT(TO_SIGNED(15,Coef_SZ));
--
--constant b4_0       :   coefT := coefT(TO_SIGNED(15,Coef_SZ));
--constant b4_1       :   coefT := coefT(TO_SIGNED(24,Coef_SZ));
--constant b4_2       :   coefT := coefT(TO_SIGNED(15,Coef_SZ));
--
--constant b5_0       :   coefT := coefT(TO_SIGNED(-81,Coef_SZ));
--constant b5_1       :   coefT := coefT(TO_SIGNED(-153,Coef_SZ));
--constant b5_2       :   coefT := coefT(TO_SIGNED(-171,Coef_SZ));
--
--constant b6_0       :   coefT := coefT(TO_SIGNED(-144,Coef_SZ));
--constant b6_1       :   coefT := coefT(TO_SIGNED(-72,Coef_SZ));
--constant b6_2       :   coefT := coefT(TO_SIGNED(-25,Coef_SZ));
--
--
--constant a0_0       :   coefT := coefT(TO_SIGNED(-128,Coef_SZ));
--constant a0_1       :   coefT := coefT(TO_SIGNED(189,Coef_SZ));
--constant a0_2       :   coefT := coefT(TO_SIGNED(-111,Coef_SZ));
--
--constant a1_0       :   coefT := coefT(TO_SIGNED(-128,Coef_SZ));
--constant a1_1       :   coefT := coefT(TO_SIGNED(162,Coef_SZ));
--constant a1_2       :   coefT := coefT(TO_SIGNED(-81,Coef_SZ));
--
--constant a2_0       :   coefT := coefT(TO_SIGNED(-128,Coef_SZ));
--constant a2_1       :   coefT := coefT(TO_SIGNED(136,Coef_SZ));
--constant a2_2       :   coefT := coefT(TO_SIGNED(-55,Coef_SZ));
--
--constant a3_0       :   coefT := coefT(TO_SIGNED(-128,Coef_SZ));
--constant a3_1       :   coefT := coefT(TO_SIGNED(114,Coef_SZ));
--constant a3_2       :   coefT := coefT(TO_SIGNED(-33,Coef_SZ));
--
--constant a4_0       :   coefT := coefT(TO_SIGNED(-128,Coef_SZ));
--constant a4_1       :   coefT := coefT(TO_SIGNED(100,Coef_SZ));
--constant a4_2       :   coefT := coefT(TO_SIGNED(-20,Coef_SZ));
--
--constant a5_0       :   coefT := coefT(TO_SIGNED(60,Coef_SZ));
--constant a5_1       :   coefT := coefT(TO_SIGNED(-128,Coef_SZ));
--constant a5_2       :   coefT := coefT(TO_SIGNED(87,Coef_SZ));
--constant a6_0       :   coefT := coefT(TO_SIGNED(60,Coef_SZ));
--constant a6_1       :   coefT := coefT(TO_SIGNED(-128,Coef_SZ));
--constant a6_2       :   coefT := coefT(TO_SIGNED(87,Coef_SZ));
--
--
--constant celb0      :  coef_celT := (b0_0,b0_1,b0_2);
--constant celb1      :  coef_celT := (b1_0,b1_1,b1_2);
--constant celb2      :  coef_celT := (b2_0,b2_1,b2_2);
--constant celb3      :  coef_celT := (b3_0,b3_1,b3_2);
--constant celb4      :  coef_celT := (b4_0,b4_1,b4_2);
--constant celb5      :  coef_celT := (b5_0,b5_1,b5_2);
--constant celb6      :  coef_celT := (b6_0,b6_1,b6_2);
--
--constant cela0      :  coef_celT := (a0_0,a0_1,a0_2);
--constant cela1      :  coef_celT := (a1_0,a1_1,a1_2);
--constant cela2      :  coef_celT := (a2_0,a2_1,a2_2);
--constant cela3      :  coef_celT := (a3_0,a3_1,a3_2);
--constant cela4      :  coef_celT := (a4_0,a4_1,a4_2);
--constant cela5      :  coef_celT := (a5_0,a5_1,a5_2);
--constant cela6      :  coef_celT := (a6_0,a6_1,a6_2);
--
--
--
--constant  NumCoefs_cel    :   coefs_celT(0 to Cels_count-1) := (celb0,celb1,celb2,celb3,celb4);
--constant  DenCoefs_cel    :   coefs_celT(0 to Cels_count-1) := (cela0,cela1,cela2,cela3,cela4);
--constant  virgPos         :   integer := 7;
--
--
--
--
--
--
--
--signal  NumeratorCoefs   :   coefsT(0 to 6) := (b0,b1,b2,b3,b4,b5,b6);
--signal  DenominatorCoefs :   coefsT(0 to 4) := (a0,a1,a2,a3,a4);
--
--
--signal  sample_Tbl  :   samplT;


end;





































