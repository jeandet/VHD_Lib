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
LIBRARY IEEE;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_1164.ALL;
LIBRARY lpp;
USE lpp.general_purpose.ALL;
--TODO
--terminer le testbensh puis changer le resize dans les instanciations
--par un resize sur un vecteur en combi


ENTITY MAC IS
  GENERIC(
    Input_SZ_A : INTEGER := 8;
    Input_SZ_B : INTEGER := 8;
    COMP_EN    : INTEGER := 0           -- 1 =>  No Comp

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
END MAC;




ARCHITECTURE ar_MAC OF MAC IS

  
  SIGNAL clr_MAC_s     : STD_LOGIC;
  SIGNAL MAC_MUL_ADD_s : STD_LOGIC_VECTOR(1 DOWNTO 0);

  SIGNAL add, mult : STD_LOGIC;
  SIGNAL MULTout   : STD_LOGIC_VECTOR(Input_SZ_A+Input_SZ_B-1 DOWNTO 0);

  SIGNAL ADDERinA : STD_LOGIC_VECTOR(Input_SZ_A+Input_SZ_B-1 DOWNTO 0);
  SIGNAL ADDERinB : STD_LOGIC_VECTOR(Input_SZ_A+Input_SZ_B-1 DOWNTO 0);
  SIGNAL ADDERout : STD_LOGIC_VECTOR(Input_SZ_A+Input_SZ_B-1 DOWNTO 0);

  SIGNAL MACMUXsel     : STD_LOGIC;
  SIGNAL OP1_2C_D_Resz : STD_LOGIC_VECTOR(Input_SZ_A+Input_SZ_B-1 DOWNTO 0);
  SIGNAL OP2_2C_D_Resz : STD_LOGIC_VECTOR(Input_SZ_A+Input_SZ_B-1 DOWNTO 0);

  SIGNAL OP1_2C : STD_LOGIC_VECTOR(Input_SZ_A-1 DOWNTO 0);
  SIGNAL OP2_2C : STD_LOGIC_VECTOR(Input_SZ_B-1 DOWNTO 0);

  SIGNAL MACMUX2sel : STD_LOGIC;

  SIGNAL add_D          : STD_LOGIC;
  SIGNAL OP1_2C_D       : STD_LOGIC_VECTOR(Input_SZ_A-1 DOWNTO 0);
  SIGNAL OP2_2C_D       : STD_LOGIC_VECTOR(Input_SZ_B-1 DOWNTO 0);
  SIGNAL MULTout_D      : STD_LOGIC_VECTOR(Input_SZ_A+Input_SZ_B-1 DOWNTO 0);
  SIGNAL MACMUXsel_D    : STD_LOGIC;
  SIGNAL MACMUX2sel_D   : STD_LOGIC;
  SIGNAL MACMUX2sel_D_D : STD_LOGIC;
  SIGNAL clr_MAC_D      : STD_LOGIC;
--  SIGNAL clr_MAC_D_D      : STD_LOGIC;
--  SIGNAL MAC_MUL_ADD_2C_D : STD_LOGIC_VECTOR(1 DOWNTO 0);

--  SIGNAL load_mult_result   : STD_LOGIC;
--  SIGNAL load_mult_result_D : STD_LOGIC;

BEGIN




--==============================================================
--=============M A C  C O N T R O L E R=========================
--==============================================================
  MAC_CONTROLER1 : MAC_CONTROLER
    PORT MAP(
      ctrl        => MAC_MUL_ADD_s,
      MULT        => mult,
      ADD         => add,
      --LOAD_ADDER  => load_mult_result,
      MACMUX_sel  => MACMUXsel,
      MACMUX2_sel => MACMUX2sel

      );
--==============================================================




--==============================================================
--=============M U L T I P L I E R==============================
--==============================================================
  Multiplieri_nst : Multiplier
    GENERIC MAP(
      Input_SZ_A => Input_SZ_A,
      Input_SZ_B => Input_SZ_B
      )
    PORT MAP(
      clk   => clk,
      reset => reset,
      mult  => mult,
      OP1   => OP1_2C,
      OP2   => OP2_2C,
      RES   => MULTout
      );
--==============================================================

  --PROCESS (clk, reset)
  --BEGIN  -- PROCESS
  --  IF reset = '0' THEN                 -- asynchronous reset (active low)
  --    load_mult_result_D <= '0';
  --  ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
  --    load_mult_result_D <= load_mult_result;
  --  END IF;
  --END PROCESS;

--==============================================================
--======================A D D E R ==============================
--==============================================================
  adder_inst : Adder
    GENERIC MAP(
      Input_SZ_A => Input_SZ_A+Input_SZ_B,
      Input_SZ_B => Input_SZ_A+Input_SZ_B
      )
    PORT MAP(
      clk   => clk,
      reset => reset,
      clr   => clr_MAC_D,
      load  => MACMUX2sel_D,            --load_mult_result_D,
      add   => add_D,
      OP1   => ADDERinA,
      OP2   => ADDERinB,
      RES   => ADDERout
      );

--==============================================================
--===================TWO COMPLEMENTERS==========================
--==============================================================
  gen_comp : IF COMP_EN = 0 GENERATE
    TWO_COMPLEMENTER1 : TwoComplementer
      GENERIC MAP(
        Input_SZ => Input_SZ_A
        )
      PORT MAP(
        clk     => clk,
        reset   => reset,
        clr     => '0',                 --clr_MAC,
        TwoComp => Comp_2C(0),
        OP      => OP1,
        RES     => OP1_2C
        );

    TWO_COMPLEMENTER2 : TwoComplementer
      GENERIC MAP(
        Input_SZ => Input_SZ_B
        )
      PORT MAP(
        clk     => clk,
        reset   => reset,
        clr     => '0',                 --clr_MAC,
        TwoComp => Comp_2C(1),
        OP      => OP2,
        RES     => OP2_2C
        );

    clr_MACREG_comp : MAC_REG
      GENERIC MAP(size => 1)
      PORT MAP(
        reset => reset,
        clk   => clk,
        D(0)  => clr_MAC,
        Q(0)  => clr_MAC_s
        );

    MAC_MUL_ADD_REG : MAC_REG
      GENERIC MAP(size => 2)
      PORT MAP(
        reset => reset,
        clk   => clk,
        D     => MAC_MUL_ADD,
        Q     => MAC_MUL_ADD_s
        );

  END GENERATE gen_comp;

  no_gen_comp : IF COMP_EN = 1 GENERATE
    OP2_2C <= OP2;
    OP1_2C <= OP1;

    clr_MAC_s     <= clr_MAC;
    MAC_MUL_ADD_s <= MAC_MUL_ADD;
  END GENERATE no_gen_comp;
--==============================================================

  clr_MACREG1 : MAC_REG
    GENERIC MAP(size => 1)
    PORT MAP(
      reset => reset,
      clk   => clk,
      D(0)  => clr_MAC_s,
      Q(0)  => clr_MAC_D
      );

  addREG : MAC_REG
    GENERIC MAP(size => 1)
    PORT MAP(
      reset => reset,
      clk   => clk,
      D(0)  => add,
      Q(0)  => add_D
      );

  OP1REG : MAC_REG
    GENERIC MAP(size => Input_SZ_A)
    PORT MAP(
      reset => reset,
      clk   => clk,
      D     => OP1_2C,
      Q     => OP1_2C_D
      );


  OP2REG : MAC_REG
    GENERIC MAP(size => Input_SZ_B)
    PORT MAP(
      reset => reset,
      clk   => clk,
      D     => OP2_2C,
      Q     => OP2_2C_D
      );

  MULToutREG : MAC_REG
    GENERIC MAP(size => Input_SZ_A+Input_SZ_B)
    PORT MAP(
      reset => reset,
      clk   => clk,
      D     => MULTout,
      Q     => MULTout_D
      );

  MACMUXselREG : MAC_REG
    GENERIC MAP(size => 1)
    PORT MAP(
      reset => reset,
      clk   => clk,
      D(0)  => MACMUXsel,
      Q(0)  => MACMUXsel_D
      );

  MACMUX2selREG : MAC_REG
    GENERIC MAP(size => 1)
    PORT MAP(
      reset => reset,
      clk   => clk,
      D(0)  => MACMUX2sel,
      Q(0)  => MACMUX2sel_D
      );

  MACMUX2selREG2 : MAC_REG
    GENERIC MAP(size => 1)
    PORT MAP(
      reset => reset,
      clk   => clk,
      D(0)  => MACMUX2sel_D,
      Q(0)  => MACMUX2sel_D_D
      );

--==============================================================
--======================M A C  M U X ===========================
--==============================================================
  MACMUX_inst : MAC_MUX
    GENERIC MAP(
      Input_SZ_A => Input_SZ_A+Input_SZ_B,
      Input_SZ_B => Input_SZ_A+Input_SZ_B

      )
    PORT MAP(
      sel  => MACMUXsel_D,
      INA1 => ADDERout,
      INA2 => OP2_2C_D_Resz,
      INB1 => MULTout,
      INB2 => OP1_2C_D_Resz,
      OUTA => ADDERinA,
      OUTB => ADDERinB
      );
  OP1_2C_D_Resz <= STD_LOGIC_VECTOR(resize(SIGNED(OP1_2C_D), Input_SZ_A+Input_SZ_B));
  OP2_2C_D_Resz <= STD_LOGIC_VECTOR(resize(SIGNED(OP2_2C_D), Input_SZ_A+Input_SZ_B));
--==============================================================


--==============================================================
--======================M A C  M U X2 ==========================
--==============================================================
  MAC_MUX2_inst : MAC_MUX2
    GENERIC MAP(Input_SZ => Input_SZ_A+Input_SZ_B)
    PORT MAP(
      sel  => MACMUX2sel_D_D,
      RES2 => MULTout_D,
      RES1 => ADDERout,
      RES  => RES
      );
--==============================================================

END ar_MAC;
