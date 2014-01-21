
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
LIBRARY grlib;
USE grlib.amba.ALL;
USE grlib.stdlib.ALL;
--LIBRARY gaisler;
--USE gaisler.libdcom.ALL;
--USE gaisler.sim.ALL;
--USE gaisler.jtagtst.ALL;
--LIBRARY techmap;
--USE techmap.gencomp.ALL;


PACKAGE testbench_package IS


  PROCEDURE APB_WRITE (
    SIGNAL   clk    : IN  STD_LOGIC;
    CONSTANT pindex : IN  INTEGER;
    SIGNAL   apbi   : OUT apb_slv_in_type;
    CONSTANT paddr  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT pwdata : IN  STD_LOGIC_VECTOR(31 DOWNTO 0)
    );

END testbench_package;

PACKAGE BODY testbench_package IS

  PROCEDURE APB_WRITE (

    SIGNAL   clk    : IN  STD_LOGIC;
    CONSTANT pindex : IN  INTEGER;
    SIGNAL   apbi   : OUT apb_slv_in_type;
    CONSTANT paddr  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT pwdata : IN  STD_LOGIC_VECTOR(31 DOWNTO 0)
    ) IS
  BEGIN
    apbi.psel(pindex) <= '1';
    apbi.pwrite       <= '1';
    apbi.penable      <= '1';
    apbi.paddr        <= paddr;
    apbi.pwdata       <= pwdata;
    WAIT UNTIL clk = '1';
    apbi.psel(pindex) <= '0';
    apbi.pwrite       <= '0';
    apbi.penable      <= '0';
    apbi.paddr        <= (OTHERS => '0');
    apbi.pwdata       <= (OTHERS => '0');
    
  END APB_WRITE;

END testbench_package;
