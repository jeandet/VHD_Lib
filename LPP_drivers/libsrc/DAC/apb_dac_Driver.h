#ifndef APB_CNA_DRIVER_H
#define APB_CNA_DRIVER_H

#define DAC_ready 3
#define DAC_enable 1
#define DAC_disable 0


/*===================================================
        T Y P E S     D E F
====================================================*/

struct DAC_Driver
{
    int configReg;
    int dataReg;
};

typedef struct DAC_Driver DAC_Device;

/*===================================================
        F U N C T I O N S
====================================================*/

DAC_Device* DacOpen(int count);

//DAC_Device* DacClose(int count);

int DacTable();

int DacConst();



#endif
