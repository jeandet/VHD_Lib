--------------------------------------------------------------------------------
-- Copyright 2007 Actel Corporation.  All rights reserved.

-- ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
-- ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
-- IN ADVANCE IN WRITING.

-- Revision 3.0 April 30, 2007 : v3.0 CoreFFT Release
-- File:  CoreFFT.vhd
-- Description: CoreFFT
--              Top level FFT module
-- Rev: 0.1 8/31/2005 4:53PM  VD  : Pre Production
-- Notes:   FFT In/out pins:
--  Input      |  Output    | Comments
-- ------------+------------+------------------  
--  clk        | ifoPong    |
--  ifiNreset  |            |async reset active low
--  start      |            |sync reset active high
-- Load Input data group    |
--  d_im[15:0] | load       |when high the inBuf is being loaded
--  d_re[15:0] |            |
--  d_valid    |            |
-- Upload Output data group |
--  read_y     | y_im[15:0] |
--             | y_re[15:0] |
--             | y_valid    |marks a new output sample)
--             | y_rdy      |when high the results are being uploaded
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
USE work.fft_components.all;

ENTITY CoreFFT IS
  GENERIC (
    LOGPTS      : integer := gLOGPTS;
    LOGLOGPTS   : integer := gLOGLOGPTS;
    WSIZE       : integer := gWSIZE;
    TWIDTH      : integer := gTWIDTH;
    DWIDTH      : integer := gDWIDTH;
    TDWIDTH     : integer := gTDWIDTH;
    RND_MODE    : integer := gRND_MODE;
    SCALE_MODE  : integer := gSCALE_MODE;
    PTS         : integer := gPTS;
    HALFPTS     : integer := gHALFPTS;
    inBuf_RWDLY : integer := gInBuf_RWDLY  );
  PORT (
    clk,ifiStart,ifiNreset : IN std_logic;
    ifiD_valid, ifiRead_y  : IN std_logic;
    ifiD_im, ifiD_re       : IN std_logic_vector(WSIZE-1 DOWNTO 0);
    ifoLoad, ifoPong       : OUT std_logic;
    ifoY_im, ifoY_re       : OUT std_logic_vector(WSIZE-1 DOWNTO 0);
    ifoY_valid, ifoY_rdy   : OUT std_logic);
END ENTITY CoreFFT;

ARCHITECTURE translated OF CoreFFT IS

  COMPONENT autoScale
    GENERIC (SCALE_MODE : integer := 1 );
    PORT (clk, clkEn, wLastStage : IN std_logic;
    ldRiskOV, bflyRiskOV   : IN std_logic;
    startLoad, ifo_loadOn  : IN std_logic;
    bflyOutValid, startFFT : IN std_logic;
    wEn_even, wEn_odd      : IN std_logic;
    upScale                : OUT std_logic);
  END COMPONENT;

  COMPONENT bfly2
    GENERIC ( RND_MODE : integer := 0;
              WSIZE    : integer := 16;
              DWIDTH   : integer := 32;
              TWIDTH   : integer := 16;
              TDWIDTH  : integer := 32 );
    PORT (clk, validIn : IN std_logic;
    swCrossIn        : IN std_logic;
    upScale          : IN std_logic;
    inP, inQ         : IN std_logic_vector(DWIDTH-1 DOWNTO 0);
    T                : IN std_logic_vector(TDWIDTH-1 DOWNTO 0);
    outP, outQ       : OUT std_logic_vector(DWIDTH-1 DOWNTO 0);
    validOut, swCrossOut : OUT std_logic);
  END COMPONENT;

  COMPONENT sm_top
    GENERIC ( PTS         : integer := 256;
              HALFPTS     : integer := 128;
              LOGPTS      : integer := 8;
              LOGLOGPTS   : integer := 3;
              inBuf_RWDLY : integer := 12 );    
    PORT (clk,clkEn       : IN std_logic;
    ifiStart, ifiNreset   : IN std_logic;
    ifiD_valid, ifiRead_y : IN std_logic;
    ldA, rA, wA, tA       : OUT std_logic_vector(LOGPTS-2 DOWNTO 0);
    twid_wA, outBuf_wA    : OUT std_logic_vector(LOGPTS-2 DOWNTO 0);
    outBuf_rA             : OUT std_logic_vector(LOGPTS-1 DOWNTO 0);
    wEn_even, wEn_odd     : OUT std_logic;
    preSwCross, twid_wEn  : OUT std_logic;
    inBuf_wEn, outBuf_wEn : OUT std_logic;
    smPong, ldValid       : OUT std_logic;
    inBuf_rdValid         : OUT std_logic;
    wLastStage            : OUT std_logic;
    smStartFFTrd          : OUT std_logic;
    smStartLoad, ifoLoad  : OUT std_logic;
    ifoY_valid, ifoY_rdy  : OUT std_logic);
  END COMPONENT;

  COMPONENT twiddle
    PORT (A : IN  std_logic_vector(LOGPTS-2 DOWNTO 0);
          T : OUT std_logic_vector(TDWIDTH-1 DOWNTO 0));
  END COMPONENT;

  COMPONENT pipoBuffer
    GENERIC ( LOGPTS  : integer := 8;
              DWIDTH  : integer := 32  );
    PORT (
      clk, clkEn, pong, rEn     : IN std_logic;
      rA, wA_load, wA_bfly      : IN std_logic_vector(LOGPTS-2 DOWNTO 0);
      ldData,wP_bfly,wQ_bfly    : IN std_logic_vector(DWIDTH-1 DOWNTO 0);
      wEn_bfly,wEn_even,wEn_odd : IN std_logic;
      outP, outQ                : OUT std_logic_vector(DWIDTH-1 DOWNTO 0) );
  END COMPONENT;

  COMPONENT switch
    GENERIC ( DWIDTH  : integer := 16 );
    PORT (clk, sel, validIn : IN std_logic;
      inP, inQ              : IN std_logic_vector(DWIDTH-1 DOWNTO 0);
      outP, outQ            : OUT std_logic_vector(DWIDTH-1 DOWNTO 0);
      validOut              : OUT std_logic);
  END COMPONENT;

  COMPONENT twidLUT
    GENERIC ( LOGPTS  : integer := 8;
              TDWIDTH : integer := 32  );
    PORT (clk, wEn : IN std_logic;
      wA, rA       : IN std_logic_vector(LOGPTS-2 DOWNTO 0);
      D            : IN std_logic_vector(TDWIDTH-1 DOWNTO 0);
      Q            : OUT std_logic_vector(TDWIDTH-1 DOWNTO 0));
  END COMPONENT;

  COMPONENT outBuff
    GENERIC ( LOGPTS  : integer := 8;
              DWIDTH  : integer := 32  );
    PORT (clk, clkEn, wEn : IN std_logic;
      inP, inQ            : IN std_logic_vector(DWIDTH-1 DOWNTO 0);
      wA                  : IN std_logic_vector(LOGPTS-2 DOWNTO 0);
      rA                  : IN std_logic_vector(LOGPTS-1 DOWNTO 0);
      outD                : OUT std_logic_vector(DWIDTH-1 DOWNTO 0));
  END COMPONENT;

  SIGNAL ldA_w, rA_w      :  std_logic_vector(LOGPTS-2 DOWNTO 0);
  SIGNAL wA_w, tA_w       :  std_logic_vector(LOGPTS-2 DOWNTO 0);
  SIGNAL twid_wA_w        :  std_logic_vector(LOGPTS-2 DOWNTO 0);
  SIGNAL outBuf_wA_w      :  std_logic_vector(LOGPTS-2 DOWNTO 0);
  SIGNAL outBuf_rA_w      :  std_logic_vector(LOGPTS-1 DOWNTO 0);
  SIGNAL wEn_even_w       :  std_logic;
  SIGNAL wEn_odd_w        :  std_logic;
  SIGNAL inBuf_wEn_w      :  std_logic;
  SIGNAL preSwCross_w     :  std_logic;
  SIGNAL postSwCross_w    :  std_logic;
  SIGNAL twid_wEn_w       :  std_logic;
  SIGNAL outBuf_wEn_w     :  std_logic;
  SIGNAL ldRiskOV_w       :  std_logic;
  SIGNAL bflyRiskOV_w     :  std_logic;
  SIGNAL readP_w          :  std_logic_vector(DWIDTH-1 DOWNTO 0);
  SIGNAL readQ_w          :  std_logic_vector(DWIDTH-1 DOWNTO 0);
  SIGNAL bflyInP_w        :  std_logic_vector(DWIDTH-1 DOWNTO 0);
  SIGNAL bflyInQ_w        :  std_logic_vector(DWIDTH-1 DOWNTO 0);
  SIGNAL bflyOutP_w       :  std_logic_vector(DWIDTH-1 DOWNTO 0);
  SIGNAL bflyOutQ_w       :  std_logic_vector(DWIDTH-1 DOWNTO 0);
  SIGNAL T_w              :  std_logic_vector(TDWIDTH-1 DOWNTO 0);
  SIGNAL twidData_w       :  std_logic_vector(TDWIDTH-1 DOWNTO 0);
  SIGNAL outEven_w        :  std_logic_vector(DWIDTH-1 DOWNTO 0);
  SIGNAL outOdd_w         :  std_logic_vector(DWIDTH-1 DOWNTO 0);
  SIGNAL inBufValid_w     :  std_logic;
  SIGNAL preSwValid_w     :  std_logic;
  SIGNAL bflyValid_w      :  std_logic;
  SIGNAL wLastStage_w     :  std_logic;
  SIGNAL startFFTrd_w     :  std_logic;
  SIGNAL startLoad_w      :  std_logic;
  SIGNAL upScale_w        :  std_logic;
  SIGNAL port_xhdl15      :  std_logic;
  SIGNAL xhdl_17          :  std_logic_vector(DWIDTH-1 DOWNTO 0);
  SIGNAL xhdl_23          :  std_logic_vector(DWIDTH-1 DOWNTO 0);
  SIGNAL clkEn_const      :  std_logic;
  SIGNAL ifoLoad_xhdl1    :  std_logic;
  SIGNAL ifoY_im_xhdl2    :  std_logic_vector(WSIZE-1 DOWNTO 0);
  SIGNAL ifoY_re_xhdl3    :  std_logic_vector(WSIZE-1 DOWNTO 0);
  SIGNAL ifoPong_xhdl4    :  std_logic;
  SIGNAL ifoY_valid_xhdl5 :  std_logic;
  SIGNAL ifoY_rdy_xhdl6   :  std_logic;
  SIGNAL displayBflyOutP  :  std_logic;
  SIGNAL displayBflyOutQ  :  std_logic;
  SIGNAL displayInBuf_wEn :  std_logic;
  SIGNAL ldValid_w        :  std_logic;

BEGIN
  ifoLoad <= ifoLoad_xhdl1;
  ifoY_im <= ifoY_im_xhdl2;
  ifoY_re <= ifoY_re_xhdl3;
  ifoPong <= ifoPong_xhdl4;
  ifoY_valid <= ifoY_valid_xhdl5;
  ifoY_rdy <= ifoY_rdy_xhdl6;
  -- debug only
  displayBflyOutP <= bflyOutP_w(0) ;
  displayBflyOutQ <= bflyOutQ_w(0) ;
  displayInBuf_wEn <= inBuf_wEn_w ;
  port_xhdl15 <= '1';

  smTop_0 : sm_top
    GENERIC MAP ( PTS => PTS, HALFPTS => HALFPTS,
      LOGPTS => LOGPTS, LOGLOGPTS => LOGLOGPTS, inBuf_RWDLY => inBuf_RWDLY )
    PORT MAP (
      clk => clk,
      clkEn => port_xhdl15,
      ifiStart => ifiStart,
      ifiNreset => ifiNreset,
      ifiD_valid => ifiD_valid,
      ifiRead_y => ifiRead_y,
      ldA => ldA_w,
      rA => rA_w,
      wA => wA_w,
      tA => tA_w,
      twid_wA => twid_wA_w,
      outBuf_wA => outBuf_wA_w,
      outBuf_rA => outBuf_rA_w,
      wEn_even => wEn_even_w,
      wEn_odd => wEn_odd_w,
      preSwCross => preSwCross_w,
      twid_wEn => twid_wEn_w,
      inBuf_wEn => inBuf_wEn_w,
      outBuf_wEn => outBuf_wEn_w,
      smPong => ifoPong_xhdl4,
      ldValid => ldValid_w,
      inBuf_rdValid => inBufValid_w,
      wLastStage => wLastStage_w,
      smStartFFTrd => startFFTrd_w,
      smStartLoad => startLoad_w,
      ifoLoad => ifoLoad_xhdl1,
      ifoY_valid => ifoY_valid_xhdl5,
      ifoY_rdy => ifoY_rdy_xhdl6);

  xhdl_17 <= ifiD_im & ifiD_re;

  inBuf_0 : pipoBuffer
    GENERIC MAP ( LOGPTS => LOGPTS,
                  DWIDTH => DWIDTH  )
    PORT MAP (
      clk => clk,
      clkEn => '1',
      rEn => '1',
      rA => rA_w,
      wA_load => ldA_w,
      wA_bfly => wA_w,
      ldData => xhdl_17,
      wP_bfly => outEven_w,
      wQ_bfly => outOdd_w,
      wEn_bfly => inBuf_wEn_w,
      wEn_even => wEn_even_w,
      wEn_odd => wEn_odd_w,
      pong => ifoPong_xhdl4,
      outP => readP_w,
      outQ => readQ_w);

  preBflySw_0 : switch
    GENERIC MAP ( DWIDTH => DWIDTH )
    PORT MAP (
      clk => clk,
      inP => readP_w,
      inQ => readQ_w,
      sel => preSwCross_w,
      outP => bflyInP_w,
      outQ => bflyInQ_w,
      validIn => inBufValid_w,
      validOut => preSwValid_w);

  bfly_0 : bfly2
    GENERIC MAP (RND_MODE => RND_MODE, WSIZE => WSIZE, DWIDTH => DWIDTH,
                 TWIDTH => TWIDTH,  TDWIDTH => TDWIDTH )
    PORT MAP (
      clk => clk,
      upScale => upScale_w,
      inP => bflyInP_w,
      inQ => bflyInQ_w,
      T => T_w,
      outP => bflyOutP_w,
      outQ => bflyOutQ_w,
      validIn => preSwValid_w,
      validOut => bflyValid_w,
      swCrossIn => preSwCross_w,
      swCrossOut => postSwCross_w);

  lut_0 : twiddle
    PORT MAP (A => twid_wA_w,  T => twidData_w);

  twidLUT_1 : twidLUT
    GENERIC MAP ( LOGPTS => LOGPTS, TDWIDTH => TDWIDTH )
    PORT MAP (
      clk => clk,
      wA => twid_wA_w,
      wEn => twid_wEn_w,
      rA => tA_w,
      D => twidData_w,
      Q => T_w);

  postBflySw_0 : switch
    GENERIC MAP ( DWIDTH => DWIDTH )
    PORT MAP (
      clk => clk,
      inP => bflyOutP_w,
      inQ => bflyOutQ_w,
      sel => postSwCross_w,
      outP => outEven_w,
      outQ => outOdd_w,
      validIn => bflyValid_w,
      validOut => open);

  ifoY_im_xhdl2 <= xhdl_23(DWIDTH-1 DOWNTO WSIZE);
  ifoY_re_xhdl3 <= xhdl_23(WSIZE-1 DOWNTO 0);
  outBuff_0 : outBuff
    GENERIC MAP( LOGPTS => LOGPTS, DWIDTH => DWIDTH )
    PORT MAP (
      clk => clk, clkEn => '1',
      rA => outBuf_rA_w,
      wA => outBuf_wA_w,
      inP => outEven_w,
      inQ => outOdd_w,
      wEn => outBuf_wEn_w,
      outD => xhdl_23);

  -- Autoscaling
  -- monitor if input data .im and .re have MSB == sign
  ldRiskOV_w <= to_logic(
    NOT ((ifiD_im(WSIZE-1) = ifiD_im(WSIZE-2))
    AND (ifiD_re(WSIZE-1) = ifiD_re(WSIZE-2)))   );

  bflyRiskOV_w <= to_logic(
    NOT ((((bflyOutP_w(DWIDTH-1) = bflyOutP_w(DWIDTH- 2))
    AND (bflyOutP_w(WSIZE-1) = bflyOutP_w(WSIZE-2)))
    AND (bflyOutQ_w(DWIDTH-1) = bflyOutQ_w(DWIDTH-2)))
    AND (bflyOutQ_w(WSIZE-1) = bflyOutQ_w(WSIZE-2)))    );
  clkEn_const <= '1';
  autoScale_0 : autoScale
    GENERIC MAP (SCALE_MODE => SCALE_MODE) 
    PORT MAP (
      clk => clk,
      clkEn => clkEn_const,
      ldRiskOV => ldRiskOV_w,
      bflyRiskOV => bflyRiskOV_w,
      startLoad => startLoad_w,
      startFFT => startFFTrd_w,
      bflyOutValid => bflyValid_w,
      wLastStage => wLastStage_w,
      wEn_even => wEn_even_w,
      wEn_odd => wEn_odd_w,
      ifo_loadOn => ifoLoad_xhdl1,
      upScale => upScale_w);

END ARCHITECTURE translated;