-- TOP_Serial_Driver2.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity TOP_Serial_Driver2 is
port(
    clk     :   in  std_logic;
    sclk    :   in  std_logic;
    Gate    :   in  std_logic;
    Data    :   out std_logic
);
end TOP_Serial_Driver2;




architecture ar_TOP_Serial_Driver2 of TOP_Serial_Driver2 is
constant Size   :   integer := 8;
signal  MinF_Inv    :   std_logic;
signal  Gate_Inv    :   std_logic;
signal  sclk_Inv    :   std_logic;
signal  OV          :   std_logic;
signal  Word      :   std_logic_vector(Size-1 downto 0);
constant  Word1      :   std_logic_vector(Size-1 downto 0) := std_logic_vector(TO_UNSIGNED(36,Size));
constant  Word2      :   std_logic_vector(Size-1 downto 0) := std_logic_vector(TO_UNSIGNED(255,Size));
signal  Flag        :   std_logic :='0';

begin
Gate_Inv    <=  not Gate;
sclk_Inv    <=  not Sclk;


SD0 : entity work.Serial_Driver 
generic map(Size)
port map(
    sclk_Inv,
    Word,
    Gate_inv,
    Data
);

cpt :   entity work.Simple_Counter
generic map(8)
port map(
    clk,
    sclk_Inv,
    Gate_Inv,
    OV);


word    <=  Word1;-- when OV = '1' and Flag = '0' else Word2 when OV = '1' and Flag = '1';

process(sclk)
begin
if sclk'event and sclk = '1' then
    if OV = '1' then 
        Flag    <=  not Flag;
    end if;
end if;
end process;


end ar_TOP_Serial_Driver2;