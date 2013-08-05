-- TOP_GSE.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library lpp;
use lpp.lpp_usb.all;
library techmap;
use techmap.gencomp.all;

entity TOP_EGSE2 is 
generic(WordSize : integer := 8; WordCnt    :   integer := 144;MinFCount   :   integer := 64;Simu : integer :=0);
port(
    Clock        : in  std_logic;
    reset        : in  std_logic;
    DataRTX      : in  std_logic;
    DataRTX_echo : out std_logic;
    SCLK         : out std_logic;
    Gate         : out std_logic;
    Major_Frame  : out std_logic;
    Minor_Frame  : out std_logic;
    if_clk       : out STD_LOGIC;
    flagb        : in  STD_LOGIC; 
    slwr         : out STD_LOGIC;
    slrd         : out std_logic;
    pktend       : out STD_LOGIC;
    sloe         : out STD_LOGIC;
    fdbusw       : out std_logic_vector (7 downto 0);
    fifoadr      : out std_logic_vector (1 downto 0)
);
end TOP_EGSE2;



architecture ar_TOP_EGSE2 of TOP_EGSE2 is

  component CLKINT
    port( A : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

signal  clk         :   std_logic;
signal  sclkint     :   std_logic;
signal  RaZ         :   std_logic;
signal  rstn        :   std_logic;
signal  WordCount   :   integer range 0 to WordCnt-1;
signal  WordClk     :   std_logic;
signal  MinFCnt     :   integer range 0 to MinFCount-1;
signal  MinF        :   std_logic;
signal  MinFclk     :   std_logic;
signal  MajF        :   std_logic;
signal  GateLF      :   std_logic;
signal  GateHF      :   std_logic;
signal  GateDC      :   std_logic;
signal  Gateint     :   std_logic;
signal  GateR       :   std_logic;
signal  NwDat       :   std_logic;
signal  DATA        :   std_logic_vector(WordSize-1 downto 0);

Signal  FIFODATin   :   std_logic_vector(7 downto 0);
Signal  FIFODATout  :   std_logic_vector(7 downto 0);

Signal  USB_DATA  :   std_logic_vector(7 downto 0);
Signal  FIFOwe,FIFOre,FIFOfull      :   std_logic; 
Signal  USBwe,USBfull,USBempty      :   std_logic; 

Signal  clk80       :   std_logic;



begin


DataRTX_echo    <= DataRTX; --P48

    ck_int0 :  CLKINT
        port map(Clock,clk);

DEFPLL: IF simu = 0 generate
    PLL : entity work.PLL0
        port map(
            POWERDOWN => '1',
            CLKA => clk,
            LOCK => RaZ,
            GLA  => SCLKint,
            GLB  => clk80
        );
end generate;


SIMPLL: IF simu = 1 generate
    PLL : entity work.PLL0Sim
        port map(
            POWERDOWN => '1',
            CLKA => clk,
            LOCK => RaZ,
            GLA  => SCLKint,
            GLB  => clk80
        );
end generate;


USB2: entity work.FX2_WithFIFO
generic map(apa3)
port map(
        clk         => clk,
        if_clk      => if_clk,
        reset       => rstn,
        flagb       => flagb,
        slwr        => slwr,
        slrd        => slrd,
        pktend      => pktend,
        sloe        => sloe,
        fdbusw      => fdbusw,
        fifoadr     => fifoadr,
        FULL        => USBfull,
        Write       => USBwe,
        Data        => USB_DATA

    );


rstn    <=  reset and RaZ;

process(clk,rstn)
begin
    if rstn = '0' then  
        USB_DATA    <= (others => '0');
        USBwe       <= '0';
    elsif clk'event and clk = '1' then
        if USBfull = '0' then
            USB_DATA    <=  std_logic_vector(unsigned(USB_DATA) + 1 );
            USBwe       <= '1';
        else
            USBwe       <= '0';
        end if;
    end if;
end process;

end ar_TOP_EGSE2;


















