-- Gene_17K36.vhd
library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;

entity Gene_17K36 is 

port(
    clk,raz :   in  std_logic;
    Pulse : in std_logic;
    Clock_17K36 : out std_logic);

end Gene_17K36;


architecture ar_Gene_17K36 of Gene_17K36 is

signal pulse_reg : std_logic;
signal clk_int : std_logic;
signal count : integer range 0 to 6;

begin
    process(clk, raz)
        begin
        if (raz='0')then            
            clk_int <= '0';
            pulse_reg <= '0'; 
            count <= 0; 

        elsif (clk'event and clk='1') then
        pulse_reg <= Pulse;            
            if(pulse_reg='0' and Pulse='1')then
                if(count=5)then
                    count <= 0;
                    clk_int <= not clk_int;
                else
                    count <= count + 1;
                end if;
            end if;
        end if;
    end process;

Clock_17K36 <= clk_int;

end ar_Gene_17K36;