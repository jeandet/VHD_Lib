-- LF_SMPL_CLK.vhd
library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;


entity LF_SMPL_CLK is 
port(
    Wclck    :   in  std_logic;
    MinF     :   in  std_logic;
    SMPL_CLK :   out std_logic
);
end entity;






architecture  ar_LF_SMPL_CLK of LF_SMPL_CLK is 

signal  cpt     :   integer range 0 to 23 := 0;
begin



process(Wclck,MinF)
begin
if MinF = '0' then
    SMPL_CLK    <=  '1';
elsif Wclck'event and Wclck = '1' then
    if cpt = 23 then
        cpt <=  0;
    else
        cpt <=  cpt+1;
    end if;
    if cpt = 0 then
        SMPL_CLK   <=  '1';
    elsif cpt = 10 then
        SMPL_CLK   <=  '0';
    end if;
end if;

end process;

end ar_LF_SMPL_CLK;