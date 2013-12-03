-- MinF_Gen.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;



entity MinF_Gen is 
generic(WordCnt : integer :=144);
port(
    clk         :   in  std_logic;
    reset       :   in  std_logic;
    WordCnt_in  :   in  integer range 0 to WordCnt-1;
    WordClk     :   in  std_logic;
    MinF_Clk    :   out std_logic
);
end entity;






architecture arMinF_Gen of MinF_Gen is
signal monostable : std_logic := '0';
begin

process(clk)
begin
    if reset = '0' then
        MinF_Clk    <=  '0';
        monostable  <=  '1';
    elsif clk'event and clk = '0' then
        if WordCnt_in = 0 and WordClk = '1' and monostable = '1' then
            MinF_Clk    <=  '1';
        else
            MinF_Clk    <=  '0';
        end if;
        if WordCnt_in = 0 and WordClk = '1' and monostable = '1' then
            monostable  <=  '0';
        elsif WordCnt_in /= 0  and monostable = '0' then
            monostable  <=  '1';
        end if;
    end if;
end process;

end architecture;