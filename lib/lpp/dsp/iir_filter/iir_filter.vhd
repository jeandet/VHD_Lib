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
--                    Author : Alexis Jeandet
--                     Mail : alexis.jeandet@lpp.polytechnique.fr
----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;
library lpp;




package iir_filter is


--===========================================================|
--================A L U   C O N T R O L======================|
--===========================================================|
constant    IDLE    :   std_logic_vector(3 downto 0) := "0000";
constant    MAC_op  :   std_logic_vector(3 downto 0) := "0001";
constant    MULT    :   std_logic_vector(3 downto 0) := "0010";
constant    ADD     :   std_logic_vector(3 downto 0) := "0011";
constant    clr_mac :   std_logic_vector(3 downto 0) := "0100";

--____
--RAM |
--____|
constant use_RAM    :   integer := 1;
constant use_CEL    :   integer := 0;


--===========================================================|
--=============C O E F S ====================================|
--===========================================================|
--  create a specific type of data for coefs to avoid errors |
--===========================================================|

type    scaleValT   is array(natural range <>) of integer;

type    samplT   is array(natural range <>,natural range <>) of std_logic;

type in_IIR_CEL_reg is record
  config    :   std_logic_vector(31 downto 0);
  virgPos   :   std_logic_vector(4 downto 0);
end record;

type out_IIR_CEL_reg is record
  config    :   std_logic_vector(31 downto 0);
  status    :   std_logic_vector(31 downto 0);
end record;



component APB_IIR_CEL is
   generic (
    tech : integer := 0;
    pindex   : integer  := 0;
    paddr    : integer  := 0;
    pmask    : integer  := 16#fff#;
    pirq     : integer  := 0;
    abits    : integer  := 8;
    Sample_SZ : integer := 16;
    ChanelsCount : integer := 1;
    Coef_SZ      : integer := 9;
    CoefCntPerCel: integer := 6;
    Cels_count   : integer := 5;
    virgPos      : integer := 3;
    Mem_use      : integer := use_RAM
    );
  port (
    rst             : in  std_logic;
    clk             : in  std_logic;
    apbi            : in  apb_slv_in_type;
    apbo            : out apb_slv_out_type;
    sample_clk      : in  std_logic;
    sample_clk_out  : out std_logic;
    sample_in   :   in  samplT(ChanelsCount-1 downto 0,Sample_SZ-1 downto 0);
    sample_out  :   out samplT(ChanelsCount-1 downto 0,Sample_SZ-1 downto 0);
    CoefsInitVal : in std_logic_vector((Cels_count*CoefCntPerCel*Coef_SZ)-1 downto 0) := (others => '1')
    );
end component;


--component FILTER is 
--generic(Smpl_SZ    :  integer := 16;
--        ChanelsCNT :  integer := 3
--);
--port(
--
--    reset       :   in  std_logic;
--    clk         :   in  std_logic;
--    sample_clk  :   in  std_logic;
--    Sample_IN   :   in  std_logic_vector(Smpl_SZ*ChanelsCNT-1 downto 0);
--    Sample_OUT  :   out std_logic_vector(Smpl_SZ*ChanelsCNT-1 downto 0)
--);
--end component;



--component  FilterCTRLR is
--port(
--    reset       :   in  std_logic;
--    clk         :   in  std_logic;
--    sample_clk  :   in  std_logic;
--    ALU_Ctrl    :   out std_logic_vector(3 downto 0);
--    sample_in   :   in  samplT;
--    coef        :   out std_logic_vector(Coef_SZ-1 downto 0);
--    sample      :   out std_logic_vector(Smpl_SZ-1 downto 0)
--);
--end component;


--component  FILTER_RAM_CTRLR is
--port(
--    reset       :   in  std_logic;
--    clk         :   in  std_logic;
--    run         :   in  std_logic;
--    GO_0        :   in  std_logic;
--    B_A         :   in  std_logic;
--    writeForce  :   in  std_logic;
--    next_blk    :   in  std_logic;
--    sample_in   :   in  std_logic_vector(Smpl_SZ-1 downto 0);
--    sample_out  :   out std_logic_vector(Smpl_SZ-1 downto 0)
--);
--end component;


component  IIR_CEL_CTRLR is
generic(
        tech : integer := 0;
        Sample_SZ : integer := 16;
		  ChanelsCount : integer := 1;
		  Coef_SZ      : integer := 9;
		  CoefCntPerCel: integer := 3;
		  Cels_count   : integer := 5;
        Mem_use      : integer := use_RAM
);
port(
    reset       :   in  std_logic;
    clk         :   in  std_logic;
    sample_clk  :   in  std_logic;
    sample_in   :   in  samplT(ChanelsCount-1 downto 0,Sample_SZ-1 downto 0);
    sample_out  :   out samplT(ChanelsCount-1 downto 0,Sample_SZ-1 downto 0);
    virg_pos    :   in  integer;
    coefs       :   in  std_logic_vector(Coef_SZ*CoefCntPerCel*Cels_count-1 downto 0)
);
end component;


component RAM is 
    port( WD : in std_logic_vector(35 downto 0); RD : out 
        std_logic_vector(35 downto 0);WEN, REN : in std_logic; 
        WADDR : in std_logic_vector(7 downto 0); RADDR : in 
        std_logic_vector(7 downto 0);RWCLK, RESET : in std_logic
        ) ;
end component;


component RAM_CEL is 
    port( WD : in std_logic_vector(35 downto 0); RD : out 
        std_logic_vector(35 downto 0);WEN, REN : in std_logic; 
        WADDR : in std_logic_vector(7 downto 0); RADDR : in 
        std_logic_vector(7 downto 0);RWCLK, RESET : in std_logic
        ) ;
end component;

component  IIR_CEL_FILTER is
generic(
        tech : integer := 0;
        Sample_SZ : integer := 16;
		  ChanelsCount : integer := 1;
		  Coef_SZ      : integer := 9;
		  CoefCntPerCel: integer := 3;
		  Cels_count   : integer := 5;
        Mem_use      : integer := use_RAM);
port(
    reset       :   in  std_logic;
    clk         :   in  std_logic;
    sample_clk  :   in  std_logic;
    regs_in     :   in  in_IIR_CEL_reg;
    regs_out    :   in  out_IIR_CEL_reg;
    sample_in   :   in  samplT(ChanelsCount-1 downto 0,Sample_SZ-1 downto 0);
    sample_out  :   out samplT(ChanelsCount-1 downto 0,Sample_SZ-1 downto 0);
	 coefs       :   in  std_logic_vector(Coef_SZ*CoefCntPerCel*Cels_count-1 downto 0)
    
);
end component;


component  RAM_CTRLR2 is
generic(
        tech : integer := 0;
    Input_SZ_1      :   integer := 16;
	 Mem_use         :   integer := use_RAM
);
port(
    reset       :   in  std_logic;
    clk         :   in  std_logic;
    WD_sel      :   in  std_logic;
    Read        :   in  std_logic;
    WADDR_sel   :   in  std_logic;
    count       :   in  std_logic;
    SVG_ADDR    :   in  std_logic;
    Write       :   in  std_logic;
    GO_0        :   in  std_logic;
    sample_in   :   in  std_logic_vector(Input_SZ_1-1 downto 0);
    sample_out  :   out std_logic_vector(Input_SZ_1-1 downto 0)
);
end component;


end;
