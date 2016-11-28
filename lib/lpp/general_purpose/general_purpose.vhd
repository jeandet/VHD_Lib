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
USE IEEE.NUMERIC_STD.ALL;



PACKAGE general_purpose IS

  COMPONENT general_counter
    GENERIC (
      CYCLIC          : STD_LOGIC := '1';
      NB_BITS_COUNTER : INTEGER   := 9;
      RST_VALUE       : INTEGER   := 0);
    PORT (
      clk       : IN  STD_LOGIC;
      rstn      : IN  STD_LOGIC;
      MAX_VALUE : IN  STD_LOGIC_VECTOR(NB_BITS_COUNTER-1 DOWNTO 0) := (OTHERS => '1');
      set       : IN  STD_LOGIC;
      set_value : IN  STD_LOGIC_VECTOR(NB_BITS_COUNTER-1 DOWNTO 0);
      add1      : IN  STD_LOGIC;
      counter   : OUT STD_LOGIC_VECTOR(NB_BITS_COUNTER-1 DOWNTO 0));
  END COMPONENT;

  COMPONENT Clk_divider IS
    GENERIC(OSC_freqHz    : INTEGER := 50000000;
            TargetFreq_Hz : INTEGER := 50000);
    PORT (clk         : IN  STD_LOGIC;
          reset       : IN  STD_LOGIC;
          clk_divided : OUT STD_LOGIC);
  END COMPONENT;


  COMPONENT Clk_divider2 IS
    GENERIC(N : INTEGER := 16);
    PORT(
      clk_in  : IN  STD_LOGIC;
      clk_out : OUT STD_LOGIC);
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
      load  : IN  STD_LOGIC;
      add   : IN  STD_LOGIC;
      OP1   : IN  STD_LOGIC_VECTOR(Input_SZ_A-1 DOWNTO 0);
      OP2   : IN  STD_LOGIC_VECTOR(Input_SZ_B-1 DOWNTO 0);
      RES   : OUT STD_LOGIC_VECTOR(Input_SZ_A-1 DOWNTO 0)
      );
  END COMPONENT;

  COMPONENT Adder_V0 IS
    GENERIC(
      Input_SZ_A : INTEGER := 16;
      Input_SZ_B : INTEGER := 16

      );
    PORT(
      clk   : IN  STD_LOGIC;
      reset : IN  STD_LOGIC;
      clr   : IN  STD_LOGIC;
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
      COMP_EN    : INTEGER := 0         -- 1 =>  No Comp

      );
    PORT(
      clk   : IN  STD_LOGIC;
      reset : IN  STD_LOGIC;
      ctrl  : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
      comp  : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
      OP1   : IN  STD_LOGIC_VECTOR(Input_SZ_1-1 DOWNTO 0);
      OP2   : IN  STD_LOGIC_VECTOR(Input_SZ_2-1 DOWNTO 0);
      RES   : OUT STD_LOGIC_VECTOR(Input_SZ_1+Input_SZ_2-1 DOWNTO 0)
      );
  END COMPONENT;

  COMPONENT ALU_V0 IS
    GENERIC(
      Arith_en   : INTEGER := 1;
      Logic_en   : INTEGER := 1;
      Input_SZ_1 : INTEGER := 16;
      Input_SZ_2 : INTEGER := 9

      );
    PORT(
      clk   : IN  STD_LOGIC;
      reset : IN  STD_LOGIC;
      ctrl  : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      OP1   : IN  STD_LOGIC_VECTOR(Input_SZ_1-1 DOWNTO 0);
      OP2   : IN  STD_LOGIC_VECTOR(Input_SZ_2-1 DOWNTO 0);
      RES   : OUT STD_LOGIC_VECTOR(Input_SZ_1+Input_SZ_2-1 DOWNTO 0)
      );
  END COMPONENT;

  COMPONENT MAC_V0 IS
    GENERIC(
      Input_SZ_A : INTEGER := 8;
      Input_SZ_B : INTEGER := 8

      );
    PORT(
      clk         : IN  STD_LOGIC;
      reset       : IN  STD_LOGIC;
      clr_MAC     : IN  STD_LOGIC;
      MAC_MUL_ADD : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
      OP1         : IN  STD_LOGIC_VECTOR(Input_SZ_A-1 DOWNTO 0);
      OP2         : IN  STD_LOGIC_VECTOR(Input_SZ_B-1 DOWNTO 0);
      RES         : OUT STD_LOGIC_VECTOR(Input_SZ_A+Input_SZ_B-1 DOWNTO 0)
      );
  END COMPONENT;

---------------------------------------------------------
-------- // Sélection grace a l'entrée "ctrl" \\ --------
---------------------------------------------------------
  CONSTANT ctrl_IDLE   : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
  CONSTANT ctrl_MAC    : STD_LOGIC_VECTOR(2 DOWNTO 0) := "001";
  CONSTANT ctrl_MULT   : STD_LOGIC_VECTOR(2 DOWNTO 0) := "010";
  CONSTANT ctrl_ADD    : STD_LOGIC_VECTOR(2 DOWNTO 0) := "011";
  CONSTANT ctrl_CLRMAC : STD_LOGIC_VECTOR(2 DOWNTO 0) := "100";


  CONSTANT IDLE_V0    : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
  CONSTANT MAC_op_V0  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0001";
  CONSTANT MULT_V0    : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0010";
  CONSTANT ADD_V0     : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0011";
  CONSTANT CLR_MAC_V0 : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0100";
---------------------------------------------------------

  COMPONENT MAC IS
    GENERIC(
      Input_SZ_A : INTEGER := 8;
      Input_SZ_B : INTEGER := 8;
      COMP_EN    : INTEGER := 0         -- 1 =>  No Comp
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

  COMPONENT TwoComplementer IS
    GENERIC(
      Input_SZ : INTEGER := 16);
    PORT(
      clk     : IN  STD_LOGIC;          --! Horloge du composant
      reset   : IN  STD_LOGIC;          --! Reset general du composant
      clr     : IN  STD_LOGIC;          --! Un reset spécifique au programme
      TwoComp : IN  STD_LOGIC;  --! Autorise l'utilisation du complément
      OP      : IN  STD_LOGIC_VECTOR(Input_SZ-1 DOWNTO 0);  --! Opérande d'entrée
      RES     : OUT STD_LOGIC_VECTOR(Input_SZ-1 DOWNTO 0)  --! Résultat, opérande complémenté ou non
      );
  END COMPONENT;

  COMPONENT MAC_CONTROLER IS
    PORT(
      ctrl        : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
      MULT        : OUT STD_LOGIC;
      ADD         : OUT STD_LOGIC;
--      LOAD_ADDER  : out std_logic;
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
      INPUT : IN  MUX_INPUT_TYPE(0 TO (2**NbStage)-1, Input_SZ-1 DOWNTO 0);
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

  COMPONENT lpp_front_to_level
    PORT (
      clk  : IN  STD_LOGIC;
      rstn : IN  STD_LOGIC;
      sin  : IN  STD_LOGIC;
      sout : OUT STD_LOGIC);
  END COMPONENT;

  COMPONENT lpp_front_detection
    PORT (
      clk  : IN  STD_LOGIC;
      rstn : IN  STD_LOGIC;
      sin  : IN  STD_LOGIC;
      sout : OUT STD_LOGIC);
  END COMPONENT;

  COMPONENT lpp_front_positive_detection
    PORT (
      clk  : IN  STD_LOGIC;
      rstn : IN  STD_LOGIC;
      sin  : IN  STD_LOGIC;
      sout : OUT STD_LOGIC);
  END COMPONENT;

  --COMPONENT SYNC_VALID_BIT
  --  GENERIC (
  --    NB_FF_OF_SYNC : INTEGER);
  --  PORT (
  --    clk_in  : IN  STD_LOGIC;
  --    clk_out : IN  STD_LOGIC;
  --    rstn : IN  STD_LOGIC;
  --    sin  : IN  STD_LOGIC;
  --    sout : OUT STD_LOGIC);
  --END COMPONENT;

  COMPONENT SYNC_VALID_BIT
    GENERIC (
      NB_FF_OF_SYNC : INTEGER);
    PORT (
      clk_in   : IN  STD_LOGIC;
      rstn_in  : IN  STD_LOGIC;
      clk_out  : IN  STD_LOGIC;
      rstn_out : IN  STD_LOGIC;
      sin      : IN  STD_LOGIC;
      sout     : OUT STD_LOGIC);
  END COMPONENT;

  COMPONENT RR_Arbiter_4
    PORT (
      clk       : IN  STD_LOGIC;
      rstn      : IN  STD_LOGIC;
      in_valid  : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      out_grant : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
  END COMPONENT;

  COMPONENT Clock_Divider IS
    GENERIC(N : INTEGER := 10);
    PORT(
      clk, rst : IN  STD_LOGIC;
      sclk     : OUT STD_LOGIC);
  END COMPONENT;

  COMPONENT ramp_generator
    GENERIC (
      DATA_SIZE           : INTEGER;
      VALUE_UNSIGNED_INIT : INTEGER;
      VALUE_UNSIGNED_INCR : INTEGER;
      VALUE_UNSIGNED_MASK : INTEGER);
    PORT (
      clk         : IN  STD_LOGIC;
      rstn        : IN  STD_LOGIC;
      new_data    : IN  STD_LOGIC;
      output_data : OUT STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0));
  END COMPONENT;

  COMPONENT TimeGenAdvancedTrigger
    PORT(
        clk         : IN STD_LOGIC;
        rstn        : IN STD_LOGIC;

        SPW_Tickout : IN STD_LOGIC;

        CoarseTime  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        FineTime    : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

        TrigPeriod  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);   -- In seconds 0 to 15
        TrigShift   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);  -- In FineTime steps
        Restart     : IN STD_LOGIC;
        StartDate   : IN STD_LOGIC_VECTOR(31 DOWNTO 0);  -- Date in seconds since epoch

        BypassTickout : IN STD_LOGIC; -- if set then Trigger output is driven by SPW tickout
                                      -- else Trigger output is driven by advanced trig
        Trigger     : OUT STD_LOGIC

    );
  END COMPONENT;

END;
