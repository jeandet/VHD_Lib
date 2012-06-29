#include <stdio.h>
#include "lpp_apb_functions.h"
#include "apb_uart_Driver.h"


int main()
{
    printf("Debut Main\n\n");
    UART_Device* dev = openUART(0);
    while(1){
        uartputc(dev,uartgetc(dev));
    }
    return 0;
}
