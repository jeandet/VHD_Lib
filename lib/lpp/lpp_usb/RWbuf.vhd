-- RWbuf.vhd
library IEEE;
use IEEE.numeric_bit.all;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RWbuf is
    generic(DataMax : integer := 1024);
    port(
        clk         : in std_logic;
        rst         : in std_logic;
        flagC       : in std_logic;
        flagB       : in std_logic;
        IOselect    : in std_logic; 
        ifclk       : out std_logic;
        sloe        : out std_logic;        
        slrd        : out std_logic;
        slwr        : out std_logic;
        pktend      : out std_logic;
        fifoadr     : out std_logic_vector(1 downto 0);
        fdbusrw     : inout std_logic_vector(7 downto 0)
    );
end entity;


architecture ar_RWbuf of RWbuf is 

type data is array (natural range <>) of std_logic_vector(7 downto 0);
signal send_data : data (DataMax downto 0);

type etat is (S0,S1,S2,S3,S4,S5,S6);                        
signal state : etat;

signal Yout         : std_logic_vector(7 downto 0);
signal Sint         : std_logic_vector(7 downto 0);
signal index_data   : integer range 0 to DataMax := 0;
signal index_data_read : integer range 0 to DataMax := 0;

component BIBUF is
    port( PAD : inout std_logic;
          D   : in    std_logic := 'U';
          E   : in    std_logic := 'U';
          Y   : out   std_logic);
end component;

begin 

io_buf0: BIBUF port map(PAD => fdbusrw(0), D=>Sint(0), E=>IOselect, Y=>Yout(0));
io_buf1: BIBUF port map(PAD => fdbusrw(1), D=>Sint(1), E=>IOselect, Y=>Yout(1));
io_buf2: BIBUF port map(PAD => fdbusrw(2), D=>Sint(2), E=>IOselect, Y=>Yout(2));
io_buf3: BIBUF port map(PAD => fdbusrw(3), D=>Sint(3), E=>IOselect, Y=>Yout(3));
io_buf4: BIBUF port map(PAD => fdbusrw(4), D=>Sint(4), E=>IOselect, Y=>Yout(4));
io_buf5: BIBUF port map(PAD => fdbusrw(5), D=>Sint(5), E=>IOselect, Y=>Yout(5));
io_buf6: BIBUF port map(PAD => fdbusrw(6), D=>Sint(6), E=>IOselect, Y=>Yout(6));
io_buf7: BIBUF port map(PAD => fdbusrw(7), D=>Sint(7), E=>IOselect, Y=>Yout(7));

ifclk      <= clk; 

--   process(flagc,flagb)
--        begin
--        if(flagc='0' and flagb='1') then
--        IOselect<='1';
--        end if;
--        if (flagc='1'and flagb='0') then
--        IOselect<='0';
--        end if;
--        if(flagc='0'and flagb='0') then
--        IOselect<='1';
--        end if;
--        if (flagc='1'and flagb='1') then
--        IOselect<='0';
--        end if;
--   end proces

   process(clk,IOselect,rst)

   begin

        if (rst = '0') then    
        state <= S0;
        slwr <= '1';
        pktend <= '1';
        sloe <= '1';
        slrd <= '1';
      

        elsif (clk'event and clk='1' )then
       
           case state is
                     when S0 =>
                         if (IOselect = '0') then
                           state <= S1;
                           fifoadr <= "00"; 
                           index_data <= 0;   
                         elsif (IOselect = '1') then
                           state <= S4;
                         end if;

                     when S1 =>                              -- lecture de ep2
                         if (flagc = '1') then               --selection de EP2
                         state <= S2;
                         sloe<='0'; 
                           else
                           state <= S0;
                           sloe <= '1';
                           slrd <= '1';
                           end if;

                     when S2 => 
                                               -- Vérification: si EP2 n'est pas vide
                            index_data <= index_data + 1;
                            slrd <= '0';
                            send_data(index_data)<=Yout;            --recupére le contenu      
                            state <= S3; 

                    when S3 => 
                       state <= S1;
                       slrd <= '1';
                       if (index_data = 2048)then
                              index_data <= 0;
                       end if;

                                                -- ecriture dans ep6.
                     when S4 =>                 -- ECRITURE DANS EP6
                          fifoadr <= "10";      --selection de EP6
                          state <= S5;
                          index_data_read <= 0;
                          slrd <= '1';
                          sloe <= '1';                      

                     when S5 => 
                             
                         if (flagb = '1') then  -- Vérification: si EP6 est plein
                            index_data_read <= index_data_read +1;
                            slwr <= '0';
                            state <= S6; 
                            Sint <= send_data(index_data_read); --"01000111";
                            else
                            state <= S0; 
                            slwr <= '1';                         
                            end if;

                       when S6 => 
                       slwr <= '1';
                       state <= S5; 
                       if (index_data_read = index_data)then
                              index_data_read <= 0;
                       end if; 
           end case;        

        end if;

    end process;

end architecture;