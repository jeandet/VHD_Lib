library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SerDes is
    generic ( 
        Dbits : integer := 16
           );   
    Port (
           serial_clk : in STD_LOGIC;
           clk        : in STD_LOGIC;
           rstn       : in STD_LOGIC;
           load : in STD_LOGIC;
           enable : in STD_LOGIC;
           serial_in : in STD_LOGIC;
           parallel_in : in STD_LOGIC_VECTOR(Dbits-1 downto 0);
           dout : out STD_LOGIC;
           parallel_out : out STD_LOGIC_VECTOR(Dbits-1 downto 0);
           ready : out STD_LOGIC
          );
end SerDes;

architecture Behavioral of SerDes is

signal rx_counter         : integer   := 0 ;
signal shift_reg : STD_LOGIC_VECTOR(Dbits-1 downto 0);
type   TYPE_STATE is (Idle,ShiftIn); 
signal CURRENT_STATE      : TYPE_STATE := Idle;
signal serial_clock_D : STD_LOGIC := '0';

begin

serialization : process(clk,rstn)  --Envoyer une donnée parallèle et la récupérer sur le sortie série

begin 

    if (rstn = '0') then
        shift_reg <= (others => '0');
        rx_counter <= 0;
        serial_clock_D <= '0';
        CURRENT_STATE <= Idle;
        ready <= '0';
        
    elsif (clk = '1' and clk'event) then  
            serial_clock_D <= serial_clk;
               
            case CURRENT_STATE is 
                
                when Idle =>
                    if (enable = '1') then
                        CURRENT_STATE <= ShiftIn;
                        ready <= '0';
                    else
                        ready <= '1';
                        CURRENT_STATE <= Idle;     
                    end if;
                    if (load = '1') then
                        shift_reg <= parallel_in;
                    end if;
                    parallel_out <=  shift_reg;
                    rx_counter <= 0;
                
                when ShiftIn =>       
                      if(serial_clk = '0' and serial_clock_D = '1') then  --front descendant
                        shift_reg <=  shift_reg(Dbits-2 downto 0) & serial_in; 
                       if (rx_counter = Dbits-1) then
                             CURRENT_STATE <= Idle;
                        else 
                             rx_counter <= rx_counter + 1;
                        end if;                           
                      end if;

            end case;
    end if;
end process;

dout <= shift_reg(Dbits-1); 

end Behavioral;
