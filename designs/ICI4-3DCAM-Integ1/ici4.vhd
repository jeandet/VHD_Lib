library ieee;
use ieee.std_logic_1164.all;
library grlib, techmap;
use techmap.gencomp.all;
use techmap.allclkgen.all;

-- pragma translate_off
use gaisler.sim.all;
library unisim;
use unisim.ODDR2;
-- pragma translate_on
library lpp;
use lpp.lpp_ad_conv.all;
use lpp.general_purpose.all;
use lpp.Rocket_PCM_Encoder.all;



use work.Convertisseur_config.all;


use work.config.all;

entity ici4 is
  generic (
    fabtech       : integer := CFG_FABTECH;
    memtech       : integer := CFG_MEMTECH;
    padtech       : integer := CFG_PADTECH;
    clktech       : integer := CFG_CLKTECH;
WordSize : integer := 8; WordCnt    :   integer := 144;MinFCount   :   integer := 64
  );
  port (
    reset       : in  std_ulogic;
    clk         : in  std_ulogic;
    sclk    :   in  std_logic;
    Gate    :   in  std_logic;
    MinF    :   in  std_logic;
    MajF    :   in  std_logic;
    Data    :   out std_logic
   );
end;

architecture rtl of ici4 is

signal  clk_buf,reset_buf   :   std_logic;

Constant FramePlacerCount    :   integer := 2;

signal  MinF_Inv    :   std_logic;
signal  Gate_Inv    :   std_logic;
signal  sclk_Inv    :   std_logic;
signal  WordCount   :   integer range 0 to WordCnt-1;
signal  WordClk     :   std_logic;

signal  data_int    :   std_logic;

signal  MuxOUT      :   std_logic_vector(WordSize-1 downto 0);
signal  MuxIN       :   std_logic_vector((FramePlacerCount*WordSize)-1 downto 0);
signal  Sel         :   integer range 0 to 1;


signal  WORD0     :     std_logic_vector(15 downto 0);
signal  WORD1     :     std_logic_vector(15 downto 0);
signal  WORD2     :     std_logic_vector(15 downto 0);
signal  WORD3     :     std_logic_vector(15 downto 0);
signal  WORD4     :     std_logic_vector(15 downto 0);
signal  WORD5     :     std_logic_vector(15 downto 0);
signal  WORD6     :     std_logic_vector(15 downto 0);
signal  WORD7     :     std_logic_vector(15 downto 0);
signal  WORD8     :     std_logic_vector(15 downto 0);
signal  WORD9     :     std_logic_vector(15 downto 0);
signal  WORD10    :     std_logic_vector(15 downto 0);
signal  WORD11    :     std_logic_vector(15 downto 0);
signal  WORD12    :     std_logic_vector(15 downto 0);


signal  LF1     :     std_logic_vector(15 downto 0);
signal  LF2     :     std_logic_vector(15 downto 0);
signal  LF3     :     std_logic_vector(15 downto 0);


signal  MinFCnt   :   integer range 0 to MinFCount-1;

signal  FramePlacerFlags    :   std_logic_vector(FramePlacerCount-1 downto 0);

begin


clk_buf   <= clk;
reset_buf <= reset;
--    

Gate_Inv    <=  not Gate;
sclk_Inv    <=  not Sclk;
MinF_Inv    <=  not MinF;

data        <= data_int;


SD0 : Serial_Driver 
generic map(WordSize)
port map(sclk_Inv,MuxOUT,Gate_inv,data_int);

WC0 : Word_Cntr
generic map(WordSize,WordCnt)
port map(sclk_Inv,MinF,WordClk,WordCount);

MFC0 : MinF_Cntr
generic map(MinFCount)
port map(
    clk     =>  MinF_Inv,
    reset   =>  MajF,
    Cnt_out =>  MinFCnt
);


MUX0 : Serial_Driver_Multiplexor
generic map(FramePlacerCount,WordSize)
port map(sclk_Inv,Sel,MuxIN,MuxOUT);

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


CAMFP0 : entity  work.ICI4_3DCAM_FRAM_PLACER
generic map(WordSize,WordCnt,MinFCount)
port map(
    clk     =>  Sclk,
    Wcount  =>  WordCount,
    Flag    =>  FramePlacerFlags(0),
    WORD0    =>  WORD0,
         WORD1    =>   WORD1,
         WORD2    =>   WORD2,
         WORD3    =>   WORD3,
         WORD4    =>   WORD4,
         WORD5    =>   WORD5,
         WORD6    =>   WORD6,
         WORD7    =>   WORD7,
         WORD8    =>   WORD8,
         WORD9    =>   WORD9,
         WORD10    =>  WORD10,
         WORD11    =>  WORD11,
         WORD12    =>  WORD12,
    WordOut =>  MuxIN(7 downto 0));


    WORD0  <= WORD0cst;
    WORD1  <= WORD1cst;
    WORD2  <= WORD2cst;
    WORD3  <= WORD3cst;
    WORD4  <= WORD4cst;
    WORD5  <= WORD5cst;
    WORD6  <= WORD6cst;
    WORD7  <= WORD7cst;
    WORD8  <= WORD8cst;
    WORD9  <= WORD9cst;
    WORD10 <= WORD10cst;
    WORD11 <= WORD11cst;
    WORD12 <= X"0" & "000" & std_logic_vector(TO_UNSIGNED(MinFCnt,9));
	 
	 
	LF1 <=  LF1cst;
	LF2 <=  LF2cst;
	LF3 <=  LF3cst;

process(clk)
variable SelVar :   integer range 0 to FramePlacerCount;
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


end rtl;


 
