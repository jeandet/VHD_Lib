
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
LIBRARY grlib;
USE grlib.amba.ALL;
USE grlib.stdlib.ALL;


PACKAGE testbench_package IS

  COMPONENT tb_memory
    GENERIC (
      n_ahb_m : INTEGER;
      n_ahb_s : INTEGER);
    PORT (
      clk   : IN  STD_LOGIC;
      rstn  : IN  STD_LOGIC;
      ahbsi : OUT ahb_slv_in_type;
      ahbso : IN  ahb_slv_out_vector := (OTHERS => ahbs_none);
      ahbmi : OUT ahb_mst_in_type;
      ahbmo : IN  ahb_mst_out_vector := (OTHERS => ahbm_none));
  END COMPONENT;

  
  PROCEDURE APB_WRITE (
    SIGNAL   clk    : IN  STD_LOGIC;
    CONSTANT pindex : IN  INTEGER;
    SIGNAL   apbi   : OUT apb_slv_in_type;
    CONSTANT paddr  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT pwdata : IN  STD_LOGIC_VECTOR(31 DOWNTO 0)
    );

  PROCEDURE APB_READ (
    SIGNAL   clk    : IN  STD_LOGIC;
    CONSTANT pindex : IN  INTEGER;
    SIGNAL   apbi   : OUT apb_slv_in_type;
    SIGNAL   apbo   : IN  apb_slv_out_type;
    CONSTANT paddr  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL   prdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );

  PROCEDURE AHB_READ (
    SIGNAL   clk    : IN  STD_LOGIC;
    CONSTANT hindex : IN  INTEGER;
    SIGNAL   ahbmi  : IN  ahb_mst_in_type;
    SIGNAL   ahbmo  : OUT ahb_mst_out_type;
    CONSTANT haddr  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL   hrdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
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
    WAIT UNTIL clk = '0';
    WAIT UNTIL clk = '1';
    apbi.psel(pindex) <= '0';
    apbi.pwrite       <= '0';
    apbi.penable      <= '0';
    apbi.paddr        <= (OTHERS => '0');
    apbi.pwdata       <= (OTHERS => '0');
    WAIT UNTIL clk = '0';
    WAIT UNTIL clk = '1';
    
  END APB_WRITE;

  PROCEDURE APB_READ (
    SIGNAL   clk    : IN  STD_LOGIC;
    CONSTANT pindex : IN  INTEGER;
    SIGNAL   apbi   : OUT apb_slv_in_type;
    SIGNAL   apbo   : IN  apb_slv_out_type;
    CONSTANT paddr  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL   prdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    ) IS
  BEGIN
    apbi.psel(pindex) <= '1';
    apbi.pwrite       <= '0';
    apbi.penable      <= '1';
    apbi.paddr        <= paddr;
    WAIT UNTIL clk = '0';
    WAIT UNTIL clk = '1';
    apbi.psel(pindex) <= '0';
    apbi.pwrite       <= '0';
    apbi.penable      <= '0';
    apbi.paddr        <= (OTHERS => '0');
    WAIT UNTIL clk = '0';
    WAIT UNTIL clk = '1';
    prdata            <= apbo.prdata;
  END APB_READ;

  PROCEDURE AHB_READ (
    SIGNAL   clk    : IN  STD_LOGIC;
    CONSTANT hindex : IN  INTEGER;
    SIGNAL   ahbmi  : IN  ahb_mst_in_type;
    SIGNAL   ahbmo  : OUT ahb_mst_out_type;
    CONSTANT haddr  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL   hrdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    ) IS
  BEGIN
    WAIT UNTIL clk = '1';
    ahbmo.HADDR   <= haddr;
    ahbmo.HPROT   <= "0011";
    ahbmo.HIRQ    <= (OTHERS => '0');
    ahbmo.HCONFIG <= (0      => (OTHERS => '0'), OTHERS => (OTHERS => '0'));
    ahbmo.HINDEX  <= hindex;
    ahbmo.HBUSREQ <= '1';
    ahbmo.HLOCK   <= '1';
    ahbmo.HSIZE   <= HSIZE_WORD;
    ahbmo.HBURST  <= HBURST_SINGLE;
    ahbmo.HTRANS  <= HTRANS_NONSEQ;
    ahbmo.HWRITE  <= '0';
    WHILE ahbmi.HREADY = '0' LOOP
      WAIT UNTIL clk = '1';
    END LOOP;
    WAIT UNTIL clk = '1';
    --WAIT UNTIL clk = '1' AND ahbmi.HREADY = '1' AND ahbmi.HGRANT(hindex) = '1';
    ahbmo.HBUSREQ <= '0';
    ahbmo.HLOCK   <= '0';
    ahbmo.HTRANS  <= HTRANS_IDLE;
    WHILE ahbmi.HREADY = '0' LOOP
      WAIT UNTIL clk = '1';
    END LOOP;
    WAIT UNTIL clk = '1';
    hrdata        <= ahbmi.HRDATA;
    --WAIT UNTIL clk = '1' AND ahbmi.HREADY = '1' AND ahbmi.HGRANT(hindex) = '1';
    ahbmo.HLOCK   <= '0';
    WAIT UNTIL clk = '1';
    
  END AHB_READ;

END testbench_package;
