library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;
library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;
library LPP;
use LPP.lpp_dma_pkg.lpp_dma_SEND16B_FIFO2DMA;

entity ADC_DMA is
GENERIC (
    hindex   : INTEGER := 2;
    pindex   : INTEGER := 2;
    paddr    : INTEGER := 4;
    pmask    : INTEGER := 16#fff#;
    pirq     : INTEGER := 0;
    vendorid : INTEGER := 100;
    deviceid : INTEGER := 10;
    version  : INTEGER := 0
    );
  PORT (
    clk  : IN STD_LOGIC;
    rstn : IN STD_LOGIC;

    -- AMBA AHB Master Interface
    AHB_Master_In  : IN  AHB_Mst_In_Type;
    AHB_Master_Out : OUT AHB_Mst_Out_Type;

    -- AMBA APB Slave Interface
    apbi : IN  apb_slv_in_type;
    apbo : OUT apb_slv_out_type;

    ADC_enable   : in std_logic;
    ADC_data     : in std_logic_vector(31 downto 0);
    sample_ready : in std_logic
    );
end entity;

architecture behave of ADC_DMA is
-- DMA Module

    -- FIFO Interface
    signal DMA_ren  :  STD_LOGIC := '0';
    signal DMA_data :  STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');

    -- Controls
    signal BURST_send        : STD_LOGIC := '0';
    signal DMA_valid_burst : STD_LOGIC := '0';        -- (1 => BURST , 0 => SINGLE)
    signal BURST_done        : STD_LOGIC := '0';
    signal BURST_address     : STD_LOGIC_VECTOR(31 DOWNTO 0):= (others => '0');

    signal CFG_DMA_enable  : std_logic;
    signal CFG_DMA_Address : std_logic_vector(31 downto 0);
    signal CFG_DMA_Size    : std_logic_vector(31 downto 0);

    signal DMA_done        : std_logic;

begin

dma0: lpp_dma_SEND16B_FIFO2DMA
    generic map(hindex => hindex,
        vendorid => vendorid,
        deviceid => deviceid,
        version  => version
    )
    port map(
        clk => clk,
        rstn => rstn,
        AHB_Master_In  => AHB_Master_In,
        AHB_Master_Out => AHB_Master_Out,

        ren          => DMA_ren,
        data         => DMA_data,

        send         => BURST_send,
        valid_burst  => DMA_valid_burst,
        done         => BURST_done,
        address      => BURST_address
    );


apb_regs : entity work.adc_dma_apbregs
    generic map(
        pindex   => pindex,
        paddr    => paddr,
        pmask    => pmask,
        pirq     => pirq,
        vendorid => vendorid,
        deviceid => deviceid,
        version  => version
    )
    port map(
        clk => clk,
        rstn => rstn,

        apbi => apbi,
        apbo => apbo,

        DMA_enable  => CFG_DMA_enable,
        DMA_Address => CFG_DMA_Address,
        DMA_Size    => CFG_DMA_Size,

        DMA_done    => DMA_done
    );

end architecture;