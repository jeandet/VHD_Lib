#include <stdio.h>
#include "lpp_apb_functions.h"
#include "apb_uart_Driver.h"


int main()
{
    printf("Debut Main\n\n");
    UART_Device* dev = openUART(0);
    printf("addr: %x\n",(unsigned int)dev);
    printf("cfg: %x\n",dev->ConfigReg);
    char* a = "hello world\n";
    uartputs(dev,a);
    printf("Try #1 done\n");
    uartputs(dev,"salut monde\n");
    printf("Try #2 done\n");
    return 0;
}

