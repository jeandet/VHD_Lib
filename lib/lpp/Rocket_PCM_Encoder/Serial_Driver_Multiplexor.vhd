-- Serial_Driver_Multiplexor.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;



entity Serial_Driver_Multiplexor is
generic(InputCnt : integer := 2;inputSize : integer:=8);
port(
    clk     :   in  std_logic;
    Sel     :   in  integer range 0 to InputCnt-1;
    input   :   in  std_logic_vector(InputCnt*inputSize-1 downto 0);
    output  :   out std_logic_vector(inputSize-1 downto 0)
);
end entity;



architecture ar_Serial_Driver_Multiplexor of Serial_Driver_Multiplexor is
begin


process(clk)
begin
if clk'event and clk = '1' then
    output  <=  input((Sel+1)*inputSize-1 downto (Sel)*inputSize);
end if;
end process;


end ar_Serial_Driver_Multiplexor;

