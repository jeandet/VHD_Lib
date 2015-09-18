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
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.fft_components.ALL;

LIBRARY lpp;
USE lpp.lpp_memory.ALL;
USE lpp.iir_filter.ALL;

ENTITY CoreFFT IS
  GENERIC (
    LOGPTS      : INTEGER := gLOGPTS;
    LOGLOGPTS   : INTEGER := gLOGLOGPTS;
    WSIZE       : INTEGER := gWSIZE;
    TWIDTH      : INTEGER := gTWIDTH;
    DWIDTH      : INTEGER := gDWIDTH;
    TDWIDTH     : INTEGER := gTDWIDTH;
    RND_MODE    : INTEGER := gRND_MODE;
    SCALE_MODE  : INTEGER := gSCALE_MODE;
    PTS         : INTEGER := gPTS;
    HALFPTS     : INTEGER := gHALFPTS;
    inBuf_RWDLY : INTEGER := gInBuf_RWDLY);
  PORT (
    clk              : IN  STD_LOGIC;
    ifiStart         : IN  STD_LOGIC;  -- start -- cste
    ifiNreset        : IN  STD_LOGIC;
    ifiD_valid       : IN  STD_LOGIC;   -- d_valid
    ifiRead_y        : IN  STD_LOGIC;   -- read_y
    ifiD_im, ifiD_re : IN  STD_LOGIC_VECTOR(WSIZE-1 DOWNTO 0);
    ifoLoad          : OUT STD_LOGIC;   -- load
    ifoPong          : OUT STD_LOGIC;  -- pong -- UNUSED
    ifoY_im, ifoY_re : OUT STD_LOGIC_VECTOR(WSIZE-1 DOWNTO 0);
    ifoY_valid       : OUT STD_LOGIC;   -- y_valid
    ifoY_rdy         : OUT STD_LOGIC);  -- y_rdy
END ENTITY CoreFFT;

ARCHITECTURE translated OF CoreFFT IS

  
  SIGNAL fft_ongoing    : STD_LOGIC;
  SIGNAL fft_done       : STD_LOGIC;
  SIGNAL counter        : INTEGER;
  SIGNAL counter_out    : INTEGER;
  SIGNAL counter_wait   : INTEGER;
  SIGNAL fft_ongoing_ok : STD_LOGIC;
  SIGNAL fft_ongoing_ok_1 : STD_LOGIC;
  SIGNAL fft_ongoing_ok_2 : STD_LOGIC;
  SIGNAL fft_ongoing_ok_3 : STD_LOGIC;
  SIGNAL fft_ongoing_ok_4 : STD_LOGIC;
  --
  SIGNAL rdata : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL wdata : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL ren : STD_LOGIC;
  SIGNAL wen : STD_LOGIC;
  --
  SIGNAL  ifoLoad_s         : STD_LOGIC;   -- load
  SIGNAL  ifoY_rdy_s        : STD_LOGIC;  -- y_rdy
  SIGNAL  ifoY_rdy_s2       : STD_LOGIC;  -- y_rdy
  SIGNAL  ifoY_rdy_s3       : STD_LOGIC;  -- y_rdy
  SIGNAL  ifoY_valid_s      : STD_LOGIC;   -- y_valid
  SIGNAL  ifoPong_s         :  STD_LOGIC;  -- pong -- UNUSED
  SIGNAL  ifoPong_first     :  STD_LOGIC;  -- pong -- UNUSED

  -----------------------------------------------------------------------------
  SIGNAL ifoY_im_counter : INTEGER;



  SIGNAL counter_in  : INTEGER;
  SIGNAL fft_start   : STD_LOGIC;
  SIGNAL fft_done    : STD_LOGIC;

  SIGNAL ifoLoad_s   : STD_LOGIC;
  SIGNAL ifoLoad_s2   : STD_LOGIC;
BEGIN

  --clk              : IN  STD_LOGIC;
  --ifiNreset        : IN  STD_LOGIC;
  -----------------------------------------------------------------------------
  --INPUT INTERFACE
  --ifoLoad          : OUT STD_LOGIC;   -- load
  --ifiD_valid       : IN  STD_LOGIC;   -- d_valid
  --ifiD_im, ifiD_re : IN  STD_LOGIC_VECTOR(WSIZE-1 DOWNTO 0);

  ifoLoad <= ifoLoad_s;
  
  PROCESS (clk, ifiNreset)
  BEGIN  -- PROCESS
    IF ifiNreset = '0' THEN             -- asynchronous reset (active low)
      counter_in <= 0;
      fft_start  <= '0';
      ifoLoad_s  <= '0';
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      IF counter_in < 256 AND ifoLoad_s = '1'THEN
        IF ifiD_valid = '1' THEN
          counter_in <= counter_in + 1;
          IF counter_in = 255 THEN
            ifoLoad_s <= '0';
            fft_start <= '1';
          END IF;
        END IF;
      ELSE
        ifoLoad_s  <= fft_done AND (NOT fft_start);
        counter_in <= 0;
        fft_start  <= '0';
      END IF;
    END IF;
  END PROCESS;
  
  PROCESS (clk, ifiNreset)
  BEGIN  -- PROCESS
    IF ifiNreset = '0' THEN             -- asynchronous reset (active low)
      fft_done <= '1';
      counter_wait <= 0;
      output_start <= '0';
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      output_start <= '0';
      IF counter_wait > 0 THEN
        IF output_done = '1' THEN
          counter_wait <= counter_wait - 1;
          IF counter_wait = 1 THEN
            output_start <= '1';
          END IF;
        END IF;
      ELSE
        fft_done     <= '1';
        IF fft_start = '1' THEN
          counter_wait <= 855;
          fft_done     <= '0';
        END IF;
        counter_wait <= 0;
      END IF;
    END IF;
  END PROCESS;
  
  PROCESS (clk, ifiNreset)
  BEGIN  -- PROCESS
    IF ifiNreset = '0' THEN             -- asynchronous reset (active low)
      output_done <= '1';
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      IF output_start = '1' THEN
        output_done     <= '0';
        counter_output  <= 0;
      ELSE
        
      END IF;
      
    END IF;
  END PROCESS;
  
  -----------------------------------------------------------------------------
    ifiStart         : IN  STD_LOGIC;  -- start -- cste
  
    ifiRead_y        : IN  STD_LOGIC;   -- read_y
  
  
    ifoPong          : OUT STD_LOGIC;  -- pong -- UNUSED
    ifoY_im, ifoY_re : OUT STD_LOGIC_VECTOR(WSIZE-1 DOWNTO 0);
    ifoY_valid       : OUT STD_LOGIC;   -- y_valid
    ifoY_rdy         : OUT STD_LOGIC);  -- y_rdy
  
  

  -----------------------------------------------------------------------------
  -- INPUT INTERFACE
  -----------------------------------------------------------------------------
  -- in                 ifiD_valid
  -- in (internal)      fft_done

  -- out(internal)      fft_ongoing 
  -- out                ifoLoad_s 
  PROCESS (clk, ifiNreset)
  BEGIN
    IF ifiNreset = '0' THEN
      counter     <= 0;
      fft_ongoing <= '0';
      ifoLoad_s     <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF fft_ongoing = '0' THEN
        ifoLoad_s     <= '1';
        fft_ongoing <= '0';
        IF ifiD_valid = '1' THEN
          ifoLoad_s       <= '1';
          IF counter = 255 THEN
            ifoLoad_s     <= '0';
            fft_ongoing <= '1';
            counter     <= 0;
          ELSE
            counter <= counter + 1;
          END IF;
        END IF;
      ELSIF fft_ongoing_ok  = '1' THEN--fft_done
        fft_ongoing <= '0';
      END IF;
    END IF;
  END PROCESS;

  -----------------------------------------------------------------------------
  -- WAIT PROCESS
  -----------------------------------------------------------------------------
  PROCESS (clk, ifiNreset)
  BEGIN
    IF ifiNreset = '0' THEN
--      fft_done    <= '0';
      
      counter_wait   <= 0;
      fft_ongoing_ok <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      fft_done    <= '0';
      fft_ongoing_ok <= '0';
      IF fft_ongoing = '0' THEN
--        fft_done    <= '1';
        counter_wait <= 855;--936;--1000;--1140;--936;
      ELSE
        IF counter_wait > 0 THEN
          counter_wait <= counter_wait -1;
          IF counter_wait = 1 THEN
            fft_ongoing_ok <= '1';
          END IF;
        END IF;
      END IF;
    END IF;
  END PROCESS;

  -----------------------------------------------------------------------------
  -- OUTPUT INTERFACE
  -----------------------------------------------------------------------------
  PROCESS (clk, ifiNreset)
  BEGIN  -- PROCESS
    IF ifiNreset = '0' THEN             -- asynchronous reset (active low)
      fft_ongoing_ok_1 <= '0';
      fft_ongoing_ok_2 <= '0';
      fft_ongoing_ok_3 <= '0';
      fft_ongoing_ok_4 <= '0';
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      fft_ongoing_ok_1 <= fft_ongoing_ok;
      fft_ongoing_ok_2 <= fft_ongoing_ok_1;
      fft_ongoing_ok_3 <= fft_ongoing_ok_2;
      fft_ongoing_ok_4 <= fft_ongoing_ok_3;
      
    END IF;
  END PROCESS;

  
  -- in ifiRead_y
  -- in(internal)      fft_ongoing_ok

  -- out (internal)      fft_done
  -- out ifoY_im
  -- out ifoY_re
  -- out ifoY_valid_s
  -- out ifoY_rdy_s
  PROCESS (clk, ifiNreset)
  BEGIN
    IF ifiNreset = '0' THEN
 --     fft_done    <= '0';
      --ifoY_im     <= (OTHERS => '0');
      --ifoY_re     <= (OTHERS => '0');
      ifoY_valid_s  <= '0';
      ifoY_rdy_s    <= '0';
      counter_out <= 0;
    ELSIF clk'EVENT AND clk = '1' THEN
--      fft_done <= '0';

      IF fft_ongoing_ok_4 = '1' THEN
        counter_out     <= 256;
      END IF;

      ifoY_valid_s      <= '0';
      ifoY_rdy_s        <= '0';
      IF counter_out > 0 THEN
        ifoY_valid_s      <= '1';
        ifoY_rdy_s        <= '1';
        IF ifiRead_y = '1' THEN
          counter_out <= counter_out - 1;
          --IF counter_out = 1 THEN
          --  fft_done <= '1';
          --END IF;
        END IF;
      END IF;
      
    END IF;
  END PROCESS;
  
  -----------------------------------------------------------------------------
  -- DATA
  -----------------------------------------------------------------------------
  lpp_fifo_1: lpp_fifo
    GENERIC MAP (
      tech         => 0,
      Mem_use      => use_CEL,
      DataSz       => 32,
      AddrSz       => 7)
    PORT MAP (
      clk        => clk,
      rstn        => ifiNreset,

      ReUse       => '0',
      
      wen         => wen,
      wdata       => wdata,
      
      ren         => ren,
      rdata       => rdata,
      
      empty       => OPEN,
      full        => OPEN,
      almost_full => OPEN);

  wen   <= '0' WHEN ifoLoad_s = '1' AND ifiD_valid = '1' ELSE '1';
  wdata <= ifiD_im & ifiD_re;


  ren <= '0' WHEN ifoY_rdy_s = '1' AND ifiRead_y = '1' ELSE '1';
  ifoY_im <= STD_LOGIC_VECTOR(to_unsigned(ifoY_im_counter,16));--rdata(31 DOWNTO 16);
  ifoY_re <= rdata(15 DOWNTO  0);
  
  PROCESS (clk, ifiNreset)
  BEGIN
    IF ifiNreset = '0' THEN
      ifoY_im_counter <= 0;
    ELSIF clk'event AND clk = '1' THEN
      IF ifoY_rdy_s = '1' AND ifiRead_y = '1' THEN
        ifoY_im_counter <= ifoY_im_counter + 1;
      END IF;
    END IF;
  END PROCESS;

  

  ifoLoad  <= ifoLoad_s;
  ifoY_rdy <= ifoY_rdy_s OR ifoY_rdy_s2 OR ifoY_rdy_s3;


  PROCESS (clk, ifiNreset)
  BEGIN
    IF ifiNreset = '0' THEN
      ifoY_valid  <= '0';
      ifoY_rdy_s2 <= '0';
      ifoY_rdy_s3 <= '0';
      ifoPong_s   <= '0';
      ifoPong_first <= '0'; 
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      ifoY_valid <= ifoY_valid_s;
      ifoY_rdy_s2 <= ifoY_rdy_s;
      ifoY_rdy_s3 <= ifoY_rdy_s2;
      IF fft_ongoing_ok = '1' THEN
        IF ifoPong_first = '1' THEN
          ifoPong_s <= NOT ifoPong_s;        
        END IF;
        ifoPong_first <= '1';
      END IF;
    END IF;
  END PROCESS;
  
  ifoPong <= ifoPong_s;
  
END ARCHITECTURE translated;
