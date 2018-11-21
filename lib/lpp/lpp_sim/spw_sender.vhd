LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY std;
USE std.textio.ALL;

ENTITY spw_sender IS
  GENERIC(
    FNAME : STRING := "input.txt"
    );
  PORT(
    end_of_simu : OUT STD_LOGIC;
    start_of_simu  : IN  STD_LOGIC;

    ack_rmap_packet  : IN STD_LOGIC;
    ack_ccsds_packet : IN STD_LOGIC;
    current_packet   : OUT STRING(1 to 256);

    clk     : IN  STD_LOGIC;
    txwrite : OUT STD_LOGIC;
    txflag  : OUT STD_LOGIC;
    txdata  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    txrdy   : IN  STD_LOGIC;
    txhalff : IN  STD_LOGIC
    );
END spw_sender;

ARCHITECTURE beh OF spw_sender IS
  FILE input_file : TEXT OPEN read_mode IS FNAME;

BEGIN
  -----------------------------------------------------------------------------
  -- Data orginization in the input file :
  -----------------------------------------------------------------------------
  -- Exemple of input.txt file :
  -- Time1 N1
  -- Data_1
  -- Data_2
  --  ...
  -- Data_N1
  -- Time2 N2
  -- Data_1
  -- Data_2
  --  ...
  -- Data_N2
  -- ...
  -- TimeK NK
  -- Data_1
  -- Data_2
  --  ...
  -- Data_NK
  -----------------------------------------------------------------------------
  -- Time : integer. Waiting time (in ns) before to send the following message
  --         0 = wait on same packet type received
  -- N    : integer. Length (in Byte) of the following message.
  -- Data : integer(0 to 255). A part of the message.
  -----------------------------------------------------------------------------

  PROCESS IS
    VARIABLE line_var          : LINE;
    VARIABLE line_var2         : LINE;
    VARIABLE waiting_time      : INTEGER;
    VARIABLE length_of_message : INTEGER;
    VARIABLE value             : INTEGER;
    VARIABLE pkt_type          : INTEGER;
    VARIABLE current_packet_var  : STRING(1 to 256);
  BEGIN  -- PROCESS
    txwrite <= '0';
    txflag  <= '0';
    WAIT UNTIL clk = '1';
    IF start_of_simu = '1' THEN

      IF endfile(input_file) THEN
        end_of_simu <= '1';
      ELSE
        end_of_simu <= '0';
        readline(input_file, line_var);
        line_var2 := line_var;
        current_packet_var := (others => ' ');
        current_packet_var(1 to line_var2.all'length) := line_var2.all;
        report "SPW_SENDER: Sending " & current_packet_var;
        current_packet <= current_packet_var;
        read(line_var, waiting_time);
        read(line_var, length_of_message);
	      WAIT FOR waiting_time * 1 ns;
        FOR char_number IN 0 TO length_of_message-1 LOOP
          WAIT UNTIL clk = '1' AND txrdy = '1';
          readline(input_file, line_var);
          read(line_var, value);
          txwrite <= '1';
          txflag  <= '0';
          txdata  <= STD_LOGIC_VECTOR(to_unsigned(value, txdata'LENGTH));
          IF char_number = 1 THEN
            pkt_type  := value;
          END IF;
        END LOOP;  -- char_number
        WAIT UNTIL clk = '1' AND txrdy = '1';
        txwrite <= '1';
        txflag  <= '1';
        txdata  <= (OTHERS => '0');
        WAIT UNTIL clk = '1';
        txwrite <= '0';
        txflag  <= '0';
        IF waiting_time = 0 THEN
          IF pkt_type = 1 THEN
		        WAIT UNTIL ack_rmap_packet = '1';
	        ELSIF pkt_type = 2 THEN
		        WAIT UNTIL ack_ccsds_packet = '1';
		      END IF;
	      END IF;
      END IF;
    END IF;

  END PROCESS;

END beh;
