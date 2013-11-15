#include <stdio.h>
#include "lpp_apb_functions.h"
#include "apb_dac_Driver.h"

int main()
{
    printf("\nDebut Main\n\n");
    int i;
    int tablo CAL_SignalData

    DAC_Device* dac0     = openDAC(0);

    printf("\nSTART\n\n");

    while(1)
    {
        for (i = 0 ; i < 251 ; i++)
        {
            while(!((dac0->ConfigReg & DAC_ready) == DAC_ready));
            dac0->DataReg = tablo[i];
            while((dac0->ConfigReg & DAC_ready) == DAC_ready);
        }
    }
    return 0;
}
