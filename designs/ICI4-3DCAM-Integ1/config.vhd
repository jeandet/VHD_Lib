


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
  
  
  
constant  WORD0cst     :     std_logic_vector(15 downto 0) := X"1111";
constant  WORD1cst     :     std_logic_vector(15 downto 0) := X"2222";
constant  WORD2cst     :     std_logic_vector(15 downto 0) := X"3333";
constant  WORD3cst     :     std_logic_vector(15 downto 0) := X"4444";
constant  WORD4cst     :     std_logic_vector(15 downto 0) := X"5555";
constant  WORD5cst     :     std_logic_vector(15 downto 0) := X"6666";
constant  WORD6cst     :     std_logic_vector(15 downto 0) := X"7777";
constant  WORD7cst     :     std_logic_vector(15 downto 0) := X"8888";
constant  WORD8cst     :     std_logic_vector(15 downto 0) := X"9999";
constant  WORD9cst     :     std_logic_vector(15 downto 0) := X"AAAA";
constant  WORD10cst    :     std_logic_vector(15 downto 0) := X"BBBB";
constant  WORD11cst    :     std_logic_vector(15 downto 0) := X"CCCC";
constant  WORD12cst    :     std_logic_vector(15 downto 0) := X"DDDD";


constant LF1cst :   std_logic_vector(15 downto 0) := X"1111";
constant LF2cst :   std_logic_vector(15 downto 0) := X"2222";
constant LF3cst :   std_logic_vector(15 downto 0) := X"3333";

end;
