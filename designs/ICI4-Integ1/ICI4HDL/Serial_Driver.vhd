-- Serial_Driver.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity Serial_Driver is
generic(size    :   integer :=8);
port(
    sclk     :   in  std_logic;
    inputDat:   in  std_logic_vector(size-1 downto 0);  
    Gate    :   in  std_logic;
    Data    :   out std_logic
);
end Serial_Driver;




architecture ar_Serial_Driver of Serial_Driver is
signal  Count   :   integer range 0 to size-1;
signal    SR_internal :   std_logic_vector(size-1 downto 0):=std_logic_vector(TO_UNSIGNED(165,Size));
begin
process(sclk)
begin
    if SCLK'event and SCLK = '1' then
        if gate = '1' then
            if Count = size-1 then 
                Count <= 0;
                Data        <=  SR_internal(size-1);
                SR_internal <=  inputDat;
            else
                Count <= Count+1;
                Data    <=  SR_internal(size-1);
                SR_internal <=  SR_internal(size-2 downto 0) & '0';
            end if;
        else
            SR_internal <=  inputDat;
            Data    <=  '0';
            Count   <=  0;
        end if;
    end if;
end process;
end ar_Serial_Driver;