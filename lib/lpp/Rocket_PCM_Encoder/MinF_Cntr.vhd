-- MinF_Cntr.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;




entity MinF_Cntr is
generic(MinFCount   :   integer := 64);
port(
    clk     :   in  std_logic;
    reset   :   in  std_logic;
    Cnt_out :   out integer range 0 to MinFCount-1
);
end entity;



architecture ar_MinF_Cntr of MinF_Cntr is

signal  Cnt_int     :   integer range 0 to MinFCount-1 := 0;
signal  MinF_reg    :   std_logic := '0';

begin

Cnt_out <=  Cnt_int;

process(clk,reset)
begin
    if reset = '0' then
        Cnt_int <= 0;
    elsif clk'event and clk = '1' then
        if Cnt_int = MinFCount -1 then
            Cnt_int     <=  0;
        else
            Cnt_int     <=  Cnt_int + 1;
        end if;
    end if;
end process;
end ar_MinF_Cntr;



























