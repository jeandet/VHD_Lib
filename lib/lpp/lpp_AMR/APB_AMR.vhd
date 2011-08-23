library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;
library lpp;
use lpp.lpp_amba.all;
use lpp.apb_devices_list.all;
use lpp.lpp_AMR.all;

--! Driver APB, va faire le lien entre l'IP VHDL du convertisseur et le bus Amba

entity APB_AMR is
  generic (
    pindex   : integer := 0;
    paddr    : integer := 0;
    pmask    : integer := 16#fff#;
    pirq     : integer := 0;
    abits    : integer := 8);
  port (
    clk     : in  std_logic;           --! Horloge du composant
    rst     : in  std_logic;           --! Reset general du composant
    clkH    : in  std_logic;
    clk_MOD     : out std_logic;                        --! Horloge de sortie, Modulation
    clk_DMOD    : out std_logic;                       --! Horloge de sortie, Demodulation
    apbi    : in  apb_slv_in_type;     --! Registre de gestion des entrées du bus
    apbo    : out apb_slv_out_type     --! Registre de gestion des sorties du bus
);
end APB_AMR;


architecture ar_APB_AMR of APB_AMR is

constant REVISION : integer := 1;

constant pconfig : apb_config_type := (
  0 => ahb_device_reg (VENDOR_LPP, LPP_BALISE, 0, REVISION, 0),
  1 => apb_iobar(paddr, pmask));

type AMR_ctrlr_Reg is record
     AMR_CTRL : std_logic_vector(31 downto 0);
     AMR_FREQ : std_logic_vector(31 downto 0);
     AMR_PHI : std_logic_vector(31 downto 0);

end record;

signal Rec : AMR_ctrlr_Reg := ((others => '0'),std_logic_vector(to_unsigned(149,32)),std_logic_vector(to_unsigned(4,32)));
signal Rdata : std_logic_vector(31 downto 0);
signal Div : integer range 250 to 1024*1024;
signal Phi : integer range 4 to 1024*8;
signal Stop_count : std_logic;


begin

    DEF0 : entity work.Dephaseur
        port map(clk,rst,Div,Phi,Stop_count,clk_MOD,clk_DMOD);
 

Div <= to_integer(unsigned(Rec.AMR_FREQ(19 downto 0)));
Phi <= to_integer(unsigned(Rec.AMR_PHI(12 downto 0)));
Stop_count <= Rec.AMR_CTRL(0);


    process(rst,clk)
    begin
        if(rst='0')then
            Rec.AMR_CTRL <= (others => '0');     
            Rec.AMR_FREQ <= std_logic_vector(to_unsigned(149,32));
            Rec.AMR_PHI <= std_logic_vector(to_unsigned(4,32));

        elsif(clk'event and clk='1')then 

    --APB Write OP
            if (apbi.psel(pindex) and apbi.penable and apbi.pwrite) = '1' then
                case apbi.paddr(abits-1 downto 2) is
                    when "000000" =>                         
                         Rec.AMR_CTRL <= apbi.pwdata;
                    when "000001" =>
                         Rec.AMR_FREQ <= apbi.pwdata;
                    when "000010" =>
                         Rec.AMR_PHI <= apbi.pwdata;
                    when others =>
                        null;
                end case;
            end if;

    --APB READ OP
            if (apbi.psel(pindex) and (not apbi.pwrite)) = '1' then
                case apbi.paddr(abits-1 downto 2) is
                    when "000000" =>
                         Rdata <= Rec.AMR_CTRL;
                     when "000001" =>
                         Rdata <= Rec.AMR_FREQ;
                    when "000010" =>
                         Rdata <= Rec.AMR_PHI;
                    when others =>
                        Rdata <= (others => '0');
                end case;
            end if;

        end if;
        apbo.pconfig <= pconfig;
    end process;

apbo.prdata     <=   Rdata when apbi.penable = '1';

end ar_APB_AMR;