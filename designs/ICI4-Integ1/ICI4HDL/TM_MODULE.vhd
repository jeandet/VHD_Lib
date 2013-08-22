----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:03:54 08/21/2013 
-- Design Name: 
-- Module Name:    TM_MODULE - AR_TM_MODULE 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library lpp;
use lpp.lpp_ad_conv.all;
use lpp.lpp_amba.all;
use lpp.apb_devices_list.all;
use lpp.general_purpose.all;
use lpp.Rocket_PCM_Encoder.all;

entity TM_MODULE is
generic(
	WordSize : integer := 8; WordCnt    :   integer := 144;MinFCount   :   integer := 64
);
port(

 reset	:  in    std_logic;
 clk     :  in    std_logic;
 MinF    :  in    std_logic;
 MajF    :  in    std_logic;
 sclk    :  in    std_logic;
 gate		:  in    std_logic;
 data		:	out	std_logic;
 WordClk :  out   std_logic;


 LF1     :  in   std_logic_vector(15 downto 0);
 LF2     :  in   std_logic_vector(15 downto 0);
 LF3     :  in   std_logic_vector(15 downto 0);
 
 AMR1X   :  in   std_logic_vector(23 downto 0);
 AMR1Y   :  in   std_logic_vector(23 downto 0);
 AMR1Z   :  in   std_logic_vector(23 downto 0);

 AMR2X   :  in   std_logic_vector(23 downto 0);
 AMR2Y   :  in   std_logic_vector(23 downto 0);
 AMR2Z   :  in   std_logic_vector(23 downto 0);

 AMR3X   :  in   std_logic_vector(23 downto 0);
 AMR3Y   :  in   std_logic_vector(23 downto 0);
 AMR3Z   :  in   std_logic_vector(23 downto 0);
 
 AMR4X   :  in   std_logic_vector(23 downto 0);
 AMR4Y   :  in   std_logic_vector(23 downto 0);
 AMR4Z   :  in   std_logic_vector(23 downto 0);
 
 Temp1   :  in   std_logic_vector(23 downto 0);
 Temp2   :  in   std_logic_vector(23 downto 0);
 Temp3   :  in   std_logic_vector(23 downto 0);
 Temp4   :  in   std_logic_vector(23 downto 0)
);
end TM_MODULE;

architecture AR_TM_MODULE of TM_MODULE is

Constant FramePlacerCount    :   integer := 2;
signal   MinFCnt   :   integer range 0 to MinFCount-1;
signal   FramePlacerFlags    :   std_logic_vector(FramePlacerCount-1 downto 0);

signal  WordCount   :   integer range 0 to WordCnt-1;

signal  data_int    :   std_logic;

signal  MuxOUT      :   std_logic_vector(WordSize-1 downto 0);
signal  MuxIN       :   std_logic_vector((2*WordSize)-1 downto 0);
signal  Sel         :   integer range 0 to 1;


signal  MinF_Inv    :   std_logic;
signal  Gate_Inv    :   std_logic;
signal  sclk_Inv    :   std_logic;

begin


Gate_Inv    <=  not Gate;
sclk_Inv    <=  not Sclk;
MinF_Inv    <=  not MinF;
data        <= data_int;

SD0 : Serial_Driver 
generic map(WordSize)
port map(sclk_Inv,MuxOUT,Gate_inv,data_int);

WC0 :  Word_Cntr
generic map(WordSize,WordCnt)
port map(sclk_Inv,MinF,WordClk,WordCount);

MFC0 :  MinF_Cntr
generic map(MinFCount)
port map(
    clk     =>  MinF_Inv,
    reset   =>  MajF,
    Cnt_out =>  MinFCnt
);


MUX0 : Serial_Driver_Multiplexor
generic map(FramePlacerCount,WordSize)
port map(sclk_Inv,Sel,MuxIN,MuxOUT);


DCFP0 : entity work.DC_FRAME_PLACER 
generic map(WordSize,WordCnt,MinFCount)
port map(
    clk     =>  Sclk,
    Wcount  =>  WordCount,
    MinFCnt =>  MinFCnt,
    Flag    =>  FramePlacerFlags(0),
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
    Temp4   =>  Temp4,
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



end AR_TM_MODULE;

