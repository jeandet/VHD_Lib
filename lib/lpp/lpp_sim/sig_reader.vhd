LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY std;
USE std.textio.ALL;

LIBRARY lpp;
USE lpp.data_type_pkg.ALL;

ENTITY sig_reader IS
GENERIC(
    FNAME       : STRING  := "input.txt";
    WIDTH       : INTEGER := 1;
    RESOLUTION  : INTEGER := 8;
    GAIN        : REAL    := 1.0
);
PORT(
    clk             : IN std_logic;
    end_of_simu     : out std_logic;
    out_signal      : out sample_vector(0 to WIDTH-1,RESOLUTION-1 downto 0)
);
END sig_reader;

ARCHITECTURE beh OF sig_reader IS
  FILE input_file    : TEXT OPEN read_mode IS FNAME;
  SIGNAL out_signal_reg  :  sample_vector(0 to WIDTH-1,RESOLUTION-1 downto 0):=(others=>(others=>'0'));
  SIGNAL end_of_simu_reg     :  std_logic:='0';
BEGIN 
    out_signal <= out_signal_reg;
    end_of_simu <= end_of_simu_reg;
    PROCESS
        VARIABLE line_var : LINE;
        VARIABLE value    : INTEGER;
        VARIABLE cell     : STD_LOGIC_VECTOR(RESOLUTION-1 downto 0);
    BEGIN
        WAIT UNTIL clk = '1';
        IF endfile(input_file) THEN
            end_of_simu_reg <= '1';
        ELSE
            end_of_simu_reg <= '0';
            readline(input_file,line_var);
            FOR COL IN 0 TO WIDTH-1 LOOP
                read(line_var, value);
                cell := std_logic_vector(to_signed(INTEGER(GAIN*REAL(value)) , RESOLUTION));
                FOR bit_idx IN RESOLUTION-1 downto 0 LOOP
                    out_signal_reg(COL,bit_idx) <= cell(bit_idx);
                END LOOP;
            END LOOP;
        END IF;
    END PROCESS;

END beh;
