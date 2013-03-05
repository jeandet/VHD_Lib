-- FFTamont.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity FFTamont is
generic(
    Data_sz  : integer range 1 to 32 := 16;
    NbData : integer range 1 to 512 := 256
    );
port(
    clk         : in std_logic;
    rstn        : in std_logic;
    Load        : in std_logic;
    Empty       : in std_logic;
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

signal DataCount : integer;

begin

    process(clk,rstn)
    begin
        if(rstn='0')then 
            ect <= e0;
            Read <= '1';
            Valid <= '0';
            Data_re <= (others => '0');
            Data_im <= (others => '0');
            DataCount <= 0;
            
        elsif(clk'event and clk='1')then

            case ect is

                when e0 =>                    
                    if(Load='1' and Empty='0')then
                        Read <= '0';
                        ect <= eX;                       
                    end if;

                when eX =>
                    ect <= e1;               

                when e1 =>                    
                    Data_re <= DATA;
                    Data_im <= (others => '0');
                    Valid <= '1';
                    if(DataCount=NbData-2)then
                        Read <= '1';
                        DataCount <= DataCount + 1;
                    elsif(DataCount=NbData)then
                        Valid <= '0';
                        DataCount <= 0;
                        ect <= e0;
                    else
                        DataCount <= DataCount + 1;
                    end if;  
               
                when others =>
                    null;                                           

            end case;
        end if;
    end process;

end architecture;





















