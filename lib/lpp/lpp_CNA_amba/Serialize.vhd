-- Serialize.vhd
library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;

entity Serialize is

port(
    clk,raz : in std_logic;
    sclk    : in std_logic;
    vectin  : in std_logic_vector(15 downto 0);
    send    : in std_logic;
    sended  : out std_logic;
    Data    : out std_logic);

end Serialize;


architecture ar_Serialize of Serialize is

type etat is (attente,serialize);
signal ect      : etat;

signal vector_int   : std_logic_vector(16 downto 0);
signal vectin_reg   : std_logic_vector(15 downto 0);
signal load         : std_logic;
signal N            : integer range 0 to 16;
signal CPT_ended    : std_logic:='0';

begin
    process(clk,raz)
        begin
        if(raz='0')then           
            ect         <= attente;
            vectin_reg  <= (others=> '0');
            load        <= '0';
            sended      <= '1';            

        elsif(clk'event and clk='1')then
            vectin_reg <= vectin;
          
            case ect is
                when attente =>                     
                    if (send='1') then 
                        sended  <= '0'; 
                        load    <= '1';                   
                        ect     <= serialize;                        
                    else
                        ect <= attente;                       
                    end if;
                
                when serialize => 
                    load <= '0';                    
                    if(CPT_ended='1')then 
                        ect     <= attente;
                        sended  <= '1';                        
                    end if;

            end case;
        end if;
    end process;

    process(sclk,load,raz)
        begin
        if (raz='0')then
            vector_int <= (others=> '0');
            N <= 16;
        elsif(load='1')then
            vector_int <= vectin & '0';
            N <= 0;
        elsif(sclk'event and sclk='0')then        
            if (CPT_ended='0') then
                vector_int <= vector_int(15 downto 0) & '0'; 
                N <= N+1;
            end if; 
        end if;
    end process;

CPT_ended   <=  '1' when N = 16 else '0';

with ect select
    Data <=  vector_int(16) when serialize,
            '0' when others;
     
end ar_Serialize;
            
