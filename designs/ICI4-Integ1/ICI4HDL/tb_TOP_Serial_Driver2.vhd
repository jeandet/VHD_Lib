-- tb_TOP_Serial_Driver2.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity tb_TOP_Serial_Driver2 is
end entity;



architecture ar_tb_TOP_Serial_Driver2 of tb_TOP_Serial_Driver2 is 

constant Speed  :   integer :=  4*1000*1000;
constant Tclk   :   time    :=  real(1000*1000*1000/Speed) * 1 ns;
constant Size   :   integer :=  8;

signal  clk         :   std_logic:='0';
signal  sclk        :   std_logic := '0';
signal  Gate        :   std_logic:='1';
signal  Data        :   std_logic;

begin

SD0 : entity work.TOP_Serial_Driver2
port map(clk,sclk,Gate,Data);

sclk    <=  not sclk after Tclk/2;
clk     <=  not clk  after 10ns;




process
begin
gate    <=  '1';
wait for 1us;
gate    <=  '0';
wait for Size * Tclk;
gate    <=  '1';
wait for 1ns;

wait for 1us;

wait for 1ns;

gate    <=  '0';
wait for Size * Tclk;
gate    <=  '1';
wait for 1ns;

gate    <=  '0';
wait for Size *4* Tclk;
gate    <=  '1';
wait for 10us;


gate    <=  '0';
wait for Size *2* Tclk;
gate    <=  '1';
wait for 1ns;


wait;
end process;



end ar_tb_TOP_Serial_Driver2;