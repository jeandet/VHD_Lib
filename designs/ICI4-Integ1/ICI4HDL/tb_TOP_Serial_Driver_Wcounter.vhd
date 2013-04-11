-- tb_TOP_Serial_Driver_Wcounter.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity tb_TOP_Serial_Driver_Wcounter is
end entity;



architecture ar_tb_TOP_Serial_Driver_Wcounter of tb_TOP_Serial_Driver_Wcounter is 

constant Speed  :   integer :=  4*1000*1000;
constant Tclk   :   time    :=  real(1000*1000*1000/Speed) * 1 ns;
constant Size   :   integer :=  8;
constant MinFCnt:   integer :=  144;
constant MajFCnt:   integer :=  64;

signal  clk         :   std_logic := '0';
signal  sclk        :   std_logic := '0';
signal  Gate        :   std_logic:='1';
signal  Data        :   std_logic;
signal  MinF        :   std_logic:='1';
signal  MajF        :   std_logic:='1';
signal  flag        :   std_logic;

begin

SD0 : entity work.TOP_Serial_Driver_Wcounter
--generic map(Size,MinFCnt)
generic map(Size,MinFCnt,MajFCnt)
port map(clk,sclk,Gate,MinF,MajF,Data);

sclk    <=  not sclk after Tclk/2;

clk    <=  not clk after 20ns;


process
begin

gate <= '1';
wait for (48)*Tclk;
gate <= '0';                    --1 ADMLF1.1
wait for (16)*Tclk;
gate <= '1';
wait for (48)*Tclk;
gate <= '0';                    --2 ADMLF2.1
wait for (32)*Tclk;
gate <= '1';
wait for (16)*Tclk;
gate <= '0';                    --3 ADMDC1 LSB
wait for (48)*Tclk;
gate <= '1';
wait for (16)*Tclk;
gate <= '0';                    --4 ADMDC2 LSB
wait for (32)*Tclk;
gate <= '1';


wait for (48)*Tclk;
gate <= '0';     
wait for (16)*Tclk;
gate <= '1';  
wait for (48)*Tclk;
gate <= '0';     
wait for (16)*Tclk;
gate <= '1';  
wait for (48)*Tclk;
gate <= '0';     
wait for (16)*Tclk;
gate <= '1';  
wait for (48)*Tclk;
gate <= '0';     
wait for (16)*Tclk;
gate <= '1';  
wait for (48)*Tclk;
gate <= '0';     
wait for (16)*Tclk;
gate <= '1';  
wait for (48)*Tclk;
gate <= '0';     
wait for (16)*Tclk;
gate <= '1';  
wait for (48)*Tclk;
gate <= '0';     
wait for (16)*Tclk;
gate <= '1';  
wait for (48)*Tclk;
gate <= '0';     
wait for (16)*Tclk;
gate <= '1';  
wait for (48)*Tclk;
gate <= '0';     
wait for (16)*Tclk;
gate <= '1';  
wait for (48)*Tclk;
gate <= '0';     
wait for (16)*Tclk;
gate <= '1';  
wait for (48)*Tclk;
gate <= '0';     
wait for (16)*Tclk;
gate <= '1';  
wait for (48)*Tclk;
gate <= '0';     
wait for (16)*Tclk;
gate <= '1';  
wait for (48)*Tclk;
gate <= '0';     
wait for (16)*Tclk;
gate <= '1';  
wait for (48)*Tclk;
gate <= '0';     
wait for (16)*Tclk;
gate <= '1';  
end process;




process
begin
MinF    <=  '0';
wait for Tclk;
MinF    <=  '1';
wait for (MinFCnt)*(Size)*Tclk-Tclk;
end process;



process
begin
MajF    <=  '0';
wait for Tclk;
MajF    <=  '1';
wait for (MajFCnt)*(MinFCnt)*(Size)*Tclk-Tclk;
end process;



end ar_tb_TOP_Serial_Driver_Wcounter;