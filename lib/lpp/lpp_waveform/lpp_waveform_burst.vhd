LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY lpp_waveform_burst IS
  
  GENERIC (
    data_size              : INTEGER := 16);

  PORT (
    clk  : IN STD_LOGIC;
    rstn : IN STD_LOGIC;
    run  : IN STD_LOGIC;

    enable            : IN STD_LOGIC;

    data_in       : IN STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
    data_in_valid : IN STD_LOGIC;

    data_out       : OUT STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
    data_out_valid : OUT STD_LOGIC
    );

END lpp_waveform_burst;

ARCHITECTURE beh OF lpp_waveform_burst IS
BEGIN  -- beh

  PROCESS (clk, rstn)
  BEGIN
    IF rstn = '0' THEN
      data_out                <= (OTHERS => '0');
      data_out_valid          <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      data_out <= data_in;
      IF enable = '0' OR run = '0' THEN
        data_out_valid          <= '0';
      ELSE
        data_out_valid          <= data_in_valid;
      END IF;
    END IF;
  END PROCESS;

END beh;
