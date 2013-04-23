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
use lpp.FILTERcfg.all;
use lpp.general_purpose.all;
--Maximum filter speed(smps/s) = Fclk/(Nchanels*Ncoefs)
--exemple 26MHz sys clock and 6 chanels @ 110ksmps/s 
--Ncoefs = 26 000 000 /(6 * 110 000) = 39 coefs

entity FILTER is 
generic(Smpl_SZ    :  integer := 16;
        ChanelsCNT :  integer := 3
);
port(

    reset       :   in  std_logic;
    clk         :   in  std_logic;
    sample_clk  :   in  std_logic;
    Sample_IN   :   in  std_logic_vector(Smpl_SZ*ChanelsCNT-1 downto 0);
    Sample_OUT  :   out std_logic_vector(Smpl_SZ*ChanelsCNT-1 downto 0)
);
end entity;





architecture ar_FILTER of FILTER is 




signal  ALU_ctrl    :   std_logic_vector(3 downto 0);
signal  Sample      :   std_logic_vector(Smpl_SZ-1 downto 0);
signal  Coef        :   std_logic_vector(Coef_SZ-1 downto 0);
signal  ALU_OUT     :   std_logic_vector(Smpl_SZ+Coef_SZ-1 downto 0);

begin

--==============================================================
--=========================A L U================================
--==============================================================
ALU1 : ALU 
generic map(
    Arith_en        =>  1,
    Logic_en        =>  0,
    Input_SZ_1      =>  Smpl_SZ,
    Input_SZ_2      =>  Coef_SZ

)
port map(
    clk     =>  clk,
    reset   =>  reset,
    ctrl    =>  ALU_ctrl,
    OP1     =>  Sample,
    OP2     =>  Coef,
    RES     =>  ALU_OUT
);
--==============================================================

--==============================================================
--===============F I L T E R   C O N T R O L E R================
--==============================================================
filterctrlr1 : FilterCTRLR 
port map(
    reset       =>  reset,
    clk         =>  clk,
    sample_clk  =>  sample_clk,
    ALU_Ctrl    =>  ALU_ctrl,
    sample_in   =>  sample_Tbl,
    coef        =>  Coef,
    sample      =>  Sample
);
--==============================================================

chanelCut : for i in 0 to ChanelsCNT-1 generate
    sample_Tbl(i)    <=  Sample_IN((i+1)*Smpl_SZ-1 downto i*Smpl_SZ);
end generate;




end ar_FILTER;

