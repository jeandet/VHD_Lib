-- Systeme_Clock.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--! Programme qui va permetre de générer l'horloge systeme (sclk)

entity Systeme_Clock is
generic(N :integer := 695);   --! Générique contenant le résultat de la division clk/sclk
port( 
    clk, raz   : in std_logic;   --! Horloge et Reset globale
    sclk       : out std_logic   --! Horloge Systeme générée
);
end Systeme_Clock;

--! @details Fonctionne a base d'un compteur (countint) qui va permetre de diviser l'horloge N fois
architecture ar_Systeme_Clock of Systeme_Clock is

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

sclk <= clockint;

end ar_Systeme_Clock;