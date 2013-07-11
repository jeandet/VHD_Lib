-- ADS1274_DRIVER.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library lpp;
use lpp.lpp_ad_conv.all;
use lpp.general_purpose.all;





entity DUAL_ADS1278_DRIVER is 
port(
    Clk     :   in  std_logic;
    reset   :   in  std_logic;
    SpiClk  :   out std_logic;
    DIN     :   in  std_logic_vector(1 downto 0);
    SmplClk :   in  std_logic;
    OUT00    :   out std_logic_vector(23 downto 0);
    OUT01    :   out std_logic_vector(23 downto 0);
    OUT02    :   out std_logic_vector(23 downto 0);
    OUT03    :   out std_logic_vector(23 downto 0);
    OUT04    :   out std_logic_vector(23 downto 0);
    OUT05    :   out std_logic_vector(23 downto 0);
    OUT06    :   out std_logic_vector(23 downto 0);
    OUT07    :   out std_logic_vector(23 downto 0);
    OUT10    :   out std_logic_vector(23 downto 0);
    OUT11    :   out std_logic_vector(23 downto 0);
    OUT12    :   out std_logic_vector(23 downto 0);
    OUT13    :   out std_logic_vector(23 downto 0);
    OUT14    :   out std_logic_vector(23 downto 0);
    OUT15    :   out std_logic_vector(23 downto 0);
    OUT16    :   out std_logic_vector(23 downto 0);
    OUT17    :   out std_logic_vector(23 downto 0);
    FSynch  :   out std_logic
);
end DUAL_ADS1278_DRIVER;






architecture ar_DUAL_ADS1278_DRIVER of DUAL_ADS1278_DRIVER is

signal  Vec00,Vec01,Vec02,Vec03,Vec04,Vec05,Vec06,Vec07,Vec10,Vec11,Vec12,Vec13,Vec14,Vec15,Vec16,Vec17     :   std_logic_vector(23 downto 0);
signal  SmplClk_Reg             :   std_logic:= '0';
signal  N                       :   integer range 0 to 23*8 := 0;
signal  SPI_CLk                 :   std_logic;
signal  SmplClk_clkd            :   std_logic:= '0';

begin


CLKDIV0 : Clk_Divider2 
generic map(16)
port map(Clk,SPI_CLk);


FSynch  <=  SmplClk_clkd;
SpiClk  <=  SPI_CLk;

process(reset,SPI_CLk)
begin

    if reset = '0' then
        Vec00        <=  (others => '0');
        Vec01        <=  (others => '0');  
        Vec02        <=  (others => '0');
        Vec03        <=  (others => '0');
        Vec04        <=  (others => '0');
        Vec05        <=  (others => '0');
        Vec06        <=  (others => '0');
        Vec07        <=  (others => '0');

        Vec10        <=  (others => '0');
        Vec11        <=  (others => '0');  
        Vec12        <=  (others => '0');
        Vec13        <=  (others => '0');
        Vec14        <=  (others => '0');
        Vec15        <=  (others => '0');
        Vec16        <=  (others => '0');
        Vec17        <=  (others => '0');
        N           <=  0;
    elsif SPI_CLk'event and SPI_CLk = '1' then
--        SmplClk_clkd  <=  SmplClk;
--        SmplClk_Reg   <=  SmplClk_clkd;
        --if ((SmplClk_clkd = '1' and SmplClk_Reg = '0') or (N /= 0)) then
        if ((SmplClk_clkd = '1' and SmplClk_Reg = '0') or (N /= 0)) then
            --Vec0(0)            <=  DIN(0);
            --Vec1(0)            <=  DIN(1);
            --Vec2(0)            <=  DIN(2);
            --Vec3(0)            <=  DIN(3);
            --Vec0(23 downto 1)   <= Vec0(22 downto 0);
            --Vec1(23 downto 1)   <= Vec1(22 downto 0);
            --Vec2(23 downto 1)   <= Vec2(22 downto 0);
            --Vec3(23 downto 1)   <= Vec3(22 downto 0);
		Vec00(0)             <=  DIN(0);
		Vec00(23 downto 1)   <= Vec00(22 downto 0);
		Vec01(0)   	    <= Vec00(23);

		Vec01(23 downto 1)   <= Vec01(22 downto 0);
		Vec02(0)   	    <= Vec01(23);

		Vec02(23 downto 1)   <= Vec02(22 downto 0);
		Vec03(0)   	    <= Vec02(23);

		Vec03(23 downto 1)   <= Vec03(22 downto 0);
		Vec04(0)   	    <= Vec03(23);

		Vec04(23 downto 1)   <= Vec04(22 downto 0);
		Vec05(0)   	    <= Vec04(23);

		Vec05(23 downto 1)   <= Vec05(22 downto 0);
		Vec06(0)   	    <= Vec05(23);

		Vec06(23 downto 1)   <= Vec06(22 downto 0);
		Vec07(0)   	    <= Vec06(23);

		Vec07(23 downto 1)   <= Vec07(22 downto 0);

                
                Vec10(0)             <=  DIN(1);
		Vec10(23 downto 1)   <= Vec10(22 downto 0);
		Vec11(0)   	    <= Vec10(23);

		Vec11(23 downto 1)   <= Vec11(22 downto 0);
		Vec12(0)   	    <= Vec11(23);

		Vec12(23 downto 1)   <= Vec12(22 downto 0);
		Vec13(0)   	    <= Vec12(23);

		Vec13(23 downto 1)   <= Vec13(22 downto 0);
		Vec14(0)   	    <= Vec13(23);

		Vec14(23 downto 1)   <= Vec14(22 downto 0);
		Vec15(0)   	    <= Vec14(23);

		Vec15(23 downto 1)   <= Vec15(22 downto 0);
		Vec16(0)   	    <= Vec15(23);

		Vec16(23 downto 1)   <= Vec16(22 downto 0);
		Vec17(0)   	    <= Vec16(23);

		Vec17(23 downto 1)   <= Vec17(22 downto 0);
            if N = (23*8) then
                N   <=  0;
            else 
                N   <=  N+1;
            end if;
        end if;
    end if;
end process;


process(SPI_CLk)
begin
    if SPI_CLk'event and SPI_CLk ='0' then 
        SmplClk_clkd  <=  SmplClk;
        SmplClk_Reg   <=  SmplClk_clkd;
    end if;
end process;


process(SPI_CLk)
begin
    if SPI_CLk'event and SPI_CLk ='1' then 
        if N = 0 then
            OUT00    <=  Vec00;
            OUT01    <=  Vec01;
            OUT02    <=  Vec02;
            OUT03    <=  Vec03;
            OUT04    <=  Vec04;
            OUT05    <=  Vec05;
            OUT06    <=  Vec06;
            OUT07    <=  Vec07;

            OUT10    <=  Vec10;
            OUT11    <=  Vec11;
            OUT12    <=  Vec12;
            OUT13    <=  Vec13;
            OUT14    <=  Vec14;
            OUT15    <=  Vec15;
            OUT16    <=  Vec16;
            OUT17    <=  Vec17;
        end if;
    end if;
end process;

end ar_DUAL_ADS1278_DRIVER;






























