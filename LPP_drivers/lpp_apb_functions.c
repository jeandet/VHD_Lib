#include "lpp_apb_functions.h"
#include <stdio.h>



int* apbgetdevice(int PID,int VID,int count)
{
    struct apbPnPreg* dev = (struct apbPnPreg*)(APB_TBL_HEAD + sizeof(struct apbPnPreg));
    int id;
    id = (PID<<12) | (VID<<24);
    while(dev != (struct apbPnPreg*)(APB_TBL_HEAD|0xFFF))
        {
            if((dev->idReg & 0xFFFFF000) == id)
            {
                if(count == 0)
                {
                    return (int*) (APB_BASE_ADDRS | (dev->bar&0xFFF00000)>>12);
                }
                count-=1;
            }
            dev += 1;
        }
    return NULL;
}


void apbgetdeviceinfofromdevptr(const struct apbPnPreg* dev,struct apbdevinfo* devinfo)
{

    devinfo->productID = (dev->idReg>>12) & 0xFFF;
    devinfo->vendorID = (dev->idReg>>24) & 0xFF;
    devinfo->address = ((dev->bar>>12) & 0xFFF00)|APB_BASE_ADDRS;
    devinfo->irq = dev->idReg & 0x1F;
    devinfo->mask = (dev->bar>>4)&0xFFF;
    devinfo->version = (dev->idReg>>5)&0x1F;
}

void apbgetdeviceinfofromid(int PID,int VID,int count,struct apbdevinfo* devinfo)
{
    struct apbPnPreg* dev = (struct apbPnPreg*)(APB_TBL_HEAD + sizeof(struct apbPnPreg));
    int id;
    id = (PID<<12) | (VID<<24);
    while(dev != (struct apbPnPreg*)(APB_TBL_HEAD|0xFFF))
        {
            if((dev->idReg & 0xFFFFF000) == id)
            {
                if(count == 0)
                {
                    devinfo->productID = PID;
                    devinfo->vendorID = VID;
                    devinfo->address = ((dev->bar>>12) & 0xFFF00)|APB_BASE_ADDRS;
                    devinfo->irq = dev->idReg & 0x1F;
                    devinfo->mask = (dev->bar>>4)&0xFFF;
                    devinfo->version = (dev->idReg>>5)&0x1F;
                    return;
                }
                count-=1;
            }
            dev += 1;
        }
}



void apbprintdeviceinfo(struct apbdevinfo devinfo)
{
    printf("Vendor ID = 0x%x\n",devinfo.vendorID);
    printf("Product ID = 0x%x\n",devinfo.productID);
    printf("Device address = 0x%x\n",devinfo.address);
    printf("Device Irq = %d\n",devinfo.irq);
    printf("Device mask = 0x%x\n",devinfo.mask);
    printf("Device Version = %d\n",devinfo.version);
}


void apbprintdeviceslist()
{
    struct apbdevinfo devinfo;
    struct apbPnPreg* dev = (struct apbPnPreg*)(APB_TBL_HEAD );//+ sizeof(struct apbPnPreg));
    int i =0;
    int fisrtBAR;
    while((dev->idReg == 0) && (i<APB_MAX_DEVICES))
    {
        dev += 1;
        i+=1;
    }
    fisrtBAR = dev->bar;
    for(i=i;i<APB_MAX_DEVICES;i++)
        {
            if((dev->idReg != 0 ))
            {
                apbgetdeviceinfofromdevptr(dev,&devinfo);
                printf("\n\n======= new device found========\n");
                apbprintdeviceinfo(devinfo);
            }
            dev += 1;
            if(dev->bar == fisrtBAR)
                break;
        }
}

