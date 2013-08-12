-- Serial_driver.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;





entity Serial_driver2 is
generic(Sz  :   integer := 8);
port(
    Sclk    :   in std_logic;
    rstn    :   in  std_logic;
    Sdata   :   in  std_logic;
    Gate    :   in  std_logic;
    NwDat   :   out std_logic;
    Data    :   out std_logic_vector(Sz-1 downto 0)
);
end entity;



architecture  arSerial_driver2 of Serial_driver2 is
signal  DataR    :    std_logic_vector(Sz-1 downto 0);
signal  DataCnt  :    integer range 0 to Sz-1 :=0;
signal  DataCntR :    integer range 0 to Sz-1 :=0;
begin


process(rstn,Sclk)
begin
    if rstn = '0' then
        DataR   <=  (others=>'0');
        NwDat   <=  '0';
    elsif Sclk'event and Sclk ='1' then
        DataCntR    <=  DataCnt;
        if DataCntR = Sz-1 then
            NwDat   <=  '1';
            Data    <=  DataR;
        else
            NwDat   <=  '0';
        end if;
        if Gate ='1' then
            DataR   <=  DataR(Sz-2 downto 0) & Sdata;
            if DataCnt = Sz-1 then
                DataCnt <=  0;
            else
                DataCnt <=  DataCnt +1;
            end if;
        else
            DataCnt <=  0;
        end if;
    end if;
end process;


end architecture;




