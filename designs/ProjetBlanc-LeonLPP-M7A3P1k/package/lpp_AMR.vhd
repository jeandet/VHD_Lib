library ieee;
use ieee.std_logic_1164.all;
library grlib;
use grlib.amba.all;
use std.textio.all;
library lpp;
use lpp.lpp_amba.all;

--! Package contenant tous les programmes qui forment le composant intégré dans le léon 

package lpp_AMR is

component APB_AMR is
  generic (
    pindex   : integer := 0;
    paddr    : integer := 0;
    pmask    : integer := 16#fff#;
    pirq     : integer := 0;
    abits    : integer := 8);
 port (
    clk     : in  std_logic;           --! Horloge du composant
    rst     : in  std_logic;           --! Reset general du composant
    clkH    : in  std_logic; 
    clk_MOD     : out std_logic;                        --! Horloge de sortie, Modulation
    clk_DMOD    : out std_logic;                       --! Horloge de sortie, Demodulation
    apbi    : in  apb_slv_in_type;     --! Registre de gestion des entrées du bus
    apbo    : out apb_slv_out_type     --! Registre de gestion des sorties du bus
);
end component;

component bclk_reg is

port(
    clk,raz     : in std_logic;     --! Horloge 25Mhz et reset du systeme 
    D           : in std_logic;     --! Signal d'entre
    Q           : out std_logic);   --! Signal de sortie

end component;

 component Clock_multi is

port( 
    clk,raz     : in std_logic;                     --! Horloge 25Mhz et reset du systeme
    pulse       : in std_logic;                     --! Reset local
    N           : in integer range 4 to 25_000;     --! La valeur MAX du compteur
    clk_var     : out std_logic);                   --! Horloge obtenu en sortie

end component;


component Dephaseur is

port( 
    clk,raz     : in std_logic;                         --! Horloge 25Mhz et reset du systeme 
    div         : in integer range 250 to 25_000;       --! Valeur MAX pour le compteur (Frequence)
    phi         : in integer range 4 to 12500;          --! Valeur MAX pour le compteur (Dephasage)
    Stop_count  : in std_logic;                         --! Flag, interuption des compteur / synchronise phi et div
    clk_MOD     : out std_logic;                        --! Horloge de sortie, Modulation
    clk_DMOD    : out std_logic);                       --! Horloge de sortie, Demodulation

end component;


component Gene_Rz is

port( 
    clk,raz     : in std_logic;     --! Horloge 25Mhz et reset du systeme
    clk_20K     : in std_logic;     --! Horloge de modulation
    pulse       : out std_logic);   --! Reset local

end component;
end;
