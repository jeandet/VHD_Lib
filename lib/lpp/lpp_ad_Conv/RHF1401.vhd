------------------------------------------------------------------------------
--  This file is a part of the LPP VHDL IP LIBRARY
--  Copyright (C) 2013, Laboratory of Plasmas Physic - CNRS
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
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
LIBRARY lpp;
USE lpp.lpp_ad_conv.ALL;

ENTITY RHF1401_drvr IS
  GENERIC(
    ChanelCount : INTEGER := 8);
  PORT (
    cnv_clk    : IN  STD_LOGIC;
    clk        : IN  STD_LOGIC;
    rstn       : IN  STD_LOGIC;
    ADC_data   : IN  Samples14;
    --ADC_smpclk : OUT STD_LOGIC;
    ADC_nOE    : OUT STD_LOGIC_VECTOR(ChanelCount-1 DOWNTO 0);
    sample     : OUT Samples14v(ChanelCount-1 DOWNTO 0);
    sample_val : OUT STD_LOGIC
    );
END RHF1401_drvr;

ARCHITECTURE ar_RHF1401_drvr OF RHF1401_drvr IS

  TYPE RHF1401_FSM_STATE IS (idle, output_en, latch, data_valid);

  SIGNAL cnv_clk_reg       : STD_LOGIC_VECTOR(1 DOWNTO 0) ;--:= (OTHERS => '0');
  SIGNAL start_readout     : STD_LOGIC                    ;--:= '0';
  SIGNAL state             : RHF1401_FSM_STATE            ;--:= idle;
  SIGNAL adc_index         : INTEGER RANGE 0 TO ChanelCount;  -- ChanelCount-1
  SIGNAL ADC_nOE_Reg       : STD_LOGIC_VECTOR(ChanelCount-1 DOWNTO 0);
  SIGNAL ADC_nOE_Reg_Shift : STD_LOGIC_VECTOR(ChanelCount-1 DOWNTO 0);
  SIGNAL sample_reg        : Samples14v(ChanelCount-1 DOWNTO 0);

BEGIN

  --ADC_smpclk <= cnv_clk;

  ADC_nOE     <= ADC_nOE_Reg;
  ADC_nOE_Reg <= ADC_nOE_Reg_Shift WHEN state = output_en ELSE (OTHERS => '1');
  
  PROCESS(rstn, clk)
  BEGIN
    IF rstn = '0' THEN
      cnv_clk_reg(1 DOWNTO 0) <= (OTHERS => '0');
      start_readout           <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      cnv_clk_reg(1 DOWNTO 0) <= cnv_clk_reg(0) & cnv_clk;
      IF cnv_clk_reg = "10" AND cnv_clk = '0' THEN
        start_readout <= '1';
      ELSE
        start_readout <= '0';
      END IF;
    END IF;
  END PROCESS;


  PROCESS(rstn, clk)
  BEGIN
    IF rstn = '0' THEN
      state             <= idle;
      ADC_nOE_Reg_Shift <= (OTHERS => '1');
      adc_index         <= 0;
      sample_val        <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      CASE state IS
        WHEN idle =>
          adc_index <= 0;
          IF start_readout = '1' THEN
            state                                     <= output_en;
            ADC_nOE_Reg_Shift(0)                      <= '0';
            ADC_nOE_Reg_Shift(ChanelCount-1 DOWNTO 1) <= (OTHERS => '1');
          END IF;
          sample_val <= '0';
        WHEN output_en =>
          sample_reg(0)                      <= ADC_data;                             --JC
          sample_reg(ChanelCount-1 DOWNTO 1) <= sample_reg(ChanelCount-2 DOWNTO 0);   --JC
          ADC_nOE_Reg_Shift(ChanelCount-1 DOWNTO 0) <= ADC_nOE_Reg_Shift(ChanelCount-2 DOWNTO 0) & '1';
          adc_index                                 <= adc_index + 1;
          sample_val                                <= '0';
          state                                     <= latch;
        WHEN latch =>
          --sample_reg(0)                      <= ADC_data;                             --JC
          --sample_reg(ChanelCount-1 DOWNTO 1) <= sample_reg(ChanelCount-2 DOWNTO 0);   --JC
          IF(adc_index = ChanelCount) THEN
            state <= data_valid;
          ELSE
            state <= output_en;
          END IF;
          sample_val <= '0';
        WHEN data_valid =>
          sample_val <= '1';
          sample     <= sample_reg;
          state      <= idle;
      END CASE;
    END IF;
  END PROCESS;

  
END ar_RHF1401_drvr;















