------------------------------------------------------------------------------
--  This file is a part of the LPP VHDL IP LIBRARY
--  Copyright (C) 2009 - 2010, Laboratory of Plasmas Physic - CNRS
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 3 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA 
-------------------------------------------------------------------------------
--                    Author : Alexis Jeandet
--                     Mail : alexis.jeandet@lpp.polytechnique.fr
-------------------------------------------------------------------------------

library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
library lpp;
use lpp.iir_filter.all;
use lpp.general_purpose.all;

--TODO amliorer la gestion de la RAM et de la flexibilit du filtre

entity  IIR_CEL_CTRLR is
generic(Sample_SZ : integer := 16;
		  ChanelsCount : integer := 1;
		  Coef_SZ      : integer := 9;
		  CoefCntPerCel: integer := 3;
		  Cels_count   : integer := 5;
        Mem_use      : integer := use_RAM
);
port(
    reset       :   in  std_logic;
    clk         :   in  std_logic;
    sample_clk  :   in  std_logic;
    sample_in   :   in  samplT(ChanelsCount-1 downto 0,Sample_SZ-1 downto 0);
    sample_out  :   out samplT(ChanelsCount-1 downto 0,Sample_SZ-1 downto 0);
    virg_pos    :   in  integer;
    coefs       :   in  std_logic_vector(Coef_SZ*CoefCntPerCel*Cels_count-1 downto 0)
);
end IIR_CEL_CTRLR;




architecture ar_IIR_CEL_CTRLR of IIR_CEL_CTRLR is

subtype    sampleVect   is std_logic_vector(Sample_SZ-1 downto 0);

signal  smpl_clk_old    :   std_logic := '0';
signal  WD_sel          :   std_logic := '0';
signal  Read            :   std_logic := '0';
signal  SVG_ADDR        :   std_logic := '0';
signal  count           :   std_logic := '0';
signal  Write           :   std_logic := '0';
signal  WADDR_sel       :   std_logic := '0';
signal  GO_0            :   std_logic := '0';

signal  RAM_sample_in   :   sampleVect;
signal  RAM_sample_in_bk:   sampleVect;
signal  RAM_sample_out  :   sampleVect;
signal  ALU_ctrl        :   std_logic_vector(3 downto 0);
signal  ALU_sample_in   :   sampleVect;
signal  ALU_Coef_in     :   std_logic_vector(Coef_SZ-1 downto 0);
signal  ALU_out         :   std_logic_vector(Sample_SZ+Coef_SZ-1 downto 0);
signal  curentCel       :   integer range 0 to Cels_count-1 := 0;
signal  curentChan      :   integer range 0 to ChanelsCount-1 := 0;


type    sampleBuffT  is array(ChanelsCount-1 downto 0) of sampleVect;

signal  sample_in_BUFF  :   sampleBuffT;
signal  sample_out_BUFF :   sampleBuffT;

type    CoefCelT  is array(CoefCntPerCel-1 downto 0) of std_logic_vector(Coef_SZ-1 downto 0);
type    CoefTblT  is array(Cels_count-1 downto 0) of CoefCelT;

type    CoefsRegT is record
    numCoefs    : CoefTblT;
	 denCoefs    : CoefTblT;
end record;

signal  CoefsReg   : CoefsRegT;

type    fsmIIR_CEL_T is (waiting,pipe1,computeb1,computeb2,computea1,computea2,next_cel,pipe2,pipe3,next_chan);

signal  IIR_CEL_STATE   :   fsmIIR_CEL_T;

begin


coefsConnectL0: for z in 0 to Cels_count-1 generate
     coefsConnectL1: for y in 0 to CoefCntPerCel-1 generate
          coefsConnectL2: for x in 0 to Coef_SZ-1 generate
               CoefsReg.numCoefs(z)(y)(x)     <=   coefs(x + y*Coef_SZ + z*Coef_SZ*CoefCntPerCel);
					CoefsReg.denCoefs(z)(y)(x)     <=   coefs(x + y*Coef_SZ + z*Coef_SZ*CoefCntPerCel);
          end generate;
     end generate;
end generate;


RAM_CTRLR2inst : RAM_CTRLR2
generic map(Sample_SZ,Mem_use)
port map(
    reset       =>  reset,
    clk         =>  clk,
    WD_sel      =>  WD_sel,
    Read        =>  Read,
    WADDR_sel   =>  WADDR_sel,
    count       =>  count,
    SVG_ADDR    =>  SVG_ADDR,
    Write       =>  Write,
    GO_0        =>  GO_0,
    sample_in   =>  RAM_sample_in,
    sample_out  =>  RAM_sample_out
);



ALU_inst :ALU
generic map(Logic_en => 0,Input_SZ_1 => Sample_SZ, Input_SZ_2 => Coef_SZ)
port map(
    clk     =>  clk,
    reset   =>  reset,
    ctrl    =>  ALU_ctrl,
    OP1     =>  ALU_sample_in,
    OP2     =>  ALU_coef_in,
    RES     =>  ALU_out
);






WD_sel      <= '0' when (IIR_CEL_STATE = waiting or IIR_CEL_STATE = pipe1 or IIR_CEL_STATE = computeb2) else '1';
Read        <= '1' when (IIR_CEL_STATE = pipe1 or IIR_CEL_STATE = computeb1 or IIR_CEL_STATE = computeb2 or IIR_CEL_STATE = computea1 or IIR_CEL_STATE = computea2) else '0';
WADDR_sel   <= '1' when IIR_CEL_STATE = computea1 else '0';
count       <= '1' when (IIR_CEL_STATE = pipe1 or IIR_CEL_STATE = computeb1 or IIR_CEL_STATE = computeb2 or IIR_CEL_STATE = computea1) else '0';
SVG_ADDR    <= '1' when IIR_CEL_STATE = computeb2 else '0';
--Write       <= '1' when (IIR_CEL_STATE = computeb1 or IIR_CEL_STATE = computeb2 or (IIR_CEL_STATE = computea1 and not(curentChan = 0 and curentCel = 0)) or IIR_CEL_STATE = computea2) else '0';
Write       <= '1' when (IIR_CEL_STATE = computeb1 or IIR_CEL_STATE = computeb2 or IIR_CEL_STATE = computea1  or IIR_CEL_STATE = computea2) else '0';

GO_0        <= '1' when IIR_CEL_STATE = waiting else '0';







process(clk,reset)
variable result :   std_logic_vector(Sample_SZ-1 downto 0);

begin

if reset = '0' then

    smpl_clk_old    <=  '0';
    RAM_sample_in   <=  (others=> '0');
    ALU_ctrl        <=  IDLE;
    ALU_sample_in   <=  (others=> '0');
    ALU_Coef_in     <=  (others=> '0');
    RAM_sample_in_bk<=  (others=> '0');
    curentCel       <=  0;
    curentChan      <=  0;
    IIR_CEL_STATE   <=  waiting;
resetL0 : for i in 0 to ChanelsCount-1 loop
                sample_in_BUFF(i)    <=  (others => '0');
                sample_out_BUFF(i)   <=  (others => '0');
					 resetL1: for j in 0 to Sample_SZ-1 loop
                    sample_out(i,j)        <=  '0';
					 end loop;
           end loop;

elsif clk'event and clk = '1' then

    smpl_clk_old    <=  sample_clk;

    case    IIR_CEL_STATE is

        when waiting =>
            if sample_clk = '1' and smpl_clk_old = '0' then
                IIR_CEL_STATE   <=  pipe1;
                RAM_sample_in   <=  std_logic_vector(sample_in_BUFF(0));
                ALU_sample_in   <=  std_logic_vector(sample_in_BUFF(0));
                
            else
                ALU_ctrl        <=  IDLE; 
                smplConnectL0: for i in 0 to ChanelsCount-1 loop
                    smplConnectL1: for j in 0 to Sample_SZ-1 loop
						      sample_in_BUFF(i)(j)  <=  sample_in(i,j);
                        sample_out(i,j)      <=  sample_out_BUFF(i)(j);
					     end loop;
					 end loop;
            end if;
            curentCel       <=  0;
            curentChan      <=  0;

        when pipe1 =>
                IIR_CEL_STATE   <=  computeb1;
                ALU_ctrl        <=  MAC_op;
                ALU_Coef_in     <=  std_logic_vector(CoefsReg.NumCoefs(curentCel)(0));

        when computeb1 =>
            
            ALU_ctrl        <=  MAC_op;
            ALU_sample_in   <=  RAM_sample_out;
            ALU_Coef_in     <=  std_logic_vector(CoefsReg.NumCoefs(curentCel)(1));
            IIR_CEL_STATE   <=  computeb2;
            RAM_sample_in   <=  RAM_sample_in_bk;
        when computeb2 =>
            ALU_sample_in   <=  RAM_sample_out;
            ALU_Coef_in     <=  std_logic_vector(CoefsReg.NumCoefs(curentCel)(2));
            IIR_CEL_STATE   <=  computea1;
            

        when computea1 =>
            ALU_sample_in   <=  RAM_sample_out;
            ALU_Coef_in     <=  std_logic_vector(CoefsReg.DenCoefs(curentCel)(1));
            IIR_CEL_STATE   <=  computea2;
            

        when computea2 =>
            ALU_sample_in   <=  RAM_sample_out;
            ALU_Coef_in     <=  std_logic_vector(CoefsReg.DenCoefs(curentCel)(2));
            IIR_CEL_STATE   <=  next_cel;
            

        when next_cel =>
            ALU_ctrl        <=  clr_mac;
            IIR_CEL_STATE   <=  pipe2;            

        when pipe2 =>
            IIR_CEL_STATE   <=  pipe3;
            
            
        when pipe3 =>

            result                          :=  ALU_out(Sample_SZ+virg_pos-1 downto virg_pos);

            sample_out_BUFF(0)              <=  result;
            RAM_sample_in_bk                <=  result;
            RAM_sample_in                   <=  result;
            if curentCel   = Cels_count-1 then
                IIR_CEL_STATE   <=  next_chan;
                curentCel       <=  0;
            else
                curentCel       <=  curentCel + 1;
                IIR_CEL_STATE   <=  pipe1;
                ALU_sample_in   <=  result;
            end if;
        when next_chan =>
 
rotate :    for i in 1 to ChanelsCount-1 loop
                sample_in_BUFF(i-1)    <=  sample_in_BUFF(i);
                sample_out_BUFF(i-1)   <=  sample_out_BUFF(i);
            end loop;
                sample_in_BUFF(ChanelsCount-1) <= sample_in_BUFF(0);
                sample_out_BUFF(ChanelsCount-1)<= sample_out_BUFF(0);
                
            if curentChan   = (ChanelsCount-1) then
                IIR_CEL_STATE   <=  waiting;
                ALU_ctrl        <=  clr_mac;
            elsif ChanelsCount>1 then
                curentChan       <=  curentChan + 1;
                IIR_CEL_STATE    <=  pipe1;
                ALU_sample_in    <=  sample_in_BUFF(1);
                RAM_sample_in    <=  sample_in_BUFF(1);
            end if;
    end case;

end if;
end process;






end ar_IIR_CEL_CTRLR;





































