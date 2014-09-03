LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


LIBRARY lpp;
USE lpp.lpp_memory.ALL;
USE lpp.iir_filter.ALL;
USE lpp.spectral_matrix_package.ALL;
USE lpp.lpp_dma_pkg.ALL;
USE lpp.lpp_Header.ALL;
USE lpp.lpp_matrix.ALL;
USE lpp.lpp_matrix.ALL;
USE lpp.lpp_lfr_pkg.ALL;
USE lpp.lpp_fft.ALL;
USE lpp.fft_components.ALL;

ENTITY lpp_lfr_ms IS
  GENERIC (
    Mem_use : INTEGER := use_RAM
    );
  PORT (
    clk  : IN STD_LOGIC;
    rstn : IN STD_LOGIC;

    );
END;

ARCHITECTURE Behavioral OF lpp_lfr_ms IS
  
BEGIN

  -----------------------------------------------------------------------------
  
  lppFIFOxN_f0_a : lppFIFOxN
    GENERIC MAP (
      tech    => 0,
      Mem_use => Mem_use,
      Data_sz => 16,
      Addr_sz => 8,
      FifoCnt => 5)
    PORT MAP (
      clk  => clk,
      rstn => rstn,

      ReUse       => (OTHERS => '0'),

      wen         => sample_f0_A_wen,
      wdata       => sample_f0_wdata,

      ren         => sample_f0_A_ren,
      rdata       => sample_f0_A_rdata,

      empty       => sample_f0_A_empty,
      full        => sample_f0_A_full,
      almost_full => OPEN);             

  -----------------------------------------------------------------------------

  lpp_lfr_ms_FFT_1 : lpp_lfr_ms_FFT
    PORT MAP (
      clk            => clk,
      rstn           => rstn,
      sample_valid   => sample_valid,   -- WRITE in
      fft_read       => fft_read,       -- READ  in
      sample_data    => sample_data,    -- WRITE in
      sample_load    => sample_load,    -- WRITE out
      fft_pong       => fft_pong,       -- READ  out
      fft_data_im    => fft_data_im,    -- READ  out
      fft_data_re    => fft_data_re,    -- READ  out
      fft_data_valid => fft_data_valid, -- READ  out
      fft_ready      => fft_ready);     -- READ  out
  
  -----------------------------------------------------------------------------

END Behavioral;
