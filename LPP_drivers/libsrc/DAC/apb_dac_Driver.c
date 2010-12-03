#include "apb_dac_Driver.h"
#include "lpp_apb_functions.h"
#include <stdio.h>


DAC_Device* DacOpen(int count)
{
    DAC_Device* dac0;
    dac0 = (DAC_Device*) apbgetdevice(LPP_DAC_CTRLR,VENDOR_LPP,count);
    dac0->configReg = DAC_enable;
    return dac0;
}

/*
DAC_Device* DacClose(int count)
{
    DAC_Device* dac1;
    dac1 = (DAC_Device*) apbgetdevice(LPP_DAC_CTRLR,VENDOR_LPP,count);
    dac1->configReg = DAC_disable;
    return dac1;
}
*/


int DacTable()
{
    int i;
    DAC_Device* dac2;
    int tablo[251] = {0x9555,0x1800,0x19AA,0x1B15,0x1C0A,0x1C66,0x1C1F,0x1B44,0x19FC,0x187F,0x170F,0x15EA,0x1542,0x1537,0x15CE,0x16F2,0x187A,0x1A2B,0x1BC2,0x1D04,0x1DBF,0x1DDB,0x1D56,0x1C49,0x1AE3,0x195F,0x1800,0x1700,0x168D,0x16BA,0x1785,0x18D0,0x1A69,0x1C12,0x1D8A,0x1E98,0x1F13,
    0x1EEB,0x1E28,0x1CEC,0x1FFF,0x19E8,0x189F,0x17C8,0x1788,0x17EA,0x18E2,0x1A48,0x1BE7,0x1D7C,0x1ECA,0x1F9C,0x1FD2,0x1F64,0x1E66,0x1D00,0x1B6E,0x19EF,0x18C1,0x1817,0x180A,0x189D,0x19BA,0x1B33,0x1CCC,0x1E44,0x1F5F,0x1FEE,0x1FDC,0x1F2B,0x1DF6,0x1C6E,0x1AD1,0x1960,0x1855,0x17D9,0x1800,
    0x18C1,0x19FD,0x1B80,0x1D0A,0x1E5C,0x1F3D,0x1F87,0x1F2E,0x1E3E,0x1CDA,0x1B39,0x199C,0x1842,0x1760,0x1717,0x1771,0x185D,0x19B1,0x1B36,0x1CAA,0x1DCF,0x1E73,0x1E79,0x1DDD,0x1CB4,0x1B2B,0x197C,0x17EA,0x16B1,0x15FF,0x15EE,0x167C,0x178F,0x18F7,0x1A78,0x1BCF,0x1CC4,0x1D2A,0x1CED,0x1C14,
    0x1ABC,0x191A,0x176B,0x15F0,0x14E2,0x1467,0x1490,0x1552,0x1689,0x1800,0x1977,0x1AAE,0x1B70,0x1B99,0x1B1E,0x1A10,0x1895,0x16E6,0x1544,0x13EC,0x1313,0x12D6,0x133C,0x1431,0x1588,0x1709,0x1871,0x1984,0x1A12,0x1A01,0x194F,0x1816,0x1684,0x14D5,0x134C,0x1223,0x1187,0x118D,0x1231,0x1356,
    0x14CA,0x164F,0x17A3,0x188F,0x18E9,0x18A0,0x17BE,0x1664,0x14C7,0x1326,0x11C2,0x10D2,0x1079,0x10C3,0x11A4,0x12F6,0x1480,0x1603,0x173F,0x1800,0x1827,0x17AB,0x16A0,0x152F,0x1392,0x120A,0x10D5,0x1024,0x1012,0x10A1,0x11BC,0x1334,0x14CD,0x1646,0x1763,0x17F6,0x17E9,0x173F,0x1611,0x1492,
    0x1300,0x119A,0x109C,0x102E,0x1064,0x1136,0x1284,0x1419,0x15B8,0x171E,0x1816,0x1878,0x1838,0x1761,0x1618,0x1494,0x1314,0x11D8,0x1115,0x10ED,0x1168,0x1276,0x13EE,0x1597,0x1730,0x187B,0x1946,0x1973,0x1900,0x1800,0x16A1,0x151D,0x13B7,0x12AA,0x1225,0x1241,0x12FC,0x143E,0x15D5,0x1786,
    0x190E,0x1A32,0x1AC9,0x1ABE,0x1A16,0x18F1,0x1781,0x1604,0x14BC,0x13E1,0x139A,0x13F6,0x14EB,0x1656};
    dac2 = (DAC_Device*)0x80000800;
    dac2->configReg = DAC_enable;
    dac2->dataReg = tablo[0];

    while(1)
    {
        for (i = 0 ; i < 251 ; i++)
        {
            while(!((dac2->configReg & DAC_ready) == DAC_ready));
            dac2->dataReg = tablo[i];
            while((dac2->configReg & DAC_ready) == DAC_ready);
        }
    }
    return 0;
}



int DacConst()
{
    DAC_Device* dac3;
    int Value = 0x1FFF;
    dac3 = (DAC_Device*)0x80000800;
    dac3->configReg = DAC_enable;
    while(1)
    {
        printf("\nEntrer une valeur Hexa entre 4096 et 8191 : ");
        scanf("%d",&Value);
        dac3->dataReg = Value;
    }
    return 0;
}

