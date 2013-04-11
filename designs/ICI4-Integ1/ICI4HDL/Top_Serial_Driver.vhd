-- Top_Serial_Driver.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity Top_Serial_Driver is
port(
    sclk     :   in  std_logic;
    Gate    :   in  std_logic;
    MinF    :   in  std_logic;
    Data    :   out std_logic
);
end Top_Serial_Driver;




architecture ar_Top_Serial_Driver of Top_Serial_Driver is
constant Size   :   integer := 8;
signal  MinF_Inv    :   std_logic;
signal  Gate_Inv    :   std_logic;
signal  sclk_Inv    :   std_logic;
constant  Word        :   std_logic_vector(Size-1 downto 0) := std_logic_vector(TO_UNSIGNED(165,Size));


begin
MinF_Inv    <=  not MinF;
Gate_Inv    <=  not Gate;
sclk_Inv    <=  not Sclk;


SD0 : entity work.Serial_Driver 
generic map(Size)
port map(
    sclk_Inv,
    Word,
    MinF_Inv,
    Gate_Inv,
    Data
);
end ar_Top_Serial_Driver;