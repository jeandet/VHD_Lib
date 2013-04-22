-- Data.vhd
library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use work.Convertisseur_config.all;

entity Data is

port(
    clk,raz         : in std_logic;    
    ADS_HF_In       : in IN_ADS;
    ADS_LF_In       : in IN_ADS;
    sclk            : out std_logic;    
    ADS_HF_config   : out ADS_config;
    ADS_LF_config   : out ADS_config;
    ADS_HF_out      : out OUT_ADS;
    ADS_LF_out      : out OUT_ADS;
    Bit_fin_HF,Bit_fin_LF : out std_logic;
    Vector_HF1,Vector_HF2,Vector_HF3 : out std_logic_vector(15 downto 0));

end Data;

architecture ar_Data of Data is

constant ADS_HF_c : ADS_config :=('1','1',FSYNC_FORMAT,MODE_low_power);
constant ADS_LF_c : ADS_config :=('1','1',FSYNC_FORMAT,MODE_low_speed);

signal Vect_1 : std_logic_vector(23 downto 0);
signal Vect_2 : std_logic_vector(23 downto 0);
signal Vect_3 : std_logic_vector(23 downto 0);
signal sclk_int : std_logic;

begin

Clock_systeme : entity work.Sys_Clock
    generic map (nb_compteur_sclk)
    port map (clk,raz,sclk_int);
    

Data_LF : entity work.Vectorize
    port map (clk,raz,sclk_int,ADS_LF_In.RDY,ADS_LF_In.Data_in(1),ADS_LF_In.Data_in(2),ADS_LF_In.Data_in(3),Bit_fin_LF,ADS_LF_out.Vector_out(1),ADS_LF_out.Vector_out(2),ADS_LF_out.Vector_out(3));
 
Data_HF : entity work.Vectorize
    port map (clk,raz,sclk_int,ADS_HF_In.RDY,ADS_HF_In.Data_in(1),ADS_HF_In.Data_in(2),ADS_HF_In.Data_in(3),Bit_fin_HF,Vect_1,Vect_2,Vect_3);


ADS_HF_config <= ADS_HF_c;
ADS_LF_config <= ADS_LF_c;

ADS_HF_out.Vector_out(1) <= Vect_1;
ADS_HF_out.Vector_out(2) <= Vect_2;
ADS_HF_out.Vector_out(3) <= Vect_3;

Vector_HF1 <= Vect_1(23 downto 8);
Vector_HF2 <= Vect_2(23 downto 8);
Vector_HF3 <= Vect_3(23 downto 8);

sclk <= sclk_int;

end ar_Data;