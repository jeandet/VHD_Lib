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
--                    Author : Jean-christophe PELLION
--                    Mail   : jean-christophe.pellion@lpp.polytechnique.fr
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_1164.ALL;
LIBRARY lpp;
USE lpp.iir_filter.ALL;
USE lpp.general_purpose.ALL;



ENTITY IIR_CEL_CTRLR_v2_DATAFLOW IS
  GENERIC(
    tech          : INTEGER := 0;
    Mem_use       : INTEGER := use_RAM;
    Sample_SZ     : INTEGER := 16;
    Coef_SZ       : INTEGER := 9;
    Coef_Nb       : INTEGER := 30;
    Coef_sel_SZ   : INTEGER := 5
    );
  PORT(
    rstn      : IN  STD_LOGIC;
    clk        : IN  STD_LOGIC;
    -- PARAMETER
    virg_pos   : IN  INTEGER;
    coefs      : IN  STD_LOGIC_VECTOR((Coef_SZ*Coef_Nb)-1 DOWNTO 0);
    -- CONTROL
    in_sel_src    : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    -- 
    ram_sel_Wdata : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    ram_write     : IN STD_LOGIC;
    ram_read      : IN STD_LOGIC;
    raddr_rst    : IN STD_LOGIC;
    raddr_add1     : IN STD_LOGIC;
    waddr_previous      : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    --
    alu_sel_input : IN STD_LOGIC;
    alu_sel_coeff : IN STD_LOGIC_VECTOR(Coef_sel_SZ-1 DOWNTO 0);
    alu_ctrl      : IN STD_LOGIC_VECTOR(3 DOWNTO 0);--(MAC_op,  MULT_with_clear_ADD, IDLE)
    -- DATA
    sample_in  : IN  STD_LOGIC_VECTOR(Sample_SZ-1 DOWNTO 0);
    sample_out : OUT STD_LOGIC_VECTOR(Sample_SZ-1 DOWNTO 0)
    );
END IIR_CEL_CTRLR_v2_DATAFLOW;

ARCHITECTURE ar_IIR_CEL_CTRLR_v2_DATAFLOW  OF IIR_CEL_CTRLR_v2_DATAFLOW IS

  COMPONENT RAM_CTRLR_v2
    GENERIC (
      tech       : INTEGER;
      Input_SZ_1 : INTEGER;
      Mem_use    : INTEGER);
    PORT (
      rstn           : IN  STD_LOGIC;
      clk            : IN  STD_LOGIC;
      ram_write      : IN  STD_LOGIC;
      ram_read       : IN  STD_LOGIC;
      raddr_rst      : IN  STD_LOGIC;
      raddr_add1     : IN  STD_LOGIC;
      waddr_previous : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
      sample_in      : IN  STD_LOGIC_VECTOR(Input_SZ_1-1 DOWNTO 0);
      sample_out     : OUT STD_LOGIC_VECTOR(Input_SZ_1-1 DOWNTO 0));
  END COMPONENT;
  
  SIGNAL reg_sample_in : STD_LOGIC_VECTOR(Sample_SZ-1 DOWNTO 0);
  SIGNAL ram_output : STD_LOGIC_VECTOR(Sample_SZ-1 DOWNTO 0);
  SIGNAL alu_output : STD_LOGIC_VECTOR(Sample_SZ-1 DOWNTO 0);
  SIGNAL ram_input : STD_LOGIC_VECTOR(Sample_SZ-1 DOWNTO 0);
  SIGNAL alu_sample : STD_LOGIC_VECTOR(Sample_SZ-1 DOWNTO 0);
  SIGNAL alu_output_s : STD_LOGIC_VECTOR(Sample_SZ+Coef_SZ-1 DOWNTO 0);

  SIGNAL arrayCoeff : MUX_INPUT_TYPE(0 TO (2**Coef_sel_SZ)-1,Coef_SZ-1 DOWNTO 0);
  SIGNAL alu_coef_s : MUX_OUTPUT_TYPE(Coef_SZ-1 DOWNTO 0);
  
  SIGNAL alu_coef   : STD_LOGIC_VECTOR(Coef_SZ-1 DOWNTO 0);
  
BEGIN

  -----------------------------------------------------------------------------
  -- INPUT
  -----------------------------------------------------------------------------
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      reg_sample_in <=  (OTHERS => '0');
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      CASE in_sel_src IS
        WHEN "00" => reg_sample_in <= reg_sample_in;
        WHEN "01" => reg_sample_in <= sample_in;
        WHEN "10" => reg_sample_in <= ram_output;
        WHEN "11" => reg_sample_in <= alu_output;
        WHEN OTHERS => NULL;
      END CASE;
    END IF;
  END PROCESS;
  
  
  -----------------------------------------------------------------------------
  -- RAM + CTRL
  -----------------------------------------------------------------------------

  ram_input <= reg_sample_in WHEN ram_sel_Wdata = "00" ELSE
               alu_output    WHEN ram_sel_Wdata = "01" ELSE
               ram_output;
  
  RAM_CTRLR_v2_1: RAM_CTRLR_v2
    GENERIC MAP (
      tech       => tech,
      Input_SZ_1 => Sample_SZ,
      Mem_use    => Mem_use)
    PORT MAP (
      clk            => clk,
      rstn           => rstn,
      ram_write      => ram_write,
      ram_read       => ram_read,
      raddr_rst      => raddr_rst,
      raddr_add1     => raddr_add1,
      waddr_previous => waddr_previous,
      sample_in      => ram_input,
      sample_out     => ram_output);
  
  -----------------------------------------------------------------------------
  -- MAC_ACC 
  -----------------------------------------------------------------------------
  -- Control : mac_ctrl (MAC_op,  MULT_with_clear_ADD, IDLE)
  -- Data In : mac_sample, mac_coef
  -- Data Out: mac_output

  alu_sample <= reg_sample_in WHEN alu_sel_input = '0' ELSE ram_output;

  coefftable: FOR I IN 0 TO (2**Coef_sel_SZ)-1 GENERATE
    coeff_in: IF I < Coef_Nb GENERATE
      all_bit: FOR J IN Coef_SZ-1 DOWNTO 0 GENERATE
        arrayCoeff(I,J) <= coefs(Coef_SZ*I+J);
      END GENERATE all_bit;
    END GENERATE coeff_in;
    coeff_null: IF I > (Coef_Nb -1) GENERATE
      all_bit: FOR J IN Coef_SZ-1 DOWNTO 0 GENERATE
        arrayCoeff(I,J) <= '0';
      END GENERATE all_bit;        
    END GENERATE coeff_null;
  END GENERATE coefftable;
  
  Coeff_Mux : MUXN
    GENERIC MAP (
      Input_SZ => Coef_SZ,
      NbStage  => Coef_sel_SZ)
    PORT MAP (
      sel    => alu_sel_coeff,
      INPUT  => arrayCoeff,
      RES    => alu_coef_s);
  

  all_bit: FOR J IN Coef_SZ-1 DOWNTO 0 GENERATE
    alu_coef(J) <= alu_coef_s(J);
  END GENERATE all_bit;        

  -----------------------------------------------------------------------------
  -- TODO : just for Synthesis test

  --PROCESS (clk, rstn)
  --BEGIN
  --  IF rstn = '0' THEN
  --    alu_coef <= (OTHERS => '0');
  --  ELSIF clk'event AND clk = '1' THEN
  --    all_bit: FOR J IN Coef_SZ-1 DOWNTO 0 LOOP
  --      alu_coef(J) <= alu_coef_s(J);
  --    END LOOP all_bit;
  --  END IF;
  --END PROCESS;
  
  -----------------------------------------------------------------------------
  
  
  ALU_1: ALU
    GENERIC MAP (
      Arith_en   => 1,
      Input_SZ_1 => Sample_SZ,
      Input_SZ_2 => Coef_SZ)
    PORT MAP (
      clk   => clk,
      reset => rstn,
      ctrl  => alu_ctrl,
      OP1   => alu_sample,
      OP2   => alu_coef,
      RES   => alu_output_s);
  
  alu_output <= alu_output_s(Sample_SZ+virg_pos-1 DOWNTO virg_pos);

  sample_out <= alu_output;
                
END ar_IIR_CEL_CTRLR_v2_DATAFLOW;





































