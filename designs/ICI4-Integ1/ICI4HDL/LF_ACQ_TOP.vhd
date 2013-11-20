library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library lpp;
use lpp.lpp_ad_conv.all;
use lpp.lpp_amba.all;
use lpp.apb_devices_list.all;
use lpp.general_purpose.all;
use lpp.Rocket_PCM_Encoder.all;
use lpp.iir_filter.all;
use work.config.all;

entity LF_ACQ_TOP is
generic(
	WordSize    : integer := 8; 
	WordCnt     : integer := 144;
	MinFCount   : integer := 64;
	CstDATA     : integer := 0;
	IIRFilter   : integer := 0
);
port(

 reset	:  in    std_logic;
 clk     :  in    std_logic;
 SyncSig :  in    STD_LOGIC;
 minorF  :  in    std_logic;
 majorF  :  in    std_logic;
 sclk    :  in    std_logic;
 WordClk :  in    std_logic;
 LF_SCK	:	out   std_logic;
 LF_CNV	:  out	std_logic;
 LF_SDO1	:	in		std_logic;
 LF_SDO2	:	in		std_logic;
 LF_SDO3	:	in		std_logic;
 LF1   	:  out   std_logic_vector(15 downto 0);
 LF2   	:  out   std_logic_vector(15 downto 0);
 LF3   	:  out   std_logic_vector(15 downto 0)
);
end LF_ACQ_TOP;

architecture AR_LF_ACQ_TOP of LF_ACQ_TOP is

signal	LF_ADC_SmplClk	:	std_logic;

signal	LF_ADC_SpPulse	:	std_logic;
signal   SDO				:	STD_LOGIC_VECTOR(2 DOWNTO 0);
signal	sps	    		:	Samples(2 DOWNTO 0);

signal	LFX   			:	Samples(2 DOWNTO 0);
signal	sample_val		:	std_logic;
signal	AD_in          :  AD7688_in(2 DOWNTO 0);
signal	AD_out         :  AD7688_out;
signal   Filter_sp_in   :  samplT(2 DOWNTO 0, 15 DOWNTO 0);
signal   Filter_sp_out  :  samplT(2 DOWNTO 0, 15 DOWNTO 0);
signal   sample_out_val :  std_logic;

signal   LF1_sync   	:     std_logic_vector(15 downto 0);
signal   LF2_sync   	:     std_logic_vector(15 downto 0);
signal   LF3_sync   	:     std_logic_vector(15 downto 0);

begin


AD_in(0).sdi	<=	LF_SDO1;
AD_in(1).sdi	<=	LF_SDO2;
AD_in(2).sdi	<=	LF_SDO3;
LF_SCK         <=	AD_out.SCK;
LF_CNV         <= AD_out.CNV;


LF_SMPL_CLK0 : entity work.LF_SMPL_CLK
generic map(6) 
port map(
    reset    => reset,
    wclk     => WordClk,
    SMPL_CLK => LF_ADC_SmplClk
);


ADC: IF CstDATA =0 GENERATE
ADCs:  AD7688_drvr 
GENERIC map
(
	 ChanelCount => 3,
    clkkHz      => 48000
)
PORT map
(
	clk       => clk,
	rstn      => reset,
   enable    => '1',
   smplClk   => LF_ADC_SmplClk,
   DataReady => sample_val,
   smpout    => sps,
   AD_in     => AD_in,
   AD_out    => AD_out
);

smpPulse: entity work.OneShot 
    Port map( 
	 reset  => reset,
    clk    => clk,
    input  => LF_ADC_SmplClk,
    output => LF_ADC_SpPulse
);




NOfilt:	IF IIRFilter = 0 GENERATE
		process(reset,clk)
		begin
			if reset ='0' then
				LF1_sync	<=	(others => '0');
				LF2_sync	<=	(others => '0');
				LF3_sync	<=	(others => '0');
			elsif clk'event and clk ='1' then
				if sample_val = '1' then
					LF1_sync	<=	sps(0);
					LF2_sync	<=	sps(1);
					LF3_sync	<=	sps(2);
				end if;
			end if;
		end process;
	END GENERATE;
	
	
filt:	IF IIRFilter /= 0 GENERATE


filtertop: entity work.IIR_FILTER_TOP 
generic map
(
	V2	=> 0
)
port map
(
    rstn 	=> reset,
    clk  	=> clk,

    SMPclk  => LF_ADC_SmplClk,
    LF1_IN  => sps(0),
    LF2_IN  => sps(1),
    LF3_IN  => sps(2),

    SMPCLKOut => open,
    LF1_OUT   => LF1_sync,
    LF2_OUT   => LF2_sync,
    LF3_OUT   => LF3_sync
);

END GENERATE;




END GENERATE;

CST: IF CstDATA /=0 GENERATE

	LF1_sync	<=	LF1cst;
	LF2_sync	<=	LF2cst;
	LF3_sync	<=	LF3cst;

END GENERATE;



LF1sync: entity work.Fast2SlowSync
generic map(N	=> 16)
port map( LF1_sync,clk,sclk,SyncSig,LF1);

LF2sync: entity work.Fast2SlowSync
generic map(N	=> 16)
port map( LF2_sync,clk,sclk,SyncSig,LF2);

LF3sync: entity work.Fast2SlowSync
generic map(N	=> 16)
port map( LF3_sync,clk,sclk,SyncSig,LF3);

--Filter: IIR_CEL_FILTER 
--    GENERIC map(
--      tech          => CFG_MEMTECH,
--      Sample_SZ     => Sample_SZ,
--      ChanelsCount  => ChanelsCount,
--      Coef_SZ       => Coef_SZ,
--      CoefCntPerCel => CoefCntPerCel,
--      Cels_count    => Cels_count,
--      Mem_use       => use_RAM
--		)
--    PORT map(
--      reset      => reset,
--      clk        => clk,
--      sample_clk => LF_ADC_SmplClk,
--      regs_in    : IN  in_IIR_CEL_reg;
--      regs_out   : IN  out_IIR_CEL_reg;
--      sample_in  : IN  samplT(ChanelsCount-1 DOWNTO 0, Sample_SZ-1 DOWNTO 0);
--      sample_out : OUT samplT(ChanelsCount-1 DOWNTO 0, Sample_SZ-1 DOWNTO 0);
--      GOtest     : OUT STD_LOGIC;
--      coefs      : IN  STD_LOGIC_VECTOR(Coef_SZ*CoefCntPerCel*Cels_count-1 DOWNTO 0)
--
--      );
		



end AR_LF_ACQ_TOP;









