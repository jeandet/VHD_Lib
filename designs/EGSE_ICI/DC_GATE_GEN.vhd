-- DC_GATE_GEN.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;








entity DC_GATE_GEN is
generic(WordCnt   :   integer := 144);
port
(
    clk     :   in  std_logic;
    Wcount  :   in  integer range 0 to WordCnt-1;
    Gate    :   out std_logic
);
end entity;




architecture ar_DC_GATE_GEN of DC_GATE_GEN is
begin
process(clk)
    begin
        if clk'event and clk ='0' then
                case Wcount is
                    when 48 =>
                        gate <= '1';
                    when 49 =>
                        gate <= '1';

                    when 50 =>
                        gate <= '1';
                    when 51 =>
                        gate <= '1';

                    when 52 =>
                        gate <= '1';
                    when 53 =>
                        gate <= '1';

                    
                    when others =>
                        gate <= '0';
                end case;
        end if;
end process;
end architecture;