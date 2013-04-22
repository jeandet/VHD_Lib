-- Convertisseur_Data.vhd
library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use work.Convertisseur_config.all;

entity Convertisseur_Data is

port(
    clk,raz                     : in std_logic;
    Minor_Frame                 : in std_logic;
    Compt_mots                  : in integer range 0 to nb_mots;
    HF_Data1,HF_Data2,HF_Data3  : in std_logic;
    LF_Data1,LF_Data2,LF_Data3  : in std_logic;        
    sclk                        : out std_logic;
    ADS_HF_config               : out ADS_config;
    ADS_LF_config               : out ADS_config;
    Bit_fin_HF,Bit_fin_LF       : out std_logic;
    Ready_HF,Ready_LF           : out std_logic;
    ADS_LF_out                  : out OUT_ADS;    
    HF_Vector1,HF_Vector2,HF_Vector3 : out std_logic_vector(15 downto 0));

end Convertisseur_Data;


architecture ar_Convertisseur_Data of Convertisseur_Data is

signal ADS_HF_In    : IN_ADS;
signal ADS_LF_In    : IN_ADS;
signal unused       : OUT_ADS;

begin

ADS_HF_In.Data_in(1) <= HF_Data1;
ADS_HF_In.Data_in(2) <= HF_Data2;
ADS_HF_In.Data_in(3) <= HF_Data3;
ADS_LF_In.Data_in(1) <= LF_Data1;
ADS_LF_In.Data_in(2) <= LF_Data2;
ADS_LF_In.Data_in(3) <= LF_Data3;

Ready_HF <= ADS_HF_In.RDY;
Ready_LF <= ADS_LF_In.RDY;


Frequence : entity work.Gene_Freq
    generic map (nb_mots)
    port map (clk,raz,Minor_Frame,Compt_mots,ADS_LF_In.RDY,ADS_HF_In.RDY);

Donnees : entity work.Data
    port map (clk,raz,ADS_HF_In,ADS_LF_In,sclk,ADS_HF_config,ADS_LF_config,unused,ADS_LF_out,Bit_fin_HF,Bit_fin_LF,HF_Vector1,HF_Vector2,HF_Vector3);


end ar_Convertisseur_Data;




