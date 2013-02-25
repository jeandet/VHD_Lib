-- FFTamont.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity FFTamont is
generic(
    Data_sz  : integer range 1 to 32 := 16
    );
port(
    clk         : in std_logic;
    rstn        : in std_logic;
    Load        : in std_logic;
    Empty       : in std_logic;
    Full        : in std_logic;
    DATA        : in std_logic_vector(Data_sz-1 downto 0);
    Valid       : out std_logic;
    Read        : out std_logic;
    Data_re     : out std_logic_vector(Data_sz-1 downto 0);
    Data_im     : out std_logic_vector(Data_sz-1 downto 0)
);
end entity;


architecture ar_FFTamont of FFTamont is

type etat is (eX,e0,e1,e2);
signal ect : etat;


begin

    process(clk,rstn)
    begin
        if(rstn='0')then 
            ect <= eX;
            Read <= '1';
            Valid <= '0';
            Data_re <= (others => '0');
            Data_im <= (others => '0');
            
        elsif(clk'event and clk='1')then

            case ect is

                when eX => 
                    if(Full='1')then
                        ect <= e0;
                    end if;

                when e0 =>
                    Valid <= '0';
                    if(Load='1' and Empty='0')then
                        Read <= '0';
                        ect <= e1;
                    elsif(Empty='1')then
                        ect <= eX;                        
                    end if;

                when e1 =>
                    Read <= '1';
                    Data_re <= DATA;
                    Data_im <= (others => '0');
                    Valid <= '1';
                    ect <= e0;  
               
                when e2 =>
                    null;                                           

            end case;
        end if;
    end process;

end architecture;





















