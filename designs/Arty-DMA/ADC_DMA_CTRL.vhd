------------------------------------------------------------------------------
--  This file is a part of the LPP VHDL IP LIBRARY
--  Copyright (C) 2009 - 2018, Laboratory of Plasmas Physic - CNRS
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
library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;

entity ADC_DMA_CTRL is
  PORT (
    clk  : IN STD_LOGIC;
    rstn : IN STD_LOGIC;

    CFG_DMA_enable  : in  std_logic;
    CFG_DMA_Address : in  std_logic_vector(31 downto 0);
    CFG_DMA_Size    : in  std_logic_vector(31 downto 0);

    DMA_done         : in  std_logic;
    DMA_send         : in  std_logic;
    DMA_burst        : out STD_LOGIC;
    DMA_address      : out STD_LOGIC_VECTOR(31 DOWNTO 0);

    FIFO_RUN         : OUT std_logic;
    FIFO_WEN         : OUT std_logic;
    FIFO_FULL        : IN  std_logic;
    FIFO_WDATA       : OUT std_logic_vector(31 DOWNTO 0);

    ADC_enable       : OUT std_logic;
    ADC_data         : in std_logic_vector(31 downto 0);
    ADC_sample_ready : in std_logic
    );
end entity;

architecture behave of ADC_DMA_CTRL is

    signal DMA_address_r       : STD_LOGIC_VECTOR(31 DOWNTO 0):= (others => '0');
    signal Sent_counter        : STD_LOGIC_VECTOR(31 DOWNTO 0):= (others => '0');
    signal CFG_DMA_Size_r      : std_logic_vector(31 downto 0):= (others => '0');
    signal ADC_sample_ready_r  : std_logic;

    type state_t is (idle,transfert);

    signal state : state_t := idle;

begin

DMA_address <= DMA_address_r;

FIFO_WEN    <= '0' WHEN ADC_sample_ready_r = '0' and ADC_sample_ready = '1' else '1';
FIFO_WDATA  <= ADC_data;

process(rstn, clk)
begin
    if rstn = '0' then
        DMA_address_r <= (others => '0');
        Sent_counter  <= (others => '0');
        state         <= idle;
        ADC_enable    <= '0';
        ADC_sample_ready_r <= '0';
    elsif clk'event and clk = '1'then
        ADC_sample_ready_r <= ADC_sample_ready;
        case state is
            WHEN IDLE =>
                FIFO_RUN    <= '0';
                if CFG_DMA_enable = '1' then
                    state           <= transfert;
                    DMA_address_r   <= CFG_DMA_Address;
                    CFG_DMA_Size_r  <= CFG_DMA_Size;
                    FIFO_RUN        <= '1';
                    ADC_enable      <= '1';
                end if;
            WHEN transfert =>
                if DMA_done = '1' then
                    if Sent_counter >= CFG_DMA_Size_r then
                        ADC_enable      <= '0';
                        state           <= idle;
                        Sent_counter    <= (others => '0');
                        DMA_address_r   <= (others => '0');
                    else
                        Sent_counter    <= std_logic_vector(UNSIGNED(Sent_counter) + 16);
                        DMA_address_r   <= std_logic_vector(UNSIGNED(DMA_address_r) + (4 * 16));
                    end if;
                end if;
            WHEN others =>
                null;
        end case;
    end if;
end process;

end architecture;