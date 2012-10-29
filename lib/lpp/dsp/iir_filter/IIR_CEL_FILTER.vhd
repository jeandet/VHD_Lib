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

entity  IIR_CEL_FILTER is
generic(
        tech : integer := 0;
        Sample_SZ : integer := 16;
		  ChanelsCount : integer := 1;
		  Coef_SZ      : integer := 9;
		  CoefCntPerCel: integer := 6;
		  Cels_count   : integer := 5;
        Mem_use      : integer := use_RAM);
port(
    reset       :   in  std_logic;
    clk         :   in  std_logic;
    sample_clk  :   in  std_logic;
    regs_in     :   in  in_IIR_CEL_reg;
    regs_out    :   in  out_IIR_CEL_reg;
    sample_in   :   in  samplT(ChanelsCount-1 downto 0,Sample_SZ-1 downto 0);
    sample_out  :   out samplT(ChanelsCount-1 downto 0,Sample_SZ-1 downto 0);
    GOtest : out std_logic;
    coefs       :   in  std_logic_vector((Coef_SZ*CoefCntPerCel*Cels_count)-1 downto 0)
    
);
end IIR_CEL_FILTER;




architecture    ar_IIR_CEL_FILTER of IIR_CEL_FILTER is

signal  virg_pos : integer;
begin

virg_pos    <=  to_integer(unsigned(regs_in.virgPos));

CTRLR : IIR_CEL_CTRLR
generic map (tech,Sample_SZ,ChanelsCount,Coef_SZ,CoefCntPerCel,Cels_count,Mem_use)
port map(
    reset       =>  reset,
    clk         =>  clk,
    sample_clk  =>  sample_clk,
    sample_in   =>  sample_in,
    sample_out  =>  sample_out,
    virg_pos    =>  virg_pos,
    GOtest => GOtest,
    coefs       =>  coefs
);





end ar_IIR_CEL_FILTER;


















