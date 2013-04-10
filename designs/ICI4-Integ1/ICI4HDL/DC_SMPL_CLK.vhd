-- DC_SMPL_CLK.vhd
library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;


entity DC_SMPL_CLK is 
port(
    minF     :   in  std_logic;
    SMPL_CLK :   out std_logic
);
end entity;






architecture  ar_DC_SMPL_CLK of DC_SMPL_CLK is 
signal  SMPL_CLK_reg    :   std_logic := '0';
begin

SMPL_CLK    <=  SMPL_CLK_reg;

process(minF)
begin

if minF'event and minF = '1' then
    SMPL_CLK_reg    <=  not SMPL_CLK_reg;
end if;

end process;

end ar_DC_SMPL_CLK;