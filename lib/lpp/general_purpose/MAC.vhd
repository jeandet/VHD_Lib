------------------------------------------------------------------------------
--  This file is a part of the LPP VHDL IP LIBRARY
--  Copyright (C) 2009 - 2010, Laboratory of Plasmas Physic - CNRS
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
-------------------------------------------------------------------------------
-- MAC.vhd
library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
library lpp;
use lpp.general_purpose.all;
--TODO
--terminer le testbensh puis changer le resize dans les instanciations
--par un resize sur un vecteur en combi





entity MAC is 
generic(
    Input_SZ_A     :   integer := 8;
    Input_SZ_B     :   integer := 8

);
port(
    clk     :   in  std_logic;
    reset   :   in  std_logic;
    clr_MAC :   in  std_logic;
    MAC_MUL_ADD :   in  std_logic_vector(1 downto 0);
    OP1     :   in  std_logic_vector(Input_SZ_A-1 downto 0);
    OP2     :   in  std_logic_vector(Input_SZ_B-1 downto 0);
    RES     :   out std_logic_vector(Input_SZ_A+Input_SZ_B-1 downto 0)
);
end MAC;




architecture ar_MAC of MAC is





signal  add,mult    :   std_logic;
signal  MULTout     :   std_logic_vector(Input_SZ_A+Input_SZ_B-1 downto 0);

signal  ADDERinA    :   std_logic_vector(Input_SZ_A+Input_SZ_B-1 downto 0);
signal  ADDERinB    :   std_logic_vector(Input_SZ_A+Input_SZ_B-1 downto 0);
signal  ADDERout    :   std_logic_vector(Input_SZ_A+Input_SZ_B-1 downto 0);


signal  MACMUXsel   :   std_logic;
signal  OP1_D_Resz  :   std_logic_vector(Input_SZ_A+Input_SZ_B-1 downto 0);
signal  OP2_D_Resz  :   std_logic_vector(Input_SZ_A+Input_SZ_B-1 downto 0);



signal  MACMUX2sel  :   std_logic;

signal  add_D           :   std_logic;
signal  OP1_D           :   std_logic_vector(Input_SZ_A-1 downto 0);
signal  OP2_D           :   std_logic_vector(Input_SZ_B-1 downto 0);
signal  MULTout_D       :   std_logic_vector(Input_SZ_A+Input_SZ_B-1 downto 0);
signal  MACMUXsel_D     :   std_logic;
signal  MACMUX2sel_D    :   std_logic;
signal  MACMUX2sel_D_D  :   std_logic;
signal  clr_MAC_D       :   std_logic;
signal  clr_MAC_D_D     :   std_logic;





begin




--==============================================================
--=============M A C  C O N T R O L E R=========================
--==============================================================
MAC_CONTROLER1 : MAC_CONTROLER
port map(
    ctrl        =>  MAC_MUL_ADD,
    MULT        =>  mult,
    ADD         =>  add,
    MACMUX_sel  =>  MACMUXsel,
    MACMUX2_sel =>  MACMUX2sel

);
--==============================================================




--==============================================================
--=============M U L T I P L I E R==============================
--==============================================================
Multiplieri_nst : Multiplier
generic map(
    Input_SZ_A     =>   Input_SZ_A,
    Input_SZ_B     =>   Input_SZ_B
)
port map(
    clk         =>  clk,
    reset       =>  reset,
    mult        =>  mult,
    OP1         =>  OP1,
    OP2         =>  OP2,
    RES         =>  MULTout
);

--==============================================================




--==============================================================
--======================A D D E R ==============================
--==============================================================
adder_inst : Adder
generic map(
    Input_SZ_A     =>   Input_SZ_A+Input_SZ_B,
    Input_SZ_B     =>   Input_SZ_A+Input_SZ_B
)
port map(
    clk         =>  clk,
    reset       =>  reset,
    clr         =>  clr_MAC_D,
    add         =>  add_D,
    OP1         =>  ADDERinA,
    OP2         =>  ADDERinB,
    RES         =>  ADDERout
);

--==============================================================


clr_MACREG1 : MAC_REG 
generic map(size    =>  1)
port map(
    reset   =>  reset,
    clk     =>  clk,
    D(0)    =>  clr_MAC,
    Q(0)    =>  clr_MAC_D
);

clr_MACREG2 : MAC_REG 
generic map(size    =>  1)
port map(
    reset   =>  reset,
    clk     =>  clk,
    D(0)    =>  clr_MAC_D,
    Q(0)    =>  clr_MAC_D_D
);

addREG : MAC_REG 
generic map(size    =>  1)
port map(
    reset   =>  reset,
    clk     =>  clk,
    D(0)    =>  add,
    Q(0)    =>  add_D
);

OP1REG : MAC_REG 
generic map(size    =>  Input_SZ_A)
port map(
    reset   =>  reset,
    clk     =>  clk,
    D       =>  OP1,
    Q       =>  OP1_D
);


OP2REG : MAC_REG 
generic map(size    =>  Input_SZ_B)
port map(
    reset   =>  reset,
    clk     =>  clk,
    D       =>  OP2,
    Q       =>  OP2_D
);


MULToutREG : MAC_REG 
generic map(size    =>  Input_SZ_A+Input_SZ_B)
port map(
    reset   =>  reset,
    clk     =>  clk,
    D       =>  MULTout,
    Q       =>  MULTout_D
);


MACMUXselREG : MAC_REG 
generic map(size    =>  1)
port map(
    reset   =>  reset,
    clk     =>  clk,
    D(0)    =>  MACMUXsel,
    Q(0)    =>  MACMUXsel_D
);

MACMUX2selREG : MAC_REG 
generic map(size    =>  1)
port map(
    reset   =>  reset,
    clk     =>  clk,
    D(0)    =>  MACMUX2sel,
    Q(0)    =>  MACMUX2sel_D
);

MACMUX2selREG2 : MAC_REG 
generic map(size    =>  1)
port map(
    reset   =>  reset,
    clk     =>  clk,
    D(0)    =>  MACMUX2sel_D,
    Q(0)    =>  MACMUX2sel_D_D
);

--==============================================================
--======================M A C  M U X ===========================
--==============================================================
MACMUX_inst : MAC_MUX 
generic map(
    Input_SZ_A     =>   Input_SZ_A+Input_SZ_B,
    Input_SZ_B     =>   Input_SZ_A+Input_SZ_B

)
port map(
    sel         =>  MACMUXsel_D,
    INA1        =>  ADDERout,
    INA2        =>  OP2_D_Resz,
    INB1        =>  MULTout,
    INB2        =>  OP1_D_Resz,
    OUTA        =>  ADDERinA,
    OUTB        =>  ADDERinB
);
OP1_D_Resz  <=  std_logic_vector(resize(signed(OP1_D),Input_SZ_A+Input_SZ_B));
OP2_D_Resz  <=  std_logic_vector(resize(signed(OP2_D),Input_SZ_A+Input_SZ_B));
--==============================================================


--==============================================================
--======================M A C  M U X2 ==========================
--==============================================================
MAC_MUX2_inst   : MAC_MUX2
generic map(Input_SZ     => Input_SZ_A+Input_SZ_B)
port map(
    sel     =>  MACMUX2sel_D_D,
    RES2    =>  MULTout_D,
    RES1    =>  ADDERout,
    RES     =>  RES
);


--==============================================================

end ar_MAC;
