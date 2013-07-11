--***************************************************************************************
--
--    File Name:  tb.vhd
--      Version:  1.0
--         Date:  Aug 8th, 2005
--    Simulator:  Modelsim 
--
--
--       Queries:  MPD Applications
--       Website:  www.cypress.com/support
--      Company:  Cypress Semiconductor
--       Part #:  testbench for CY7C1360C (256K x 36)
--
--
--   Disclaimer:  THESE DESIGNS ARE PROVIDED "AS IS" WITH NO WARRANTY 
--                WHATSOEVER AND CYPRESS SPECIFICALLY DISCLAIMS ANY 
--                IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR
--                A PARTICULAR PURPOSE, OR AGAINST INFRINGEMENT.
--
--	Copyright(c) Cypress Semiconductor, 2004
--	All rights reserved
--
-- Rev       Date        Changes
-- ---    ----------  ---------------------------------------
-- 1.0      12/22/2004  - New Model
--                      - New Test Bench
--                      - New Test Vectors
--
--***************************************************************************************

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE std.textio.ALL;
USE ieee.std_logic_textio.ALL;


ENTITY tb IS
END tb;

architecture tb_arch of tb is

    CONSTANT addr_bits : INTEGER := 18;
    CONSTANT data_bits : INTEGER := 36;

    CONSTANT tx01     : TIME    :=  2.2 ns;  -- 0.0 ns to 1.8 ns


    COMPONENT CY7C1360C
        PORT (iZZ : IN STD_LOGIC;
              iMode : IN STD_LOGIC;
              iADDR : IN STD_LOGIC_VECTOR ((addr_bits -1) downto 0);
              inGW : IN STD_LOGIC;
              inBWE : IN STD_LOGIC;
              inBWd : IN STD_LOGIC;
              inBWc : IN STD_LOGIC;
              inBWb : IN STD_LOGIC;
              inBWa : IN STD_LOGIC;
              inCE1 : IN STD_LOGIC;
              iCE2 : IN STD_LOGIC;
              inCE3 : IN STD_LOGIC;
              inADSP : IN STD_LOGIC;
              inADSC : IN STD_LOGIC;
              inADV : IN STD_LOGIC;
              inOE : IN STD_LOGIC;
              ioDQ : INOUT STD_LOGIC_VECTOR ((data_bits-1) downto 0);
              iCLK : IN STD_LOGIC);
    END COMPONENT;

--------------------------------------------------------------------------
-- Function:    to_slv
--
-- Description: Converts string to std_logic_vector
--------------------------------------------------------------------------
function to_slv(value : in string) return std_logic_vector is
variable outvec : std_logic_vector(value'length -1 downto 0);
variable i : integer;
variable temp : character;
begin
    for i in 1 to value'length  loop
        
        temp := value(i);     
      
     case temp is
        when '0' => outvec(i-1) := '0';
        when '1' => outvec(i-1) := '1';            
        when 'X' => outvec(i-1) := 'X';
        when 'Z' => outvec(i-1) := 'Z';
        when others  =>
            assert false report "Illegal characters" severity note;
                       
    end case;
    end loop;
    return outvec;    
end to_slv;

--------------------------------------------------------------------------
-- Function:    to_slv_char
--
-- Description: Converts character to std_logic_vector
--------------------------------------------------------------------------
function to_slv_char(value : in character) return std_logic is
variable outvec_char : std_logic;

begin
    
    case value is
        when '0' => outvec_char := '0';
        when '1' => outvec_char := '1';            
        when 'X' => outvec_char := 'X';
        when 'Z' => outvec_char := 'Z';
        when others  =>
            assert false report "Illegal characters" severity note;
                       
    end case;
 
    return outvec_char;    
end to_slv_char;
--------------------------------------------------------------------------

--------------------------------------------------------------------------
-- Function:    to_string
--
-- Description: Converts time to string
--------------------------------------------------------------------------
function to_string (value : in integer) return string is
variable L : line; 

begin
    write(L, value, RIGHT, 10);
    return L.all;
end to_string;
--------------------------------------------------------------------------


    FOR ALL: CY7C1360C USE ENTITY WORK.CY7C1360C(CY7C1360C_arch);

    SIGNAL DQ    : STD_LOGIC_VECTOR((data_bits-1) DOWNTO 0);
    SIGNAL Addr   : STD_LOGIC_VECTOR((addr_bits-1) DOWNTO 0) := (OTHERS => '0');
    SIGNAL ZZ, clk  : STD_LOGIC := '0';
    SIGNAL Mode  : STD_LOGIC := '0';
    SIGNAL BWE_n : STD_LOGIC := '1';
    SIGNAL BWd_n : STD_LOGIC := '1';
    SIGNAL BWc_n : STD_LOGIC := '1';
    SIGNAL BWb_n : STD_LOGIC := '1';
    SIGNAL BWa_n : STD_LOGIC := '1';
    SIGNAL GW_n : STD_LOGIC := '1';
    signal CE1_n : STD_LOGIC := '1';
    signal CE2   : STD_LOGIC := '0';
    SIGNAL CE3_n : STD_LOGIC := '1';
    signal ADSP_n : STD_LOGIC := '1';
    signal ADSC_n : STD_LOGIC := '1';
    signal ADV_n : STD_LOGIC := '1';
    signal OE_n : STD_LOGIC := '1';
    signal count : integer := 0;
    signal chkout : std_logic := '0';
    signal testin_tmp_slv : std_logic_vector ((data_bits-1) downto 0) := (others => '0');
    signal strb : std_logic := '0';
    signal temp : std_logic := '1';
    signal D    : STD_LOGIC_VECTOR((data_bits-1) DOWNTO 0) := (OTHERS => '0');
    signal read_write : std_logic;
    signal trigger : std_logic := '0';
begin
    
    
    
    
    -- Unit Under Test port map
    UUT : CY7C1360C
        PORT MAP (ioDq => Dq, 
                  iAddr => Addr, 
                  iClk => Clk, 
                  iMode => Mode, 
                  inAdv => Adv_n,
                  inBwa => Bwa_n, 
                  inBwb => Bwb_n, 
                  inBwc => Bwc_n, 
                  inBwd => Bwd_n,
                  inOE => OE_n, 
                  inCE1 => CE1_n, 
                  inCE3 => CE3_n, 
                  iCE2 => CE2, 
                  inADSP => ADSP_n,
                  inADSC => ADSC_n,
                  inGW => GW_n,
                  inBWE => BWE_n,
                  iZZ => Zz
        );

Process
  begin
      trigger <= '1' after 4 ns;
      wait;
end process;
        
     with trigger select         
        strb <= not strb after 4.4 ns when '1',
                '0' when others; --clock
        
process(strb)
  begin
      clk <= strb after tx01;
  end process;

process 

variable l : line;
variable A_tmp : string (5 downto 1);
variable zz_tmp : character;
variable mode_tmp : character;
variable gw_tmp : character;
variable bwe_tmp : character;
variable bw_tmp : string (4 downto 1);
variable ce1_n_tmp : character;
variable ce2_tmp : character;
variable ce3_n_tmp : character;
variable adsp_n_tmp : character;
variable adsc_n_tmp : character;
variable adv_n_tmp : character;
variable oeb_tmp  : character;
variable testout_tmp1, testout_tmp2, testout_tmp3, testout_tmp4 : string (9 downto 1);
variable testin_tmp1, testin_tmp2, testin_tmp3, testin_tmp4 : string (9 downto 1);
variable A_tmp_slv : STD_LOGIC_VECTOR (4 downto 0);
variable zz_tmp_slv : STD_LOGIC;
variable mode_tmp_slv : STD_LOGIC;
variable gw_tmp_slv : STD_LOGIC;
variable bwe_tmp_slv : STD_LOGIC;
variable bw_tmp_slv : STD_LOGIC_VECTOR (3 downto 0);
variable ce1_n_tmp_slv : STD_LOGIC;
variable ce2_tmp_slv : STD_LOGIC;
variable ce3_n_tmp_slv : STD_LOGIC;
variable adsp_n_tmp_slv : STD_LOGIC;
variable adsc_n_tmp_slv : STD_LOGIC;
variable adv_n_tmp_slv : STD_LOGIC;
variable oeb_tmp_slv  : STD_LOGIC;
variable testout_tmp1_slv,testout_tmp2_slv,testout_tmp3_slv,testout_tmp4_slv : STD_LOGIC_VECTOR (8 downto 0);
variable US: character;
variable linecount: integer; 
FILE test_vectors : text is in "SS_PL_SCD_X36_vect.txt";  -- preload file


begin 
    while not endfile(test_vectors) loop
          assert false report "Line no" &to_string(count) severity note;
    wait until strb = '1';
      readline (test_vectors,l);
      read(l,zz_tmp);
      read(l,US);
      read(l,mode_tmp);
      read(l,US);
      read(l,A_tmp);
      read(l,US);
      read(l,gw_tmp);
      read(l,US);
      read(l,bwe_tmp);
      read(l,US); 
      read(l,bw_tmp);
      read(l,US); 
      read(l,ce1_n_tmp); 
      read(l,US);
      read(l,ce2_tmp);
      read(l,US);
      read(l,ce3_n_tmp);
      read(l,US);
      read(l,ADSP_n_tmp);
      read(l,US);
      read(l,ADSC_n_tmp);
      read(l,US);
      read(l,ADV_n_tmp);
      read(l,US); 
      read(l,oeb_tmp);
      read(l,US); 
      read(l,testout_tmp1); 
      read(l,US);
      read(l,testout_tmp2);
      read(l,US); 
      read(l,testout_tmp3); 
      read(l,US);
      read(l,testout_tmp4);
      read(l,US); 
      read(l,testin_tmp1); 
      read(l,US);
      read(l,testin_tmp2);
      read(l,US); 
      read(l,testin_tmp3); 
      read(l,US);
      read(l,testin_tmp4);

      
      A_tmp_slv (4 downto 0) := to_slv(A_tmp);
      zz_tmp_slv := to_slv_char(zz_tmp);
      mode_tmp_slv := to_slv_char(mode_tmp);
      gw_tmp_slv := to_slv_char(gw_tmp);
      bwe_tmp_slv := to_slv_char(bwe_tmp);
      bw_tmp_slv (3 downto 0) := to_slv(bw_tmp);
      ce1_n_tmp_slv := to_slv_char(ce1_n_tmp);
      ce2_tmp_slv := to_slv_char(ce2_tmp);
      ce3_n_tmp_slv := to_slv_char(ce3_n_tmp);
      ADSP_n_tmp_slv := to_slv_char(ADSP_n_tmp);
      ADSC_n_tmp_slv := to_slv_char(ADSC_n_tmp);
      ADV_n_tmp_slv := to_slv_char(ADV_n_tmp);
      oeb_tmp_slv := to_slv_char(oeb_tmp);
      testin_tmp_slv (8 downto 0) <= to_slv(testin_tmp4);
      testout_tmp1_slv (8 downto 0) := to_slv(testout_tmp1);
      testin_tmp_slv (17 downto 9) <= to_slv(testin_tmp3);
      testout_tmp2_slv (8 downto 0) := to_slv(testout_tmp2);
      testin_tmp_slv (26 downto 18) <= to_slv(testin_tmp2);
      testout_tmp3_slv (8 downto 0) := to_slv(testout_tmp3);
      testin_tmp_slv (35 downto 27) <= to_slv(testin_tmp1);
      testout_tmp4_slv (8 downto 0) := to_slv(testout_tmp4);

      
      Addr <= "0000000000000" & A_tmp_slv;
      Mode <= mode_tmp_slv; 
      Adv_n <= Adv_n_tmp_slv;
      Bwa_n <= Bw_tmp_slv (0); 
      Bwb_n <= Bw_tmp_slv (1); 
      Bwc_n <= Bw_tmp_slv (2); 
      Bwd_n <= Bw_tmp_slv (3);
      OE_n <= OEb_tmp_slv; 
      CE1_n <= CE1_n_tmp_slv; 
      CE3_n <= CE3_n_tmp_slv; 
      CE2 <= CE2_tmp_slv; 
      ADSP_n <= ADSP_n_tmp_slv;
      ADSC_n <= ADSC_n_tmp_slv;
      GW_n <= GW_tmp_slv;
      BWE_n <= BWE_tmp_slv;
      ZZ <= zz_tmp_slv;

      D (35 downto 27) <= testout_tmp1_slv;
      D (26 downto 18) <= testout_tmp2_slv;
      D (17 downto 9) <= testout_tmp3_slv;
      D (8 downto 0) <= testout_tmp4_slv;

      count <= count +1;


    end loop;
   chkout <= '1';
   wait;
end process;


read_write <= '0' when D = "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" else '1'; --1 means write
DQ <= D when read_write = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";

Process (clk)
begin
    if rising_edge (clk) then
      if (chkout = '0') then  
        if (D /= "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ") then
             assert false report "Write Cycle" severity note;
        else     
          if (DQ(35 downto 0) = testin_tmp_slv(35 downto 0)) then
            assert false report "OK" severity note;
          else
            assert false report "ERROR" severity note;
          end if;
        end if;    
      else
          assert false report "TEST COMPLETE" severity note;
      end if;    
    end if;
end process;


end tb_arch;



