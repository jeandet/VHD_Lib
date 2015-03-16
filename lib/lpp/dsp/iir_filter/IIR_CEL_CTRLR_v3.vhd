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

LIBRARY techmap;
USE techmap.gencomp.ALL;

LIBRARY lpp;
USE lpp.iir_filter.ALL;
USE lpp.general_purpose.ALL;

ENTITY IIR_CEL_CTRLR_v3 IS
  GENERIC (
    tech         : INTEGER := 0;
    Mem_use      : INTEGER := use_RAM;
    Sample_SZ    : INTEGER := 18;
    Coef_SZ      : INTEGER := 9;
    Coef_Nb      : INTEGER := 25;
    Coef_sel_SZ  : INTEGER := 5;
    Cels_count   : INTEGER := 5;
    ChanelsCount : INTEGER := 8);
  PORT (
    rstn : IN STD_LOGIC;
    clk  : IN STD_LOGIC;

    virg_pos : IN INTEGER;
    coefs    : IN STD_LOGIC_VECTOR((Coef_SZ*Coef_Nb)-1 DOWNTO 0);

    sample_in1_val : IN STD_LOGIC;
    sample_in1     : IN samplT(ChanelsCount-1 DOWNTO 0, Sample_SZ-1 DOWNTO 0);
    sample_in2_val : IN STD_LOGIC;
    sample_in2     : IN samplT(ChanelsCount-1 DOWNTO 0, Sample_SZ-1 DOWNTO 0);

    sample_out1_val : OUT STD_LOGIC;
    sample_out1     : OUT samplT(ChanelsCount-1 DOWNTO 0, Sample_SZ-1 DOWNTO 0);
    sample_out2_val : OUT STD_LOGIC;
    sample_out2     : OUT samplT(ChanelsCount-1 DOWNTO 0, Sample_SZ-1 DOWNTO 0));
END IIR_CEL_CTRLR_v3;

ARCHITECTURE ar_IIR_CEL_CTRLR_v3 OF IIR_CEL_CTRLR_v3 IS

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

  COMPONENT IIR_CEL_CTRLR_v3_DATAFLOW
    GENERIC (
      Sample_SZ   : INTEGER;
      Coef_SZ     : INTEGER;
      Coef_Nb     : INTEGER;
      Coef_sel_SZ : INTEGER);
    PORT (
      rstn          : IN  STD_LOGIC;
      clk           : IN  STD_LOGIC;
      virg_pos      : IN  INTEGER;
      coefs         : IN  STD_LOGIC_VECTOR((Coef_SZ*Coef_Nb)-1 DOWNTO 0);
      in_sel_src    : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
      ram_sel_Wdata : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
      ram_input     : OUT STD_LOGIC_VECTOR(Sample_SZ-1 DOWNTO 0);
      ram_output    : IN  STD_LOGIC_VECTOR(Sample_SZ-1 DOWNTO 0);
      alu_sel_input : IN  STD_LOGIC;
      alu_sel_coeff : IN  STD_LOGIC_VECTOR(Coef_sel_SZ-1 DOWNTO 0);
      alu_ctrl      : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
      alu_comp      : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
      sample_in     : IN  STD_LOGIC_VECTOR(Sample_SZ-1 DOWNTO 0);
      sample_out    : OUT STD_LOGIC_VECTOR(Sample_SZ-1 DOWNTO 0));
  END COMPONENT;

  COMPONENT IIR_CEL_CTRLR_v2_CONTROL
    GENERIC (
      Coef_sel_SZ  : INTEGER;
      Cels_count   : INTEGER;
      ChanelsCount : INTEGER);
    PORT (
      rstn           : IN  STD_LOGIC;
      clk            : IN  STD_LOGIC;
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
      alu_ctrl       : OUT STD_LOGIC_VECTOR(2 DOWNTO 0));
  END COMPONENT;

  SIGNAL in_sel_src     : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL ram_sel_Wdata  : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL ram_write      : STD_LOGIC;
  SIGNAL ram_read       : STD_LOGIC;
  SIGNAL raddr_rst      : STD_LOGIC;
  SIGNAL raddr_add1     : STD_LOGIC;
  SIGNAL waddr_previous : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL alu_sel_input  : STD_LOGIC;
  SIGNAL alu_sel_coeff  : STD_LOGIC_VECTOR(Coef_sel_SZ-1 DOWNTO 0);
  SIGNAL alu_ctrl       : STD_LOGIC_VECTOR(2 DOWNTO 0);

  SIGNAL sample_in_buf     : samplT(ChanelsCount-1 DOWNTO 0, Sample_SZ-1 DOWNTO 0);
  SIGNAL sample_in_rotate  : STD_LOGIC;
  SIGNAL sample_in_s       : STD_LOGIC_VECTOR(Sample_SZ-1 DOWNTO 0);
  SIGNAL sample_out_val_s  : STD_LOGIC;
  SIGNAL sample_out_val_s2 : STD_LOGIC;
  SIGNAL sample_out_rot_s  : STD_LOGIC;
  SIGNAL sample_out_s      : STD_LOGIC_VECTOR(Sample_SZ-1 DOWNTO 0);

  SIGNAL sample_out_s2 : samplT(ChanelsCount-1 DOWNTO 0, Sample_SZ-1 DOWNTO 0);

  SIGNAL ram_input      : STD_LOGIC_VECTOR(Sample_SZ-1 DOWNTO 0);
  SIGNAL ram_output     : STD_LOGIC_VECTOR(Sample_SZ-1 DOWNTO 0);
  --
  SIGNAL sample_in_val  : STD_LOGIC;
  SIGNAL sample_in      : samplT(ChanelsCount-1 DOWNTO 0, Sample_SZ-1 DOWNTO 0);
  SIGNAL sample_out_val : STD_LOGIC;
  SIGNAL sample_out     : samplT(ChanelsCount-1 DOWNTO 0, Sample_SZ-1 DOWNTO 0);

  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  SIGNAL CHANNEL_SEL : STD_LOGIC;

  SIGNAL ram_output_1 : STD_LOGIC_VECTOR(Sample_SZ-1 DOWNTO 0);
  SIGNAL ram_output_2 : STD_LOGIC_VECTOR(Sample_SZ-1 DOWNTO 0);

  SIGNAL ram_write_1      : STD_LOGIC;
  SIGNAL ram_read_1       : STD_LOGIC;
  SIGNAL raddr_rst_1      : STD_LOGIC;
  SIGNAL raddr_add1_1     : STD_LOGIC;
  SIGNAL waddr_previous_1 : STD_LOGIC_VECTOR(1 DOWNTO 0);

  SIGNAL ram_write_2             : STD_LOGIC;
  SIGNAL ram_read_2              : STD_LOGIC;
  SIGNAL raddr_rst_2             : STD_LOGIC;
  SIGNAL raddr_add1_2            : STD_LOGIC;
  SIGNAL waddr_previous_2        : STD_LOGIC_VECTOR(1 DOWNTO 0);
  -----------------------------------------------------------------------------
  SIGNAL channel_ready           : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL channel_val             : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL channel_done            : STD_LOGIC_VECTOR(1 DOWNTO 0);
  -----------------------------------------------------------------------------
  TYPE   FSM_CHANNEL_SELECTION IS (IDLE, ONGOING_1, ONGOING_2, WAIT_STATE);
  SIGNAL state_channel_selection : FSM_CHANNEL_SELECTION;

  --SIGNAL   sample_out_zero     : samplT(ChanelsCount-1 DOWNTO 0, Sample_SZ-1 DOWNTO 0);
  
BEGIN

  -----------------------------------------------------------------------------
  channel_val(0) <= sample_in1_val;
  channel_val(1) <= sample_in2_val;
  all_channel_input_valid : FOR I IN 1 DOWNTO 0 GENERATE
    PROCESS (clk, rstn)
    BEGIN  -- PROCESS
      IF rstn = '0' THEN                  -- asynchronous reset (active low)
        channel_ready(I) <= '0';
      ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
        IF channel_val(I) = '1' THEN
          channel_ready(I) <= '1';
        ELSIF channel_done(I) = '1' THEN
          channel_ready(I) <= '0';
        END IF;
      END IF;
    END PROCESS;
  END GENERATE all_channel_input_valid;
  -----------------------------------------------------------------------------


  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      state_channel_selection <= IDLE;
      CHANNEL_SEL             <= '0';
      sample_in_val           <= '0';
      sample_out1_val         <= '0';
      sample_out2_val         <= '0';
      all_channel_sample_out : FOR I IN ChanelsCount-1 DOWNTO 0 LOOP
        all_bit : FOR J IN Sample_SZ-1 DOWNTO 0 LOOP
          sample_out1(I, J) <= '0';
          sample_out2(I, J) <= '0';
        END LOOP all_bit;
      END LOOP all_channel_sample_out;
      channel_done <= "00";
      
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
      CASE state_channel_selection IS
        WHEN IDLE =>
          CHANNEL_SEL     <= '0';
          sample_in_val   <= '0';
          sample_out1_val <= '0';
          sample_out2_val <= '0';
          channel_done    <= "00";
          IF channel_ready(0) = '1' THEN
            state_channel_selection <= ONGOING_1;
            CHANNEL_SEL             <= '0';
            sample_in_val           <= '1';
          ELSIF channel_ready(1) = '1' THEN
            state_channel_selection <= ONGOING_2;
            CHANNEL_SEL             <= '1';
            sample_in_val           <= '1';
          END IF;
        WHEN ONGOING_1 =>
          sample_in_val <= '0';
          IF sample_out_val = '1' THEN
            state_channel_selection <= WAIT_STATE;
            sample_out1             <= sample_out;
            sample_out1_val         <= '1';
            channel_done(0)         <= '1';
          END IF;
        WHEN ONGOING_2 =>
          sample_in_val <= '0';
          IF sample_out_val = '1' THEN
            state_channel_selection <= WAIT_STATE;
            sample_out2             <= sample_out;
            sample_out2_val         <= '1';
            channel_done(1)         <= '1';
          END IF;
        WHEN WAIT_STATE =>
          state_channel_selection <= IDLE;
          CHANNEL_SEL             <= '0';
          sample_in_val           <= '0';
          sample_out1_val         <= '0';
          sample_out2_val         <= '0';
          channel_done            <= "00";
          
        WHEN OTHERS => NULL;
      END CASE;
      
    END IF;
  END PROCESS;

  sample_in  <= sample_in1   WHEN CHANNEL_SEL = '0' ELSE sample_in2;
  -----------------------------------------------------------------------------
  ram_output <= ram_output_1 WHEN CHANNEL_SEL = '0' ELSE
                      ram_output_2;
  
  ram_write_1      <= ram_write      WHEN CHANNEL_SEL = '0' ELSE '0';
  ram_read_1       <= ram_read       WHEN CHANNEL_SEL = '0' ELSE '0';
  raddr_rst_1      <= raddr_rst      WHEN CHANNEL_SEL = '0' ELSE '1';
  raddr_add1_1     <= raddr_add1     WHEN CHANNEL_SEL = '0' ELSE '0';
  waddr_previous_1 <= waddr_previous WHEN CHANNEL_SEL = '0' ELSE "00";

  ram_write_2      <= ram_write      WHEN CHANNEL_SEL = '1' ELSE '0';
  ram_read_2       <= ram_read       WHEN CHANNEL_SEL = '1' ELSE '0';
  raddr_rst_2      <= raddr_rst      WHEN CHANNEL_SEL = '1' ELSE '1';
  raddr_add1_2     <= raddr_add1     WHEN CHANNEL_SEL = '1' ELSE '0';
  waddr_previous_2 <= waddr_previous WHEN CHANNEL_SEL = '1' ELSE "00";

  RAM_CTRLR_v2_1 : RAM_CTRLR_v2
    GENERIC MAP (
      tech       => tech,
      Input_SZ_1 => Sample_SZ,
      Mem_use    => Mem_use)
    PORT MAP (
      clk            => clk,
      rstn           => rstn,
      ram_write      => ram_write_1,
      ram_read       => ram_read_1,
      raddr_rst      => raddr_rst_1,
      raddr_add1     => raddr_add1_1,
      waddr_previous => waddr_previous_1,
      sample_in      => ram_input,
      sample_out     => ram_output_1);

  RAM_CTRLR_v2_2 : RAM_CTRLR_v2
    GENERIC MAP (
      tech       => tech,
      Input_SZ_1 => Sample_SZ,
      Mem_use    => Mem_use)
    PORT MAP (
      clk            => clk,
      rstn           => rstn,
      ram_write      => ram_write_2,
      ram_read       => ram_read_2,
      raddr_rst      => raddr_rst_2,
      raddr_add1     => raddr_add1_2,
      waddr_previous => waddr_previous_2,
      sample_in      => ram_input,
      sample_out     => ram_output_2);
  -----------------------------------------------------------------------------

  IIR_CEL_CTRLR_v3_DATAFLOW_1 : IIR_CEL_CTRLR_v3_DATAFLOW
    GENERIC MAP (
      Sample_SZ   => Sample_SZ,
      Coef_SZ     => Coef_SZ,
      Coef_Nb     => Coef_Nb,
      Coef_sel_SZ => Coef_sel_SZ)
    PORT MAP (
      rstn          => rstn,
      clk           => clk,
      virg_pos      => virg_pos,
      coefs         => coefs,
      --CTRL
      in_sel_src    => in_sel_src,
      ram_sel_Wdata => ram_sel_Wdata,
      --
      ram_input     => ram_input,
      ram_output    => ram_output,
      --
      alu_sel_input => alu_sel_input,
      alu_sel_coeff => alu_sel_coeff,
      alu_ctrl      => alu_ctrl,
      alu_comp      => "00",
      --DATA
      sample_in     => sample_in_s,
      sample_out    => sample_out_s);
  -----------------------------------------------------------------------------


  IIR_CEL_CTRLR_v3_CONTROL_1 : IIR_CEL_CTRLR_v2_CONTROL
    GENERIC MAP (
      Coef_sel_SZ  => Coef_sel_SZ,
      Cels_count   => Cels_count,
      ChanelsCount => ChanelsCount)
    PORT MAP (
      rstn           => rstn,
      clk            => clk,
      sample_in_val  => sample_in_val,
      sample_in_rot  => sample_in_rotate,
      sample_out_val => sample_out_val_s,
      sample_out_rot => sample_out_rot_s,

      in_sel_src     => in_sel_src,
      ram_sel_Wdata  => ram_sel_Wdata,
      ram_write      => ram_write,
      ram_read       => ram_read,
      raddr_rst      => raddr_rst,
      raddr_add1     => raddr_add1,
      waddr_previous => waddr_previous,
      alu_sel_input  => alu_sel_input,
      alu_sel_coeff  => alu_sel_coeff,
      alu_ctrl       => alu_ctrl);

  -----------------------------------------------------------------------------
  -- SAMPLE IN
  -----------------------------------------------------------------------------
  loop_all_sample : FOR J IN Sample_SZ-1 DOWNTO 0 GENERATE

    loop_all_chanel : FOR I IN ChanelsCount-1 DOWNTO 0 GENERATE
      PROCESS (clk, rstn)
      BEGIN  -- PROCESS
        IF rstn = '0' THEN                  -- asynchronous reset (active low)
          sample_in_buf(I, J) <= '0';
        ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
          IF sample_in_val = '1' THEN
            sample_in_buf(I, J) <= sample_in(I, J);
          ELSIF sample_in_rotate = '1' THEN
            sample_in_buf(I, J) <= sample_in_buf((I+1) MOD ChanelsCount, J);
          END IF;
        END IF;
      END PROCESS;
    END GENERATE loop_all_chanel;

    sample_in_s(J) <= sample_in(0, J) WHEN sample_in_val = '1' ELSE sample_in_buf(0, J);

  END GENERATE loop_all_sample;

  -----------------------------------------------------------------------------
  -- SAMPLE OUT
  -----------------------------------------------------------------------------
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      sample_out_val    <= '0';
      sample_out_val_s2 <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
      sample_out_val    <= sample_out_val_s2;
      sample_out_val_s2 <= sample_out_val_s;
    END IF;
  END PROCESS;

  chanel_HIGH : FOR I IN Sample_SZ-1 DOWNTO 0 GENERATE
    PROCESS (clk, rstn)
    BEGIN  -- PROCESS
      IF rstn = '0' THEN                  -- asynchronous reset (active low)
        sample_out_s2(ChanelsCount-1, I) <= '0';
      ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
        IF sample_out_rot_s = '1' THEN
          sample_out_s2(ChanelsCount-1, I) <= sample_out_s(I);
        END IF;
      END IF;
    END PROCESS;
  END GENERATE chanel_HIGH;

  chanel_more : IF ChanelsCount > 1 GENERATE
    all_chanel : FOR J IN ChanelsCount-1 DOWNTO 1 GENERATE
      all_bit : FOR I IN Sample_SZ-1 DOWNTO 0 GENERATE
        PROCESS (clk, rstn)
        BEGIN  -- PROCESS
          IF rstn = '0' THEN            -- asynchronous reset (active low)
            sample_out_s2(J-1, I) <= '0';
          ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
            IF sample_out_rot_s = '1' THEN
              sample_out_s2(J-1, I) <= sample_out_s2(J, I);
            END IF;
          END IF;
        END PROCESS;
      END GENERATE all_bit;
    END GENERATE all_chanel;
  END GENERATE chanel_more;

  sample_out <= sample_out_s2;
END ar_IIR_CEL_CTRLR_v3;
