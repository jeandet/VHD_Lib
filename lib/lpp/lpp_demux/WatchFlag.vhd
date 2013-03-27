-- WatchFlag.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity WatchFlag is
port(
    clk    :   in std_logic;
    rstn   :   in std_logic;

    FullF0a    :   in std_logic_vector(4 downto 0);
    FullF0b    :   in std_logic_vector(4 downto 0);
    FullF1     :   in std_logic_vector(4 downto 0);
    FullF2     :   in std_logic_vector(4 downto 0);

    EmptyF0a    :   in std_logic_vector(4 downto 0);
    EmptyF0b    :   in std_logic_vector(4 downto 0);
    EmptyF1     :   in std_logic_vector(4 downto 0);
    EmptyF2     :   in std_logic_vector(4 downto 0);

    DataCpt     :   out std_logic_vector(3 downto 0) -- f2 f1 f0b f0a
);
end entity;


architecture ar_WatchFlag of WatchFlag is

constant FlagSet : std_logic_vector(4 downto 0) := (others =>'1');

begin
    process(clk,rstn)
    begin
        if(rstn='0')then
            DataCpt <= (others => '0');

        elsif(clk'event and clk='1')then
           
            if(FullF0a = FlagSet)then
                DataCpt(0) <= '1';
            elsif(EmptyF0a = FlagSet)then
                DataCpt(0) <= '0';
            end if;

            if(FullF0b = FlagSet)then
                DataCpt(1) <= '1';
            elsif(EmptyF0b = FlagSet)then
                DataCpt(1) <= '0';
            end if;

            if(FullF1 = FlagSet)then
                DataCpt(2) <= '1';
            elsif(EmptyF1 = FlagSet)then
                DataCpt(2) <= '0';
            end if;

            if(FullF2 = FlagSet)then
                DataCpt(3) <= '1';
            elsif(EmptyF2 = FlagSet)then
                DataCpt(3) <= '0';
            end if;

        end if;
    end process;

end architecture;