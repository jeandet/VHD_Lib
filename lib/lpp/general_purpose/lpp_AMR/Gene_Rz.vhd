-- Gene_Rz.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--! Programme qui genere un reset local utilise pour synchroniser les compteur

entity Gene_Rz is

port( 
    clk,raz     : in std_logic;     --! Horloge 25Mhz et reset du systeme
    clk_20K     : in std_logic;     --! Horloge de modulation
    pulse       : out std_logic);   --! Reset local

end Gene_Rz;


architecture ar_Gene_Rz of Gene_Rz is

signal s_clk : std_logic;

begin 
    process (clk,raz)
    begin
        if(raz='0')then
            pulse <= '0';
            s_clk <= '0';           
            
        elsif(clk' event and clk='1')then            
            s_clk <= clk_20K;
            
            if(s_clk='0' and clk_20K='1')then
                pulse <= '1';
            elsif(s_clk='1' and clk_20K='0')then
                pulse <= '1';
            else
                pulse <= '0';  
            end if;

        end if;
    end process;
end ar_Gene_Rz;