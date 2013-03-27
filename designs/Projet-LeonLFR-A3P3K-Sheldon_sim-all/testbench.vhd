------------------------------------------------------------------------------
--  LEON3 Demonstration design test bench
--  Copyright (C) 2004 Jiri Gaisler, Gaisler Research
------------------------------------------------------------------------------
--  This file is a part of the GRLIB VHDL IP LIBRARY
--  Copyright (C) 2003 - 2008, Gaisler Research
--  Copyright (C) 2008 - 2010, Aeroflex Gaisler
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
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
------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
LIBRARY grlib;
USE grlib.stdlib.ALL;
LIBRARY gaisler;
USE gaisler.libdcom.ALL;
USE gaisler.sim.ALL;
USE gaisler.jtagtst.ALL;
LIBRARY techmap;
USE techmap.gencomp.ALL;
LIBRARY micron;
USE micron.components.ALL;
USE work.debug.ALL;

USE work.config.ALL;                    -- configuration

ENTITY testbench IS
  GENERIC (
    fabtech : INTEGER := CFG_FABTECH;
    memtech : INTEGER := CFG_MEMTECH;
    padtech : INTEGER := CFG_PADTECH;
    clktech : INTEGER := CFG_CLKTECH;
    ncpu    : INTEGER := CFG_NCPU;
    disas   : INTEGER := CFG_DISAS;     -- Enable disassembly to console
    dbguart : INTEGER := CFG_DUART;     -- Print UART on console
    pclow   : INTEGER := CFG_PCLOW;

    clkperiod : INTEGER := 20;          -- system clock period
    romwidth  : INTEGER := 32;          -- rom data width (8/32)
    romdepth  : INTEGER := 16;          -- rom address depth
    sramwidth : INTEGER := 32;          -- ram data width (8/16/32)
    sramdepth : INTEGER := 21;          -- ram address depth
    srambanks : INTEGER := 2            -- number of ram banks
    );
  PORT (
    pci_rst    : INOUT STD_LOGIC;       -- PCI bus
    pci_clk    : IN    STD_ULOGIC;
    pci_gnt    : IN    STD_ULOGIC;
    pci_idsel  : IN    STD_ULOGIC;
    pci_lock   : INOUT STD_ULOGIC;
    pci_ad     : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    pci_cbe    : INOUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    pci_frame  : INOUT STD_ULOGIC;
    pci_irdy   : INOUT STD_ULOGIC;
    pci_trdy   : INOUT STD_ULOGIC;
    pci_devsel : INOUT STD_ULOGIC;
    pci_stop   : INOUT STD_ULOGIC;
    pci_perr   : INOUT STD_ULOGIC;
    pci_par    : INOUT STD_ULOGIC;
    pci_req    : INOUT STD_ULOGIC;
    pci_serr   : INOUT STD_ULOGIC;
    pci_host   : IN    STD_ULOGIC;
    pci_66     : IN    STD_ULOGIC
    );
END;

ARCHITECTURE behav OF testbench IS

  CONSTANT promfile  : STRING := "prom.srec";   -- rom contents
  CONSTANT sramfile  : STRING := "sram.srec";   -- ram contents
  CONSTANT sdramfile : STRING := "sdram.srec";  -- sdram contents

  COMPONENT leon3mp
    GENERIC (
      fabtech : INTEGER := CFG_FABTECH;
      memtech : INTEGER := CFG_MEMTECH;
      padtech : INTEGER := CFG_PADTECH;
      clktech : INTEGER := CFG_CLKTECH;
      disas   : INTEGER := CFG_DISAS;   -- Enable disassembly to console
      dbguart : INTEGER := CFG_DUART;   -- Print UART on console
      pclow   : INTEGER := CFG_PCLOW
      );
    PORT (
      resetn  : IN    STD_ULOGIC;
      clk     : IN    STD_ULOGIC;
      pllref  : IN    STD_ULOGIC;
      errorn  : OUT   STD_ULOGIC;
      address : OUT   STD_LOGIC_VECTOR(27 DOWNTO 0);
      data    : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      dsutx   : OUT   STD_ULOGIC;       -- DSU tx data
      dsurx   : IN    STD_ULOGIC;       -- DSU rx data
      dsuen   : IN    STD_ULOGIC;
      dsubre  : IN    STD_ULOGIC;
      dsuact  : OUT   STD_ULOGIC;
      txd1    : OUT   STD_ULOGIC;       -- UART1 tx data
      rxd1    : IN    STD_ULOGIC;       -- UART1 rx data
      txd2    : OUT   STD_ULOGIC;       -- UART1 tx data
      rxd2    : IN    STD_ULOGIC;       -- UART1 rx data
      ramsn   : OUT   STD_LOGIC_VECTOR (4 DOWNTO 0);
      ramoen  : OUT   STD_LOGIC_VECTOR (4 DOWNTO 0);
      rwen    : OUT   STD_LOGIC_VECTOR (3 DOWNTO 0);
      oen     : OUT   STD_ULOGIC;
      writen  : OUT   STD_ULOGIC;
      read    : OUT   STD_ULOGIC;
      iosn    : OUT   STD_ULOGIC;
      romsn   : OUT   STD_LOGIC_VECTOR (1 DOWNTO 0);
      gpio    : INOUT STD_LOGIC_VECTOR(CFG_GRGPIO_WIDTH-1 DOWNTO 0);  -- I/O port


      emddis  : OUT STD_LOGIC;
      epwrdwn : OUT STD_LOGIC;
      ereset  : OUT STD_LOGIC;
      esleep  : OUT STD_LOGIC;
      epause  : OUT STD_LOGIC;

      pci_rst     : INOUT STD_LOGIC;    -- PCI bus
      pci_clk     : IN    STD_ULOGIC;
      pci_gnt     : IN    STD_ULOGIC;
      pci_idsel   : IN    STD_ULOGIC;
      pci_lock    : INOUT STD_ULOGIC;
      pci_ad      : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      pci_cbe     : INOUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      pci_frame   : INOUT STD_ULOGIC;
      pci_irdy    : INOUT STD_ULOGIC;
      pci_trdy    : INOUT STD_ULOGIC;
      pci_devsel  : INOUT STD_ULOGIC;
      pci_stop    : INOUT STD_ULOGIC;
      pci_perr    : INOUT STD_ULOGIC;
      pci_par     : INOUT STD_ULOGIC;
      pci_req     : INOUT STD_ULOGIC;
      pci_serr    : INOUT STD_ULOGIC;
      pci_host    : IN    STD_ULOGIC;
      pci_66      : IN    STD_ULOGIC;
      pci_arb_req : IN    STD_LOGIC_VECTOR(0 TO 3);
      pci_arb_gnt : OUT   STD_LOGIC_VECTOR(0 TO 3);

      spw_clk       : IN  STD_ULOGIC;
      spw_rxd       : IN  STD_LOGIC_VECTOR(0 TO 2);
      spw_rxdn      : IN  STD_LOGIC_VECTOR(0 TO 2);
      spw_rxs       : IN  STD_LOGIC_VECTOR(0 TO 2);
      spw_rxsn      : IN  STD_LOGIC_VECTOR(0 TO 2);
      spw_txd       : OUT STD_LOGIC_VECTOR(0 TO 2);
      spw_txdn      : OUT STD_LOGIC_VECTOR(0 TO 2);
      spw_txs       : OUT STD_LOGIC_VECTOR(0 TO 2);
      spw_txsn      : OUT STD_LOGIC_VECTOR(0 TO 2);

    ramclk : OUT STD_LOGIC; 

    nBWa        : out std_logic;
    nBWb        : out std_logic;
    nBWc        : out std_logic;
    nBWd        : out std_logic;
    nBWE        : out std_logic;
    nADSC       : out std_logic;
    nADSP       : out std_logic;
    nADV        : out std_logic;
    nGW         : out std_logic;
    nCE1        : out std_logic;
    CE2         : out std_logic;
    nCE3        : out std_logic;
    nOE         : out std_logic;		
    MODE        : out std_logic;        
    SSRAM_CLK   : out std_logic;
    ZZ          : out std_logic;
    
      tck, tms, tdi : IN  STD_ULOGIC;
      tdo           : OUT STD_ULOGIC

      );
  END COMPONENT;

  COMPONENT CY7C1360C
    GENERIC (
      addr_bits : INTEGER;
      data_bits : INTEGER;
      Cyp_tCO   : TIME;
      Cyp_tCYC  : TIME;
      Cyp_tCH   : TIME;
      Cyp_tCL   : TIME;
      Cyp_tCHZ  : TIME;
      Cyp_tCLZ  : TIME;
      Cyp_tOEHZ : TIME;
      Cyp_tOELZ : TIME;
      Cyp_tOEV  : TIME;
      Cyp_tAS   : TIME;
      Cyp_tADS  : TIME;
      Cyp_tADVS : TIME;
      Cyp_tWES  : TIME;
      Cyp_tDS   : TIME;
      Cyp_tCES  : TIME;
      Cyp_tAH   : TIME;
      Cyp_tADH  : TIME;
      Cyp_tADVH : TIME;
      Cyp_tWEH  : TIME;
      Cyp_tDH   : TIME;
      Cyp_tCEH  : TIME);
    PORT (
      iZZ    : IN    STD_LOGIC;
      iMode  : IN    STD_LOGIC;
      iADDR  : IN    STD_LOGIC_VECTOR ((addr_bits -1) downto 0);
      inGW   : IN    STD_LOGIC;
      inBWE  : IN    STD_LOGIC;
      inBWd  : IN    STD_LOGIC;
      inBWc  : IN    STD_LOGIC;
      inBWb  : IN    STD_LOGIC;
      inBWa  : IN    STD_LOGIC;
      inCE1  : IN    STD_LOGIC;
      iCE2   : IN    STD_LOGIC;
      inCE3  : IN    STD_LOGIC;
      inADSP : IN    STD_LOGIC;
      inADSC : IN    STD_LOGIC;
      inADV  : IN    STD_LOGIC;
      inOE   : IN    STD_LOGIC;
      ioDQ   : INOUT STD_LOGIC_VECTOR ((data_bits-1) downto 0);
      iCLK   : IN    STD_LOGIC);
  END COMPONENT;

  
  SIGNAL   clk : STD_LOGIC := '0';
  SIGNAL   Rst : STD_LOGIC := '0';      -- Reset
  CONSTANT ct  : INTEGER   := clkperiod/2;

  SIGNAL address : STD_LOGIC_VECTOR(27 DOWNTO 0);
  SIGNAL data    : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL ioData  : STD_LOGIC_VECTOR(35 DOWNTO 0);

  SIGNAL ramsn                               : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL ramoen                              : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL rwen                                : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL rwenx                               : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL romsn                               : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL iosn                                : STD_ULOGIC;
  SIGNAL oen                                 : STD_ULOGIC;
  SIGNAL read                                : STD_ULOGIC;
  SIGNAL writen                              : STD_ULOGIC;
  SIGNAL brdyn                               : STD_ULOGIC;
  SIGNAL bexcn                               : STD_ULOGIC;
  SIGNAL wdog                                : STD_ULOGIC;
  SIGNAL dsuen, dsutx, dsurx, dsubre, dsuact : STD_ULOGIC;
  SIGNAL dsurst                              : STD_ULOGIC;
  SIGNAL test                                : STD_ULOGIC;
  SIGNAL error                               : STD_LOGIC;
  SIGNAL gpio                                : STD_LOGIC_VECTOR(CFG_GRGPIO_WIDTH-1 DOWNTO 0);
  SIGNAL GND                                 : STD_ULOGIC := '0';
  SIGNAL VCC                                 : STD_ULOGIC := '1';
  SIGNAL NC                                  : STD_ULOGIC := 'Z';
  SIGNAL clk2                                : STD_ULOGIC := '1';

  SIGNAL sdcke      : STD_LOGIC_VECTOR (1 DOWNTO 0);  -- clk en
  SIGNAL sdcsn      : STD_LOGIC_VECTOR (1 DOWNTO 0);  -- chip sel
  SIGNAL sdwen      : STD_ULOGIC;                     -- write en
  SIGNAL sdrasn     : STD_ULOGIC;                     -- row addr stb
  SIGNAL sdcasn     : STD_ULOGIC;                     -- col addr stb
  SIGNAL sddqm      : STD_LOGIC_VECTOR (7 DOWNTO 0);  -- data i/o mask
  SIGNAL sdclk      : STD_ULOGIC;
  SIGNAL plllock    : STD_ULOGIC;
  SIGNAL txd1, rxd1 : STD_ULOGIC;
  SIGNAL txd2, rxd2 : STD_ULOGIC;

  SIGNAL etx_clk, erx_clk, erx_dv, erx_er, erx_col, erx_crs, etx_en, etx_er : STD_LOGIC                    := '0';
  SIGNAL erxd, etxd                                                         : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
  SIGNAL erxdt, etxdt                                                       : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
  SIGNAL emdc                                                      : STD_LOGIC;
  SIGNAL gtx_clk                                                            : STD_ULOGIC;

  SIGNAL emddis  : STD_LOGIC;
  SIGNAL epwrdwn : STD_LOGIC;
  SIGNAL ereset  : STD_LOGIC;
  SIGNAL esleep  : STD_LOGIC;
  SIGNAL epause  : STD_LOGIC;

  CONSTANT lresp : BOOLEAN := false;

  SIGNAL sa : STD_LOGIC_VECTOR(14 DOWNTO 0);
  SIGNAL sd : STD_LOGIC_VECTOR(63 DOWNTO 0);

  SIGNAL pci_arb_req, pci_arb_gnt : STD_LOGIC_VECTOR(0 TO 3);


  SIGNAL spw_clk  : STD_ULOGIC               := '0';
  SIGNAL spw_rxd  : STD_LOGIC_VECTOR(0 TO 2) := "000";
  SIGNAL spw_rxdn : STD_LOGIC_VECTOR(0 TO 2) := "000";
  SIGNAL spw_rxs  : STD_LOGIC_VECTOR(0 TO 2) := "000";
  SIGNAL spw_rxsn : STD_LOGIC_VECTOR(0 TO 2) := "000";
  SIGNAL spw_txd  : STD_LOGIC_VECTOR(0 TO 2);
  SIGNAL spw_txdn : STD_LOGIC_VECTOR(0 TO 2);
  SIGNAL spw_txs  : STD_LOGIC_VECTOR(0 TO 2);
  SIGNAL spw_txsn : STD_LOGIC_VECTOR(0 TO 2);

  SIGNAL tck, tms, tdi, tdo : STD_ULOGIC;

  CONSTANT CFG_SDEN : INTEGER := CFG_SDCTRL + CFG_MCTRL_SDEN;
  CONSTANT CFG_SD64 : INTEGER := CFG_SDCTRL_SD64 + CFG_MCTRL_SD64;

  -----------------------------------------------------------------------------
  
  SIGNAL ramclk :  STD_LOGIC; 
  
  SIGNAL nBWa        :  std_logic;
  SIGNAL nBWb        :  std_logic;
  SIGNAL nBWc        :  std_logic;
  SIGNAL nBWd        :  std_logic;
  SIGNAL nBWE        :  std_logic;
  SIGNAL nADSC       :  std_logic;
  SIGNAL nADSP       :  std_logic;
  SIGNAL nADV        :  std_logic;
  SIGNAL nGW         :  std_logic;
  SIGNAL nCE1        :  std_logic;
  SIGNAL CE2         :  std_logic;
  SIGNAL nCE3        :  std_logic;
  SIGNAL nOE         :  std_logic;		
  SIGNAL MODE        :  std_logic;        
  SIGNAL SSRAM_CLK   :  std_logic;
  SIGNAL ZZ          :  std_logic;
  

BEGIN

-- clock and reset

  spw_clk    <= NOT spw_clk AFTER 20 ns;
  spw_rxd(0) <= spw_txd(0); spw_rxdn(0) <= spw_txdn(0);
  spw_rxs(0) <= spw_txs(0); spw_rxsn(0) <= spw_txsn(0);
  spw_rxd(1) <= spw_txd(1); spw_rxdn(1) <= spw_txdn(1);
  spw_rxs(1) <= spw_txs(1); spw_rxsn(1) <= spw_txsn(1);
  spw_rxd(2) <= spw_txd(0); spw_rxdn(2) <= spw_txdn(2);
  spw_rxs(2) <= spw_txs(0); spw_rxsn(2) <= spw_txsn(2);
  clk        <= NOT clk     AFTER ct * 1 ns;
  rst        <= dsurst;
  dsuen      <= '1'; dsubre <= '0'; rxd1 <= '1';

  d3 : leon3mp
    GENERIC MAP (fabtech,
                 memtech,
                 padtech,
                 clktech,
                 disas,
                 dbguart,
                 pclow)
    PORT MAP (rst, clk, sdclk, error, address(27 DOWNTO 0), data,
              dsutx, dsurx, dsuen, dsubre, dsuact, txd1, rxd1, txd2, rxd2,
              ramsn, ramoen, rwen, oen, writen, read, iosn, romsn, gpio,
             
              emddis, epwrdwn, ereset, esleep, epause,
              pci_rst, pci_clk, pci_gnt, pci_idsel, pci_lock, pci_ad, pci_cbe,
              pci_frame, pci_irdy, pci_trdy, pci_devsel, pci_stop, pci_perr, pci_par,
              pci_req, pci_serr, pci_host, pci_66, pci_arb_req, pci_arb_gnt,
              spw_clk, spw_rxd, spw_rxdn, spw_rxs,
              spw_rxsn, spw_txd, spw_txdn, spw_txs, spw_txsn,


  ramclk      , 
  
  nBWa        ,
  nBWb        ,
  nBWc        ,
  nBWd        ,
  nBWE        ,
  nADSC       ,
  nADSP       ,
  nADV        ,
  nGW         ,
  nCE1        ,
  CE2         ,
  nCE3        ,
  nOE         ,		
  MODE         ,       
  SSRAM_CLK   ,
  ZZ          ,
              


               tck, tms, tdi, tdo);

  -----------------------------------------------------------------------------

  prom0 : FOR i IN 0 TO (romwidth/8)-1 GENERATE
    sr0 : sram GENERIC MAP (index => i, abits => romdepth, fname => promfile)
      PORT MAP (address(romdepth+1 DOWNTO 2), data(31-i*8 DOWNTO 24-i*8), romsn(0),
                rwen(i), oen);
  END GENERATE;

  -----------------------------------------------------------------------------
  CY7C1360C_2: CY7C1360C
    GENERIC MAP (

      
      addr_bits =>  19,
      data_bits =>  36,

         Cyp_tCO   =>	3.5 ns,	-- Data Output Valid After CLK Rise
         Cyp_tCYC  =>	6.0 ns,  -- Clock cycle time
         Cyp_tCH   =>	2.4 ns,	-- Clock HIGH time
         Cyp_tCL   =>	2.4 ns,	-- Clock LOW time
         Cyp_tCHZ  =>	3.5 ns,	-- Clock to High-Z
         Cyp_tCLZ  =>	1.25 ns,	-- Clock to Low-Z
         Cyp_tOEHZ => 3.5 ns,	-- OE# HIGH to Output High-Z
         Cyp_tOELZ => 0.0 ns,	-- OE# LOW to Output Low-Z 
         Cyp_tOEV  => 3.5 ns,	-- OE# LOW to Output Valid 
         Cyp_tAS   => 1.5 ns,	-- Address Set-up Before CLK Rise
         Cyp_tADS  => 1.5 ns,	-- ADSC#, ADSP# Set-up Before CLK Rise
         Cyp_tADVS => 1.5 ns,	-- ADV# Set-up Before CLK Rise
         Cyp_tWES  =>	1.5 ns,	-- BWx#, GW#, BWE# Set-up Before CLK Rise
         Cyp_tDS   =>	1.5 ns,	-- Data Input Set-up Before CLK Rise
         Cyp_tCES  =>	1.5 ns,	-- Chip Enable Set-up 
         Cyp_tAH   => 0.5 ns,	-- Address Hold After CLK Rise
         Cyp_tADH  => 0.5 ns,	-- ADSC#, ADSP# Hold After CLK Rise
         Cyp_tADVH => 0.5 ns,	-- ADV# Hold After CLK Rise
         Cyp_tWEH  =>	0.5 ns,	-- BWx#, GW#, BWE# Hold After CLK Rise
         Cyp_tDH   => 0.5 ns,	-- Data Input Hold After CLK Rise
         Cyp_tCEH  => 0.5 ns	-- Chip Enable Hold After CLK Rise

      
      --Cyp_tCO   =>  2.8 ns,
      --Cyp_tCYC  =>  4.0 ns,
      --Cyp_tCH   =>  1.8 ns,
      --Cyp_tCL   =>  1.8 ns,
      --Cyp_tCHZ  =>  2.8 ns,     
      --Cyp_tCLZ  => 1.25 ns,     
      --Cyp_tOEHZ =>  2.8 ns,    
      --Cyp_tOELZ =>  0.0 ns,      
      --Cyp_tOEV  =>  2.8 ns,      
      --Cyp_tAS   =>  1.4 ns,      
      --Cyp_tADS  =>  1.4 ns,     
      --Cyp_tADVS =>  1.4 ns,    
      --Cyp_tWES  =>  1.4 ns,     
      --Cyp_tDS   =>  1.4 ns,   
      --Cyp_tCES  =>  1.4 ns,   
      --Cyp_tAH   =>  0.4 ns,   
      --Cyp_tADH  =>  0.4 ns,   
      --Cyp_tADVH =>  0.4 ns,   
      --Cyp_tWEH  =>  0.4 ns,   
      --Cyp_tDH   =>  0.4 ns,   
      --Cyp_tCEH  =>  0.4 ns
      )  
    PORT MAP ( 
      iZZ    => ZZ,
      iMode  => MODE,
      iADDR  => address(20 DOWNTO 2),
      inGW   => nGW,
      inBWE  => nBWE,
      inBWd  => nBWd,
      inBWc  => nBWc,
      inBWb  => nBWb,
      inBWa  => nBWa,
      inCE1  => nCE1,
      iCE2   => CE2,
      inCE3  => nCE3,
      inADSP => nADSP,
      inADSC => nADSC,
      inADV  => nADV,
      inOE   => nOE,
      ioDQ   => ioData,                    --
      iCLK   => SSRAM_CLK);             -- ??


    ioData <= "0" & data(31 DOWNTO 24) &
              "0" & data(23 DOWNTO 16) &
              "0" & data(15 DOWNTO  8) &
              "0" & data( 7 DOWNTO  0) ;
  
  --sbanks : FOR k IN 0 TO srambanks-1 GENERATE
  --  sram0 : FOR i IN 0 TO (sramwidth/8)-1 GENERATE
  --    sr0 : sram GENERIC MAP (index => i, abits => sramdepth, fname => sramfile)
  --      PORT MAP (address(sramdepth+1 DOWNTO 2), data(31-i*8 DOWNTO 24-i*8),
  --                ramsn(k), rwen(i), ramoen(k));
  --  END GENERATE;
  --END GENERATE;

  error <= 'H';                         -- ERROR pull-up

  iuerr : PROCESS
  BEGIN
    WAIT FOR 2500 ns;
    IF to_x01(error) = '1' THEN WAIT ON error; END IF;
    ASSERT (to_x01(error) = '1')
      REPORT "*** IU in error mode, simulation halted ***"
      SEVERITY failure;
  END PROCESS;

  data <= buskeep(data), (OTHERS => 'H') AFTER 250 ns;
  sd   <= buskeep(sd), (OTHERS   => 'H') AFTER 250 ns;

  test0 : grtestmod
    PORT MAP (rst, clk, error, address(21 DOWNTO 2), data, iosn, oen, writen, brdyn);


  dsucom : PROCESS
    PROCEDURE dsucfg(SIGNAL dsurx : IN STD_ULOGIC; SIGNAL dsutx : OUT STD_ULOGIC) IS
      VARIABLE w32 : STD_LOGIC_VECTOR(31 DOWNTO 0);
      VARIABLE c8  : STD_LOGIC_VECTOR(7 DOWNTO 0);
      CONSTANT txp : TIME := 160 * 1 ns;
    BEGIN
      dsutx  <= '1';
      dsurst <= '0';
      WAIT FOR 500 ns;
      dsurst <= '1';
      WAIT;
      WAIT FOR 5000 ns;
    END;
  BEGIN

    dsucfg(dsutx, dsurx);
    WAIT;

  END PROCESS;

END;
