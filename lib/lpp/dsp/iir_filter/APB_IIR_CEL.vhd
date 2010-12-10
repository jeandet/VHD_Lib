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

entity APB_IIR_CEL is
  generic (
    pindex   : integer  := 0;
    paddr    : integer  := 0;
    pmask    : integer  := 16#fff#;
    pirq     : integer  := 0;
    abits    : integer  := 8;
    Sample_SZ : integer := 16;
    ChanelsCount : integer := 1;
	 Coef_SZ      : integer := 9;
	 CoefCntPerCel: integer := 3;
	 Cels_count   : integer := 5;
	 virgPos      : integer := 3;
    Mem_use      : integer := use_RAM
    );
  port (
    rst             : in  std_logic;
    clk             : in  std_logic;
    apbi            : in  apb_slv_in_type;
    apbo            : out apb_slv_out_type;
    sample_clk      : in  std_logic;
    sample_clk_out  : out std_logic;
    sample_in   :   in  samplT(ChanelsCount-1 downto 0,Sample_SZ-1 downto 0);
    sample_out  :   out samplT(ChanelsCount-1 downto 0,Sample_SZ-1 downto 0)
    );
end;


architecture AR_APB_IIR_CEL of APB_IIR_CEL is 

constant REVISION : integer := 1;

constant pconfig : apb_config_type := (
  0 => ahb_device_reg (VENDOR_LPP, ROCKET_TM, 0, REVISION, 0),
  1 => apb_iobar(paddr, pmask));



type FILTERreg is record
  regin     :   in_IIR_CEL_reg;
  regout    :   out_IIR_CEL_reg;
end record;

signal Rdata	  :  std_logic_vector(31 downto 0);
signal  r : FILTERreg;
signal  filter_reset    :   std_logic:='0';
signal  smp_cnt : integer :=0;
signal  sample_clk_out_R : std_logic;


type    CoefCelT  is array(CoefCntPerCel-1 downto 0) of std_logic_vector(Coef_SZ-1 downto 0);
type    CoefTblT  is array(Cels_count-1 downto 0) of CoefCelT;

type    CoefsRegT is record
    numCoefs    : CoefTblT;
	 denCoefs    : CoefTblT;
end record;

signal  CoefsReg   : CoefsRegT;

begin

filter_reset    <=  rst and r.regin.config(0);
sample_clk_out  <=  sample_clk_out_R;

filter : IIR_CEL_FILTER
generic map(Sample_SZ,ChanelsCount,Coef_SZ,CoefCntPerCel,Cels_count,Mem_use)
port map(
    reset       =>  filter_reset,
    clk         =>  clk,
    sample_clk  =>  sample_clk,
    regs_in     =>  r.regin,
    regs_out    =>  r.regout,
    sample_in   =>  sample_in,
    sample_out  =>  sample_out   
    );

process(rst,sample_clk)
begin
if rst = '0' then
    smp_cnt <= 0;
    sample_clk_out_R <= '0';
elsif sample_clk'event and sample_clk = '1' then
  if smp_cnt = 1 then
    smp_cnt <= 0;
    sample_clk_out_R <= not sample_clk_out_R;
  else
    smp_cnt <= smp_cnt +1;
  end if;
end if;
end process;


process(rst,clk)
begin
    if rst = '0' then
        r.regin.virgPos          <= std_logic_vector(to_unsigned(virgPos,5));

    elsif clk'event and clk = '1' then


--APB Write OP
        if (apbi.psel(pindex) and apbi.penable and apbi.pwrite) = '1' then
            case apbi.paddr(7 downto 2) is
                when "000000" =>
                    r.regin.config(0) <= apbi.pwdata(0);
                when "000001" =>
                      r.regin.virgPos <= apbi.pwdata(4 downto 0);
                when others =>
                    for i in 0 to Cels_count-1 loop
                        if conv_integer(apbi.paddr(7 downto 5)) = i+1 then
                            case apbi.paddr(4 downto 2) is
                                when "000" =>
                                    CoefsReg.numCoefs(i)(0)  <=  (apbi.pwdata(Coef_SZ-1 downto 0));
                                when "001" =>
                                    CoefsReg.numCoefs(i)(1)  <=  (apbi.pwdata(Coef_SZ-1 downto 0));
                                when "010" =>
                                    CoefsReg.numCoefs(i)(2)  <=  (apbi.pwdata(Coef_SZ-1 downto 0));
                                when "011" =>
                                    CoefsReg.denCoefs(i)(0)  <=  (apbi.pwdata(Coef_SZ-1 downto 0));
                                when "100" =>
                                    CoefsReg.denCoefs(i)(1)  <=  (apbi.pwdata(Coef_SZ-1 downto 0));
                                when "101" =>
                                    CoefsReg.denCoefs(i)(2)  <=  (apbi.pwdata(Coef_SZ-1 downto 0));
                                when others =>
                            end case;
                        end if;
                    end loop;
            end case;
        end if;

--APB READ OP
        if (apbi.psel(pindex) and (not apbi.pwrite)) = '1' then
            case apbi.paddr(7 downto 2) is
                when "000000" =>
                    
                when "000001" =>
                    Rdata(4 downto 0) <=   r.regin.virgPos;
                when others =>
                    for i in 0 to Cels_count-1 loop
                        if conv_integer(apbi.paddr(7 downto 5)) = i+1 then
                            case apbi.paddr(4 downto 2) is
                                when "000" =>
                                    Rdata(Coef_SZ-1 downto 0)  <= std_logic_vector(CoefsReg.numCoefs(i)(0));
                                when "001" =>
                                    Rdata(Coef_SZ-1 downto 0)  <=  std_logic_vector(CoefsReg.numCoefs(i)(1));
                                when "010" =>
                                    Rdata(Coef_SZ-1 downto 0)  <=  std_logic_vector(CoefsReg.numCoefs(i)(2));
                                when "011" =>
                                    Rdata(Coef_SZ-1 downto 0)  <=  std_logic_vector(CoefsReg.denCoefs(i)(0));
                                when "100" =>
                                    Rdata(Coef_SZ-1 downto 0)  <=  std_logic_vector(CoefsReg.denCoefs(i)(1));
                                when "101" =>
                                    Rdata(Coef_SZ-1 downto 0)  <=  std_logic_vector(CoefsReg.denCoefs(i)(2));
                                when others =>
                            end case;
                        end if;
                    end loop;
            end case;
        end if;
    
    end if;
    apbo.pconfig <= pconfig;
end process;

apbo.prdata <=	Rdata when apbi.penable = '1' ;

-- pragma translate_off
    bootmsg : report_version
    generic map ("apbuart" & tost(pindex) &
	": Generic UART rev " & tost(REVISION) & ", fifo " & tost(fifosize) &
	", irq " & tost(pirq));
-- pragma translate_on



end ar_APB_IIR_CEL;

