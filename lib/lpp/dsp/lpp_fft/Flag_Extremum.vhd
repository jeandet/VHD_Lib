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
------------------------------------------------------------------------------
--                        Author : Martin Morlot
--                     Mail : martin.morlot@lpp.polytechnique.fr
------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library lpp;
use lpp.FFT_config.all;

--! Programme qui va permettre de générer des flags utilisés au niveau du driver C

entity Flag_Extremum is
  port(
    clk,raz    : in std_logic;    --! Horloge et Reset général du composant
    load       : in std_logic;    --! Signal en provenance de CoreFFT
    y_rdy      : in std_logic;    --! Signal en provenance de CoreFFT
    fill       : out std_logic;   --! Flag, Va permettre d'autoriser l'écriture (Driver C)
    ready      : out std_logic    --! Flag, Va permettre d'autoriser la lecture (Driver C)
    );
end Flag_Extremum;

--! @details Flags générés a partir de signaux fourni par l'IP FFT d'actel

architecture ar_Flag_Extremum of Flag_Extremum is

begin
    process (clk,raz)
    begin
        if(raz='0')then
            fill  <= '0';
            ready <= '0';

        elsif(clk' event and clk='1')then

            if(load='1' and y_rdy='0')then
                fill  <= '1';
                ready <= '0';
            
            elsif(y_rdy='1')then
                fill  <= '0';
                ready <= '1';

            else
                fill  <= '0';
                ready <= '0';

            end if;
        end if;
    end process;

end ar_Flag_Extremum;

                


