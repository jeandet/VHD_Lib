-- Version: 9.0 9.0.0.15

library ieee;
use ieee.std_logic_1164.all;
library proasic3e;
use proasic3e.all;

entity actram is 
    port( DI : in std_logic_vector(31 downto 0); DO : out 
        std_logic_vector(31 downto 0);WRB, RDB : in std_logic; 
        WADDR : in std_logic_vector(6 downto 0); RADDR : in 
        std_logic_vector(6 downto 0);WCLOCK, RCLOCK : in 
        std_logic) ;
end actram;


architecture DEF_ARCH of  actram is

    component RAM512X18
    generic (MEMORYFILE:string := "");

        port(RADDR8, RADDR7, RADDR6, RADDR5, RADDR4, RADDR3, 
        RADDR2, RADDR1, RADDR0, WADDR8, WADDR7, WADDR6, WADDR5, 
        WADDR4, WADDR3, WADDR2, WADDR1, WADDR0, WD17, WD16, WD15, 
        WD14, WD13, WD12, WD11, WD10, WD9, WD8, WD7, WD6, WD5, 
        WD4, WD3, WD2, WD1, WD0, RW0, RW1, WW0, WW1, PIPE, REN, 
        WEN, RCLK, WCLK, RESET : in std_logic := 'U'; RD17, RD16, 
        RD15, RD14, RD13, RD12, RD11, RD10, RD9, RD8, RD7, RD6, 
        RD5, RD4, RD3, RD2, RD1, RD0 : out std_logic) ;
    end component;

    component VCC
        port( Y : out std_logic);
    end component;

    component GND
        port( Y : out std_logic);
    end component;

    signal VCC_1_net, GND_1_net : std_logic ;
    begin   

    VCC_2_net : VCC port map(Y => VCC_1_net);
    GND_2_net : GND port map(Y => GND_1_net);
    actram_R0C1 : RAM512X18
      port map(RADDR8 => GND_1_net, RADDR7 => GND_1_net, 
        RADDR6 => RADDR(6), RADDR5 => RADDR(5), RADDR4 => 
        RADDR(4), RADDR3 => RADDR(3), RADDR2 => RADDR(2), 
        RADDR1 => RADDR(1), RADDR0 => RADDR(0), WADDR8 => 
        GND_1_net, WADDR7 => GND_1_net, WADDR6 => WADDR(6), 
        WADDR5 => WADDR(5), WADDR4 => WADDR(4), WADDR3 => 
        WADDR(3), WADDR2 => WADDR(2), WADDR1 => WADDR(1), 
        WADDR0 => WADDR(0), WD17 => GND_1_net, WD16 => GND_1_net, 
        WD15 => DI(31), WD14 => DI(30), WD13 => DI(29), WD12 => 
        DI(28), WD11 => DI(27), WD10 => DI(26), WD9 => DI(25), 
        WD8 => DI(24), WD7 => DI(23), WD6 => DI(22), WD5 => 
        DI(21), WD4 => DI(20), WD3 => DI(19), WD2 => DI(18), 
        WD1 => DI(17), WD0 => DI(16), RW0 => GND_1_net, RW1 => 
        VCC_1_net, WW0 => GND_1_net, WW1 => VCC_1_net, PIPE => 
        VCC_1_net, REN => RDB, WEN => WRB, RCLK => RCLOCK, 
        WCLK => WCLOCK, RESET => VCC_1_net, RD17 => OPEN , 
        RD16 => OPEN , RD15 => DO(31), RD14 => DO(30), RD13 => 
        DO(29), RD12 => DO(28), RD11 => DO(27), RD10 => DO(26), 
        RD9 => DO(25), RD8 => DO(24), RD7 => DO(23), RD6 => 
        DO(22), RD5 => DO(21), RD4 => DO(20), RD3 => DO(19), 
        RD2 => DO(18), RD1 => DO(17), RD0 => DO(16));
    actram_R0C0 : RAM512X18
      port map(RADDR8 => GND_1_net, RADDR7 => GND_1_net, 
        RADDR6 => RADDR(6), RADDR5 => RADDR(5), RADDR4 => 
        RADDR(4), RADDR3 => RADDR(3), RADDR2 => RADDR(2), 
        RADDR1 => RADDR(1), RADDR0 => RADDR(0), WADDR8 => 
        GND_1_net, WADDR7 => GND_1_net, WADDR6 => WADDR(6), 
        WADDR5 => WADDR(5), WADDR4 => WADDR(4), WADDR3 => 
        WADDR(3), WADDR2 => WADDR(2), WADDR1 => WADDR(1), 
        WADDR0 => WADDR(0), WD17 => GND_1_net, WD16 => GND_1_net, 
        WD15 => DI(15), WD14 => DI(14), WD13 => DI(13), WD12 => 
        DI(12), WD11 => DI(11), WD10 => DI(10), WD9 => DI(9), 
        WD8 => DI(8), WD7 => DI(7), WD6 => DI(6), WD5 => DI(5), 
        WD4 => DI(4), WD3 => DI(3), WD2 => DI(2), WD1 => DI(1), 
        WD0 => DI(0), RW0 => GND_1_net, RW1 => VCC_1_net, WW0 => 
        GND_1_net, WW1 => VCC_1_net, PIPE => VCC_1_net, REN => 
        RDB, WEN => WRB, RCLK => RCLOCK, WCLK => WCLOCK, RESET => 
        VCC_1_net, RD17 => OPEN , RD16 => OPEN , RD15 => DO(15), 
        RD14 => DO(14), RD13 => DO(13), RD12 => DO(12), RD11 => 
        DO(11), RD10 => DO(10), RD9 => DO(9), RD8 => DO(8), 
        RD7 => DO(7), RD6 => DO(6), RD5 => DO(5), RD4 => DO(4), 
        RD3 => DO(3), RD2 => DO(2), RD1 => DO(1), RD0 => DO(0));
end DEF_ARCH;
