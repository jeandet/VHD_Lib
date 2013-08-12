-- ICI_EGSE_PROTOCOL.vhd
-- ICI_EGSE_PROTOCOL.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ICI_EGSE_PROTOCOL2 is
generic(WordSize : integer := 8;Simu : integer :=0);
port(
    clk          : in  std_logic;
    reset        : in  std_logic;
    WEN          : in  std_logic;
    MinF         : in  std_logic;
    DATAIN       : in  std_logic_vector (WordSize-1 downto 0);
    FULL         : in  std_logic;
    WR           : out std_logic;
    DATAOUT      : out std_logic_vector (WordSize-1 downto 0)
);
end ICI_EGSE_PROTOCOL2;


architecture ar_ICI_EGSE_PROTOCOL2 of ICI_EGSE_PROTOCOL2 is

type   state_t is (idle,forward,header1,header2,header3,header4);
signal MinFReg      : std_logic;
signal state        : state_t;

begin

process(reset,clk)
begin
    if reset = '0' then
        MinFReg         <= '1';
        state   <=  idle;
        DATAOUT <=  X"00";
        WR      <=  '1';
    elsif clk'event and clk ='1' then
        MinFReg         <= MinF;
        case state is
            when idle =>
                DATAOUT <=  X"00";
                WR      <=  '1';
                state   <= forward;
            when forward =>
                DATAOUT <=  DATAIN;
                WR      <=  WEN;
                if MinFReg = '0' and MinF = '1' then
                    state   <= header1;
                end if;
            when header1 =>
                if FULL = '0' then
                    WR       <= '0';
                    DATAOUT  <= X"5a";
                    state    <= header2;
                else
                    WR  <= '1';
                end if;
            when header2 =>
                if FULL = '0' then
                    WR       <= '0';
                    DATAOUT  <= X"F0";
                    state    <= header3;
                else
                    WR  <= '1';
                end if;
            when header3 =>
                if FULL = '0' then
                    WR       <= '0';
                    DATAOUT  <= X"0F";
                    state    <= header4;
                else
                    WR  <= '1';
                end if;
            when header4 =>
                if FULL = '0' then
                    WR       <= '0';
                    DATAOUT  <= X"a5";
                    state    <= forward;
                else
                    WR  <= '1';
                end if;
        end case;
    end if;
end process;


end ar_ICI_EGSE_PROTOCOL2;