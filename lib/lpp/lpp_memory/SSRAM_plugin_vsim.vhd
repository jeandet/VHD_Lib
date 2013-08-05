------------------------------------------------------------------------------
--  This file is a part of the LPP VHDL IP LIBRARY
--  Copyright (C) 2011, Laboratory of Plasmas Physic - CNRS
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
library gaisler;
use gaisler.misc.all;
use gaisler.memctrl.all;
library techmap;
use techmap.gencomp.all;
use techmap.allclkgen.all;




entity ssram_plugin is 
generic (tech : integer := 0);
port
(
    clk             : in  std_logic;
    mem_ctrlr_o     : in  memory_out_type;
    SSRAM_CLK       : out std_logic;
    nBWa            : out std_logic;
    nBWb            : out std_logic;
    nBWc            : out std_logic;
    nBWd            : out std_logic;
    nBWE            : out std_logic;
    nADSC           : out std_logic;
    nADSP           : out std_logic;
    nADV            : out std_logic;
    nGW             : out std_logic;
    nCE1            : out std_logic;
    CE2             : out std_logic;
    nCE3            : out std_logic;
    nOE             : out std_logic;
    MODE            : out std_logic;
    ZZ              : out std_logic
);
end entity;






architecture ar_ssram_plugin of ssram_plugin is


signal nADSPint : std_logic:='1';
signal nOEint   : std_logic:='1';
signal RAMSN_reg: std_logic:='1';
signal OEreg    : std_logic:='1';
signal nBWaint   : std_logic:='1';
signal nBWbint   : std_logic:='1';
signal nBWcint   : std_logic:='1';
signal nBWdint   : std_logic:='1';
signal nBWEint   : std_logic:='1';
signal nCE1int   : std_logic:='1';
signal CE2int    : std_logic:='0';
signal nCE3int   : std_logic:='1';

Type stateT is (idle,st1,st2,st3,st4);
signal state : stateT;

SIGNAL nclk : STD_LOGIC;

begin

process(clk , mem_ctrlr_o.RAMSN(0))
begin
    if mem_ctrlr_o.RAMSN(0) ='1' then
        state   <=  idle;
    elsif clk ='1' and clk'event then
        case state is
            when idle =>
                state   <=  st1;
            when st1 =>
                state   <=  st2;
            when st2 =>
                state   <=  st3;
            when st3 =>
                state   <=  st4;
            when st4 =>
                state   <=  st1;
        end case;
    end if;
end process;

nclk <= NOT clk;
ssram_clk_pad : outpad generic map (tech => tech)
    port map (SSRAM_CLK,nclk);


nBWaint  <=  mem_ctrlr_o.WRN(3)or mem_ctrlr_o.ramsn(0);
nBWa_pad : outpad generic map (tech => tech)
    port map (nBWa,nBWaint);

nBWbint  <=  mem_ctrlr_o.WRN(2)or mem_ctrlr_o.ramsn(0);
nBWb_pad : outpad generic map (tech => tech)
    port map (nBWb, nBWbint);

nBWcint  <=  mem_ctrlr_o.WRN(1)or mem_ctrlr_o.ramsn(0);
nBWc_pad : outpad generic map (tech => tech)
    port map (nBWc, nBWcint);

nBWdint  <=  mem_ctrlr_o.WRN(0)or mem_ctrlr_o.ramsn(0);
nBWd_pad : outpad generic map (tech => tech)
    port map (nBWd, nBWdint);

nBWEint  <=  mem_ctrlr_o.WRITEN or mem_ctrlr_o.ramsn(0);
nBWE_pad : outpad generic map (tech => tech)
    port map (nBWE, nBWEint);

nADSC_pad : outpad generic map (tech => tech)
    port map (nADSC, '1');

--nADSPint    <=  not((RAMSN_reg xor mem_ctrlr_o.RAMSN(0)) and RAMSN_reg);
nADSPint    <=  '0' when state = st1 else '1';

process(clk)
begin
    if clk'event and clk = '1' then
        RAMSN_reg   <=  mem_ctrlr_o.RAMSN(0);
    end if;
end process;

nADSP_pad : outpad generic map (tech => tech)
    port map (nADSP, nADSPint);

nADV_pad : outpad generic map (tech => tech)
    port map (nADV, '1');       

nGW_pad : outpad generic map (tech => tech)
    port map (nGW, '1');

nCE1int <= nADSPint or mem_ctrlr_o.address(31) or (not mem_ctrlr_o.address(30)) or mem_ctrlr_o.address(29)  or mem_ctrlr_o.address(28);
CE2int <= (not mem_ctrlr_o.address(27)) and (not mem_ctrlr_o.address(26)) and (not mem_ctrlr_o.address(25))  and (not mem_ctrlr_o.address(24));
nCE3int <= mem_ctrlr_o.address(23) or mem_ctrlr_o.address(22) or mem_ctrlr_o.address(21)  or mem_ctrlr_o.address(20);

nCE1_pad : outpad generic map (tech => tech)
    port map (nCE1, nCE1int);

CE2_pad : outpad generic map (tech => tech)
    port map (CE2, CE2int);

nCE3_pad : outpad generic map (tech => tech)
    port map (nCE3, nCE3int);

nOE_pad : outpad generic map (tech => tech)
    port map (nOE, nOEint);

process(clk)
begin
    if clk'event and clk = '1' then
        OEreg   <=  mem_ctrlr_o.OEN;
    end if;
end process;

 
--nOEint  <=  OEreg or mem_ctrlr_o.RAMOEN(0);	
nOEint  <=  '0' when state = st2 or state = st3 or state = st4 else '1';	
 
MODE_pad : outpad generic map (tech => tech)
    port map (MODE, '0');      

ZZ_pad : outpad generic map (tech => tech)
    port map (ZZ, '0');

end architecture;
