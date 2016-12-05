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
library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;


entity saturation is

  generic (
    SIZE_INPUT  : integer := 18;
    SIZE_OUTPUT : integer := 16);

  port (
    s_in  : in  std_logic_vector(SIZE_INPUT-1 downto 0);
    s_out : out std_logic_vector(SIZE_OUTPUT-1 downto 0)
    );

end entity saturation;

architecture beh of saturation is

  signal saturated : std_logic;

  constant all_one  : std_logic_vector(SIZE_INPUT-1 downto SIZE_OUTPUT-1) := (others => '1');
  constant all_zero : std_logic_vector(SIZE_INPUT-1 downto SIZE_OUTPUT-1) := (others => '0');

begin  -- architecture beh

  SIZE_IN_inf_SIZE_OUT : if SIZE_INPUT < SIZE_OUTPUT generate
    s_out(SIZE_INPUT-1 downto 0) <= s_in(SIZE_INPUT-1 downto 0);
    all_inf_bits : for I in SIZE_OUTPUT-1 downto SIZE_INPUT generate
      s_out(I) <= s_in(SIZE_INPUT-1);
    end generate all_inf_bits;
  end generate SIZE_IN_inf_SIZE_OUT;

  SIZE_IN_equ_SIZE_OUT : if SIZE_INPUT = SIZE_OUTPUT generate
    s_out <= s_in;
  end generate SIZE_IN_equ_SIZE_OUT;

  SIZE_IN_sup_SIZE_OUT : if SIZE_INPUT > SIZE_OUTPUT generate

    saturated <= '0' when s_in(SIZE_INPUT-1 downto SIZE_OUTPUT-1) = all_zero else
                 '0' when s_in(SIZE_INPUT-1 downto SIZE_OUTPUT-1) = all_one  else
                 '1';

    s_out(SIZE_OUTPUT-1) <= s_in(SIZE_INPUT-1);

    all_bits : for I in SIZE_OUTPUT-2 downto 0 generate
      s_out(I) <= s_in(I) when saturated = '0' else not s_in(SIZE_INPUT-1);
    end generate all_bits;

  end generate SIZE_IN_sup_SIZE_OUT;



end architecture beh;
