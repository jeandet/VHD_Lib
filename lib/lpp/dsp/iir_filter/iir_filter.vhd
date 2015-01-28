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
----------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
LIBRARY grlib;
USE grlib.amba.ALL;
USE grlib.stdlib.ALL;
USE grlib.devices.ALL;




PACKAGE iir_filter IS


--===========================================================|
--================A L U   C O N T R O L======================|
--===========================================================|
  CONSTANT IDLE                : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
  CONSTANT MAC_op              : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0001";
  CONSTANT MULT                : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0010";
  CONSTANT ADD                 : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0011";
  CONSTANT clr_mac             : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0100";
  CONSTANT MULT_with_clear_ADD : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0101";

--____
--RAM |
--____|
  CONSTANT use_RAM : INTEGER := 1;
  CONSTANT use_CEL : INTEGER := 0;


--===========================================================|
--=============C O E F S ====================================|
--===========================================================|
--  create a specific type of data for coefs to avoid errors |
--===========================================================|

  TYPE scaleValT IS ARRAY(NATURAL RANGE <>) OF INTEGER;

  TYPE samplT IS ARRAY(NATURAL RANGE <>, NATURAL RANGE <>) OF STD_LOGIC;

  TYPE in_IIR_CEL_reg IS RECORD
    config  : STD_LOGIC_VECTOR(31 DOWNTO 0);
    virgPos : STD_LOGIC_VECTOR(4 DOWNTO 0);
  END RECORD;

  TYPE out_IIR_CEL_reg IS RECORD
    config : STD_LOGIC_VECTOR(31 DOWNTO 0);
    status : STD_LOGIC_VECTOR(31 DOWNTO 0);
  END RECORD;


  COMPONENT APB_IIR_CEL IS
    GENERIC (
      tech          : INTEGER := 0;
      pindex        : INTEGER := 0;
      paddr         : INTEGER := 0;
      pmask         : INTEGER := 16#fff#;
      pirq          : INTEGER := 0;
      abits         : INTEGER := 8;
      Sample_SZ     : INTEGER := 16;
      ChanelsCount  : INTEGER := 6;
      Coef_SZ       : INTEGER := 9;
      CoefCntPerCel : INTEGER := 6;
      Cels_count    : INTEGER := 5;
      virgPos       : INTEGER := 7;
      Mem_use       : INTEGER := use_RAM
      );
    PORT (
      rst            : IN  STD_LOGIC;
      clk            : IN  STD_LOGIC;
      apbi           : IN  apb_slv_in_type;
      apbo           : OUT apb_slv_out_type;
      sample_clk     : IN  STD_LOGIC;
      sample_clk_out : OUT STD_LOGIC;
      sample_in      : IN  samplT(ChanelsCount-1 DOWNTO 0, Sample_SZ-1 DOWNTO 0);
      sample_out     : OUT samplT(ChanelsCount-1 DOWNTO 0, Sample_SZ-1 DOWNTO 0);
      CoefsInitVal   : IN  STD_LOGIC_VECTOR((Cels_count*CoefCntPerCel*Coef_SZ)-1 DOWNTO 0) := (OTHERS => '1')
      );
  END COMPONENT;


  COMPONENT Top_IIR IS
    GENERIC(
      Sample_SZ     : INTEGER := 18;
      ChanelsCount  : INTEGER := 1;
      Coef_SZ       : INTEGER := 9;
      CoefCntPerCel : INTEGER := 6;
      Cels_count    : INTEGER := 5);
    PORT(
      reset      : IN  STD_LOGIC;
      clk        : IN  STD_LOGIC;
      sample_clk : IN  STD_LOGIC;
      --       BP : in std_logic;
      --       BPinput       :   in std_logic_vector(3 downto 0);
      LVLinput   : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
      INsample   : OUT samplT(ChanelsCount-1 DOWNTO 0, Sample_SZ-1 DOWNTO 0);
      OUTsample  : OUT samplT(ChanelsCount-1 DOWNTO 0, Sample_SZ-1 DOWNTO 0)
      ); 
  END COMPONENT;

  COMPONENT IIR_CEL_CTRLR_v2
    GENERIC (
      tech          : INTEGER;
      Mem_use       : INTEGER;
      Sample_SZ     : INTEGER;
      Coef_SZ       : INTEGER;
      Coef_Nb       : INTEGER;
      Coef_sel_SZ   : INTEGER;
      Cels_count    : INTEGER;
      ChanelsCount  : INTEGER);
    PORT (
      rstn          : IN  STD_LOGIC;
      clk            : IN  STD_LOGIC;
      virg_pos       : IN  INTEGER;
      coefs          : IN  STD_LOGIC_VECTOR((Coef_SZ*Coef_Nb)-1 DOWNTO 0);
      sample_in_val  : IN  STD_LOGIC;
      sample_in      : IN  samplT(ChanelsCount-1 DOWNTO 0, Sample_SZ-1 DOWNTO 0);
      sample_out_val : OUT  STD_LOGIC;
      sample_out     : OUT samplT(ChanelsCount-1 DOWNTO 0, Sample_SZ-1 DOWNTO 0));
  END COMPONENT;

  COMPONENT IIR_CEL_CTRLR_v3
    GENERIC (
      tech         : INTEGER;
      Mem_use      : INTEGER;
      Sample_SZ    : INTEGER;
      Coef_SZ      : INTEGER;
      Coef_Nb      : INTEGER;
      Coef_sel_SZ  : INTEGER;
      Cels_count   : INTEGER;
      ChanelsCount : INTEGER);
    PORT (
      rstn            : IN  STD_LOGIC;
      clk             : IN  STD_LOGIC;
      virg_pos        : IN  INTEGER;
      coefs           : IN  STD_LOGIC_VECTOR((Coef_SZ*Coef_Nb)-1 DOWNTO 0);
      sample_in1_val  : IN  STD_LOGIC;
      sample_in1      : IN  samplT(ChanelsCount-1 DOWNTO 0, Sample_SZ-1 DOWNTO 0);
      sample_in2_val  : IN  STD_LOGIC;
      sample_in2      : IN  samplT(ChanelsCount-1 DOWNTO 0, Sample_SZ-1 DOWNTO 0);
      sample_out1_val : OUT STD_LOGIC;
      sample_out1     : OUT samplT(ChanelsCount-1 DOWNTO 0, Sample_SZ-1 DOWNTO 0);
      sample_out2_val : OUT STD_LOGIC;
      sample_out2     : OUT samplT(ChanelsCount-1 DOWNTO 0, Sample_SZ-1 DOWNTO 0));
  END COMPONENT;
  


  
--component  FilterCTRLR is
--port(
--    reset       :   in  std_logic;
--    clk         :   in  std_logic;
--    sample_clk  :   in  std_logic;
--    ALU_Ctrl    :   out std_logic_vector(3 downto 0);
--    sample_in   :   in  samplT;
--    coef        :   out std_logic_vector(Coef_SZ-1 downto 0);
--    sample      :   out std_logic_vector(Smpl_SZ-1 downto 0)
--);
--end component;


--component  FILTER_RAM_CTRLR is
--port(
--    reset       :   in  std_logic;
--    clk         :   in  std_logic;
--    run         :   in  std_logic;
--    GO_0        :   in  std_logic;
--    B_A         :   in  std_logic;
--    writeForce  :   in  std_logic;
--    next_blk    :   in  std_logic;
--    sample_in   :   in  std_logic_vector(Smpl_SZ-1 downto 0);
--    sample_out  :   out std_logic_vector(Smpl_SZ-1 downto 0)
--);
--end component;


  COMPONENT IIR_CEL_CTRLR IS
    GENERIC(
      tech          : INTEGER := 0;
      Sample_SZ     : INTEGER := 16;
      ChanelsCount  : INTEGER := 1;
      Coef_SZ       : INTEGER := 9;
      CoefCntPerCel : INTEGER := 3;
      Cels_count    : INTEGER := 5;
      Mem_use       : INTEGER := use_RAM
      );
    PORT(
      reset      : IN  STD_LOGIC;
      clk        : IN  STD_LOGIC;
      sample_clk : IN  STD_LOGIC;
      sample_in  : IN  samplT(ChanelsCount-1 DOWNTO 0, Sample_SZ-1 DOWNTO 0);
      sample_out : OUT samplT(ChanelsCount-1 DOWNTO 0, Sample_SZ-1 DOWNTO 0);
      virg_pos   : IN  INTEGER;
      GOtest     : OUT STD_LOGIC;
      coefs      : IN  STD_LOGIC_VECTOR(Coef_SZ*CoefCntPerCel*Cels_count-1 DOWNTO 0)
      );
  END COMPONENT;


  COMPONENT RAM IS
    GENERIC(
      Input_SZ_1 : INTEGER := 8
      );
    PORT(WD                                           : IN STD_LOGIC_VECTOR(Input_SZ_1-1 DOWNTO 0); RD : OUT
    STD_LOGIC_VECTOR(Input_SZ_1-1 DOWNTO 0); WEN, REN : IN STD_LOGIC;
    WADDR                                             : IN STD_LOGIC_VECTOR(7 DOWNTO 0); RADDR : IN
    STD_LOGIC_VECTOR(7 DOWNTO 0); RWCLK, RESET        : IN STD_LOGIC
          ) ;
  END COMPONENT;

COMPONENT RAM_CEL is
    generic(DataSz        :   integer range 1 to 32 := 8;
            abits         :   integer range 2 to 12 := 8);
    port( WD : in std_logic_vector(DataSz-1 downto 0); RD : out
        std_logic_vector(DataSz-1 downto 0);WEN, REN : in std_logic;
        WADDR : in std_logic_vector(abits-1 downto 0); RADDR : in 
        std_logic_vector(abits-1 downto 0);RWCLK, RESET : in std_logic
        ) ;
end COMPONENT;

  COMPONENT RAM_CEL_N
    GENERIC (
      size : INTEGER);
    PORT (
      WD           : IN  STD_LOGIC_VECTOR(size-1 DOWNTO 0);
      RD           : OUT STD_LOGIC_VECTOR(size-1 DOWNTO 0);
      WEN, REN     : IN  STD_LOGIC;
      WADDR        : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
      RADDR        : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
      RWCLK, RESET : IN  STD_LOGIC);
  END COMPONENT;

  COMPONENT IIR_CEL_FILTER IS
    GENERIC(
      tech          : INTEGER := 0;
      Sample_SZ     : INTEGER := 16;
      ChanelsCount  : INTEGER := 1;
      Coef_SZ       : INTEGER := 9;
      CoefCntPerCel : INTEGER := 3;
      Cels_count    : INTEGER := 5;
      Mem_use       : INTEGER := use_RAM);
    PORT(
      reset      : IN  STD_LOGIC;
      clk        : IN  STD_LOGIC;
      sample_clk : IN  STD_LOGIC;
      regs_in    : IN  in_IIR_CEL_reg;
      regs_out   : IN  out_IIR_CEL_reg;
      sample_in  : IN  samplT(ChanelsCount-1 DOWNTO 0, Sample_SZ-1 DOWNTO 0);
      sample_out : OUT samplT(ChanelsCount-1 DOWNTO 0, Sample_SZ-1 DOWNTO 0);
      GOtest     : OUT STD_LOGIC;
      coefs      : IN  STD_LOGIC_VECTOR(Coef_SZ*CoefCntPerCel*Cels_count-1 DOWNTO 0)

      );
  END COMPONENT;


  COMPONENT RAM_CTRLR2 IS
    GENERIC(
      tech       : INTEGER := 0;
      Input_SZ_1 : INTEGER := 16;
      Mem_use    : INTEGER := use_RAM
      );
    PORT(
      reset      : IN  STD_LOGIC;
      clk        : IN  STD_LOGIC;
      WD_sel     : IN  STD_LOGIC;
      Read       : IN  STD_LOGIC;
      WADDR_sel  : IN  STD_LOGIC;
      count      : IN  STD_LOGIC;
      SVG_ADDR   : IN  STD_LOGIC;
      Write      : IN  STD_LOGIC;
      GO_0       : IN  STD_LOGIC;
      sample_in  : IN  STD_LOGIC_VECTOR(Input_SZ_1-1 DOWNTO 0);
      sample_out : OUT STD_LOGIC_VECTOR(Input_SZ_1-1 DOWNTO 0)
      );
  END COMPONENT;

  COMPONENT APB_IIR_Filter IS
    GENERIC (
      tech          : INTEGER := 0;
      pindex        : INTEGER := 0;
      paddr         : INTEGER := 0;
      pmask         : INTEGER := 16#fff#;
      pirq          : INTEGER := 0;
      abits         : INTEGER := 8;
      Sample_SZ     : INTEGER := 16;
      ChanelsCount  : INTEGER := 1;
      Coef_SZ       : INTEGER := 9;
      CoefCntPerCel : INTEGER := 6;
      Cels_count    : INTEGER := 5;
      virgPos       : INTEGER := 3;
      Mem_use       : INTEGER := use_RAM
      );
    PORT (
      rst            : IN  STD_LOGIC;
      clk            : IN  STD_LOGIC;
      apbi           : IN  apb_slv_in_type;
      apbo           : OUT apb_slv_out_type;
      sample_clk_out : OUT STD_LOGIC;
      GOtest         : OUT STD_LOGIC;
      CoefsInitVal   : IN  STD_LOGIC_VECTOR((Cels_count*CoefCntPerCel*Coef_SZ)-1 DOWNTO 0) := (OTHERS => '1')
      );
  END COMPONENT;
END;
