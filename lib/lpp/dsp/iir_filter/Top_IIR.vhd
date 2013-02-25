-- Top_IIR.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.FILTERcfg.all;
use lpp.iir_filter.all;

entity Top_IIR is
generic(
        Sample_SZ : integer := 18;
		  ChanelsCount : integer := 1;
		  Coef_SZ      : integer := 9;
		  CoefCntPerCel: integer := 6;
		  Cels_count   : integer := 5);
    port(
        reset       :   in  std_logic;
        clk         :   in  std_logic;
        sample_clk  :   in  std_logic;
--        BP : in std_logic;
--        BPinput       :   in std_logic_vector(3 downto 0);
        LVLinput       :   in std_logic_vector(15 downto 0);
        INsample      :   out samplT(ChanelsCount-1 downto 0,Sample_SZ-1 downto 0);
        OUTsample      :   out samplT(ChanelsCount-1 downto 0,Sample_SZ-1 downto 0)
    ); 
end entity; 


architecture ar_Top_IIR of Top_IIR is

signal    regs_in     :     in_IIR_CEL_reg;
signal    regs_out    :     out_IIR_CEL_reg;
signal    sample_in   :     samplT(ChanelsCount-1 downto 0,Sample_SZ-1 downto 0);
signal    sample_out  :     samplT(ChanelsCount-1 downto 0,Sample_SZ-1 downto 0);
signal    coefs       :      std_logic_vector((Coef_SZ*CoefCntPerCel*Cels_count)-1 downto 0);

signal sample_int : std_logic_vector(Sample_SZ-1 downto 0):=(others => '0');
--signal sample_temp : std_logic_vector(Sample_SZ-1 downto 0):=(others => '0');

begin

ChanelLoop: for i in 0 to ChanelsCount-1 generate
    SampleLoop: for j in 0 to Sample_SZ-1 generate
        sample_in(i,j) <= sample_int(i*20+j);
    end generate;
end generate;

--CH2loop: for k in 0 to Sample_SZ-1 generate
--         sample_temp(k) <= BP;
--end generate;

sample_int <= LVLinput(15) & LVLinput(15) & LVLinput;
INsample <= sample_in;
OUTsample <= sample_out;

filter : IIR_CEL_FILTER
generic map (0,Sample_SZ,ChanelsCount,Coef_SZ,CoefCntPerCel,Cels_count,1)
port map(
    reset       =>  reset,
    clk         =>  clk,
    sample_clk  =>  sample_clk,
    regs_in     =>  regs_in,
    regs_out    =>  regs_out,
    sample_in   =>  sample_in,
    sample_out  =>  sample_out,
    coefs       =>  coefs
    );

coefs <= CoefsInitValCst;
regs_in.virgPos <= std_logic_vector(to_unsigned(virgPos,5));
regs_in.config <= (others => '1');



end architecture;