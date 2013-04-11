-- Telemetry_config.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


package Telemetry_config is

--===========================================================|
--==================== Géné Signaux =========================|
--===========================================================|
constant Fréq_clk_Hz        : integer := 40000000;
constant Débit_Hz           : integer := 3300000;
constant Débit_série_bauds  : integer := 57600;
constant nb_bits_par_mot    : integer := 8;
constant nb_mots_par_Minor  : integer := 144;
constant nb_Minor_par_Major : integer := 64;
constant nb_mots_total      : integer := nb_mots_par_Minor*nb_Minor_par_Major;
constant nb_compteur_sclk   : integer := Fréq_clk_Hz / Débit_Hz;


--===========================================================|
--==================== Entêtes UART =========================|
--===========================================================|
constant nb_bit_start       : integer := 1;
constant nb_bit_stop        : integer := 1;
constant nb_bit_pause       : integer := 3;


--===========================================================|
--=================== Signal Gate_HF ========================|
--===========================================================|
constant nb_mots_lgt        : integer := 8;
constant start_mot          : integer := 6;
constant lrg_ON             : integer := 2;


--===========================================================|
--=================== Signal Gate_LF ========================|
--===========================================================|
type Tbl is array(natural range <>) of integer ;
constant Tablo : Tbl (0 to 7):= (16,17,20,21,24,25,28,29);


--===========================================================|
--====================== Pacquage ===========================|
--===========================================================|
constant Start_1 : std_logic_vector(7 downto 0) := X"0F";
constant Start_0 : std_logic_vector(7 downto 0) := X"A5";
constant Stop_1  : std_logic_vector(7 downto 0) := X"5A";
constant Stop_0  : std_logic_vector(7 downto 0) := X"F0";


end;
