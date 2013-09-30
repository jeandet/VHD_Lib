------------------------------------------------------------------------------
--  This file is a part of the LPP VHDL IP LIBRARY
--  Copyright (C) 2011, Laboratory of Plasmas Physic - CNRS
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
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
LIBRARY gaisler;
USE gaisler.misc.ALL;
USE gaisler.memctrl.ALL;
LIBRARY techmap;
USE techmap.gencomp.ALL;
USE techmap.allclkgen.ALL;




ENTITY ssram_plugin IS
  GENERIC (tech : INTEGER := 0);
  PORT
    (
      clk         : IN  STD_LOGIC;
      mem_ctrlr_o : IN  memory_out_type;
      SSRAM_CLK   : OUT STD_LOGIC;
      nBWa        : OUT STD_LOGIC;
      nBWb        : OUT STD_LOGIC;
      nBWc        : OUT STD_LOGIC;
      nBWd        : OUT STD_LOGIC;
      nBWE        : OUT STD_LOGIC;
      nADSC       : OUT STD_LOGIC;
      nADSP       : OUT STD_LOGIC;
      nADV        : OUT STD_LOGIC;
      nGW         : OUT STD_LOGIC;
      nCE1        : OUT STD_LOGIC;
      CE2         : OUT STD_LOGIC;
      nCE3        : OUT STD_LOGIC;
      nOE         : OUT STD_LOGIC;
      MODE        : OUT STD_LOGIC;
      ZZ          : OUT STD_LOGIC
      );
END ENTITY;






ARCHITECTURE ar_ssram_plugin OF ssram_plugin IS


  SIGNAL nADSPint  : STD_LOGIC := '1';
  SIGNAL nOEint    : STD_LOGIC := '1';
  SIGNAL RAMSN_reg : STD_LOGIC := '1';
  SIGNAL OEreg     : STD_LOGIC := '1';
  SIGNAL nBWaint   : STD_LOGIC := '1';
  SIGNAL nBWbint   : STD_LOGIC := '1';
  SIGNAL nBWcint   : STD_LOGIC := '1';
  SIGNAL nBWdint   : STD_LOGIC := '1';
  SIGNAL nBWEint   : STD_LOGIC := '1';
  SIGNAL nCE1int   : STD_LOGIC := '1';
  SIGNAL CE2int    : STD_LOGIC := '0';
  SIGNAL nCE3int   : STD_LOGIC := '1';

  TYPE   stateT IS (idle, st1, st2, st3, st4);
  SIGNAL state : stateT;

--SIGNAL nclk : STD_LOGIC;

BEGIN

  PROCESS(clk , mem_ctrlr_o.RAMSN(0))
  BEGIN
    IF mem_ctrlr_o.RAMSN(0) = '1' then
      state <= idle;
    ELSIF clk = '1' and clk'event then
      CASE state IS
        WHEN idle =>
          state <= st1;
        WHEN st1 =>
          state <= st2;
        WHEN st2 =>
          state <= st3;
        WHEN st3 =>
          state <= st4;
        WHEN st4 =>
          state <= st1;
      END CASE;
    END IF;
  END PROCESS;

  --nclk <= NOT clk;
  ssram_clk_pad : outpad GENERIC MAP (tech => tech)
    PORT MAP (SSRAM_CLK, NOT clk);


  nBWaint <= mem_ctrlr_o.WRN(3)OR mem_ctrlr_o.ramsn(0);
  nBWa_pad : outpad GENERIC MAP (tech => tech)
    PORT MAP (nBWa, nBWaint);

  nBWbint <= mem_ctrlr_o.WRN(2)OR mem_ctrlr_o.ramsn(0);
  nBWb_pad : outpad GENERIC MAP (tech => tech)
    PORT MAP (nBWb, nBWbint);

  nBWcint <= mem_ctrlr_o.WRN(1)OR mem_ctrlr_o.ramsn(0);
  nBWc_pad : outpad GENERIC MAP (tech => tech)
    PORT MAP (nBWc, nBWcint);

  nBWdint <= mem_ctrlr_o.WRN(0)OR mem_ctrlr_o.ramsn(0);
  nBWd_pad : outpad GENERIC MAP (tech => tech)
    PORT MAP (nBWd, nBWdint);

  nBWEint <= mem_ctrlr_o.WRITEN OR mem_ctrlr_o.ramsn(0);
  nBWE_pad : outpad GENERIC MAP (tech => tech)
    PORT MAP (nBWE, nBWEint);

  nADSC_pad : outpad GENERIC MAP (tech => tech)
    PORT MAP (nADSC, '1');

--nADSPint    <=  not((RAMSN_reg xor mem_ctrlr_o.RAMSN(0)) and RAMSN_reg);
  nADSPint <= '0' WHEN state = st1 ELSE '1';

  PROCESS(clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      RAMSN_reg <= mem_ctrlr_o.RAMSN(0);
    END IF;
  END PROCESS;

  nADSP_pad : outpad GENERIC MAP (tech => tech)
    PORT MAP (nADSP, nADSPint);

  nADV_pad : outpad GENERIC MAP (tech => tech)
    PORT MAP (nADV, '1');

  nGW_pad : outpad GENERIC MAP (tech => tech)
    PORT MAP (nGW, '1');

  nCE1int <= nADSPint OR mem_ctrlr_o.address(31) OR (NOT mem_ctrlr_o.address(30)) OR mem_ctrlr_o.address(29) OR mem_ctrlr_o.address(28);
  CE2int  <= (NOT mem_ctrlr_o.address(27)) AND (NOT mem_ctrlr_o.address(26)) AND (NOT mem_ctrlr_o.address(25)) AND (NOT mem_ctrlr_o.address(24));
  nCE3int <= mem_ctrlr_o.address(23) OR mem_ctrlr_o.address(22) OR mem_ctrlr_o.address(21) OR mem_ctrlr_o.address(20);

  nCE1_pad : outpad GENERIC MAP (tech => tech)
    PORT MAP (nCE1, nCE1int);

  CE2_pad : outpad GENERIC MAP (tech => tech)
    PORT MAP (CE2, CE2int);

  nCE3_pad : outpad GENERIC MAP (tech => tech)
    PORT MAP (nCE3, nCE3int);

  nOE_pad : outpad GENERIC MAP (tech => tech)
    PORT MAP (nOE, nOEint);

  PROCESS(clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      OEreg <= mem_ctrlr_o.OEN;
    END IF;
  END PROCESS;


--nOEint  <=  OEreg or mem_ctrlr_o.RAMOEN(0);   
  nOEint <= '0' WHEN state = st2 OR state = st3 OR state = st4 ELSE '1';

  MODE_pad : outpad GENERIC MAP (tech => tech)
    PORT MAP (MODE, '0');

  ZZ_pad : outpad GENERIC MAP (tech => tech)
    PORT MAP (ZZ, '0');

END ARCHITECTURE;