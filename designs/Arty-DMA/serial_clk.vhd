library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity serial_clk is
    generic (N : integer := 5);
    Port ( clk : in STD_LOGIC;
           rstn : in STD_LOGIC;
           serial_clk : out STD_LOGIC);
end serial_clk;

architecture Behavioral of serial_clk is
    signal cpt : integer range 0 to N := 0;
begin

process(rstn,clk)
   begin
        if rstn = '0' then
            cpt <= 0;
        elsif (clk'event and clk='1') then
            if(cpt=N) then
               cpt <= 0;
            else
               cpt <= cpt + 1;
               if(cpt < N/2) then
                 serial_clk <=   '0';
               else
                 serial_clk <= '1';
               end if;
            end if;
        end if;

end process;

end Behavioral;

