------------------------------------------------------------------------------
--  This file is a part of the LPP VHDL IP LIBRARY
--  Copyright (C) 2009 - 2015, Laboratory of Plasmas Physic - CNRS
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
--                     Mail : alexis.jeandet@member.fsf.org
------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SPI_DAC_DRIVER is
    Generic(
        datawidth     : INTEGER := 16;
        MSBFIRST      : INTEGER := 1
    );
    Port ( 
        clk        : in  STD_LOGIC;
        rstn       : in  STD_LOGIC;
        DATA       : in STD_LOGIC_VECTOR(datawidth-1 downto 0);
        SMP_CLK    : in STD_LOGIC;
        SYNC       : out STD_LOGIC;
        DOUT       : out STD_LOGIC;
        SCLK       : out STD_LOGIC
         );
end entity SPI_DAC_DRIVER;

architecture behav of SPI_DAC_DRIVER is
signal SHIFTREG     : STD_LOGIC_VECTOR(datawidth-1 downto 0):=(others=>'0');
signal INPUTREG     : STD_LOGIC_VECTOR(datawidth-1 downto 0):=(others=>'0');
signal SMP_CLK_R    : STD_LOGIC:='0';
signal shiftcnt     : INTEGER:=0;
signal shifting     : STD_LOGIC:='0';
signal shifting_R   : STD_LOGIC:='0';
begin

DOUT <= SHIFTREG(datawidth-1);

MSB:IF MSBFIRST=1 GENERATE
    INPUTREG    <= DATA;
END GENERATE;

LSB:IF MSBFIRST=0 GENERATE
    INPUTREG(datawidth-1 downto 0)    <= DATA(0 to datawidth-1);
END GENERATE;

SCLK   <= clk;

process(clk,rstn)
begin
    if rstn='0' then
        shifting_R  <= '0';
        SMP_CLK_R   <= '0';
    elsif clk'event and clk='1' then
        SMP_CLK_R   <= SMP_CLK;
        shifting_R  <= shifting;
    end if;
end process;

process(clk,rstn)
begin
    if rstn='0' then
        shifting    <= '0';
        SHIFTREG    <= (others=>'0');
        SYNC        <= '0';
        shiftcnt    <= 0;
    elsif clk'event and clk='1' then
        if(SMP_CLK='1' and SMP_CLK_R='0') then
            SYNC        <= '1';
            shifting    <= '1';
        else
            SYNC        <= '0';
            if shiftcnt = datawidth-1 then
                shifting <= '0';
            end if;
        end if;
        if shifting_R='1' then
            shiftcnt    <= shiftcnt + 1;
            SHIFTREG    <= SHIFTREG (datawidth-2 downto 0) & '0';
        else
            SHIFTREG    <= INPUTREG;
            shiftcnt    <= 0;
        end if;
    end if;
end process;

end architecture behav;


