--------------------------------------------------------------------------------
-- Copyright 2007 Actel Corporation.  All rights reserved.

-- ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
-- ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
-- IN ADVANCE IN WRITING.

-- Revision 3.0 April 30, 2007 : v3.0 CoreFFT Release
-- File:  fftDp.vhd
-- Description: CoreFFT
--              FFT dapa path module
-- Rev: 0.1 8/31/2005 4:53PM  VD  : Pre Production
--
--
--------------------------------------------------------------------------------
--------------------------------  SWITCH  -------------------------------
-- if (sel) straight, else cross
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY switch IS
  GENERIC ( DWIDTH  : integer := 32 );
  PORT (
    clk, sel, validIn       : IN std_logic;
    inP, inQ                : IN std_logic_vector(DWIDTH-1 DOWNTO 0);
    outP, outQ              : OUT std_logic_vector(DWIDTH-1 DOWNTO 0);
    validOut                : OUT std_logic);
END ENTITY switch;

ARCHITECTURE translated OF switch IS
  CONSTANT tscale         : time := 1 ns;

  SIGNAL leftQ_r, rightP_r        :  std_logic_vector(DWIDTH-1 DOWNTO 0);
  SIGNAL pipe1                    :  std_logic;
  SIGNAL muxP_w                   :  std_logic_vector(DWIDTH-1 DOWNTO 0);
  SIGNAL muxQ_w                   :  std_logic_vector(DWIDTH-1 DOWNTO 0);
  SIGNAL temp_xhdl4               :  std_logic_vector(DWIDTH-1 DOWNTO 0);
  SIGNAL temp_xhdl5               :  std_logic_vector(DWIDTH-1 DOWNTO 0);
  SIGNAL outP_xhdl1               :  std_logic_vector(DWIDTH-1 DOWNTO 0);
  SIGNAL outQ_xhdl2               :  std_logic_vector(DWIDTH-1 DOWNTO 0);
  SIGNAL validOut_xhdl3           :  std_logic;

BEGIN
  outP <= outP_xhdl1;
  outQ <= outQ_xhdl2;
  validOut <= validOut_xhdl3;
  temp_xhdl4 <= leftQ_r WHEN sel = '1' ELSE inP;
  muxP_w <= temp_xhdl4 ;
  temp_xhdl5 <= leftQ_r WHEN NOT sel = '1' ELSE inP;
  muxQ_w <= temp_xhdl5 ;

  PROCESS (clk)
  BEGIN
    IF (clk'EVENT AND clk = '1') THEN
      outP_xhdl1 <= rightP_r AFTER tscale;
      outQ_xhdl2 <= muxQ_w AFTER tscale;
      leftQ_r <= inQ AFTER tscale;
      rightP_r <= muxP_w AFTER tscale;
      validOut_xhdl3 <= pipe1 AFTER tscale;
      pipe1 <= validIn AFTER tscale;
    END IF;
  END PROCESS;
END ARCHITECTURE translated;

---------------------------- B U T T E R F L Y  --------------------------------
-------------------------  Simple Round Up: 1-clk delay  ----------------------V
---------- Use it when it is known INBITWIDTH > OUTBITWIDTH --------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY kitRndUp IS
  GENERIC (OUTBITWIDTH  : integer := 12;
           RND_MODE     : integer := 0   );
  PORT (nGrst, rst, clk, clkEn : IN std_logic;
    inp       : IN std_logic_vector(OUTBITWIDTH DOWNTO 0);
    valInp    : IN std_logic;
    outp      : OUT std_logic_vector(OUTBITWIDTH-1 DOWNTO 0);
    valOutp   : OUT std_logic);
END ENTITY kitRndUp;

ARCHITECTURE rtl OF kitRndUp IS
  CONSTANT tscale : time := 1 ns;

  SIGNAL int_outp      : signed(OUTBITWIDTH DOWNTO 0);
  SIGNAL int_valOutp                      : std_logic;

BEGIN
  outp <= std_logic_vector(int_outp(OUTBITWIDTH DOWNTO 1));
  valOutp <= int_valOutp;

  PROCESS (clk, nGrst)
  BEGIN
    IF (NOT nGrst = '1') THEN
      int_outp <= to_signed(0, OUTBITWIDTH+1);
      int_valOutp <= '0';
    ELSIF (clk'EVENT AND clk = '1') THEN
      IF (rst = '1') THEN
        int_outp <= to_signed(0, OUTBITWIDTH+1) AFTER tscale;
        int_valOutp <= '0' AFTER 1 ns;
      ELSIF (clkEn = '1') THEN
        IF (valInp = '1') THEN
          IF(RND_MODE = 1) THEN
            int_outp <= signed(inp) + to_signed(1, OUTBITWIDTH+1) AFTER tscale;
          ELSE  int_outp <= signed(inp);
          END IF;
        END IF;
        int_valOutp <= valInp AFTER tscale;
      END IF;   --rst and no rst
    END IF;   --nGrst and no nGrst
  END PROCESS;
END ARCHITECTURE rtl;

-------------------------------- MULT -----------------------------V
library IEEE;
use IEEE.STD_LOGIC_1164.all;

ENTITY agen IS
  GENERIC ( RND_MODE : integer := 0;
            WSIZE    : integer := 16;
            DWIDTH   : integer := 16;
            TWIDTH   : integer := 16 );
  PORT (    -- synthesis syn_preserve=1
    clk   : IN std_logic;
    a     : IN std_logic_vector(WSIZE-1 DOWNTO 0);
    t     : IN std_logic_vector(TWIDTH-1 DOWNTO 0);
    arout : OUT std_logic_vector(WSIZE-1 DOWNTO 0));
END ENTITY agen;

ARCHITECTURE rtl OF agen IS
  CONSTANT tscale        : time := 1 ns;
  COMPONENT actar
    PORT (DataA : IN  std_logic_vector(WSIZE-1 DOWNTO 0);
          DataB : IN  std_logic_vector(TWIDTH-1 DOWNTO 0);
          Mult  : OUT std_logic_vector(WSIZE+TWIDTH-1 DOWNTO 0);
          Clock : IN  std_logic                        );
  END COMPONENT;

  COMPONENT kitRndUp
    GENERIC (
      OUTBITWIDTH  : integer := 12;
      RND_MODE     : integer := 0   );
    PORT (nGrst, rst, clk, clkEn : IN std_logic;
      inp       : IN std_logic_vector(OUTBITWIDTH DOWNTO 0);
      valInp    : IN std_logic;
      outp      : OUT std_logic_vector(OUTBITWIDTH-1 DOWNTO 0);
      valOutp   : OUT std_logic);
  END COMPONENT;

  SIGNAL a_r      : std_logic_vector(WSIZE-1 DOWNTO 0);
  SIGNAL t_r      : std_logic_vector(TWIDTH-1 DOWNTO 0);
  SIGNAL out1     : std_logic_vector(WSIZE DOWNTO 0);
  SIGNAL out_w    : std_logic_vector(WSIZE+TWIDTH-1 DOWNTO 0);
  SIGNAL out_VHDL : std_logic_vector(WSIZE-1 DOWNTO 0);

BEGIN
  arout <= out_VHDL;
  actar_0 : actar
    PORT MAP (DataA => a_r, DataB => t_r, Mult => out_w, Clock => clk);

  kitRndUp_0: kitRndUp
    GENERIC MAP ( OUTBITWIDTH => WSIZE, RND_MODE => RND_MODE )
    PORT MAP (nGrst => '1', rst => '0', clk => clk, clkEn => '1',
              inp => out1, valInp => '1', outp => out_VHDL, valOutp => open);

  PROCESS (clk)
  BEGIN
    IF (clk'EVENT AND clk = '1') THEN
      a_r <= a AFTER tscale;
      t_r <= t AFTER tscale;

      out1 <= out_w(DWIDTH-1 DOWNTO WSIZE-1) AFTER tscale;
    END IF;
  END PROCESS;
END ARCHITECTURE rtl;
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_ARITH.all;

ENTITY bfly2 IS
  GENERIC ( RND_MODE : integer := 0;
            WSIZE    : integer := 16;
            DWIDTH   : integer := 32;
            TWIDTH   : integer := 16;
            TDWIDTH  : integer := 32 );
  PORT (clk, validIn : IN std_logic;
    swCrossIn        : IN std_logic;
    upScale          : IN std_logic; --don't do downscaling if upScale==1
    inP, inQ         : IN std_logic_vector(DWIDTH-1 DOWNTO 0);
    T                : IN std_logic_vector(TDWIDTH-1 DOWNTO 0);
    outP, outQ       : OUT std_logic_vector(DWIDTH-1 DOWNTO 0);
    --Signals need to be delayed by the bfly latency. That's why they are here
    validOut, swCrossOut : OUT std_logic);
END ENTITY bfly2;

ARCHITECTURE translated OF bfly2 IS
  CONSTANT tscale         : time := 1 ns;

  COMPONENT agen
    GENERIC ( RND_MODE : integer := 0;
              WSIZE    : integer := 16;
              DWIDTH   : integer := 16;
              TWIDTH   : integer := 16 );
    PORT (clk   : IN  std_logic;
          a     : IN  std_logic_vector(WSIZE-1 DOWNTO 0);
          t     : IN  std_logic_vector(TWIDTH-1 DOWNTO 0);
          arout : OUT std_logic_vector(WSIZE-1 DOWNTO 0));
  END COMPONENT;

  -- CONVENTION: real - LSBs[15:0], imag - MSBs[31:16]
  SIGNAL inPr_w, inPi_w, inQr_w, inQi_w :  std_logic_vector(WSIZE-1 DOWNTO 0);
  SIGNAL Tr_w, Ti_w                     :  std_logic_vector(TWIDTH-1 DOWNTO 0);
  SIGNAL Hr_w, Hi_w, Hr, Hi             :  std_logic_vector(WSIZE-1 DOWNTO 0);
  SIGNAL PrT1_r, PrT2_r, PrT3_r, PrT4_r :  std_logic_vector(WSIZE-1 DOWNTO 0);
  SIGNAL PrT5_r, PrT6_r, PiT1_r, PiT2_r :  std_logic_vector(WSIZE-1 DOWNTO 0);
  SIGNAL PiT3_r, PiT4_r, PiT5_r, PiT6_r :  std_logic_vector(WSIZE-1 DOWNTO 0);
  SIGNAL QrTr_w, QiTi_w, QiTr_w, QrTi_w :  std_logic_vector(WSIZE-1 DOWNTO 0);
  SIGNAL pipe1,pipe2,pipe3,pipe4,pipe5  :  std_logic_vector(1 DOWNTO 0);
  SIGNAL pipe6                          :  std_logic_vector(1 DOWNTO 0);
  -- select either 16-bit value or sign-extended 15-bit value (downscaled one)
  SIGNAL temp_xhdl5               :  std_logic_vector(WSIZE-1 DOWNTO 0);
  SIGNAL temp_xhdl6               :  std_logic_vector(DWIDTH-1 DOWNTO WSIZE);
  -- select either 16-bit value or left-shifted value (upscaled one)
  SIGNAL temp_xhdl7               :  std_logic_vector(WSIZE-1 DOWNTO 0);
  SIGNAL temp_xhdl8               :  std_logic_vector(WSIZE-1 DOWNTO 0);
  SIGNAL outP_xhdl1               :  std_logic_vector(DWIDTH-1 DOWNTO 0);
  SIGNAL outQ_xhdl2               :  std_logic_vector(DWIDTH-1 DOWNTO 0);
  SIGNAL validOut_xhdl3           :  std_logic;
  SIGNAL swCrossOut_xhdl4         :  std_logic;

BEGIN
  outP <= outP_xhdl1;
  outQ <= outQ_xhdl2;
  validOut <= validOut_xhdl3;
  swCrossOut <= swCrossOut_xhdl4;
  Tr_w <= T(TWIDTH-1 DOWNTO 0) ;
  Ti_w <= T(TDWIDTH-1 DOWNTO TWIDTH) ;
  temp_xhdl5 <= inP(WSIZE-1 DOWNTO 0) WHEN upScale = '1' ELSE inP(WSIZE-1) &
  inP(WSIZE-1 DOWNTO 1);
  inPr_w <= temp_xhdl5  AFTER tscale;
  temp_xhdl6 <= inP(DWIDTH-1 DOWNTO WSIZE) WHEN upScale = '1' ELSE inP(DWIDTH-1)
  & inP(DWIDTH-1 DOWNTO WSIZE+1);
  inPi_w <= temp_xhdl6  AFTER tscale;
  temp_xhdl7 <= inQ(WSIZE-2 DOWNTO 0) & '0' WHEN upScale = '1' ELSE inQ(WSIZE-1
  DOWNTO 0);
  inQr_w <= temp_xhdl7  AFTER tscale;
  temp_xhdl8 <= inQ(DWIDTH-2 DOWNTO WSIZE) & '0' WHEN upScale = '1' ELSE
    inQ(DWIDTH-1 DOWNTO WSIZE);
  inQi_w <= temp_xhdl8  AFTER tscale;

  am3QrTr : agen
    GENERIC MAP ( RND_MODE => RND_MODE, WSIZE => WSIZE, 
                  DWIDTH => DWIDTH, TWIDTH => TWIDTH)
    PORT MAP (clk => clk, a => inQr_w,  t => Tr_w,  arout => QrTr_w);
  am3QiTi : agen
    GENERIC MAP ( RND_MODE => RND_MODE, WSIZE => WSIZE, 
                  DWIDTH => DWIDTH, TWIDTH => TWIDTH)
    PORT MAP (clk => clk, a => inQi_w,  t => Ti_w,  arout => QiTi_w);
  am3QiTr : agen
    GENERIC MAP ( RND_MODE => RND_MODE, WSIZE => WSIZE, 
                  DWIDTH => DWIDTH, TWIDTH => TWIDTH)
    PORT MAP (clk => clk, a => inQi_w,  t => Tr_w,  arout => QiTr_w);
  am3QrTi : agen
    GENERIC MAP ( RND_MODE => RND_MODE, WSIZE => WSIZE, 
                  DWIDTH => DWIDTH, TWIDTH => TWIDTH)
    PORT MAP (clk => clk, a => inQr_w,  t => Ti_w,  arout => QrTi_w);

  Hr_w <= QrTr_w + QiTi_w  AFTER tscale;
  Hi_w <= QiTr_w - QrTi_w  AFTER tscale;

  PROCESS (clk)
  BEGIN
    IF (clk'EVENT AND clk = '1') THEN
      outQ_xhdl2(DWIDTH-1 DOWNTO WSIZE) <= PiT6_r - Hi AFTER tscale;
      outQ_xhdl2(WSIZE-1 DOWNTO 0) <= PrT6_r - Hr AFTER tscale;
      outP_xhdl1(DWIDTH-1 DOWNTO WSIZE) <= PiT6_r + Hi AFTER tscale;
      outP_xhdl1(WSIZE-1 DOWNTO 0) <= PrT6_r + Hr AFTER tscale;
      -- pipes

      PrT6_r <= PrT5_r AFTER tscale;     PiT6_r <= PiT5_r AFTER tscale;
      PrT5_r <= PrT4_r AFTER tscale;     PiT5_r <= PiT4_r AFTER tscale;
      PrT4_r <= PrT3_r AFTER tscale;     PiT4_r <= PiT3_r AFTER tscale;
      PrT3_r <= PrT2_r AFTER tscale;     PiT3_r <= PiT2_r AFTER tscale;
      PrT2_r <= PrT1_r AFTER tscale;     PiT2_r <= PiT1_r AFTER tscale;
      PrT1_r <= inPr_w AFTER tscale;     PiT1_r <= inPi_w AFTER tscale;
      Hr <= Hr_w AFTER tscale;           Hi <= Hi_w AFTER tscale;
      validOut_xhdl3 <= pipe6(0) AFTER tscale;
      swCrossOut_xhdl4 <= pipe6(1) AFTER tscale;
      pipe6 <= pipe5 AFTER tscale;       pipe5 <= pipe4 AFTER tscale;
      pipe4 <= pipe3 AFTER tscale;       pipe3 <= pipe2 AFTER tscale;
      pipe2 <= pipe1 AFTER tscale;       pipe1(0) <= validIn AFTER tscale;
      pipe1(1) <= swCrossIn AFTER tscale;
    END IF;
  END PROCESS;
END ARCHITECTURE translated;
--------------------------------------------------------------------------------

--********************************** B U F F E R *******************************
----------------------------------- inBuffer ----------------------------------V
-- InBuf stores double complex words so that FFT engine can read two cmplx
-- words per clock.  Thus the depth of the buffer is `LOGPTS-1
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY inBuffer IS
  GENERIC ( LOGPTS  : integer := 8;
            DWIDTH  : integer := 32  );
  PORT (
    clk, clkEn              : IN std_logic;
    rA, wA_bfly, wA_load    : IN std_logic_vector(LOGPTS-2 DOWNTO 0);
    --  new data to load, data coming from FFT engine
    ldData, wP_bfly, wQ_bfly: IN std_logic_vector(DWIDTH-1 DOWNTO 0);
    wEn_bfly                : IN std_logic; --wEn to store FFT engine data
    wEn_even, wEn_odd       : IN std_logic; --wEn to store new data in even/odd subbuffers
    rEn                     : IN std_logic; --used only by FFT engine
    -- pipo=pong for pong buffer, =/pong for ping buffer
    pipo                    : IN std_logic; --controls buffer input muxes.
    outP, outQ              : OUT std_logic_vector(DWIDTH-1 DOWNTO 0));   --  output data to FFT engine
END ENTITY inBuffer;

ARCHITECTURE translated OF inBuffer IS
  CONSTANT tscale         : time := 1 ns;

  COMPONENT wrapRam
    GENERIC ( LOGPTS : integer := 8;
              DWIDTH : integer := 32  );
    PORT( clk, wEn : in  std_logic;
          wA, rA   : in  std_logic_vector(LOGPTS-2 downto 0);
          D        : in  std_logic_vector(DWIDTH-1 downto 0);
          Q        : out std_logic_vector(DWIDTH-1 downto 0)        );
  end component;

  -- internal wires, &-gates
  SIGNAL wA_w                         : std_logic_vector(LOGPTS-2 DOWNTO 0);
  SIGNAL wP_w, wQ_w                   : std_logic_vector(DWIDTH-1 DOWNTO 0);
  SIGNAL wEn_P, wEn_Q                 : std_logic;
  SIGNAL rEn_ce_w,wEnP_ce_w,wEnQ_ce_w : std_logic;
  SIGNAL temp_xhdl3                   : std_logic;
  SIGNAL temp_xhdl4                   : std_logic;
  SIGNAL temp_xhdl5                   : std_logic_vector(LOGPTS-2 DOWNTO 0);
  SIGNAL temp_xhdl6                   : std_logic_vector(DWIDTH-1 DOWNTO 0);
  SIGNAL temp_xhdl7                   : std_logic_vector(DWIDTH-1 DOWNTO 0);
  SIGNAL outP_xhdl1                   : std_logic_vector(DWIDTH-1 DOWNTO 0);
  SIGNAL outQ_xhdl2                   : std_logic_vector(DWIDTH-1 DOWNTO 0);

BEGIN
  outP <= outP_xhdl1;
  outQ <= outQ_xhdl2;
  rEn_ce_w <= rEn AND clkEn ;
  wEnP_ce_w <= wEn_P AND clkEn ;
  wEnQ_ce_w <= wEn_Q AND clkEn ;
  temp_xhdl3 <= wEn_bfly WHEN pipo = '1' ELSE wEn_even;
  wEn_P <= temp_xhdl3 ;
  temp_xhdl4 <= wEn_bfly WHEN pipo = '1' ELSE wEn_odd;
  wEn_Q <= temp_xhdl4 ;
  temp_xhdl5 <= wA_bfly WHEN pipo = '1' ELSE wA_load;
  wA_w <= temp_xhdl5 ;
  temp_xhdl6 <= wP_bfly WHEN pipo = '1' ELSE ldData;
  wP_w <= temp_xhdl6 ;
  temp_xhdl7 <= wQ_bfly WHEN pipo = '1' ELSE ldData;
  wQ_w <= temp_xhdl7 ;
  -- if(~pipo) LOAD, else - RUN BFLY.  Use MUX'es

  -- instantiate two mem blocks `HALFPTS deep each
  memP : wrapRam
    GENERIC MAP( LOGPTS => LOGPTS, DWIDTH => DWIDTH )
    PORT MAP (D => wP_w,    Q => outP_xhdl1,    wA => wA_w,   rA => rA,
              wEn => wEnP_ce_w,   clk => clk);

  memQ : wrapRam
    GENERIC MAP( LOGPTS => LOGPTS, DWIDTH => DWIDTH )
    PORT MAP (D => wQ_w,    Q => outQ_xhdl2,    wA => wA_w,   rA => rA,
              wEn => wEnQ_ce_w,   clk => clk);
END ARCHITECTURE translated;
--------------------------------------------------------------------------------
------------------------------- pipoBuffer ------------------------------------V
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY pipoBuffer IS
  GENERIC ( LOGPTS  : integer := 8;
            DWIDTH  : integer := 32  );
  PORT (
    clk, clkEn, pong, rEn     : IN std_logic;
    rA, wA_load, wA_bfly      : IN std_logic_vector(LOGPTS-2 DOWNTO 0);
    ldData,wP_bfly,wQ_bfly    : IN std_logic_vector(DWIDTH-1 DOWNTO 0);
    wEn_bfly,wEn_even,wEn_odd : IN std_logic;
    outP, outQ                : OUT std_logic_vector(DWIDTH-1 DOWNTO 0) );
END ENTITY pipoBuffer;

ARCHITECTURE translated OF pipoBuffer IS
  CONSTANT tscale         : time := 1 ns;

  COMPONENT inBuffer
    GENERIC ( LOGPTS  : integer := 8;
              DWIDTH  : integer := 32  );
    PORT (
      clk, clkEn, rEn, pipo     : IN  std_logic;
      rA,wA_bfly,wA_load        : IN  std_logic_vector(LOGPTS-2 DOWNTO 0);
      ldData,wP_bfly,wQ_bfly    : IN  std_logic_vector(DWIDTH-1 DOWNTO 0);
      wEn_bfly,wEn_even,wEn_odd : IN  std_logic;
      outP, outQ                : OUT std_logic_vector(DWIDTH-1 DOWNTO 0));
  END COMPONENT;

  --internal signals
  SIGNAL pi_outP, pi_outQ       :  std_logic_vector(DWIDTH-1 DOWNTO 0);
  SIGNAL po_outP, po_outQ       :  std_logic_vector(DWIDTH-1 DOWNTO 0);
  SIGNAL port_xhdl17            :  std_logic;
  SIGNAL temp_xhdl32            :  std_logic_vector(DWIDTH-1 DOWNTO 0);
  SIGNAL temp_xhdl33            :  std_logic_vector(DWIDTH-1 DOWNTO 0);
  SIGNAL outP_xhdl1             :  std_logic_vector(DWIDTH-1 DOWNTO 0);
  SIGNAL outQ_xhdl2             :  std_logic_vector(DWIDTH-1 DOWNTO 0);

BEGIN
  outP <= outP_xhdl1;
  outQ <= outQ_xhdl2;
  port_xhdl17 <= NOT pong;
  piBuf : inBuffer
    GENERIC MAP( LOGPTS => LOGPTS, DWIDTH => DWIDTH )
    PORT MAP (clk => clk,   rA => rA,   wA_bfly => wA_bfly,
              wA_load => wA_load,   ldData => ldData,   wP_bfly => wP_bfly,
              wQ_bfly => wQ_bfly,   wEn_bfly => wEn_bfly,
              wEn_even => wEn_even, wEn_odd => wEn_odd, rEn => rEn,
              clkEn => clkEn,       pipo => port_xhdl17,
              outP => pi_outP,      outQ => pi_outQ);

  poBuf : inBuffer
    GENERIC MAP( LOGPTS => LOGPTS, DWIDTH => DWIDTH )
    PORT MAP (clk => clk,   rA => rA,   wA_bfly => wA_bfly,
              wA_load => wA_load,   ldData => ldData,   wP_bfly => wP_bfly,
              wQ_bfly => wQ_bfly,   wEn_bfly => wEn_bfly,
              wEn_even => wEn_even, wEn_odd => wEn_odd, rEn => rEn,
              clkEn => clkEn,       pipo => pong,
              outP => po_outP,      outQ => po_outQ);

  temp_xhdl32 <= po_outP WHEN pong = '1' ELSE pi_outP;
  outP_xhdl1 <= temp_xhdl32 ;
  temp_xhdl33 <= po_outQ WHEN pong = '1' ELSE pi_outQ;
  outQ_xhdl2 <= temp_xhdl33 ;

END ARCHITECTURE translated;
--------------------------------------------------------------------------------
--*******************************  outBuffer  *********************************V
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY outBuff IS
  GENERIC ( LOGPTS  : integer := 8;
            DWIDTH  : integer := 32  );
  PORT (
    clk, clkEn, wEn         : IN std_logic;
    inP, inQ                : IN std_logic_vector(DWIDTH-1 DOWNTO 0);
    wA                      : IN std_logic_vector(LOGPTS-2 DOWNTO 0);
    rA                      : IN std_logic_vector(LOGPTS-1 DOWNTO 0);
    outD                    : OUT std_logic_vector(DWIDTH-1 DOWNTO 0));
END ENTITY outBuff;

ARCHITECTURE translated OF outBuff IS
  CONSTANT tscale         : time := 1 ns;

  COMPONENT wrapRam
    GENERIC ( LOGPTS  : integer := 8;
              DWIDTH  : integer := 32  );
    PORT( clk, wEn : in  std_logic;
          wA, rA   : in  std_logic_vector(LOGPTS-2 downto 0);
          D        : in  std_logic_vector(DWIDTH-1 downto 0);
          Q        : out std_logic_vector(DWIDTH-1 downto 0)        );
  end component;

  SIGNAL wEn_r                    :  std_logic;
  SIGNAL inP_r, inQ_r             :  std_logic_vector(DWIDTH-1 DOWNTO 0);
  SIGNAL wA_r                     :  std_logic_vector(LOGPTS-2 DOWNTO 0);
  SIGNAL rAmsb_r1, rAmsb_r2       :  std_logic;
  SIGNAL P_w, Q_w                 :  std_logic_vector(DWIDTH-1 DOWNTO 0);
  SIGNAL outPQ                    :  std_logic_vector(DWIDTH-1 DOWNTO 0);
  SIGNAL temp_xhdl10              :  std_logic_vector(DWIDTH-1 DOWNTO 0);
  SIGNAL outD_xhdl1               :  std_logic_vector(DWIDTH-1 DOWNTO 0);

BEGIN
  outD <= outD_xhdl1;
  outBuf_0 : wrapRam
    GENERIC MAP( LOGPTS => LOGPTS, DWIDTH => DWIDTH )
    PORT MAP (D => inP_r,     Q => P_w,     wA => wA_r,
              rA => rA(LOGPTS-2 DOWNTO 0),
              wEn => wEn_r,   clk => clk);
  outBuf_1 : wrapRam
    GENERIC MAP( LOGPTS => LOGPTS, DWIDTH => DWIDTH )
    PORT MAP (D => inQ_r,     Q => Q_w,     wA => wA_r,
              rA => rA(LOGPTS-2 DOWNTO 0),
              wEn => wEn_r,   clk => clk);

  temp_xhdl10 <= Q_w WHEN rAmsb_r2 = '1' ELSE P_w;
  outPQ <= temp_xhdl10 ;

  PROCESS (clk)
  BEGIN
    IF (clk'EVENT AND clk = '1') THEN
      inP_r <= inP AFTER 1*tscale;
      inQ_r <= inQ AFTER 1*tscale;    -- pipes
      wEn_r <= wEn AFTER 1*tscale;
      wA_r <= wA AFTER 1*tscale;
      rAmsb_r2 <= rAmsb_r1 AFTER 1*tscale;
      rAmsb_r1 <= rA(LOGPTS-1) AFTER 1*tscale;
      outD_xhdl1 <= outPQ AFTER 1*tscale;
    END IF;
  END PROCESS;
END ARCHITECTURE translated;
--------------------------------------------------------------------------------
--************************ T W I D D L E   L U T ******************************V
-- RAM-block based twiddle LUT
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY twidLUT IS
  GENERIC ( LOGPTS  : integer := 8;
            TDWIDTH : integer := 32  );
  PORT (
    clk, wEn                : IN std_logic;
    wA, rA                  : IN std_logic_vector(LOGPTS-2 DOWNTO 0);
    D                       : IN std_logic_vector(TDWIDTH-1 DOWNTO 0);
    Q                       : OUT std_logic_vector(TDWIDTH-1 DOWNTO 0));
END ENTITY twidLUT;

ARCHITECTURE translated OF twidLUT IS
  CONSTANT tscale         : time := 1 ns;

  COMPONENT wrapRam
    GENERIC ( LOGPTS  : integer := 8;
              DWIDTH  : integer := 32  );
    PORT( clk, wEn : in  std_logic;
          wA, rA   : in  std_logic_vector(LOGPTS-2 downto 0);
          D        : in  std_logic_vector(TDWIDTH-1 downto 0);
          Q        : out std_logic_vector(TDWIDTH-1 downto 0)        );
  end component;

  SIGNAL rA_r                     :  std_logic_vector(LOGPTS-2 DOWNTO 0);
  SIGNAL Q_xhdl1                  :  std_logic_vector(TDWIDTH-1 DOWNTO 0);

BEGIN
  Q <= Q_xhdl1;
  twidLUT_0 : wrapRam
    GENERIC MAP( LOGPTS => LOGPTS, DWIDTH => TDWIDTH )
    PORT MAP (D => D,     Q => Q_xhdl1,   wA => wA,     rA => rA_r,
              wEn => wEn, clk => clk);

  PROCESS (clk)
  BEGIN
    IF (clk'EVENT AND clk = '1') THEN
      rA_r <= rA AFTER tscale;
    END IF;
  END PROCESS;
END ARCHITECTURE translated;
--------------------------------------------------------------------------------
------------------------- R A M -----------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY wrapRam IS
  GENERIC ( LOGPTS : integer := 8;
            DWIDTH : integer := 32  );
  PORT (clk, wEn    : IN std_logic;
        D           : IN std_logic_vector(DWIDTH-1 DOWNTO 0);
        rA, wA      : IN std_logic_vector(LOGPTS-2 DOWNTO 0);
        Q           : OUT std_logic_vector(DWIDTH-1 DOWNTO 0)  );
END ENTITY wrapRam;

ARCHITECTURE rtl OF wrapRam IS
  CONSTANT RE   :  std_logic := '0';
  COMPONENT actram
    port(WRB, RDB, WCLOCK, RCLOCK : IN std_logic;
         DI    : in std_logic_vector(DWIDTH-1 downto 0);
         DO    : out std_logic_vector(DWIDTH-1 downto 0);
         WADDR,RADDR : IN std_logic_vector(LOGPTS-2 downto 0) );
  end COMPONENT;

  SIGNAL nwEn    : std_logic;

BEGIN
  nwEn <= NOT wEn;
  wrapRam_0 : actram
    PORT MAP (DI => D,  WADDR => wA, RADDR => rA, WRB => nwEn,
              RDB => RE,  RCLOCK => clk, WCLOCK => clk,  DO => Q);
END ARCHITECTURE rtl;
-------------------------------------------------------------------------------V
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE work.fft_components.all;

ENTITY autoScale IS
  GENERIC (SCALE_MODE : integer := 1 );  -- enable autoscaling
  PORT (
    clk, clkEn, wLastStage : IN std_logic;
    ldRiskOV, bflyRiskOV   : IN std_logic;
    startLoad, ifo_loadOn  : IN std_logic;
    bflyOutValid, startFFT : IN std_logic;
    wEn_even, wEn_odd      : IN std_logic;
--    scaleMode              : IN std_logic;  --set 1 to turn autoscaling ON
    upScale                : OUT std_logic);
END ENTITY autoScale;

ARCHITECTURE translated OF autoScale IS
  CONSTANT tscale         : time := 1 ns;

  SIGNAL ldMonitor, bflyMonitor, stageEnd_w :  std_logic;
  SIGNAL xhdl_5                             :  std_logic;
  SIGNAL upScale_xhdl1                      :  std_logic;

BEGIN
  upScale <= upScale_xhdl1;
  xhdl_5 <= (bflyOutValid AND (NOT wLastStage));
  fedge_0 : edgeDetect
    GENERIC MAP (INPIPE => 0, FEDGE => 1)
    PORT MAP (clk => clk, clkEn => clkEn, edgeIn => xhdl_5, edgeOut => stageEnd_w);

  PROCESS (clk)
  BEGIN
    IF (clk'EVENT AND clk = '1') THEN
      -- Initialize ldMonitor
      IF (startLoad = '1') THEN
        ldMonitor <= to_logic(SCALE_MODE) AFTER tscale;
      ELSE
        -- Monitor the data being loaded: turn down ldMonitor
        -- if any valid input data violates the condition
        IF ((ldRiskOV AND (wEn_even OR wEn_odd)) = '1') THEN
          ldMonitor <= '0' AFTER tscale;
        END IF;
      END IF;
      -- monitor the data being FFT'ed
      IF ((bflyRiskOV AND bflyOutValid) = '1') THEN
        bflyMonitor <= '0';
      END IF;
      --check ldMonitor on startFFT (startFFT coinsides with the next startLoad)
      IF (startFFT = '1') THEN
        upScale_xhdl1 <= ldMonitor AFTER tscale;
        -- initialize bflyMonitor
        bflyMonitor <= to_logic(SCALE_MODE) AFTER tscale;
      ELSE
        -- Check the bflyMonitor at a stage end except the last stage, since the
        -- end of the last stage may come on or even after the startFFT signal
        -- when the upScale is supposed to check the ldMonitor only
        IF (stageEnd_w = '1') THEN
          upScale_xhdl1 <= bflyMonitor AFTER tscale;
          -- initialize bflyMonitor at the beginning of every stage
          bflyMonitor <= to_logic(SCALE_MODE) AFTER tscale;
        END IF;
      END IF;
    END IF;
  END PROCESS;

END ARCHITECTURE translated;
--------------------------------------------------------------------------------
