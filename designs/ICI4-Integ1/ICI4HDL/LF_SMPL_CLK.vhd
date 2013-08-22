-- LF_SMPL_CLK.vhd
library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;


entity LF_SMPL_CLK is 
generic(N : integer range 0 to 4096 :=24);
port(
    reset    :   in  std_logic;
    wclk     :   in  std_logic;
    SMPL_CLK :   out std_logic
);
end entity;






architecture  ar_LF_SMPL_CLK of LF_SMPL_CLK is 

signal  cpt     :   integer range 0 to N-1 := 0;
begin



process(reset,wclk)
begin
if reset = '0' then
    SMPL_CLK    <=  '1';
	 cpt 			 <=  0;
elsif wclk'event and wclk = '1' then
    if cpt = (N-1) then
        cpt <=  0;
    else
        cpt <=  cpt+1;
    end if;
    if cpt = 0 then
        SMPL_CLK   <=  '1';
    elsif cpt = (N/2) then
        SMPL_CLK   <=  '0';
    end if;
end if;

end process;

end ar_LF_SMPL_CLK;