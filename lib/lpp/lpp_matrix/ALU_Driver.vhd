------------------------------------------------------------------------------
--  This file is a part of the LPP VHDL IP LIBRARY
--  Copyright (C) 2009 - 2010, Laboratory of Plasmas Physic - CNRS
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 3 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA 
-------------------------------------------------------------------------------
--                    Author : Martin Morlot
--                   Mail : martin.morlot@lpp.polytechnique.fr
-------------------------------------------------------------------------------
library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
library lpp;
use lpp.general_purpose.all;

--! Driver de l'ALU

entity ALU_Driver is
  generic(
      Input_SZ_1      :   integer := 16;
      Input_SZ_2      :   integer := 16);
  port(
      clk       :   in std_logic;                                --! Horloge du composant
      reset     :   in std_logic;                                --! Reset general du composant
      IN1       :   in std_logic_vector(Input_SZ_1-1 downto 0);  --! Donn�e d'entr�e
      IN2       :   in std_logic_vector(Input_SZ_2-1 downto 0);  --! Donn�e d'entr�e
      Take      :   in std_logic;                                --! Flag, op�rande r�cup�r�
      Received  :   in std_logic;                                --! Flag, R�sultat bien ressu
      Conjugate :   in std_logic;                                --! Flag, Calcul sur un complexe et son conjugu�
      Valid     :   out std_logic;                               --! Flag, R�sultat disponible
      Read      :   out std_logic;                               --! Flag, op�rande disponible
      CTRL      :   out std_logic_vector(2 downto 0);            --! Permet de s�lectionner la/les op�ration d�sir�e
      COMP      :   out  std_logic_vector(1 downto 0);            --! (set) Permet de compl�menter les op�randes
      OP1       :   out std_logic_vector(Input_SZ_1-1 downto 0); --! Premier Op�rande
      OP2       :   out std_logic_vector(Input_SZ_2-1 downto 0)  --! Second Op�rande
);
end ALU_Driver;

--! @details Les op�randes sont issue des donn�es d'entr�es et associ� aux bonnes valeurs sur CTRL, les diff�rentes op�rations sont effectu�es 

architecture ar_ALU_Driver of ALU_Driver is

signal OP1re : std_logic_vector(Input_SZ_1-1 downto 0);
signal OP1im : std_logic_vector(Input_SZ_1-1 downto 0);
signal OP2re : std_logic_vector(Input_SZ_2-1 downto 0);
signal OP2im : std_logic_vector(Input_SZ_2-1 downto 0);

signal go_st        : std_logic;
signal Take_reg     : std_logic;
signal Received_reg : std_logic;

type etat is (eX,e0,e1,e2,e3,e4,e5,eY,eZ,eW);
signal ect : etat;
signal st  : etat;

begin
    process(clk,reset)
    begin

        if(reset='0')then
            ect          <= eX;
            st           <= e0;
            go_st        <= '0';
            CTRL         <= ctrl_CLRMAC;
            COMP         <= "00"; -- pas de complement
            Read         <= '0';
            Valid        <= '0';
            Take_reg     <= '0';
            Received_reg <= '0';

        elsif(clk'event and clk='1')then
            Take_reg     <= Take;
            Received_reg <= Received;
            
            case ect is
                when eX =>
                    go_st <= '0';
                    Read  <= '1';
                    CTRL  <= ctrl_CLRMAC;
                    ect   <= e0;

                when e0 =>
                    OP1re <= IN1;
                    if(Conjugate='1')then           --
                        OP2re <= IN1;               --
                    else                            --
                        OP2re <= IN2;               -- modif 23/06/11
                    end if;                         --
                    if(Take_reg='0' and Take='1')then
                        read <= '0'; 
                        ect  <= e1;
                    end if;

                when e1 =>
                    OP1  <= OP1re;
                    OP2  <= OP2re;
                    CTRL <= ctrl_MAC;
                    Read <= '1';
                    ect  <= eY;
              
                when eY =>
                    OP1im <= IN1;
                    if(Conjugate='1')then           --
                        OP2im <= IN1;               --
                    else                            --
                        OP2im <= IN2;               -- modif 23/06/11
                    end if;                         --
                    CTRL  <= ctrl_IDLE;
                    if(Take_reg='1' and Take='0')then
                        Read <= '0';
                        ect  <= e2;
                    end if; 
                    
                when e2 =>                    
                    OP1  <= OP1im;
                    OP2  <= OP2im;
                    CTRL <= ctrl_MAC;
                    ect  <= eZ;
                    
                when eZ =>
                    CTRL  <= ctrl_IDLE;
                    go_st <= '1';
                    if(Received_reg='0' and Received='1')then
                        if(Conjugate='1')then     
                            ect <= eX;
                        else
                            ect <= e3;
                        end if;
                    end if;

                when e3 =>
                    CTRL  <= ctrl_CLRMAC;
                    go_st <= '0';
                    ect   <= e4;

                when e4 =>
                    OP1  <= OP1im;
                    OP2  <= OP2re;
                    CTRL <= ctrl_MAC;
                    ect  <= e5;
                
                when e5 =>
                    OP1  <= OP1re;
                    OP2  <= OP2im;
                    COMP <= "10";
                    ect  <= eW;

                when eW =>
                    CTRL  <= ctrl_IDLE;
                    COMP  <= "00";
                    go_st <= '1';
                    if(Received_reg='1' and Received='0')then
                        ect <= eX;
                    end if;
            end case;
---------------------------------------------------------------------------------
            case st is
                when e0 =>                    
                    if(go_st='1')then                         
                        st <= e1;
                    end if;

                when e1 =>                    
                    Valid <= '1';
                    st    <= e2;

                when e2 =>
                    if(Received_reg='0' and Received='1')then
                        Valid <= '0';
                        if(Conjugate='1')then
                            st <= eY;
                        else
                            st <= eX;
                        end if;
                    end if;

                when eX =>
                    st <= e3;

                when e3 =>
                    if(go_st='1')then 
                        st <= e4;
                    end if;
                
                when e4 =>
                    Valid <= '1';
                    st    <= e5;
                
                when e5 =>
                    if(Received_reg='1' and Received='0')then
                        Valid <= '0';                    
                        st    <= eY;
                    end if;
                                
                when eY =>
                    st <= e0;
                        
                when others =>
                    null;
            end case; 

        end if;
    end process;

end ar_ALU_Driver;