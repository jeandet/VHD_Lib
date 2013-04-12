-- DC_FRAME_PLACER.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;



entity DC_FRAME_PLACER is
generic(WordSize :integer := 8;WordCnt   :   integer := 144;MinFCount   :   integer := 64);
port(
    clk     :   in  std_logic;
    Wcount  :   in  integer range 0 to WordCnt-1;
    MinFCnt :   in  integer range 0 to MinFCount-1;
    Flag    :   out std_logic;
    DC1     :   in  std_logic_vector(23 downto 0);
    DC2     :   in  std_logic_vector(23 downto 0);
    DC3     :   in  std_logic_vector(23 downto 0);
    WordOut :   out std_logic_vector(WordSize-1 downto 0)

);
end entity; 





architecture ar_DC_FRAME_PLACER of DC_FRAME_PLACER is

signal  MinFCntVect     :   std_logic_vector(8 downto 0);
signal  MinFCntVectLSB  :   std_logic;   

begin

MinFCntVect     <=  std_logic_vector(TO_UNSIGNED(MinFCnt,9));
MinFCntVectLSB  <=  MinFCntVect(0);
    process(clk)
    begin
        if clk'event and clk ='1' then
            if MinFCntVectLSB = '0'then
                case Wcount is
                    when 15 =>
                        WordOut <=  DC1(23 downto 16);
                        Flag <= '1';
                    when 16 =>
                        WordOut <=  DC1(15 downto 8);
                        Flag <= '1';
                    when 19 =>
                        WordOut <=  DC1(7 downto 0);
                        Flag <= '1';
                    when 23 =>
                        WordOut <=  DC3(23 downto 16);
                        Flag <= '1';
                    when 24 =>
                        WordOut <=  DC3(15 downto 8);
                        Flag <= '1';
                    when 27 =>
                        WordOut <=  DC3(7 downto 0);
                        Flag <= '1';
                    when others =>
                        WordOut <=  X"A5";
                        Flag <= '0';
                end case;
            else
                case Wcount is
                    when 15 =>
                        WordOut <=  DC2(23 downto 16);
                        Flag <= '1';
                    when 16 =>
                        WordOut <=  DC2(15 downto 8);
                        Flag <= '1';
                    when 19 =>
                        WordOut <=  DC2(7 downto 0);
                        Flag <= '1';
                    when others =>
                        WordOut <=  X"A5";
                        Flag <= '0';
                end case;
            end if;
        end if;
    end process;



end ar_DC_FRAME_PLACER;

























