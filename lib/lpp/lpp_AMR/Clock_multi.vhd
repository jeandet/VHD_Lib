-- Clock_multi.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--! Compteur utilise en diviseur de frequence

entity Clock_multi is

port( 
    clk,raz     : in std_logic;                     --! Horloge 25Mhz et reset du systeme
    pulse       : in std_logic;                     --! Reset local
    N           : in integer range 4 to 25_000;     --! La valeur MAX du compteur
    clk_var     : out std_logic);                   --! Horloge obtenu en sortie

end Clock_multi;

--!@details Il permet a partir de l'horloge en entree, d'obtenir un horloge en sortie de frequence plus faible
architecture ar_Clock_multi of Clock_multi is

signal clockint : std_logic;
signal countint : integer range 0 to 15_000;

begin 
    process (clk,raz)
    begin
        if(raz='0' or pulse='1')then
            clockint <= '0';
            countint <= 0;
        elsif(clk' event and clk='1')then
            if(countint = N/2-1)then 
                countint <= 0;
                clockint <= not clockint;
            else 
                countint <= countint+1;
            end if;
        end if;
    end process;

clk_var <= clockint;

end ar_Clock_multi;