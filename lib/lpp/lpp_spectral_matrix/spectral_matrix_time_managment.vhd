LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY spectral_matrix_time_managment IS
  
  PORT (
    clk  : IN STD_LOGIC;
    rstn : IN STD_LOGIC;

    time_in  : IN STD_LOGIC_VECTOR(47 DOWNTO 0);
    update_1 : IN STD_LOGIC;
    time_out : OUT STD_LOGIC_VECTOR(47 DOWNTO 0)
    );

END spectral_matrix_time_managment;

ARCHITECTURE beh OF spectral_matrix_time_managment IS
  
  SIGNAL time_reg : STD_LOGIC_VECTOR(47 DOWNTO 0);                                     
  
BEGIN  -- beh

  PROCESS (clk, rstn)
  BEGIN
    IF rstn = '0' THEN
      time_reg <= (OTHERS => '0');
    ELSIF clk'event AND clk = '1' THEN
      IF update_1 = '1' THEN
        time_reg <= time_in;
      END IF;
    END IF;
  END PROCESS;

  time_out <= time_reg;
  
END beh;
