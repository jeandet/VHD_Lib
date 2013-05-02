-- DC_FRAME_PLACER.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;



entity DC_FRAME_PLACER is
generic(WordSize :integer := 8;WordCnt   :   integer := 144;MinFCount   :   integer := 64);
port(
    clk     :   in  std_logic;
    Wcount  :   in  integer range 0 to WordCnt-1;
    MinFCnt :   in  integer range 0 to MinFCount-1;
    Flag    :   out std_logic;
    AMR1X   :   in  std_logic_vector(23 downto 0);
    AMR1Y   :   in  std_logic_vector(23 downto 0);
    AMR1Z   :   in  std_logic_vector(23 downto 0);
    AMR2X   :   in  std_logic_vector(23 downto 0);
    AMR2Y   :   in  std_logic_vector(23 downto 0);
    AMR2Z   :   in  std_logic_vector(23 downto 0);
    AMR3X   :   in  std_logic_vector(23 downto 0);
    AMR3Y   :   in  std_logic_vector(23 downto 0);
    AMR3Z   :   in  std_logic_vector(23 downto 0);
    AMR4X   :   in  std_logic_vector(23 downto 0);
    AMR4Y   :   in  std_logic_vector(23 downto 0);
    AMR4Z   :   in  std_logic_vector(23 downto 0);
    Temp1   :   in  std_logic_vector(23 downto 0);
    Temp2   :   in  std_logic_vector(23 downto 0);
    Temp3   :   in  std_logic_vector(23 downto 0);
    Temp4   :   in  std_logic_vector(23 downto 0);
    WordOut :   out std_logic_vector(WordSize-1 downto 0)

);
end entity; 





architecture ar_DC_FRAME_PLACER of DC_FRAME_PLACER is

signal  MinFCntVect     :   std_logic_vector(8 downto 0);
signal  MinFCntVectLSB  :   std_logic;   

begin

MinFCntVect     <=  std_logic_vector(TO_UNSIGNED(MinFCnt,9));
MinFCntVectLSB  <=  MinFCntVect(0);
    process(clk)
    begin
        if clk'event and clk ='1' then
            case MinFCntVect(2 downto 0) is
				    when "000" =>
                    case Wcount is
                        when 47 =>
                            WordOut <=  AMR1X(23 downto 16);
                            Flag <= '1';
                        when 48 =>
                            WordOut <=  AMR1X(15 downto 8);
                            Flag <= '1';
									 
                        when 49 =>
                            WordOut <=  AMR1X(7 downto 0);
                            Flag <= '1';
                        when 50 =>
                            WordOut <=  AMR1Y(23 downto 16);
                            Flag <= '1';
									 
                        when 51 =>
                            WordOut <=  AMR1Y(15 downto 8);
                            Flag <= '1';
                        when 52 =>
                            WordOut <=  AMR1Y(7 downto 0);
                            Flag <= '1';
									 
                        when others =>
                            WordOut <=  X"A5";
                            Flag <= '0';
                    end case;
                when  "001"   =>
                    case Wcount is
                        when 47 =>
                            WordOut <=  AMR1Z(23 downto 16);
                            Flag <= '1';
                        when 48 =>
                            WordOut <=  AMR1Z(15 downto 8);
                            Flag <= '1';
									 
                        when 49 =>
                            WordOut <=  AMR1Z(7 downto 0);
                            Flag <= '1';
                        when 50 =>
                            WordOut <=  AMR2X(23 downto 16);
                            Flag <= '1';
									 
                        when 51 =>
                            WordOut <=  AMR2X(15 downto 8);
                            Flag <= '1';
                        when 52 =>
                            WordOut <=  AMR2X(7 downto 0);
                            Flag <= '1';
									 
                        when others =>
                            WordOut <=  X"A5";
                            Flag <= '0';
                    end case;
                when  "010"   =>
                    case Wcount is
                        when 47 =>
                            WordOut <=  AMR2Y(23 downto 16);
                            Flag <= '1';
                        when 48 =>
                            WordOut <=  AMR2Y(15 downto 8);
                            Flag <= '1';
									 
                        when 49 =>
                            WordOut <=  AMR2Y(7 downto 0);
                            Flag <= '1';
                        when 50 =>
                            WordOut <=  AMR2Z(23 downto 16);
                            Flag <= '1';
									 
                        when 51 =>
                            WordOut <=  AMR2Z(15 downto 8);
                            Flag <= '1';
                        when 52 =>
                            WordOut <=  AMR2Z(7 downto 0);
                            Flag <= '1';
									 
                        when others =>
                            WordOut <=  X"A5";
                            Flag <= '0';
                    end case;	
                when  "011"   =>
                    case Wcount is
                        when 47 =>
                            WordOut <=  AMR3X(23 downto 16);
                            Flag <= '1';
                        when 48 =>
                            WordOut <=  AMR3X(15 downto 8);
                            Flag <= '1';
									 
                        when 49 =>
                            WordOut <=  AMR3X(7 downto 0);
                            Flag <= '1';
                        when 50 =>
                            WordOut <=  AMR3Y(23 downto 16);
                            Flag <= '1';
									 
                        when 51 =>
                            WordOut <=  AMR3Y(15 downto 8);
                            Flag <= '1';
                        when 52 =>
                            WordOut <=  AMR3Y(7 downto 0);
                            Flag <= '1';
									 
                        when others =>
                            WordOut <=  X"A5";
                            Flag <= '0';
                    end case;							
                when  "100"   =>
                    case Wcount is
                        when 47 =>
                            WordOut <=  AMR3Z(23 downto 16);
                            Flag <= '1';
                        when 48 =>
                            WordOut <=  AMR3Z(15 downto 8);
                            Flag <= '1';
									 
                        when 49 =>
                            WordOut <=  AMR3Z(7 downto 0);
                            Flag <= '1';
                        when 50 =>
                            WordOut <=  AMR4X(23 downto 16);
                            Flag <= '1';
									 
                        when 51 =>
                            WordOut <=  AMR4X(15 downto 8);
                            Flag <= '1';
                        when 52 =>
                            WordOut <=  AMR4X(7 downto 0);
                            Flag <= '1';
									 
                        when others =>
                            WordOut <=  X"A5";
                            Flag <= '0';
                    end case;			
                when  "101"   =>
                    case Wcount is
                        when 47 =>
                            WordOut <=  AMR4Y(23 downto 16);
                            Flag <= '1';
                        when 48 =>
                            WordOut <=  AMR4Y(15 downto 8);
                            Flag <= '1';
									 
                        when 49 =>
                            WordOut <=  AMR4Y(7 downto 0);
                            Flag <= '1';
                        when 50 =>
                            WordOut <=  AMR4Z(23 downto 16);
                            Flag <= '1';
									 
                        when 51 =>
                            WordOut <=  AMR4Z(15 downto 8);
                            Flag <= '1';
                        when 52 =>
                            WordOut <=  AMR4Z(7 downto 0);
                            Flag <= '1';
									 
                        when others =>
                            WordOut <=  X"A5";
                            Flag <= '0';
                    end case;							
                when  "110"   =>
                    case Wcount is
                        when 47 =>
                            WordOut <=  Temp1(23 downto 16);
                            Flag <= '1';
                        when 48 =>
                            WordOut <=  Temp1(15 downto 8);
                            Flag <= '1';
									 
                        when 49 =>
                            WordOut <=  Temp1(7 downto 0);
                            Flag <= '1';
                        when 50 =>
                            WordOut <=  Temp2(23 downto 16);
                            Flag <= '1';
									 
                        when 51 =>
                            WordOut <=  Temp2(15 downto 8);
                            Flag <= '1';
                        when 52 =>
                            WordOut <=  Temp2(7 downto 0);
                            Flag <= '1';
									 
                        when others =>
                            WordOut <=  X"A5";
                            Flag <= '0';
                    end case;							
                when  "111"   =>
                    case Wcount is
                        when 47 =>
                            WordOut <=  Temp3(23 downto 16);
                            Flag <= '1';
                        when 48 =>
                            WordOut <=  Temp3(15 downto 8);
                            Flag <= '1';
									 
                        when 49 =>
                            WordOut <=  Temp3(7 downto 0);
                            Flag <= '1';
                        when 50 =>
                            WordOut <=  Temp4(23 downto 16);
                            Flag <= '1';
									 
                        when 51 =>
                            WordOut <=  Temp4(15 downto 8);
                            Flag <= '1';
                        when 52 =>
                            WordOut <=  Temp4(7 downto 0);
                            Flag <= '1';
									 
                        when others =>
                            WordOut <=  X"A5";
                            Flag <= '0';
                    end case;		
                    when others =>
                            WordOut <=  X"A5";
                            Flag <= '0';						  
						  						  
            end case;
        end if;
    end process;



end ar_DC_FRAME_PLACER;

























