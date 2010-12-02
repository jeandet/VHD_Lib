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
library ieee;
use ieee.std_logic_1164.all;



package general_purpose is



component Clk_divider is
	 generic(OSC_freqHz	:	integer := 50000000;
				TargetFreq_Hz	:	integer := 50000);
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           clk_divided : out  STD_LOGIC);
end component;





component Adder is 
generic(
    Input_SZ_A     :   integer := 16;
    Input_SZ_B     :   integer := 16

);
port(
    clk     :   in  std_logic;
    reset   :   in  std_logic;
    clr     :   in  std_logic;
    add     :   in  std_logic;
    OP1     :   in  std_logic_vector(Input_SZ_A-1 downto 0);
    OP2     :   in  std_logic_vector(Input_SZ_B-1 downto 0);
    RES     :   out std_logic_vector(Input_SZ_A-1 downto 0)
);
end component;

component ADDRcntr is 
port(
    clk     :   in  std_logic;
    reset   :   in  std_logic;
    count   :   in  std_logic;
    clr     :   in  std_logic;
    Q       :   out std_logic_vector(7 downto 0)
);
end component;

component ALU is
generic(
    Arith_en        :   integer := 1;
    Logic_en        :   integer := 1;
    Input_SZ_1      :   integer := 16;
    Input_SZ_2      :   integer := 9

);
port(
    clk     :   in  std_logic;
    reset   :   in  std_logic;
    ctrl    :   in  std_logic_vector(3 downto 0);
    OP1     :   in  std_logic_vector(Input_SZ_1-1 downto 0);
    OP2     :   in  std_logic_vector(Input_SZ_2-1 downto 0);
    RES     :   out std_logic_vector(Input_SZ_1+Input_SZ_2-1 downto 0)
);
end component;


component MAC is 
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
end component;


component MAC_CONTROLER is
port(
    ctrl        :   in  std_logic_vector(1 downto 0);
    MULT        :   out std_logic;
    ADD         :   out std_logic;
    MACMUX_sel  :   out std_logic;
    MACMUX2_sel :   out std_logic

);
end component;

component MAC_MUX is 
generic(
    Input_SZ_A     :   integer := 16;
    Input_SZ_B     :   integer := 16

);
port(
    sel     :   in  std_logic;
    INA1    :   in  std_logic_vector(Input_SZ_A-1 downto 0);
    INA2    :   in  std_logic_vector(Input_SZ_A-1 downto 0);
    INB1    :   in  std_logic_vector(Input_SZ_B-1 downto 0);
    INB2    :   in  std_logic_vector(Input_SZ_B-1 downto 0);
    OUTA    :   out std_logic_vector(Input_SZ_A-1 downto 0);
    OUTB    :   out std_logic_vector(Input_SZ_B-1 downto 0)
);
end component;


component MAC_MUX2 is 
generic(Input_SZ     :   integer := 16);
port(
    sel     :   in  std_logic;
    RES1    :   in  std_logic_vector(Input_SZ-1 downto 0);
    RES2    :   in  std_logic_vector(Input_SZ-1 downto 0);
    RES     :   out std_logic_vector(Input_SZ-1 downto 0)
);
end component;


component MAC_REG is 
generic(size    :   integer := 16);
port(
    reset   :   in  std_logic;
    clk     :   in  std_logic;
    D       :   in  std_logic_vector(size-1 downto 0);
    Q       :   out std_logic_vector(size-1 downto 0)
);
end component;


component MUX2 is 
generic(Input_SZ     :   integer := 16);
port(
    sel     :   in  std_logic;
    IN1     :   in  std_logic_vector(Input_SZ-1 downto 0);
    IN2     :   in  std_logic_vector(Input_SZ-1 downto 0);
    RES     :   out std_logic_vector(Input_SZ-1 downto 0)
);
end component;

component Multiplier is 
generic(
    Input_SZ_A     :   integer := 16;
    Input_SZ_B     :   integer := 16

);
port(
    clk     :   in  std_logic;
    reset   :   in  std_logic;
    mult    :   in  std_logic;
    OP1     :   in  std_logic_vector(Input_SZ_A-1 downto 0);
    OP2     :   in  std_logic_vector(Input_SZ_B-1 downto 0);
    RES     :   out std_logic_vector(Input_SZ_A+Input_SZ_B-1 downto 0)
);
end component;

component REG is 
generic(size    :   integer := 16 ; initial_VALUE : integer := 0);
port(
    reset   :   in  std_logic;
    clk     :   in  std_logic;
    D       :   in  std_logic_vector(size-1 downto 0);
    Q       :   out std_logic_vector(size-1 downto 0)
);
end component;



component RShifter is 
generic(
    Input_SZ       :   integer := 16;
    shift_SZ       :   integer := 4
);
port(
    clk     :   in  std_logic;
    reset   :   in  std_logic;
    shift   :   in  std_logic;
    OP      :   in  std_logic_vector(Input_SZ-1 downto 0);
    cnt     :   in  std_logic_vector(shift_SZ-1 downto 0);
    RES     :   out std_logic_vector(Input_SZ-1 downto 0)
);
end component;

end;
