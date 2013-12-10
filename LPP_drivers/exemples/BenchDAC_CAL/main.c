#include <stdio.h>
#include "lpp_apb_functions.h"
#include "apb_dac_Driver.h"
#include "apb_fifo_Driver.h"

int main()
{
    printf("\nDebut Main\n\n");

//        int Tabl [256] = {0x9800,0x1B06,0x1C64,0x1B6A,0x18C8,0x1625,0x1529,0x1685,0x1988,0x1C8A,0x1DE3,0x1CE3,0x1A39,0x178E,0x168A,0x17DC,0x1AD4,0x1DCB,0x1F18,0x1E0B,0x1B53,0x189A,0x1787,0x18CA,0x1BB2,0x1E98,0x1FD4,0x1EB5,0x1BEC,0x1921,0x17FB,0x192B,0x1C00,0x1ED3,0x1FFB,0x1EC9,0x1BEC,0x190D,0x17D4,0x18F0,0x1BB2,0x1E72,0x1F87,0x1E42,0x1B53,0x1862,0x1718,0x1823,0x1AD4,0x1D84,0x1E8A,0x1D36,0x1A39,0x173A,0x15E3,0x16E2,0x1988,0x1C2D,0x1D29,0x1BCD,0x18C8,0x15C2,0x1464,0x155E,0x1800,0x1AA2,0x1B9C,0x1A3E,0x1738,0x1433,0x12D7,0x13D3,0x1678,0x191E,0x1A1D,0x18C6,0x15C7,0x12CA,0x1176,0x127C,0x152C,0x17DD,0x18E8,0x179E,0x14AD,0x11BE,0x1079,0x118E,0x144E,0x1710,0x182C,0x16F3,0x1414,0x1137,0x1005,0x112D,0x1400,0x16D5,0x1805,0x16DF,0x1414,0x114B,0x102C,0x1168,0x144E,0x1736,0x1879,0x1766,0x14AD,0x11F5,0x10E8,0x1235,0x152C,0x1824,0x1976,0x1872,0x15C7,0x131D,0x121D,0x1376,0x1678,0x197B,0x1AD7,0x19DB,0x1738,0x1496,0x139C,0x14FA,0x1800,0x1B06,0x1C64,0x1B6A,0x18C8,0x1625,0x1529,0x1685,0x1988,0x1C8A,0x1DE3,0x1CE3,0x1A39,0x178E,0x168A,0x17DC,0x1AD4,0x1DCB,0x1F18,0x1E0B,0x1B53,0x189A,0x1787,0x18CA,0x1BB2,0x1E98,0x1FD4,0x1EB5,0x1BEC,0x1921,0x17FB,0x192B,0x1C00,0x1ED3,0x1FFB,0x1EC9,0x1BEC,0x190D,0x17D4,0x18F0,0x1BB2,0x1E72,0x1F87,0x1E42,0x1B53,0x1862,0x1718,0x1823,0x1AD4,0x1D84,0x1E8A,0x1D36,0x1A39,0x173A,0x15E3,0x16E2,0x1988,0x1C2D,0x1D29,0x1BCD,0x18C8,0x15C2,0x1464,0x155E,0x1800,0x1AA2,0x1B9C,0x1A3E,0x1738,0x1433,0x12D7,0x13D3,0x1678,0x191E,0x1A1D,0x18C6,0x15C7,0x12CA,0x1176,0x127C,0x152C,0x17DD,0x18E8,0x179E,0x14AD,0x11BE,0x1079,0x118E,0x144E,0x1710,0x182C,0x16F3,0x1414,0x1137,0x1005,0x112D,0x1400,0x16D5,0x1805,0x16DF,0x1414,0x114B,0x102C,0x1168,0x144E,0x1736,0x1879,0x1766,0x14AD,0x11F5,0x10E8,0x1235,0x152C,0x1824,0x1976,0x1872,0x15C7,0x131D,0x121D,0x1376,0x1678,0x197B,0x1AD7,0x19DB,0x1738,0x1496,0x139C,0x14FA};
//(10Khz + 625hz)

    int Tabl [256] = {0x9800,0x1DA8,0x1FFF,0x1DA8,0x1800,0x1258,0x1000,0x1258,0x1800,0x1DA8,0x1FFF,0x1DA8,0x1800,0x1258,0x1000,0x1258,0x1800,0x1DA8,0x1FFF,0x1DA8,0x1800,0x1258,0x1000,0x1258,0x1800,0x1DA8,0x1FFF,0x1DA8,0x1800,0x1258,0x1000,0x1258,0x1800,0x1DA8,0x1FFF,0x1DA8,0x1800,0x1258,0x1000,0x1258,0x1800,0x1DA8,0x1FFF,0x1DA8,0x1800,0x1258,0x1000,0x1258,0x1800,0x1DA8,0x1FFF,0x1DA8,0x1800,0x1258,0x1000,0x1258,0x1800,0x1DA8,0x1FFF,0x1DA8,0x1800,0x1258,0x1000,0x1258,0x1800,0x1DA8,0x1FFF,0x1DA8,0x1800,0x1258,0x1000,0x1258,0x1800,0x1DA8,0x1FFF,0x1DA8,0x1800,0x1258,0x1000,0x1258,0x1800,0x1DA8,0x1FFF,0x1DA8,0x1800,0x1258,0x1000,0x1258,0x1800,0x1DA8,0x1FFF,0x1DA8,0x1800,0x1258,0x1000,0x1258,0x1800,0x1DA8,0x1FFF,0x1DA8,0x1800,0x1258,0x1000,0x1258,0x1800,0x1DA8,0x1FFF,0x1DA8,0x1800,0x1258,0x1000,0x1258,0x1800,0x1DA8,0x1FFF,0x1DA8,0x1800,0x1258,0x1000,0x1258,0x1800,0x1DA8,0x1FFF,0x1DA8,0x1800,0x1258,0x1000,0x1258,0x1800,0x1DA8,0x1FFF,0x1DA8,0x1800,0x1258,0x1000,0x1258,0x1800,0x1DA8,0x1FFF,0x1DA8,0x1800,0x1258,0x1000,0x1258,0x1800,0x1DA8,0x1FFF,0x1DA8,0x1800,0x1258,0x1000,0x1258,0x1800,0x1DA8,0x1FFF,0x1DA8,0x1800,0x1258,0x1000,0x1258,0x1800,0x1DA8,0x1FFF,0x1DA8,0x1800,0x1258,0x1000,0x1258,0x1800,0x1DA8,0x1FFF,0x1DA8,0x1800,0x1258,0x1000,0x1258,0x1800,0x1DA8,0x1FFF,0x1DA8,0x1800,0x1258,0x1000,0x1258,0x1800,0x1DA8,0x1FFF,0x1DA8,0x1800,0x1258,0x1000,0x1258,0x1800,0x1DA8,0x1FFF,0x1DA8,0x1800,0x1258,0x1000,0x1258,0x1800,0x1DA8,0x1FFF,0x1DA8,0x1800,0x1258,0x1000,0x1258,0x1800,0x1DA8,0x1FFF,0x1DA8,0x1800,0x1258,0x1000,0x1258,0x1800,0x1DA8,0x1FFF,0x1DA8,0x1800,0x1258,0x1000,0x1258,0x1800,0x1DA8,0x1FFF,0x1DA8,0x1800,0x1258,0x1000,0x1258,0x1800,0x1DA8,0x1FFF,0x1DA8,0x1800,0x1258,0x1000,0x1258,0x1800,0x1DA8,0x1FFF,0x1DA8,0x1800,0x1258,0x1000,0x1258,0x1800,0x1DA8,0x1FFF,0x1DA8,0x1800,0x1258,0x1000,0x1258};
//(10Khz)

//    int Tabl [256] = {0x9800,0x1864,0x18C9,0x192D,0x1990,0x19F2,0x1A53,0x1AB2,0x1B10,0x1B6C,0x1BC5,0x1C1D,0x1C72,0x1CC4,0x1D13,0x1D5F,0x1DA8,0x1DED,0x1E2F,0x1E6D,0x1EA7,0x1EDD,0x1F0E,0x1F3B,0x1F64,0x1F88,0x1FA8,0x1FC3,0x1FD9,0x1FEA,0x1FF6,0x1FFE,0x1FFF,0x1FFE,0x1FF6,0x1FEA,0x1FD9,0x1FC3,0x1FA8,0x1F88,0x1F64,0x1F3B,0x1F0E,0x1EDD,0x1EA7,0x1E6D,0x1E2F,0x1DED,0x1DA8,0x1D5F,0x1D13,0x1CC4,0x1C72,0x1C1D,0x1BC5,0x1B6C,0x1B10,0x1AB2,0x1A53,0x19F2,0x1990,0x192D,0x18C9,0x1864,0x1800,0x179C,0x1737,0x16D3,0x1670,0x160E,0x15AD,0x154E,0x14F0,0x1494,0x143B,0x13E3,0x138E,0x133C,0x12ED,0x12A1,0x1258,0x1213,0x11D1,0x1193,0x1159,0x1123,0x10F2,0x10C5,0x109C,0x1078,0x1058,0x103D,0x1027,0x1016,0x100A,0x1002,0x1000,0x1002,0x100A,0x1016,0x1027,0x103D,0x1058,0x1078,0x109C,0x10C5,0x10F2,0x1123,0x1159,0x1193,0x11D1,0x1213,0x1258,0x12A1,0x12ED,0x133C,0x138E,0x13E3,0x143B,0x1494,0x14F0,0x154E,0x15AD,0x160E,0x1670,0x16D3,0x1737,0x179C,0x1800,0x1864,0x18C9,0x192D,0x1990,0x19F2,0x1A53,0x1AB2,0x1B10,0x1B6C,0x1BC5,0x1C1D,0x1C72,0x1CC4,0x1D13,0x1D5F,0x1DA8,0x1DED,0x1E2F,0x1E6D,0x1EA7,0x1EDD,0x1F0E,0x1F3B,0x1F64,0x1F88,0x1FA8,0x1FC3,0x1FD9,0x1FEA,0x1FF6,0x1FFE,0x1FFF,0x1FFE,0x1FF6,0x1FEA,0x1FD9,0x1FC3,0x1FA8,0x1F88,0x1F64,0x1F3B,0x1F0E,0x1EDD,0x1EA7,0x1E6D,0x1E2F,0x1DED,0x1DA8,0x1D5F,0x1D13,0x1CC4,0x1C72,0x1C1D,0x1BC5,0x1B6C,0x1B10,0x1AB2,0x1A53,0x19F2,0x1990,0x192D,0x18C9,0x1864,0x1800,0x179C,0x1737,0x16D3,0x1670,0x160E,0x15AD,0x154E,0x14F0,0x1494,0x143B,0x13E3,0x138E,0x133C,0x12ED,0x12A1,0x1258,0x1213,0x11D1,0x1193,0x1159,0x1123,0x10F2,0x10C5,0x109C,0x1078,0x1058,0x103D,0x1027,0x1016,0x100A,0x1002,0x1000,0x1002,0x100A,0x1016,0x1027,0x103D,0x1058,0x1078,0x109C,0x10C5,0x10F2,0x1123,0x1159,0x1193,0x11D1,0x1213,0x1258,0x12A1,0x12ED,0x133C,0x138E,0x13E3,0x143B,0x1494,0x14F0,0x154E,0x15AD,0x160E,0x1670,0x16D3,0x1737,0x179C};
//(625hz)

    DAC_Device* dac0     = openDAC(0);
    FIFO_Device* fifo0   = openFIFO(0);

    dac0->ClkConfigReg = 0;

    FillFifo(fifo0,0,Tabl,256);

    fifo0->FIFOreg[(2*0)+FIFO_Ctrl] = FIFO_ReUse;
//    printf("%x\n",fifo0->FIFOreg[(2*0)+FIFO_Ctrl]);

    dac0->ConfigReg = DAC_enable;

    return 0;
}
