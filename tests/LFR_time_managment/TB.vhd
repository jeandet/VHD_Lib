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
use ieee.std_logic_textio.all; 
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use std.textio.all; 


LIBRARY grlib;
USE grlib.amba.ALL;
USE grlib.stdlib.ALL;
USE grlib.devices.ALL;

LIBRARY lpp;
USE lpp.lpp_lfr_management.ALL;

ENTITY TB IS
  
  PORT (
    SIM_OK : OUT STD_LOGIC
    );

END TB;


ARCHITECTURE beh OF TB IS

  SIGNAL clk25MHz     : STD_LOGIC  := '0';

  SIGNAL resetn       : STD_LOGIC;
  SIGNAL grspw_tick   : STD_LOGIC;
  SIGNAL apbi         : apb_slv_in_type;
  SIGNAL apbo         : apb_slv_out_type;
  SIGNAL coarse_time  : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL fine_time    : STD_LOGIC_VECTOR(15 DOWNTO 0);

  SIGNAL TB_string : STRING(1 TO 8):= "12345678";

  SIGNAL coarse_time_reg : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL fine_time_reg   : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL global_time     : STD_LOGIC_VECTOR(47 DOWNTO 0);
  SIGNAL global_time_reg : STD_LOGIC_VECTOR(47 DOWNTO 0);
  SIGNAL tick_ongoing : STD_LOGIC;

  SIGNAL ASSERTION_1 : STD_LOGIC;
  SIGNAL ASSERTION_2 : STD_LOGIC;
  SIGNAL ASSERTION_3 : STD_LOGIC;
  SIGNAL ASSERTION_3_ERROR : STD_LOGIC;

  SIGNAL end_of_simu : STD_LOGIC := '0';
    
BEGIN  -- beh

  apb_lfr_management_1: apb_lfr_management
    GENERIC MAP (
      tech   => 0,
      pindex => 0,
      paddr  => 0,
      pmask  => 16#fff#,
--      FIRST_DIVISION => 20,
      NB_SECOND_DESYNC => 4)
    PORT MAP (
      clk25MHz     => clk25MHz,
      resetn_25MHz => resetn,
      
      grspw_tick   => grspw_tick,
      apbi         => apbi,
      apbo         => apbo,

      HK_sample    => (others => '0'),
      HK_val       => '0',
      HK_sel       => OPEN,

      DAC_SDO      => OPEN,
      DAC_SCK      => OPEN,
      DAC_SYNC     => OPEN,
      DAC_CAL_EN   => OPEN,
            
      coarse_time  => coarse_time,
      fine_time    => fine_time,
      
      LFR_soft_rstn => OPEN);

  -----------------------------------------------------------------------------
  -- CLOCK GEN
  PROCESS IS
  BEGIN  -- PROCESS
    IF end_of_simu /= '1' THEN
      clk25MHz     <= NOT clk25MHz;
      WAIT FOR 20000 ps;
    ELSE
      WAIT FOR 20 ps;
      ASSERT false REPORT "END OF TEST" SEVERITY note;
      WAIT;
    END IF;
  END PROCESS;
  -----------------------------------------------------------------------------
  

  PROCESS
  BEGIN  -- PROCESS
    WAIT UNTIL clk25MHz = '1';
    TB_string <= "RESET   ";  REPORT "RESET" SEVERITY note;
    
    resetn        <= '0';
    
    apbi.psel(0)  <= '0';
    apbi.pwrite   <= '0';
    apbi.penable  <= '0';
    apbi.paddr    <= (OTHERS => '0');
    apbi.pwdata   <= (OTHERS => '0');
    grspw_tick    <= '0';
    WAIT UNTIL clk25MHz = '1';
    WAIT UNTIL clk25MHz = '1';
    resetn <= '1';
    WAIT FOR 60 ms;
    ---------------------------------------------------------------------------
    -- DESYNC TO SYNC 
    ---------------------------------------------------------------------------
    WAIT UNTIL clk25MHz = '1';
    TB_string <= "TICK 1  "; REPORT "Tick 1" SEVERITY note;
    grspw_tick   <= '1';------------------------------------------------------1
    WAIT UNTIL clk25MHz = '1';
    grspw_tick   <= '0';
    WAIT FOR 53333 us;
    WAIT UNTIL clk25MHz = '1';
    TB_string <= "TICK 2  "; REPORT "Tick 2" SEVERITY note;
    grspw_tick   <= '1';------------------------------------------------------2
    WAIT UNTIL clk25MHz = '1';
    grspw_tick   <= '0';
    WAIT FOR 56000 us;
    WAIT UNTIL clk25MHz = '1';
    TB_string <= "TICK 3  "; REPORT "Tick 3" SEVERITY note;
    grspw_tick   <= '1';------------------------------------------------------3
    WAIT UNTIL clk25MHz = '1';
    grspw_tick   <= '0';
    WAIT FOR 200 ms;
    WAIT UNTIL clk25MHz = '1';
    TB_string <= "CT new  "; REPORT "CT new" SEVERITY note;
    -- WRITE NEW COARSE_TIME
    apbi.psel(0)      <= '1';
    apbi.pwrite       <= '1';
    apbi.penable      <= '1';
    apbi.paddr        <= X"00000004";
    apbi.pwdata       <= X"00001234";
    WAIT UNTIL clk25MHz = '1';
    apbi.psel(0)      <= '0';
    apbi.pwrite       <= '0';
    apbi.penable      <= '0';
    apbi.paddr        <= (OTHERS => '0');
    apbi.pwdata       <= (OTHERS => '0');
    WAIT UNTIL clk25MHz = '1';
    
    WAIT FOR 10 ms;
    WAIT UNTIL clk25MHz = '1';
    TB_string <= "TICK 4  "; REPORT "Tick 4" SEVERITY note;
    grspw_tick   <= '1';------------------------------------------------------3
    WAIT UNTIL clk25MHz = '1';
    grspw_tick   <= '0';

    
    WAIT FOR 250 ms;
    WAIT UNTIL clk25MHz = '1';
    TB_string <= "CT new  "; REPORT "CT new" SEVERITY note;
    -- WRITE NEW COARSE_TIME
    apbi.psel(0)      <= '1';
    apbi.pwrite       <= '1';
    apbi.penable      <= '1';
    apbi.paddr        <= X"00000004";
    apbi.pwdata       <= X"80005678";
    WAIT UNTIL clk25MHz = '1';
    apbi.psel(0)      <= '0';
    apbi.pwrite       <= '0';
    apbi.penable      <= '0';
    apbi.paddr        <= (OTHERS => '0');
    apbi.pwdata       <= (OTHERS => '0');
    WAIT UNTIL clk25MHz = '1';
    
    WAIT FOR 10 ms;
    WAIT UNTIL clk25MHz = '1';
    TB_string <= "TICK 5  "; REPORT "Tick 5" SEVERITY note;
    grspw_tick   <= '1';------------------------------------------------------3
    WAIT UNTIL clk25MHz = '1';
    grspw_tick   <= '0';

    
    WAIT FOR 20 ms;
    WAIT UNTIL clk25MHz = '1';
    TB_string <= "CT new  "; REPORT "CT new" SEVERITY note;
    -- WRITE NEW COARSE_TIME
    apbi.psel(0)      <= '1';
    apbi.pwrite       <= '1';
    apbi.penable      <= '1';
    apbi.paddr        <= X"00000004";
    apbi.pwdata       <= X"00005678";
    WAIT UNTIL clk25MHz = '1';
    apbi.psel(0)      <= '0';
    apbi.pwrite       <= '0';
    apbi.penable      <= '0';
    apbi.paddr        <= (OTHERS => '0');
    apbi.pwdata       <= (OTHERS => '0');
    WAIT UNTIL clk25MHz = '1';
    
    WAIT FOR 25 ms;
    WAIT UNTIL clk25MHz = '1';
    TB_string <= "Soft RST"; REPORT "Soft Reset" SEVERITY note;
    -- WRITE SOFT RESET
    apbi.psel(0)      <= '1';
    apbi.pwrite       <= '1';
    apbi.penable      <= '1';
    apbi.paddr        <= X"00000000";
    apbi.pwdata       <= X"00000002";
    WAIT UNTIL clk25MHz = '1';
    apbi.psel(0)      <= '0';
    apbi.pwrite       <= '0';
    apbi.penable      <= '0';
    apbi.paddr        <= (OTHERS => '0');
    apbi.pwdata       <= (OTHERS => '0');
    WAIT UNTIL clk25MHz = '1';
    
    WAIT FOR 250 ms;
    TB_string <= "READ 1  "; REPORT "Read 1" SEVERITY note;
    apbi.psel(0)      <= '1';
    apbi.pwrite       <= '0';
    apbi.penable      <= '1';
    apbi.paddr        <= X"00000008";
    WAIT UNTIL clk25MHz = '1';
    apbi.psel(0)      <= '0';
    apbi.pwrite       <= '0';
    apbi.penable      <= '0';
    apbi.paddr        <= (OTHERS => '0');
    WAIT UNTIL clk25MHz = '1';
    WAIT FOR 250 ms;
    TB_string <= "READ 2  "; REPORT "Read 2" SEVERITY note;
    apbi.psel(0)      <= '1';
    apbi.pwrite       <= '0';
    apbi.penable      <= '1';
    apbi.paddr        <= X"00000008";
    WAIT UNTIL clk25MHz = '1';
    apbi.psel(0)      <= '0';
    apbi.pwrite       <= '0';
    apbi.penable      <= '0';
    apbi.paddr        <= (OTHERS => '0');
    WAIT UNTIL clk25MHz = '1';
    WAIT FOR 250 ms;
    TB_string <= "READ 3  "; REPORT "Read 3" SEVERITY note;
    apbi.psel(0)      <= '1';
    apbi.pwrite       <= '0';
    apbi.penable      <= '1';
    apbi.paddr        <= X"00000008";
    WAIT UNTIL clk25MHz = '1';
    apbi.psel(0)      <= '0';
    apbi.pwrite       <= '0';
    apbi.penable      <= '0';
    apbi.paddr        <= (OTHERS => '0');
    WAIT UNTIL clk25MHz = '1';
    WAIT FOR 10 ps;
    end_of_simu <= '1';
    REPORT "end_of_simu set to 1" SEVERITY note;

    IF ASSERTION_1 = '1' THEN
      REPORT "ASSERTION 1 : **UPDATE(CoarseTime) => RESET(fineTime)**  OK" SEVERITY note;
    ELSE
      REPORT "ASSERTION 1 : **UPDATE(CoarseTime) => RESET(fineTime)**  !! FAILED !!" SEVERITY note;
    END IF;

    IF ASSERTION_2 = '1' THEN
      REPORT "ASSERTION 2 : **Tick => NEXT(fineTime) = RESET(fineTime) OK" SEVERITY note;
    ELSE
      REPORT "ASSERTION 2 : **Tick => NEXT(fineTime) = RESET(fineTime) !! FAILED !!" SEVERITY note;
    END IF;
    
    IF ASSERTION_3 = '1' THEN
      REPORT "ASSERTION 3 : **NEXT(TIME) > TIME **                     OK" SEVERITY note;
    ELSE
      REPORT "ASSERTION 3 : **NEXT(TIME) > TIME **                     !! FAILED !!" SEVERITY note;
    END IF;

    

    
    ASSERT false REPORT "*** END simulation ***" SEVERITY note;
    WAIT;   
    
  END PROCESS;


  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------

  global_time <= coarse_time & fine_time;
  
  PROCESS (clk25MHz, resetn)
  BEGIN  -- PROCESS
    IF resetn = '0' THEN                -- asynchronous reset (active low)
      coarse_time_reg <= (OTHERS => '0');
      fine_time_reg   <= (OTHERS => '0');
      global_time_reg <= (OTHERS => '0');
      tick_ongoing <= '0';
    ELSIF clk25MHz'event AND clk25MHz = '1' THEN  -- rising clock edge
      global_time_reg <= global_time;
      coarse_time_reg <= coarse_time;
      fine_time_reg   <= fine_time;
      IF grspw_tick ='1' THEN
        tick_ongoing <= '1';
      ELSIF tick_ongoing = '1' THEN
        IF (fine_time_reg /= fine_time) OR (coarse_time_reg /= coarse_time) THEN
          tick_ongoing <= '0';
        END IF;
      END IF;
      
    END IF;
  END PROCESS;
  
  -----------------------------------------------------------------------------
  -- ASSERTION 1 :
  -- Coarse_time "changed"  => FINE_TIME = 0
  -- False after a TRANSITION !
  -----------------------------------------------------------------------------
  PROCESS (clk25MHz, resetn)
    VARIABLE coarse_time_integer : INTEGER;
  BEGIN  -- PROCESS
    IF resetn = '0' THEN                -- asynchronous reset (active low)
      ASSERTION_1 <= '1';
    ELSIF clk25MHz'event AND clk25MHz = '1' THEN  -- rising clock edge
      coarse_time_integer := to_integer(UNSIGNED(coarse_time));
      
      IF coarse_time /= coarse_time_reg THEN
        IF fine_time /= X"0000" THEN
          IF fine_time /= X"0041" THEN
            ASSERTION_1 <= '0';
            REPORT "ASSERTION 1 : **UPDATE(CoarseTime) => RESET(fineTime)**                     !! FAILED !!  " SEVERITY note;
          ELSE
            REPORT "ASSERTION 1 : **UPDATE(CoarseTime) => RESET(fineTime)** false after a transition" SEVERITY note;
            ASSERTION_1 <= 'U';            
          END IF;
          REPORT "COARSE_TIME_REG= " & integer'IMAGE(to_integer(UNSIGNED(coarse_time_reg))) SEVERITY note;
          REPORT "COARSE_TIME    = " & integer'IMAGE(to_integer(UNSIGNED(coarse_time    ))) SEVERITY note;
          REPORT "FINE_TIME_REG  = " & integer'IMAGE(to_integer(UNSIGNED(fine_time_reg  ))) SEVERITY note;
          REPORT "FINE_TIME      = " & integer'IMAGE(to_integer(UNSIGNED(fine_time      ))) SEVERITY note;
        ELSE
          ASSERTION_1 <= '1';          
        END IF;
      END IF;
    END IF;
  END PROCESS;
  
  -----------------------------------------------------------------------------
  -- ASSERTION 2 :
  -- tick  => next(FINE_TIME) = 0
  -----------------------------------------------------------------------------
  PROCESS (clk25MHz, resetn)
  BEGIN  -- PROCESS
    IF resetn = '0' THEN                -- asynchronous reset (active low)
      ASSERTION_2 <= '1';
    ELSIF clk25MHz'event AND clk25MHz = '1' THEN  -- rising clock edge
      IF tick_ongoing = '1'  THEN
        IF fine_time_reg /= fine_time OR coarse_time_reg /= coarse_time THEN
          IF fine_time /= X"0000" THEN
            REPORT "ASSERTION 2 : **Tick => NEXT(fineTime) = RESET(fineTime)                    !! FAILED !!  " SEVERITY note;
            ASSERTION_2 <= '0';
          REPORT "COARSE_TIME_REG= " & integer'IMAGE(to_integer(UNSIGNED(coarse_time_reg))) SEVERITY note;
          REPORT "COARSE_TIME    = " & integer'IMAGE(to_integer(UNSIGNED(coarse_time    ))) SEVERITY note;
          REPORT "FINE_TIME_REG  = " & integer'IMAGE(to_integer(UNSIGNED(fine_time_reg  ))) SEVERITY note;
          REPORT "FINE_TIME      = " & integer'IMAGE(to_integer(UNSIGNED(fine_time      ))) SEVERITY note;
          END IF;
        END IF;
      END IF;
    END IF;
  END PROCESS;

  -----------------------------------------------------------------------------
  -- ASSERTION 3 :
  -- next(TIME) > TIME
  -- false if resynchro, or new coarse_time
  -----------------------------------------------------------------------------
  PROCESS (clk25MHz, resetn)
  BEGIN  -- PROCESS
    IF resetn = '0' THEN                -- asynchronous reset (active low)
      ASSERTION_3       <= '1';
    ELSIF clk25MHz'event AND clk25MHz = '1' THEN  -- rising clock edge
      ASSERTION_3 <= '1';
      IF global_time_reg(46 DOWNTO 0) > global_time(46 DOWNTO 0) THEN
        IF global_time(47) = '0' AND global_time_reg(47) = '1' THEN
          REPORT "ASSERTION 3 : **NEXT(TIME) > TIME ** can be false after a resynchro" SEVERITY note;
          ASSERTION_3 <= 'U';           -- RESYNCHRO ....
        ELSE
          REPORT "ASSERTION 3 : **NEXT(TIME) > TIME ** can be false after a NEW coarse time" SEVERITY note;
          ASSERTION_3 <= '0';                 
        END IF;
        REPORT "COARSE_TIME_REG= " & integer'IMAGE(to_integer(UNSIGNED(coarse_time_reg))) SEVERITY note;
        REPORT "COARSE_TIME    = " & integer'IMAGE(to_integer(UNSIGNED(coarse_time    ))) SEVERITY note;
        REPORT "FINE_TIME_REG  = " & integer'IMAGE(to_integer(UNSIGNED(fine_time_reg  ))) SEVERITY note;
        REPORT "FINE_TIME      = " & integer'IMAGE(to_integer(UNSIGNED(fine_time      ))) SEVERITY note;
      END IF;
    END IF;
  END PROCESS;
  
  
END beh;
 
