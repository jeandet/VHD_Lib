library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;
library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;
library LPP;
use LPP.lpp_dma_pkg.lpp_dma_SEND16B_FIFO2DMA;

entity ADC_DMA_CTRL is
GENERIC (
    );
  PORT (
    clk  : IN STD_LOGIC;
    rstn : IN STD_LOGIC;

    CFG_DMA_enable  : in  std_logic
    CFG_DMA_Address : in  std_logic_vector(31 downto 0);
    CFG_DMA_Size    : in  std_logic_vector(31 downto 0);

    DMA_done         : in  std_logic;
    DMA_send         : in  std_logic;
    DMA_burst        : out STD_LOGIC;
    DMA_address      : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);

    ADC_enable       : in std_logic;
    ADC_data         : in std_logic_vector(31 downto 0);
    ADC_sample_ready : in std_logic
    );
end entity;

architecture behave of ADC_DMA_CTRL is

-- DMA Module

    -- FIFO Interface
    signal DMA_ren  :  STD_LOGIC := '0';
    signal DMA_data :  STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');

    -- Controls
    signal BURST_send        : STD_LOGIC := '0';
    signal DMA_valid_burst : STD_LOGIC := '0';        -- (1 => BURST , 0 => SINGLE)
    signal BURST_done        : STD_LOGIC := '0';
    signal BURST_address     : STD_LOGIC_VECTOR(31 DOWNTO 0):= (others => '0');

    type fifo_bank is array(0 to 15) of std_logic_vector(31 downto 0);
    type ping_pong_fifo is array(0 to 1) of fifo_bank;

    signal fifo : ping_pong_fifo;
    signal fifo_index : std_logic_vector(0 downto 0);
    signal fifo_wr_index : integer range 0 to 15;
    signal fifo_rd_index : integer range 0 to 15;

    signal rd_fifo_empty : std_logic := '1';


    signal DMA_done : std_logic;
    signal DMA_address     : STD_LOGIC_VECTOR(31 DOWNTO 0):= (others => '0');
    signal Sent_counter    : STD_LOGIC_VECTOR(31 DOWNTO 0):= (others => '0');

begin




DMA_data  <= fifo(TO_INTEGER(unsigned(not fifo_index)))(fifo_rd_index);

process(rstn, clk)
begin
    if rstn = '0' then
        fifo_wr_index <= 0;
        fifo_rd_index <= 0;
        fifo_index <= "0";
        BURST_send <= '0';
    elsif clk'event and clk = '1'then
        BURST_send <= '0';
        if wen = '0' and Rec.CTRL(0) = '1' then
            fifo(TO_INTEGER(unsigned(fifo_index)))(fifo_wr_index) <= data_in;
            fifo_wr_index <= fifo_wr_index + 1;
            if fifo_wr_index = 15 then
                fifo_wr_index <= 0;
                fifo_index <= not fifo_index;
                rd_fifo_empty <= '0';
            end if;
        end if;
        if rd_fifo_empty = '0'and Rec.CTRL(0) = '1' then
            BURST_send <= '1';
            if DMA_ren = '0' then
                fifo_rd_index <= fifo_rd_index + 1;
                Sent_counter <= std_logic_vector(unsigned(Sent_counter) + 1);
                if (Sent_counter = Rec.Size) then
                    DMA_done <= '1';
                    Sent_counter <= (others => '0');
                end if;
                if fifo_rd_index = 15 then
                    fifo_rd_index <= 0;
                    rd_fifo_empty <= '1';
                    BURST_send <= '0';
                end if;
            end if;
        end if;
    end if;
end process;

end architecture;