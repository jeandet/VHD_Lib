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
    ChanelCount     : INTEGER:=8);
  PORT (
    cnv_clk    : IN  STD_LOGIC;
    clk        : IN  STD_LOGIC;
    rstn       : IN  STD_LOGIC;
    ADC_data   : IN  Samples14;
    ADC_smpclk : OUT STD_LOGIC;
    ADC_nOE    : OUT STD_LOGIC_VECTOR(ChanelCount-1 DOWNTO 0);
    sample     : OUT Samples14v(ChanelCount-1 DOWNTO 0);
    sample_val : OUT STD_LOGIC
    );
END RHF1401_drvr;

ARCHITECTURE ar_RHF1401_drvr OF RHF1401_drvr IS

type      RHF1401_FSM_STATE is (idle,output_en,latch,data_valid);

signal    cnv_clk_reg        :    std_logic_vector(1 downto 0) := (others => '0');
signal    start_readout      :    std_logic := '0';
signal    state              :    RHF1401_FSM_STATE := idle;
signal    adc_index          :    integer range  0 to ChanelCount-1;
signal    ADC_nOE_Reg        :    std_logic_vector(ChanelCount-1 DOWNTO 0);
signal    ADC_nOE_Reg_Shift  :    std_logic_vector(ChanelCount-1 DOWNTO 0);
signal    sample_reg         :    Samples14v(ChanelCount-1 DOWNTO 0);

begin

ADC_smpclk   <=   cnv_clk;

ADC_nOE     <= ADC_nOE_Reg;
ADC_nOE_Reg <= ADC_nOE_Reg_Shift when state = output_en else
               (others => '1');
process(rstn,clk)
begin
     if rstn = '0' then
           cnv_clk_reg(1 downto 0)  <=  (others => '0');
           start_readout <= '0';
     elsif clk'event and clk = '1' then
           cnv_clk_reg(1 downto 0)  <=  cnv_clk_reg(0) & cnv_clk;
           if cnv_clk_reg = "10" and cnv_clk = '0' then
               start_readout <= '1';
           else
               start_readout <= '0';
           end if;
     end if;
end process;


process(rstn,clk)
begin
     if rstn = '0' then
           state             <=  idle;
           ADC_nOE_Reg_Shift <= (others => '1');
           adc_index         <= 0;
           sample_val        <= '0';
     elsif clk'event and clk = '1' then
           case state is
                when idle     =>
                     adc_index  <= 0;
                     if  start_readout = '1' then
                         state  <=  output_en;
                         ADC_nOE_Reg_Shift(0)   <= '0';
                         ADC_nOE_Reg_Shift(ChanelCount-1 DOWNTO 1)   <= (others => '1');
                     end if;
                     sample_val <= '0';
                when output_en =>
                     ADC_nOE_Reg_Shift(ChanelCount-1 DOWNTO 0)  <= ADC_nOE_Reg_Shift(ChanelCount-2 DOWNTO 0) & '1';
                     adc_index  <=  adc_index + 1;
                     sample_val <= '0';
                     state  <=  latch;
                when latch     =>
                     sample_reg(0)  <= ADC_data;
                     sample_reg(ChanelCount-1 DOWNTO 1)     <=   sample_reg(ChanelCount-2 DOWNTO 0);
                     if( adc_index = ChanelCount) then
                         state <= data_valid;
                     else
                         state <= output_en;
                     end if;
                     sample_val <= '0';
                when data_valid =>
                     sample_val <= '1';
                     sample		<= sample_reg;
                     state      <= idle;
           end case;
     end if;
end process;
end ar_RHF1401_drvr;

















