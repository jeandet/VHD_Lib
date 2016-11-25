-- TimeGenAdvancedTrigger.vhd
------------------------------------------------------------------------------
--  This file is a part of the LPP VHDL IP LIBRARY
--  Copyright (C) 2009 - 2016, Laboratory of Plasmas Physic - CNRS
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
LIBRARY IEEE;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_1164.ALL;

ENTITY TimeGenAdvancedTrigger IS
PORT(
    clk         : IN STD_LOGIC;
    rstn        : IN STD_LOGIC;

    SPW_Tickout : IN STD_LOGIC;

    CoarseTime  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    FineTime    : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

    TrigPeriod  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);   -- In seconds 0 to 15
    TrigShift   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);  -- In FineTime steps
    Restart     : IN STD_LOGIC;
    StartDate   : IN STD_LOGIC_VECTOR(31 DOWNTO 0);  -- Date in seconds since epoch

    BypassTickout : IN STD_LOGIC; -- if set then Trigger output is driven by SPW tickout
                                  -- else Trigger output is driven by advanced trig
    Trigger     : OUT STD_LOGIC

);

END TimeGenAdvancedTrigger;


ARCHITECTURE beh OF TimeGenAdvancedTrigger IS

SIGNAL AdvancedTrigger : STD_LOGIC:='0';
SIGNAL AdvancedTrigger_l0 : STD_LOGIC:='0';
SIGNAL AdvancedTrigger_l1 : STD_LOGIC:='0';
SIGNAL started : STD_LOGIC:='0';
SIGNAL periodCntr : STD_LOGIC_VECTOR(3 DOWNTO 0):=(OTHERS=>'0');
SIGNAL coarseTime0 :  STD_LOGIC:='0';


BEGIN

Trigger <= SPW_Tickout WHEN BypassTickout = '1' ELSE AdvancedTrigger;
AdvancedTrigger <= AdvancedTrigger_l0 AND AdvancedTrigger_l1;


PROCESS(clk,rstn)
BEGIN
IF rstn = '0' THEN
    started         <= '0';
    AdvancedTrigger_l0 <='0';
    AdvancedTrigger_l1 <='0';
    coarseTime0     <= '0';
    periodCntr  <= (OTHERS => '0');

ELSIF clk'event AND clk = '1' THEN

    coarseTime0 <= CoarseTime(0);

-- Detection of start date and handling of Restart
    IF Restart = '1'  THEN
        started <= '0';
    ELSIF StartDate = CoarseTime THEN
        started <= '1';
    END IF;

-- Fine time based comparator for phase shift
    IF TrigShift = FineTime THEN
        AdvancedTrigger_l0 <='1';
    ELSE
        AdvancedTrigger_l0 <='0';
    END IF;

-- Second filter, generates a pulse for each N seconds since StartDate
    IF started = '1' THEN
        IF periodCntr = "0000" THEN
            AdvancedTrigger_l1 <='1';
            periodCntr <= TrigPeriod;
        ELSIF CoarseTime(0) /= coarseTime0 THEN
            periodCntr <= STD_LOGIC_VECTOR(SIGNED(periodCntr) - 1);
            AdvancedTrigger_l1 <='0';
        END IF;
    ELSE
        periodCntr <= (OTHERS => '0');
        AdvancedTrigger_l1 <='0';
    END IF;

END IF;
END PROCESS;

END beh;

















