-- LF_FRAME_PLACER.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;



entity LF_FRAME_PLACER is
generic(WordSize :integer := 8;WordCnt   :   integer := 144;MinFCount   :   integer := 64);
port(
    clk     :   in  std_logic;
    Wcount  :   in  integer range 0 to WordCnt-1;
    Flag    :   out std_logic;
    LF1     :   in  std_logic_vector(15 downto 0);
    LF2     :   in  std_logic_vector(15 downto 0);
    LF3     :   in  std_logic_vector(15 downto 0);
    WordOut :   out std_logic_vector(WordSize-1 downto 0)

);
end entity; 





architecture ar_LF_FRAME_PLACER of LF_FRAME_PLACER is


begin

    process(clk)
    begin
        if clk'event and clk ='1' then
                case Wcount is
                    when 23 =>
                        WordOut <=  LF1(15 downto 8);
                        Flag <= '1';
                    when 24 =>
                        WordOut <=  LF1(7 downto 0);
                        Flag <= '1';
                    when 25 =>
                        WordOut <=  LF2(15 downto 8);
                        Flag <= '1';
                    when 26 =>
                        WordOut <=  LF2(7 downto 0);
                        Flag <= '1';
                    when 27 =>
                        WordOut <=  LF3(15 downto 8);
                        Flag <= '1';
                    when 28 =>
                        WordOut <=  LF3(7 downto 0);
                        Flag <= '1';

                    when others =>
                        WordOut <=  X"A5";
                        Flag <= '0';
                end case;
        end if;
    end process;



end ar_LF_FRAME_PLACER;