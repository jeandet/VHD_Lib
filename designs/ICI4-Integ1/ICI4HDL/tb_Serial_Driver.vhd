-- tb_Serial_Driver.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity tb_Serial_Driver is
end entity;



architecture ar_tb_Serial_Driver of tb_Serial_Driver is 

constant Speed  :   integer :=  4*1000*1000;
constant Tclk   :   time    :=  real(1000*1000*1000/Speed) * 1 ns;
constant Size   :   integer := 8;


signal  sclk        :   std_logic := '0';
signal  inputDat    :   std_logic_vector(Size-1 downto 0);
signal  load        :   std_logic:='0';
signal  Gate        :   std_logic:='0';
signal  Data        :   std_logic;

begin

SD0 : entity work.Serial_Driver 
generic map(Size)
port map(
    sclk,
    inputDat,
    load,
    Gate,
    Data
);

sclk    <=  not sclk after Tclk/2;





process
begin

inputDat    <=  std_logic_vector(TO_UNSIGNED(0,Size));
wait for 1ns;
load    <=  '1';
wait for 1ns;
load    <=  '0';
gate    <=  '1';
wait for Size * Tclk;
gate    <=  '0';
wait for 1ns;


inputDat    <=  std_logic_vector(TO_UNSIGNED(165,Size));
wait for 1ns;
load    <=  '1';
wait for 1ns;
load    <=  '0';
gate    <=  '1';
wait for Size * Tclk;
gate    <=  '0';
wait for 1ns;


wait;
end process;



end ar_tb_Serial_Driver;