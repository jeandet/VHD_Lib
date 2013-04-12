-- Word_Cntr.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;




entity Word_Cntr is
generic(WordSize :integer := 8 ;N   :   integer := 144);
port(
    Sclk    :   in  std_logic;
    reset   :   in  std_logic;
    WordClk :   out std_logic;
    Cnt_out :   out integer range 0 to N-1
);
end entity;



architecture ar_Word_Cntr of Word_Cntr is

signal  Cnt_int     :   integer range 0 to N-1 := 0;
signal  Wcnt        :   integer range 0 to WordSize -1 ;

begin

Cnt_out <=  Cnt_int;

process(Sclk,reset)
begin
    if reset = '0' then
        Cnt_int <= 0;
        Wcnt    <=  0;
        WordClk <=  '0';
    elsif Sclk'event and Sclk = '1' then
        if Wcnt = WordSize - 1 then
            Cnt_int <=  Cnt_int + 1;
            Wcnt    <=  0;
            WordClk <=  '1';
        else
            Wcnt    <=  Wcnt + 1;
            WordClk <=  '0';
        end if;
    end if;
end process;
end ar_Word_Cntr;























