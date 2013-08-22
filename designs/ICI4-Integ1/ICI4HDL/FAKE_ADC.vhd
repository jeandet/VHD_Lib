-- ADS1274_DRIVER.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library lpp;
use lpp.lpp_ad_conv.all;
use lpp.general_purpose.all;





entity FAKE_DUAL_ADS1278_DRIVER is 
generic
(
	SCLKDIV	:	integer range 2 to 256 :=16
);
port(
    Clk      :   in  std_logic;
    reset    :   in  std_logic;
    SpiClk   :   out std_logic;
    DIN      :   in  std_logic_vector(1 downto 0);
    SmplClk  :   in  std_logic;
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
    FSynch   :   out std_logic
);
end FAKE_DUAL_ADS1278_DRIVER;






architecture ar_FAKE_DUAL_ADS1278_DRIVER of FAKE_DUAL_ADS1278_DRIVER is
signal  ShiftGeg0,ShiftGeg1	  :   std_logic_vector((8*24)-1 downto 0);
signal  ShiftGeg20,ShiftGeg21     :   std_logic_vector((8*24)-1 downto 0);
signal  SmplClk_Reg               :   std_logic:= '0';
signal  N                         :   integer range 0 to (24*8) := 0;
signal  SPI_CLk                   :   std_logic;
signal  SmplClk_clkd              :   std_logic:= '0';
signal  OUT00_r                   :   std_logic_vector(23 downto 0) := (others => '0');
signal  OUT01_r                   :   std_logic_vector(23 downto 0) := (others => '0');
signal  OUT02_r                   :   std_logic_vector(23 downto 0) := (others => '0');
signal  OUT03_r                   :   std_logic_vector(23 downto 0) := (others => '0');
signal  OUT04_r                   :   std_logic_vector(23 downto 0) := (others => '0');
signal  OUT05_r                   :   std_logic_vector(23 downto 0) := (others => '0');
signal  OUT06_r                   :   std_logic_vector(23 downto 0) := (others => '0');
signal  OUT07_r                   :   std_logic_vector(23 downto 0) := (others => '0');
signal  OUT10_r                   :   std_logic_vector(23 downto 0) := (others => '0');
signal  OUT11_r                   :   std_logic_vector(23 downto 0) := (others => '0');
signal  OUT12_r                   :   std_logic_vector(23 downto 0) := (others => '0');
signal  OUT13_r                   :   std_logic_vector(23 downto 0) := (others => '0');
signal  OUT14_r                   :   std_logic_vector(23 downto 0) := (others => '0');
signal  OUT15_r                   :   std_logic_vector(23 downto 0) := (others => '0');
signal  OUT16_r                   :   std_logic_vector(23 downto 0) := (others => '0');
signal  OUT17_r                   :   std_logic_vector(23 downto 0) := (others => '0');

begin


CLKDIV0 : Clk_Divider2 
generic map(SCLKDIV)
port map(Clk,SPI_CLk);


FSynch  <=  SmplClk;
SpiClk  <=  SPI_CLk;

process(reset,SPI_CLk)
begin

    if reset = '0' then
        ShiftGeg0   <= (others => '0');
        ShiftGeg1   <= (others => '0');
        N           <=  0;
        OUT00_r     <= (others => '0');
        OUT01_r     <= (others => '0');
        OUT02_r     <= (others => '0');
        OUT03_r     <= (others => '0');
        OUT04_r     <= (others => '0');
        OUT05_r     <= (others => '0');
        OUT06_r     <= (others => '0');
        OUT07_r     <= (others => '0');
        OUT10_r     <= (others => '0');
        OUT11_r     <= (others => '0');
        OUT12_r     <= (others => '0');
        OUT13_r     <= (others => '0');
        OUT14_r     <= (others => '0');
        OUT15_r     <= (others => '0');
        OUT16_r     <= (others => '0');
        OUT17_r     <= (others => '0');
        ShiftGeg20   <= (others => '0');
        ShiftGeg21   <= (others => '0');

    elsif SPI_CLk'event and SPI_CLk = '1' then
        if ((SmplClk_clkd = '1' and SmplClk_Reg = '0') or (N /= 0)) then
            ShiftGeg20((8*24)-1 downto 0) <= ShiftGeg20((8*24)-2 downto 0) & '0';
            ShiftGeg21((8*24)-1 downto 0) <= ShiftGeg21((8*24)-2 downto 0) & '0';
            ShiftGeg0((8*24)-1 downto 0)  <= ShiftGeg0((8*24)-2 downto 0) & ShiftGeg20((8*24)-1);
            ShiftGeg1((8*24)-1 downto 0)  <= ShiftGeg1((8*24)-2 downto 0) & ShiftGeg21((8*24)-1);
            if N = ((24*8)-1) then
                N   <=  0;
                OUT00_r     <= std_logic_vector(UNSIGNED(OUT00_r) + 1);
                OUT01_r     <= std_logic_vector(UNSIGNED(OUT01_r) + 2);
                OUT02_r     <= std_logic_vector(UNSIGNED(OUT02_r) + 3);
                OUT03_r     <= std_logic_vector(UNSIGNED(OUT03_r) + 4);
                OUT04_r     <= std_logic_vector(UNSIGNED(OUT04_r) + 5);
                OUT05_r     <= std_logic_vector(UNSIGNED(OUT05_r) + 6);
                OUT06_r     <= std_logic_vector(UNSIGNED(OUT06_r) + 7);
                OUT07_r     <= std_logic_vector(UNSIGNED(OUT07_r) + 8);
                OUT10_r     <= std_logic_vector(UNSIGNED(OUT10_r) + 9);
                OUT11_r     <= std_logic_vector(UNSIGNED(OUT11_r) + 10);
                OUT12_r     <= std_logic_vector(UNSIGNED(OUT12_r) + 11);
                OUT13_r     <= std_logic_vector(UNSIGNED(OUT13_r) + 12);
                OUT14_r     <= std_logic_vector(UNSIGNED(OUT14_r) + 13);
                OUT15_r     <= std_logic_vector(UNSIGNED(OUT15_r) + 14);
                OUT16_r     <= std_logic_vector(UNSIGNED(OUT16_r) + 15);
                OUT17_r     <= std_logic_vector(UNSIGNED(OUT17_r) + 16);
					 
						ShiftGeg20((24*1)-1 downto (24*(1-1)))    <=  OUT00_r;
						ShiftGeg20((24*2)-1 downto (24*(2-1)))    <=  OUT01_r;
						ShiftGeg20((24*3)-1 downto (24*(3-1)))    <=  OUT02_r;
						ShiftGeg20((24*4)-1 downto (24*(4-1)))    <=  OUT03_r;
						ShiftGeg20((24*5)-1 downto (24*(5-1)))    <=  OUT04_r;
						ShiftGeg20((24*6)-1 downto (24*(6-1)))    <=  OUT05_r;
						ShiftGeg20((24*7)-1 downto (24*(7-1)))    <=  OUT06_r;
						ShiftGeg20((24*8)-1 downto (24*(8-1)))    <=  OUT07_r;

						ShiftGeg21((24*1)-1 downto (24*(1-1)))    <=  OUT10_r;
						ShiftGeg21((24*2)-1 downto (24*(2-1)))    <=  OUT11_r;
						ShiftGeg21((24*3)-1 downto (24*(3-1)))    <=  OUT12_r;
						ShiftGeg21((24*4)-1 downto (24*(4-1)))    <=  OUT13_r;
						ShiftGeg21((24*5)-1 downto (24*(5-1)))    <=  OUT14_r;
						ShiftGeg21((24*6)-1 downto (24*(6-1)))    <=  OUT15_r;
						ShiftGeg21((24*7)-1 downto (24*(7-1)))    <=  OUT16_r;
						ShiftGeg21((24*8)-1 downto (24*(8-1)))    <=  OUT17_r;
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


process(clk,reset)
begin
    if reset = '0' then
            OUT00    <=  (others => '0');
            OUT01    <=  (others => '0');
            OUT02    <=  (others => '0');
            OUT03    <=  (others => '0');
            OUT04    <=  (others => '0');
            OUT05    <=  (others => '0');
            OUT06    <=  (others => '0');
            OUT07    <=  (others => '0');

            OUT10    <=  (others => '0');
            OUT11    <=  (others => '0');
            OUT12    <=  (others => '0');
            OUT13    <=  (others => '0');
            OUT14    <=  (others => '0');
            OUT15    <=  (others => '0');
            OUT16    <=  (others => '0');
            OUT17    <=  (others => '0');
    elsif clk'event and clk ='1' then 
        if N = 0 then
            OUT00    <=  ShiftGeg0((24*1)-1 downto (24*(1-1)));
            OUT01    <=  ShiftGeg0((24*2)-1 downto (24*(2-1)));
            OUT02    <=  ShiftGeg0((24*3)-1 downto (24*(3-1)));
            OUT03    <=  ShiftGeg0((24*4)-1 downto (24*(4-1)));
            OUT04    <=  ShiftGeg0((24*5)-1 downto (24*(5-1)));
            OUT05    <=  ShiftGeg0((24*6)-1 downto (24*(6-1)));
            OUT06    <=  ShiftGeg0((24*7)-1 downto (24*(7-1)));
            OUT07    <=  ShiftGeg0((24*8)-1 downto (24*(8-1)));

            OUT10    <=  ShiftGeg1((24*1)-1 downto (24*(1-1)));
            OUT11    <=  ShiftGeg1((24*2)-1 downto (24*(2-1)));
            OUT12    <=  ShiftGeg1((24*3)-1 downto (24*(3-1)));
            OUT13    <=  ShiftGeg1((24*4)-1 downto (24*(4-1)));
            OUT14    <=  ShiftGeg1((24*5)-1 downto (24*(5-1)));
            OUT15    <=  ShiftGeg1((24*6)-1 downto (24*(6-1)));
            OUT16    <=  ShiftGeg1((24*7)-1 downto (24*(7-1)));
            OUT17    <=  ShiftGeg1((24*8)-1 downto (24*(8-1)));

        end if;
    end if;
end process;

end ar_FAKE_DUAL_ADS1278_DRIVER;






























