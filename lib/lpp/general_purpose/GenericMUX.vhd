ENTITY GenericMUX IS
  GENERIC (
    data_SZ : INTEGER := 8;
    input_NB : INTEGER := 2;
    NB_STAGE : INTEGER := 1);
  PORT (
    sel    : IN  STD_LOGIC_VECTOR(NB_STAGE-1 DOWNTO 0);
    input  : IN  ARRAY(0 TO (input_NB-1)) OF STD_LOGIC_VECTOR(data_SZ-1 DOWNTO 0);
    output : OUT STD_LOGIC_VECTOR(data_SZ-1 DOWNTO 0)
    );
END GenericMUX;

ARCHITECTURE beh OF GenericMUX IS

  COMPONENT GenericMUX
    GENERIC (
      data_SZ  : INTEGER;
      input_NB : INTEGER;
      NB_STAGE : INTEGER);
    PORT (
      sel    : IN  STD_LOGIC_VECTOR(NB_STAGE-1 DOWNTO 0);
      input  : IN  ARRAY(0 TO (input_NB-1)) OF STD_LOGIC_VECTOR(data_SZ-1 DOWNTO 0);
      output : OUT STD_LOGIC_VECTOR(data_SZ-1 DOWNTO 0));
  END COMPONENT;

  SIGNAL s : ARRAY(0 TO 2**(NB_STAGE-1)-1 ) OF STD_LOGIC_VECTOR(data_SZ-1 DOWNTO 0);
    
BEGIN  -- beh

  nb_stage_1: IF NB_STAGE = 1 GENERATE
    input_nb_2: IF input_NB > 1 GENERATE
      output <= input(0) WHEN sel = "0" ELSE input(1);
    END GENERATE input_nb_2;
    input_nb_2: IF input_NB = 1 GENERATE
      output <= input(0) ;
    END GENERATE input_nb_2;
    input_nb_2: IF input_NB < 1 GENERATE
      output <= (OTHERS => '0');
    END GENERATE input_nb_2;    
  END GENERATE nb_stage_1;<label>: IF NERIC MAP (
        data_SZ  => data_SZ,
        input_NB => 2**(NB_STAGE-1),
        NB_STifAGE => NB_STAGE-1)
      PORT MAP (
        sel    => sel(NB_STAGE-2 DOWNTO 0),
        input  => s,
        output => output);

    
  END GENERATE nb_stages;
  
END beh;
