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
--UPDATE
-------------------------------------------------------------------------------
-- 14-03-2013 - Jean-christophe Pellion
-- ADD MUXN (a parametric multiplexor (N stage of MUX2))
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;



PACKAGE general_purpose IS



  COMPONENT Clk_divider IS
    GENERIC(OSC_freqHz    : INTEGER := 50000000;
            TargetFreq_Hz : INTEGER := 50000);
    PORT (clk          : IN  STD_LOGIC;
           reset       : IN  STD_LOGIC;
           clk_divided : OUT STD_LOGIC);
  END COMPONENT;


  COMPONENT Clk_divider2 IS
    generic(N : integer := 16);
    port(
    clk_in  :   in  std_logic;
    clk_out :   out std_logic);
  END COMPONENT;

  COMPONENT Adder IS
    GENERIC(
      Input_SZ_A : INTEGER := 16;
      Input_SZ_B : INTEGER := 16

      );
    PORT(
      clk   : IN  STD_LOGIC;
      reset : IN  STD_LOGIC;
      clr   : IN  STD_LOGIC;
      load  : IN STD_LOGIC;
      add   : IN  STD_LOGIC;
      OP1   : IN  STD_LOGIC_VECTOR(Input_SZ_A-1 DOWNTO 0);
      OP2   : IN  STD_LOGIC_VECTOR(Input_SZ_B-1 DOWNTO 0);
      RES   : OUT STD_LOGIC_VECTOR(Input_SZ_A-1 DOWNTO 0)
      );
  END COMPONENT;

  COMPONENT ADDRcntr IS
    PORT(
      clk   : IN  STD_LOGIC;
      reset : IN  STD_LOGIC;
      count : IN  STD_LOGIC;
      clr   : IN  STD_LOGIC;
      Q     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
      );
  END COMPONENT;

  COMPONENT ALU IS
    GENERIC(
      Arith_en   : INTEGER := 1;
      Logic_en   : INTEGER := 1;
      Input_SZ_1 : INTEGER := 16;
      Input_SZ_2 : INTEGER := 9;
      COMP_EN    : INTEGER := 0 -- 1 =>  No Comp

      );
    PORT(
      clk   : IN  STD_LOGIC;
      reset : IN  STD_LOGIC;
      ctrl  : IN  STD_LOGIC_VECTOR(2 downto 0);
      comp  : IN  STD_LOGIC_VECTOR(1 downto 0);
      OP1   : IN  STD_LOGIC_VECTOR(Input_SZ_1-1 DOWNTO 0);
      OP2   : IN  STD_LOGIC_VECTOR(Input_SZ_2-1 DOWNTO 0);
      RES   : OUT STD_LOGIC_VECTOR(Input_SZ_1+Input_SZ_2-1 DOWNTO 0)
      );
  END COMPONENT;

---------------------------------------------------------
-------- // Sélection grace a l'entrée "ctrl" \\ --------
---------------------------------------------------------
Constant ctrl_IDLE   : std_logic_vector(2 downto 0) := "000";
Constant ctrl_MAC    : std_logic_vector(2 downto 0) := "001";
Constant ctrl_MULT   : std_logic_vector(2 downto 0) := "010";
Constant ctrl_ADD    : std_logic_vector(2 downto 0) := "011";
Constant ctrl_CLRMAC : std_logic_vector(2 downto 0) := "100";
---------------------------------------------------------

  COMPONENT MAC IS
    GENERIC(
      Input_SZ_A : INTEGER := 8;
      Input_SZ_B : INTEGER := 8;
      COMP_EN    : INTEGER := 0 -- 1 =>  No Comp
      );
    PORT(
      clk         : IN  STD_LOGIC;
      reset       : IN  STD_LOGIC;
      clr_MAC     : IN  STD_LOGIC;
      MAC_MUL_ADD : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
      Comp_2C     : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
      OP1         : IN  STD_LOGIC_VECTOR(Input_SZ_A-1 DOWNTO 0);
      OP2         : IN  STD_LOGIC_VECTOR(Input_SZ_B-1 DOWNTO 0);
      RES         : OUT STD_LOGIC_VECTOR(Input_SZ_A+Input_SZ_B-1 DOWNTO 0)
      );
  END COMPONENT;

  COMPONENT TwoComplementer is
  generic(
      Input_SZ : integer := 16);
  port(
      clk     : in  std_logic;                                --! Horloge du composant
      reset   : in  std_logic;                                --! Reset general du composant
      clr     : in  std_logic;                                --! Un reset spécifique au programme
      TwoComp : in  std_logic;                                --! Autorise l'utilisation du complément
      OP      : in  std_logic_vector(Input_SZ-1 downto 0);    --! Opérande d'entrée
      RES     : out std_logic_vector(Input_SZ-1 downto 0)     --! Résultat, opérande complémenté ou non
  );
  end COMPONENT;

  COMPONENT MAC_CONTROLER IS
    PORT(
      ctrl        : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
      MULT        : OUT STD_LOGIC;
      ADD         : OUT STD_LOGIC;
      LOAD_ADDER  : out std_logic;
      MACMUX_sel  : OUT STD_LOGIC;
      MACMUX2_sel : OUT STD_LOGIC
      );
  END COMPONENT;

  COMPONENT MAC_MUX IS
    GENERIC(
      Input_SZ_A : INTEGER := 16;
      Input_SZ_B : INTEGER := 16

      );
    PORT(
      sel  : IN  STD_LOGIC;
      INA1 : IN  STD_LOGIC_VECTOR(Input_SZ_A-1 DOWNTO 0);
      INA2 : IN  STD_LOGIC_VECTOR(Input_SZ_A-1 DOWNTO 0);
      INB1 : IN  STD_LOGIC_VECTOR(Input_SZ_B-1 DOWNTO 0);
      INB2 : IN  STD_LOGIC_VECTOR(Input_SZ_B-1 DOWNTO 0);
      OUTA : OUT STD_LOGIC_VECTOR(Input_SZ_A-1 DOWNTO 0);
      OUTB : OUT STD_LOGIC_VECTOR(Input_SZ_B-1 DOWNTO 0)
      );
  END COMPONENT;


  COMPONENT MAC_MUX2 IS
    GENERIC(Input_SZ : INTEGER := 16);
    PORT(
      sel  : IN  STD_LOGIC;
      RES1 : IN  STD_LOGIC_VECTOR(Input_SZ-1 DOWNTO 0);
      RES2 : IN  STD_LOGIC_VECTOR(Input_SZ-1 DOWNTO 0);
      RES  : OUT STD_LOGIC_VECTOR(Input_SZ-1 DOWNTO 0)
      );
  END COMPONENT;


  COMPONENT MAC_REG IS
    GENERIC(size : INTEGER := 16);
    PORT(
      reset : IN  STD_LOGIC;
      clk   : IN  STD_LOGIC;
      D     : IN  STD_LOGIC_VECTOR(size-1 DOWNTO 0);
      Q     : OUT STD_LOGIC_VECTOR(size-1 DOWNTO 0)
      );
  END COMPONENT;


  COMPONENT MUX2 IS
    GENERIC(Input_SZ : INTEGER := 16);
    PORT(
      sel : IN  STD_LOGIC;
      IN1 : IN  STD_LOGIC_VECTOR(Input_SZ-1 DOWNTO 0);
      IN2 : IN  STD_LOGIC_VECTOR(Input_SZ-1 DOWNTO 0);
      RES : OUT STD_LOGIC_VECTOR(Input_SZ-1 DOWNTO 0)
      );
  END COMPONENT;

  TYPE MUX_INPUT_TYPE IS ARRAY (NATURAL RANGE <>, NATURAL RANGE <>) OF STD_LOGIC;
  TYPE MUX_OUTPUT_TYPE IS ARRAY (NATURAL RANGE <>) OF STD_LOGIC;
  
  COMPONENT MUXN
    GENERIC (
      Input_SZ : INTEGER;
      NbStage  : INTEGER);
    PORT (
      sel   : IN  STD_LOGIC_VECTOR(NbStage-1 DOWNTO 0);
      INPUT : IN  MUX_INPUT_TYPE(0 TO (2**NbStage)-1,Input_SZ-1 DOWNTO 0);
      --INPUT : IN  ARRAY (0 TO (2**NbStage)-1) OF STD_LOGIC_VECTOR(Input_SZ-1 DOWNTO 0);
      RES   : OUT MUX_OUTPUT_TYPE(Input_SZ-1 DOWNTO 0));
  END COMPONENT;

  

  COMPONENT Multiplier IS
    GENERIC(
      Input_SZ_A : INTEGER := 16;
      Input_SZ_B : INTEGER := 16

      );
    PORT(
      clk   : IN  STD_LOGIC;
      reset : IN  STD_LOGIC;
      mult  : IN  STD_LOGIC;
      OP1   : IN  STD_LOGIC_VECTOR(Input_SZ_A-1 DOWNTO 0);
      OP2   : IN  STD_LOGIC_VECTOR(Input_SZ_B-1 DOWNTO 0);
      RES   : OUT STD_LOGIC_VECTOR(Input_SZ_A+Input_SZ_B-1 DOWNTO 0)
      );
  END COMPONENT;

  COMPONENT REG IS
    GENERIC(size : INTEGER := 16; initial_VALUE : INTEGER := 0);
    PORT(
      reset : IN  STD_LOGIC;
      clk   : IN  STD_LOGIC;
      D     : IN  STD_LOGIC_VECTOR(size-1 DOWNTO 0);
      Q     : OUT STD_LOGIC_VECTOR(size-1 DOWNTO 0)
      );
  END COMPONENT;



  COMPONENT RShifter IS
    GENERIC(
      Input_SZ : INTEGER := 16;
      shift_SZ : INTEGER := 4
      );
    PORT(
      clk   : IN  STD_LOGIC;
      reset : IN  STD_LOGIC;
      shift : IN  STD_LOGIC;
      OP    : IN  STD_LOGIC_VECTOR(Input_SZ-1 DOWNTO 0);
      cnt   : IN  STD_LOGIC_VECTOR(shift_SZ-1 DOWNTO 0);
      RES   : OUT STD_LOGIC_VECTOR(Input_SZ-1 DOWNTO 0)
      );
  END COMPONENT;

  COMPONENT SYNC_FF
    GENERIC (
      NB_FF_OF_SYNC : INTEGER);
    PORT (
      clk    : IN  STD_LOGIC;
      rstn   : IN  STD_LOGIC;
      A      : IN  STD_LOGIC;
      A_sync : OUT STD_LOGIC);
  END COMPONENT;

COMPONENT Clock_Divider is
generic(N :integer := 10);
port( 
    clk, rst   : in std_logic;
    sclk       : out std_logic);
end COMPONENT;

END;
