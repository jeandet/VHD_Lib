-- sys_clock.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity Sys_Clock is

generic(N :integer := 22);

port( 
    clk, raz   : in std_logic ;
    clock       : out std_logic);

end Sys_Clock;


architecture ar_Sys_Clock of Sys_Clock is

signal clockint : std_logic;
signal countint : integer range 0 to N/2-1;

begin 
    process (clk,raz)
        begin
        if(raz = '0') then
            countint <= 0;
            clockint <= '0';
        elsif (clk' event and clk='1') then
            if (countint = N/2-1) then 
                countint <= 0;
                clockint <= not clockint;
            else 
                countint <= countint+1;
            end if;
        end if;
    end process;

clock <= clockint;

end ar_Sys_Clock;



