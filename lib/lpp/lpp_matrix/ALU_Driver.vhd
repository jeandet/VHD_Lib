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

--! Driver de l'ALU

entity ALU_Driver is
  generic(
      Input_SZ_1      :   integer := 16;
      Input_SZ_2      :   integer := 16);
  port(
      clk       :   in std_logic;                                --! Horloge du composant
      reset     :   in std_logic;                                --! Reset general du composant
      IN1       :   in std_logic_vector(Input_SZ_1-1 downto 0);  --! Donnée d'entrée
      IN2       :   in std_logic_vector(Input_SZ_2-1 downto 0);  --! Donnée d'entrée
      Take      :   in std_logic;                                --! Flag, opérande récupéré
      Received  :   in std_logic;                                --! Flag, Résultat bien ressu
      Conjugate :   in std_logic;                                --! Flag, Calcul sur un complexe et son conjugué
      Valid     :   out std_logic;                               --! Flag, Résultat disponible
      Read      :   out std_logic;                               --! Flag, opérande disponible
      CTRL      :   out std_logic_vector(4 downto 0);            --! Permet de sélectionner la/les opération désirée
      OP1       :   out std_logic_vector(Input_SZ_1-1 downto 0); --! Premier Opérande
      OP2       :   out std_logic_vector(Input_SZ_2-1 downto 0)  --! Second Opérande
);
end ALU_Driver;

--! @details Les opérandes sont issue des données d'entrées et associé aux bonnes valeurs sur CTRL, les différentes opérations sont effectuées 

architecture ar_ALU_Driver of ALU_Driver is

signal OP1re : std_logic_vector(Input_SZ_1-1 downto 0);
signal OP1im : std_logic_vector(Input_SZ_1-1 downto 0);
signal OP2re : std_logic_vector(Input_SZ_2-1 downto 0);
signal OP2im : std_logic_vector(Input_SZ_2-1 downto 0);

signal go_st        : std_logic;
signal Take_reg     : std_logic;
signal Received_reg : std_logic;

type etat is (eX,e0,e1,e2,e3,e4,e5,idle,idle2,idle3);
signal ect : etat;
signal st  : etat;

begin
    process(clk,reset)
    begin

        if(reset='0')then
            ect          <= eX;
            st           <= e0;
            go_st        <= '0';
            CTRL         <= "10000";
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
                    CTRL  <= "10000";
                    ect   <= e0;

                when e0 =>
                    OP1re <= IN1;
                    OP2re <= IN2;
                    if(Take_reg='0' and Take='1')then
                        read <= '0'; 
                        ect  <= e1;
                    end if;

                when e1 =>
                    OP1  <= OP1re;
                    OP2  <= OP2re;
                    CTRL <= "00001";
                    Read <= '1';
                    ect  <= idle;
              
                when idle =>
                    OP1im <= IN1;
                    OP2im <= IN2;
                    CTRL  <= "00000";
                    if(Take_reg='1' and Take='0')then
                        Read <= '0';
                        ect  <= e2;
                    end if; 
                    
                when e2 =>                    
                    OP1  <= OP1im;
                    OP2  <= OP2im;
                    CTRL <= "00001";
                    ect  <= idle2;
                    
                when idle2 =>
                    CTRL  <= "00000";
                    go_st <= '1';
                    if(Received_reg='0' and Received='1')then
                        if(Conjugate='1')then     
                            ect <= eX;
                        else
                            ect <= e3;
                        end if;
                    end if;

                when e3 =>
                    CTRL  <= "10000";
                    go_st <= '0';
                    ect   <= e4;

                when e4 =>
                    OP1  <= OP1im;
                    OP2  <= OP2re;
                    CTRL <= "00001";                    
                    ect  <= e5;
                
                when e5 =>
                    OP1  <= OP1re;
                    OP2  <= OP2im;
                    CTRL <= "01001";
                    ect  <= idle3;
                
                when idle3 =>
                    CTRL  <= "00000";
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
                            st <= idle2;
                        else
                            st <= idle;
                        end if;
                    end if;

                when idle =>
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
                        st    <= idle2;
                    end if;
                                
                when idle2 =>
                    st <= e0;
                        
                when others =>
                    null;
            end case; 

        end if;
    end process;

end ar_ALU_Driver;