-- TOP_GSE.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library lpp;
use lpp.lpp_usb.all;
use lpp.Rocket_PCM_Encoder.all;
use lpp.iir_filter.all;
use lpp.general_purpose.all;
library techmap;
use techmap.gencomp.all;
use work.config.all;


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
    fifoadr      : out std_logic_vector (1 downto 0);
    BUS0         : out std_logic;
    BUS12        : out std_logic;
    BUS13        : out std_logic;
    BUS14        : out std_logic
);
end TOP_EGSE2;



architecture ar_TOP_EGSE2 of TOP_EGSE2 is

  component CLKINT
    port( A : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

signal  clk         :   std_logic;
signal  clk_48      :   std_logic;
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
signal  GateR       :   std_logic;
signal  Gateint     :   std_logic;
signal  NwDat       :   std_logic;
signal  NwDatR      :   std_logic;
signal  DATA        :   std_logic_vector(WordSize-1 downto 0);
signal  MinFVector  :   std_logic_vector(WordSize-1 downto 0);

Signal  PROTO_WEN          :   std_logic;
Signal  PROTO_DATAIN       :   std_logic_vector (WordSize-1 downto 0);
Signal  PROTO_FULL         :   std_logic;
Signal  PROTO_WR           :   std_logic;
Signal  PROTO_DATAOUT      :   std_logic_vector (WordSize-1 downto 0);

Signal  clk80       :   std_logic;

signal cgi                : clkgen_in_type;
signal cgo                : clkgen_out_type;


begin


DataRTX_echo    <= DataRTX; --P48


ck_int0 :  CLKINT
        port map(Clock,clk_48);

RaZ <= cgo.clklock;

CLKGEN : entity clkgen 
  generic map(
    tech      => CFG_CLKTECH,
    clk_mul   => CFG_CLKMUL,
    clk_div   => CFG_CLKDIV,
    freq      => BOARDFREQ,	-- clock frequency in KHz
    clk_odiv  => CFG_OCLKDIV,            -- Proasic3/Fusion output divider clkA
    clkb_odiv => CFG_OCLKDIV,            -- Proasic3/Fusion output divider clkB
    clkc_odiv => CFG_OCLKDIV)           -- Proasic3/Fusion output divider clkC
  port map(
    clkin   => clk_48,
    pciclkin => '0',
    clk      => clk,			-- main clock
    clkn     => open,			-- inverted main clock
    clk2x    => open,			-- 2x clock
    sdclk    => open,			-- SDRAM clock
    pciclk   => open,			-- PCI clock
    cgi      => cgi,
    cgo      => cgo,
    clk4x    => open,			-- 4x clock
    clk1xu   => open,			-- unscaled 1X clock
    clk2xu   => open,			-- unscaled 2X clock
    clkb     => clk80,           -- Proasic3/Fusion clkB
    clkc     => open);           -- Proasic3/Fusion clkC



    gene3_3M : entity Clk_Divider2 
    generic map(N => 10)
    port map(
        clk_in  => clk,
        clk_out => sclkint
    );

    Wcounter : entity Word_Cntr
        generic map(WordSize  => WordSize ,N  => WordCnt)
        port map(
            Sclk    => Sclkint,
            reset   => rstn,
            WordClk => WordClk,
            Cnt_out => WordCount
        );

    MFGEN0 : entity work.MinF_Gen  
        generic map(WordCnt => WordCnt)
        port map(
            clk         => Sclkint,
            reset       => rstn,
            WordCnt_in  => WordCount,
            WordClk     => WordClk,
            MinF_Clk    => MinF
        );

    MinFcounter : entity Word_Cntr
        generic map(WordSize  => WordCnt ,N  => MinFCount)
        port map(
            Sclk    => WordClk,
            reset   => rstn,
            WordClk => MinFclk,
            Cnt_out => MinFCnt
        );

    MFGEN1 : entity work.MajF_Gen  
        generic map(WordCnt => WordCnt,MinFCount => MinFCount)
        port map(
            clk         => Sclkint,
            reset       => rstn,
            WordCnt_in  => WordCount,
            MinfCnt_in  => MinFCnt,
            WordClk     => WordClk,
            MajF_Clk    => MajF
        );

    LFGATEGEN0 : entity work.LF_GATE_GEN
        generic map(WordCnt  => WordCnt)
        port map(
            clk     => Sclkint,
            Wcount  => WordCount,
            Gate    => GateLF
        );

    DCGATEGEN0 : entity work.DC_GATE_GEN
        generic map(WordCnt  => WordCnt)
        port map(
            clk     => Sclkint,
            Wcount  => WordCount,
            Gate    => GateDC
        );

--GateDC  <= '0';
--GateLF  <= '0';

HFGATEGEN0 :
        GateHF <= '1' when WordCount = 120 else 
                  '1' when WordCount = 121 else '0';



SD0 : entity Serial_driver2 
generic map(Sz  => WordSize)
port map(
    Sclk    =>  Sclkint,
    rstn    =>  rstn,
    Sdata   =>  DataRTX,
    Gate    =>  GateR,
    NwDat   =>  NwDat,
    Data    =>  DATA
);



proto: entity work.ICI_EGSE_PROTOCOL
generic map(WordSize  => WordSize,WordCnt  => WordCnt,MinFCount => MinFCount,Simu => 0)
port map(
    clk        => clk,
--    reset      => not MinF,
    reset      => rstn,
    WEN        => PROTO_WEN,
    MinfCnt_in => MinfCnt,
    WordCnt_in => WordCount,
    DATAIN     => PROTO_DATAIN,
    FULL       => PROTO_FULL,
    WR         => PROTO_WR,
    DATAOUT    => PROTO_DATAOUT
);



USB2: entity work.FX2_WithFIFO
generic map(CFG_MEMTECH,use_RAM,'0',15,11)
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
        FULL        => PROTO_FULL,
        wen         => PROTO_WR,
        Data        => PROTO_DATAOUT
);


rstn    <=  reset and RaZ;
SCLK    <=  Sclkint;

Major_Frame <=  MajF;
Minor_Frame <=  MinF;
--Minor_Frame <=  MinFclk;
gateint <=  GateDC or GateLF or GateHF;
Gate    <=  gateint;

process(Sclkint,rstn)
begin
    if rstn = '0' then 
        GateR <=    '0';
    elsif Sclkint'event and Sclkint = '0' then
        GateR   <=   Gateint;
    end if;
end process;

BUS0  <= WordClk;
BUS12 <= MinFVector(0);
--BUS13 <= MinFclk;
--BUS14 <= '1' when WordCount = 0 else '0';
BUS13 <= MinF;
BUS14 <= MajF;


MinFVector    <= std_logic_vector(TO_UNSIGNED(MinfCnt,WordSize));


process(clk,rstn)
begin
    if rstn = '0' then
        PROTO_DATAIN    <= (others => '0');
        PROTO_WEN       <= '1';
    elsif clk'event and clk = '1' then
        NwDatR   <= NwDat;
        if NwDat = '1' and NwDatR = '0'  then
--            PROTO_DATAIN  <=  std_logic_vector(unsigned(PROTO_DATAIN) + 1 );
              PROTO_DATAIN  <=  DATA;
              PROTO_WEN       <= '0';
        else
            PROTO_WEN       <= '1';
        end if;
    end if;
end process;

end ar_TOP_EGSE2;




