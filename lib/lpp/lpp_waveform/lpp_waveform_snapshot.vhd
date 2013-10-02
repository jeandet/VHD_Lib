LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY lpp_waveform_snapshot IS
  
  GENERIC (
    data_size              : INTEGER := 16;
    nb_snapshot_param_size : INTEGER := 11);

  PORT (
    clk  : IN STD_LOGIC;
    rstn : IN STD_LOGIC;
    run         : IN STD_LOGIC;       

    enable            : IN STD_LOGIC;
    burst_enable      : IN STD_LOGIC;
    nb_snapshot_param : IN STD_LOGIC_VECTOR(nb_snapshot_param_size-1 DOWNTO 0);

    start_snapshot : IN STD_LOGIC;

    data_in       : IN STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
    data_in_valid : IN STD_LOGIC;

    data_out       : OUT STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
    data_out_valid : OUT STD_LOGIC
    );

END lpp_waveform_snapshot;

ARCHITECTURE beh OF lpp_waveform_snapshot IS
  SIGNAL counter_points_snapshot : INTEGER;
BEGIN  -- beh

  PROCESS (clk, rstn)
  BEGIN
    IF rstn = '0' THEN
      data_out                <= (OTHERS => '0');
      data_out_valid          <= '0';
      counter_points_snapshot <= 0;
    ELSIF clk'EVENT AND clk = '1' THEN
      data_out <= data_in;
      IF enable = '0' OR run = '0' THEN
        data_out_valid          <= '0';
        counter_points_snapshot <= 0;
      ELSE
        IF burst_enable = '1' THEN
          -- BURST ModE --
          data_out_valid          <= data_in_valid;
          counter_points_snapshot <= 0;
        ELSE
          -- SNAPShOT MODE --
          IF start_snapshot = '1' THEN
            IF data_in_valid = '1' THEN
              counter_points_snapshot <= to_integer(unsigned(nb_snapshot_param)) - 1;
              data_out_valid          <= '1';
            ELSE
              counter_points_snapshot <= to_integer(unsigned(nb_snapshot_param));
              data_out_valid          <= '0';
            END IF;
          ELSE
            IF data_in_valid = '1' THEN
              IF counter_points_snapshot > 0  THEN
                counter_points_snapshot <= counter_points_snapshot - 1;
                data_out_valid          <= '1';
              ELSE
                counter_points_snapshot <= counter_points_snapshot;
                data_out_valid          <= '0';
              END IF;
            ELSE
              counter_points_snapshot <= counter_points_snapshot;
              data_out_valid          <= '0';
            END IF;
          END IF;
          
        END IF;
      END IF;
    END IF;
  END PROCESS;

END beh;
