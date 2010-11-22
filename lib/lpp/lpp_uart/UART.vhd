-- UART.vhd
library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
library lpp;
use lpp.lpp_uart.all;

--! Programme qui va gerer toute la communication entre le PC et le FPGA

entity UART is 
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
end entity;


--! @details Gestion de la Reception/Transmission donc de la Vectorisation/Serialisation
--! ainsi que la detection et le reglage de le frequence de transmission optimale sur le bus (Generateur de Bauds) 
architecture ar_UART of UART is
signal  Bclk    :   std_logic;

signal  RDATA_int       :   std_logic_vector(Data_sz+1 downto 0);
signal  WDATA_int       :   std_logic_vector(Data_sz+1 downto 0);

signal  TXD_Dummy       :   std_logic;
signal  NwDat_int       :   std_logic;
signal  NwDat_int_reg   :   std_logic;
signal  receive         :   std_logic;

begin


RDATA       <=  RDATA_int(8 downto 1);
WDATA_int   <=  '1' & WDATA & '0'; 

BaudGenerator : BaudGen
    port map(clk,reset,Capture,Bclk,RXD,BTrigger);


RX_REG  : Shift_REG
    generic map(Data_sz+2)
    port map(clk,Bclk,reset,RXD,TXD_Dummy,receive,NwDat_int,(others => '0'),RDATA_int);

TX_REG  : Shift_REG
    generic map(Data_sz+2)
    port map(clk,Bclk,reset,'1',TXD,Send,Sended,WDATA_int);



process(clk,reset)
begin
    if reset = '0' then
        NwDat   <=  '0';
    elsif clk'event and clk = '1' then
        NwDat_int_reg   <=  NwDat_int;
        if RXD = '1' and NwDat_int = '1' then
            receive <=  '0';
        elsif RXD = '0' then
            receive <=  '1';
        end if;
        if NwDat_int_reg = '0' and NwDat_int = '1' then
            NwDat   <=  '1';
        elsif ack = '1' then
            NwDat   <=  '0';
        end if;
    end if;
end process;

end ar_UART;