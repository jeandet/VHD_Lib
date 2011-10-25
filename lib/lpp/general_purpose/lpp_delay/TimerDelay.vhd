-- TimerDelay.vhd
library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;

entity TimerDelay is
port(
    clk     : in  std_logic;
    raz     : in  std_logic;
    Start : in std_logic;
    Fin : out std_logic;
    Cpt : in std_logic_vector(25 downto 0)
);
end TimerDelay;


architecture ar_TimerDelay of TimerDelay is

type state is (stX,st1);
signal ect : state;

constant MAX : integer := 67_108_863;

signal delay : integer range 0 to MAX;
signal compt : integer range 0 to MAX;
signal Start_reg : std_logic;


begin

delay  <= to_integer(unsigned(Cpt));

    process(clk,raz)
    begin
    
        if(raz='0')then
            Fin <= '1';
            Start_reg <= '0';
            ect <= stX;
        
        elsif(clk'event and clk='1')then 
            Start_reg <= Start;          
              
            case ect is

                when stX =>                    
                    if(Start_reg = '0' and Start = '1')then
                        Fin <= '0';
                        ect <= st1;
                    end if;
           

                when st1 =>
                    if(compt = delay)then
                        compt <= 0;
                        Fin <= '1';
                        ect <= stX;
                    else
                        compt <= compt + 1;
                        ect <= st1;
                    end if;              
             
            end case;
        end if;
    end process;

end ar_TimerDelay;