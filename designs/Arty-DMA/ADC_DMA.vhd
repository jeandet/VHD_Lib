------------------------------------------------------------------------------
--  This file is a part of the LPP VHDL IP LIBRARY
--  Copyright (C) 2009 - 2018, Laboratory of Plasmas Physic - CNRS
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 3 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
------------------------------------------------------------------------------
--                    Author : Alexis Jeandet
--                     Mail : alexis.jeandet@member.fsf.org
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;
library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;
library LPP;
USE lpp.iir_filter.ALL;
use LPP.lpp_dma_pkg.ALL;
USE lpp.lpp_memory.ALL;

entity ADC_DMA is
GENERIC (
    memtech  : integer := 0;
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

    ADC_enable   : out std_logic;
    ADC_data     : in std_logic_vector(31 downto 0);
    ADC_sample_ready : in std_logic
    );
end entity;

architecture behave of ADC_DMA is

  CONSTANT EMPTY_THRESHOLD_LIMIT : INTEGER               := 16;
  CONSTANT FULL_THRESHOLD_LIMIT  : INTEGER               := 5;
  CONSTANT DataSz                : INTEGER RANGE 1 TO 32 := 32;
  CONSTANT AddrSz                : INTEGER RANGE 2 TO 12 := 8;

-- DMA Module

    -- FIFO Interface
    signal BURST_ren  :  STD_LOGIC := '0';
    signal BURST_data :  STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');

    -- Controls
    signal BURST_send        : STD_LOGIC := '0';
    signal BURST_valid_burst : STD_LOGIC := '0';        -- (1 => BURST , 0 => SINGLE)
    signal BURST_done        : STD_LOGIC := '0';
    signal BURST_address     : STD_LOGIC_VECTOR(31 DOWNTO 0):= (others => '0');

    signal CFG_DMA_start   : std_logic;
    signal CFG_DMA_Address : std_logic_vector(31 downto 0);
    signal CFG_DMA_Size    : std_logic_vector(31 downto 0);

    signal CTRL_done       : std_logic;

    SIGNAL FIFO_ren   : STD_LOGIC := '1';
    SIGNAL FIFO_rdata : STD_LOGIC_VECTOR(DataSz-1 DOWNTO 0);

    --OUT
    SIGNAL  FIFO_wen   : STD_LOGIC := '1';
    SIGNAL  FIFO_wdata : STD_LOGIC_VECTOR(DataSz-1 DOWNTO 0) := (others => '1');

    SIGNAL  FIFO_empty           : STD_LOGIC;
    SIGNAL  FIFO_full            : STD_LOGIC;
    SIGNAL  FIFO_full_almost     : STD_LOGIC;
    SIGNAL  FIFO_empty_threshold : STD_LOGIC;
    SIGNAL  FIFO_full_threshold  : STD_LOGIC;
    SIGNAL  FIFO_run             : STD_LOGIC;



  -- Controls
  signal DMA_done        : STD_LOGIC := '0';

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

        ren          => BURST_ren,
        data         => BURST_data,

        send         => BURST_send,
        valid_burst  => BURST_valid_burst,
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

        DMA_start   => CFG_DMA_start,
        DMA_Address => CFG_DMA_Address,
        DMA_Size    => CFG_DMA_Size,

        DMA_done    => CTRL_done
    );

FIFO0: lpp_fifo
  GENERIC map(
    tech                  => memtech,
    mem_use               => use_RAM,
    EMPTY_THRESHOLD_LIMIT => EMPTY_THRESHOLD_LIMIT,
    FULL_THRESHOLD_LIMIT  => FULL_THRESHOLD_LIMIT,
    DataSz                => DataSz,
    AddrSz                => AddrSz
    )
  PORT MAP(
      clk              => clk,
      rstn             => rstn,
    --
    reUse => '0',
    run   => FIFO_run,

    --IN
    ren   => FIFO_ren,
    rdata => FIFO_rdata,
    --OUT
    wen   => FIFO_wen,
    wdata => FIFO_wdata,

    empty           => FIFO_empty,
    full            => FIFO_full,
    full_almost     => FIFO_full_almost,
    empty_threshold => FIFO_empty_threshold,
    full_threshold  => FIFO_full_threshold
    );


latency0: fifo_latency_correction
  PORT MAP(
    clk     => clk,
    rstn    => rstn,

    FIFO_empty           => FIFO_empty,
    FIFO_empty_threshold => FIFO_empty_threshold,
    FIFO_ren             => FIFO_ren,
    FIFO_rdata           => FIFO_rdata,

    DMA_ren              => BURST_ren,
    DMA_data             => BURST_data,

    DMA_send             => BURST_send,
    DMA_valid_burst      => BURST_valid_burst,
    DMA_done             => BURST_done
    );

CTRL0:   entity work.ADC_DMA_CTRL
  PORT MAP(
    clk    => clk,
    rstn   => rstn,
    done   => CTRL_done,

    CFG_DMA_start   => CFG_DMA_start,
    CFG_DMA_Address => CFG_DMA_Address,
    CFG_DMA_Size    => CFG_DMA_Size,

    DMA_done         => BURST_done,
    DMA_send         => BURST_send,
    DMA_burst        => BURST_valid_burst,
    DMA_address      => BURST_address,

    FIFO_RUN         => FIFO_run,
    FIFO_WEN         => FIFO_WEN,
    FIFO_FULL        => FIFO_FULL,
    FIFO_WDATA       => FIFO_WDATA,

    ADC_enable       => ADC_enable,
    ADC_data         => ADC_data,
    ADC_sample_ready => ADC_sample_ready
    );

end architecture;