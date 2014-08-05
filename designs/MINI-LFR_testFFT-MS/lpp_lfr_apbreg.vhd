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
-- Author : Jean-christophe Pellion
-- Mail   : jean-christophe.pellion@lpp.polytechnique.fr
--          jean-christophe.pellion@easii-ic.com
----------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
LIBRARY grlib;
USE grlib.amba.ALL;
USE grlib.stdlib.ALL;
USE grlib.devices.ALL;
LIBRARY lpp;
USE lpp.lpp_lfr_pkg.ALL;
--USE lpp.lpp_amba.ALL;
USE lpp.apb_devices_list.ALL;
USE lpp.lpp_memory.ALL;
LIBRARY techmap;
USE techmap.gencomp.ALL;

ENTITY lpp_lfr_apbreg_tb IS
  GENERIC (
    pindex          : INTEGER                       := 4;
    paddr           : INTEGER                       := 4;
    pmask           : INTEGER                       := 16#fff#);
  PORT (
    -- AMBA AHB system signals
    HCLK    : IN STD_ULOGIC;
    HRESETn : IN STD_ULOGIC;

    -- AMBA APB Slave Interface
    apbi : IN  apb_slv_in_type;
    apbo : OUT apb_slv_out_type;

    ---------------------------------------------------------------------------
    sample_f0_wen : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
    sample_f1_wen : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
    sample_f2_wen : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);

    sample_f0_wdata  : OUT STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
    sample_f1_wdata  : OUT STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
    sample_f2_wdata  : OUT STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
    ---------------------------------------------------------------------------
    MEM_OUT_SM_ren       : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    MEM_OUT_SM_Data_out  : IN  STD_LOGIC_VECTOR(63 DOWNTO 0);
    MEM_OUT_SM_Full      : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
    MEM_OUT_SM_Full_2    : IN  STD_LOGIC;
    MEM_OUT_SM_Empty     : IN  STD_LOGIC_VECTOR(1 DOWNTO 0)
    ---------------------------------------------------------------------------    
    );

END lpp_lfr_apbreg_tb;

ARCHITECTURE beh OF lpp_lfr_apbreg_tb IS
  
  CONSTANT REVISION : INTEGER := 1;

  CONSTANT pconfig : apb_config_type := (
    0 => ahb_device_reg (VENDOR_LPP, LPP_LFR, 0, REVISION, 1),
    1 => apb_iobar(paddr, pmask));

  TYPE reg_debug_fft IS RECORD
    in_data_f0 : STD_LOGIC_VECTOR(5*16-1 DOWNTO 0);
    in_data_f1 : STD_LOGIC_VECTOR(5*16-1 DOWNTO 0);
    in_data_f2 : STD_LOGIC_VECTOR(5*16-1 DOWNTO 0);

    in_wen_f0  : STD_LOGIC_VECTOR(4 DOWNTO 0);
    in_wen_f1  : STD_LOGIC_VECTOR(4 DOWNTO 0);
    in_wen_f2  : STD_LOGIC_VECTOR(4 DOWNTO 0);
    --
    out_ren    : STD_LOGIC_VECTOR(1 DOWNTO 0);
  END RECORD;
  SIGNAL reg_ftt : reg_debug_fft;
  
  SIGNAL prdata : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN  -- beh

  ---------------------------------------------------------------------------
  sample_f0_wen <= reg_ftt.in_wen_f0;
  sample_f1_wen <= reg_ftt.in_wen_f1;
  sample_f2_wen <= reg_ftt.in_wen_f2;

  sample_f0_wdata  <= reg_ftt.in_data_f0;
  sample_f1_wdata  <= reg_ftt.in_data_f1;
  sample_f2_wdata  <= reg_ftt.in_data_f2;
  ---------------------------------------------------------------------------
  MEM_OUT_SM_ren    <= reg_ftt.out_ren;
  ---------------------------------------------------------------------------    

  lpp_lfr_apbreg : PROCESS (HCLK, HRESETn)
    VARIABLE paddr : STD_LOGIC_VECTOR(7 DOWNTO 2);
  BEGIN
    IF HRESETn = '0' THEN

      reg_ftt.in_data_f0 <= (OTHERS => '0');
      reg_ftt.in_data_f1 <= (OTHERS => '0');
      reg_ftt.in_data_f2 <= (OTHERS => '0');

      reg_ftt.in_wen_f0 <= (OTHERS => '1');
      reg_ftt.in_wen_f1 <= (OTHERS => '1');
      reg_ftt.in_wen_f2 <= (OTHERS => '1');

      reg_ftt.out_ren    <= (OTHERS => '1');
      
    ELSIF HCLK'EVENT AND HCLK = '1' THEN  -- rising clock edge


      reg_ftt.in_wen_f0 <= (OTHERS => '1');
      reg_ftt.in_wen_f1 <= (OTHERS => '1');
      reg_ftt.in_wen_f2 <= (OTHERS => '1');
      reg_ftt.out_ren   <= (OTHERS => '1');

      paddr             := "000000";
      paddr(7 DOWNTO 2) := apbi.paddr(7 DOWNTO 2);
      prdata            <= (OTHERS => '0');
      IF apbi.psel(pindex) = '1' THEN
        -- APB DMA READ  --
        CASE paddr(7 DOWNTO 2) IS
          --0
          WHEN "000000" => prdata(31 DOWNTO 0) <= reg_ftt.in_data_f0(31 DOWNTO 0);
          WHEN "000001" => prdata(31 DOWNTO 0) <= reg_ftt.in_data_f0(63 DOWNTO 32);
          WHEN "000010" => prdata(15 DOWNTO 0) <= reg_ftt.in_data_f0(79 DOWNTO 64);
          WHEN "000011" => prdata(4 DOWNTO 0)  <= reg_ftt.in_wen_f0;

          WHEN "000100" => prdata(31 DOWNTO 0) <= reg_ftt.in_data_f1(31 DOWNTO 0);
          WHEN "000101" => prdata(31 DOWNTO 0) <= reg_ftt.in_data_f1(63 DOWNTO 32);
          WHEN "000110" => prdata(15 DOWNTO 0) <= reg_ftt.in_data_f1(79 DOWNTO 64);
          WHEN "000111" => prdata(4 DOWNTO 0)  <= reg_ftt.in_wen_f1;

          WHEN "001000" => prdata(31 DOWNTO 0) <= reg_ftt.in_data_f2(31 DOWNTO 0);
          WHEN "001001" => prdata(31 DOWNTO 0) <= reg_ftt.in_data_f2(63 DOWNTO 32);
          WHEN "001010" => prdata(15 DOWNTO 0) <= reg_ftt.in_data_f2(79 DOWNTO 64);
          WHEN "001011" => prdata(4 DOWNTO 0)  <= reg_ftt.in_wen_f2;

          WHEN "001100" => prdata(31 DOWNTO 0) <= MEM_OUT_SM_Data_out(32*1-1 DOWNTO 32*0);
          WHEN "001101" => prdata(31 DOWNTO 0) <= MEM_OUT_SM_Data_out(32*2-1 DOWNTO 32*1);

          WHEN "001110" => prdata(1 DOWNTO 0) <= reg_ftt.out_ren;
                           prdata(3 DOWNTO 2) <= MEM_OUT_SM_Full;
                           prdata(5 DOWNTO 4) <= MEM_OUT_SM_Empty;
                           prdata(6)          <= MEM_OUT_SM_Full_2;
          WHEN OTHERS => NULL;
                           
        END CASE;
        IF (apbi.pwrite AND apbi.penable) = '1' THEN
          -- APB DMA WRITE --
          CASE paddr(7 DOWNTO 2) IS
            WHEN "000000" => reg_ftt.in_data_f0(31 DOWNTO 0)  <= apbi.pwdata;
            WHEN "000001" => reg_ftt.in_data_f0(63 DOWNTO 32) <= apbi.pwdata;
            WHEN "000010" => reg_ftt.in_data_f0(79 DOWNTO 64) <= apbi.pwdata(15 DOWNTO 0);
            WHEN "000011" => reg_ftt.in_wen_f0                <= apbi.pwdata(4 DOWNTO 0);

            WHEN "000100" => reg_ftt.in_data_f1(31 DOWNTO 0)  <= apbi.pwdata;
            WHEN "000101" => reg_ftt.in_data_f1(63 DOWNTO 32) <= apbi.pwdata;
            WHEN "000110" => reg_ftt.in_data_f1(79 DOWNTO 64) <= apbi.pwdata(15 DOWNTO 0);
            WHEN "000111" => reg_ftt.in_wen_f1                <= apbi.pwdata(4 DOWNTO 0);

            WHEN "001000" => reg_ftt.in_data_f2(31 DOWNTO 0)  <= apbi.pwdata;
            WHEN "001001" => reg_ftt.in_data_f2(63 DOWNTO 32) <= apbi.pwdata;
            WHEN "001010" => reg_ftt.in_data_f2(79 DOWNTO 64) <= apbi.pwdata(15 DOWNTO 0);
            WHEN "001011" => reg_ftt.in_wen_f2                <= apbi.pwdata(4 DOWNTO 0);

            WHEN "001110" => reg_ftt.out_ren <= apbi.pwdata(1 DOWNTO 0);
                             
            WHEN OTHERS => NULL;
          END CASE;
        END IF;
      END IF;
      
    END IF;
  END PROCESS lpp_lfr_apbreg;
  
  apbo.pindex  <= pindex;
  apbo.pconfig <= pconfig;
  apbo.prdata  <= prdata;
  
END beh;