#include <stdio.h>
#include "lpp_apb_functions.h"
#include "apb_delay_Driver.h"
#include "apb_gpio_Driver.h"




int main()
{
    GPIO_Device* gpio0 = openGPIO(0);
    DELAY_Device* delay0 = openDELAY(0);

    printf("\nDebut Main\n\n");

    gpio0->oen = 0x3;
    gpio0->Dout = 0x0;

    delay0->Cfg = 0x01;
    Setup(delay0,30000000);

    while(1){
        gpio0->Dout = 0x2;
        Delay_ms(delay0,100);
        gpio0->Dout = 0x1;
        Delay_ms(delay0,100);

    }

    return 0;
}
