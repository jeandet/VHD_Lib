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


entity IIR_FILTER_TOP is
generic
(
	V2	:	integer :=0		-- IF 1 uses V2 else use V1
);
port
(
    rstn : IN STD_LOGIC;
    clk  : IN STD_LOGIC;

    SMPclk : IN STD_LOGIC;
    LF1_IN : IN std_logic_vector(15 downto 0);
    LF2_IN : IN std_logic_vector(15 downto 0);
    LF3_IN : IN std_logic_vector(15 downto 0);

    SMPCLKOut : OUT STD_LOGIC;
    LF1_OUT : OUT std_logic_vector(15 downto 0);
    LF2_OUT : OUT std_logic_vector(15 downto 0);
    LF3_OUT : OUT std_logic_vector(15 downto 0)
);
end IIR_FILTER_TOP;

architecture AR_IIR_FILTER_TOP of IIR_FILTER_TOP is
signal	sps	    		:	Samples(2 DOWNTO 0);

signal	LFX   			:	Samples(2 DOWNTO 0);
signal   Filter_sp_in   :  samplT(2 DOWNTO 0, 15 DOWNTO 0);
signal   Filter_sp_out  :  samplT(2 DOWNTO 0, 15 DOWNTO 0);
signal   sample_out_val :  std_logic;
signal	LF_ADC_SpPulse	:	std_logic;

begin

sps(0)   <= LF1_IN;
sps(1)   <= LF2_IN;
sps(2)   <= LF3_IN;

LF1_OUT	<= LFX(0);
LF2_OUT	<=	LFX(1);
LF3_OUT	<=	LFX(2);

SMPCLKOut	<= sample_out_val;

loop_all_sample : FOR J IN 15 DOWNTO 0 GENERATE

 loop_all_chanel : FOR I IN 2 DOWNTO 0 GENERATE
		process(rstn,clk)
		begin
			if rstn ='0' then
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

V2FILTER: IF V2 = 1 GENERATE

smpPulse: entity work.OneShot 
    Port map( 
	 reset  => rstn,
    clk    => clk,
    input  => SMPclk,
    output => LF_ADC_SpPulse
);

FilterV2: IIR_CEL_CTRLR_v2 
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
    rstn => rstn,
    clk  => clk,

    virg_pos => virgPos,
    coefs    => CoefsInitValCst_v2,

    sample_in_val => LF_ADC_SpPulse,
    sample_in     => Filter_sp_in,

    sample_out_val => sample_out_val,
    sample_out     => Filter_sp_out
);

	

END GENERATE;

V1FILTER: IF V2 /= 1 GENERATE

sample_out_val	<= SMPclk;


FilterV1: IIR_CEL_CTRLR 
generic map(
        tech 			=> CFG_MEMTECH,
        Sample_SZ 	=> Sample_SZ,
		  ChanelsCount => 3,
		  Coef_SZ      => Coef_SZ,
		  CoefCntPerCel=> CoefCntPerCel,
		  Cels_count   => Cels_count,
        Mem_use      => use_RAM
)
port map(
    reset       => rstn,
    clk         => clk,
    sample_clk  => SMPclk,
    sample_in   => Filter_sp_in,
    sample_out  => Filter_sp_out,
    virg_pos    => virgPos,
    GOtest      => open,
    coefs       => CoefsInitValCst
);
	
END GENERATE;


end AR_IIR_FILTER_TOP;

