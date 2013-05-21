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


package Rocket_PCM_Encoder is

component MinF_Cntr is
generic(MinFCount   :   integer := 64);
port(
    clk     :   in  std_logic;
    reset   :   in  std_logic;
    Cnt_out :   out integer range 0 to MinFCount-1
);
end component;

component Serial_Driver is
generic(size    :   integer :=8);
port(
    sclk     :   in  std_logic;
    inputDat:   in  std_logic_vector(size-1 downto 0);  
    Gate    :   in  std_logic;
    Data    :   out std_logic
);
end component;

component Serial_Driver_Multiplexor is
generic(InputCnt : integer := 2;inputSize : integer:=8);
port(
    clk     :   in  std_logic;
    Sel     :   in  integer range 0 to InputCnt-1;
    input   :   in  std_logic_vector(InputCnt*inputSize-1 downto 0);
    output  :   out std_logic_vector(inputSize-1 downto 0)
);
end component;

component Word_Cntr is
generic(WordSize :integer := 8 ;N   :   integer := 144);
port(
    Sclk    :   in  std_logic;
    reset   :   in  std_logic;
    WordClk :   out std_logic;
    Cnt_out :   out integer range 0 to N-1
);
end component;

end Rocket_PCM_Encoder;
