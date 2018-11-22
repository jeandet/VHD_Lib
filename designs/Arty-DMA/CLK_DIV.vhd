library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CLK_DIV is
    generic(fclkout      : integer := 10000000);
    Port ( clk           : in STD_LOGIC;
           rstn          : in STD_LOGIC;
           serial_clk    : out STD_LOGIC);
           
end CLK_DIV;

architecture Behavioral of CLK_DIV is

constant sysfreq  : integer := 20000000; 
constant DIVRATIO : integer := (sysfreq / fclkout);
signal cpt        : integer range 0 to DIVRATIO:= 0;

begin
process(clk,rstn)
    begin
        if (rstn = '0') then
            cpt <= 0;
        elsif (clk'event and clk ='1') then
            if(cpt=DIVRATIO) then
               cpt <= 0;
            else
               cpt <= cpt + 1;
            if(cpt < DIVRATIO/2) then
               serial_clk <=  '0';
            else
               serial_clk <= '1';
            end if;
            end if;  
        end if;
        
end process;
end Behavioral;


