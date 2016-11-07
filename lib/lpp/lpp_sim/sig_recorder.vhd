LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY std;
USE std.textio.ALL;

LIBRARY lpp;
USE lpp.data_type_pkg.ALL;

ENTITY sig_recorder IS
GENERIC(
    FNAME       : STRING  := "output.txt";
    WIDTH       : INTEGER := 1;
    RESOLUTION  : INTEGER := 8
);
PORT(
    clk             : IN STD_LOGIC;
    end_of_simu     : IN STD_LOGIC;
    timestamp       : IN INTEGER;
    input_signal    : IN sample_vector(0 TO WIDTH-1,RESOLUTION-1 DOWNTO 0)
);
END sig_recorder;


ARCHITECTURE beh OF sig_recorder IS
  FILE output_file    : TEXT OPEN write_mode IS FNAME;
BEGIN

  PROCESS(clk,end_of_simu)
    VARIABLE line_var : LINE;
    VARIABLE cell : std_logic_vector(RESOLUTION-1 downto 0):=(OTHERS => '0');
  BEGIN
    IF end_of_simu = '1' THEN
      file_close(output_file);
    ELSIF clk'EVENT AND clk = '1' THEN
      write(line_var, INTEGER'IMAGE(timestamp));
      FOR I IN 0 TO WIDTH-1 LOOP
        FOR bit_idx IN 0 TO RESOLUTION-1 LOOP
          cell(bit_idx) := input_signal(I,bit_idx);
        END LOOP;
        write(line_var, " " & INTEGER'IMAGE(to_integer(SIGNED(cell))));
      END LOOP;
      writeline(output_file, line_var);
    END IF;
  END PROCESS;

END beh;
