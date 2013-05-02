-- ADS1274_DRIVER.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library lpp;
use lpp.lpp_ad_conv.all;
use lpp.general_purpose.all;





entity ADS1278_DRIVER is 
generic(modeCfg : ADS127X_MODE_Type := ADS127X_MODE_low_power; formatCfg : ADS127X_FORMAT_Type := ADS127X_FSYNC_FORMAT);
port(
    Clk     :   in  std_logic;
    reset   :   in  std_logic;
    SpiClk  :   out std_logic;
    DIN     :   in  std_logic_vector(7 downto 0);
    Ready   :   in  std_logic;
    Format  :   out std_logic_vector(2 downto 0);
    Mode    :   out std_logic_vector(1 downto 0);
    ClkDiv  :   out std_logic;
    PWDOWN  :   out std_logic_vector(7 downto 0);
    SmplClk :   in  std_logic;
    OUT0    :   out std_logic_vector(23 downto 0);
    OUT1    :   out std_logic_vector(23 downto 0);
    OUT2    :   out std_logic_vector(23 downto 0);
    OUT3    :   out std_logic_vector(23 downto 0);
    OUT4    :   out std_logic_vector(23 downto 0);
    OUT5    :   out std_logic_vector(23 downto 0);
    OUT6    :   out std_logic_vector(23 downto 0);
    OUT7    :   out std_logic_vector(23 downto 0);
    FSynch  :   out std_logic
);
end ADS1278_DRIVER;






architecture ar_ADS1278_DRIVER of ADS1278_DRIVER is

signal  Vec0,Vec1,Vec2,Vec3,Vec4,Vec5,Vec6,Vec7     :   std_logic_vector(23 downto 0);
signal  SmplClk_Reg             :   std_logic:= '0';
signal  N                       :   integer range 0 to 23*8 := 0;
signal  SPI_CLk                 :   std_logic;
signal  SmplClk_clkd            :   std_logic:= '0';

begin


CLKDIV0 : Clk_Divider2 
generic map(16)
port map(Clk,SPI_CLk);


Mode(1) <=  modeCfg(1);
Mode(0) <=  modeCfg(0);
Format(2)  <=  formatCfg(2);
Format(1)  <=  formatCfg(1);
Format(0)  <=  formatCfg(0);
PWDOWN  <=  (others => '1');
FSynch  <=  SmplClk_clkd;
ClkDiv  <=  '1';
SpiClk  <=  SPI_CLk;

process(reset,SPI_CLk)
begin

    if reset = '0' then
        Vec0        <=  (others => '0');
        Vec1        <=  (others => '0');  
        Vec2        <=  (others => '0');
        Vec3        <=  (others => '0');
        Vec4        <=  (others => '0');
        Vec5        <=  (others => '0');
        Vec6        <=  (others => '0');
        Vec7        <=  (others => '0');
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
		Vec0(0)             <=  DIN(0);
		Vec0(23 downto 1)   <= Vec0(22 downto 0);
		Vec1(0)   	    <= Vec0(23);

		Vec1(23 downto 1)   <= Vec1(22 downto 0);
		Vec2(0)   	    <= Vec1(23);

		Vec2(23 downto 1)   <= Vec2(22 downto 0);
		Vec3(0)   	    <= Vec2(23);

		Vec3(23 downto 1)   <= Vec3(22 downto 0);
		Vec4(0)   	    <= Vec3(23);

		Vec4(23 downto 1)   <= Vec4(22 downto 0);
		Vec5(0)   	    <= Vec4(23);

		Vec5(23 downto 1)   <= Vec5(22 downto 0);
		Vec6(0)   	    <= Vec5(23);

		Vec6(23 downto 1)   <= Vec6(22 downto 0);
		Vec7(0)   	    <= Vec6(23);

		Vec7(23 downto 1)   <= Vec7(22 downto 0);
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
            OUT0    <=  Vec0;
            OUT1    <=  Vec1;
            OUT2    <=  Vec2;
            OUT3    <=  Vec3;
            OUT4    <=  Vec4;
            OUT5    <=  Vec5;
            OUT6    <=  Vec6;
            OUT7    <=  Vec7;
        end if;
    end if;
end process;

end ar_ADS1278_DRIVER;






























