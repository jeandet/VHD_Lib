-- TOP_Serial_Driver_Wcounter.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity TOP_Serial_Driver_Wcounter is 
Generic(WordSize : integer := 8; WordCnt    :   integer := 144;MinFCount   :   integer := 64);
port(
    clk     :   in  std_logic;
    sclk    :   in  std_logic;
    Gate    :   in  std_logic;
    MinF    :   in  std_logic;
    MajF    :   in  std_logic;
    Data    :   out std_logic
);
end entity;




architecture ar_TOP_Serial_Driver_Wcounter of TOP_Serial_Driver_Wcounter is


Constant FramePlacerCount    :   integer := 2;

signal  MinF_Inv    :   std_logic;
signal  Gate_Inv    :   std_logic;
signal  sclk_Inv    :   std_logic;
signal  WordCount   :   integer range 0 to WordCnt-1;
signal  WordClk     :   std_logic;

signal  MuxOUT      :   std_logic_vector(WordSize-1 downto 0);
signal  MuxIN       :   std_logic_vector((2*WordSize)-1 downto 0);
signal  Sel         :   integer range 0 to 1;

signal  DC1     :     std_logic_vector(23 downto 0);
signal  DC2     :     std_logic_vector(23 downto 0);
signal  DC3     :     std_logic_vector(23 downto 0);



signal  LF1     :     std_logic_vector(15 downto 0);
signal  LF2     :     std_logic_vector(15 downto 0);
signal  LF3     :     std_logic_vector(15 downto 0);

constant DC1cst :   std_logic_vector(23 downto 0) := X"FA5961";
constant DC2cst :   std_logic_vector(23 downto 0) := X"123456";
constant DC3cst :   std_logic_vector(23 downto 0) := X"789012";

constant LF1cst :   std_logic_vector(15 downto 0) := X"3210";
constant LF2cst :   std_logic_vector(15 downto 0) := X"6543";
constant LF3cst :   std_logic_vector(15 downto 0) := X"3456";


signal  MinFCnt   :   integer range 0 to MinFCount-1;

signal  FramePlacerFlags    :   std_logic_vector(FramePlacerCount-1 downto 0);

begin

Gate_Inv    <=  not Gate;
sclk_Inv    <=  not Sclk;
MinF_Inv    <=  not MinF;

DC1 <=  DC1cst;
DC2 <=  DC2cst;
DC3 <=  DC3cst;

LF1 <=  LF1cst;
LF2 <=  LF2cst;
LF3 <=  LF3cst;

SD0 : entity work.Serial_Driver 
generic map(WordSize)
port map(sclk_Inv,MuxOUT,Gate_inv,Data);

WC0 :   entity work.Word_Cntr
generic map(WordSize,WordCnt)
port map(sclk_Inv,MinF,WordClk,WordCount);

MFC0 : entity work.MinF_Cntr
generic map(MinFCount)
port map(
    clk     =>  MinF_Inv,
    reset   =>  MajF,
    Cnt_out =>  MinFCnt
);


MUX0 : entity work.Serial_Driver_Multiplexor
generic map(FramePlacerCount,WordSize)
port map(sclk_Inv,Sel,MuxIN,MuxOUT);


DCFP0 : entity work.DC_FRAME_PLACER 
generic map(WordSize,WordCnt,MinFCount)
port map(
    clk     =>  Sclk,
    Wcount  =>  WordCount,
    MinFCnt =>  MinFCnt,
    Flag    =>  FramePlacerFlags(0),
    DC1     =>  DC1,
    DC2     =>  DC2,
    DC3     =>  DC3,
    WordOut =>  MuxIN(7 downto 0));



LFP0 : entity  work.LF_FRAME_PLACER
generic map(WordSize,WordCnt,MinFCount)
port map(
    clk     =>  Sclk,
    Wcount  =>  WordCount,
    Flag    =>  FramePlacerFlags(1),
    LF1     =>  LF1,
    LF2     =>  LF2,
    LF3     =>  LF3,
    WordOut =>  MuxIN(15 downto 8));

-- FramePlacerFlags(1) <= '0';
-- MuxIN(15 downto 8)  <= (others =>'0');

--Input Word Selection Decoder

process(clk)
variable SelVar :   integer range 0 to 1;
begin
    if clk'event and clk ='1' then
        Decoder: FOR i IN 0 to FramePlacerCount-1 loop
            if FramePlacerFlags(i) = '1' then
                SelVar := i;
            end if;
        END loop Decoder;
        Sel <=  SelVar;
    end if;
end process;


end ar_TOP_Serial_Driver_Wcounter;





































