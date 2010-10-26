------------------------------------------------------------------------------
--  This file is a part of the LPP VHDL IP LIBRARY
--  Copyright (C) 2009 - 2010, Laboratory of Plasmas Physic - CNRS
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
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
-- IIR_CEL_FILTER.vhd

library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
library lpp;
use lpp.iir_filter.all;
use lpp.FILTERcfg.all;
use lpp.general_purpose.all;

--TODO améliorer la gestion de la RAM et de la flexibilité du filtre

entity  IIR_CEL_FILTER is
generic(Sample_SZ : integer := 16);
port(
    reset       :   in  std_logic;
    clk         :   in  std_logic;
    sample_clk  :   in  std_logic;
    regs_in     :   in  in_IIR_CEL_reg;
    regs_out    :   in  out_IIR_CEL_reg;
    sample_in   :   in  samplT;
    sample_out  :   out samplT
    
);
end IIR_CEL_FILTER;




architecture    ar_IIR_CEL_FILTER of IIR_CEL_FILTER is

signal  virg_pos : integer;
begin

virg_pos    <=  to_integer(unsigned(regs_in.virgPos));


CTRLR : IIR_CEL_CTRLR
generic map (Sample_SZ => Sample_SZ)
port map(
    reset       =>  reset,
    clk         =>  clk,
    sample_clk  =>  sample_clk,
    sample_in   =>  sample_in,
    sample_out  =>  sample_out,
    virg_pos    =>  virg_pos,
    coefs       =>  regs_in.coefsTB
);





end ar_IIR_CEL_FILTER;


















