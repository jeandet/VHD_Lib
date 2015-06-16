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
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY dynamic_freq_div IS
  GENERIC(
    PRESZ  : INTEGER RANGE 1 TO 32 := 4;
    PREMAX : INTEGER               := 16#FFFFFF#;
    CPTSZ  : INTEGER RANGE 1 TO 32 := 16
    );
  PORT (
    clk     : IN  STD_LOGIC;
    rstn    : IN  STD_LOGIC;
    pre     : IN  STD_LOGIC_VECTOR(PRESZ-1 DOWNTO 0);
    N       : IN  STD_LOGIC_VECTOR(CPTSZ-1 DOWNTO 0);
    Reload  : IN  STD_LOGIC;
    clk_out : OUT STD_LOGIC
    );
END dynamic_freq_div;

ARCHITECTURE Behavioral OF dynamic_freq_div IS
  CONSTANT prescaller_reg_sz : INTEGER                            := 2**PRESZ;
  CONSTANT PREMAX_max        : STD_LOGIC_VECTOR(PRESZ-1 DOWNTO 0) := (OTHERS => '1');
  SIGNAL   cpt_reg           : STD_LOGIC_VECTOR(CPTSZ-1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL   prescaller_reg    : STD_LOGIC_VECTOR(prescaller_reg_sz-1 DOWNTO 0);  --:=(others => '0');
  SIGNAL   internal_clk      : STD_LOGIC                          := '0';
  SIGNAL   internal_clk_reg  : STD_LOGIC                          := '0';
  SIGNAL   clk_out_reg       : STD_LOGIC                          := '0';

BEGIN

  max0 : IF (UNSIGNED(PREMAX_max) < PREMAX) GENERATE

    internal_clk <= prescaller_reg(to_integer(UNSIGNED(pre))) WHEN (to_integer(UNSIGNED(pre)) <= UNSIGNED(PREMAX_max)) ELSE
                    prescaller_reg(to_integer(UNSIGNED(PREMAX_max)));
  END GENERATE;

  max1 : IF UNSIGNED(PREMAX_max) > PREMAX GENERATE
    internal_clk <= prescaller_reg(to_integer(UNSIGNED(pre))) WHEN (to_integer(UNSIGNED(pre)) <= PREMAX) ELSE
                    prescaller_reg(PREMAX);
  END GENERATE;



  prescaller : PROCESS(rstn, clk)
  BEGIN
    IF rstn = '0' then
      prescaller_reg <= (OTHERS => '0');
    ELSIF clk'EVENT AND clk = '1' THEN
      prescaller_reg <= STD_LOGIC_VECTOR(UNSIGNED(prescaller_reg) + 1);
    END IF;
  END PROCESS;


  clk_out <= clk_out_reg;

  counter : PROCESS(rstn, clk)
  BEGIN
    IF rstn = '0' then
      cpt_reg          <= (OTHERS => '0');
      internal_clk_reg <= '0';
      clk_out_reg      <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      internal_clk_reg <= internal_clk;
      IF Reload = '1' THEN
        clk_out_reg <= '0';
        cpt_reg     <= (OTHERS => '0');
      ELSIF (internal_clk = '1' AND internal_clk_reg = '0') THEN
        IF cpt_reg = N THEN
          clk_out_reg <= NOT clk_out_reg;
          cpt_reg     <= (OTHERS => '0');
        ELSE
          cpt_reg <= STD_LOGIC_VECTOR(UNSIGNED(cpt_reg) + 1);
        END IF;
      END IF;
    END IF;
  END PROCESS;

END Behavioral;
