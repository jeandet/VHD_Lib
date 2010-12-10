-- APB_CNA.vhd

library ieee;
use ieee.std_logic_1164.all;
library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;
library lpp;
use lpp.lpp_amba.all;
use lpp.apb_devices_list.all;
use lpp.lpp_cna.all;


entity APB_CNA is
  generic (
    pindex   : integer := 0;
    paddr    : integer := 0;
    pmask    : integer := 16#fff#;
    pirq     : integer := 0;
    abits    : integer := 8);
  port (
    clk     : in  std_logic;
    rst     : in  std_logic;
    apbi    : in  apb_slv_in_type;
    apbo    : out apb_slv_out_type;
    SYNC    : out std_logic;
    SCLK    : out std_logic;
    DATA    : out std_logic
    );
end APB_CNA;


architecture ar_APB_CNA of APB_CNA is

constant REVISION : integer := 1;

constant pconfig : apb_config_type := (
  0 => ahb_device_reg (VENDOR_LPP, LPP_CNA, 0, REVISION, 0),
  1 => apb_iobar(paddr, pmask));

signal enable   : std_logic;
signal flag_sd : std_logic;

type CNA_ctrlr_Reg is record
     CNA_Cfg  : std_logic_vector(1 downto 0);
     CNA_Data : std_logic_vector(15 downto 0);
end record;

signal Rec : CNA_ctrlr_Reg;
signal Rdata     : std_logic_vector(31 downto 0);

begin

enable <= Rec.CNA_Cfg(0);
Rec.CNA_Cfg(1) <= flag_sd;

    CONVERTER : entity Work.CNA_TabloC
        port map(clk,rst,enable,Rec.CNA_Data,SYNC,SCLK,flag_sd,Data);


    process(rst,clk)
    begin
        if(rst='0')then
            Rec.CNA_Data <=  (others => '0');

        elsif(clk'event and clk='1')then 
        

    --APB Write OP
            if (apbi.psel(pindex) and apbi.penable and apbi.pwrite) = '1' then
                case apbi.paddr(abits-1 downto 2) is
                    when "000000" =>
                        Rec.CNA_Cfg(0) <= apbi.pwdata(0);
                    when "000001" =>
                        Rec.CNA_Data <= apbi.pwdata(15 downto 0);
                    when others =>
                        null;
                end case;
            end if;

    --APB READ OP
            if (apbi.psel(pindex) and (not apbi.pwrite)) = '1' then
                case apbi.paddr(abits-1 downto 2) is
                    when "000000" =>
                        Rdata(31 downto 2) <= X"ABCDEF5" & "00";
                        Rdata(1 downto 0) <= Rec.CNA_Cfg;
                    when "000001" =>
                        Rdata(31 downto 16) <= X"FD18";
                        Rdata(15 downto 0) <= Rec.CNA_Data;
                    when others =>
                        Rdata <= (others => '0');
                end case;
            end if;

        end if;
        apbo.pconfig <= pconfig;
    end process;

apbo.prdata     <=   Rdata when apbi.penable = '1';
end ar_APB_CNA;
