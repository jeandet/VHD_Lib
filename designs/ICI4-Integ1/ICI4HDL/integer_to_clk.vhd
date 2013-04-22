-- integer_to_clk.vhd
library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;

entity integer_to_clk is 

generic(N : integer := 144);

port(
    clk,raz :   in  std_logic;
    Compt : in integer range 0 to N;
    Clock : out std_logic);

end integer_to_clk;


architecture ar_integer_to_clk of integer_to_clk is

signal compt_reg : integer range 0 to N;
signal Clock_int : std_logic;

begin
    process(clk, raz)
        begin
        if (raz='0')then            
            Clock_int <= '0';
            compt_reg <= 0;
            
        elsif (clk'event and clk='1') then
        compt_reg <= Compt;
            if(compt_reg/=Compt)then
                Clock_int <= not Clock_int;
            end if;
        end if;
    end process;

Clock <= Clock_int;
end ar_integer_to_clk;









