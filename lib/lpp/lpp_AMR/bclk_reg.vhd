-- bclk_reg.vhd
library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;

--! Simple bascule D utilise pour retarder d'un top d'horloge le signal d'entre

entity bclk_reg is 

port(
    clk,raz     : in std_logic;     --! Horloge 25Mhz et reset du systeme 
    D           : in std_logic;     --! Signal d'entre
    Q           : out std_logic);   --! Signal de sortie

end bclk_reg;


architecture ar_bclk_reg of bclk_reg is

begin
    process(clk,raz)
        begin

        if(raz='0')then
            Q <= '0';

        elsif(clk'event and clk='1')then
           Q <= D;            

        end if;

    end process;

end ar_bclk_reg;