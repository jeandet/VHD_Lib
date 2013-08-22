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
	IIRFilter   : integer := 1
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



Filter: IIR_CEL_CTRLR_v2 
  GENERIC map(
    tech          => CFG_MEMTECH,
    Mem_use       => use_RAM,
    Sample_SZ     => Sample_SZ,
    Coef_SZ       => Coef_SZ,
    Coef_Nb       => 25,
    Coef_sel_SZ   => 5,
    Cels_count    => 5,
    ChanelsCount  => ChanelsCount
	 )
  PORT map(
    rstn => reset,
    clk  => clk,

    virg_pos => virgPos,
    coefs    => CoefsInitValCst_v2,

    sample_in_val => LF_ADC_SpPulse,
    sample_in     => Filter_sp_in,

    sample_out_val => sample_out_val,
    sample_out     => Filter_sp_out
);

NOfilt:	IF IIRFilter = 0 GENERATE
		process(reset,clk)
		begin
			if reset ='0' then
				LF1	<=	(others => '0');
				LF2	<=	(others => '0');
				LF3	<=	(others => '0');
			elsif clk'event and clk ='1' then
				if sample_val = '1' then
					LF1	<=	sps(0);
					LF2	<=	sps(1);
					LF3	<=	sps(2);
				end if;
			end if;
		end process;
	END GENERATE;
filt:	IF IIRFilter /= 0 GENERATE

	LF1	<= LFX(0);
	LF2	<=	LFX(1);
	LF3	<=	LFX(2);

  loop_all_sample : FOR J IN 15 DOWNTO 0 GENERATE

    loop_all_chanel : FOR I IN 2 DOWNTO 0 GENERATE
			process(reset,clk)
			begin
				if reset ='0' then
					Filter_sp_in(I,J)	<=	'0';
--					LFX(I)					<=	(others => '0');
				elsif clk'event and clk ='1' then
					if sample_out_val = '1' then
						LFX(I)(J)	<=	Filter_sp_out(I,J);
						Filter_sp_in(I,J)	<=	sps(I)(J);
					end if;
				end if;
			end process;
		END GENERATE;
	END GENERATE;
END GENERATE;




END GENERATE;

CST: IF CstDATA /=0 GENERATE

	LF1	<=	LF1cst;
	LF2	<=	LF2cst;
	LF3	<=	LF3cst;

END GENERATE;




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









