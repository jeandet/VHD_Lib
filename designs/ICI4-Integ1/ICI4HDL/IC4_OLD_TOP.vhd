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
--			ADC Oscillator frequency = 4MHz
--
--
--==================================================================

entity ici4_OLD is
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
    Data    :   out std_logic;
    DC_ADC_Sclk     :   out std_logic;
    DC_ADC_IN       :   in  std_logic_vector(1 downto 0);
    DC_ADC_ClkDiv   :   out std_logic;
    DC_ADC_FSynch   :   out std_logic;
	 SET_RESET0      :   out std_logic;
	 SET_RESET1      :   out std_logic;
	 LED             :   out std_logic
   );
end;

architecture rtl of ici4_OLD is

signal  clk_buf,reset_buf   :   std_logic;

Constant FramePlacerCount    :   integer := 2;

signal  MinF_Inv    :   std_logic;
signal  Gate_Inv    :   std_logic;
signal  sclk_Inv    :   std_logic;
signal  WordCount   :   integer range 0 to WordCnt-1;
signal  WordClk     :   std_logic;

signal  data_int    :   std_logic;

signal  MuxOUT      :   std_logic_vector(WordSize-1 downto 0);
signal  MuxIN       :   std_logic_vector((2*WordSize)-1 downto 0);
signal  Sel         :   integer range 0 to 1;

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

signal  AMR1X_ADC   :     std_logic_vector(23 downto 0);
signal  AMR1Y_ADC   :     std_logic_vector(23 downto 0);
signal  AMR1Z_ADC   :     std_logic_vector(23 downto 0);

signal  AMR2X_ADC   :     std_logic_vector(23 downto 0);
signal  AMR2Y_ADC   :     std_logic_vector(23 downto 0);
signal  AMR2Z_ADC   :     std_logic_vector(23 downto 0);

signal  AMR3X_ADC   :     std_logic_vector(23 downto 0);
signal  AMR3Y_ADC   :     std_logic_vector(23 downto 0);
signal  AMR3Z_ADC   :     std_logic_vector(23 downto 0);

signal  AMR4X_ADC   :     std_logic_vector(23 downto 0);
signal  AMR4Y_ADC   :     std_logic_vector(23 downto 0);
signal  AMR4Z_ADC   :     std_logic_vector(23 downto 0);

signal  AMR1X_R   :     std_logic_vector(23 downto 0);
signal  AMR1Y_R   :     std_logic_vector(23 downto 0);
signal  AMR1Z_R   :     std_logic_vector(23 downto 0);

signal  AMR2X_R   :     std_logic_vector(23 downto 0);
signal  AMR2Y_R   :     std_logic_vector(23 downto 0);
signal  AMR2Z_R   :     std_logic_vector(23 downto 0);

signal  AMR3X_R   :     std_logic_vector(23 downto 0);
signal  AMR3Y_R   :     std_logic_vector(23 downto 0);
signal  AMR3Z_R   :     std_logic_vector(23 downto 0);

signal  AMR4X_R   :     std_logic_vector(23 downto 0);
signal  AMR4Y_R   :     std_logic_vector(23 downto 0);
signal  AMR4Z_R   :     std_logic_vector(23 downto 0);

signal  AMR1X_S   :     std_logic_vector(23 downto 0);
signal  AMR1Y_S   :     std_logic_vector(23 downto 0);
signal  AMR1Z_S   :     std_logic_vector(23 downto 0);

signal  AMR2X_S   :     std_logic_vector(23 downto 0);
signal  AMR2Y_S   :     std_logic_vector(23 downto 0);
signal  AMR2Z_S   :     std_logic_vector(23 downto 0);

signal  AMR3X_S   :     std_logic_vector(23 downto 0);
signal  AMR3Y_S   :     std_logic_vector(23 downto 0);
signal  AMR3Z_S   :     std_logic_vector(23 downto 0);

signal  AMR4X_S   :     std_logic_vector(23 downto 0);
signal  AMR4Y_S   :     std_logic_vector(23 downto 0);
signal  AMR4Z_s   :     std_logic_vector(23 downto 0);



signal  Temp1   :     std_logic_vector(23 downto 0);
signal  Temp2   :     std_logic_vector(23 downto 0);
signal  Temp3   :     std_logic_vector(23 downto 0);
signal  Temp4   :     std_logic_vector(23 downto 0);


signal  LF1     :     std_logic_vector(15 downto 0);
signal  LF2     :     std_logic_vector(15 downto 0);
signal  LF3     :     std_logic_vector(15 downto 0);


signal  LF1_int    :     std_logic_vector(23 downto 0);
signal  LF2_int    :     std_logic_vector(23 downto 0);
signal  LF3_int    :     std_logic_vector(23 downto 0);

signal   DC_ADC_SmplClk  :    std_logic;
signal   LF_ADC_SmplClk  :    std_logic;
signal   SET_RESET0_sig  :    std_logic;
signal   SET_RESET1_sig  :    std_logic;
signal   SET_RESET_counter : integer range 0 to 31:=0;

signal  MinFCnt   :   integer range 0 to MinFCount-1;

signal  FramePlacerFlags    :   std_logic_vector(FramePlacerCount-1 downto 0);

begin


clk_buf   <= clk;
reset_buf <= reset;
--    

Gate_Inv    <=  not Gate;
sclk_Inv    <=  not Sclk;
MinF_Inv    <=  not MinF;

LED         <= not data_int;
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



DC_SMPL_CLK0 : entity work.LF_SMPL_CLK
generic map(36) 
port map(
    reset    => reset,
    wclk     => WordClk,
    SMPL_CLK => DC_ADC_SmplClk);

process(reset,DC_ADC_SmplClk)
begin
if reset = '0' then
	SET_RESET0_sig <= '0';
elsif DC_ADC_SmplClk'event and DC_ADC_SmplClk = '0' then
	if(SET_RESET_counter = 31) then
		SET_RESET0_sig <= not SET_RESET0_sig;
		SET_RESET_counter <= 0;
	else
		SET_RESET_counter <= SET_RESET_counter +1;
	end if;
end if;
end process;

SET_RESET1_sig	<= SET_RESET0_sig;
SET_RESET0 	<= SET_RESET0_sig;
SET_RESET1  <= SET_RESET1_sig;
--



send_ADC_DATA : IF SEND_CONSTANT_DATA = 0 GENERATE
    DC_ADC0 : DUAL_ADS1278_DRIVER                      --With AMR down ! => 24bits DC TM -> SC high res on Spin
		port map(
			 Clk     =>  clk_buf,
			 reset   =>  reset_buf,
			 SpiClk  =>  DC_ADC_Sclk,
			 DIN     =>  DC_ADC_IN,
			 SmplClk =>  DC_ADC_SmplClk,
                         OUT00   =>  AMR1X,
                         OUT01   =>  AMR1Y,
                         OUT02   =>  AMR1Z,
                         OUT03   =>  AMR2X,
                         OUT04   =>  AMR2Y,
                         OUT05   =>  AMR2Z,
			 OUT06   =>  Temp1,
			 OUT07   =>  Temp2,
                         OUT10   =>  AMR3X,
                         OUT11   =>  AMR3Y,
                         OUT12   =>  AMR3Z,
                         OUT13   =>  AMR4X,
                         OUT14   =>  AMR4Y,
                         OUT15   =>  AMR4Z,
			 OUT16   =>  Temp3,
			 OUT17   =>  Temp4,
			 FSynch  =>  DC_ADC_FSynch
		);
	LF1 <=  LF1cst;
	LF2 <=  LF2cst;
	LF3 <=  LF3cst;
  END GENERATE;

send_CST_DATA : IF (SEND_CONSTANT_DATA = 1) and (SEND_MINF_VALUE = 0) GENERATE
        AMR1X   <= AMR1Xcst;
        AMR1Y   <= AMR1Ycst;
        AMR1Z   <= AMR1Zcst;
        AMR2X   <= AMR2Xcst;
        AMR2Y   <= AMR2Ycst;
        AMR2Z   <= AMR2Zcst;
	Temp1   <= Temp1cst;
	Temp2   <= Temp2cst;
        AMR3X   <= AMR3Xcst;
        AMR3Y   <= AMR3Ycst;
        AMR3Z   <= AMR3Zcst;
        AMR4X   <= AMR4Xcst;
        AMR4Y   <= AMR4Ycst;
        AMR4Z   <= AMR4Zcst;
	Temp3   <= Temp3cst;
	Temp4   <= Temp4cst;
	
	LF1 <=  LF1cst;
	LF2 <=  LF2cst;
	LF3 <=  LF3cst;	
  END GENERATE;
  
  


send_minF_valuelbl : IF (SEND_CONSTANT_DATA = 1) and (SEND_MINF_VALUE = 1) GENERATE
        AMR1X   <= X"000" & "000" & std_logic_vector(TO_UNSIGNED(MinFCnt,9));
        AMR1Y   <= X"000" & "000" & std_logic_vector(TO_UNSIGNED(MinFCnt,9));
        AMR1Z   <= X"000" & "000" & std_logic_vector(TO_UNSIGNED(MinFCnt,9));
        AMR2X   <= X"000" & "000" & std_logic_vector(TO_UNSIGNED(MinFCnt,9));
        AMR2Y   <= X"000" & "000" & std_logic_vector(TO_UNSIGNED(MinFCnt,9));
        AMR2Z   <= X"000" & "000" & std_logic_vector(TO_UNSIGNED(MinFCnt,9));
	Temp1   <= X"000" & "000" & std_logic_vector(TO_UNSIGNED(MinFCnt,9));
	Temp2   <= X"000" & "000" & std_logic_vector(TO_UNSIGNED(MinFCnt,9));
        AMR3X   <= X"000" & "000" & std_logic_vector(TO_UNSIGNED(MinFCnt,9));
        AMR3Y   <= X"000" & "000" & std_logic_vector(TO_UNSIGNED(MinFCnt,9));
        AMR3Z   <= X"000" & "000" & std_logic_vector(TO_UNSIGNED(MinFCnt,9));
        AMR4X   <= X"000" & "000" & std_logic_vector(TO_UNSIGNED(MinFCnt,9));
        AMR4Y   <= X"000" & "000" & std_logic_vector(TO_UNSIGNED(MinFCnt,9));
        AMR4Z   <= X"000" & "000" & std_logic_vector(TO_UNSIGNED(MinFCnt,9));
	Temp3   <= X"000" & "000" & std_logic_vector(TO_UNSIGNED(MinFCnt,9));
	Temp4   <= X"000" & "000" & std_logic_vector(TO_UNSIGNED(MinFCnt,9));
	
	LF1 <=  LF1cst;
	LF2 <=  LF2cst;
	LF3 <=  LF3cst;	
  END GENERATE;

LF_SMPL_CLK0 : entity work.LF_SMPL_CLK
port map(
    reset    => reset,
    wclk     => WordClk,
    SMPL_CLK => LF_ADC_SmplClk
);


sr_hndl: IF SEND_CONSTANT_DATA = 0 GENERATE
process(clk)
begin
    if clk'event and clk ='1' then
		if SET_RESET0_sig = '1' then
                        AMR1X_S   <= AMR1X_ADC;
                        AMR1Y_S   <= AMR1Y_ADC;
                        AMR1Z_S   <= AMR1Z_ADC;
                        AMR2X_S   <= AMR2X_ADC;
                        AMR2Y_S   <= AMR2Y_ADC;
                        AMR2Z_S   <= AMR2Z_ADC;
                        AMR3X_S   <= AMR3X_ADC;
                        AMR3Y_S   <= AMR3Y_ADC;
                        AMR3Z_S   <= AMR3Z_ADC;
                        AMR4X_S   <= AMR4X_ADC;
                        AMR4Y_S   <= AMR4Y_ADC;
                        AMR4Z_S   <= AMR4Z_ADC;
		else
                        AMR1X_R   <= AMR1X_ADC;
                        AMR1Y_R   <= AMR1Y_ADC;
                        AMR1Z_R   <= AMR1Z_ADC;
                        AMR2X_R   <= AMR2X_ADC;
                        AMR2Y_R   <= AMR2Y_ADC;
                        AMR2Z_R   <= AMR2Z_ADC;
                        AMR3X_R   <= AMR3X_ADC;
                        AMR3Y_R   <= AMR3Y_ADC;
                        AMR3Z_R   <= AMR3Z_ADC;
                        AMR4X_R   <= AMR4X_ADC;
                        AMR4Y_R   <= AMR4Y_ADC;
                        AMR4Z_R   <= AMR4Z_ADC;
		end if;
--                        AMR1X   <= std_logic_vector((signed(AMR1X_S) - signed(AMR1X_R))/2);
--                        AMR1Y   <= std_logic_vector((signed(AMR1Y_S) - signed(AMR1Y_R))/2);
--                        AMR1Z   <= std_logic_vector((signed(AMR1Z_S) - signed(AMR1Z_R))/2);
--                        AMR2X   <= std_logic_vector((signed(AMR2X_S) - signed(AMR2X_R))/2);
--                        AMR2Y   <= std_logic_vector((signed(AMR2Y_S) - signed(AMR2Y_R))/2);
--                        AMR2Z   <= std_logic_vector((signed(AMR2Z_S) - signed(AMR2Z_R))/2);
--                        AMR3X   <= std_logic_vector((signed(AMR3X_S) - signed(AMR3X_R))/2);
--                        AMR3Y   <= std_logic_vector((signed(AMR3Y_S) - signed(AMR3Y_R))/2);
--                        AMR3Z   <= std_logic_vector((signed(AMR3Z_S) - signed(AMR3Z_R))/2);
--                        AMR4X   <= std_logic_vector((signed(AMR4X_S) - signed(AMR4X_R))/2);
--                        AMR4Y   <= std_logic_vector((signed(AMR4Y_S) - signed(AMR4Y_R))/2);
--                        AMR4Z   <= std_logic_vector((signed(AMR4Z_S) - signed(AMR4Z_R))/2);
--                        AMR1X   <= AMR1X_S;
--                        AMR1Y   <= AMR1Y_S;
--                        AMR1Z   <= AMR1Z_S;
--                        AMR2X   <= AMR2X_S;
--                        AMR2Y   <= AMR2Y_S;
--                        AMR2Z   <= AMR2Z_S;
--                        AMR3X   <= AMR3X_S;
--                        AMR3Y   <= AMR3Y_S;
--                        AMR3Z   <= AMR3Z_S;
--                        AMR4X   <= AMR4X_S;
--                        AMR4Y   <= AMR4Y_S;
--                        AMR4Z   <= AMR4Z_S;
    end if;
end process;
end generate;


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


end rtl;


 
