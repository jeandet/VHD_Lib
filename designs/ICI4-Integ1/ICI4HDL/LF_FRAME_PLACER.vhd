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
                    when 5 =>
                        WordOut <=  LF1(15 downto 8);
                        Flag <= '1';
                    when 6 =>
                        WordOut <=  LF1(7 downto 0);
                        Flag <= '1';
                    when 13 =>
                        WordOut <=  LF2(15 downto 8);
                        Flag <= '1';
                    when 14 =>
                        WordOut <=  LF2(7 downto 0);
                        Flag <= '1';
                    when 21 =>
                        WordOut <=  LF3(15 downto 8);
                        Flag <= '1';
                    when 22 =>
                        WordOut <=  LF3(7 downto 0);
                        Flag <= '1';

                    when 29 =>
                        WordOut <=  LF1(15 downto 8);
                        Flag <= '1';
                    when 30 =>
                        WordOut <=  LF1(7 downto 0);
                        Flag <= '1';
                    when 37 =>
                        WordOut <=  LF2(15 downto 8);
                        Flag <= '1';
                    when 38 =>
                        WordOut <=  LF2(7 downto 0);
                        Flag <= '1';
                    when 45 =>
                        WordOut <=  LF3(15 downto 8);
                        Flag <= '1';
                    when 46 =>
                        WordOut <=  LF3(7 downto 0);
                        Flag <= '1';

                    when 53 =>
                        WordOut <=  LF1(15 downto 8);
                        Flag <= '1';
                    when 54 =>
                        WordOut <=  LF1(7 downto 0);
                        Flag <= '1';
                    when 61 =>
                        WordOut <=  LF2(15 downto 8);
                        Flag <= '1';
                    when 62 =>
                        WordOut <=  LF2(7 downto 0);
                        Flag <= '1';
                    when 69 =>
                        WordOut <=  LF3(15 downto 8);
                        Flag <= '1';
                    when 70 =>
                        WordOut <=  LF3(7 downto 0);
                        Flag <= '1';

                    when 77 =>
                        WordOut <=  LF1(15 downto 8);
                        Flag <= '1';
                    when 78 =>
                        WordOut <=  LF1(7 downto 0);
                        Flag <= '1';
                    when 85 =>
                        WordOut <=  LF2(15 downto 8);
                        Flag <= '1';
                    when 86 =>
                        WordOut <=  LF2(7 downto 0);
                        Flag <= '1';
                    when 93 =>
                        WordOut <=  LF3(15 downto 8);
                        Flag <= '1';
                    when 94 =>
                        WordOut <=  LF3(7 downto 0);
                        Flag <= '1';

                    when 101 =>
                        WordOut <=  LF1(15 downto 8);
                        Flag <= '1';
                    when 102 =>
                        WordOut <=  LF1(7 downto 0);
                        Flag <= '1';
                    when 109 =>
                        WordOut <=  LF2(15 downto 8);
                        Flag <= '1';
                    when 110 =>
                        WordOut <=  LF2(7 downto 0);
                        Flag <= '1';
                    when 117 =>
                        WordOut <=  LF3(15 downto 8);
                        Flag <= '1';
                    when 118 =>
                        WordOut <=  LF3(7 downto 0);
                        Flag <= '1';

                    when 125 =>
                        WordOut <=  LF1(15 downto 8);
                        Flag <= '1';
                    when 126 =>
                        WordOut <=  LF1(7 downto 0);
                        Flag <= '1';
                    when 133 =>
                        WordOut <=  LF2(15 downto 8);
                        Flag <= '1';
                    when 134 =>
                        WordOut <=  LF2(7 downto 0);
                        Flag <= '1';
                    when 141 =>
                        WordOut <=  LF3(15 downto 8);
                        Flag <= '1';
                    when 142 =>
                        WordOut <=  LF3(7 downto 0);
                        Flag <= '1';


                    when others =>
                        WordOut <=  X"A5";
                        Flag <= '0';
                end case;
        end if;
    end process;



end ar_LF_FRAME_PLACER;