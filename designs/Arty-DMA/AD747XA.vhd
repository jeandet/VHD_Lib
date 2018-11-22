library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity AD747XA is
   
   Port (  
       serial_clk : in STD_LOGIC; 
       sdata     : out STD_LOGIC; 
       cs_n       : in STD_LOGIC
       );
   
end AD747XA;

architecture Behavioral of AD747XA is

    --Timing specifications
    constant tsclk : time := 1 sec/20000000;  --Fsclk -> 20 MHz
    constant tconvert : time := 16*tsclk; 
    constant tquiet : time := 50 ns;
    constant tpowerup :  time := 1 us;
    constant t1 :  time := 10 ns;
    constant t2 :  time := 10 ns;
    constant t3 :  time := 22 ns;
    constant t4 :  time := 40 ns;
    constant t5 :  time := 0.4*tsclk;
    constant t6 :  time := 0.4*tsclk;
    constant t7 :  time := 9.5 ns; 
    constant t8 :  time := 36 ns;
    
    signal data : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');   
begin
    process
        begin
            
            wait until falling_edge(cs_n);
            wait for t2;
            for i in 0 to 3 loop 
                        wait until falling_edge(serial_clk);   
                        wait for t4;
                        sdata <= data(i); 
            end loop; 
            for i in 3 to 15 loop 
                        wait until falling_edge(serial_clk);   
                        wait for t7;
                        sdata <= data(i); 
            end loop; 

            data <= STD_LOGIC_VECTOR(unsigned(data) + 1);
                    
   end process;
end Behavioral;