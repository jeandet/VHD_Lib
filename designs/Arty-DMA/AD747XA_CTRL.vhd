library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;
library WORK;
use WORK.AD747X.all;

entity AD747XA_CTRL is
generic ( 
    chan_count :
     integer := 2
    
       );
    Port ( 
           clk        : in STD_LOGIC;
           rstn       : in STD_LOGIC;
           serial_clk : in STD_LOGIC;
           sdata      :  in STD_LOGIC_VECTOR(chan_count-1 downto 0);
           sampleValid : out STD_LOGIC;
           convert    : in STD_LOGIC;
           csn        : out STD_LOGIC;
           data       : out ad747X_sample_v(chan_count-1 downto 0)
           );
           
end AD747XA_CTRL;

architecture Behavioral of AD747XA_CTRL is
signal enable : STD_LOGIC := '0';

signal sample : STD_LOGIC;
signal enable_r : STD_LOGIC;
signal ready : STD_LOGIC_VECTOR(chan_count-1 downto 0);
signal data_r   :  ad747X_sample_v(chan_count-1 downto 0);
signal convert_D : STD_LOGIC;

component SerDes is
    generic ( 
        Dbits : integer := 16
           );   
    Port (
           serial_clk : in STD_LOGIC;
           clk        : in STD_LOGIC;
           rstn       : in STD_LOGIC;
           load : in STD_LOGIC;
           enable : in STD_LOGIC;
           serial_in : in STD_LOGIC;
           parallel_in : in STD_LOGIC_VECTOR(Dbits-1 downto 0);
           dout : out STD_LOGIC;
           parallel_out : out STD_LOGIC_VECTOR(Dbits-1 downto 0);
           ready : out STD_LOGIC
          );
end component;

begin 

SRX: for i in 0 to chan_count-1 generate
SR1 : SerDes 
    generic map( 
        Dbits => 16
           )  
    Port map(
           serial_clk    => serial_clk,
           clk           => clk,
           rstn          => rstn,
           load          => '0',
           enable        => enable,
           serial_in     => sdata(i),
           parallel_in   => X"0000",
           dout          => open,
           parallel_out  => data_r(i),  
           ready         => ready(i)
          );
   data(i) <= '0' & data_r(i)(15 downto 1);
end generate SRx;     

enable <= enable_r;

process(clk,rstn)
   begin
        if rstn = '0' then
            enable_r <= '0';
            csn <= '1';
            SampleValid <= '0';
        elsif (clk'event and clk='1') then
            convert_D <= convert;
             if (convert = '1' and convert_D = '0') then
                enable_r <= '1';
                csn <= '0';
                SampleValid <= '0';
             else
                if (ready(0) = '1' and enable_r = '0') then
                    csn <= '1';
                    SampleValid <= '1';
                end if;
                enable_r <= '0';
             end if;
       end if;

end process;

end Behavioral;
