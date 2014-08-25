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
--                    Author : Jean-christophe Pellion
--                     Mail : jean-christophe.pellion@lpp.polytechnique.fr
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.MATH_REAL.ALL;
USE IEEE.NUMERIC_STD.ALL;

--LIBRARY lpp;
--USE lpp.iir_filter.ALL;

LIBRARY techmap;
USE techmap.gencomp.ALL;

ENTITY TB IS
  

END TB;


ARCHITECTURE beh OF TB IS

  COMPONENT RAM_CEL
    GENERIC (
      DataSz : integer range 1 to 32;
      abits  : integer range 2 to 12);
    PORT (
      WD           : in  std_logic_vector(DataSz-1 downto 0);
      RD           : out std_logic_vector(DataSz-1 downto 0);
      WEN, REN     : in  std_logic;
      WADDR        : in  std_logic_vector(abits-1 downto 0);
      RADDR        : in  std_logic_vector(abits-1 downto 0);
      RWCLK, RESET : in  std_logic);
  END COMPONENT;

  CONSTANT DATA_SIZE : INTEGER := 8;
  CONSTANT ADDR_BIT_NUMBER : INTEGER := 8;
  
  -----------------------------------------------------------------------------
  SIGNAL clk  : STD_LOGIC := '0';
  SIGNAL rstn : STD_LOGIC := '0';

  -----------------------------------------------------------------------------
  SIGNAL write_data : STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
  SIGNAL write_addr : STD_LOGIC_VECTOR(ADDR_BIT_NUMBER-1 DOWNTO 0);
  SIGNAL write_enable   : STD_LOGIC;
  SIGNAL write_enable_n : STD_LOGIC;

  SIGNAL read_data_ram  : STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
  SIGNAL read_data_cel  : STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0);
  SIGNAL read_addr : STD_LOGIC_VECTOR(ADDR_BIT_NUMBER-1 DOWNTO 0);
  SIGNAL read_enable    : STD_LOGIC;
  SIGNAL read_enable_n  : STD_LOGIC;
  -----------------------------------------------------------------------------
  CONSTANT RANDOM_VECTOR_SIZE : INTEGER := DATA_SIZE + ADDR_BIT_NUMBER + ADDR_BIT_NUMBER + 2;
  CONSTANT TWO_POWER_RANDOM_VECTOR_SIZE : real := (2**RANDOM_VECTOR_SIZE)*1.0;
  SIGNAL random_vector : STD_LOGIC_VECTOR(RANDOM_VECTOR_SIZE-1 DOWNTO 0);

  -----------------------------------------------------------------------------
  SIGNAL error_value : STD_LOGIC;
  SIGNAL warning_value : STD_LOGIC;
  SIGNAL warning_value_clocked : STD_LOGIC;
  
  CONSTANT READ_DATA_ALL_X : STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0) := (OTHERS => 'X');
  CONSTANT READ_DATA_ALL_U : STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0) := (OTHERS => 'U');
  CONSTANT READ_DATA_ALL_0 : STD_LOGIC_VECTOR(DATA_SIZE-1 DOWNTO 0) := (OTHERS => '0');

  
  
BEGIN  -- beh
  
  clk   <= NOT clk  AFTER 10 ns;
  rstn  <= '1' AFTER 30 ns;
  -----------------------------------------------------------------------------
  
  CEL: RAM_CEL
    GENERIC MAP (
      DataSz => DATA_SIZE,
      abits  => ADDR_BIT_NUMBER)
    PORT MAP (
      WD    => write_data,
      RD    => read_data_cel,
      WEN   => write_enable_n,
      REN   => read_enable_n,
      WADDR => write_addr,
      RADDR => read_addr,
      
      RWCLK => clk,
      RESET => rstn);
  
  RAM : syncram_2p
      GENERIC MAP(tech => 0, abits => ADDR_BIT_NUMBER, dbits => DATA_SIZE)
      PORT MAP(rclk  => clk, renable => read_enable, raddress => read_addr, dataout => read_data_ram,
              wclk => clk, write => write_enable, waddress => write_addr, datain => write_data);

  -----------------------------------------------------------------------------

  PROCESS (clk, rstn)
    VARIABLE seed1, seed2 : POSITIVE;
    VARIABLE rand1 : REAL;
    VARIABLE RANDOM_VECTOR_VAR : STD_LOGIC_VECTOR(RANDOM_VECTOR_SIZE-1 DOWNTO 0);
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      random_vector <= (OTHERS => '0');
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      UNIFORM(seed1,seed2,rand1);
      RANDOM_VECTOR_VAR := STD_LOGIC_VECTOR(
                            to_unsigned(INTEGER(TRUNC(rand1*TWO_POWER_RANDOM_VECTOR_SIZE)),
                                        RANDOM_VECTOR_VAR'LENGTH)
                            );
      
      random_vector <= RANDOM_VECTOR_VAR ;
      
    END IF;
  END PROCESS;

  -----------------------------------------------------------------------------
  write_data   <= random_vector(DATA_SIZE-1 DOWNTO 0);
  write_addr   <= random_vector(DATA_SIZE+ADDR_BIT_NUMBER-1 DOWNTO DATA_SIZE);
  read_addr    <= random_vector(DATA_SIZE+ADDR_BIT_NUMBER+ADDR_BIT_NUMBER-1 DOWNTO DATA_SIZE+ADDR_BIT_NUMBER);
  read_enable  <= random_vector(RANDOM_VECTOR_SIZE-2);
  write_enable <= random_vector(RANDOM_VECTOR_SIZE-1);

  read_enable_n  <= NOT read_enable;
  write_enable_n <= NOT write_enable;

  -----------------------------------------------------------------------------
  warning_value <= '0' WHEN read_data_ram = read_data_cel ELSE
                   '1';

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      error_value           <= '0';
      warning_value_clocked <= '0';
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      IF read_data_ram = read_data_cel THEN
        error_value <= '0';
        warning_value_clocked <= '0';
      ELSE
        warning_value_clocked <= '1';
        IF read_data_ram = READ_DATA_ALL_U AND read_data_cel = READ_DATA_ALL_0 THEN
          error_value <= '0';
        ELSE
          error_value <= '1';
        END IF;
      END IF;
    END IF;
  END PROCESS;
  
END beh;
 
