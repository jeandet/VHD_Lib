-- APB_FFTexp.vhd
library ieee;
use ieee.std_logic_1164.all;
library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;
library lpp;
use lpp.lpp_amba.all;
use lpp.apb_devices_list.all;
use lpp.lpp_fft.all;

--! Driver APB, va faire le lien entre l'IP VHDL de la FIFO et le bus Amba

entity APB_FFTexp is
  generic (
    pindex   : integer := 0;
    paddr    : integer := 0;
    pmask    : integer := 16#fff#;
    pirq     : integer := 0;
    abits    : integer := 8);
  port (
    clk     : in  std_logic;           --! Horloge du composant
    rst     : in  std_logic;           --! Reset general du composant
    apbi    : in  apb_slv_in_type;     --! Registre de gestion des entrées du bus
    apbo    : out apb_slv_out_type     --! Registre de gestion des sorties du bus
    );
end APB_FFTexp;


architecture ar_APB_FFTexp of APB_FFTexp is

constant REVISION : integer := 1;

constant pconfig : apb_config_type := (
  0 => ahb_device_reg (VENDOR_LPP, LPP_FFT, 0, REVISION, 0),
  1 => apb_iobar(paddr, pmask));

type FFT_ctrlr_Reg is record
     FFT_Cfg  : std_logic_vector(1 downto 0); 
     FFT_Reel : std_logic_vector(15 downto 0);
     FFT_Img  : std_logic_vector(15 downto 0);
end record;

signal Rec    : FFT_ctrlr_Reg;
signal Rdata  : std_logic_vector(31 downto 0);

signal y_valid : std_logic;
signal y_rdy : std_logic;
begin


Rec.FFT_Cfg(0) <= y_rdy;
Rec.FFT_Cfg(1) <= y_valid;

    CONVERTER : entity work.topFFTbis
        port map (clk,raz,y_valid,y_rdy,Rec.FFT_Reel,Rec.FFT_Img); 


    process(rst,clk)
    begin
--        if(rst='0')then
                        
       if(clk'event and clk='1')then        

    --APB Write OP
--            if (apbi.psel(pindex) and apbi.penable and apbi.pwrite) = '1' then
--                case apbi.paddr(abits-1 downto 2) is
--                    when "000001" =>
--                        Rec.FFT_Data <= apbi.pwdata(15 downto 0);
--                    when others =>
--                        null;
--                end case;
--            end if;

    --APB Read OP
            if (apbi.psel(pindex) and (not apbi.pwrite)) = '1' then
                case apbi.paddr(abits-1 downto 2) is
                    when "000000" =>
                        Rdata(3 downto 0)   <= "000" & Rec.FFT_Cfg(0);
                        Rdata(7 downto 4)   <= "000" & Rec.FFT_Cfg(1);                        
                        Rdata(31 downto 8) <= X"CCCCCC";
                    when "000001" =>
                        Rdata(31 downto 16) <= X"FFFF";
                        Rdata(15 downto 0)  <= Rec.FFT_Data;
                    when "000010" =>
                        Rdata(31 downto 16) <= X"FFFF";
                        Rdata(15 downto 0)  <= Rec.FFT_Reel;
                    when "000011" =>
                        Rdata(31 downto 16) <= X"FFFF";
                        Rdata(15 downto 0)  <= Rec.FFT_Img;                     
                    when others =>
                        Rdata <= (others => '0');
                end case;
            end if;

        end if;
        apbo.pconfig <= pconfig;
    end process;

apbo.prdata     <=   Rdata when apbi.penable = '1';

end ar_APB_FFTexp;