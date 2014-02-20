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
--                    Author : Martin Morlot
--                     Mail : martin.morlot@lpp.polytechnique.fr
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library grlib;
use grlib.amba.all;
use std.textio.all;
library lpp;
use lpp.lpp_amba.all;

--! Package contenant tous les programmes qui forment le composant intégré dans le léon 

package lpp_matrix is

component APB_Matrix is
  generic (
    pindex   : integer := 0;
    paddr    : integer := 0;
    pmask    : integer := 16#fff#;
    pirq     : integer := 0;
    abits    : integer := 8;
    Input_SZ : integer := 16;
    Result_SZ : integer := 32);
  port (
    clk       : in std_logic;
    rst     : in std_logic;
    FIFO1     : in std_logic_vector(Input_SZ-1 downto 0);
    FIFO2     : in std_logic_vector(Input_SZ-1 downto 0);
    Full      : in std_logic_vector(1 downto 0);
    Empty     : in std_logic_vector(1 downto 0);
    ReadFIFO  : out std_logic_vector(1 downto 0);
    FullFIFO  : in std_logic;
    WriteFIFO : out std_logic;
    Result    : out std_logic_vector(Result_SZ-1 downto 0);
    apbi    : in  apb_slv_in_type;     --! Registre de gestion des entrées du bus
    apbo    : out apb_slv_out_type     --! Registre de gestion des sorties du bus
);
end component;

component MatriceSpectrale is
  generic(
      Input_SZ  : integer := 16;
      Result_SZ : integer := 32);
    port(
        clkm            : in std_logic;
        rstn            : in std_logic;

        FifoIN_Full     : in std_logic_vector(4 downto 0);
        SetReUse        : in std_logic_vector(4 downto 0);
        Valid           : in std_logic;
        Data_IN         : in std_logic_vector((5*Input_SZ)-1 downto 0);
        ACK             : in std_logic;
        SM_Write        : out std_logic;
        FlagError       : out std_logic;
        Statu           : out std_logic_vector(3 downto 0);
        Write           : out std_logic_vector(1 downto 0);
        Read            : out std_logic_vector(4 downto 0);
        ReUse           : out std_logic_vector(4 downto 0);
        Data_OUT        : out std_logic_vector((2*Result_SZ)-1 downto 0)
        );
end component;


component TopSpecMatrix is
generic(
    Input_SZ  : integer := 16);
port(
    clk         : in std_logic;
    rstn       : in std_logic;
    Write       : in std_logic;
    ReadIn      : in std_logic_vector(1 downto 0);
    Full        : in std_logic_vector(4 downto 0);
    Data        : in std_logic_vector((5*Input_SZ)-1 downto 0);
    Start       : out std_logic;
    ReadOut     : out std_logic_vector(4 downto 0);
    Statu       : out std_logic_vector(3 downto 0); 
    DATA1       : out std_logic_vector(Input_SZ-1 downto 0);
    DATA2       : out std_logic_vector(Input_SZ-1 downto 0)
);
end component;


component Top_MatrixSpec is
generic(
    Input_SZ  : integer := 16;
    Result_SZ : integer := 32);
port(
    clk       : in std_logic;
    reset     : in std_logic;
    Statu     : in std_logic_vector(3 downto 0);
    FIFO1     : in std_logic_vector(Input_SZ-1 downto 0);
    FIFO2     : in std_logic_vector(Input_SZ-1 downto 0);
    Full      : in std_logic_vector(1 downto 0);
    Empty     : in std_logic_vector(1 downto 0);
    ReadFIFO  : out std_logic_vector(1 downto 0);
    FullFIFO  : in std_logic;
    WriteFIFO : out std_logic;
    Result    : out std_logic_vector(Result_SZ-1 downto 0)
);
end component;

component SpectralMatrix is
generic(
    Input_SZ  : integer := 16;
    Result_SZ : integer := 32);
port(
    clk        : in std_logic;
    reset      : in std_logic;
    Start      : in std_logic;
    FIFO1      : in std_logic_vector(Input_SZ-1 downto 0);
    FIFO2      : in std_logic_vector(Input_SZ-1 downto 0);
    Statu      : in std_logic_vector(3 downto 0);
--    FullFIFO   : in std_logic;
    ReadFIFO   : out std_logic_vector(1 downto 0);
    WriteFIFO  : out std_logic;
    Result     : out std_logic_vector(Result_SZ-1 downto 0)
);
end component;


component Matrix is
  generic(
      Input_SZ : integer := 16);
  port(
      clk        : in std_logic;
      raz        : in std_logic;
      IN1        : in std_logic_vector(Input_SZ-1 downto 0);
      IN2        : in std_logic_vector(Input_SZ-1 downto 0);
      Take       : in std_logic;
      Received   : in std_logic;
      Conjugate  : in std_logic;
      Valid      : out std_logic;
      Read       : out std_logic;
      Result     : out std_logic_vector(2*Input_SZ-1 downto 0)
);
end component;

component GetResult is
generic(
    Result_SZ : integer := 32);
port(
    clk       : in  std_logic;
    raz       : in  std_logic;
    Valid     : in  std_logic;
    Conjugate : in  std_logic;
    Res       : in std_logic_vector(Result_SZ-1 downto 0);
--    Full      : in std_logic;
    WriteFIFO : out std_logic;
    Received  : out std_logic;
    Result    : out std_logic_vector(Result_SZ-1 downto 0)
);
end component;


component TopMatrix_PDR is
generic(
    Input_SZ  : integer := 16;
    Result_SZ : integer := 32);
port(
    clk         : in std_logic;
    reset       : in std_logic;
    Data        : in std_logic_vector((5*Input_SZ)-1 downto 0);
    FULLin      : in std_logic_vector(4 downto 0);
    READin      : in std_logic_vector(1 downto 0);
    WRITEin     : in std_logic;
    FIFO1       : out std_logic_vector(Input_SZ-1 downto 0);
    FIFO2       : out std_logic_vector(Input_SZ-1 downto 0);    
    Start       : out std_logic;
    Read        : out std_logic_vector(4 downto 0);
    Statu       : out std_logic_vector(3 downto 0)  
);
end component;


component Dispatch is
generic(
    Data_SZ  : integer := 32);
port(
    clk         : in std_logic;
    reset       : in std_logic;
    Ack         : in std_logic;
    Data        : in std_logic_vector(Data_SZ-1 downto 0);
    Write       : in std_logic;
    Valid       : in std_logic;
    FifoData    : out std_logic_vector(2*Data_SZ-1 downto 0);
    FifoWrite   : out std_logic_vector(1 downto 0);
    Error       : out std_logic
);
end component;


component DriveInputs is
port(
    clk     : in  std_logic;
    raz     : in  std_logic;
    Read    : in  std_logic;
    Conjugate : in std_logic;
    Take    : out std_logic;
    ReadFIFO : out std_logic_vector(1 downto 0)
);
end component;

component Starter is
port(
    clk     : in  std_logic;
    raz     : in  std_logic;
    Full    : in  std_logic_vector(1 downto 0);
    Empty   : in  std_logic_vector(1 downto 0);
    Statu   : in std_logic_vector(3 downto 0);
    Write   : in std_logic;
    Start   : out std_logic
);
end component;

component ALU_Driver is
  generic(
      Input_SZ_1      :   integer := 16;
      Input_SZ_2      :   integer := 16);
  port(
      clk       :   in std_logic;
      reset     :   in std_logic;
      IN1       :   in std_logic_vector(Input_SZ_1-1 downto 0);
      IN2       :   in std_logic_vector(Input_SZ_2-1 downto 0);
      Take      :   in std_logic;
      Received  :   in std_logic;
      Conjugate :   in std_logic;
      Valid     :   out std_logic;
      Read      :   out std_logic;
      CTRL      :   out std_logic_vector(2 downto 0);
      COMP      :   out  std_logic_vector(1 downto 0);
      OP1       :   out std_logic_vector(Input_SZ_1-1 downto 0);
      OP2       :   out std_logic_vector(Input_SZ_2-1 downto 0)
);
end component;

component ReUse_CTRLR is
    port(
        clk         : in std_logic;
        reset       : in std_logic;
        SetReUse    : in std_logic_vector(4 downto 0);
        Statu       : in std_logic_vector(3 downto 0);
        ReUse       : out std_logic_vector(4 downto 0)
    );
end component;

end;