-- Vectorize.vhd
library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;


entity Vectorize is

port(
    clk,raz     : in std_logic;
    sclk        : in std_logic;
    RDY         : in std_logic;
    In1,In2,In3 : in std_logic;
    bit         : out std_logic;
    Vector_1,Vector_2,Vector_3 : out std_logic_vector(23 downto 0));

end Vectorize;


architecture ar_Vectorize of Vectorize is

type etat is (e0,e1,e2);
signal ect      : etat;

signal rdy_reg  : std_logic;
signal sclk_reg : std_logic;
signal cpt      : integer range 0 to 24;
signal Vect_1   : std_logic_vector(23 downto 0);
signal Vect_2   : std_logic_vector(23 downto 0);
signal Vect_3   : std_logic_vector(23 downto 0);

begin
    process(clk,raz)
    begin
        if(raz='0')then
            Vect_1      <= (others => '0');
            Vect_2      <= (others => '0');
            Vect_3      <= (others => '0');
            rdy_reg     <= '1';
            sclk_reg    <= '0';
            ect         <= e0;
            cpt         <= 0;
            bit <= '0';
                  
        elsif(clk'event and clk='1')then
        rdy_reg     <= RDY;
        sclk_reg    <= sclk;

            case ect is
                when e0 =>
                    if(rdy_reg='0' and RDY='1')then
                        ect <= e1;
                    else
                        ect <= e0;
                    end if;

                when e1 =>
                    bit <= '0';
                    if(sclk_reg='0' and sclk='1')then
                        Vect_1 <= Vect_1(22 downto 0) & In1;
                        Vect_2 <= Vect_2(22 downto 0) & In2;
                        Vect_3 <= Vect_3(22 downto 0) & In3;
                        if(cpt=23)then
                            cpt <= 0;
                            bit  <= '1';
                            ect <= e0;
                        else
                            cpt <= cpt + 1;
                            ect <= e2;
                        end if;
                    end if;
                
                when e2 =>
                    bit <= '0';
                    if(sclk_reg='0' and sclk='1')then
                        Vect_1 <= Vect_1(22 downto 0) & In1;
                        Vect_2 <= Vect_2(22 downto 0) & In2;
                        Vect_3 <= Vect_3(22 downto 0) & In3;
                        if(cpt=23)then
                            cpt <= 0;
                            bit  <= '1';
                            ect <= e0;
                        else
                            cpt <= cpt + 1;
                            ect <= e1;
                        end if;
                    end if;
            end case;
        end if;
    end process;

Vector_1 <= Vect_1;
Vector_2 <= Vect_2;
Vector_3 <= Vect_3;

end ar_Vectorize;