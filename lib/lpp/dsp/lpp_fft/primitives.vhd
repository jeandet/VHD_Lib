--------------------------------------------------------------------------------
-- Copyright 2007 Actel Corporation.  All rights reserved.

-- ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
-- ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
-- IN ADVANCE IN WRITING.

-- Revision 3.0 April 30, 2007 : v3.0 CoreFFT Release
-- File:  primitives.vhd
-- Description: CoreFFT
--              FFT primitives module
-- Rev: 0.1 8/31/2005 4:53PM  VD  : Pre Production
--
--
--------------------------------------------------------------------------------
-- counts up to TERMCOUNT, then jumps to 0.
-- Generates tc signal on count==TERMCOUNT-1
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE work.fft_components.all;

ENTITY counter IS
  GENERIC (
    WIDTH           : integer := 7;
    TERMCOUNT       : integer := 127 );
  PORT (
    clk, nGrst, rst, cntEn : IN std_logic;
    tc                     : OUT std_logic;
    Q                      : OUT std_logic_vector(WIDTH-1 DOWNTO 0) );
END ENTITY counter;

ARCHITECTURE translated OF counter IS
  SIGNAL tc_out : std_logic;
  SIGNAL Q_out  : unsigned(WIDTH-1 DOWNTO 0);

BEGIN
  tc <= tc_out;
  Q <= std_logic_vector(Q_out);
  PROCESS (clk, nGrst)
  BEGIN
    IF (nGrst = '0') THEN
      Q_out <= (OTHERS => '0');
      tc_out <= '0';
    ELSIF (clk'EVENT AND clk = '1') THEN      -- nGrst!=0
      IF (rst = '1') THEN
        Q_out <= (OTHERS => '0');
        tc_out <= '0';
      ELSE
        IF (cntEn = '1') THEN     -- start cntEn
          tc_out <= to_logic( Q_out = to_unsigned((TERMCOUNT-1),WIDTH));
          IF (Q_out = to_unsigned(TERMCOUNT, WIDTH)) THEN
            Q_out <= (OTHERS => '0');
          ELSE
            Q_out <= unsigned(Q_out) + to_unsigned(1, WIDTH);
          END IF;
        END IF;   -- end cntEn
      END IF;   -- end rst
    END IF;    -- end nGrst
  END PROCESS;
END ARCHITECTURE translated;

--------------------------------------------------------------------------
-- binary counter with no feedback.  Counts up to 2^WIDTH - 1
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY bcounter IS
  GENERIC (WIDTH : integer:=7 );
  PORT (clk, nGrst, rst, cntEn  : IN std_logic;
    Q  : OUT std_logic_vector(WIDTH-1 DOWNTO 0));
END ENTITY bcounter;

ARCHITECTURE translated OF bcounter IS
  SIGNAL Q_out     : unsigned(WIDTH-1 DOWNTO 0);

BEGIN
  Q <= std_logic_vector(Q_out);
  PROCESS (clk, nGrst)
  BEGIN
    IF (nGrst = '0') THEN
      Q_out <= (OTHERS => '0');
    ELSIF (clk'EVENT AND clk = '1') THEN
      IF (cntEn = '1') THEN
        IF (rst = '1') THEN
          Q_out <= (OTHERS => '0');
        ELSE
          Q_out <= unsigned(Q_out) + to_unsigned(1, WIDTH);
        END IF;
      END IF;
    END IF;
  END PROCESS;
END ARCHITECTURE translated;
--------------------------------------------------------------------------
-- rising-falling edge detector
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY edgeDetect IS
  GENERIC (
    INPIPE  :integer := 0; --if (INPIPE==1) insert input pipeline reg
    FEDGE   :integer := 0);--If FEDGE==1 detect falling edge, else-rising edge
  PORT (
    clk, clkEn, edgeIn   : IN std_logic;
    edgeOut              : OUT std_logic);
END ENTITY edgeDetect;

ARCHITECTURE translated OF edgeDetect IS
  SIGNAL in_pipe, in_t1      : std_logic;   -- regs
  SIGNAL temp_input          : std_logic;
  SIGNAL in_w                : std_logic;
  SIGNAL temp_output         : std_logic;
  SIGNAL out_w               : std_logic;
  SIGNAL output_reg          : std_logic;

BEGIN
  edgeOut <= output_reg;
  temp_input <= (in_pipe) WHEN INPIPE /= 0 ELSE edgeIn;
  in_w <= temp_input ;
  temp_output<=
      ((NOT in_w) AND in_t1) WHEN FEDGE /= 0 ELSE (in_w AND (NOT in_t1));
  out_w <= temp_output ;

  PROCESS (clk)
  BEGIN
    IF (clk'EVENT AND clk = '1') THEN
      in_pipe <= edgeIn;
      in_t1 <= in_w;
      output_reg <= out_w;
    END IF;
  END PROCESS;
END ARCHITECTURE translated;
