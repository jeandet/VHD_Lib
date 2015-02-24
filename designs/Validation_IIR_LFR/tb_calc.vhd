LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY lpp;
USE lpp.cic_pkg.ALL;
USE lpp.data_type_pkg.ALL;
USE lpp.chirp_pkg.ALL;

ENTITY testbench IS
END;

ARCHITECTURE behav OF testbench IS

  SIGNAL clk            : STD_LOGIC := '0';
  SIGNAL rstn           : STD_LOGIC;

  CONSTANT VECTOR_SIZE : INTEGER := 4*2;
  SIGNAL VECTOR_1        : STD_LOGIC_VECTOR(VECTOR_SIZE-1 DOWNTO 0);
  SIGNAL VECTOR_MIN      : STD_LOGIC_VECTOR(VECTOR_SIZE-1 DOWNTO 0);
  SIGNAL VECTOR_MAX      : STD_LOGIC_VECTOR(VECTOR_SIZE-1 DOWNTO 0);

  SIGNAL all_done : STD_LOGIC;
  SIGNAL all_ok   : STD_LOGIC;
  SIGNAL all_ok_E   : STD_LOGIC;
  
  SIGNAL A : STD_LOGIC_VECTOR(VECTOR_SIZE-1 DOWNTO 0);
  SIGNAL B : STD_LOGIC_VECTOR(VECTOR_SIZE-1 DOWNTO 0);
  
  SIGNAL C : STD_LOGIC_VECTOR(VECTOR_SIZE-1 DOWNTO 0);
  
  SIGNAL D_0 : STD_LOGIC_VECTOR(VECTOR_SIZE/2 DOWNTO 0);
  SIGNAL D_1 : STD_LOGIC_VECTOR(VECTOR_SIZE/2-1 DOWNTO 0);
  SIGNAL D : STD_LOGIC_VECTOR(VECTOR_SIZE-1 DOWNTO 0);
  
  SIGNAL E : STD_LOGIC_VECTOR(VECTOR_SIZE-1 DOWNTO 0);
  
  
BEGIN
  VECTOR_1(0)  <= '1';
  VECTOR_1(VECTOR_SIZE-1 DOWNTO 1) <= (OTHERS => '0') ;
  
  VECTOR_MIN(VECTOR_SIZE-1)          <= '1';
  VECTOR_MIN(VECTOR_SIZE-2 DOWNTO 0) <= (OTHERS => '0') ;
  VECTOR_MAX(VECTOR_SIZE-1)          <= '0';
  VECTOR_MAX(VECTOR_SIZE-2 DOWNTO 0) <= (OTHERS => '1') ;

  clk <= NOT clk AFTER 5 ns;
    
  PROCESSD_0(VECTOR_SIZE/2)
  BEGIN  -- PROCESS
    WAIT UNTIL clk = '1';
    rstn <= '0';
    WAIT UNTIL clk = '1';
    rstn <= '1';
    WAIT UNTIL clk = '1';

    
    WAIT FOR 2 ms;
    REPORT "*** END simulation ***" SEVERITY failure;
    WAIT;    
  END PROCESS;

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      A <= VECTOR_MIN;
      B <= VECTOR_MIN;
      all_done <= '0';
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      all_done <= '0';
      IF A = VECTOR_MAX THEN
        A <= VECTOR_MIN;
        IF B = VECTOR_MAX THEN
          B <= VECTOR_MIN;
          all_done <= '1';
        ELSE
          B <= STD_LOGIC_VECTOR(signed(B) + signed(VECTOR_1));
        END IF;
      ELSE
        A <= STD_LOGIC_VECTOR(signed(A) + signed(VECTOR_1));
      END IF;
    END IF;
  END PROCESS;
  
 
  C <= STD_LOGIC_VECTOR(SIGNED(A)   - SIGNED(B));
  
  E <= STD_LOGIC_VECTOR(UNSIGNED(A) - UNSIGNED(B));

  

  
  D_0 <= STD_LOGIC_VECTOR(SIGNED('0'&A(VECTOR_SIZE/2-1 DOWNTO 0)) - SIGNED('0' & B(VECTOR_SIZE/2-1 DOWNTO 0)));
  
  D_1 <= STD_LOGIC_VECTOR(    SIGNED(A(VECTOR_SIZE-1 DOWNTO VECTOR_SIZE/2))
                            - SIGNED(B(VECTOR_SIZE-1 DOWNTO VECTOR_SIZE/2))
                            - SIGNED(VECTOR_1(VECTOR_SIZE/2-1 DOWNTO 1) & D_0(VECTOR_SIZE/2) ));
         
  D <= D_1(VECTOR_SIZE/2-1 DOWNTO 0) & D_0(VECTOR_SIZE/2-1 DOWNTO 0);


  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      all_ok <= '1';
      all_ok_E <= '1';
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      IF D = C THEN
        all_ok <= '1';
      ELSE
        all_ok <= '0';
      END IF;
      
      IF E = C THEN
        all_ok_E <= '1';
      ELSE
        all_ok_E <= '0';
      END IF;
    END IF;
  END PROCESS;
  
END;

