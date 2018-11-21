LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY std;
USE std.textio.ALL;

ENTITY spw_receiver IS
  GENERIC(
    FNAME : STRING := "output.txt"
    );
  PORT(
    end_of_simu : IN STD_LOGIC;
    timestamp : IN integer;

    got_rmap_packet  : OUT STD_LOGIC;
    got_ccsds_packet : OUT STD_LOGIC;

    clk     : IN  STD_LOGIC;

    rxread  : out STD_LOGIC;
    rxflag  : in STD_LOGIC;
    rxdata  : in STD_LOGIC_VECTOR(7 DOWNTO 0);
    rxvalid : in  STD_LOGIC;
    rxhalff : out  STD_LOGIC
    );
END spw_receiver;

ARCHITECTURE beh OF spw_receiver IS

  FILE output_file    : TEXT OPEN write_mode IS FNAME;

  SIGNAL message_ongoing   : STD_LOGIC := '0';
  SIGNAL message_timestamp : INTEGER;
  SIGNAL byte_number	   : INTEGER:=0;
  SIGNAL is_rmap           : STD_LOGIC:='0';
  SIGNAL is_ccsds          : STD_LOGIC:='0';

BEGIN
  -----------------------------------------------------------------------------
  -- Data orginization in the output file :
  -----------------------------------------------------------------------------
  -- Exemple of output.txt file :
  -- Data_1
  -- Data_2
  --  ...
  -- Data_N
  -- TIME= TimeStamp_when_Data_1_was_received
  -- Data_N+1
  -- Data_N+2
  --  ...
  -- Data_M
  -- TIME= TimeStamp_when_Data_N+1_was_received
  -- Data_M+1
  -- Data_M+2
  --  ...
  -- Data_K
  -- TIME= TimeStamp_when_Data_M+1_was_received
  -----------------------------------------------------------------------------
  -- TimeStamp : integer. Waiting time (in ns) before to send the following message
  -- Data : integer(0 to 255). A part of the message.
  -----------------------------------------------------------------------------

  PROCESS(clk,end_of_simu)
    VARIABLE line_var : LINE;
  BEGIN
    IF end_of_simu = '1' THEN
      file_close(output_file);
      rxread <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      rxread <= '1';
      IF rxvalid = '1' THEN
        IF rxflag = '1' THEN
          write(line_var, "TIME= " & INTEGER'IMAGE(message_timestamp));
          byte_number     <= 0;
          message_ongoing <= '0';
          got_ccsds_packet <= is_ccsds;
          got_rmap_packet  <= is_rmap;
          is_rmap  <= '0';
          is_ccsds <= '0';
          if is_ccsds = '1' THEN
            report "SPW_RECEIVER: Received CCSDS packet of length " & INTEGER'IMAGE(byte_number);
          ELSIF is_rmap = '1' THEN
            report "SPW_RECEIVER: Received RMAP packet of length " & INTEGER'IMAGE(byte_number);
          ELSE
            report "SPW_RECEIVER: Received UNKNOWN packet of length " & INTEGER'IMAGE(byte_number);
          END IF;

        ELSE
          IF message_ongoing = '0' THEN
            message_ongoing <= '1';
            message_timestamp <= TimeStamp;
          END IF;
          write(line_var, INTEGER'IMAGE(to_integer(UNSIGNED(rxdata))));
          IF byte_number = 1 THEN
          	IF rxdata = X"01" THEN
          		is_rmap  <= '1';
          	ELSIF rxdata = X"02" THEN
          		is_ccsds <= '1';
          	END IF;
          END IF;
          byte_number <= byte_number+1;
        END IF;
        writeline(output_file, line_var);
      ELSE
          got_rmap_packet <= '0';
          got_ccsds_packet <= '0';
      END IF;
    END IF;
  END PROCESS;

END beh;
