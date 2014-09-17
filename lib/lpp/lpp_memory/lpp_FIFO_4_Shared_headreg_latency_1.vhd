------------------------------------------------------------------------------
--  This file is a part of the LPP VHDL IP LIBRARY
--  Copyright (C) 2009 - 2012, Laboratory of Plasmas Physic - CNRS
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
--                    Author : Jean-christophe PELLION
--                    Mail   : jean-christophe.pellion@lpp.polytechnique.fr
------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

LIBRARY techmap;
USE techmap.gencomp.ALL;

ENTITY lpp_fifo_4_shared_headreg_latency_1 IS
  PORT(
    clk            : IN  STD_LOGIC;
    rstn           : IN  STD_LOGIC;
    ---------------------------------------------------------------------------
    run            : IN  STD_LOGIC;
    ---------------------------------------------------------------------------
    o_empty_almost : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);  --occupancy is lesser than 16 * 32b
    o_empty        : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    
    o_data_ren     : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    o_rdata_0      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0); --
    o_rdata_1      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0); --
    o_rdata_2      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0); --
    o_rdata_3      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);  --
    ---------------------------------------------------------------------------
    i_empty_almost : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    i_empty        : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    i_data_ren     : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);  --
    i_rdata        : IN  STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY;


ARCHITECTURE beh OF lpp_fifo_4_shared_headreg_latency_1 IS

  TYPE REG_HEAD_TYPE IS ARRAY (3 DOWNTO 0) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL reg_head_data : REG_HEAD_TYPE;
    
  
  SIGNAL reg_head_full : STD_LOGIC_VECTOR(3 DOWNTO 0); 
  SIGNAL i_data_ren_pre : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL o_data_ren_pre : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL i_data_ren_s_temp : STD_LOGIC_VECTOR(3 DOWNTO 0); 
  SIGNAL i_data_ren_s : STD_LOGIC_VECTOR(3 DOWNTO 0);  -- todo
  SIGNAL i_empty_reg        : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL  o_rdata_0_s      :  STD_LOGIC_VECTOR(31 DOWNTO 0); --
  SIGNAL  o_rdata_1_s      :  STD_LOGIC_VECTOR(31 DOWNTO 0); --
  SIGNAL  o_rdata_2_s      :  STD_LOGIC_VECTOR(31 DOWNTO 0); --
  SIGNAL  o_rdata_3_s      :  STD_LOGIC_VECTOR(31 DOWNTO 0);  --
  
  
BEGIN
  --i_data_ren     : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);  --
  i_data_ren     <= i_data_ren_s;
  
  o_rdata_0_s <=  i_rdata WHEN o_data_ren_pre(0) = '0' AND o_data_ren(0) = '0' ELSE reg_head_data(0) ;
  o_rdata_1_s <=  i_rdata WHEN o_data_ren_pre(1) = '0' AND o_data_ren(1) = '0' ELSE reg_head_data(1) ;
  o_rdata_2_s <=  i_rdata WHEN o_data_ren_pre(2) = '0' AND o_data_ren(2) = '0' ELSE reg_head_data(2) ;
  o_rdata_3_s <=  i_rdata WHEN o_data_ren_pre(3) = '0' AND o_data_ren(3) = '0' ELSE reg_head_data(3) ;


  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      o_rdata_0 <= (OTHERS => '0');
      o_rdata_1 <= (OTHERS => '0');
      o_rdata_2 <= (OTHERS => '0');
      o_rdata_3 <= (OTHERS => '0');
      --o_empty_almost <= (OTHERS => '0');
      --o_empty        <= (OTHERS => '0');
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      o_rdata_0 <= o_rdata_0_s;
      o_rdata_1 <= o_rdata_1_s;
      o_rdata_2 <= o_rdata_2_s;
      o_rdata_3 <= o_rdata_3_s;
  
      --o_empty_almost <= i_empty_almost;     --TODO
      --o_empty        <= NOT reg_head_full;
    END IF;
  END PROCESS;


  o_empty_almost <= i_empty_almost;     --TODO
  o_empty        <= NOT reg_head_full OR (i_empty AND o_data_ren);
  

  
  i_data_ren_s(0) <= i_data_ren_s_temp(0);
  i_data_ren_s(1) <= i_data_ren_s_temp(1) WHEN i_data_ren_s_temp(0) = '1' ELSE '1';  
  i_data_ren_s(2) <= i_data_ren_s_temp(2) WHEN i_data_ren_s_temp(1 DOWNTO 0) = "11" ELSE '1';
  i_data_ren_s(3) <= i_data_ren_s_temp(3) WHEN i_data_ren_s_temp(2 DOWNTO 0) = "111" ELSE '1';
    
  each_fifo: FOR I IN 3 DOWNTO 0 GENERATE

--    i_data_ren_pre(I) <= i_data_ren_s(I);
    
    PROCESS (clk, rstn)
    BEGIN
      IF rstn = '0' THEN
        reg_head_data(I)  <= (OTHERS => '0');
        i_data_ren_pre(I)  <=  '1';
        reg_head_full(I) <= '0';
        o_data_ren_pre(I) <= '1';
      ELSIF clk'event AND clk = '1' THEN
        o_data_ren_pre(I) <= o_data_ren(I) ;
        IF i_data_ren_pre(I) = '0' THEN
          reg_head_data(I) <= i_rdata;
        END IF;
        i_data_ren_pre(I) <= i_data_ren_s(I);
        IF i_data_ren_s(I) = '0' THEN
          reg_head_full(I) <= '1';
        ELSIF o_data_ren(I) = '0' THEN
          reg_head_full(I) <= '0';            
        END IF;
        
      END IF;
    END PROCESS;

    i_data_ren_s_temp(I) <= '1' WHEN i_empty_reg(I) = '1' ELSE
                            '0' WHEN o_data_ren(I) = '0' ELSE
                            '0' WHEN reg_head_full(I) = '0' ELSE
                            '1';

    
    PROCESS (clk, rstn)
    BEGIN
      IF rstn = '0' THEN
        i_empty_reg(I) <= '1';
      ELSIF clk'event AND clk = '1' THEN
        i_empty_reg(I) <= i_empty(I);
      END IF;
    END PROCESS;
    

    
  END GENERATE each_fifo;

  
END ARCHITECTURE;













