library ieee;
use ieee.std_logic_1164.all;
USE IEEE.NUMERIC_STD.ALL;


entity LFR_paterns_serializer is
generic(
    width : integer := 18;
    div_factor : std_logic_vector(23 downto 0) := X"0000FF"
);
port(
    rstn       : in std_logic;
    clk        : in std_logic;
    latch      : in std_logic;
    datain     : in  std_logic_vector(width-1 downto 0);
    serial_out : out std_logic
);
end entity;

architecture beh of LFR_paterns_serializer is

signal sec_shift_reg : std_logic_vector(width+1 downto 0);
signal sec_freq_div_ctr : std_logic_vector(23 downto 0);

begin


serial_out <= sec_shift_reg(0);

process(rstn, clk)
begin
    if rstn = '0' then
        sec_freq_div_ctr <= (others => '0');
        sec_shift_reg <= (others => '0');
    elsif clk'event and clk = '1' then
        if latch = '1' then
            sec_shift_reg    <= datain & "01";
            sec_freq_div_ctr <= (others => '0');
        else
            if sec_freq_div_ctr = div_factor then
                sec_freq_div_ctr <= (others => '0');
                sec_shift_reg <= '0' & sec_shift_reg(19 DOWNTO 1);
            else
                sec_freq_div_ctr <= std_logic_vector(UNSIGNED(sec_freq_div_ctr) + 1);
            end if;
        end if;
    end if;
end process;


end architecture;
