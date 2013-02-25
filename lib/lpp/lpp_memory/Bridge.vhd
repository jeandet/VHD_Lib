-- Bridge.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Bridge is
generic(
    Data_sz  : integer range 1 to 32 := 16
    );
port(
    clk         : in std_logic;
    raz        : in std_logic;
    Start : in std_logic;
    FullUp : in std_logic;
    EmptyUp : in std_logic;
    FullDown : in std_logic;
    EmptyDown : in std_logic;
    Write : out std_logic;
    Read : out std_logic
);
end entity;


architecture ar_Bridge of Bridge is

type etat is (eX,e1,e2,e3);
signal ect : etat;

signal i : integer;

begin

    process(clk,raz)
    begin
        if(raz='0')then 
            Write <= '1';
            Read <= '1';
            i <= 0;
            ect <= eX;
            
        elsif(clk'event and clk='1')then
            
            case ect is
                
                when eX =>
                    if(FullUp='1' and EmptyDown='1' and start='0')then
                        ect <= e1;
                    end if;    

                when e1 =>
                    Write <= '1';
                    if(EmptyUp='0')then
                        Read <= '0';
                        ect <= e2;
                    else
                        Read <= '1';
                        ect <= e3;
                    end if;

                when e2 =>
                    Read <= '1';
                    if(FullDown='0')then
                        Write <= '0';
                        ect <= e1;
                    else
                        Write <= '1';
                        ect <= e3;
                    end if;
                    
                when e3 =>
                     null;

             end case;         
        end if;
    end process;


end architecture;