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
library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
library lpp;
use lpp.iir_filter.all;
use lpp.FILTERcfg.all;
use lpp.general_purpose.all;

--TODO améliorer la gestion de la RAM et de la flexibilité du filtre

entity  FilterCTRLR is
port(
    reset       :   in  std_logic;
    clk         :   in  std_logic;
    sample_clk  :   in  std_logic;
    ALU_Ctrl    :   out std_logic_vector(3 downto 0);
    sample_in   :   in  samplT;
    coef        :   out std_logic_vector(Coef_SZ-1 downto 0);
    sample      :   out std_logic_vector(Smpl_SZ-1 downto 0)
);
end FilterCTRLR;


architecture ar_FilterCTRLR of FilterCTRLR is

constant    NUMCoefsCnt     :   integer:= NumeratorCoefs'high;
constant    DENCoefsCnt     :   integer:= DenominatorCoefs'high;

signal      NcoefCnt         :   integer range 0 to NumeratorCoefs'high:=0;
signal      DcoefCnt         :   integer range 0 to DenominatorCoefs'high:=0;

signal  chanelCnt   :   integer range 0 to 15:=0;

signal  WD          :   std_logic_vector(35 downto 0); 
signal  WD_D        :   std_logic_vector(35 downto 0); 
signal  RD          :   std_logic_vector(35 downto 0);
signal  WEN, REN,WEN_D    :   std_logic; 
signal  WADDR_back  :   std_logic_vector(7 downto 0); 
signal  ADDR        :   std_logic_vector(7 downto 0); 
signal  ADDR_D      :   std_logic_vector(7 downto 0);
signal  clk_inv     :   std_logic;

type    Rotate_BuffT is array(ChanelsCNT-1 downto 0) of std_logic_vector(Smpl_SZ-1 downto 0);
signal  in_Rotate_Buff  :   Rotate_BuffT;
signal  out_Rotate_Buff :   Rotate_BuffT;

signal  sample_clk_old  :   std_logic;

type    stateT  is  (waiting,computeNUM,computeDEN,NextChanel);
signal  state   :   stateT;  
  
begin
clk_inv <=  not clk;

process(clk,reset)
begin
if reset = '0' then
    state       <=  waiting;
    WEN         <=  '1';
    REN         <=  '1';
    ADDR        <=  (others => '0');
    WD          <=  (others => '0');
    NcoefCnt    <=  0;
    DcoefCnt    <=  0;
    chanelCnt   <=  0;
    ALU_Ctrl    <=  clr_mac;
    sample_clk_old  <=  '0';
    coef        <=  (others => '0');
    sample      <=  (others => '0');
rst:for i in 0 to ChanelsCNT-1 loop
        in_Rotate_Buff(i)    <=  (others => '0');
      end loop;
elsif clk'event and clk = '1' then

    sample_clk_old  <=  sample_clk;

--=================================================================
--===============DATA processing===================================
--=================================================================
    case state is
        when    waiting=>
            
            if sample_clk_old = '0' and sample_clk = '1' then
                ALU_Ctrl    <=  MAC_op;
                sample      <=  in_Rotate_Buff(0);
                coef        <=  std_logic_vector(NumeratorCoefs(0));
            else
                ALU_Ctrl    <=  clr_mac;
loadinput:      for i in 0 to ChanelsCNT-1 loop
                    in_Rotate_Buff(i)    <=  sample_in(i);
                end loop;
            end if;

        when    computeNUM=>
            ALU_Ctrl    <=  MAC_op;
            sample      <=  RD(Smpl_SZ-1 downto 0);
            coef        <=  std_logic_vector(NumeratorCoefs(NcoefCnt));

        when    computeDEN=>
            ALU_Ctrl    <=  MAC_op;
            sample      <=  RD(Smpl_SZ-1 downto 0);
            coef        <=  std_logic_vector(DenominatorCoefs(DcoefCnt));

        when    NextChanel=>
rotate :    for i in 0 to ChanelsCNT-2 loop
                in_Rotate_Buff(i)    <=  in_Rotate_Buff(i+1);
            end loop;
rotatetoo:  if ChanelsCNT > 1 then
                sample      <=  in_Rotate_Buff(1);
                coef        <=  std_logic_vector(NumeratorCoefs(0));
            end if;
    end case;

--=================================================================
--===============RAM read write====================================
--=================================================================
    case state is
        when    waiting=>
            if sample_clk_old = '0' and sample_clk = '1' then
                REN     <=  '0';
            else
                REN     <=  '1';
            end if;
            ADDR        <=  (others => '0');
            WD(Smpl_SZ-1 downto 0) <=  in_Rotate_Buff(0);
            WEN     <=  '1';
            
        when    computeNUM=>
            WD      <=  RD;
            REN     <=  '0';
            WEN     <=  '0';
            ADDR    <=  std_logic_vector(unsigned(ADDR)+1);
        when    computeDEN=>
            WD      <=  RD;
            REN     <=  '0';
            WEN     <=  '0';
            ADDR    <=  std_logic_vector(unsigned(ADDR)+1);
        when    NextChanel=>
            REN     <=  '1';
            WEN     <=  '1';
    end case;
--=================================================================


--=================================================================
--===============FSM Management====================================
--=================================================================
    case state is
        when    waiting=>
            if sample_clk_old = '0' and sample_clk = '1' then
                state   <=  computeNUM;
            end if;
            DcoefCnt    <=  0;
            NcoefCnt    <=  1;
            chanelCnt<= 0;
        when    computeNUM=>
            if NcoefCnt = NumCoefsCnt then
                state   <=  computeDEN;
                NcoefCnt <=  1;
            else
                NcoefCnt <=  NcoefCnt+1;
            end if;
        when    computeDEN=>
            if DcoefCnt = DENCoefsCnt then
                state   <=  NextChanel;
                DcoefCnt <=  0;
            else
                DcoefCnt <=  DcoefCnt+1;
            end if;
        when    NextChanel=>
            if chanelCnt = (ChanelsCNT-1) then
                state   <=  waiting;
            else
                chanelCnt<= chanelCnt+1;
                state    <=  computeNUM;
            end if;
    end case;
--=================================================================

end if;
end process;

ADDRreg : REG
generic map(size    => 8)
port map(
    reset   =>  reset,
    clk     =>  clk,
    D       =>  ADDR,
    Q       =>  ADDR_D
);

WDreg :REG
generic map(size    => 36)
port map(
    reset   =>  reset,
    clk     =>  clk,
    D       =>  WD,
    Q       =>  WD_D
);

WRreg :REG
generic map(size    => 1)
port map(
    reset   =>  reset,
    clk     =>  clk,
    D(0)    =>  WEN,
    Q(0)    =>  WEN_D
);
--==============================================================
--=========================R A M================================
--==============================================================
memRAM :   if Mem_use = use_RAM generate
RAMblk :RAM 
    port map( 
    WD      =>  WD_D,
    RD      =>  RD,
    WEN     =>  WEN_D,
    REN     =>  REN,
    WADDR   =>  ADDR_D,
    RADDR   =>  ADDR,
    RWCLK   =>  clk_inv,
    RESET   =>  reset
        ) ;
end generate;

memCEL :   if Mem_use = use_CEL generate
RAMblk :RAM 
    port map( 
    WD      =>  WD_D,
    RD      =>  RD,
    WEN     =>  WEN_D,
    REN     =>  REN,
    WADDR   =>  ADDR_D,
    RADDR   =>  ADDR,
    RWCLK   =>  clk_inv,
    RESET   =>  reset
        ) ;
end generate;

--==============================================================



end ar_FilterCTRLR;
