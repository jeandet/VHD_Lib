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
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;
library lpp;
use lpp.iir_filter.all;
use lpp.general_purpose.all;
use lpp.lpp_amba.all;
use lpp.apb_devices_list.all;

entity APB_IIR_Filter is
  generic (
    tech : integer := 0;
    pindex   : integer  := 0;
    paddr    : integer  := 0;
    pmask    : integer  := 16#fff#;
    pirq     : integer  := 0;
    abits    : integer  := 8;
    Sample_SZ : integer := 16;
    ChanelsCount : integer := 1;
    Coef_SZ      : integer := 9;
    CoefCntPerCel: integer := 6;
    Cels_count   : integer := 5;
    virgPos      : integer := 7;
    Mem_use      : integer := use_RAM
    );
  port (
    rst             : in  std_logic;
    clk             : in  std_logic;
    apbi            : in  apb_slv_in_type;
    apbo            : out apb_slv_out_type;
--    sample_clk      : in  std_logic;
    sample_clk_out  : out std_logic;
    GOtest : out std_logic;
--    sample_in   :   in  samplT(ChanelsCount-1 downto 0,Sample_SZ-1 downto 0);
--    sample_out  :   out samplT(ChanelsCount-1 downto 0,Sample_SZ-1 downto 0);
    CoefsInitVal : in std_logic_vector((Cels_count*CoefCntPerCel*Coef_SZ)-1 downto 0) := (others => '1')
    );
end entity;


architecture AR_APB_IIR_Filter of APB_IIR_Filter is

constant REVISION : integer := 1;

constant pconfig : apb_config_type := (
  0 => ahb_device_reg (VENDOR_LPP, LPP_IIR_CEL_FILTER, 0, REVISION, 0),
  1 => apb_iobar(paddr, pmask));



type FILTERreg is record
  Config     :   std_logic;
  SampleIN    :   samplT(ChanelsCount-1 downto 0,Sample_SZ-1 downto 0);
  SampleOUT   :  samplT(ChanelsCount-1 downto 0,Sample_SZ-1 downto 0);
    regin     :   in_IIR_CEL_reg;
  regout    :   out_IIR_CEL_reg;
end record;

signal Rdata	  :  std_logic_vector(31 downto 0);
signal  r : FILTERreg;
signal  filter_reset    :   std_logic:='0';
signal  smp_cnt : integer :=0;
signal  sample_clk_out_R : std_logic;
signal  RawCoefs       :     std_logic_vector(((Coef_SZ*CoefCntPerCel*Cels_count)-1) downto 0);

signal    sample_clk      : std_logic;
--signal    sample_in   :   samplT(ChanelsCount-1 downto 0,Sample_SZ-1 downto 0);
--signal     sample_out  :   samplT(ChanelsCount-1 downto 0,Sample_SZ-1 downto 0);

type    CoefCelT  is array(0 to (CoefCntPerCel/2)-1) of std_logic_vector(Coef_SZ-1 downto 0);
type    CoefTblT  is array(0 to Cels_count-1) of CoefCelT;

type    CoefsRegT is record
        numCoefs    : CoefTblT;
        denCoefs    : CoefTblT;
end record;

signal  CoefsReg   : CoefsRegT;
signal  CoefsReg_d   : CoefsRegT;


begin

filter_reset    <=  rst and r.regin.config(0);
sample_clk_out  <=  r.Config;

filter : IIR_CEL_FILTER
generic map(tech,Sample_SZ,ChanelsCount,Coef_SZ,CoefCntPerCel,Cels_count,Mem_use)
port map(
    reset       =>  filter_reset,
    clk         =>  clk,
    sample_clk  =>  r.Config,
    regs_in     =>  r.regin,
    regs_out    =>  r.regout,
    sample_in   =>  r.SampleIN,
    sample_out  =>  r.SampleOUT,
    GOtest => GOtest,
    coefs       =>  RawCoefs
    );

--process(rst,sample_clk)
--begin
--if rst = '0' then
--    smp_cnt <= 0;
--    sample_clk_out_R <= '0';
--elsif r.Config'event and r.Config = '1' then
--  if smp_cnt = 1 then
--    smp_cnt <= 0;
--    sample_clk_out_R <= not sample_clk_out_R;
--  else
--    smp_cnt <= smp_cnt +1;
--  end if;
--end if;
--end process;


coefsConnectL0: for z in 0 to Cels_count-1 generate
     coefsConnectL1: for y in 0 to (CoefCntPerCel/2)-1 generate
		          RawCoefs(((((z*CoefCntPerCel+y)+1)*Coef_SZ)-1) downto (((z*CoefCntPerCel+y))*Coef_SZ) )     <=   CoefsReg_d.numCoefs(z)(y)(Coef_SZ-1 downto 0);
		          RawCoefs(((((z*CoefCntPerCel+y+(CoefCntPerCel/2))+1)*Coef_SZ)-1) downto ((z*CoefCntPerCel+y+(CoefCntPerCel/2))*Coef_SZ))   <=   CoefsReg_d.denCoefs(z)(y)(Coef_SZ-1 downto 0);
     end generate;
end generate;


process(rst,clk)
begin
    if rst = '0' then
        r.regin.virgPos          <= std_logic_vector(to_unsigned(virgPos,5));
coefsRstL0: for z in 0 to Cels_count-1 loop
     coefsRstL1: for y in 0 to (CoefCntPerCel/2)-1 loop
                     CoefsReg.numCoefs(z)(y)  <= CoefsInitVal(((((z*CoefCntPerCel+y)+1)*Coef_SZ)-1) downto (((z*CoefCntPerCel+y))*Coef_SZ) );
                     CoefsReg.denCoefs(z)(y)  <= CoefsInitVal(((((z*CoefCntPerCel+y+(CoefCntPerCel/2))+1)*Coef_SZ)-1) downto ((z*CoefCntPerCel+y+(CoefCntPerCel/2))*Coef_SZ));
     end loop;
end loop;
    elsif clk'event and clk = '1' then
    CoefsReg_d <=     CoefsReg;

--APB Write OP
        if (apbi.psel(pindex) and apbi.penable and apbi.pwrite) = '1' then
           case apbi.paddr(7 downto 2) is
                when "000000" =>
                     r.Config <= apbi.pwdata(0);
                when "000001" =>
                     r.SampleIN <= apbi.pwdata(17 downto 0);
                when "000011" =>
                     r.regin.config(0) <= apbi.pwdata(0);
                when "000100" =>
                     r.regin.virgPos <= apbi.pwdata(4 downto 0);
                when others =>
                   for i in 0 to Cels_count-1 loop
                   for j in 0 to (CoefCntPerCel/2) - 1  loop
                       if apbi.paddr(9 downto 2) = std_logic_vector(TO_UNSIGNED((2+ (i*(CoefCntPerCel/2))+j),8)) then
                           CoefsReg.numCoefs(i)(j)        <=  apbi.pwdata(Coef_SZ-1 downto 0);
                           CoefsReg.denCoefs(i)(j)        <=  apbi.pwdata((Coef_SZ+15) downto 16);
                       end if;
                   end loop;
                   end loop;
            end case;
        end if;

--APB Read OP
        if (apbi.psel(pindex) and (not apbi.pwrite)) = '1' then
            case apbi.paddr(7 downto 2)is
                when "000000" =>
                     Rdata(31 downto 1) <= (others => '0');
                     Rdata(0) <= r.Config;
                when "000001" =>
                     Rdata(31 downto 18) <= (others => '0');
                     Rdata(17 downto 0) <= r.SampleIN;
                when "000010" =>
                     Rdata(31 downto 18) <= (others => '0');
                     Rdata(17 downto 0) <= r.SampleOUT;
                when "000011" =>
                     Rdata(7 downto 0)   <=   std_logic_vector(TO_UNSIGNED(ChanelsCount,8));
                     Rdata(15 downto 8)  <=   std_logic_vector(TO_UNSIGNED(Sample_SZ,8));
                     Rdata(23 downto 16) <=   std_logic_vector(TO_UNSIGNED(CoefCntPerCel,8));
                     Rdata(31 downto 24) <=   std_logic_vector(TO_UNSIGNED(Cels_count,8));
                when "000100" =>
                     Rdata(4 downto 0)   <=   r.regin.virgPos;
                     Rdata(15 downto 8)  <=   std_logic_vector(TO_UNSIGNED(Coef_SZ,8));
                     Rdata(7 downto 5)   <=   (others => '0');
                     Rdata(31 downto 16) <=   (others => '0');
                when others =>
                    for i in 0 to Cels_count-1 loop
                    for j in 0 to (CoefCntPerCel/2) - 1  loop
                        if apbi.paddr(9 downto 2) = std_logic_vector(TO_UNSIGNED((2+ (i*(CoefCntPerCel/2))+j),8)) then
                           Rdata(Coef_SZ-1 downto 0)      <= CoefsReg_d.numCoefs(i)(j);
                           Rdata((Coef_SZ+15) downto 16)  <= CoefsReg_d.denCoefs(i)(j);
                        end if;
                    end loop;
                  end loop;
           end case;
        end if;
    end if;
    apbo.pconfig <= pconfig;
end process;

apbo.prdata <=	Rdata when apbi.penable = '1' ;


end architecture;

