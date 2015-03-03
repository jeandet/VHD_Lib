------------------------------------------------------------------------------
--  This file is a part of the LPP VHDL IP LIBRARY
--  Copyright (C) 2009 - 2015, Laboratory of Plasmas Physic - CNRS
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
------------------------------------------------------------------------------
--                    Author : Alexis Jeandet
--                     Mail : alexis.jeandet@member.fsf.org
------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity dynamic_freq_div is
    generic(
        PRESZ  :  integer range 1 to 32:=4;
        PREMAX :  integer := 16#FFFFFF#;
        CPTSZ  :  integer range 1 to 32:=16
     );
    Port ( 
        clk     : in  STD_LOGIC;
        rstn    : in  STD_LOGIC;
        pre     : in  STD_LOGIC_VECTOR(PRESZ-1 downto 0);
        N       : in  STD_LOGIC_VECTOR(CPTSZ-1 downto 0);
        Reload  : in  std_logic;
        clk_out : out STD_LOGIC
        );
end dynamic_freq_div;

architecture Behavioral of dynamic_freq_div is
constant prescaller_reg_sz : integer := 2**PRESZ;
constant PREMAX_max        : STD_LOGIC_VECTOR(PRESZ-1 downto 0):=(others => '1');
signal cpt_reg             : std_logic_vector(CPTSZ-1 downto 0):=(others => '0');
signal prescaller_reg      : std_logic_vector(prescaller_reg_sz-1 downto 0);--:=(others => '0');
signal internal_clk        : std_logic:='0';
signal internal_clk_reg    : std_logic:='0';
signal clk_out_reg         : std_logic:='0';

begin

max0: if (UNSIGNED(PREMAX_max) < PREMAX) generate

internal_clk <= prescaller_reg(to_integer(unsigned(pre))) when (to_integer(unsigned(pre))<=UNSIGNED(PREMAX_max)) else
                    prescaller_reg(to_integer(UNSIGNED(PREMAX_max)));
end generate;
max1: if UNSIGNED(PREMAX_max) > PREMAX generate
internal_clk <= prescaller_reg(to_integer(unsigned(pre))) when (to_integer(unsigned(pre))<=PREMAX) else
                    prescaller_reg(PREMAX);
end generate;


                
prescaller: process(rstn, clk)
begin
if rstn='0' then
    prescaller_reg    <= (others => '0');
elsif clk'event and clk = '1' then
    prescaller_reg <= std_logic_vector(UNSIGNED(prescaller_reg) + 1);
end if;
end process;


clk_out <= clk_out_reg;

counter: process(rstn, clk)
begin
if rstn='0' then
    cpt_reg    <= (others => '0');
    internal_clk_reg <= '0';
    clk_out_reg <= '0';
elsif clk'event and clk = '1' then
    internal_clk_reg  <= internal_clk;
    if Reload = '1' then
        clk_out_reg <= '0';
        cpt_reg     <= (others => '0');
    elsif (internal_clk = '1' and internal_clk_reg = '0')  then 
        if cpt_reg = N then
            clk_out_reg <= not clk_out_reg;
            cpt_reg     <= (others => '0');
        else 
            cpt_reg     <= std_logic_vector(UNSIGNED(cpt_reg) + 1);
        end if;
    end if;
end if;
end process;

end Behavioral;