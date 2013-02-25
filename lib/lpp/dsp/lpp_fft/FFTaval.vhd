-- FFTaval.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity FFTaval is
generic(
    Data_sz  : integer range 1 to 32 := 8
    );
port(
    clk         : in std_logic;
    rstn        : in std_logic;
    Ready       : in std_logic;
    Valid       : in std_logic;
    Full        : in std_logic;
    Data_re     : in std_logic_vector(Data_sz-1 downto 0);
    Data_im     : in std_logic_vector(Data_sz-1 downto 0);
    Read        : out std_logic;
    Write       : out std_logic;
    ReUse       : out std_logic;
    DATA        : out std_logic_vector(Data_sz-1 downto 0)
);
end entity;


architecture ar_FFTaval of FFTaval is

type etat is (eX,e0,e1,e2,e3);
signal ect : etat;

signal DataTmp  : std_logic_vector(Data_sz-1 downto 0);

signal sReady   : std_logic;

begin

    process(clk,rstn)
    begin
        if(rstn='0')then 
            ect <= e0;
            Read <= '0';
            Write <= '1';
            Reuse <= '0';
            
        elsif(clk'event and clk='1')then
            sReady <= Ready;

            case ect is

                when e0 =>
                    Write <= '1';
                    if(sReady='0' and Ready='1' and full='0')then
                        Read <= '1';
                        ect <= e1;
                    end if;

                when e1 =>
                    Read <= '0';
                    if(Valid='1' and full='0')then
                        DataTmp <= Data_im;
                        DATA <= Data_re;
                        Write <= '0';
                        ect <= e2;
                    elsif(full='1')then
                        ReUse <= '1';
                        ect <= e0;
                    end if;                    

                 when e2 =>
                    DATA <= DataTmp;
                    ect <= e3;            
 
                when e3 =>
                    Write <= '1';
                    if(Ready='1' and full='0')then
                        Read <= '1';
                        ect <= e1;
                    end if;
                               
                when eX =>
                    null;                   

            end case;
        end if;
    end process;



end architecture;

