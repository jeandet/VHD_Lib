-- Convertisseur_config.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


Package Convertisseur_config is

--===========================================================|
--================== Variables Utiles =======================|
--===========================================================|

constant Fréq_clk_Hz        : integer := 27000000;
constant Débit_Hz           : integer := 1000000;
constant nb_compteur_sclk   : integer := Fréq_clk_Hz/Débit_Hz;
constant N_chanel           : integer := 3;
constant nb_mots            : integer := 144;
constant Vector_Dummy : std_logic_vector(23 downto 0) := X"FD1869";


--===========================================================|
--================= Configuration ADS =======================|
--===========================================================|

Type ADS_FORMAT_Type is array(2 downto 0) of std_logic;
constant SPI_FORMAT     : ADS_FORMAT_Type := "010";
constant FSYNC_FORMAT   : ADS_FORMAT_Type := "101";

Type ADS_MODE_Type is array(1 downto 0) of std_logic;
constant MODE_low_power         : ADS_MODE_Type := "10";
constant MODE_low_speed         : ADS_MODE_Type := "11";
constant MODE_high_resolution   : ADS_MODE_Type := "01";

Type ADS_config is
    record
        SYNC    : std_logic;
        CLKDIV  : std_logic;
        FORMAT  : ADS_FORMAT_Type;
        MODE    : ADS_MODE_Type;
    end record;


--===========================================================|
--================ Entrées/Sorties ADS ======================|
--=============== + init entrées (simu) =====================|
--===========================================================|

Type Tbl_In is array(natural range <>) of std_logic;
Type Tbl_Out is array(natural range <>) of std_logic_vector(23 downto 0);

Type IN_ADS is
    record
        RDY : std_logic;
        Data_in : Tbl_In(1 to N_chanel);
    end record;

Type OUT_ADS is
    record
        Vector_out : Tbl_Out(1 to N_chanel);
    end record;

constant Data_inINIT  :  Tbl_In(1 to N_chanel) := (others => '0');
constant IN_ADSINIT   :  IN_ADS                := ('1',Data_inINIT);


end;