-- LF_GATE_GEN.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;








entity LF_GATE_GEN is
generic(WordCnt   :   integer := 144);
port
(
    clk     :   in  std_logic;
    Wcount  :   in  integer range 0 to WordCnt-1;
    Gate    :   out std_logic
);
end entity;




architecture ar_LF_GATE_GEN of LF_GATE_GEN is
begin
process(clk)
    begin
        if clk'event and clk ='0' then
                case Wcount is
                    when 6 =>
                        gate <= '1';
                    when 7 =>
                        gate <= '1';
                    when 8 =>
                        gate <= '1';
                    when 9 =>
                        gate <= '1';
                    when 10 =>
                        gate <= '1';
                    when 11 =>
                        gate <= '1';

                    when 30 =>
                        gate <= '1';
                    when 31 =>
                        gate <= '1';
                    when 32 =>
                        gate <= '1';
                    when 33 =>
                        gate <= '1';
                    when 34 =>
                        gate <= '1';
                    when 35 =>
                        gate <= '1';

                    when 54 =>
                        gate <= '1';
                    when 55 =>
                        gate <= '1';
                    when 56 =>
                        gate <= '1';
                    when 57 =>
                        gate <= '1';
                    when 58 =>
                        gate <= '1';
                    when 59 =>
                        gate <= '1';

                    when 78 =>
                        gate <= '1';
                    when 79 =>
                        gate <= '1';
                    when 80 =>
                        gate <= '1';
                    when 81 =>
                        gate <= '1';
                    when 82 =>
                        gate <= '1';
                    when 83 =>
                        gate <= '1';

                    when 102 =>
                        gate <= '1';
                    when 103 =>
                        gate <= '1';
                    when 104 =>
                        gate <= '1';
                    when 105 =>
                        gate <= '1';
                    when 106 =>
                        gate <= '1';
                    when 107 =>
                        gate <= '1';

                    when 126 =>
                        gate <= '1';
                    when 127 =>
                        gate <= '1';
                    when 128 =>
                        gate <= '1';
                    when 129 =>
                        gate <= '1';
                    when 130 =>
                        gate <= '1';
                    when 131 =>
                        gate <= '1';


                    when others =>
                        gate <= '0';
                end case;
        end if;
end process;
end architecture;