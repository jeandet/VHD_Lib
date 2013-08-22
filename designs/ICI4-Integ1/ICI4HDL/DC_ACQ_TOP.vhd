library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library lpp;
use lpp.lpp_ad_conv.all;
use lpp.lpp_amba.all;
use lpp.apb_devices_list.all;
use lpp.general_purpose.all;
use lpp.Rocket_PCM_Encoder.all;


entity DC_ACQ_TOP is
generic(
	WordSize   : integer := 8; 
	WordCnt    : integer := 144;
	MinFCount  : integer := 64;
	EnableSR   : integer := 1;
	FakeADC	  : integer := 0
);
port(

 reset	:  in    std_logic;
 clk     :  in    std_logic;
 SyncSig :  in    STD_LOGIC;
 minorF  :  in    std_logic;
 majorF  :  in    std_logic;
 sclk    :  in    std_logic;
 WordClk :  in    std_logic;

 DC_ADC_Sclk     :   out std_logic;
 DC_ADC_IN       :   in  std_logic_vector(1 downto 0);
 DC_ADC_ClkDiv   :   out std_logic;
 DC_ADC_FSynch   :   out std_logic;
 SET_RESET0      :   out std_logic;
 SET_RESET1      :   out std_logic;

 AMR1X   :  out   std_logic_vector(23 downto 0);
 AMR1Y   :  out   std_logic_vector(23 downto 0);
 AMR1Z   :  out   std_logic_vector(23 downto 0);

 AMR2X   :  out   std_logic_vector(23 downto 0);
 AMR2Y   :  out   std_logic_vector(23 downto 0);
 AMR2Z   :  out   std_logic_vector(23 downto 0);

 AMR3X   :  out   std_logic_vector(23 downto 0);
 AMR3Y   :  out   std_logic_vector(23 downto 0);
 AMR3Z   :  out   std_logic_vector(23 downto 0);
 
 AMR4X   :  out   std_logic_vector(23 downto 0);
 AMR4Y   :  out   std_logic_vector(23 downto 0);
 AMR4Z   :  out   std_logic_vector(23 downto 0);
 
 Temp1   :  out   std_logic_vector(23 downto 0);
 Temp2   :  out   std_logic_vector(23 downto 0);
 Temp3   :  out   std_logic_vector(23 downto 0);
 Temp4   :  out   std_logic_vector(23 downto 0)
);
end DC_ACQ_TOP;

architecture Behavioral of DC_ACQ_TOP is

signal   DC_ADC_SmplClk  :    std_logic;
signal   LF_ADC_SmplClk  :    std_logic;
signal   SET_RESET0_sig  :    std_logic;
signal   SET_RESET1_sig  :    std_logic;
signal   SET_RESET_counter : integer range 0 to 31:=0;

signal   AMR1X_Sync   :    std_logic_vector(23 downto 0);
signal   AMR1Y_Sync   :    std_logic_vector(23 downto 0);
signal   AMR1Z_Sync   :    std_logic_vector(23 downto 0);

signal   AMR2X_Sync   :    std_logic_vector(23 downto 0);
signal   AMR2Y_Sync   :    std_logic_vector(23 downto 0);
signal   AMR2Z_Sync   :    std_logic_vector(23 downto 0);

signal   AMR3X_Sync   :    std_logic_vector(23 downto 0);
signal   AMR3Y_Sync   :    std_logic_vector(23 downto 0);
signal   AMR3Z_Sync   :    std_logic_vector(23 downto 0);

signal   AMR4X_Sync   :    std_logic_vector(23 downto 0);
signal   AMR4Y_Sync   :    std_logic_vector(23 downto 0);
signal   AMR4Z_Sync   :    std_logic_vector(23 downto 0);

signal   Temp1_Sync   :    std_logic_vector(23 downto 0);
signal   Temp2_Sync   :    std_logic_vector(23 downto 0);
signal   Temp3_Sync   :    std_logic_vector(23 downto 0);
signal   Temp4_Sync   :    std_logic_vector(23 downto 0);

begin

------------------------------------------------------------------
--
--			DC sampling clock generation
--
------------------------------------------------------------------


DC_SMPL_CLK0 : entity work.LF_SMPL_CLK
--generic map(36) 
generic map(288) 
port map(
    reset    => reset,
    wclk     => WordClk,
    SMPL_CLK => DC_ADC_SmplClk
);
------------------------------------------------------------------


	 
	 
------------------------------------------------------------------
--
--			DC	ADC
--
------------------------------------------------------------------
ADC : IF FakeADC /=1 GENERATE
	 
DC_ADC0 : DUAL_ADS1278_DRIVER                 
port map(
    Clk     =>  clk,
    reset   =>  reset,
    SpiClk  =>  DC_ADC_Sclk,
    DIN     =>  DC_ADC_IN,
    SmplClk =>  DC_ADC_SmplClk,
    OUT00   =>  AMR1X_Sync,
    OUT01   =>  AMR1Y_Sync,
    OUT02   =>  AMR1Z_Sync,
    OUT03   =>  AMR2X_Sync,
    OUT04   =>  AMR2Y_Sync,
    OUT05   =>  AMR2Z_Sync,
    OUT06   =>  Temp1_Sync,
    OUT07   =>  Temp2_Sync,
    OUT10   =>  AMR3X_Sync,
    OUT11   =>  AMR3Y_Sync,
    OUT12   =>  AMR3Z_Sync,
    OUT13   =>  AMR4X_Sync,
    OUT14   =>  AMR4Y_Sync,
    OUT15   =>  AMR4Z_Sync,
    OUT16   =>  Temp3_Sync,
    OUT17   =>  Temp4_Sync,
    FSynch  =>  DC_ADC_FSynch
);
END GENERATE;

NOADC: IF FakeADC=1 GENERATE
	 
DC_ADC0 : entity work.FAKE_DUAL_ADS1278_DRIVER                 
port map(
    Clk     =>  clk,
    reset   =>  reset,
    SpiClk  =>  DC_ADC_Sclk,
    DIN     =>  DC_ADC_IN,
    SmplClk =>  DC_ADC_SmplClk,
    OUT00   =>  AMR1X_Sync,
    OUT01   =>  AMR1Y_Sync,
    OUT02   =>  AMR1Z_Sync,
    OUT03   =>  AMR2X_Sync,
    OUT04   =>  AMR2Y_Sync,
    OUT05   =>  AMR2Z_Sync,
    OUT06   =>  Temp1_Sync,
    OUT07   =>  Temp2_Sync,
    OUT10   =>  AMR3X_Sync,
    OUT11   =>  AMR3Y_Sync,
    OUT12   =>  AMR3Z_Sync,
    OUT13   =>  AMR4X_Sync,
    OUT14   =>  AMR4Y_Sync,
    OUT15   =>  AMR4Z_Sync,
    OUT16   =>  Temp3_Sync,
    OUT17   =>  Temp4_Sync,
    FSynch  =>  DC_ADC_FSynch
);
END GENERATE;
------------------------------------------------------------------




------------------------------------------------------------------
--	 
--				SET/RESET GEN
--
------------------------------------------------------------------
 
SR: IF EnableSR /=0 GENERATE
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

END GENERATE;
NOSR: IF EnableSR=0 GENERATE
	SET_RESET0_sig	<=	'0';
END GENERATE;

SET_RESET1_sig	<= SET_RESET0_sig;
SET_RESET0 	<= SET_RESET0_sig;
SET_RESET1  <= SET_RESET1_sig;
------------------------------------------------------------------
------------------------------------------------------------------


------------------------------------------------------------------
--
--				Cross domain clock synchronisation 
--
------------------------------------------------------------------



AMR1Xsync: entity work.Fast2SlowSync
generic map(N	=> 24)
port map( AMR1X_Sync,clk,sclk,SyncSig,AMR1X);
AMR1Ysync: entity work.Fast2SlowSync
generic map(N	=> 24)
port map( AMR1Y_Sync,clk,sclk,SyncSig,AMR1Y);
AMR1Zsync: entity work.Fast2SlowSync
generic map(N	=> 24)
port map( AMR1Z_Sync,clk,sclk,SyncSig,AMR1Z);

AMR2Xsync: entity work.Fast2SlowSync
generic map(N	=> 24)
port map( AMR2X_Sync,clk,sclk,SyncSig,AMR2X);
AMR2Ysync: entity work.Fast2SlowSync
generic map(N	=> 24)
port map( AMR2Y_Sync,clk,sclk,SyncSig,AMR2Y);
AMR2Zsync: entity work.Fast2SlowSync
generic map(N	=> 24)
port map( AMR2Z_Sync,clk,sclk,SyncSig,AMR2Z);

AMR3Xsync: entity work.Fast2SlowSync
generic map(N	=> 24)
port map( AMR3X_Sync,clk,sclk,SyncSig,AMR3X);
AMR3Ysync: entity work.Fast2SlowSync
generic map(N	=> 24)
port map( AMR3Y_Sync,clk,sclk,SyncSig,AMR3Y);
AMR3Zsync: entity work.Fast2SlowSync
generic map(N	=> 24)
port map( AMR3Z_Sync,clk,sclk,SyncSig,AMR3Z);


AMR4Xsync: entity work.Fast2SlowSync
generic map(N	=> 24)
port map( AMR4X_Sync,clk,sclk,SyncSig,AMR4X);
AMR4Ysync: entity work.Fast2SlowSync
generic map(N	=> 24)
port map( AMR4Y_Sync,clk,sclk,SyncSig,AMR4Y);
AMR4Zsync: entity work.Fast2SlowSync
generic map(N	=> 24)
port map( AMR4Z_Sync,clk,sclk,SyncSig,AMR4Z);


TEMP1sync: entity work.Fast2SlowSync
generic map(N	=> 24)
port map( TEMP1_Sync,clk,sclk,SyncSig,TEMP1);
TEMP2sync: entity work.Fast2SlowSync
generic map(N	=> 24)
port map( TEMP2_Sync,clk,sclk,SyncSig,TEMP2);
TEMP3sync: entity work.Fast2SlowSync
generic map(N	=> 24)
port map( TEMP3_Sync,clk,sclk,SyncSig,TEMP3);
TEMP4sync: entity work.Fast2SlowSync
generic map(N	=> 24)
port map( TEMP4_Sync,clk,sclk,SyncSig,TEMP4);

------------------------------------------------------------------


end Behavioral;











