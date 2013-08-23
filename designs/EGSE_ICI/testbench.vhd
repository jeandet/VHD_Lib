-- LF_GATE_GEN.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;








entity testbench is
port
(
);
end entity;




architecture ar_testbench of testbench is
signal Clock        :   std_logic;
signal reset        :   std_logic;
signal DataRTX      :   std_logic;
signal DataRTX_echo :   std_logic;
signal SCLK         :   std_logic;
signal Gate         :   std_logic;
signal Major_Frame  :   std_logic;
signal Minor_Frame  :   std_logic;
signal if_clk       :   STD_LOGIC;
signal flagb        :   STD_LOGIC; 
signal slwr         :   STD_LOGIC;
signal slrd         :   std_logic;
signal pktend       :   STD_LOGIC;
signal sloe         :   STD_LOGIC;
signal fdbusw       :   std_logic_vector (7 downto 0);
signal fifoadr      :   std_logic_vector (1 downto 0);

begin
EGSE: entity TOP_EGSE2 
generic map(8,144,64,1)
port map(Clock,
    reset,
    DataRTX,
    DataRTX_echo,
    SCLK,
    Gate,
    Major_Frame,
    Minor_Frame,
    if_clk,
    flagb,
    slwr,
    slrd,
    pktend,
    sloe,
    fdbusw,
    fifoadr
);

end architecture;