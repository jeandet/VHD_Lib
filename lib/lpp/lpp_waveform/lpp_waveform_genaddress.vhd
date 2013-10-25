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
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY grlib;
USE grlib.amba.ALL;
USE grlib.stdlib.ALL;
USE grlib.devices.ALL;
USE GRLIB.DMA2AHB_Package.ALL;

LIBRARY lpp;
USE lpp.lpp_waveform_pkg.ALL;

LIBRARY techmap;
USE techmap.gencomp.ALL;

ENTITY lpp_waveform_genaddress IS
  
  GENERIC (
    nb_data_by_buffer_size : INTEGER);

  PORT (
    clk               : IN STD_LOGIC;
    rstn              : IN STD_LOGIC;
    run               : IN STD_LOGIC;
    -------------------------------------------------------------------------
    -- CONFIG
    -------------------------------------------------------------------------
    nb_data_by_buffer : IN STD_LOGIC_VECTOR(nb_data_by_buffer_size-1 DOWNTO 0);
    addr_data_f0      : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_data_f1      : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_data_f2      : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_data_f3      : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    -------------------------------------------------------------------------
    -- CTRL
    -------------------------------------------------------------------------
    empty             : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    empty_almost      : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    data_ren          : IN STD_LOGIC_VECTOR(3 DOWNTO 0);

    -------------------------------------------------------------------------
    -- STATUS
    -------------------------------------------------------------------------
    status_full     : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    status_full_ack : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    status_full_err : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);

    -------------------------------------------------------------------------
    -- ADDR DATA OUT
    -------------------------------------------------------------------------
    data_f0_data_out_valid_burst : OUT STD_LOGIC;
    data_f1_data_out_valid_burst : OUT STD_LOGIC;
    data_f2_data_out_valid_burst : OUT STD_LOGIC;
    data_f3_data_out_valid_burst : OUT STD_LOGIC;

    data_f0_data_out_valid : OUT STD_LOGIC;
    data_f1_data_out_valid : OUT STD_LOGIC;
    data_f2_data_out_valid : OUT STD_LOGIC;
    data_f3_data_out_valid : OUT STD_LOGIC;

    data_f0_addr_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    data_f1_addr_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    data_f2_addr_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    data_f3_addr_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)

    );

END lpp_waveform_genaddress;

ARCHITECTURE beh OF lpp_waveform_genaddress IS
  -----------------------------------------------------------------------------
  -- Valid gen
  -----------------------------------------------------------------------------
  SIGNAL addr_burst_avail : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL data_out_valid : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL data_out_valid_burst : STD_LOGIC_VECTOR(3 DOWNTO 0);

  -----------------------------------------------------------------------------
  -- Register
  -----------------------------------------------------------------------------
  SIGNAL data_addr_v_pre : Data_Vector(3 DOWNTO 0, 31 DOWNTO 0);
  SIGNAL data_addr_v_reg : Data_Vector(3 DOWNTO 0, 31 DOWNTO 0);
  SIGNAL data_addr_v_base : Data_Vector(3 DOWNTO 0, 31 DOWNTO 0);
  SIGNAL data_addr_pre : STD_LOGIC_VECTOR(31 DOWNTO 0);  -- TODO
  SIGNAL data_addr_reg : STD_LOGIC_VECTOR(31 DOWNTO 0);  -- TODO
  SIGNAL data_addr_base : STD_LOGIC_VECTOR(31 DOWNTO 0);  -- TODO

  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  SIGNAL  status_full_s     :  STD_LOGIC_VECTOR(3 DOWNTO 0);

  TYPE addr_VECTOR IS ARRAY (NATURAL RANGE <>) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL addr_v_p : addr_VECTOR(3 DOWNTO 0);
  SIGNAL addr_v_b : addr_VECTOR(3 DOWNTO 0);
    
BEGIN  -- beh
  
  -----------------------------------------------------------------------------
  -- valid gen
  -----------------------------------------------------------------------------
  data_f0_data_out_valid <= data_out_valid(0);
  data_f1_data_out_valid <= data_out_valid(1);
  data_f2_data_out_valid <= data_out_valid(2);
  data_f3_data_out_valid <= data_out_valid(3);
  
  data_f0_data_out_valid_burst <= data_out_valid_burst(0);
  data_f1_data_out_valid_burst <= data_out_valid_burst(1);
  data_f2_data_out_valid_burst <= data_out_valid_burst(2);
  data_f3_data_out_valid_burst <= data_out_valid_burst(3);
  
  
  all_bit_data_valid_out: FOR I IN 3 DOWNTO 0 GENERATE
    addr_burst_avail(I)    <= '1' WHEN data_addr_v_pre(I,2) = '0' AND
                                       data_addr_v_pre(I,3) = '0' AND
                                       data_addr_v_pre(I,4) = '0' AND
                                       data_addr_v_pre(I,5) = '0'  ELSE '0';
    
    data_out_valid(I) <= '0' WHEN (status_full_s(I) = '1' AND status_full_ack(I) = '0') ELSE
                              '0' WHEN empty(I) = '1' ELSE
                              '0' WHEN addr_burst_avail(I) = '1' ELSE
                              '0' WHEN (run = '0') ELSE
                              '1';
    
    data_out_valid_burst(I) <= '0' WHEN (status_full_s(I) = '1' AND status_full_ack(I) = '0') ELSE
                               '0' WHEN empty(I) = '1'                                        ELSE
                               '0' WHEN addr_burst_avail(I) = '0'                             ELSE
                               '0' WHEN empty_almost(I) = '1'                                 ELSE
                               '0' WHEN (run = '0')                                           ELSE
                               '1';
  END GENERATE all_bit_data_valid_out;

  -----------------------------------------------------------------------------
  -- Register
  -----------------------------------------------------------------------------
  all_data_bit: FOR J IN 31 DOWNTO 0 GENERATE
    all_data_addr: FOR I IN 3 DOWNTO 0 GENERATE
      PROCESS (clk, rstn)
      BEGIN  -- PROCESS
        IF rstn = '0' THEN                  -- asynchronous reset (active low)
          data_addr_v_reg(I,J) <= '0';
        ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
          IF run = '1' AND status_full_ack(I) = '0' THEN
            data_addr_v_reg(I,J) <= data_addr_v_pre(I,J);
          ELSE
            data_addr_v_reg(I,J) <= data_addr_v_base(I,J);
          END IF;        
        END IF;
      END PROCESS;
      
      data_addr_v_pre(I,J) <= data_addr_v_reg(I,J) WHEN data_ren(I) = '1' ELSE data_addr_pre(J);
      
    END GENERATE all_data_addr;
    
    data_addr_reg(J) <= data_addr_v_reg(0,J) WHEN data_ren(0) = '1' ELSE 
                        data_addr_v_reg(1,J) WHEN data_ren(1) = '1' ELSE 
                        data_addr_v_reg(2,J) WHEN data_ren(2) = '1' ELSE 
                        data_addr_v_reg(3,J);
  
    data_addr_v_base(0,J) <= addr_data_f0(J);
    data_addr_v_base(1,J) <= addr_data_f1(J);
    data_addr_v_base(2,J) <= addr_data_f2(J);
    data_addr_v_base(3,J) <= addr_data_f3(J);
    
    data_f0_addr_out(J) <= data_addr_v_reg(0,J);
    data_f1_addr_out(J) <= data_addr_v_reg(1,J);
    data_f2_addr_out(J) <= data_addr_v_reg(2,J);
    data_f3_addr_out(J) <= data_addr_v_reg(3,J);
    
  END GENERATE all_data_bit;

  

  
  -----------------------------------------------------------------------------
  -- ADDER
  -----------------------------------------------------------------------------
  
  data_addr_pre <= data_addr_reg + 1;

  -----------------------------------------------------------------------------
  -- FULL STATUS
  -----------------------------------------------------------------------------
  all_status: FOR I IN 3 DOWNTO 0 GENERATE
    all_bit_addr: FOR J IN 31 DOWNTO 0 GENERATE
      addr_v_p(I)(J) <= data_addr_v_pre(I,J);
      addr_v_b(I)(J) <= data_addr_v_base(I,J);
    END GENERATE all_bit_addr;
  
    PROCESS (clk, rstn)
    BEGIN  -- PROCESS
      IF rstn = '0' THEN                  -- asynchronous reset (active low)
        status_full_s(I) <= '0';
        status_full_err(I) <= '0';
      ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
        IF run = '1' AND status_full_ack(I) = '0' THEN
          IF addr_v_p(I) = addr_v_b(I) + nb_data_by_buffer THEN
            status_full_s(I) <= '1';
            IF status_full_s(I) = '1' AND data_ren(I)= '1' THEN
              status_full_err(I) <= '1';
            END IF;
          END IF;
        ELSE
          status_full_s(I) <= '0';
          status_full_err(I) <= '0';          
        END IF;
      END IF;
    END PROCESS;
    
  END GENERATE all_status;

  status_full <=  status_full_s;

  
END beh;
