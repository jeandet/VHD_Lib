-- Gene_Freq.vhd
library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;

entity Gene_Freq is

generic(nb_mots : integer :=144);

port(
    clk,raz     : in std_logic;
    Minor_Frame : in std_logic;
    Compt_mots  : in integer range 0 to nb_mots;
    Clock_1k4   : out std_logic;
    Clock_17K36 : out std_logic);

end Gene_Freq;

architecture ar_Gene_Freq of Gene_Freq is

signal Pulse_mot : std_logic;

begin
    
Gene_LF : entity work.Gene_1K4
    port map (clk,raz,Minor_Frame,Clock_1K4);

 
Gene_HF : entity work.Gene_17K36 
    port map(clk,raz,Pulse_mot,Clock_17K36);


Pulsing : entity work.integer_to_clk
    generic map(nb_mots)
    port map(clk,raz,Compt_mots,Pulse_mot);

end ar_Gene_Freq;
