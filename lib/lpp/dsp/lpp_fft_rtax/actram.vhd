-- Version: 9.1 SP5 9.1.5.1

library ieee;
use ieee.std_logic_1164.all;
library Axcelerator;
use Axcelerator.all;

entity actram is 
    port( DI : in std_logic_vector(31 downto 0); DO : out 
        std_logic_vector(31 downto 0); WADDR : in 
        std_logic_vector(6 downto 0); RADDR : in 
        std_logic_vector(6 downto 0);WRB, RDB, WCLOCK, RCLOCK : 
        in std_logic) ;
end actram;


architecture DEF_ARCH of  actram is

    component INV
        port(A : in std_logic := 'U'; Y : out std_logic) ;
    end component;

    component RAM64K36P
    generic (MEMORYFILE:string := "");

        port(WCLK, RCLK, DEPTH0, DEPTH1, DEPTH2, DEPTH3, WEN, WW0, 
        WW1, WW2, WRAD0, WRAD1, WRAD2, WRAD3, WRAD4, WRAD5, WRAD6, 
        WRAD7, WRAD8, WRAD9, WRAD10, WRAD11, WRAD12, WRAD13, 
        WRAD14, WRAD15, WD0, WD1, WD2, WD3, WD4, WD5, WD6, WD7, 
        WD8, WD9, WD10, WD11, WD12, WD13, WD14, WD15, WD16, WD17, 
        WD18, WD19, WD20, WD21, WD22, WD23, WD24, WD25, WD26, 
        WD27, WD28, WD29, WD30, WD31, WD32, WD33, WD34, WD35, REN, 
        RW0, RW1, RW2, RDAD0, RDAD1, RDAD2, RDAD3, RDAD4, RDAD5, 
        RDAD6, RDAD7, RDAD8, RDAD9, RDAD10, RDAD11, RDAD12, 
        RDAD13, RDAD14, RDAD15 : in std_logic := 'U'; RD0, RD1, 
        RD2, RD3, RD4, RD5, RD6, RD7, RD8, RD9, RD10, RD11, RD12, 
        RD13, RD14, RD15, RD16, RD17, RD18, RD19, RD20, RD21, 
        RD22, RD23, RD24, RD25, RD26, RD27, RD28, RD29, RD30, 
        RD31, RD32, RD33, RD34, RD35 : out std_logic) ;
    end component;

    component VCC
        port( Y : out std_logic);
    end component;

    component GND
        port( Y : out std_logic);
    end component;

    signal WEP, REP, VCC_1_net, GND_1_net : std_logic ;
    begin   

    VCC_2_net : VCC port map(Y => VCC_1_net);
    GND_2_net : GND port map(Y => GND_1_net);
    REBUBBLE : INV
      port map(A => RDB, Y => REP);
    WEBUBBLE : INV
      port map(A => WRB, Y => WEP);
    actram_R0C0 : RAM64K36P
      port map(WCLK => WCLOCK, RCLK => RCLOCK, DEPTH0 => 
        GND_1_net, DEPTH1 => GND_1_net, DEPTH2 => GND_1_net, 
        DEPTH3 => GND_1_net, WEN => WEP, WW0 => VCC_1_net, WW1 => 
        GND_1_net, WW2 => VCC_1_net, WRAD0 => WADDR(0), WRAD1 => 
        WADDR(1), WRAD2 => WADDR(2), WRAD3 => WADDR(3), WRAD4 => 
        WADDR(4), WRAD5 => WADDR(5), WRAD6 => WADDR(6), WRAD7 => 
        GND_1_net, WRAD8 => GND_1_net, WRAD9 => GND_1_net, 
        WRAD10 => GND_1_net, WRAD11 => GND_1_net, WRAD12 => 
        GND_1_net, WRAD13 => GND_1_net, WRAD14 => GND_1_net, 
        WRAD15 => GND_1_net, WD0 => DI(0), WD1 => DI(1), WD2 => 
        DI(2), WD3 => DI(3), WD4 => DI(4), WD5 => DI(5), WD6 => 
        DI(6), WD7 => DI(7), WD8 => DI(8), WD9 => DI(9), WD10 => 
        DI(10), WD11 => DI(11), WD12 => DI(12), WD13 => DI(13), 
        WD14 => DI(14), WD15 => DI(15), WD16 => DI(16), WD17 => 
        DI(17), WD18 => DI(18), WD19 => DI(19), WD20 => DI(20), 
        WD21 => DI(21), WD22 => DI(22), WD23 => DI(23), WD24 => 
        DI(24), WD25 => DI(25), WD26 => DI(26), WD27 => DI(27), 
        WD28 => DI(28), WD29 => DI(29), WD30 => DI(30), WD31 => 
        DI(31), WD32 => GND_1_net, WD33 => GND_1_net, WD34 => 
        GND_1_net, WD35 => GND_1_net, REN => REP, RW0 => 
        VCC_1_net, RW1 => GND_1_net, RW2 => VCC_1_net, RDAD0 => 
        RADDR(0), RDAD1 => RADDR(1), RDAD2 => RADDR(2), RDAD3 => 
        RADDR(3), RDAD4 => RADDR(4), RDAD5 => RADDR(5), RDAD6 => 
        RADDR(6), RDAD7 => GND_1_net, RDAD8 => GND_1_net, 
        RDAD9 => GND_1_net, RDAD10 => GND_1_net, RDAD11 => 
        GND_1_net, RDAD12 => GND_1_net, RDAD13 => GND_1_net, 
        RDAD14 => GND_1_net, RDAD15 => GND_1_net, RD0 => DO(0), 
        RD1 => DO(1), RD2 => DO(2), RD3 => DO(3), RD4 => DO(4), 
        RD5 => DO(5), RD6 => DO(6), RD7 => DO(7), RD8 => DO(8), 
        RD9 => DO(9), RD10 => DO(10), RD11 => DO(11), RD12 => 
        DO(12), RD13 => DO(13), RD14 => DO(14), RD15 => DO(15), 
        RD16 => DO(16), RD17 => DO(17), RD18 => DO(18), RD19 => 
        DO(19), RD20 => DO(20), RD21 => DO(21), RD22 => DO(22), 
        RD23 => DO(23), RD24 => DO(24), RD25 => DO(25), RD26 => 
        DO(26), RD27 => DO(27), RD28 => DO(28), RD29 => DO(29), 
        RD30 => DO(30), RD31 => DO(31), RD32 => OPEN , RD33 => 
        OPEN , RD34 => OPEN , RD35 => OPEN );
end DEF_ARCH;
