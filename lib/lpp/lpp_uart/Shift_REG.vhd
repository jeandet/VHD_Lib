-- Shift_REG.vhd
library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;

--! Gestion Reception/Transmission

entity Shift_REG is
generic(Data_sz     :   integer :=  10);
port(
    clk         :   in  std_logic;
    Sclk        :   in  std_logic;
    reset       :   in  std_logic;
    SIN         :   in  std_logic;
    SOUT        :   out std_logic;
    Serialize   :   in  std_logic;
    Serialized  :   out std_logic;
    D           :   in  std_logic_vector(Data_sz-1 downto 0);
    Q           :   out std_logic_vector(Data_sz-1 downto 0)

);
end entity;


architecture ar_Shift_REG of Shift_REG is 

signal   REG                :   std_logic_vector(Data_sz-1 downto 0);
signal   Serialized_int     :   std_logic;
signal   Serialize_reg      :   std_logic;
signal   CptBits            :   std_logic_vector(Data_sz-1 downto 0);
constant CptBits_trig       :   std_logic_vector(Data_sz-1 downto 0) := (others => '1');
signal   CptBits_flag       :   std_logic;
signal   CptBits_flag_reg   :   std_logic;

begin

Serialized          <=  Serialized_int;
CptBits_flag        <=  '1' when CptBits = CptBits_trig else '0';

process(reset,clk)
begin
    if reset = '0' then
        Serialized_int  <=  '1';
        CptBits_flag_reg    <=  '0';
        Q               <=  (others => '0');
    elsif clk'event and clk = '1' then
        CptBits_flag_reg    <=  CptBits_flag;
        
        if CptBits_flag = '1' and CptBits_flag_reg = '0' then
            Serialized_int  <=  '1';
            Q               <=  REG;
        elsif Serialize = '1'  then
            Serialized_int  <=  '0';
        end if;
    end if;
end process;


process(reset,Sclk)
begin
    if reset = '0' then
        CptBits <=  (others =>  '0');
        REG     <=  (others =>  '0');
        SOUT    <=  '1';
        Serialize_reg  <=  '0';
    elsif Sclk'event and Sclk = '1' then
        Serialize_reg       <=  Serialized_int;
        if (Serialized_int = '0' and Serialize_reg ='1') then
            REG          <=  SIN & D(Data_sz-1 downto 1);
            SOUT         <=  D(0);
        elsif CptBits_flag ='1' then
            REG          <=  SIN & D(Data_sz-1 downto 1);
            SOUT         <=  D(0);
        elsif Serialized_int = '0' then
            REG          <=  SIN & REG(Data_sz-1 downto 1);
            SOUT         <=  REG(0);
        else
            SOUT         <=  '1';
        end if;
        if Serialized_int = '0' then
            if CptBits_flag = '1' then
                CptBits <=  (others =>  '0');
            else
                CptBits <=  '1' & CptBits(Data_sz-1 downto 1);
            end if;

        else
            CptBits <=  (others =>  '0');
        end if;
        
    end if;
end process;

end ar_Shift_REG;