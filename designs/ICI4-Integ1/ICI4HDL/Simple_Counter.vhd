-- Simple_Counter.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity Simple_Counter is
generic(N   :   integer := 8);
port(
    clk     :   in  std_logic;
    sclk    :   in  std_logic;
    Gate   :   in  std_logic;
    OV      :   out std_logic

);
end entity;


architecture ar_Simple_Counter of Simple_Counter is
signal  Count   :   integer range 0 to N-1;
signal  Gate_Reg    :   std_logic:='0';
signal  sclk_Reg    :   std_logic := '0';
begin

process(clk)
begin
    if clk'event and clk = '1' then
        Gate_Reg    <= Gate;
        sclk_Reg     <=  sclk;
        if Gate = '1' and Gate_reg = '0' then
            Count <= 0;
        else
            if sclk = '1' and sclk_Reg = '0' then
                if Count = N-1 then 
                    Count <= 0;
                else
                    Count <= Count+1;
                end if;
            end if;
        end if;
    end if;
end process;


OV  <=  '1' when Count = N-1 and sclk_Reg = '0' and sclk = '1' else '0';

end ar_Simple_Counter;











