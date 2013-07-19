----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:39:51 04/25/2013 
-- Design Name: 
-- Module Name:    ICI4_3DCAM_FRAM_PLACER - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ICI4_3DCAM_FRAM_PLACER is
generic(WordSize :integer := 8;WordCnt   :   integer := 144;MinFCount   :   integer := 64);
port(
    clk     :   in  std_logic;
    Wcount  :   in  integer range 0 to WordCnt-1;
    Flag    :   out std_logic;
    WORD0     :   in  std_logic_vector(15 downto 0);
	 WORD1     :   in  std_logic_vector(15 downto 0);
	 WORD2     :   in  std_logic_vector(15 downto 0);
	 WORD3     :   in  std_logic_vector(15 downto 0);
	 WORD4     :   in  std_logic_vector(15 downto 0);
	 WORD5     :   in  std_logic_vector(15 downto 0);
	 WORD6     :   in  std_logic_vector(15 downto 0);
	 WORD7     :   in  std_logic_vector(15 downto 0);
	 WORD8     :   in  std_logic_vector(15 downto 0);
	 WORD9     :   in  std_logic_vector(15 downto 0);
	 WORD10    :   in  std_logic_vector(15 downto 0);
	 WORD11    :   in  std_logic_vector(15 downto 0);
	 WORD12    :   in  std_logic_vector(15 downto 0);
    WordOut :   out std_logic_vector(WordSize-1 downto 0)

);
end ICI4_3DCAM_FRAM_PLACER;

architecture Behavioral of ICI4_3DCAM_FRAM_PLACER is

begin


    process(clk)
    begin
        if clk'event and clk ='1' then
                case Wcount is
                    

                    when 29 =>
                        WordOut <=  WORD3(15 downto 8);
                        Flag <= '1';
                    when 30 =>
                        WordOut <=  WORD3(7 downto 0);
                        Flag <= '1';
                    when 31 =>
                        WordOut <=  WORD4(15 downto 8);
                        Flag <= '1';
                    when 32 =>
                        WordOut <=  WORD4(7 downto 0);
                        Flag <= '1';
                    when 33 =>
                        WordOut <=  WORD5(15 downto 8);
                        Flag <= '1';
                    when 34 =>
                        WordOut <=  WORD5(7 downto 0);
                        Flag <= '1';

                    when 35 =>
                        WordOut <=  WORD6(15 downto 8);
                        Flag <= '1';
                    when 36 =>
                        WordOut <=  WORD6(7 downto 0);
                        Flag <= '1';
                    when 37 =>
                        WordOut <=  WORD7(15 downto 8);
                        Flag <= '1';
                    when 38 =>
                        WordOut <=  WORD7(7 downto 0);
                        Flag <= '1';
                    when 39 =>
                        WordOut <=  WORD8(15 downto 8);
                        Flag <= '1';
                    when 40 =>
                        WordOut <=  WORD8(7 downto 0);
                        Flag <= '1';

                    when 41 =>
                        WordOut <=  WORD9(15 downto 8);
                        Flag <= '1';
                    when 42 =>
                        WordOut <=  WORD9(7 downto 0);
                        Flag <= '1';
                    when 43 =>
                        WordOut <=  WORD10(15 downto 8);
                        Flag <= '1';
                    when 44 =>
                        WordOut <=  WORD10(7 downto 0);
                        Flag <= '1';
                    when 45 =>
                        WordOut <=  WORD11(15 downto 8);
                        Flag <= '1';
                    when 46 =>
                        WordOut <=  WORD11(7 downto 0);
                        Flag <= '1';

                    when 47 =>
                        WordOut <=  WORD12(15 downto 8);
                        Flag <= '1';
                    when 48 =>
                        WordOut <=  WORD12(7 downto 0);
                        Flag <= '1';


                    when others =>
                        WordOut <=  X"A5";
                        Flag <= '0';
                end case;
        end if;
    end process;

end Behavioral;

