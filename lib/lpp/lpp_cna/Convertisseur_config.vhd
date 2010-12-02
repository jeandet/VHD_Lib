-- Convertisseur_config.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

Package Convertisseur_config is


--===========================================================|
--================= Valeurs Sinus 1Khz ======================|
--===========================================================|
type Tbl is array(natural range <>) of std_logic_vector(11 downto 0);
constant Tablo : Tbl (0 to 49):= (X"800",X"901",X"9FD",X"AF2",X"BDB",X"CB4",X"D7A",X"E2A",X"EC1",X"F3D",X"F9C",X"FDC",X"FFC",X"FFC",X"FDC",X"F9C",X"F3D",X"EC1",X"E2A",X"D7A",X"CB4",X"BDB",X"AF2",X"9FD",X"901",X"800",X"6FF",X"603",X"50E",X"425",X"34C",X"286",X"1D6",X"13F",X"0C3",X"064",X"024",X"004",X"004",X"024",X"064",X"0C3",X"13F",X"1D6",X"286",X"34C",X"425",X"50E",X"603",X"6FF");

--constant Tablo : Tbl (0 to 49):= (X"C00",X"C80",X"CFF",X"D79",X"DED",X"E5A",X"EBD",X"F15",X"F61",X"F9F",X"FCE",X"FEE",X"FFE",X"FFE",X"FEE",X"FCE",X"F9F",X"F61",X"F15",X"EBD",X"E5A",X"DED",X"D79",X"CFF",X"C80",X"C00",X"B80",X"B01",X"A87",X"A13",X"9A6",X"943",X"8EB",X"89F",X"861",X"832",X"812",X"802",X"802",X"812",X"832",X"861",X"89F",X"8EB",X"943",X"9A6",X"A13",X"A87",X"B01",X"B80");


--===========================================================|
--============= Fréquence de sérialisation ==================|
--===========================================================|
constant Freq_serial : integer := 5_000_000;
constant nb_serial : integer := 30_000_000 / Freq_serial;

end;