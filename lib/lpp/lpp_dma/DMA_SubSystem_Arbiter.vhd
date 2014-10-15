LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY lpp;
USE lpp.lpp_ad_conv.ALL;
USE lpp.iir_filter.ALL;
USE lpp.FILTERcfg.ALL;
USE lpp.lpp_memory.ALL;
USE lpp.lpp_waveform_pkg.ALL;
USE lpp.lpp_dma_pkg.ALL;
USE lpp.lpp_top_lfr_pkg.ALL;
USE lpp.lpp_lfr_pkg.ALL;
USE lpp.general_purpose.ALL;

LIBRARY techmap;
USE techmap.gencomp.ALL;

LIBRARY grlib;
USE grlib.amba.ALL;
USE grlib.stdlib.ALL;
USE grlib.devices.ALL;
USE GRLIB.DMA2AHB_Package.ALL;

ENTITY DMA_SubSystem_Arbiter IS

  PORT (
    clk                            : IN  STD_LOGIC;
    rstn                           : IN  STD_LOGIC;
    run                            : IN  STD_LOGIC;
    --
    data_burst_valid         : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
    data_burst_valid_grant   : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
    );

END DMA_SubSystem_Arbiter;


ARCHITECTURE beh OF DMA_SubSystem_Arbiter IS

  SIGNAL data_burst_valid_r : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL dma_rr_grant_s  : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL dma_rr_grant_ms : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL dma_rr_valid_ms : STD_LOGIC_VECTOR(3 DOWNTO 0);
  
BEGIN  -- beh
  -----------------------------------------------------------------------------
  -- REG the burst valid signal
  -----------------------------------------------------------------------------
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      data_burst_valid_r <= (OTHERS => '0');
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      IF run = '1' THEN
        data_burst_valid_r <= data_burst_valid;
      ELSE
        data_burst_valid_r <= (OTHERS => '0');
      END IF;

    END IF;
  END PROCESS;

  -----------------------------------------------------------------------------
  -- ARBITER Between all the "WAVEFORM_PICKER" channel
  -----------------------------------------------------------------------------
  RR_Arbiter_4_1 : RR_Arbiter_4
    PORT MAP (
      clk       => clk,
      rstn      => rstn,
      in_valid  => data_burst_valid_r(3 DOWNTO 0),
      out_grant => dma_rr_grant_s);

  dma_rr_valid_ms(0) <= data_burst_valid_r(4);--data_ms_valid OR data_ms_valid_burst;
  dma_rr_valid_ms(1) <= '0' WHEN dma_rr_grant_s = "0000" ELSE '1';
  dma_rr_valid_ms(2) <= '0';
  dma_rr_valid_ms(3) <= '0';

  -----------------------------------------------------------------------------
  -- ARBITER Between all the "WAVEFORM_PICKER" and "SPECTRAL MATRIX"
  -----------------------------------------------------------------------------

  RR_Arbiter_4_2 : RR_Arbiter_4
    PORT MAP (
      clk       => clk,
      rstn      => rstn,
      in_valid  => dma_rr_valid_ms,
      out_grant => dma_rr_grant_ms);

  data_burst_valid_grant <= dma_rr_grant_ms(0) & "0000" WHEN dma_rr_grant_ms(0) = '1' ELSE '0' & dma_rr_grant_s;
  

  
END beh;
