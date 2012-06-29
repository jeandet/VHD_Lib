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
----------------------------------------------------------------------------
library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
library lpp;
use lpp.lpp_uart.all;

--! \brief A general purpose UART with automatic baudrate 
--! 
--! \author Alexis Jeandet alexis.jeandet@lpp.polytechnique.fr

entity UART is 
generic(Data_sz     :   integer :=  8);            --! Data width
port(
    clk         :   in  std_logic;                              --! System clock
    reset       :   in  std_logic;                              --! System reset
    TXD         :   out std_logic;                              --! UART Transmission pin
    RXD         :   in  std_logic;                              --! UART Reception pin
    Capture     :   in  std_logic;                              --! Automatic baudrate module reset
    NwDat       :   out std_logic;                              --! New data flag, means that a new data have been received by the UART
    ACK         :   in  std_logic;                              --! Acknowledge flag to clear NwDat flag
    Send        :   in  std_logic;                              --! To send a data you have to set this flag
    Sended      :   out std_logic;                              --! When this flag is set you can sed a new data
    BTrigger    :   out std_logic_vector(11 downto 0);          --! Baudrate generator current value, could be usefull if you whant to know the current value of the baudrate or of the oscillator (it suppose that you know baudrate)
    RDATA       :   out std_logic_vector(Data_sz-1 downto 0);   --! Current read word
    WDATA       :   in  std_logic_vector(Data_sz-1 downto 0)    --! Put here the word you whant to send
);
end entity;


architecture ar_UART of UART is
signal  Bclk    :   std_logic;

signal  RDATA_int   :   std_logic_vector(Data_sz+1 downto 0);
signal  WDATA_int   :   std_logic_vector(Data_sz+1 downto 0);

signal  Take        :   std_logic;
signal  Taken       :   std_logic;
signal  Taken_reg   :   std_logic;

constant Dummy      :   std_logic_vector(Data_sz+1 downto 0) := (others => '1');

begin

NwDat    <= '0' when (ack = '1') else '1' when (Taken_reg='0' and Taken='1');
WDATA_int     <= '1' & WDATA & '0';

BaudGenerator : BaudGen
    port map(clk,reset,Capture,Bclk,RXD,BTrigger);

RX_REG  : Shift_Reg
    generic map(Data_sz+2)
    port map(Bclk,RXD,open,Take,Taken,Dummy,RDATA_int);

TX_REG  : Shift_Reg
    generic map(Data_sz+2)
    port map(Bclk,Dummy(0),TXD,Send,Sended,WDATA_int,open);

process(clk,reset)
begin
    if(reset ='0')then
        Take   <=  '0';

    elsif(clk'event and clk ='1')then
        Taken_reg <= Taken;

        if(RXD ='0' and Taken ='1')then
            Take <=  '1';
        elsif(Taken ='0')then
            Take <=  '0';
        end if;

        if (Taken_reg ='0' and Taken ='1') then
			RDATA   <=  RDATA_int(8 downto 1);
        end if;

    end if;
end process;

end architecture;


