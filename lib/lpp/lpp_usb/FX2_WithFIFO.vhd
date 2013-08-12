-- FX2_WithFIFO.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library lpp;
use lpp.lpp_usb.all;
use lpp.lpp_memory.all;
use lpp.iir_filter.all;
library techmap;
use techmap.gencomp.all;

entity FX2_WithFIFO is
generic(
    tech          :   integer := 0;
    Mem_use       :   integer := use_RAM;
    Enable_ReUse  :   std_logic := '0'
    );
port(
        clk         : in STD_LOGIC;
        if_clk      : out STD_LOGIC;
        reset       : in  std_logic;
        flagb       : in STD_LOGIC; 
        slwr        : out STD_LOGIC;
        slrd        : out std_logic;
        pktend      : out STD_LOGIC;
        sloe        : out STD_LOGIC;
        fdbusw      : out std_logic_vector (7 downto 0);
        fifoadr     : out std_logic_vector (1 downto 0);

        FULL        : out std_logic;
        wen         : in std_logic;
        Data        : in std_logic_vector(7 downto 0)
    ); 
end FX2_WithFIFO;


architecture Ar_FX2_WithFIFO of FX2_WithFIFO is

type FX2State is (idle);

Signal  USB_DATA  :   std_logic_vector(7 downto 0);
Signal  FIFOfull      :   std_logic; 
Signal  USBwe,USBfull     :   std_logic; 

begin

FULL    <=  FIFOfull;

--FIFO:  lpp_fifo
FIFO: FIFO_pipeline
generic map(
    tech          => tech,
    Mem_use       => Mem_use,
    DataSz        =>  8,
    abits         =>  12
    )
port map(
    rstn    =>   reset,
    ReUse   =>   '0',
    rclk    =>   clk,
    ren     =>   USBfull,
    rdata   =>   USB_DATA, 
    empty   =>   USBwe,
    raddr   =>   open,
    wclk    =>   clk,
    wen     =>   wen,
    wdata   =>   Data,
    full    =>   FIFOfull,
    waddr   =>   open
);

USB2: entity FX2_Driver
port map(
        clk         => clk,
        if_clk      => if_clk,
        reset       => reset,
        flagb       => flagb,
        slwr        => slwr,
        slrd        => slrd,
        pktend      => pktend,
        sloe        => sloe,
        fdbusw      => fdbusw,
        fifoadr     => fifoadr,
        FULL        => USBfull,
        Write       => not USBwe,
        Data        => USB_DATA

    );

end ar_FX2_WithFIFO; 


