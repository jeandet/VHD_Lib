-- FX2_Driver.vhd


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library lpp;
use lpp.lpp_usb.all;

entity FX2_Driver is
port(
        clk         : in STD_LOGIC;
        if_clk      : out STD_LOGIC;
        reset       : in  std_logic;
        flagb       : in STD_LOGIC; 
        slwr        : out STD_LOGIC;
        slrd        : out std_logic;
        pktend      : out STD_LOGIC;
        sloe        : out STD_LOGIC;
        fdbusw      : out std_logic_vector (7 downto 0);
        fifoadr     : out std_logic_vector (1 downto 0);

        FULL        : out std_logic;
        Write       : in std_logic;
        Data        : in std_logic_vector(7 downto 0)
    ); 
end FX2_Driver;


architecture Ar_FX2_Driver of FX2_Driver is

type FX2State is (idle);

begin

   slrd    <= '1';
   sloe    <= '1';
   pktend  <= '1';
   fifoadr <= "10";
   if_clk  <= not clk; 
   FULL <= not flagb;

process(reset,clk)
begin
    if reset ='0' then
        slwr   <= '1';
        fdbusw <= (others => '0');
    elsif clk'event and clk = '1' then
        if Write = '1' and flagb = '1' then 
            fdbusw <= Data;
            slwr   <= '0';
        else
            slwr   <= '1';
        end if; 
    end if;
end process;


end ar_FX2_Driver; 

























