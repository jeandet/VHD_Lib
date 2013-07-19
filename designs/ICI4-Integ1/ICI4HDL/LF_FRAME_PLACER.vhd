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
                    when 7 =>
                        WordOut <=  LF2(15 downto 8);
                        Flag <= '1';
                    when 8 =>
                        WordOut <=  LF2(7 downto 0);
                        Flag <= '1';
                    when 9 =>
                        WordOut <=  LF3(15 downto 8);
                        Flag <= '1';
                    when 10 =>
                        WordOut <=  LF3(7 downto 0);
                        Flag <= '1';

                    when 29 =>
                        WordOut <=  LF1(15 downto 8);
                        Flag <= '1';
                    when 30 =>
                        WordOut <=  LF1(7 downto 0);
                        Flag <= '1';
                    when 31 =>
                        WordOut <=  LF2(15 downto 8);
                        Flag <= '1';
                    when 32 =>
                        WordOut <=  LF2(7 downto 0);
                        Flag <= '1';
                    when 33 =>
                        WordOut <=  LF3(15 downto 8);
                        Flag <= '1';
                    when 34 =>
                        WordOut <=  LF3(7 downto 0);
                        Flag <= '1';

                    when 53 =>
                        WordOut <=  LF1(15 downto 8);
                        Flag <= '1';
                    when 54 =>
                        WordOut <=  LF1(7 downto 0);
                        Flag <= '1';
                    when 55 =>
                        WordOut <=  LF2(15 downto 8);
                        Flag <= '1';
                    when 56 =>
                        WordOut <=  LF2(7 downto 0);
                        Flag <= '1';
                    when 57 =>
                        WordOut <=  LF3(15 downto 8);
                        Flag <= '1';
                    when 58 =>
                        WordOut <=  LF3(7 downto 0);
                        Flag <= '1';

                    when 77 =>
                        WordOut <=  LF1(15 downto 8);
                        Flag <= '1';
                    when 78 =>
                        WordOut <=  LF1(7 downto 0);
                        Flag <= '1';
                    when 79 =>
                        WordOut <=  LF2(15 downto 8);
                        Flag <= '1';
                    when 80 =>
                        WordOut <=  LF2(7 downto 0);
                        Flag <= '1';
                    when 81 =>
                        WordOut <=  LF3(15 downto 8);
                        Flag <= '1';
                    when 82 =>
                        WordOut <=  LF3(7 downto 0);
                        Flag <= '1';

                    when 101 =>
                        WordOut <=  LF1(15 downto 8);
                        Flag <= '1';
                    when 102 =>
                        WordOut <=  LF1(7 downto 0);
                        Flag <= '1';
                    when 103 =>
                        WordOut <=  LF2(15 downto 8);
                        Flag <= '1';
                    when 104 =>
                        WordOut <=  LF2(7 downto 0);
                        Flag <= '1';
                    when 105 =>
                        WordOut <=  LF3(15 downto 8);
                        Flag <= '1';
                    when 106 =>
                        WordOut <=  LF3(7 downto 0);
                        Flag <= '1';

                    when 125 =>
                        WordOut <=  LF1(15 downto 8);
                        Flag <= '1';
                    when 126 =>
                        WordOut <=  LF1(7 downto 0);
                        Flag <= '1';
                    when 127 =>
                        WordOut <=  LF2(15 downto 8);
                        Flag <= '1';
                    when 128 =>
                        WordOut <=  LF2(7 downto 0);
                        Flag <= '1';
                    when 129 =>
                        WordOut <=  LF3(15 downto 8);
                        Flag <= '1';
                    when 130 =>
                        WordOut <=  LF3(7 downto 0);
                        Flag <= '1';


                    when others =>
                        WordOut <=  X"A5";
                        Flag <= '0';
                end case;
        end if;
    end process;



end ar_LF_FRAME_PLACER;