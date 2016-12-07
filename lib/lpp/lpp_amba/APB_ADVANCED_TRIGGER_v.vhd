------------------------------------------------------------------------------
--  This file is a part of the LPP VHDL IP LIBRARY
--  Copyright (C) 2016, Laboratory of Plasmas Physic - CNRS
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
------------------------------------------------------------------------------
--                    Author : Alexis Jeandet
--                     Mail : alexis.jeandet@lpp.polytechnique.fr
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;
library lpp;
use lpp.apb_devices_list.all;
use lpp.lpp_amba.all;
use lpp.general_purpose.TimeGenAdvancedTrigger;


entity APB_ADVANCED_TRIGGER_v is
  generic (
    pindex   : integer;
    paddr    : integer;
    count    : integer range 1 to 16 := 1
  );
  port (
    rstn   : in  std_ulogic;
    clk    : in  std_ulogic;
    apbi   : in  apb_slv_in_type;
    apbo   : out apb_slv_out_type;

    SPW_Tickout : IN STD_LOGIC;
    CoarseTime  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    FineTime    : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

    Trigger     : OUT STD_LOGIC_VECTOR(count-1 DOWNTO 0)
    );
end;


architecture beh of APB_ADVANCED_TRIGGER_v is

constant REVISION : integer := 1;

constant pconfig : apb_config_type := (
  0 => ahb_device_reg (VENDOR_LPP, LPP_APB_ADVANCED_TRIGGER_v, 0, REVISION, 0),
  1 => apb_iobar(paddr,  16#fff#));



type adv_trig_type is record
    TrigPeriod    :  STD_LOGIC_VECTOR(3 DOWNTO 0);   -- In seconds 0 to 15
    TrigShift     :  STD_LOGIC_VECTOR(15 DOWNTO 0);  -- In FineTime steps
    Restart       :  STD_LOGIC;
    StartDate     :  STD_LOGIC_VECTOR(31 DOWNTO 0);  -- Date in seconds since epoch
    BypassTickout :  STD_LOGIC; -- if set then Trigger output is driven by SPW tickout
end record;

type adv_trig_regs is record
    CFG       :  STD_LOGIC_VECTOR(31 DOWNTO 0);
    Restart   :  STD_LOGIC_VECTOR(31 DOWNTO 0);
    StartDate :  STD_LOGIC_VECTOR(31 DOWNTO 0);
end record;

type adv_trig_regs_array is array(count-1 downto 0) of adv_trig_regs;
type adv_trig_type_array is array(count-1 downto 0) of adv_trig_type;

signal r : adv_trig_regs_array;
signal adv_trig : adv_trig_type_array;
signal Rdata     : std_logic_vector(31 downto 0);


begin


adv_trig_loop: FOR I IN 0 TO count-1 GENERATE
  adv_trig_i: TimeGenAdvancedTrigger
      PORT MAP(
          clk         =>  clk,
          rstn        =>  rstn,

          SPW_Tickout =>  SPW_Tickout,

          CoarseTime  =>  CoarseTime,
          FineTime    =>  FineTime,

          TrigPeriod  =>  adv_trig(i).TrigPeriod,
          TrigShift   =>  adv_trig(i).TrigShift,
          Restart     =>  adv_trig(i).Restart,
          StartDate   =>  adv_trig(i).StartDate,

          BypassTickout =>  adv_trig(i).BypassTickout,
          Trigger     =>  Trigger(i)

      );

    adv_trig(i).BypassTickout <= r(i).CFG(0);
    adv_trig(i).TrigPeriod    <= r(i).CFG(7 downto 4);
    adv_trig(i).TrigShift     <= r(i).CFG(31 downto 16);
    adv_trig(i).Restart       <= r(i).Restart(0);
    adv_trig(i).StartDate     <= r(i).StartDate;
END GENERATE;

process(rstn,clk)
  Variable I : integer :=0;
begin
    if rstn = '0' then
        rst_loop: FOR I IN 0 TO count-1 LOOP
          r(i).CFG(31 DOWNTO 1)   <= (others=>'0');
          r(i).CFG(0)     <= '0';
          r(i).Restart    <= (others=>'0');
          r(i).StartDate  <= (others=>'0');
        END LOOP;
    elsif clk'event and clk = '1' then
        I :=  to_integer(UNSIGNED(apbi.paddr(8-1 downto 4)));
--APB Write OP
        if (apbi.psel(pindex) and apbi.penable and apbi.pwrite) = '1' then
               case apbi.paddr(3 downto 2) is
                 when "00" =>
                     r(I).CFG <= apbi.pwdata;
                 when "01" =>
                     r(I).Restart <= apbi.pwdata;
                 when "10" =>
                     r(I).StartDate <= apbi.pwdata;
                 when others =>
                    null;
               end case;
        end if;

--APB READ OP
        if (apbi.psel(pindex) and (not apbi.pwrite)) = '1' then
            case apbi.paddr(3 downto 2) is
                when "00" =>
                    Rdata <= r(I).CFG;
                when "01" =>
                    Rdata <= r(I).Restart;
                when "10" =>
                    Rdata <= r(I).StartDate;
              when others =>
                  Rdata <= std_logic_vector(to_unsigned(count,32));
            end case;
        end if;

    end if;

end process;
apbo.pconfig    <=   pconfig;
apbo.prdata     <=   Rdata when apbi.penable = '1';
apbo.pirq    <= (OTHERS => '0');
apbo.pindex  <= pindex;

end beh;
