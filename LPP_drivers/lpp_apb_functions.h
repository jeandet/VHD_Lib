#ifndef LPP_APB_FUNCTIONS_H
#define LPP_APB_FUNCTIONS_H

#define APB_TBL_HEAD   0x800FF000
#define APB_BASE_ADDRS 0x80000000
#define APB_MAX_DEVICES 256

#define VENDOR_LPP  0x19

#define ROCKET_TM           0x001
#define otherCore           0x002
#define LPP_SIMPLE_DIODE    0x003
#define LPP_MULTI_DIODE     0x004
#define LPP_LCD_CTRLR       0x005

/** @todo implemente a descriptor structure for any APB device */


/** Structure representing a device descriptor register on Grlib's AHB2APB brige with plug and play feature */
struct apbPnPreg
{
  int idReg;    /**< id register composed of Vendor ID [31:24], Device ID [23:12], CT [11:10], Version [9:5], IRQ [4:0] */
  int bar;      /**< Bank Address Register composed of Device's ADDRESS [31:20], MASK [14:4], TYPE [3:0] */
};

struct apbdevinfo
{
    int vendorID;
    int productID;
    int version;
    int irq;
    int address;
    int mask;
};

/** This Function scans APB devices table and returns counth device according to VID and PID */
int* apbgetdevice(int PID,int VID,int count);
/** This Function scans APB devices table and returns counth device informations according VID and PID  */
void apbgetdeviceinfofromid(int PID,int VID,int count,struct apbdevinfo* devinfo);

void apbgetdeviceinfofromdevptr(const struct apbPnPreg* dev,struct apbdevinfo* devinfo);


void apbprintdeviceinfo(struct apbdevinfo devinfo);

void apbprintdeviceslist();
#endif // LPP_APB_FUNCTIONS_H
