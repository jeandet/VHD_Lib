------------------------------------------------------------------------------
--  This file is a part of the LPP VHDL IP LIBRARY
--  Copyright (C) 2017, Laboratory of Plasmas Physic - CNRS
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
--                     Mail : alexis.jeandet@member.fsf.org
----------------------------------------------------------------------------
library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
library lpp;
use lpp.general_purpose.all;

entity D_FF is
generic(reset_value : std_logic := '0');
port(
    rstn    :   in  std_logic;
    clk     :   in  std_logic;
    enable  :   in  std_logic;
    D       :   in  std_logic;
    Q       :   out std_logic
);
end entity;



architecture    ar_D_FF of D_FF is
begin
  process(clk,rstn)
  begin
    if rstn = '0' then
        Q   <=  reset_value;
    elsif clk'event and clk ='1' then
      if enable = '1' then
        Q   <=  D;
      end if;
    end if;
  end process;
end ar_D_FF;

library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
library lpp;
use lpp.general_purpose.all;
entity D_FF_v is
generic(size: INTEGER :=1; reset_value : INTEGER := 0);
port(
    rstn    :   in  std_logic;
    clk     :   in  std_logic;
    enable  :   in  std_logic;
    D       :   in  std_logic_vector(size-1 downto 0);
    Q       :   out std_logic_vector(size-1 downto 0)
);
end entity;



architecture    ar_D_FF_v of D_FF_v is
  CONSTANT rst_val : std_logic_vector(size-1 downto 0)  := std_logic_vector(to_unsigned(reset_value,size));
begin
  FF: FOR i IN 0 TO size-1 GENERATE
    bitx: D_FF
      generic map(reset_value => rst_val(i))
      port map(
          rstn    =>  rstn,
          clk     =>  clk,
          enable  =>  enable,
          D       =>  D(i),
          Q       =>  Q(i)
      );
  END GENERATE;
end ar_D_FF_v;
