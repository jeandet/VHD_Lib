-- ClkDivider.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;



entity Clk_Divider2 is 
generic(N : integer := 16);
port(
    clk_in  :   in  std_logic;
    clk_out :   out std_logic
);
end entity;



architecture ar_ClkDivider of Clk_Divider2 is
signal  cpt     :   integer range 0 to N/2-1;
signal  clk_int :   std_logic:='0';
begin

clk_out <=  clk_int;

process(clk_in)
begin
    if clk_in'event and clk_in = '1' then
        if cpt = N/2-1 then
            clk_int <= not clk_int;
            cpt       <=  0;
        else
            cpt       <=  cpt + 1;
        end if;
    end if;
end process;
end ar_ClkDivider;
