-- Dephaseur.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--! Programme qui va gerer la creation des deux signaux de sortie

entity Dephaseur is

port( 
    clk,raz     : in std_logic;                         --! Horloge 25Mhz et reset du systeme 
    div         : in integer range 250 to 25_000;       --! Valeur MAX pour le compteur (Frequence)
    phi         : in integer range 4 to 12500;          --! Valeur MAX pour le compteur (Dephasage)
    Stop_count  : in std_logic;                         --! Flag, interuption des compteur / synchronise phi et div
    clk_MOD     : out std_logic;                        --! Horloge de sortie, Modulation
    clk_DMOD    : out std_logic);                       --! Horloge de sortie, Demodulation

end Dephaseur;


architecture ar_Dephaseur of Dephaseur is

signal clk_var      : std_logic;
signal s_clk_MOD    : std_logic;
signal s_clk_DMOD   : std_logic;
signal pulse        : std_logic;
signal ou           : std_logic;

begin

    MODUL : entity work.Clock_multi
        port map(clk,raz,Stop_count,div,s_clk_MOD);

    Rz : entity work.Gene_Rz
        port map(clk,raz,s_clk_MOD,pulse);


    CLKVAR : entity work.Clock_multi
        port map(clk,raz,ou,phi,clk_var);
                    
                    
    RETARD : entity work.bclk_reg
        port map(clk_var,raz,s_clk_MOD,clk_DMOD);

clk_MOD <= s_clk_MOD;
ou <= pulse or Stop_count;

end ar_Dephaseur;