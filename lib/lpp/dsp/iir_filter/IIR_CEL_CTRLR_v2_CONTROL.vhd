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
--  GNU General Public License for more Cdetails.
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

ENTITY IIR_CEL_CTRLR_v2_CONTROL IS
  GENERIC (
    Coef_sel_SZ  : INTEGER;
    Cels_count   : INTEGER := 5;
    ChanelsCount : INTEGER := 1);
  PORT (
    rstn : IN STD_LOGIC;
    clk  : IN STD_LOGIC;

    sample_in_val  : IN  STD_LOGIC;
    sample_in_rot  : OUT STD_LOGIC;
    sample_out_val : OUT STD_LOGIC;
    sample_out_rot : OUT STD_LOGIC;

    in_sel_src     : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    ram_sel_Wdata  : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    ram_write      : OUT STD_LOGIC;
    ram_read       : OUT STD_LOGIC;
    raddr_rst      : OUT STD_LOGIC;
    raddr_add1     : OUT STD_LOGIC;
    waddr_previous : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    alu_sel_input  : OUT STD_LOGIC;
    alu_sel_coeff  : OUT STD_LOGIC_VECTOR(Coef_sel_SZ-1 DOWNTO 0);
    alu_ctrl       : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END IIR_CEL_CTRLR_v2_CONTROL;

ARCHITECTURE ar_IIR_CEL_CTRLR_v2_CONTROL OF IIR_CEL_CTRLR_v2_CONTROL IS

  TYPE fsmIIR_CEL_T IS (waiting,
                        first_read,
                        compute_b0,
                        compute_b1,
                        compute_b2,
                        compute_a1,
                        compute_a2,
                        LAST_CEL,
                        wait_valid_last_output,
                        wait_valid_last_output_2);
  SIGNAL IIR_CEL_STATE : fsmIIR_CEL_T;

  SIGNAL alu_selected_coeff : INTEGER;
  SIGNAL Chanel_ongoing     : INTEGER;
  SIGNAL Cel_ongoing        : INTEGER;
  
BEGIN

  alu_sel_coeff <= STD_LOGIC_VECTOR(to_unsigned(alu_selected_coeff, Coef_sel_SZ));

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      --REG -------------------------------------------------------------------
      in_sel_src         <= (OTHERS => '0');  -- 
      --RAM_WRitE -------------------------------------------------------------
      ram_sel_Wdata      <= "00";       --
      ram_write          <= '0';        --
      waddr_previous     <= "00";       --
      --RAM_READ --------------------------------------------------------------
      ram_read           <= '0';        --
      raddr_rst          <= '0';        --     
      raddr_add1         <= '0';        --
      --ALU -------------------------------------------------------------------
      alu_selected_coeff <= 0;          --      
      alu_sel_input      <= '0';        --
      alu_ctrl           <= ctrl_IDLE;  --
      --OUT
      sample_out_val     <= '0';        --
      sample_out_rot     <= '0';        --

      Chanel_ongoing <= 0;              --
      Cel_ongoing    <= 0;              --
      sample_in_rot  <= '0';
      
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
      
      CASE IIR_CEL_STATE IS
        WHEN waiting =>
          sample_out_rot     <= '0';
          sample_in_rot      <= '0';
          sample_out_val     <= '0';
          alu_ctrl           <= ctrl_CLRMAC;
          alu_selected_coeff <= 0;
          in_sel_src         <= "01";
          ram_read           <= '0';
          ram_sel_Wdata      <= "00";
          ram_write          <= '0';
          waddr_previous     <= "00";
          IF sample_in_val = '1' THEN
            raddr_rst      <= '0';
            alu_sel_input  <= '1';
            ram_read       <= '1';
            raddr_add1     <= '1';
            IIR_CEL_STATE  <= first_read;
            Chanel_ongoing <= Chanel_ongoing + 1;
            Cel_ongoing    <= 1;
          ELSE
            raddr_add1     <= '0';
            raddr_rst      <= '1';
            Chanel_ongoing <= 0;
            Cel_ongoing    <= 0;
          END IF;

        WHEN first_read =>
          IIR_CEL_STATE <= compute_b2;
          ram_read      <= '1';
          raddr_add1    <= '1';     
          alu_ctrl      <= ctrl_MULT;
          alu_sel_input <= '1';
          in_sel_src    <= "01";
          
          
        WHEN compute_b2 =>
          sample_out_rot <= '0';

          sample_in_rot  <= '0';
          sample_out_val <= '0';

          alu_sel_input  <= '1';
          -- 
          ram_sel_Wdata  <= "10";
          ram_write      <= '1';
          waddr_previous <= "10";
          --
          ram_read       <= '1';
          raddr_rst      <= '0';
          raddr_add1     <= '0';
          IF Cel_ongoing = 1 THEN
            in_sel_src <= "00";
          ELSE
            in_sel_src <= "11";
          END IF;
          alu_selected_coeff <= alu_selected_coeff+1;
          alu_ctrl           <= ctrl_MAC;
          IIR_CEL_STATE      <= compute_b1;
          
        WHEN compute_b1 =>
          sample_in_rot  <= '0';
          alu_sel_input  <= '0';
          --
          ram_sel_Wdata  <= "00";
          ram_write      <= '1';
          waddr_previous <= "01";
          --
          ram_read       <= '1';
          raddr_rst      <= '0';
          raddr_add1     <= '1';        
          sample_out_rot <= '0';        
          IF Cel_ongoing = 1 THEN
            in_sel_src     <= "10";
            sample_out_val <= '0';      
          ELSE
            sample_out_val <= '0';      
            in_sel_src     <= "00";
          END IF;
          alu_selected_coeff <= alu_selected_coeff+1;
          alu_ctrl           <= ctrl_MAC;
          IIR_CEL_STATE      <= compute_b0;
          
        WHEN compute_b0 =>
          sample_out_rot     <= '0';     
          sample_out_val     <= '0';     
          sample_in_rot      <= '0';
          alu_sel_input      <= '1';     
          ram_sel_Wdata      <= "00";    
          ram_write          <= '0';
          waddr_previous     <= "01";
          ram_read           <= '1';
          raddr_rst          <= '0';
          raddr_add1         <= '0';     
          in_sel_src         <= "10";    
          alu_selected_coeff <= alu_selected_coeff+1;
          alu_ctrl           <= ctrl_MAC;
          IIR_CEL_STATE      <= compute_a2;
          IF Cel_ongoing = Cels_count THEN
            sample_in_rot <= '1';
          ELSE
            sample_in_rot <= '0';
          END IF;
          
        WHEN compute_a2 =>
          sample_out_val <= '0';    
          sample_out_rot <= '0';    
          alu_sel_input  <= '1';
          ram_sel_Wdata  <= "00";   
          ram_write      <= '0';
          waddr_previous <= "01";
          ram_read       <= '1';
          raddr_rst      <= '0';
          IF Cel_ongoing = Cels_count THEN
            raddr_add1 <= '1';
          ELSE
            raddr_add1 <= '0';
          END IF;
          in_sel_src         <= "00";
          alu_selected_coeff <= alu_selected_coeff+1;
          alu_ctrl           <= ctrl_MAC;
          IIR_CEL_STATE      <= compute_a1;
          sample_in_rot      <= '0';
          
        WHEN compute_a1 =>
          sample_out_val <= '0';
          sample_out_rot <= '0';
          alu_sel_input  <= '0';
          ram_sel_Wdata  <= "00";
          ram_write      <= '0';
          waddr_previous <= "01";
          ram_read       <= '1';
          raddr_rst      <= '0';
          alu_ctrl       <= ctrl_MULT;
          sample_in_rot  <= '0';
          IF Cel_ongoing = Cels_count THEN
            alu_selected_coeff <= 0;

            ram_sel_Wdata  <= "10";
            raddr_add1     <= '1';
            ram_write      <= '1';
            waddr_previous <= "10";

            IF Chanel_ongoing = ChanelsCount THEN
              IIR_CEL_STATE <= wait_valid_last_output;
            ELSE
              Chanel_ongoing <= Chanel_ongoing + 1;
              Cel_ongoing    <= 1;
              IIR_CEL_STATE  <= LAST_CEL;
              in_sel_src     <= "01";
            END IF;
          ELSE
            raddr_add1         <= '1';
            alu_selected_coeff <= alu_selected_coeff+1;
            Cel_ongoing        <= Cel_ongoing+1;
            IIR_CEL_STATE      <= compute_b2;
          END IF;

        WHEN LAST_CEL =>
          alu_sel_input  <= '1';
          IIR_CEL_STATE  <= compute_b2;
          raddr_add1     <= '1';
          ram_sel_Wdata  <= "01";
          ram_write      <= '1';
          waddr_previous <= "10";
          sample_out_rot <= '1';
          
          
        WHEN wait_valid_last_output =>
          IIR_CEL_STATE      <= wait_valid_last_output_2;
          sample_in_rot      <= '0';
          alu_ctrl           <= ctrl_IDLE;
          alu_selected_coeff <= 0;
          in_sel_src         <= "01";
          ram_read           <= '0';
          raddr_rst          <= '1';
          raddr_add1         <= '1';
          ram_sel_Wdata      <= "01";
          ram_write          <= '1';
          waddr_previous     <= "10";
          Chanel_ongoing     <= 0;
          Cel_ongoing        <= 0;
          sample_out_val     <= '0';
          sample_out_rot     <= '1';
          
        WHEN wait_valid_last_output_2 =>
          IIR_CEL_STATE      <= waiting;
          sample_in_rot      <= '0';
          alu_ctrl           <= ctrl_IDLE;
          alu_selected_coeff <= 0;
          in_sel_src         <= "01";
          ram_read           <= '0';
          raddr_rst          <= '1';
          raddr_add1         <= '1';
          ram_sel_Wdata      <= "10";
          ram_write          <= '1';
          waddr_previous     <= "10";
          Chanel_ongoing     <= 0;
          Cel_ongoing        <= 0;
          sample_out_val     <= '1';
          sample_out_rot     <= '0';
        WHEN OTHERS => NULL;
      END CASE;
      
    END IF;
  END PROCESS;
  
END ar_IIR_CEL_CTRLR_v2_CONTROL;