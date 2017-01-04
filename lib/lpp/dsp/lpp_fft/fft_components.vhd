--------------------------------------------------------------------------------
-- Copyright 2007 Actel Corporation.  All rights reserved.

-- ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
-- ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
-- IN ADVANCE IN WRITING.

-- Revision 3.0 April 30, 2007 : v3.0 CoreFFT Release
--  Package:  fft_components.vhd
--  Description: CoreFFT
--               Core package
--  Rev: 0.1 8/31/2005 12:54PM  VD  : Pre Production
--  
--  
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
USE IEEE.numeric_std.all;
USE std.textio.all;
USE IEEE.STD_LOGIC_TEXTIO.all;

package FFT_COMPONENTS is
  CONSTANT  gPTS       : integer:=256; --Number of FFT points
  CONSTANT  gLOGPTS    : integer:=8; --Log2(PTS)
  CONSTANT  gLOGLOGPTS : integer:=3; --Stage counter width
-------------------------------------------------
  CONSTANT  gWSIZE    : integer:=16; -- FFT bit resolution; length of a re or im sample
  CONSTANT  gTWIDTH   : integer:=16; -- Twiddle, sin or cos bit resolution
  CONSTANT  gHALFPTS  : integer:=gPTS/2; -- Num of FFT points (PTS) divided by 2
  CONSTANT  gDWIDTH   : integer:=2*gWSIZE; -- width of a complex input word,
  CONSTANT  gTDWIDTH  : integer:=2*gTWIDTH; -- width of a complex twiddle factor
  CONSTANT  gRND_MODE : integer:=1;   -- enable product rounding
  CONSTANT  gSCALE_MODE : integer:=0;   -- scale mode
  CONSTANT  gInBuf_RWDLY : integer:=12;

  function to_logic  ( x : integer) return std_logic;
  function to_logic  ( x : boolean) return std_logic;
  FUNCTION to_integer( sig : std_logic_vector) return integer;  
  function to_integer( x : boolean) return integer;
  function maskbar   (barn, bar_enable,dma_reg_bar,dma_reg_loc : integer) return integer;
  function anyfifo   (bar0, bar1, bar2, bar3, bar4, bar5 : integer) return integer;
  FUNCTION reverse   (x :IN std_logic_vector) RETURN bit_vector;

  FUNCTION reverseStd(x :IN std_logic_vector) RETURN std_logic_vector;
  
  COMPONENT counter
    GENERIC (
      WIDTH  :  integer := 7;
      TERMCOUNT     :  integer := 127 );    
    PORT (
      clk, nGrst, rst, cntEn  : IN  std_logic;
      tc                      : OUT std_logic;
      Q                       : OUT std_logic_vector(WIDTH-1 DOWNTO 0));
  END COMPONENT;

  COMPONENT bcounter
    GENERIC (
      WIDTH  :  integer := 7);    
    PORT (
      clk, nGrst, rst, cntEn  : IN std_logic;   
      Q                       : OUT std_logic_vector(WIDTH-1 DOWNTO 0)  );
  END COMPONENT;

  COMPONENT edgeDetect
    GENERIC (
      INPIPE  :integer := 0; --if (INPIPE==1) insert input pipeline reg
      FEDGE   :integer := 0);--If FEDGE==1 detect falling edge, else-rising edge
    PORT (
      clk, clkEn, edgeIn   : IN std_logic;   
      edgeOut              : OUT std_logic);
  END COMPONENT;

end FFT_COMPONENTS;

package body FFT_COMPONENTS is

  function to_logic ( x : integer) return std_logic is
  variable y  : std_logic;
  begin
    if x = 0 then
      y := '0';
    else
      y := '1';
    end if;
    return y;
  end to_logic;

  function to_logic( x : boolean) return std_logic is
    variable y : std_logic;
  begin
    if x then 
      y := '1';
    else 
      y := '0';
    end if;
    return(y);
  end to_logic;

-- added 081805
  function to_integer(sig : std_logic_vector) return integer is
    variable num : integer := 0;  -- descending sig as integer
  begin
    for i in sig'range loop
      if sig(i)='1' then
        num := num*2+1;
      else  -- use anything other than '1' as '0'
        num := num*2;
      end if;
    end loop;  -- i
    return num;
  end function to_integer;

  function to_integer( x : boolean) return integer is
  variable y : integer;
  begin
    if x then 
      y := 1;
    else 
      y := 0;
    end if;
    return(y);
  end to_integer;
  
  function maskbar (barn, bar_enable,dma_reg_bar,dma_reg_loc : integer) return integer is
  begin
    if ( dma_reg_loc>= 2 and barn=dma_reg_bar) then
      return(0);
    else
      return(bar_enable);
    end if;
  end maskbar;   


  function anyfifo ( bar0, bar1, bar2, bar3, bar4, bar5 : integer) return integer is
  begin
    if ( bar0=2 or bar1=2 or bar2=2 or bar3=2 or bar4=2 or bar5=2) then
      return(1);
    else
      return(0);
    end if;
  end anyfifo; 
  
  FUNCTION reverse (x :IN std_logic_vector) 
                    RETURN bit_vector IS
    VARIABLE i              : integer;
    VARIABLE reverse        : bit_vector(x'HIGH DOWNTO x'LOW);
  BEGIN
    FOR i IN x'range LOOP
      reverse(i) := To_bit( x(x'HIGH - i));
    END LOOP;
    RETURN(reverse);
  END FUNCTION reverse;

  FUNCTION reverseStd (x :IN std_logic_vector) 
                       RETURN std_logic_vector IS
    VARIABLE i              : integer;
    VARIABLE reverse        : std_logic_vector(x'HIGH DOWNTO x'LOW);
  BEGIN
    FOR i IN x'range LOOP
      reverse(i) := x(x'HIGH - i);
    END LOOP;
    RETURN(reverse);
  END FUNCTION reverseStd;

end FFT_COMPONENTS;
