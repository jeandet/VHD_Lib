


-----------------------------------------------------------------------------
-- LEON3 Demonstration design test bench configuration
-- Copyright (C) 2009 Aeroflex Gaisler
------------------------------------------------------------------------------


library techmap;
use techmap.gencomp.all;
LIBRARY IEEE;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_1164.ALL;


package config is
-- Technology and synthesis options
  constant CFG_FABTECH : integer := spartan6;
  constant CFG_MEMTECH : integer := spartan6;
  constant CFG_PADTECH : integer := spartan6;
-- Clock generator
  constant CFG_CLKTECH : integer := spartan6;
  constant SEND_CONSTANT_DATA : integer := 0;
  constant SEND_MINF_VALUE    : integer := 0;
  
  
  
constant LF1cst :   std_logic_vector(15 downto 0) := X"1111";
constant LF2cst :   std_logic_vector(15 downto 0) := X"2222";
constant LF3cst :   std_logic_vector(15 downto 0) := X"3333";


constant  AMR1Xcst   :     std_logic_vector(23 downto 0):= X"000001";
constant  AMR1Ycst   :     std_logic_vector(23 downto 0):= X"111111";
constant  AMR1Zcst   :     std_logic_vector(23 downto 0):= X"7FFFFF";

constant  AMR2Xcst   :     std_logic_vector(23 downto 0):= X"800000";
constant  AMR2Ycst   :     std_logic_vector(23 downto 0):= X"000002";
constant  AMR2Zcst   :     std_logic_vector(23 downto 0):= X"800001";

constant  AMR3Xcst   :     std_logic_vector(23 downto 0):= X"AAAAAA";
constant  AMR3Ycst   :     std_logic_vector(23 downto 0):= X"BBBBBB";
constant  AMR3Zcst   :     std_logic_vector(23 downto 0):= X"CCCCCC";

constant  AMR4Xcst   :     std_logic_vector(23 downto 0):= X"DDDDDD";
constant  AMR4Ycst   :     std_logic_vector(23 downto 0):= X"EEEEEE";
constant  AMR4Zcst   :     std_logic_vector(23 downto 0):= X"FFFFFF";

constant  Temp1cst   :     std_logic_vector(23 downto 0):= X"121212";
constant  Temp2cst   :     std_logic_vector(23 downto 0):= X"343434";
constant  Temp3cst   :     std_logic_vector(23 downto 0):= X"565656";
constant  Temp4cst   :     std_logic_vector(23 downto 0):= X"787878";



--===========================================================|
--========F I L T E R   C O N F I G  V A L U E S=============|
--===========================================================|
--____________________________
--Bus Width and chanels number|
--____________________________|
constant ChanelsCount :   integer :=  3;
constant Sample_SZ    :   integer := 16;
constant Coef_SZ    :   integer := 9;
constant CoefCntPerCel:   integer := 6;
constant CoefPerCel:   integer := 5;
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

--constant b5_0       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(-81,Coef_SZ));
--constant b5_1       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(-153,Coef_SZ));
--constant b5_2       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(-171,Coef_SZ));

--constant b6_0       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(-144,Coef_SZ));
--constant b6_1       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(-72,Coef_SZ));
--constant b6_2       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(-25,Coef_SZ));


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

--constant a5_0       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(60,Coef_SZ));
--constant a5_1       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(-128,Coef_SZ));
--constant a5_2       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(87,Coef_SZ));
--constant a6_0       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(60,Coef_SZ));
--constant a6_1       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(-128,Coef_SZ));
--constant a6_2       :   std_logic_vector(Coef_SZ-1 downto 0) := std_logic_vector(TO_SIGNED(87,Coef_SZ));

constant CoefsInitValCst  :   std_logic_vector((Cels_count*CoefCntPerCel*Coef_SZ)-1 downto 0) := (a4_2 & a4_1 & a4_0 & b4_2 & b4_1 & b4_0 & a3_2 & a3_1 & a3_0 & b3_2 & b3_1 & b3_0 & a2_2 & a2_1 & a2_0 & b2_2 & b2_1 & b2_0 & a1_2 & a1_1 & a1_0 & b1_2 & b1_1 &  b1_0 & a0_2 & a0_1 & a0_0 & b0_2 & b0_1 & b0_0);

constant CoefsInitValCst_v2  :   std_logic_vector((Cels_count*CoefPerCel*Coef_SZ)-1 downto 0) :=
  (a4_1 & a4_2 & b4_0 & b4_1 & b4_2 &
   a3_1 & a3_2 & b3_0 & b3_1 & b3_2 &
   a2_1 & a2_2 & b2_0 & b2_1 & b2_2 &
   a1_1 & a1_2 & b1_0 & b1_1 & b1_2 &
   a0_1 & a0_2 & b0_0 & b0_1 & b0_2  );



end;
