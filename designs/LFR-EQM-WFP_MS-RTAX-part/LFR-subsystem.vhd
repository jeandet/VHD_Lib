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
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_1164.ALL;
LIBRARY grlib;
USE grlib.amba.ALL;
USE grlib.stdlib.ALL;
LIBRARY techmap;
USE techmap.gencomp.ALL;
LIBRARY gaisler;
USE gaisler.sim.ALL;
USE gaisler.memctrl.ALL;
USE gaisler.leon3.ALL;
USE gaisler.uart.ALL;
USE gaisler.misc.ALL;
USE gaisler.spacewire.ALL;
LIBRARY esa;
USE esa.memoryctrl.ALL;
LIBRARY lpp;
USE lpp.lpp_memory.ALL;
USE lpp.lpp_ad_conv.ALL;
USE lpp.lpp_lfr_pkg.ALL;  -- contains lpp_lfr, not in the 206 rev of the VHD_Lib
USE lpp.lpp_top_lfr_pkg.ALL;            -- contains top_wf_picker
USE lpp.iir_filter.ALL;
USE lpp.general_purpose.ALL;
USE lpp.lpp_lfr_management.ALL;
USE lpp.lpp_leon3_soc_pkg.ALL;

--library proasic3l;
--use proasic3l.all;


ENTITY lfr_subsystem IS
  GENERIC (
    Mem_use                : INTEGER := use_RAM    
    );
  PORT (
    clk_25             : IN  STD_LOGIC;
    LFR_soft_rstn   : IN  STD_LOGIC;
    rstn_25   : IN  STD_LOGIC;
    -- SAMPLE
    sample_s        : IN  Samples(7 DOWNTO 0);
    sample_val      : IN  STD_LOGIC;
    -- APB
    apbi_ext            : IN  apb_slv_in_type;
    apbo_ext            : OUT apb_slv_out_type;
    -- AHB
    ahbi_m_ext            : IN  AHB_Mst_In_Type;
    ahbo_m_ext            : OUT AHB_Mst_Out_Type;
    -- TIME
    coarse_time     : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);  -- todo
    fine_time       : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);  -- todo
    -- 
    bias_fail_sw : OUT STD_LOGIC;
    --
    debug_vector    : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);   
    debug_vector_ms : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)    
    );
END lfr_subsystem;


ARCHITECTURE beh OF lfr_subsystem IS
  SIGNAL LFR_rstn : STD_LOGIC;
BEGIN  -- beh
  
  LFR_rstn <= LFR_soft_rstn AND rstn_25;

  lpp_lfr_1 : lpp_lfr
    GENERIC MAP (
      Mem_use                => Mem_use,
      tech                   => inferred,--tech,
      nb_data_by_buffer_size => 32,
      --nb_word_by_buffer_size => 30,
      nb_snapshot_param_size => 32,
      delta_vector_size      => 32,
      delta_vector_size_f0_2 => 7,          -- log2(96)
      pindex                 => 15,
      paddr                  => 15,
      pmask                  => 16#fff#,
      pirq_ms                => 6,
      pirq_wfp               => 14,
      hindex                 => 2,
      top_lfr_version        => X"020153",  -- aa.bb.cc version
                                            -- AA : BOARD NUMBER
                                            --      0 => MINI_LFR
                                            --      1 => EM
                                            --      2 => EQM (with A3PE3000)
      DEBUG_FORCE_DATA_DMA  => 0)
    PORT MAP (
      clk             => clk_25,
      rstn            => LFR_rstn,
      sample_B        => sample_s(2 DOWNTO 0),
      sample_E        => sample_s(7 DOWNTO 3),
      sample_val      => sample_val,
      apbi            => apbi_ext,
      apbo            => apbo_ext,
      ahbi            => ahbi_m_ext,
      ahbo            => ahbo_m_ext,
      coarse_time     => coarse_time,
      fine_time       => fine_time,
      data_shaping_BW => bias_fail_sw,
      debug_vector    => debug_vector,
      debug_vector_ms => OPEN); 
  
END beh;