LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY lpp_waveform_snapshot_controler IS

  GENERIC (
    delta_snapshot_size : INTEGER := 16;
    delta_f2_f0_size    : INTEGER := 10;
    delta_f2_f1_size    : INTEGER := 10);

  PORT (
    clk               : IN STD_LOGIC;
    rstn              : IN STD_LOGIC;
    --config
    delta_snapshot    : IN STD_LOGIC_VECTOR(delta_snapshot_size-1 DOWNTO 0);
    delta_f2_f1       : IN STD_LOGIC_VECTOR(delta_f2_f1_size-1 DOWNTO 0);
    delta_f2_f0       : IN STD_LOGIC_VECTOR(delta_f2_f0_size-1 DOWNTO 0);
                                                                          
    --input
    coarse_time_0     : IN STD_LOGIC;
    data_f0_in_valid  : IN STD_LOGIC;
    data_f2_in_valid  : IN STD_LOGIC;
    --output
    start_snapshot_f0 : OUT STD_LOGIC;
    start_snapshot_f1 : OUT STD_LOGIC;
    start_snapshot_f2 : OUT STD_LOGIC
    );

END lpp_waveform_snapshot_controler;

ARCHITECTURE beh OF lpp_waveform_snapshot_controler IS
  SIGNAL counter_delta_snapshot : INTEGER;
  SIGNAL counter_delta_f0       : INTEGER;

  SIGNAL coarse_time_0_r : STD_LOGIC;
  SIGNAL start_snapshot_f2_temp : STD_LOGIC;
  SIGNAL start_snapshot_fothers_temp : STD_LOGIC;
  SIGNAL start_snapshot_fothers_temp2 : STD_LOGIC;
BEGIN  -- beh

  PROCESS (clk, rstn)
  BEGIN
    IF rstn = '0' THEN
      start_snapshot_f0 <= '0';
      start_snapshot_f1 <= '0';
      start_snapshot_f2 <= '0';
      counter_delta_snapshot <= 0;
      counter_delta_f0 <= 0;
      coarse_time_0_r <=  '0';
      start_snapshot_f2_temp <=  '0';
      start_snapshot_fothers_temp <=  '0';
      start_snapshot_fothers_temp2 <=  '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF counter_delta_snapshot = UNSIGNED(delta_snapshot) THEN
        start_snapshot_f2_temp <=   '1';
      ELSE
        start_snapshot_f2_temp <= '0';
      END IF;
      -------------------------------------------------------------------------
      IF counter_delta_snapshot = UNSIGNED(delta_snapshot) AND start_snapshot_f2_temp = '0'  THEN
        start_snapshot_f2 <= '1';
      ELSE
        start_snapshot_f2 <= '0';
      END IF;
      -------------------------------------------------------------------------
      coarse_time_0_r <= coarse_time_0;
      IF coarse_time_0 = NOT coarse_time_0_r AND coarse_time_0 = '1' THEN
        IF counter_delta_snapshot = 0  THEN
          counter_delta_snapshot <=  to_integer(UNSIGNED(delta_snapshot));
        ELSE
          counter_delta_snapshot <=  counter_delta_snapshot - 1;            
        END IF;
      END IF;


      -------------------------------------------------------------------------


      
      IF counter_delta_f0 = UNSIGNED(delta_f2_f1) THEN
        start_snapshot_f1 <= '1';
      ELSE
        start_snapshot_f1 <= '0';
      END IF;

      IF counter_delta_f0 = 1 THEN --UNSIGNED(delta_f2_f0) THEN
        start_snapshot_f0 <= '1';
      ELSE
        start_snapshot_f0 <= '0';
      END IF;
      
      IF counter_delta_snapshot = UNSIGNED(delta_snapshot)
        AND start_snapshot_f2_temp = '0'
      THEN --
        start_snapshot_fothers_temp <= '1';
      ELSIF counter_delta_f0 > 0 THEN
        start_snapshot_fothers_temp <= '0';
      END IF;

      
      -------------------------------------------------------------------------
      IF (start_snapshot_fothers_temp = '1' OR (counter_delta_snapshot = UNSIGNED(delta_snapshot) AND start_snapshot_f2_temp = '0')) AND data_f2_in_valid = '1' THEN
        --counter_delta_snapshot = UNSIGNED(delta_snapshot) AND start_snapshot_f2_temp = '0'  THEN --
        --counter_delta_snapshot = UNSIGNED(delta_snapshot) THEN
        counter_delta_f0  <= to_integer(UNSIGNED(delta_f2_f0));  --0;
      ELSE
        IF (( counter_delta_f0 > 0 ) AND ( data_f0_in_valid = '1' )) THEN --<= UNSIGNED(delta_f2_f0) THEN
            counter_delta_f0  <= counter_delta_f0 - 1;--counter_delta_f0 + 1;
        END IF;
      END IF;
      -------------------------------------------------------------------------      
    END IF;
  END PROCESS;

END beh;
