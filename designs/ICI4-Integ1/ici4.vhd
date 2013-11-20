library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
library grlib, techmap;
use grlib.amba.all;
use grlib.amba.all;
use grlib.stdlib.all;
use techmap.gencomp.all;
use techmap.allclkgen.all;
library gaisler;
use gaisler.memctrl.all;
use gaisler.leon3.all;
use gaisler.uart.all;
use gaisler.misc.all;
--use gaisler.sim.all;
library lpp;
use lpp.lpp_ad_conv.all;
use lpp.lpp_amba.all;
use lpp.apb_devices_list.all;
use lpp.general_purpose.all;
use lpp.Rocket_PCM_Encoder.all;


use work.Convertisseur_config.all;


use work.config.all;
--==================================================================
--
--
--			FPGA FREQ = 48MHz
--			ADC Oscillator frequency = 12MHz
--
--
--==================================================================

entity ici4 is
  generic (
    fabtech       : integer := CFG_FABTECH;
    memtech       : integer := CFG_MEMTECH;
    padtech       : integer := CFG_PADTECH;
    clktech       : integer := CFG_CLKTECH;
WordSize : integer := 8; WordCnt    :   integer := 144;MinFCount   :   integer := 64
  );
  port (
    reset         : in  std_ulogic;
    clk           : in  std_ulogic;
    sclk          : in  std_logic;
    Gate          : in  std_logic;
    MinF          : in  std_logic;
    MajF          : in  std_logic;
    Data          : out std_logic;
	 LF_SCK	      : out std_logic;
    LF_CNV	      : out std_logic;
    LF_SDO1	      : in  std_logic;
	 LF_SDO2	      : in  std_logic;
	 LF_SDO3	      : in  std_logic;
    DC_ADC_Sclk   : out std_logic;
    DC_ADC_IN     : in  std_logic_vector(1 downto 0);
    DC_ADC_ClkDiv : out std_logic;
    DC_ADC_FSynch : out std_logic;
	 SET_RESET0    : out std_logic;
	 SET_RESET1    : out std_logic;
	 LED           : out std_logic
   );
end;

architecture rtl of ici4 is

signal  clk_buf,reset_buf   :   std_logic;

Constant FramePlacerCount    :   integer := 2;


signal  WordCount   :   integer range 0 to WordCnt-1;
signal  WordClk     :   std_logic;


signal  AMR1X   :     std_logic_vector(23 downto 0);
signal  AMR1Y   :     std_logic_vector(23 downto 0);
signal  AMR1Z   :     std_logic_vector(23 downto 0);

signal  AMR2X   :     std_logic_vector(23 downto 0);
signal  AMR2Y   :     std_logic_vector(23 downto 0);
signal  AMR2Z   :     std_logic_vector(23 downto 0);

signal  AMR3X   :     std_logic_vector(23 downto 0);
signal  AMR3Y   :     std_logic_vector(23 downto 0);
signal  AMR3Z   :     std_logic_vector(23 downto 0);

signal  AMR4X   :     std_logic_vector(23 downto 0);
signal  AMR4Y   :     std_logic_vector(23 downto 0);
signal  AMR4Z   :     std_logic_vector(23 downto 0);


signal  TEMP1   :     std_logic_vector(23 downto 0);
signal  TEMP2   :     std_logic_vector(23 downto 0);
signal  TEMP3   :     std_logic_vector(23 downto 0);
signal  TEMP4   :     std_logic_vector(23 downto 0);

signal  LF1     :     std_logic_vector(15 downto 0);
signal  LF2     :     std_logic_vector(15 downto 0);
signal  LF3     :     std_logic_vector(15 downto 0);

signal  data_int :    std_logic;

signal  CrossDomainSync	:	std_logic;

begin


LED         <= not data_int;
data			<=	data_int;



CDS0 : entity  work.CrossDomainSyncGen
Port map( 
		  reset      => reset,
		  ClockS     => sclk,
		  ClockF     => clk,
		  SyncSignal => CrossDomainSync
);

TM : entity work.TM_MODULE 
generic map(
	WordSize   =>  WordSize,
	WordCnt    =>  WordCnt,
	MinFCount  =>  MinFCount
)
port map(

 reset	=>reset,
 clk     =>clk,
 MinF    =>MinF,
 MajF    =>MajF,
 sclk    =>sclk,
 gate		=>gate,
 data		=>data_int,
 WordClk =>WordClk,


 LF1     =>      LF1,
 LF2     =>      LF2,
 LF3     =>      LF3,

 AMR1X   =>      AMR1X,
 AMR1Y   =>      AMR1Y,
 AMR1Z   =>      AMR1Z,

 AMR2X   =>      AMR2X,
 AMR2Y   =>      AMR2Y,
 AMR2Z   =>      AMR2Z,

 AMR3X   =>      AMR3X,
 AMR3Y   =>      AMR3Y,
 AMR3Z   =>      AMR3Z,

 AMR4X   =>      AMR4X,
 AMR4Y   =>      AMR4Y,
 AMR4Z   =>      AMR4Z,

 Temp1   =>      Temp1,
 Temp2   =>      Temp2,
 Temp3   =>      Temp3,
 Temp4   =>      Temp4
);

DC_ADC0:entity work.DC_ACQ_TOP
generic map (
	WordSize  => WordSize,
	WordCnt   => WordCnt,
	MinFCount => MinFCount,
	EnableSR  => 0,
	CstDATA   => SEND_CONSTANT_DATA,
	FakeADC	 => 0
)
port map(

 reset	=>  reset,
 clk     =>  clk,
 SyncSig =>  CrossDomainSync,
 minorF  =>  minF,
 majorF  =>  majF,
 sclk    =>  sclk,
 WordClk =>  WordClk,

 DC_ADC_Sclk     =>  DC_ADC_Sclk,
 DC_ADC_IN       =>  DC_ADC_IN,
 DC_ADC_ClkDiv   =>  DC_ADC_ClkDiv,
 DC_ADC_FSynch   =>  DC_ADC_FSynch,
 SET_RESET0      =>  SET_RESET0,
 SET_RESET1      =>  SET_RESET1,

 AMR1X   =>  AMR1X,
 AMR1Y   =>  AMR1Y,
 AMR1Z   =>  AMR1Z,

 AMR2X   =>  AMR2X,
 AMR2Y   =>  AMR2Y,
 AMR2Z   =>  AMR2Z,

 AMR3X   =>  AMR3X,
 AMR3Y   =>  AMR3Y,
 AMR3Z   =>  AMR3Z,
 
 AMR4X   =>  AMR4X,
 AMR4Y   =>  AMR4Y,
 AMR4Z   =>  AMR4Z,
 
 Temp1   =>  Temp1,
 Temp2   =>  Temp2,
 Temp3   =>  Temp3,
 Temp4   =>  Temp4
);


LF: entity work.LF_ACQ_TOP
generic map(
	WordSize  => WordSize,
	WordCnt   => WordCnt,
	MinFCount => MinFCount,
	CstDATA   => SEND_CONSTANT_DATA,
	IIRFilter => 0
)
port map(

 reset	=>  reset,
 clk     =>  clk,
 SyncSig =>  CrossDomainSync,
 minorF  =>  minF,
 majorF  =>  majF,
 sclk    =>  sclk,
 WordClk =>  WordClk,
 LF_SCK	=>  LF_SCK,
 LF_CNV	=>  LF_CNV,
 LF_SDO1	=>  LF_SDO1,
 LF_SDO2	=>  LF_SDO2,
 LF_SDO3	=>  LF_SDO3,
 LF1   	=>  LF1,
 LF2   	=>  LF2,
 LF3   	=>  LF3
);

end rtl;


 
