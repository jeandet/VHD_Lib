-- Gene_1K4.vhd
library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;

entity Gene_1K4 is 

port(
    clk,raz :   in  std_logic;
    Minor_Frame : in std_logic;
    Clock_1K4 : out std_logic);

end Gene_1K4;


architecture ar_Gene_1K4 of Gene_1K4 is

signal minor_reg : std_logic;
signal clk_int : std_logic;

begin
    process(clk, raz)
        begin
        if (raz='0')then            
            clk_int <= '0';
            minor_reg <= '0';  

        elsif (clk'event and clk='1') then
        minor_reg <= Minor_Frame;            
            if(minor_reg='0' and Minor_Frame='1')then    
                clk_int <= not clk_int;
            end if;
        end if;
    end process;

Clock_1K4 <= clk_int;

end ar_Gene_1K4;







