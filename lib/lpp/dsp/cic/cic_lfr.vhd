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
--                    Mail   : jean-christophe.pellion@lpp.polytechnique.fr
--                             jean-christophe.pellion@easii-ic.com
----------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.all;

LIBRARY lpp;
USE lpp.cic_pkg.ALL;
USE lpp.data_type_pkg.ALL;
USE lpp.iir_filter.ALL;

LIBRARY techmap;
USE techmap.gencomp.ALL;

ENTITY cic_lfr IS
  GENERIC(
    tech         : INTEGER := 0;
    use_RAM_nCEL : INTEGER := 0         -- 1 => RAM(tech) , 0 => RAM_CEL
    );    
  PORT (
    clk            : IN  STD_LOGIC;
    rstn           : IN  STD_LOGIC;
    run            : IN  STD_LOGIC;
    
    data_in        : IN  sample_vector(5 DOWNTO 0,15 DOWNTO 0);
    data_in_valid  : IN  STD_LOGIC;

    data_out_16        : OUT sample_vector(5 DOWNTO 0,15 DOWNTO 0);
    data_out_16_valid  : OUT STD_LOGIC;
    data_out_256       : OUT sample_vector(5 DOWNTO 0,15 DOWNTO 0);
    data_out_256_valid : OUT STD_LOGIC
    );

END cic_lfr;

ARCHITECTURE beh OF cic_lfr IS
  --
  SIGNAL sel_sample  : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL sample_temp : sample_vector(5 DOWNTO 0,15 DOWNTO 0);
  SIGNAL sample      : STD_LOGIC_VECTOR(15 DOWNTO 0);
  --
  SIGNAL sel_A  : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL data_A_temp : sample_vector(2 DOWNTO 0,15 DOWNTO 0);
  SIGNAL data_A  : STD_LOGIC_VECTOR(15 DOWNTO 0);
  --
  SIGNAL ALU_OP : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL data_B      : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL data_B_reg      : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL data_out      : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL data_in_Carry  : STD_LOGIC;
  SIGNAL data_out_Carry : STD_LOGIC;
  --
  CONSTANT S_parameter : INTEGER := 3;
  SIGNAL carry_reg  : STD_LOGIC_VECTOR(S_parameter-1 DOWNTO 0);
  SIGNAL CARRY_PUSH : STD_LOGIC;
  SIGNAL CARRY_POP  : STD_LOGIC;
  --
  
  SIGNAL OPERATION    : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL OPERATION_reg: STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL OPERATION_reg2: STD_LOGIC_VECTOR(15 DOWNTO 0);

  -----------------------------------------------------------------------------
  TYPE ARRAY_OF_ADDR IS ARRAY (5 DOWNTO 0) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL   base_addr_INT   : ARRAY_OF_ADDR;
  CONSTANT base_addr_delta : INTEGER := 40;
  SIGNAL addr_base_sel : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL addr_gen: STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL addr_read: STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL addr_write: STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL addr_write_mux: STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL addr_write_s: STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL data_we: STD_LOGIC;
  SIGNAL data_we_s: STD_LOGIC;
  SIGNAL data_wen       : STD_LOGIC;
--  SIGNAL data_write     : STD_LOGIC_VECTOR(15 DOWNTO 0);
--  SIGNAL data_read      : STD_LOGIC_VECTOR(15 DOWNTO 0);
--  SIGNAL data_read_pre      : STD_LOGIC_VECTOR(15 DOWNTO 0);
  -----------------------------------------------------------------------------
  SIGNAL sample_out_reg16   : sample_vector(6*2-1 DOWNTO 0, 15 DOWNTO 0);
  SIGNAL sample_out_reg256  : sample_vector(6*3-1 DOWNTO 0, 15 DOWNTO 0);
  SIGNAL sample_valid_reg16 : STD_LOGIC_VECTOR(6*2 DOWNTO 0);
  SIGNAL sample_valid_reg256: STD_LOGIC_VECTOR(6*3 DOWNTO 0);
  SIGNAL  data_out_16_valid_s  : STD_LOGIC;
  SIGNAL  data_out_256_valid_s : STD_LOGIC;
  SIGNAL  data_out_16_valid_s1  : STD_LOGIC;
  SIGNAL  data_out_256_valid_s1 : STD_LOGIC;
  SIGNAL  data_out_16_valid_s2  : STD_LOGIC;
  SIGNAL  data_out_256_valid_s2 : STD_LOGIC;
  -----------------------------------------------------------------------------
  SIGNAL sample_out_reg16_s   : sample_vector(5 DOWNTO 0, 16*2-1 DOWNTO 0);
  SIGNAL sample_out_reg256_s  : sample_vector(5 DOWNTO 0, 16*3-1 DOWNTO 0);  
  -----------------------------------------------------------------------------

  
BEGIN


  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      data_B_reg <=  (OTHERS => '0');
      OPERATION_reg <= (OTHERS => '0');
      OPERATION_reg2 <= (OTHERS => '0');
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      OPERATION_reg <= OPERATION;
      OPERATION_reg2 <= OPERATION_reg;
      data_B_reg <= data_B;
    END IF;
  END PROCESS;

  
  -----------------------------------------------------------------------------
  -- SEL_SAMPLE
  -----------------------------------------------------------------------------
  sel_sample <= OPERATION_reg(2 DOWNTO 0);
  
  all_bit: FOR I IN 15 DOWNTO 0 GENERATE
    sample_temp(0,I) <= data_in(0,I)     WHEN sel_sample(0) = '0' ELSE data_in(1,I);
    sample_temp(1,I) <= data_in(2,I)     WHEN sel_sample(0) = '0' ELSE data_in(3,I);
    sample_temp(2,I) <= data_in(4,I)     WHEN sel_sample(0) = '0' ELSE data_in(5,I);

    sample_temp(4,I) <= sample_temp(0,I) WHEN sel_sample(1) = '0' ELSE sample_temp(1,I);
    sample_temp(5,I) <= sample_temp(2,I) WHEN sel_sample(1) = '0' ELSE '0';

    sample(I)        <= sample_temp(4,I) WHEN sel_sample(2) = '0' ELSE sample_temp(5,I);
  END GENERATE all_bit;  

  -----------------------------------------------------------------------------
  -- SEL_DATA_IN_A
  -----------------------------------------------------------------------------
  sel_A <= OPERATION_reg(4 DOWNTO 3);

  all_data_mux_A: FOR I IN 15 DOWNTO 0 GENERATE
    data_A_temp(0,I) <= sample(I) WHEN sel_A(0) = '0' ELSE data_out(I);
    data_A_temp(1,I) <= '0'       WHEN sel_A(0) = '0' ELSE sample(15);    
    data_A_temp(2,I) <= data_A_temp(0,I) WHEN sel_A(1) = '0' ELSE data_A_temp(1,I);
    data_A(I)        <= data_A_temp(2,I) WHEN OPERATION_reg(14) = '0' ELSE data_B_reg(I);
  END GENERATE all_data_mux_A;

  
    
  -----------------------------------------------------------------------------
  -- ALU
  -----------------------------------------------------------------------------
  ALU_OP <= OPERATION_reg(6 DOWNTO 5);
  
  ALU: cic_lfr_add_sub
    PORT MAP (
      clk            => clk,
      rstn           => rstn,
      run            => run,

      OP             => ALU_OP,

      data_in_A      => data_A,
      data_in_B      => data_B,
      data_in_Carry  => data_in_Carry,
      
      data_out       => data_out,
      data_out_Carry => data_out_Carry);

  -----------------------------------------------------------------------------
  -- CARRY_MANAGER
  -----------------------------------------------------------------------------
  data_in_Carry <= carry_reg(S_parameter-2) WHEN OPERATION_reg(7) = '0' ELSE carry_reg(S_parameter-1);
  
--  CARRY_PUSH <= OPERATION_reg(7);
--  CARRY_POP  <= OPERATION_reg(6);

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      carry_reg <= (OTHERS => '0');
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      --IF CARRY_POP = '1' OR CARRY_PUSH = '1' THEN
        carry_reg(S_parameter-1 DOWNTO 1) <= carry_reg(S_parameter-2 DOWNTO 0);
        carry_reg(0)                      <= data_out_Carry;
      --END IF;
    END IF;
  END PROCESS;
  
  -----------------------------------------------------------------------------
  -- MEMORY
  -----------------------------------------------------------------------------
  all_channel: FOR I IN 5 DOWNTO 0 GENERATE
    all_bit: FOR J IN 7 DOWNTO 0 GENERATE
      base_addr_INT(I)(J) <= '1' WHEN (base_addr_delta * I/(2**J)) MOD 2 = 1 ELSE '0';
    END GENERATE all_bit;
  END GENERATE all_channel;
  addr_base_sel <= base_addr_INT(to_integer(UNSIGNED(OPERATION(2 DOWNTO 0))));
  
  cic_lfr_address_gen_1: cic_lfr_address_gen
    PORT MAP (
      clk               => clk,
      rstn              => rstn,
      run               => run,
      
      addr_base         => addr_base_sel,
      addr_init         => OPERATION(8),
      addr_add_1        => OPERATION(9),
      addr              => addr_gen);

    
  addr_read <= addr_gen                                                               WHEN OPERATION(12 DOWNTO 10) = "000" ELSE
               STD_LOGIC_VECTOR(to_unsigned(to_integer(UNSIGNED(addr_base_sel))+2,8)) WHEN OPERATION(12 DOWNTO 10) = "001" ELSE
               STD_LOGIC_VECTOR(to_unsigned(to_integer(UNSIGNED(addr_base_sel))+5,8)) WHEN OPERATION(12 DOWNTO 10) = "010" ELSE
               STD_LOGIC_VECTOR(to_unsigned(to_integer(UNSIGNED(addr_base_sel))+8,8)) WHEN OPERATION(12 DOWNTO 10) = "011" ELSE
               STD_LOGIC_VECTOR(to_unsigned(to_integer(UNSIGNED(addr_gen     ))+6,8)) WHEN OPERATION(12 DOWNTO 10) = "100" ELSE
               STD_LOGIC_VECTOR(to_unsigned(to_integer(UNSIGNED(addr_gen     ))+15,8));
  
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      addr_write   <= (OTHERS => '0');
      data_we      <= '0';
      addr_write_s <= (OTHERS => '0');
      data_we_s    <= '0';
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      addr_write_s <= addr_read;
      data_we_s    <= OPERATION(13);
      IF OPERATION_reg(15) = '0' THEN
        addr_write   <= addr_write_s;
      ELSE
        addr_write <= addr_read;
      END IF;
      data_we      <= data_we_s;
    END IF;
  END PROCESS;

  memCEL : IF use_RAM_nCEL = 0 GENERATE
    data_wen <= NOT data_we;
    RAMblk : RAM_CEL
      GENERIC MAP(16, 8)
      PORT MAP(
        WD    => data_out,
        RD    => data_B,
        WEN   => data_wen,
        REN   => '0',
        WADDR => addr_write,
        RADDR => addr_read,
        RWCLK => clk,
        RESET => rstn
        ) ;
  END GENERATE;

  memRAM : IF use_RAM_nCEL = 1 GENERATE
    SRAM : syncram_2p
      GENERIC MAP(tech, 8, 16)
      PORT MAP(clk, '1', addr_read,  data_B,
               clk, data_we, addr_write, data_out);
  END GENERATE;

  -----------------------------------------------------------------------------
  -- CONTROL
  -----------------------------------------------------------------------------
  cic_lfr_control_1: cic_lfr_control
    PORT MAP (
      clk                => clk,
      rstn               => rstn,
      run                => run,
      data_in_valid      => data_in_valid,
      data_out_16_valid  => data_out_16_valid_s,
      data_out_256_valid => data_out_256_valid_s,
      OPERATION          => OPERATION);
  
  -----------------------------------------------------------------------------
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      data_out_16_valid_s1 <= '0';
      data_out_256_valid_s1 <= '0';
      data_out_16_valid_s2 <= '0';
      data_out_256_valid_s2 <= '0';
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      data_out_16_valid_s1 <= data_out_16_valid_s;
      data_out_256_valid_s1 <= data_out_256_valid_s;
      data_out_16_valid_s2  <= data_out_16_valid_s1;
      data_out_256_valid_s2 <= data_out_256_valid_s1;      
    END IF;
  END PROCESS;

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      sample_valid_reg16  <= '0' & "000000" & "000001";
      sample_valid_reg256 <= '0' & "000000" & "000000" & "000001";
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      IF run = '0' THEN
        sample_valid_reg16  <= '0' & "000000" & "000001";
        sample_valid_reg256 <= '0' & "000000" & "000000" & "000001";
      ELSE
        IF data_out_16_valid_s2 = '1' OR sample_valid_reg16(6*2) = '1' THEN
          sample_valid_reg16  <= sample_valid_reg16(6*2-1 DOWNTO 0)  & sample_valid_reg16(6*2);
        END IF;
        IF data_out_256_valid_s2 = '1' OR sample_valid_reg256(6*3) = '1' THEN
          sample_valid_reg256 <= sample_valid_reg256(6*3-1 DOWNTO 0) & sample_valid_reg256(6*3);
        END IF;
      END IF;      
    END IF;
  END PROCESS;

  data_out_16_valid  <= sample_valid_reg16(6*2);
  data_out_256_valid <= sample_valid_reg256(6*3);

  -----------------------------------------------------------------------------
  
  all_bits: FOR J IN 15 DOWNTO 0 GENERATE
    all_channel_out16: FOR I IN 6*2-1 DOWNTO 0 GENERATE
      PROCESS (clk, rstn)
      BEGIN  -- PROCESS
        IF rstn = '0' THEN              -- asynchronous reset (active low)
          sample_out_reg16(I,J)  <= '0';
        ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
          IF run = '0' THEN
            sample_out_reg16(I,J)  <= '0';
          ELSE
            IF sample_valid_reg16(I) = '1' AND data_out_16_valid_s2 = '1' THEN
              sample_out_reg16(I,J) <= data_out(J);
            END IF;
          END IF;
        END IF;
      END PROCESS;
    END GENERATE all_channel_out16;  

    all_channel_out256: FOR I IN 6*3-1 DOWNTO 0 GENERATE
      PROCESS (clk, rstn)
      BEGIN  -- PROCESS
        IF rstn = '0' THEN              -- asynchronous reset (active low)
          sample_out_reg256(I,J) <= '0';
        ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
          IF run = '0' THEN
            sample_out_reg256(I,J) <= '0';
          ELSE
            IF sample_valid_reg256(I) = '1' AND data_out_256_valid_s2 = '1' THEN
              sample_out_reg256(I,J) <= data_out(J);
            END IF;
          END IF;
        END IF;
      END PROCESS;
    END GENERATE all_channel_out256;
  END GENERATE all_bits;
  

  all_channel_out: FOR I IN 5 DOWNTO 0 GENERATE
    all_bits: FOR J IN 15 DOWNTO 0 GENERATE
      all_reg_16: FOR K IN 1 DOWNTO 0 GENERATE
        sample_out_reg16_s(I,J+(K*16)) <= sample_out_reg16(2*I+K,J);
      END GENERATE all_reg_16;
      all_reg_256: FOR K IN 2 DOWNTO 0 GENERATE
        sample_out_reg256_s(I,J+(K*16)) <= sample_out_reg256(3*I+K,J);
      END GENERATE all_reg_256;
    END GENERATE all_bits;
  END GENERATE all_channel_out;
  
  all_channel_out_v: FOR I IN 5 DOWNTO 0 GENERATE
    all_bits: FOR J IN 15 DOWNTO 0 GENERATE
      data_out_256(I,J) <= sample_out_reg256_s(I,J+16*2-32+27);
      data_out_16(I,J)  <= sample_out_reg16_s (I,J+16  -16+15);
    END GENERATE all_bits;    
  END GENERATE all_channel_out_v;
  
END beh;

