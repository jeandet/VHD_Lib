-----------------------------------------------------------------------------
--  LEON3 Xilinx SP605 Demonstration design
--  Copyright (C) 2011 Jiri Gaisler, Aeroflex Gaisler
------------------------------------------------------------------------------
--  This file is a part of the GRLIB VHDL IP LIBRARY
--  Copyright (C) 2003 - 2008, Gaisler Research
--  Copyright (C) 2008 - 2011, Aeroflex Gaisler
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
------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
library grlib, techmap;
use grlib.amba.all;
use grlib.amba.all;
use grlib.stdlib.all;
use techmap.gencomp.all;
use techmap.allclkgen.all;
library gaisler;
use gaisler.memctrl.all;
use gaisler.leon3.all;
use gaisler.uart.all;
use gaisler.misc.all;
--use gaisler.sim.all;
library lpp;
use lpp.lpp_ad_conv.all;
use lpp.lpp_amba.all;
use lpp.apb_devices_list.all;
use lpp.general_purpose.all;


use work.Convertisseur_config.all;

library esa;
use esa.memoryctrl.all;

use work.config.all;

entity ici4 is
  generic (
    fabtech       : integer := CFG_FABTECH;
    memtech       : integer := CFG_MEMTECH;
    padtech       : integer := CFG_PADTECH;
    clktech       : integer := CFG_CLKTECH;
WordSize : integer := 8; WordCnt    :   integer := 144;MinFCount   :   integer := 64
  );
  port (
    reset       : in  std_ulogic;
    clk         : in  std_ulogic;
    sclk    :   in  std_logic;
    Gate    :   in  std_logic;
    MinF    :   in  std_logic;
    MajF    :   in  std_logic;
    Data    :   out std_logic;
    DC_ADC_Sclk     :   out std_logic;
    DC_ADC_IN       :   in  std_logic_vector(3 downto 0);
    DC_ADC_FORMAT   :   out std_logic_vector(2 downto 0);
    DC_ADC_Mode     :   out std_logic_vector(1 downto 0);
    DC_ADC_ClkDiv   :   out std_logic;
    DC_ADC_PWDOWN   :   out std_logic_vector(3 downto 0);
    DC_ADC_FSynch   :   out std_logic;
    DC_ADC_Synch    :   out std_logic;
--    DATA_out_Test   :   out std_logic;
--    Sclk_out_test   :   out std_logic;
--    Synch_out_test  :   out std_logic;  
    test            :   out std_logic;  

    LF_ADC_Sclk     :   out std_logic;
    LF_ADC_IN       :   in  std_logic_vector(3 downto 0);
    LF_ADC_FORMAT   :   out std_logic_vector(2 downto 0);
    LF_ADC_Mode     :   out std_logic_vector(1 downto 0);
    LF_ADC_ClkDiv   :   out std_logic;
    LF_ADC_PWDOWN   :   out std_logic_vector(3 downto 0);
    LF_ADC_FSynch   :   out std_logic;
    LF_ADC_Synch    :   out std_logic
   );
end;

architecture rtl of ici4 is

signal  clk_buf,reset_buf   :   std_logic;

Constant FramePlacerCount    :   integer := 2;

signal  MinF_Inv    :   std_logic;
signal  Gate_Inv    :   std_logic;
signal  sclk_Inv    :   std_logic;
signal  WordCount   :   integer range 0 to WordCnt-1;
signal  WordClk     :   std_logic;

signal  MuxOUT      :   std_logic_vector(WordSize-1 downto 0);
signal  MuxIN       :   std_logic_vector((2*WordSize)-1 downto 0);
signal  Sel         :   integer range 0 to 1;

signal  DC1     :     std_logic_vector(23 downto 0);
signal  DC2     :     std_logic_vector(23 downto 0);
signal  DC3     :     std_logic_vector(23 downto 0);


signal  LF1     :     std_logic_vector(15 downto 0);
signal  LF2     :     std_logic_vector(15 downto 0);
signal  LF3     :     std_logic_vector(15 downto 0);


signal  LF1_int    :     std_logic_vector(23 downto 0);
signal  LF2_int    :     std_logic_vector(23 downto 0);
signal  LF3_int    :     std_logic_vector(23 downto 0);


--constant DC1cst :   std_logic_vector(23 downto 0) := X"FA5961";
--constant DC2cst :   std_logic_vector(23 downto 0) := X"123456";
--constant DC3cst :   std_logic_vector(23 downto 0) := X"789012";
--
--constant LF1cst :   std_logic_vector(15 downto 0) := X"3210";
--constant LF2cst :   std_logic_vector(15 downto 0) := X"6543";
--constant LF3cst :   std_logic_vector(15 downto 0) := X"3456";
--

signal   DC_ADC_SmplClk  :    std_logic;
signal   LF_ADC_SmplClk  :    std_logic;

signal  MinFCnt   :   integer range 0 to MinFCount-1;

signal  FramePlacerFlags    :   std_logic_vector(FramePlacerCount-1 downto 0);

begin

--CLKINT0 : CLKINT
--    port map(clk,clk_buf);
--    
--CLKINT1 : CLKINT
--    port map(reset,reset_buf);

clk_buf   <= clk;
reset_buf <= reset;
--    
--DATA_out_Test   <=  DC_ADC_IN(0);
--Sclk_out_test   <=  DC_ADC_Sclk;
--Synch_out_test  <=  DC_ADC_FSynch;

Gate_Inv    <=  not Gate;
sclk_Inv    <=  not Sclk;
MinF_Inv    <=  not MinF;

--DC1 <=  DC1cst;
--DC2 <=  DC2cst;
--DC3 <=  DC3cst;

--LF1 <=  LF1cst;
--LF2 <=  LF2cst;
--LF3 <=  LF3cst;

SD0 : entity work.Serial_Driver 
generic map(WordSize)
port map(sclk_Inv,MuxOUT,Gate_inv,Data);

WC0 :   entity work.Word_Cntr
generic map(WordSize,WordCnt)
port map(sclk_Inv,MinF,WordClk,WordCount);

MFC0 : entity work.MinF_Cntr
generic map(MinFCount)
port map(
    clk     =>  MinF_Inv,
    reset   =>  MajF,
    Cnt_out =>  MinFCnt
);


MUX0 : entity work.Serial_Driver_Multiplexor
generic map(FramePlacerCount,WordSize)
port map(sclk_Inv,Sel,MuxIN,MuxOUT);


DCFP0 : entity work.DC_FRAME_PLACER 
generic map(WordSize,WordCnt,MinFCount)
port map(
    clk     =>  Sclk,
    Wcount  =>  WordCount,
    MinFCnt =>  MinFCnt,
    Flag    =>  FramePlacerFlags(0),
    DC1     =>  DC1,
    DC2     =>  DC2,
    DC3     =>  DC3,
    WordOut =>  MuxIN(7 downto 0));



LFP0 : entity  work.LF_FRAME_PLACER
generic map(WordSize,WordCnt,MinFCount)
port map(
    clk     =>  Sclk,
    Wcount  =>  WordCount,
    Flag    =>  FramePlacerFlags(1),
    LF1     =>  LF1,
    LF2     =>  LF2,
    LF3     =>  LF3,
    WordOut =>  MuxIN(15 downto 8));



DC_SMPL_CLK0 : entity work.DC_SMPL_CLK 
port map(MinF_Inv,DC_ADC_SmplClk);


DC_ADC_Synch    <=  reset;
LF_ADC_Synch    <=  reset;

DC_ADC0 : ADS1274_DRIVER                      --With AMR down ! => 24bits DC TM -> SC high res on Spin
generic map(ADS127X_MODE_low_power,ADS127X_FSYNC_FORMAT)
port map(
    Clk     =>  clk_buf,
    reset   =>  reset_buf,
    SpiClk  =>  DC_ADC_Sclk,
    DIN     =>  DC_ADC_IN,
    Ready   =>  '0',
    Format  =>  DC_ADC_Format,
    Mode    =>  DC_ADC_Mode,
    ClkDiv  =>  DC_ADC_ClkDiv,
    PWDOWN  =>  DC_ADC_PWDOWN,
    SmplClk =>  DC_ADC_SmplClk,
    OUT0    =>  DC1,
    OUT1    =>  DC2,
    OUT2    =>  DC3,
    OUT3    =>  open,
    FSynch  =>  DC_ADC_FSynch,
    test    =>  test
);


LF_SMPL_CLK0 : entity work.LF_SMPL_CLK
port map(
    Wclck    => WordClk,
    MinF     => MinF,
    SMPL_CLK => LF_ADC_SmplClk
);

LF_ADC0 : ADS1274_DRIVER 
generic map(ADS127X_MODE_low_power,ADS127X_FSYNC_FORMAT)
port map(
    Clk     =>  clk_buf,
    reset   =>  reset_buf,
    SpiClk  =>  LF_ADC_Sclk,
    DIN     =>  LF_ADC_IN,
    Ready   =>  '0',
    Format  =>  LF_ADC_Format,
    Mode    =>  LF_ADC_Mode,
    ClkDiv  =>  LF_ADC_ClkDiv,
    PWDOWN  =>  LF_ADC_PWDOWN,
    SmplClk =>  LF_ADC_SmplClk,
    OUT0    =>  LF1_int,
    OUT1    =>  LF2_int,
    OUT2    =>  LF3_int,
    OUT3    =>  open,
    FSynch  =>  LF_ADC_FSynch
);


LF1     <=  LF1_int(23 downto 8);
LF2     <=  LF2_int(23 downto 8);
LF3     <=  LF3_int(23 downto 8);
--
--DC1     <=  LF1_int(23 downto 0);
--DC2     <=  LF2_int(23 downto 0);
--DC3     <=  LF3_int(23 downto 0);

--Input Word Selection Decoder

process(clk)
variable SelVar :   integer range 0 to 1;
begin
    if clk'event and clk ='1' then
        Decoder: FOR i IN 0 to FramePlacerCount-1 loop
            if FramePlacerFlags(i) = '1' then
                SelVar := i;
            end if;
        END loop Decoder;
        Sel <=  SelVar;
    end if;
end process;


end rtl;


 
