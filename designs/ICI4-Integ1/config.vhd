


-----------------------------------------------------------------------------
-- LEON3 Demonstration design test bench configuration
-- Copyright (C) 2009 Aeroflex Gaisler
------------------------------------------------------------------------------


library techmap;
use techmap.gencomp.all;
library ieee;
use ieee.std_logic_1164.all;

package config is
-- Technology and synthesis options
  constant CFG_FABTECH : integer := spartan6;
  constant CFG_MEMTECH : integer := spartan6;
  constant CFG_PADTECH : integer := spartan6;
-- Clock generator
  constant CFG_CLKTECH : integer := spartan6;
  constant SEND_CONSTANT_DATA : integer := 1;
  constant SEND_MINF_VALUE    : integer := 1;
  
  
  
constant LF1cst :   std_logic_vector(15 downto 0) := X"1111";
constant LF2cst :   std_logic_vector(15 downto 0) := X"2222";
constant LF3cst :   std_logic_vector(15 downto 0) := X"3333";


constant  AMR1Xcst   :     std_logic_vector(23 downto 0):= X"444444";
constant  AMR1Ycst   :     std_logic_vector(23 downto 0):= X"555555";
constant  AMR1Zcst   :     std_logic_vector(23 downto 0):= X"666666";

constant  AMR2Xcst   :     std_logic_vector(23 downto 0):= X"777777";
constant  AMR2Ycst   :     std_logic_vector(23 downto 0):= X"888888";
constant  AMR2Zcst   :     std_logic_vector(23 downto 0):= X"999999";

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
end;
