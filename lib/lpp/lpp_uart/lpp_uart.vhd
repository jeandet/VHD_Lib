library ieee;
use ieee.std_logic_1164.all;
library grlib;
use grlib.amba.all;
-- pragma translate_off
use std.textio.all;
-- pragma translate_on
library lpp;
use lpp.lpp_amba.all;

package lpp_uart is


component APB_UART is
  generic (
    pindex   : integer := 0;
    paddr    : integer := 0;
    pmask    : integer := 16#fff#;
    pirq     : integer := 0;
    abits    : integer := 8;
    Data_sz  : integer := 8);
  port (
    clk     : in  std_logic;
    rst     : in  std_logic;    
    apbi    : in  apb_slv_in_type;
    apbo    : out apb_slv_out_type;
    TXD    :   out std_logic;
    RXD    :   in  std_logic
    );
end component;


component UART is
generic(Data_sz     :   integer :=  8);            --! Constante de taille pour un mot de donnee
port(
    clk         :   in  std_logic;                              --! Horloge a 25Mhz du systeme
    reset       :   in  std_logic;                              --! Reset du systeme
    TXD         :   out std_logic;                              --! Transmission, cote PC
    RXD         :   in  std_logic;                              --! Reception, cote PC
    Capture     :   in  std_logic;                              --! "Reset" cible pour le generateur de bauds, ici indissocie du reset global 
    NwDat       :   out std_logic;                              --! Flag, Nouvelle donnee presente
    ACK         :   in  std_logic;                              --! Flag, Reponse au flag precedent
    Send        :   in  std_logic;                              --! Flag, Demande d'envoi sur le bus
    Sended      :   out std_logic;                              --! Flag, Envoi termine
    BTrigger    :   out std_logic_vector(11 downto 0);          --! Registre contenant la valeur du diviseur de frequence pour la transmission
    RDATA       :   out std_logic_vector(Data_sz-1 downto 0);   --! Mot de donnee en provenance de l'utilisateur
    WDATA       :   in  std_logic_vector(Data_sz-1 downto 0)    --! Mot de donnee a transmettre a l'utilisateur
);
end component;


component Shift_REG is
generic(Data_sz     :   integer :=  10);
port(
    clk         :   in  std_logic;
    Sclk        :   in  std_logic;
    reset       :   in  std_logic;
    SIN         :   in  std_logic;
    SOUT        :   out std_logic;
    Serialize   :   in  std_logic;
    Serialized  :   out std_logic;
    D           :   in  std_logic_vector(Data_sz-1 downto 0);
    Q           :   out std_logic_vector(Data_sz-1 downto 0)

);
end component;


component BaudGen is
port(
    clk         :   in  std_logic;
    reset       :   in  std_logic;
    Capture     :   in  std_logic;
    Bclk        :   out std_logic;
    RXD         :   in  std_logic;
    BTrigger    :   out std_logic_vector(11 downto 0)
);
end component;


end lpp_uart;