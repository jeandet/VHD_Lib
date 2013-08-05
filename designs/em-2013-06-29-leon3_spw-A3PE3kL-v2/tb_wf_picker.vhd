-----------------------------------------------------------------------------
--  LEON3 Demonstration design
--  Copyright (C) 2004 Jiri Gaisler, Gaisler Research
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
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


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
LIBRARY grlib;
USE grlib.amba.ALL;
USE grlib.stdlib.ALL;
LIBRARY techmap;
USE techmap.gencomp.ALL;
LIBRARY gaisler;
USE gaisler.memctrl.ALL;
USE gaisler.leon3.ALL;
USE gaisler.uart.ALL;
USE gaisler.misc.ALL;
USE gaisler.spacewire.ALL;              -- PLE

LIBRARY esa;
USE esa.memoryctrl.ALL;
--USE work.config.ALL;
LIBRARY lpp;
USE lpp.lpp_memory.ALL;
USE lpp.lpp_ad_conv.ALL;
USE lpp.lpp_top_lfr_pkg.ALL;
USE lpp.iir_filter.ALL;
USE lpp.general_purpose.ALL;
USE lpp.lpp_lfr_time_management.ALL;

ENTITY tb_wf_picker IS
END;

ARCHITECTURE Behavioral OF tb_wf_picker IS
  
  SIGNAL clk49_152MHz  : STD_LOGIC := '0';
  SIGNAL clkm          : STD_LOGIC := '0';
  SIGNAL rstn          : STD_LOGIC := '0';
  SIGNAL coarse_time_0 : STD_LOGIC := '0';

  -- ADC interface
  SIGNAL bias_fail_sw   : STD_LOGIC;                      -- OUT
  SIGNAL ADC_OEB_bar_CH : STD_LOGIC_VECTOR(7 DOWNTO 0);   -- OUT
  SIGNAL ADC_smpclk     : STD_LOGIC;                      -- OUT
  SIGNAL ADC_data       : STD_LOGIC_VECTOR(13 DOWNTO 0);  -- IN 

  --
  SIGNAL apbi  : apb_slv_in_type;
  SIGNAL apbo  : apb_slv_out_vector := (OTHERS => apb_none);
  SIGNAL ahbmi : ahb_mst_in_type;
  SIGNAL ahbmo : ahb_mst_out_vector := (OTHERS => ahbm_none);

  -- internal
  SIGNAL sample     : Samples14v(7 DOWNTO 0);
  SIGNAL sample_val : STD_LOGIC;
  
BEGIN

  -----------------------------------------------------------------------------
  
  MODULE_RHF1401: FOR I IN 0 TO 7 GENERATE
    TestModule_RHF1401_1: TestModule_RHF1401
      GENERIC MAP (
        freq      => 24*(I+1),
        amplitude => 8000/(I+1),
        impulsion => 0)
      PORT MAP (
        ADC_smpclk  => ADC_smpclk,
        ADC_OEB_bar => ADC_OEB_bar_CH(I),
        ADC_data    => ADC_data);
  END GENERATE MODULE_RHF1401;

  -----------------------------------------------------------------------------
  
  clk49_152MHz  <= NOT clk49_152MHz  AFTER 10173 ps;  -- 49.152/2 MHz
  clkm          <= NOT clkm          AFTER 20 ns;     -- 25 MHz
  coarse_time_0 <= NOT coarse_time_0 AFTER 100 ms;

  -----------------------------------------------------------------------------
  -- waveform generation
  WaveGen_Proc : PROCESS
  BEGIN
    -- insert signal assignments here
    WAIT UNTIL clkm = '1';
    apbi                     <= apb_slv_in_none;
    rstn                     <= '0';
--    cnv_rstn                 <= '0';
--    run_cnv                  <= '0';
    WAIT UNTIL clkm = '1';
    WAIT UNTIL clkm = '1';
    WAIT UNTIL clkm = '1';
    rstn                     <= '1';
--    cnv_rstn                 <= '1';
    WAIT UNTIL clkm = '1';
    WAIT UNTIL clkm = '1';
    WAIT UNTIL clkm = '1';
    WAIT UNTIL clkm = '1';
    WAIT UNTIL clkm = '1';
    WAIT UNTIL clkm = '1';
--    run_cnv                  <= '1';
    WAIT UNTIL clkm = '1';
    WAIT UNTIL clkm = '1';
    WAIT UNTIL clkm = '1';
    WAIT UNTIL clkm = '1';
    WAIT UNTIL clkm = '1';
    WAIT UNTIL clkm = '1';
    WAIT UNTIL clkm = '1';
    WAIT UNTIL clkm = '1';
    WAIT UNTIL clkm = '1';
    WAIT UNTIL clkm = '1';
    WAIT UNTIL clkm = '1';
    WAIT UNTIL clkm = '1';
    apbi.psel(15)            <= '1';
    apbi.penable             <= '1';
    apbi.pwrite              <= '1';
    --                           765432   
    apbi.paddr(7 DOWNTO 2)   <= "001000";
    apbi.pwdata(4 DOWNTO 0)  <= "00000";
    WAIT UNTIL clkm = '1';
    apbi.paddr(7 DOWNTO 2)   <= "001001";
    apbi.pwdata(6 DOWNTO 0)  <= "0000000";
    WAIT UNTIL clkm = '1';
    apbi.paddr(7 DOWNTO 2)   <= "001010";
    apbi.pwdata              <= "10000000000000000000000000000000";
    WAIT UNTIL clkm = '1';
    apbi.paddr(7 DOWNTO 2)   <= "001011";
    apbi.pwdata              <= "10010000000000000000000000000000";
    WAIT UNTIL clkm = '1';
    apbi.paddr(7 DOWNTO 2)   <= "001100";
    apbi.pwdata              <= "10100000000000000000000000000000";
    WAIT UNTIL clkm = '1';
    apbi.paddr(7 DOWNTO 2)   <= "001101";
    apbi.pwdata              <= "10110000000000000000000000000000";
    WAIT UNTIL clkm = '1';
    apbi.paddr(7 DOWNTO 2)   <= "001110";
    apbi.pwdata(11 DOWNTO 0) <= "000000000000";
    WAIT UNTIL clkm = '1';
    apbi.paddr(7 DOWNTO 2)   <= "001111";
    apbi.pwdata(15 DOWNTO 0) <= "0000000000000001";      -- A => 1 * 100 ms
    WAIT UNTIL clkm = '1';
    apbi.paddr(7 DOWNTO 2)   <= "010000";                -- delta_f2_f1
    apbi.pwdata(15 DOWNTO 0) <= "0000000001111000";      -- 0x78 = 120
    WAIT UNTIL clkm = '1';
    apbi.paddr(7 DOWNTO 2)   <= "010001";                -- delta_f2_f0
    apbi.pwdata(19 DOWNTO 0) <= "00000000001011111000";  -- 0x2f8 = 760
    WAIT UNTIL clkm = '1';
    apbi.paddr(7 DOWNTO 2)   <= "010010";                -- nb_burst_available
    apbi.pwdata(11 DOWNTO 0) <= "000000001100";          -- 12 = 0xC
    WAIT UNTIL clkm = '1';
    apbi.paddr(7 DOWNTO 2)   <= "010011";                -- nb_snapshot_param
    apbi.pwdata(11 DOWNTO 0) <= "000000001111";          -- 15 (+ 1)
    WAIT UNTIL clkm = '1';
    WAIT UNTIL clkm = '1';
    WAIT UNTIL clkm = '1';
    WAIT UNTIL clkm = '1';
    WAIT UNTIL clkm = '1';
    apbi.paddr(7 DOWNTO 2)   <= "001001";
    apbi.pwdata(6 DOWNTO 0)  <= "0000111";
    WAIT UNTIL clkm = '1';
    apbi.psel(15)            <= '1';
    apbi.penable             <= '0';
    apbi.pwrite              <= '0';
    WAIT UNTIL clkm = '1';

    WAIT;

  END PROCESS WaveGen_Proc;


  ahbmi.HGRANT(2)       <= '1';
  ahbmi.HREADY          <= '1';
  ahbmi.HRESP           <= HRESP_OKAY;
  


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- DUT ------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

  top_ad_conv_RHF1401_1 : top_ad_conv_RHF1401
    GENERIC MAP (
      ChanelCount     => 8,
      ncycle_cnv_high => 79,
      ncycle_cnv      => 500)
    PORT MAP (
      cnv_clk  => clk49_152MHz,
      cnv_rstn => rstn,

      cnv => ADC_smpclk,

      clk        => clkm,
      rstn       => rstn,
      ADC_data   => ADC_data,
      ADC_nOE    => ADC_OEB_bar_CH,
      sample     => sample,
      sample_val => sample_val);

  waveform_picker0 : top_wf_picker
    GENERIC MAP(
      hindex                  => 2,
      pindex                  => 15,
      paddr                   => 15,
      pmask                   => 16#fff#,
      pirq                    => 14,
      tech                    => inferred,
      nb_burst_available_size => 12,  -- size of the register holding the nb of burst
      nb_snapshot_param_size  => 12,  -- size of the register holding the snapshots size
      delta_snapshot_size     => 16,    -- snapshots period
      delta_f2_f0_size        => 20,  -- initialize the counter when the f2 snapshot starts 
      delta_f2_f1_size        => 16,  -- nb f0 ticks before starting the f1 snapshot
      ENABLE_FILTER           => '0'
      )
    PORT MAP(
      sample          => sample,
      sample_val      => sample_val,
      --
      cnv_clk         => clk49_152MHz,
      cnv_rstn        => rstn,
      -- AMBA AHB system signals
      HCLK            => clkm,
      HRESETn         => rstn,
      -- AMBA APB Slave Interface
      apbi            => apbi,
      apbo            => apbo(15),
      -- AMBA AHB Master Interface
      AHB_Master_In   => ahbmi,
      AHB_Master_Out  => ahbmo(2),
      --
      coarse_time_0   => coarse_time_0,  -- bit 0 of the coarse time
      -- 
      data_shaping_BW => bias_fail_sw
      );
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

END Behavioral;
