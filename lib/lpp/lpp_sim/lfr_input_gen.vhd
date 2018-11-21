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
--                    Author : Jean-christophe Pellion
--                     Mail : jean-christophe.pellion@lpp.polytechnique.fr
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_1164.ALL;

LIBRARY std;
USE std.textio.ALL;

ENTITY lfr_input_gen IS

  GENERIC(
    FNAME : STRING := "input.txt"
    );

  PORT (
    end_of_simu            : OUT STD_LOGIC;
    ---------------------------------------------------------------------------
    rhf1401_data           : OUT STD_LOGIC_VECTOR(13 DOWNTO 0);
    -- ADC --------------------------------------------------------------------
    adc_rhf1401_smp_clk    : IN  STD_LOGIC;
    adc_rhf1401_oeb_bar_ch : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
    adc_bias_fail_sel      : IN  STD_LOGIC;
    -- HK ---------------------------------------------------------------------
    hk_rhf1401_smp_clk     : IN  STD_LOGIC;
    hk_rhf1401_oeb_bar_ch  : IN  STD_LOGIC;
    hk_sel                 : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
    ---------------------------------------------------------------------------
    error_oeb              : OUT STD_LOGIC;
    error_hksel            : OUT STD_LOGIC
    );

END ENTITY lfr_input_gen;

ARCHITECTURE beh OF lfr_input_gen IS

  FILE input_file : TEXT OPEN read_mode IS FNAME;

  TYPE SAMPLE_VECTOR_TYPE IS ARRAY (NATURAL RANGE <>) OF STD_LOGIC_VECTOR(13 DOWNTO 0);
  SIGNAL sample_vector     : SAMPLE_VECTOR_TYPE(1 TO 16);

  SIGNAL sample_vector_adc : SAMPLE_VECTOR_TYPE(1  TO 13);
  SIGNAL sample_vector_hk  : SAMPLE_VECTOR_TYPE(14 TO 16);

  SIGNAL sample_vector_reg     : SAMPLE_VECTOR_TYPE(1  TO 16);
  SIGNAL sample_vector_adc_reg : SAMPLE_VECTOR_TYPE(1  TO 13);
  SIGNAL sample_vector_hk_reg  : SAMPLE_VECTOR_TYPE(14 TO 16);


  SIGNAL oeb_bar_ch : STD_LOGIC_VECTOR(8 DOWNTO 0);

BEGIN  -- ARCHITECTURE beh

  -----------------------------------------------------------------------------
  -- Data orginization in the input file :
  -----------------------------------------------------------------------------
  -- Exemple of input.txt file :
  -- Time1 B1 B2 B3 BIAS1 BIAS2 BIAS3 BIAS4 BIAS5 V1 V2 V3 GND1 GND2 HK1 HK2 HK3
  -- Time2 B1 B2 B3 BIAS1 BIAS2 BIAS3 BIAS4 BIAS5 V1 V2 V3 GND1 GND2 HK1 HK2 HK3
  -----------------------------------------------------------------------------
  -- Time : integer. Duration time (in ns) to set the following data
  -- Data : unsigned (0 to 255). A part of the message.
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  PROCESS IS
    VARIABLE line_var          : LINE;
    VARIABLE waiting_time      : INTEGER;
    VARIABLE value             : INTEGER;
  BEGIN  -- PROCESS

    IF endfile(input_file) THEN
      end_of_simu <= '1';
    ELSE
      end_of_simu <= '0';
      readline(input_file, line_var);
      read(line_var, waiting_time);
      FOR sample_index IN 1 TO 16 LOOP
        read(line_var, value);
        sample_vector(sample_index) <= STD_LOGIC_VECTOR(to_unsigned(value, 14));
      END LOOP;  -- sample

      WAIT FOR waiting_time * 1 ns;
    END IF;

  END PROCESS;

  all_adc_sample: FOR sample_index IN 1 TO 13 GENERATE
    sample_vector_adc(sample_index) <= sample_vector        (sample_index);
    sample_vector_reg(sample_index) <= sample_vector_adc_reg(sample_index);
  END GENERATE all_adc_sample;
  all_hk_sample: FOR sample_index IN 14 TO 16 GENERATE
    sample_vector_hk (sample_index) <= sample_vector       (sample_index);
    sample_vector_reg(sample_index) <= sample_vector_hk_reg(sample_index);
  END GENERATE all_hk_sample;


  -----------------------------------------------------------------------------
  PROCESS  IS
  BEGIN  -- PROCESS
    WAIT UNTIL adc_rhf1401_smp_clk = '1';
    sample_vector_adc_reg <= sample_vector_adc;
  END PROCESS;

  PROCESS  IS
  BEGIN  -- PROCESS
    WAIT UNTIL hk_rhf1401_smp_clk = '1';
    sample_vector_hk_reg <= sample_vector_hk;
  END PROCESS;
  -----------------------------------------------------------------------------

  oeb_bar_ch <= hk_rhf1401_oeb_bar_ch & adc_rhf1401_oeb_bar_ch;

  PROCESS (oeb_bar_ch, sample_vector_reg, hk_sel) IS
  BEGIN  -- PROCESS
    error_oeb   <= '0';
    error_hksel <= '0';
    CASE oeb_bar_ch IS
      WHEN "111111111" => NULL;
      WHEN "111111110" => IF adc_bias_fail_sel = '1' THEN rhf1401_data <= sample_vector_reg(4); ELSE rhf1401_data <= sample_vector_reg( 9);  END IF;
      WHEN "111111101" => IF adc_bias_fail_sel = '1' THEN rhf1401_data <= sample_vector_reg(5); ELSE rhf1401_data <= sample_vector_reg(10);  END IF;
      WHEN "111111011" => IF adc_bias_fail_sel = '1' THEN rhf1401_data <= sample_vector_reg(6); ELSE rhf1401_data <= sample_vector_reg(11);  END IF;
      WHEN "111110111" => IF adc_bias_fail_sel = '1' THEN rhf1401_data <= sample_vector_reg(7); ELSE rhf1401_data <= sample_vector_reg(12);  END IF;
      WHEN "111101111" => IF adc_bias_fail_sel = '1' THEN rhf1401_data <= sample_vector_reg(8); ELSE rhf1401_data <= sample_vector_reg(13);  END IF;
      WHEN "111011111" => rhf1401_data <= sample_vector_reg(1);
      WHEN "110111111" => rhf1401_data <= sample_vector_reg(2);
      WHEN "101111111" => rhf1401_data <= sample_vector_reg(3);
      WHEN "011111111" =>
        CASE hk_sel IS
          WHEN "00" => rhf1401_data <= sample_vector_reg(14);
          WHEN "01" => rhf1401_data <= sample_vector_reg(15);
          WHEN "10" => rhf1401_data <= sample_vector_reg(16);
          WHEN OTHERS => error_hksel <= '1';
        END CASE;
      WHEN OTHERS => error_oeb <= '1';
    END CASE;
  END PROCESS;
  -----------------------------------------------------------------------------

END ARCHITECTURE beh;

