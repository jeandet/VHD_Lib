------------------------------------------------------------------------------
--  This file is a part of the LPP VHDL IP LIBRARY
--  Copyright (C) 2009 - 2010, Laboratory of Plasmas Physic - CNRS
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 3 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA 
-------------------------------------------------------------------------------
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
    RDATA       :   out std_logic_vector(Data_sz-1 downto 0);   --! Current read word
    WDATA       :   in  std_logic_vector(Data_sz-1 downto 0)    --! Mot de donnee a transmettre a l'utilisateur
);
end component;


component Shift_Reg is
generic(
        Data_sz     :   integer :=  10 --! Width of the shift register
);
port(
    Sclk        :   in  std_logic; --! Serial clock
    SIN         :   in  std_logic; --! Serial data in
    SOUT        :   out std_logic; --! Serial data out
    Serialize   :   in  std_logic; --! Launch serialization
    Serialized  :   out std_logic; --! Serialization complete
    D           :   in  std_logic_vector(Data_sz-1 downto 0); --! Parallel data to be shifted out
    Q           :   out std_logic_vector(Data_sz-1 downto 0)  --! Unserialized data
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


end lpp_uart;
