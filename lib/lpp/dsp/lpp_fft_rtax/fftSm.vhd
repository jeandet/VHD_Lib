--------------------------------------------------------------------------------
-- Copyright 2007 Actel Corporation.  All rights reserved.

-- ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
-- ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
-- IN ADVANCE IN WRITING.

-- Revision 3.0 April 30, 2007 : v3.0 CoreFFT Release
-- File:  fftSm.vhd
-- Description: CoreFFT
--              FFT state machine module
-- Rev: 3.0 3/28/2007 4:43PM  VlaD  : Variable bitwidth
--
--
--------------------------------------------------------------------------------
--**************************  TWIDDLE rA GENERATOR  **************************
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;
USE work.fft_components.all;

ENTITY twid_rA IS
  GENERIC (LOGPTS    : integer := 8;
           LOGLOGPTS : integer := 3  );
  PORT (clk     : IN std_logic;
        timer   : IN std_logic_vector(LOGPTS-2 DOWNTO 0);
        stage   : IN std_logic_vector(LOGLOGPTS-1 DOWNTO 0);
        tA      : OUT std_logic_vector(LOGPTS-2 DOWNTO 0));
END ENTITY twid_rA;

ARCHITECTURE translated OF twid_rA IS
  CONSTANT timescale         : time := 1 ns;
  --twiddleMask = ~(0xFFFFFFFF<<(NumberOfStages-1));
  --addrTwiddle=reverseBits(count, NumberOfStages-1)<<(NumberOfStages-1-stage);
  --mask out extra left bits: addrTwiddle = addrTwiddle & twiddleMask;
  --reverse bits of the timer;
  SIGNAL reverseBitTimer          :  bit_vector(LOGPTS-2 DOWNTO 0);
  SIGNAL tA_w, tA_reg             :  std_logic_vector(LOGPTS-2 DOWNTO 0);

BEGIN
  tA <= tA_reg;
  PROCESS (timer)
    BEGIN
      reverseBitTimer <= reverse(timer);
  END PROCESS;
  -- Left shift by
  tA_w <= To_StdLogicVector(reverseBitTimer SLL (LOGPTS-1 - to_integer(stage)) )
          AFTER timescale;

  PROCESS (clk)
  BEGIN
    IF (clk'EVENT AND clk = '1') THEN
      tA_reg <= tA_w AFTER timescale;
    END IF;
  END PROCESS;
END ARCHITECTURE translated;
--------------------------------------------------------------------------------
--*****************************  TIMERS & rdValid  ***************************
-- FFT computation sequence is predefined.  Once it gets started it runs for
-- a number of stages, `HALFPTS+ clk per stage.  The following module sets the
-- read inBuf time sequence.  Every stage takes HALFPTS + inBuf_RWDLY clk for
-- the inBuf to write Bfly results back in place before it starts next stage
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE work.fft_components.all;

ENTITY rdFFTtimer IS
  GENERIC (LOGPTS      : integer := 8;
           LOGLOGPTS   : integer := 3;
           HALFPTS     : integer := 128;
           inBuf_RWDLY : integer := 12  );
  PORT (
    clk, cntEn, rst, nGrst  : IN std_logic;
    startFFT, fft_runs      : IN std_logic;
    timerTC, lastStage      : OUT std_logic; --terminal counts of rA and stage
    stage                   : OUT std_logic_vector(LOGLOGPTS-1 DOWNTO 0);
    timer                   : OUT std_logic_vector(LOGPTS-1 DOWNTO 0);
    rdValid                 : OUT std_logic     );
END ENTITY rdFFTtimer;

ARCHITECTURE translated OF rdFFTtimer IS
  CONSTANT dlta         : time := 1 ns;

  SIGNAL preRdValid          :  std_logic;
  SIGNAL pipe1, pipe2        :  std_logic;
  SIGNAL rst_comb, timerTCx1 :  std_logic;
  SIGNAL lastStage_xhdl2     :  std_logic;
  SIGNAL stage_xhdl3         :  std_logic_vector(LOGLOGPTS-1 DOWNTO 0);
  SIGNAL timer_xhdl4         :  std_logic_vector(LOGPTS-1 DOWNTO 0);
  SIGNAL rdValid_xhdl5       :  std_logic;

BEGIN
  timerTC <= timerTCx1;
  lastStage <= lastStage_xhdl2;
  stage <= stage_xhdl3;
  timer <= timer_xhdl4;
  rdValid <= rdValid_xhdl5;
  rst_comb <= rst OR startFFT;

  rA_timer : counter
    GENERIC MAP (WIDTH =>LOGPTS, TERMCOUNT =>HALFPTS+inBuf_RWDLY-1)
    PORT MAP (clk => clk, nGrst => nGrst, rst => rst_comb,
              cntEn => cntEn, tc => timerTCx1, Q => timer_xhdl4);
  stage_timer : counter
    GENERIC MAP (WIDTH => LOGLOGPTS, TERMCOUNT => LOGPTS-1)
    PORT MAP (clk => clk,     nGrst => nGrst,   rst => rst_comb,
              cntEn => timerTCx1,  tc => lastStage_xhdl2,
              Q => stage_xhdl3);

  PROCESS (clk, nGrst)
  BEGIN
    IF (NOT nGrst = '1') THEN
      preRdValid <= '0';
    ELSIF (clk'EVENT AND clk = '1') THEN
      IF (rst = '1') THEN
        preRdValid <= '0' AFTER dlta;
      ELSE
        IF (cntEn = '1') THEN
          IF ( to_integer(timer_xhdl4) = HALFPTS-1 ) THEN
            preRdValid <= '0' AFTER dlta;
          END IF;
          -- on startFFT the valid reading session always starts
          IF (startFFT = '1') THEN preRdValid <= '1' AFTER dlta;
          END IF;
          -- reading session starts on rTimerTC except after the lastStage
          IF ((((NOT lastStage_xhdl2) AND timerTCx1) AND fft_runs) = '1') THEN
            preRdValid <= '1' AFTER dlta;
          END IF;
        END IF;
      END IF;
    END IF;
  END PROCESS;

  PROCESS (clk)
  BEGIN
    IF (clk'EVENT AND clk = '1') THEN
      rdValid_xhdl5 <= pipe2 AFTER dlta;
      pipe2 <= pipe1 AFTER dlta;
      pipe1 <= preRdValid AFTER dlta;
    END IF;
  END PROCESS;
END ARCHITECTURE translated;
--------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE work.fft_components.all;

ENTITY wrFFTtimer IS
  GENERIC (LOGPTS      : integer := 8;
           LOGLOGPTS   : integer := 3;
           HALFPTS     : integer := 128  );
  PORT (
    clk, cntEn, nGrst, rst : IN std_logic;
    rstStage, rstTime      : IN std_logic;
    timerTC, lastStage     : OUT std_logic; --  terminal counts of wA and stage
    stage                  : OUT std_logic_vector(LOGLOGPTS-1 DOWNTO 0);
    timer                  : OUT std_logic_vector(LOGPTS-2 DOWNTO 0));
END ENTITY wrFFTtimer;

ARCHITECTURE translated OF wrFFTtimer IS
  CONSTANT timescale         : time := 1 ns;

  SIGNAL rst_VHDL,rstStage_VHDL :  std_logic;
  SIGNAL timerTC_xhdl1          :  std_logic;
  SIGNAL lastStage_xhdl2        :  std_logic;
  SIGNAL stage_xhdl3            :  std_logic_vector(LOGLOGPTS-1 DOWNTO 0);
  SIGNAL timer_xhdl4            :  std_logic_vector(LOGPTS-2 DOWNTO 0);

BEGIN
  timerTC <= timerTC_xhdl1;
  lastStage <= lastStage_xhdl2;
  stage <= stage_xhdl3;
  timer <= timer_xhdl4;
  rst_VHDL <= rstTime OR rst;
  wA_timer : counter
    GENERIC MAP (WIDTH => LOGPTS-1, TERMCOUNT =>HALFPTS-1)
    PORT MAP (clk => clk, nGrst => nGrst, rst => rst_VHDL, cntEn => cntEn,
              tc => timerTC_xhdl1, Q => timer_xhdl4);
    rstStage_VHDL <= rstStage OR rst;

    stage_timer : counter
      GENERIC MAP (WIDTH => LOGLOGPTS, TERMCOUNT =>LOGPTS-1)
      PORT MAP (clk => clk, nGrst => nGrst, rst => rstStage_VHDL,
                  cntEn => timerTC_xhdl1, tc => lastStage_xhdl2,
                  Q => stage_xhdl3);
END ARCHITECTURE translated;
--------------------------------------------------------------------------------
--********************* inBuf LOAD ADDRESS GENERATOR *********************
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE work.fft_components.all;

ENTITY inBuf_ldA IS
  GENERIC (PTS    : integer := 256;
           LOGPTS : integer := 8  );
  PORT (
    clk, clkEn, nGrst       : IN std_logic;
    --comes from topSM to reset ldA count & start another loading cycle
    startLoad               : IN std_logic;
    ifi_dataRdy             : IN std_logic; -- inData strobe
    ifo_loadOn              : OUT std_logic;-- inBuf is ready for new data
    --tells topSM the buffer is fully loaded and ready for FFTing
    load_done               : OUT std_logic;
    ldA                     : OUT std_logic_vector(LOGPTS-1 DOWNTO 1);
    wEn_even, wEn_odd       : OUT std_logic;
    ldValid                 : OUT std_logic);
END ENTITY inBuf_ldA;

ARCHITECTURE translated OF inBuf_ldA IS
  CONSTANT timescale         : time := 1 ns;

  -- just LSB of the counter below. Counts even/odd samples
  SIGNAL ldCountLsb_w          :  std_logic;
  SIGNAL closeLoad_w, cntEn_w  :  std_logic;
  SIGNAL loadOver_w            :  std_logic;
  SIGNAL xhdl_9                :  std_logic_vector(LOGPTS-1 DOWNTO 0);
  SIGNAL ifo_loadOn_int        :  std_logic;
  SIGNAL load_done_int         :  std_logic;
  SIGNAL ldA_int               :  std_logic_vector(LOGPTS-1 DOWNTO 1);
  SIGNAL wEn_even_int          :  std_logic;
  SIGNAL wEn_odd_int           :  std_logic;
  SIGNAL ldValid_int           :  std_logic;

BEGIN
  ifo_loadOn <= ifo_loadOn_int;
  load_done <= load_done_int;
  ldA <= ldA_int;
  wEn_even <= wEn_even_int;
  wEn_odd <= wEn_odd_int;
  ldValid <= ldValid_int;
  cntEn_w <= clkEn AND ifi_dataRdy ;
  loadOver_w <= closeLoad_w AND wEn_odd_int ;
  ldValid_int <= ifo_loadOn_int AND ifi_dataRdy ;
  wEn_even_int <= NOT ldCountLsb_w AND ldValid_int ;
  wEn_odd_int <= ldCountLsb_w AND ldValid_int ;
--  xhdl_9 <= ldA_int & ldCountLsb_w;
  ldA_int <= xhdl_9(LOGPTS-1 DOWNTO 1);
  ldCountLsb_w <= xhdl_9(0);
  -- counts samples loaded.  There is `PTS samples to load, not `PTS/2
  ldCount : counter
    GENERIC MAP (WIDTH =>LOGPTS, TERMCOUNT =>PTS-1)
    PORT MAP (clk => clk, nGrst => nGrst, rst => startLoad,
              cntEn => cntEn_w, tc => closeLoad_w, Q => xhdl_9);

    -- A user can stop supplying ifi_dataRdy after loadOver gets high, thus
    -- the loadOver can stay high indefinitely.  Shorten it!
  edge_0 : edgeDetect
    GENERIC MAP (INPIPE => 0, FEDGE => 1)
    PORT MAP (clk => clk, clkEn => clkEn, edgeIn => loadOver_w,
              edgeOut => load_done_int);

    PROCESS (clk, nGrst)
    BEGIN
      -- generate ifo_loadOn:
      IF (NOT nGrst = '1') THEN
        ifo_loadOn_int <= '0';
      ELSE
        IF (clk'EVENT AND clk = '1') THEN
          IF (clkEn = '1') THEN
            -- if (load_done) ifo_loadOn <= #1 0;
            IF (loadOver_w = '1') THEN
              ifo_loadOn_int <= '0' AFTER timescale;
            ELSE
              IF (startLoad = '1') THEN
                ifo_loadOn_int <= '1' AFTER timescale;
              END IF;
            END IF;
          END IF;
        END IF;
      END IF;
    END PROCESS;
END ARCHITECTURE translated;
--------------------------------------------------------------------------------
--******************  inBuf ADDRESS GENERATOR for BFLY DATA  *****************
-- Implements both read and write data generators.  The core utilizes inPlace
-- algorithm thus the wA is a delayed copy of the rA
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;
USE work.fft_components.all;

ENTITY inBuf_fftA IS
  GENERIC (LOGPTS    : integer := 8;
           LOGLOGPTS : integer := 3  );
  PORT (
    clk, clkEn         :IN std_logic;
    timer              :IN std_logic_vector(LOGPTS-2 DOWNTO 0);
    stage              :IN std_logic_vector(LOGLOGPTS-1 DOWNTO 0);
    timerTC, lastStage :IN std_logic;
    fftDone, swCross   :OUT std_logic;
    bflyA              :OUT std_logic_vector(LOGPTS-2 DOWNTO 0));
END ENTITY inBuf_fftA;

ARCHITECTURE translated OF inBuf_fftA IS
  CONSTANT timescale   : time := 1 ns;
  CONSTANT offsetConst : bit_vector(LOGPTS-1 DOWNTO 0):=('1', others=>'0');
  CONSTANT  addrMask1: BIT_VECTOR(LOGPTS-1 DOWNTO 0) := ('0', OTHERS=>'1');
  CONSTANT  addrMask2: BIT_VECTOR(LOGPTS-1 DOWNTO 0) := (OTHERS=>'1');

  SIGNAL fftDone_w, swCross_w: std_logic;
  SIGNAL bflyA_w             : std_logic_vector(LOGPTS-2 DOWNTO 0);
  SIGNAL addrP_w, offsetPQ_w : std_logic_vector(LOGPTS-1 DOWNTO 0);
  --rA takes either Paddr or Qaddr value (Qaddr=Paddr+offsetPQ) per clock.
  --At even clk rA=Paddr, at odd clk rA=Qaddr. (Every addr holds a pair of
  --data samples).  Timer LSB controls which clk is happening now.  LSB of
  --the same timer controls switch(es).
  SIGNAL bflyA_w_int         :  std_logic_vector(LOGPTS-1 DOWNTO 1);
  SIGNAL swCross_w_int,swCross_int: std_logic;
  SIGNAL fftDone_int         :  std_logic;
  SIGNAL bflyA_int           :  std_logic_vector(LOGPTS-2 DOWNTO 0);

BEGIN
  fftDone <= fftDone_int;
  bflyA <= bflyA_int;
  swCross <= swCross_int;
  --addrP_w=( (timer<<1)&(~(addrMask2>>stage)) ) | (timer&(addrMask1>>stage));
  addrP_w <= To_StdLogicVector(
    ( (('0'& To_BitVector(timer)) SLL 1) AND (NOT (addrMask2 SRL to_integer(stage)) ) )
    OR ( ('0'& To_BitVector(timer)) AND (addrMask1 SRL to_integer(stage)) ) );

  -- address offset between P and Q offsetPQ_w= ( 1<<(`LOGPTS-1) )>>stage;
  offsetPQ_w <= To_StdLogicVector(offsetConst SRL to_integer(stage));

  -- bflyA_w = timer[0] ? (addrP_w[`LOGPTS-1:1]+offsetPQ_w[`LOGPTS-1:1]):
  --                                                 addrP_w[`LOGPTS-1:1];
  bflyA_w_int <=
    (addrP_w(LOGPTS-1 DOWNTO 1) + offsetPQ_w(LOGPTS-1 DOWNTO 1)) WHEN
      timer(0) = '1'
    ELSE addrP_w(LOGPTS-1 DOWNTO 1);

  bflyA_w <= bflyA_w_int  AFTER timescale;
  fftDone_w <= lastStage AND timerTC  AFTER timescale;
  swCross_w_int <= '0' WHEN lastStage = '1' ELSE timer(0);
  swCross_w <= swCross_w_int  AFTER timescale;

  PROCESS (clk)
  BEGIN
    IF (clk'EVENT AND clk = '1') THEN
      IF (clkEn = '1') THEN
        bflyA_int <= bflyA_w AFTER timescale;
        swCross_int <= swCross_w AFTER timescale;
        fftDone_int <= fftDone_w AFTER timescale;
      END IF;
    END IF;
  END PROCESS;
END ARCHITECTURE translated;
--------------------------------------------------------------------------------
--**************************  TWIDDLE wA GENERATOR  ****************************
-- initializes Twiddle LUT on rst based on contents of twiddle.v file.
-- Generates trueRst when the initialization is over
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE work.fft_components.all;

ENTITY twid_wAmod IS
  GENERIC (LOGPTS : integer := 8 );
  PORT (
    clk, ifiNreset    : IN std_logic;   --  async global reset
    twid_wA     : OUT std_logic_vector(LOGPTS-2 DOWNTO 0);
    twid_wEn,twidInit : OUT std_logic;
    rstAfterInit      : OUT std_logic);
END ENTITY twid_wAmod;

ARCHITECTURE translated OF twid_wAmod IS
  CONSTANT timescale         : time := 1 ns;
  CONSTANT allOnes : std_logic_vector(LOGPTS+1 DOWNTO 0):=(OTHERS=>'1');

  SIGNAL slowTimer_w      : std_logic_vector(LOGPTS+1 DOWNTO 0);
  SIGNAL preRstAfterInit  : std_logic;
  SIGNAL twid_wA_int      : std_logic_vector(LOGPTS-2 DOWNTO 0);
  SIGNAL twid_wEn_int     : std_logic;
  SIGNAL rstAfterInit_int : std_logic;
  SIGNAL twidInit_int     : std_logic;

BEGIN
  twid_wA <= twid_wA_int;
  twid_wEn <= twid_wEn_int;
  rstAfterInit <= rstAfterInit_int;
  twidInit <= twidInit_int;

  -- slow counter not to worry about the clk rate
  slowTimer : bcounter
    GENERIC MAP (WIDTH => LOGPTS+2)
    PORT MAP (clk => clk, nGrst => ifiNreset, rst => '0',
              cntEn => twidInit_int, Q => slowTimer_w);
  -- wEn = 2-clk wide for the RAM to have enough time
  twid_wEn_int <= to_logic(slowTimer_w(2 DOWNTO 1) = "11");
  twid_wA_int <= slowTimer_w(LOGPTS+1 DOWNTO 3);

  PROCESS (clk, ifiNreset)
  BEGIN
    IF (NOT ifiNreset = '1') THEN
      twidInit_int <= '1' AFTER timescale;
    ELSIF (clk'EVENT AND clk = '1') THEN
      rstAfterInit_int <= preRstAfterInit AFTER timescale;
      IF (slowTimer_w = allOnes) THEN twidInit_int <='0' AFTER timescale;
      END IF;
      preRstAfterInit <= to_logic(slowTimer_w = allOnes) AFTER timescale;
    END IF;
  END PROCESS;
END ARCHITECTURE translated;
--------------------------------------------------------------------------------
----------------------------------- outBufA ------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;
USE work.fft_components.all;

ENTITY outBufA IS
  GENERIC (PTS    : integer := 256;
           LOGPTS : integer := 8  );
  PORT (clk, clkEn, nGrst : IN std_logic;
    rst, outBuf_wEn       : IN std_logic;
    timer                 : IN std_logic_vector(LOGPTS-2 DOWNTO 0);
    -- host can slow down results reading by lowering the signal
    rdCtl                 : IN std_logic;
    wA                    : OUT std_logic_vector(LOGPTS-2 DOWNTO 0);
    rA                    : OUT std_logic_vector(LOGPTS-1 DOWNTO 0);
    outBuf_rEn, rdValid   : OUT std_logic);
END ENTITY outBufA;

ARCHITECTURE translated OF outBufA IS
  CONSTANT timescale         : time := 1 ns;

  SIGNAL reverseBitTimer, wA_w : std_logic_vector(LOGPTS-2 DOWNTO 0);
  SIGNAL outBufwEnFall_w       :  std_logic;
  SIGNAL rA_TC_w, preOutBuf_rEn:  std_logic;
  SIGNAL pipe11, pipe12, pipe21:  std_logic;
  SIGNAL pipe22, rdCtl_reg     :  std_logic;
  -- Reset a binary counter on the rear edge
  SIGNAL rstVhdl, rdValid_int  :  std_logic;
  SIGNAL wA_int                :  std_logic_vector(LOGPTS-2 DOWNTO 0);
  SIGNAL rA_int                :  std_logic_vector(LOGPTS-1 DOWNTO 0);
  SIGNAL outBuf_rEn_int        :  std_logic;

BEGIN
  wA <= wA_int;
  rA <= rA_int;
  outBuf_rEn <= outBuf_rEn_int;
  rdValid <= rdValid_int;

  PROCESS (timer)
    VARIABLE reverseBitTimer_int  : std_logic_vector(LOGPTS-2 DOWNTO 0);
  BEGIN
    reverseBitTimer_int := reverseStd(timer);
    reverseBitTimer <= reverseBitTimer_int;
  END PROCESS;
  wA_w <= reverseBitTimer AFTER timescale;
  -- rA generator.  Detect rear edge of the outBuf wEn
  fedge_0 : edgeDetect
    GENERIC MAP (INPIPE => 0, FEDGE => 1)
    PORT MAP (clk => clk, clkEn => '1', edgeIn => outBuf_wEn,
              edgeOut => outBufwEnFall_w);

    rstVhdl <= rst OR outBufwEnFall_w;

    outBuf_rA_0 : counter
      GENERIC MAP (WIDTH => LOGPTS, TERMCOUNT =>PTS-1)
      PORT MAP (clk => clk, nGrst => nGrst, rst => rstVhdl,
                cntEn => rdCtl_reg, tc => rA_TC_w, Q => rA_int);

      PROCESS (clk, nGrst)
      BEGIN
        -- RS FF preOutBuf_rEn
        IF (NOT nGrst = '1') THEN
          preOutBuf_rEn <= '0' AFTER timescale;
        ELSE
          IF (clk'EVENT AND clk = '1') THEN
            IF ((rst OR outBuf_wEn OR rA_TC_w) = '1') THEN
              preOutBuf_rEn <= '0' AFTER timescale;
            ELSE
              IF (outBufwEnFall_w = '1') THEN
                preOutBuf_rEn <= '1' AFTER timescale;
              END IF;
            END IF;
          END IF;
        END IF;
      END PROCESS;

      PROCESS (clk)
      BEGIN
        IF (clk'EVENT AND clk = '1') THEN
          wA_int <= wA_w AFTER timescale;
          rdCtl_reg <= rdCtl AFTER timescale;
          outBuf_rEn_int <= pipe12 AFTER timescale;
          pipe12 <= pipe11 AFTER timescale;
          pipe11 <= preOutBuf_rEn AFTER timescale;
          rdValid_int <= pipe22 AFTER timescale;
          pipe22 <= pipe21 AFTER timescale;
          pipe21 <= preOutBuf_rEn AND rdCtl_reg AFTER timescale;
        END IF;
      END PROCESS;
END ARCHITECTURE translated;
----------------------------------------------------------------------------------------------
--**********************************  SM TOP  ********************************
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.std_logic_arith.all;
USE work.fft_components.all;

ENTITY sm_top IS
  GENERIC ( PTS         : integer := 256;
            HALFPTS     : integer := 128;
            LOGPTS      : integer := 8;
            LOGLOGPTS   : integer := 3;
            inBuf_RWDLY : integer := 12 );
  PORT (clk,clkEn         : IN std_logic;
    ifiStart, ifiNreset   : IN std_logic; --sync and async reset
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
END ENTITY sm_top;

ARCHITECTURE translated OF sm_top IS
  CONSTANT timescale         : time := 1 ns;

  COMPONENT inBuf_fftA
    GENERIC (LOGPTS    : integer := 8;
             LOGLOGPTS : integer := 3  );
    PORT (clk, clkEn     : IN std_logic;
      timer              : IN std_logic_vector(LOGPTS-2 DOWNTO 0);
      stage              : IN std_logic_vector(LOGLOGPTS-1 DOWNTO 0);
      timerTC, lastStage : IN std_logic;
      fftDone, swCross   : OUT std_logic;
      bflyA              : OUT std_logic_vector(LOGPTS-2 DOWNTO 0) );
  END COMPONENT;

  COMPONENT inBuf_ldA
    GENERIC (PTS    : integer := 8;
             LOGPTS : integer := 3  );
    PORT (
    clk, clkEn, nGrst       : IN std_logic;
    startLoad, ifi_dataRdy  : IN std_logic;
    ifo_loadOn, load_done   : OUT std_logic;
    ldA                     : OUT std_logic_vector(LOGPTS-1 DOWNTO 1);
    wEn_even, wEn_odd       : OUT std_logic;
    ldValid                 : OUT std_logic);
  END COMPONENT;


  COMPONENT outBufA
    GENERIC (PTS    : integer := 256;
             LOGPTS : integer := 8  );
    PORT (clk,clkEn,nGrst         : IN std_logic;
          rst, outBuf_wEn, rdCtl  : IN std_logic;
          timer                   : IN std_logic_vector(LOGPTS-2 DOWNTO 0);
          wA                      : OUT std_logic_vector(LOGPTS-2 DOWNTO 0);
          rA                      : OUT std_logic_vector(LOGPTS-1 DOWNTO 0);
          outBuf_rEn, rdValid     : OUT std_logic);
  END COMPONENT;

  COMPONENT rdFFTtimer
    GENERIC (LOGPTS      : integer := 8;
             LOGLOGPTS   : integer := 3;
             HALFPTS     : integer := 128;
             inBuf_RWDLY : integer := 12  );
    PORT (clk, cntEn, rst     : IN std_logic;
      startFFT,fft_runs,nGrst : IN std_logic;
      timerTC, lastStage      : OUT std_logic;
      stage                   : OUT std_logic_vector(LOGLOGPTS-1 DOWNTO 0);
      timer                   : OUT std_logic_vector(LOGPTS-1 DOWNTO 0);
      rdValid                 : OUT std_logic     );
  END COMPONENT;

  COMPONENT twid_rA
    GENERIC (LOGPTS    : integer := 8;
             LOGLOGPTS : integer := 3  );
    PORT (
      clk       : IN  std_logic;
      timer     : IN  std_logic_vector(LOGPTS-2 DOWNTO 0);
      stage     : IN  std_logic_vector(LOGLOGPTS-1 DOWNTO 0);
      tA        : OUT std_logic_vector(LOGPTS-2 DOWNTO 0));
  END COMPONENT;

  COMPONENT twid_wAmod
    GENERIC (LOGPTS : integer := 8 );
    PORT (clk, ifiNreset: IN  std_logic;
      twid_wA           : OUT std_logic_vector(LOGPTS-2 DOWNTO 0);
      twid_wEn,twidInit : OUT std_logic;
      rstAfterInit      : OUT std_logic );
  END COMPONENT;

  COMPONENT wrFFTtimer
    GENERIC (LOGPTS      : integer := 8;
             LOGLOGPTS   : integer := 3;
             HALFPTS     : integer := 128  );
    PORT (
    clk, cntEn, nGrst, rst : IN std_logic;
    rstStage, rstTime      : IN std_logic;
    timerTC, lastStage     : OUT std_logic;
    stage                  : OUT std_logic_vector(LOGLOGPTS-1 DOWNTO 0);
    timer                  : OUT std_logic_vector(LOGPTS-2 DOWNTO 0));
  END COMPONENT;

  SIGNAL rTimer_w          : std_logic_vector(LOGPTS-1 DOWNTO 0);
  SIGNAL wTimer_w, timerT1 : std_logic_vector(LOGPTS-2 DOWNTO 0);
  SIGNAL rStage_w,wStage_w : std_logic_vector(LOGLOGPTS-1 DOWNTO 0);
  SIGNAL stageT1, stageT2  : std_logic_vector(LOGLOGPTS-1 DOWNTO 0);
  SIGNAL rLastStage_w      : std_logic;
  SIGNAL rTimerTC_w        : std_logic;
  SIGNAL wTimerTC_w        : std_logic;
  SIGNAL load_done_w       : std_logic;
  SIGNAL sync_rAwA         : std_logic;
  SIGNAL fftRd_done_w      : std_logic;
  SIGNAL preInBuf_wEn      : std_logic;
  SIGNAL preOutBuf_wEn     : std_logic;
  SIGNAL trueRst           : std_logic;
  SIGNAL smBuf_full        : std_logic;   --  top level SM registers
  SIGNAL smFft_rdy         : std_logic;   --  top level SM registers
  SIGNAL smFft_runs        : std_logic;   --  top level SM registers
  -- Reset logic:
  -- - On ifiNreset start loading twidLUT.
  -- - While it is loading keep global async rst nGrst active
  -- - Once load is over issue short rstAfterInit which is just another ifiStart
  SIGNAL initRst, nGrst         : std_logic;
  SIGNAL rstAfterInit           : std_logic;
  SIGNAL trueRst_w              : std_logic;
  SIGNAL xhdl_27, rdTimer_cntEn : std_logic;
  SIGNAL port_xhdl37       : std_logic_vector(LOGPTS-2 DOWNTO 0);
  SIGNAL ldA_xhdl1         : std_logic_vector(LOGPTS-2 DOWNTO 0);
  SIGNAL rA_xhdl2          : std_logic_vector(LOGPTS-2 DOWNTO 0);
  SIGNAL wA_xhdl3          : std_logic_vector(LOGPTS-2 DOWNTO 0);
  SIGNAL tA_xhdl4          : std_logic_vector(LOGPTS-2 DOWNTO 0);
  SIGNAL twid_wA_xhdl5     : std_logic_vector(LOGPTS-2 DOWNTO 0);
  SIGNAL outBuf_wA_xhdl6   : std_logic_vector(LOGPTS-2 DOWNTO 0);
  SIGNAL outBuf_rA_xhdl7   : std_logic_vector(LOGPTS-1 DOWNTO 0);
  SIGNAL wEn_even_xhdl8    : std_logic;
  SIGNAL wEn_odd_xhdl9     : std_logic;
  SIGNAL preSwCross_xhdl10 : std_logic;
  SIGNAL twid_wEn_xhdl11   : std_logic;
  SIGNAL inBuf_wEn_xhdl12  : std_logic;
  SIGNAL outBuf_wEn_xhdl13 : std_logic;
  SIGNAL smPong_xhdl14     : std_logic;
  SIGNAL ldValid_xhdl15    : std_logic;
  SIGNAL inBuf_rdValid_int : std_logic;
  SIGNAL wLastStage_xhdl17 : std_logic;
  SIGNAL smStartFFTrd_int  : std_logic;
  SIGNAL smStartLoad_int   : std_logic;
  SIGNAL ifoLoad_xhdl20    : std_logic;
  SIGNAL ifoY_valid_xhdl21 : std_logic;
  SIGNAL ifoY_rdy_xhdl22   : std_logic;
  SIGNAL smStartLoad_w     : std_logic;

BEGIN
  ldA <= ldA_xhdl1;
  rA <= rA_xhdl2;
  wA <= wA_xhdl3;
  tA <= tA_xhdl4;
  twid_wA <= twid_wA_xhdl5;
  outBuf_wA <= outBuf_wA_xhdl6;
  outBuf_rA <= outBuf_rA_xhdl7;
  wEn_even <= wEn_even_xhdl8;
  wEn_odd <= wEn_odd_xhdl9;
  preSwCross <= preSwCross_xhdl10;
  twid_wEn <= twid_wEn_xhdl11;
  inBuf_wEn <= inBuf_wEn_xhdl12;
  outBuf_wEn <= outBuf_wEn_xhdl13;
  smPong <= smPong_xhdl14;
  ldValid <= ldValid_xhdl15;
  inBuf_rdValid <= inBuf_rdValid_int;
  wLastStage <= wLastStage_xhdl17;
  smStartFFTrd <= smStartFFTrd_int;
  smStartLoad <= smStartLoad_int;
  ifoLoad <= ifoLoad_xhdl20;
  ifoY_valid <= ifoY_valid_xhdl21;
  ifoY_rdy <= ifoY_rdy_xhdl22;
  nGrst <= ifiNreset AND (NOT initRst) ;
  trueRst_w <= rstAfterInit OR ifiStart ;
  -- Top SM outputs
  smStartFFTrd_int <= smBuf_full AND smFft_rdy ;
  -- Start loading on FFT start or initially on trueRst.
  smStartLoad_w <= trueRst_w OR smStartFFTrd_int ;
  -- To prevent fake ifoY_rdy and ifoY_valid do not let rdFFTTimer run
  -- outside smFft_runs
  rdTimer_cntEn <= clkEn AND (smFft_runs OR smStartFFTrd_int);

  -- FFT read inBuf timer
  rdFFTtimer_0 : rdFFTtimer
    GENERIC MAP (LOGPTS       => LOGPTS,
                 LOGLOGPTS    => LOGLOGPTS,
                 HALFPTS      => HALFPTS,
                 inBuf_RWDLY  => inBuf_RWDLY )
    PORT MAP (
      clk => clk,
      cntEn => rdTimer_cntEn,
      nGrst => nGrst,
      rst => trueRst,
      startFFT => smStartFFTrd_int,
      timer => rTimer_w,
      timerTC => rTimerTC_w,
      stage => rStage_w,
      lastStage => rLastStage_w,
      fft_runs => smFft_runs,
      rdValid => inBuf_rdValid_int);

  -- FFT write inBuf timer
  sync_rAwA <= To_logic(rTimer_w = CONV_STD_LOGIC_VECTOR(inBuf_RWDLY, LOGPTS-1)) ;
  xhdl_27 <= sync_rAwA OR smStartFFTrd_int;
  wrFFTtimer_0 : wrFFTtimer
    GENERIC MAP (LOGPTS    => LOGPTS,
                 LOGLOGPTS => LOGLOGPTS,
                 HALFPTS   => HALFPTS )
    PORT MAP (
      clk => clk,
      rst => trueRst,
      nGrst => nGrst,
      rstStage => smStartFFTrd_int,
      rstTime => xhdl_27,
      cntEn => clkEn,
      timer => wTimer_w,
      timerTC => wTimerTC_w,
      stage => wStage_w,
      lastStage => wLastStage_xhdl17);

  --inData strobe
  --out; inBuf is ready for new data (PTS new samples)
  --out; tells topSM the buffer is fully loaded and ready for FFTing
  inBuf_ldA_0 : inBuf_ldA
    GENERIC MAP (PTS    => PTS,
                 LOGPTS => LOGPTS )
    PORT MAP (
      clk => clk,
      clkEn => clkEn,
      nGrst => nGrst,
      startLoad => smStartLoad_int,
      ifi_dataRdy => ifiD_valid,
      ifo_loadOn => ifoLoad_xhdl20,
      load_done => load_done_w,
      ldA => ldA_xhdl1,
      wEn_even => wEn_even_xhdl8,
      wEn_odd => wEn_odd_xhdl9,
      ldValid => ldValid_xhdl15);

  port_xhdl37 <= rTimer_w(LOGPTS-2 DOWNTO 0);
  inBuf_rA_0 : inBuf_fftA
    GENERIC MAP (LOGPTS    => LOGPTS,
                 LOGLOGPTS => LOGLOGPTS )
    PORT MAP (
      clk => clk,
      clkEn => clkEn,
      timer => port_xhdl37,
      stage => rStage_w,
      timerTC => rTimerTC_w,
      lastStage => rLastStage_w,
      fftDone => fftRd_done_w,
      bflyA => rA_xhdl2,
      swCross => preSwCross_xhdl10);   -- out

  twid_rA_0 : twid_rA
    GENERIC MAP (LOGPTS    => LOGPTS,
                 LOGLOGPTS => LOGLOGPTS )
    PORT MAP (
      clk => clk,
      timer => timerT1,
      stage => stageT2,
      tA => tA_xhdl4);

  -- Twiddle LUT initialization
  twid_wA_0 : twid_wAmod
    GENERIC MAP (LOGPTS    => LOGPTS )
    PORT MAP (
      clk => clk,
      ifiNreset => ifiNreset,
      twid_wA => twid_wA_xhdl5,
      twid_wEn => twid_wEn_xhdl11,
      twidInit => initRst,
      rstAfterInit => rstAfterInit);

  -- wA generator.  On the last stage the fftRd_done comes before the last
  -- FFT results get written back to the inBuf, but it is not necessary since
  -- the results get written into the output buffer.
  inBuf_wA_0 : inBuf_fftA
    GENERIC MAP (LOGPTS    => LOGPTS,
                 LOGLOGPTS => LOGLOGPTS )
    PORT MAP (
      clk => clk,
      clkEn => clkEn,
      timer => wTimer_w,
      stage => wStage_w,
      timerTC => wTimerTC_w,
      lastStage => wLastStage_xhdl17,
      fftDone => open,
      bflyA => wA_xhdl3,
      swCross => open);

  outBufA_0 : outBufA
    GENERIC MAP (PTS    => PTS,
                 LOGPTS => LOGPTS )
    PORT MAP (
      clk => clk,
      clkEn => clkEn,
      nGrst => nGrst,
      rst => trueRst,
      timer => wTimer_w,
      outBuf_wEn => outBuf_wEn_xhdl13,
      rdCtl => ifiRead_y,
      wA => outBuf_wA_xhdl6,
      rA => outBuf_rA_xhdl7,
      outBuf_rEn => ifoY_rdy_xhdl22,
      rdValid => ifoY_valid_xhdl21);

  PROCESS (clk)
  BEGIN
    IF (clk'EVENT AND clk = '1') THEN      -- pipes
      trueRst <= trueRst_w AFTER timescale;
      smStartLoad_int <= smStartLoad_w AFTER timescale;
      timerT1 <= rTimer_w(LOGPTS-2 DOWNTO 0) AFTER timescale;
      stageT1 <= rStage_w AFTER timescale;
      stageT2 <= stageT1 AFTER timescale;
      inBuf_wEn_xhdl12 <= preInBuf_wEn AFTER timescale;
      outBuf_wEn_xhdl13 <= preOutBuf_wEn AFTER timescale;
    END IF;
  END PROCESS;

  PROCESS (clk, nGrst)
  BEGIN
    IF (NOT nGrst = '1') THEN  -- reset topSM
      smBuf_full <= '0';
      smFft_rdy <= '0';
      smFft_runs <= '0';
      smPong_xhdl14 <= '1';
      preInBuf_wEn <= '0';
      preOutBuf_wEn <= '0';
    --nGrst
    ELSIF (clk'EVENT AND clk = '1') THEN
      --mark A
      IF (trueRst = '1') THEN
        -- reset topSM
        smBuf_full <= '0' AFTER timescale;
        smFft_rdy <= '1' AFTER timescale;
        smFft_runs <= '0' AFTER timescale;
        smPong_xhdl14 <= '1' AFTER timescale;
        preInBuf_wEn <= '0' AFTER timescale;
        preOutBuf_wEn <= '0' AFTER timescale;
      ELSE
        -- mark B
        IF (load_done_w = '1') THEN
          smBuf_full <= '1' AFTER timescale;
        END IF;
        IF (fftRd_done_w = '1') THEN
          smFft_rdy <= '1' AFTER timescale;
          smFft_runs <= '0' AFTER timescale;
        END IF;
        IF (smStartFFTrd_int = '1') THEN
          smBuf_full <= '0' AFTER timescale;
          smFft_rdy <= '0' AFTER timescale;
          smFft_runs <= '1' AFTER timescale;
          smPong_xhdl14 <= NOT smPong_xhdl14 AFTER timescale;
        END IF;
        IF (sync_rAwA = '1') THEN
          IF (rLastStage_w = '1') THEN
            preOutBuf_wEn <= '1' AFTER timescale;
          ELSE
            IF (smFft_runs = '1') THEN
              preInBuf_wEn <= '1' AFTER timescale;
            END IF;
          END IF;
        END IF;
        IF (wTimerTC_w = '1') THEN
          preInBuf_wEn <= '0' AFTER timescale;
          preOutBuf_wEn <= '0' AFTER timescale;
        END IF;
      END IF;
      -- mark B
    END IF;
    -- mark A
  END PROCESS;
END ARCHITECTURE translated;
------------------------------------------------------------------------------
