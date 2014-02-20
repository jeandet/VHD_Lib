-- Bridge.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Bridge is
    port(
        clk         : in std_logic;
        raz        : in std_logic;
        EmptyUp : in std_logic;
        FullDwn : in std_logic;
        WriteDwn : out std_logic;
        ReadUp : out std_logic
        );
end entity;


architecture ar_Bridge of Bridge is

type etat is (e0,e1);
signal ect : etat;

begin

    process(clk,raz)
    begin
        if(raz='0')then 
            WriteDwn    <= '1';
            ReadUp      <= '1';
            ect         <= e0;

        elsif(clk'event and clk='1')then

            case ect is

                when e0 =>
                    WriteDwn    <= '1';
                    if(EmptyUp='0' and FullDwn='0')then
                        ReadUp      <= '0';
                        ect         <= e1;
                    end if;

                when e1 =>
                    ReadUp      <= '1';
                    WriteDwn    <= '0';
                    ect         <= e0; 
                           
            end case;                
   
        end if;
    end process;

end architecture;