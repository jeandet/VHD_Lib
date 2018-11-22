----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.03.2018 16:20:36
-- Design Name: 
-- Module Name: AD747XA_pkg - 
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package AD747X is

  SUBTYPE ad747X_sample IS std_logic_vector( 15 downto 0 );
  TYPE ad747X_sample_v IS ARRAY (natural range<>) OF ad747X_sample;
    
end package;
