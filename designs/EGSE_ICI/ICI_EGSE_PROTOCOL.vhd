-- ICI_EGSE_PROTOCOL.vhd
-- ICI_EGSE_PROTOCOL.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ICI_EGSE_PROTOCOL is 
generic(WordSize : integer := 8;WordCnt : integer :=144;MinFCount   :   integer := 64;Simu : integer :=0);
port(
    clk          : in  std_logic;
    reset        : in  std_logic;
    WEN          : in  std_logic;
    WordCnt_in   : in  integer range 0 to WordCnt-1;
    MinfCnt_in   : in  integer range 0 to MinFCount-1;
    DATAIN       : in  std_logic_vector (WordSize-1 downto 0);
    FULL         : in  std_logic;
    WR           : out std_logic;
    DATAOUT      : out std_logic_vector (WordSize-1 downto 0)
);
end ICI_EGSE_PROTOCOL;


architecture ar_ICI_EGSE_PROTOCOL of ICI_EGSE_PROTOCOL is

type   DATA_pipe_t is  array(NATURAL RANGE <>) of  std_logic_vector (WordSize-1 downto 0);

signal DATA_pipe    : DATA_pipe_t(10 downto 0);
signal WR_pipe      : std_logic_vector(10 downto 0);
signal headerSended : std_logic := '0';


begin

WR          <= WR_pipe(0);

DATAOUT     <= DATA_pipe(0);


process(reset,clk)
begin
    if reset = '0' then
        WR_pipe(10 downto 0)         <= (others => '1');
rstloop: for i in 0 to 10 loop
            DATA_pipe(i)    <= X"00";
        end loop;
        headerSended    <=  '0';
    elsif clk'event and clk ='1' then
        if WordCnt_in = 1 and headerSended = '0' then
            WR_pipe(4 downto 1)         <= (others => '0');
            WR_pipe(1)      <=  '0';
            WR_pipe(3)      <=  '0';
            WR_pipe(5)      <=  '0';
            WR_pipe(7)      <=  '0';
            WR_pipe(9)      <=  '0';
            DATA_pipe(1)    <= X"0F";
            DATA_pipe(3)    <= X"5a";
            DATA_pipe(5)    <= X"a5";
            DATA_pipe(7)    <= X"F0";           
            DATA_pipe(9)    <= std_logic_vector(TO_UNSIGNED(MinfCnt_in,WordSize));
            WR_pipe(0)      <=  '1';
            WR_pipe(2)      <=  '1';
            WR_pipe(4)      <=  '1';
            WR_pipe(6)      <=  '1';
            WR_pipe(8)      <=  '1';
            WR_pipe(10)     <=  '1';
            DATA_pipe(0)    <= X"00";
            DATA_pipe(2)    <= X"00";
            DATA_pipe(4)    <= X"00";
            DATA_pipe(6)    <= X"00";
            DATA_pipe(10)   <= X"00";
            headerSended    <= '1';
        elsif (FULL = '0') then
            if WordCnt_in /= 1 then
                headerSended    <= '0';
            end if;
            DATA_pipe(0)    <= DATA_pipe(1);
            DATA_pipe(1)    <= DATA_pipe(2);
            DATA_pipe(2)    <= DATA_pipe(3);
            DATA_pipe(3)    <= DATA_pipe(4);
            DATA_pipe(4)    <= DATA_pipe(5);
            DATA_pipe(5)    <= DATA_pipe(6);
            DATA_pipe(6)    <= DATA_pipe(7);
            DATA_pipe(7)    <= DATA_pipe(8);
            DATA_pipe(8)    <= DATA_pipe(9);
            DATA_pipe(9)    <= DATA_pipe(10);
            DATA_pipe(10)   <= DATAIN;
            WR_pipe(10 downto 0)         <=  WEN & WR_pipe(10 downto 1);
        else
            WR_pipe(0)      <= '1';
            if WordCnt_in /= 1 then
                headerSended    <= '0';
            end if;
        end if;
    end if;
end process;


end ar_ICI_EGSE_PROTOCOL;