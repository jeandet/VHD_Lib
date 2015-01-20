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
--                     Mail :  jean-christophe.pellion@lpp.polytechnique.fr
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY grlib;
USE grlib.amba.ALL;
USE grlib.stdlib.ALL;
USE grlib.devices.ALL;

LIBRARY lpp;
USE lpp.apb_devices_list.ALL;

ENTITY lpp_lfr_hk IS
  
  GENERIC (
    pindex : INTEGER := 0;
    paddr  : INTEGER := 0;
    pmask  : INTEGER := 16#fff#);   --! MASK field of the APB BAR);

  PORT (
    clk  : IN STD_LOGIC;
    rstn : IN STD_LOGIC;

    apbi : IN  apb_slv_in_type;         --! APB slave input signals
    apbo : OUT apb_slv_out_type;        --! APB slave output signals
    
    sample_val : IN STD_LOGIC;
    sample : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

    HK_SEL : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
    );

END lpp_lfr_hk;


ARCHITECTURE Behavioral OF lpp_lfr_hk IS

  -----------------------------------------------------------------------------
  -- APB REG
  CONSTANT REVISION : INTEGER := 1;
  
  CONSTANT pconfig : apb_config_type := (
    0 => ahb_device_reg (VENDOR_LPP, LPP_LFR_HK_DEVICE, 0, REVISION, 0),
    1 => apb_iobar(paddr, pmask)
    );

  TYPE lpp_lfr_HK_reg IS RECORD
    temp_0           : STD_LOGIC_VECTOR(15 DOWNTO 0);
    temp_1           : STD_LOGIC_VECTOR(15 DOWNTO 0);
    temp_2           : STD_LOGIC_VECTOR(15 DOWNTO 0);
  END RECORD;

  SIGNAL reg_hk : lpp_lfr_HK_reg;
  
  SIGNAL Rdata               : STD_LOGIC_VECTOR(31 DOWNTO 0);
  -----------------------------------------------------------------------------
  SIGNAL  HK_SEL_s :STD_LOGIC_VECTOR(1 DOWNTO 0);
  
BEGIN

  -----------------------------------------------------------------------------
  -- APB REG
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)

      Rdata        <= (OTHERS => '0');
      
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      --APB READ OP
      IF (apbi.psel(pindex) AND (NOT apbi.pwrite)) = '1' THEN
        CASE apbi.paddr(7 DOWNTO 2) IS
          WHEN "000000" => Rdata(15 DOWNTO 0) <= reg_hk.temp_0;
          WHEN "000001" => Rdata(15 DOWNTO 0) <= reg_hk.temp_1;
          WHEN "000010" => Rdata(15 DOWNTO 0) <= reg_hk.temp_2;
          WHEN OTHERS =>   Rdata(31 DOWNTO 0)  <= (others => '0');
        END CASE;
      END IF;

    END IF;
  END PROCESS;

  apbo.pirq    <= (OTHERS => '0');
  apbo.prdata  <= Rdata;
  apbo.pconfig <= pconfig;
  apbo.pindex  <= pindex;
  -----------------------------------------------------------------------------

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)

      reg_hk.temp_0 <= (OTHERS => '0');
      reg_hk.temp_1 <= (OTHERS => '0');
      reg_hk.temp_2 <= (OTHERS => '0');
      
      HK_SEL_s <= "00";
      
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge

      IF sample_val = '1' THEN
        CASE HK_SEL_s IS
          WHEN "00" => reg_hk.temp_0 <= sample; HK_SEL_s <= "01";
          WHEN "01" => reg_hk.temp_1 <= sample; HK_SEL_s <= "10";
          WHEN "10" => reg_hk.temp_2 <= sample; HK_SEL_s <= "00";
          WHEN OTHERS => NULL;
        END CASE;
        
      END IF;
      
    END IF;
  END PROCESS;  

  HK_SEL <= HK_SEL_s;
  
END Behavioral;



