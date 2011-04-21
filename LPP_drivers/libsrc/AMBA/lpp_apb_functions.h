/*------------------------------------------------------------------------------
--  This file is a part of the LPP VHDL IP LIBRARY
--  Copyright (C) 2009 - 2010, Laboratory of Plasmas Physic - CNRS
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 3 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
-------------------------------------------------------------------------------*/
/*--                  Author : Alexis Jeandet
--                     Mail : alexis.jeandet@lpp.polytechnique.fr
----------------------------------------------------------------------------*/
#ifndef LPP_APB_FUNCTIONS_H
#define LPP_APB_FUNCTIONS_H

#define APB_TBL_HEAD   0x800FF000  /**< Start address of APB devices list on AHB2APB bridge*/
#define APB_BASE_ADDRS 0x80000000  /**< Start address of APB bus*/
#define APB_MAX_DEVICES 256        /**< Maximun device count on APB bus*/

#include "apb_devices_list.h"


/*! \file lpp_apb_functions.h
    \brief General purpose APB functions.
    
    This library is written to work with AHB2APB VHDL module from Gaisler's GRLIB. It help you to find your device 
    on the APB bus by providing scan functions, it extract information such as device Version, IRQ value, Address mask.
    You can use it to print the APB devices list on your SOC.
    
    \author Alexis Jeandet
    \todo implemente a descriptor structure for any APB device
*/


/*! \struct apbPnPreg
    \brief Structure representing a device descriptor register on Grlib's AHB2APB brige with plug and play feature
*/
struct apbPnPreg
{
  int idReg;    /**< \brief id register composed of Vendor ID [31:24], Device ID [23:12], CT [11:10], Version [9:5], IRQ [4:0] */
  int bar;      /**< \brief Bank Address Register composed of Device's ADDRESS [31:20], MASK [14:4], TYPE [3:0] */
};


/*! \struct apbdevinfo
    \brief Structure holding an APB device informations
    
    This information are extracted from the descriptor registers on Grlib's AHB2APB brige with plug and play feature
*/
struct apbdevinfo
{
    int vendorID;       /**< \brief Stores the Vendor ID of the current device */
    int productID;      /**< \brief Stores the Product ID of the current device */
    int version;        /**< \brief Stores the Version of the current device */
    int irq;            /**< \brief Stores the interrupt Number of the current device */
    int address;        /**< \brief Stores the base address of the current device */
    int mask;           /**< \brief Stores the address mask of the current device, it gives the address space of this device */
};




/*! \fn int* apbgetdevice(int PID,int VID,int count);
    \brief Find device with given VID/PID
    
    This Function scans APB devices table and returns counth device according to VID and PID 
    
    \param PID The PID of the device you whant to get.
    \param VID The VID of the device you whant to get.
    \param count The number of the device you whant to get. For example if you have 3 UARTS on your SOC you whant 
    to use UART1 so count = 2.
    
    \return The pointer to the device.
*/
int* apbgetdevice(int PID,int VID,int count);

/*! \fn void apbgetdeviceinfofromid(int PID,int VID,int count,struct apbdevinfo* devinfo);
    \brief Record device informations with given VID/PID
    
        This Function scans APB devices table and returns counth device informations according VID and PID.
    
    \param PID The PID of the device you whant to get.
    \param VID The VID of the device you whant to get.
    \param count The number of the device you whant to get. For example if you have 3 UARTS on your SOC you whant 
    to use UART1 so count = 2.
    \param devinfo The device information structure to be populated.
*/
void apbgetdeviceinfofromid(int PID,int VID,int count,struct apbdevinfo* devinfo);


/*! \fn void apbgetdeviceinfofromdevptr(const struct apbPnPreg* dev,struct apbdevinfo* devinfo);
    \brief Record device informations with given AHB2APB Plugn'Play register.
    
        This Function extract device informations from the given AHB2APB Plugn'Play register end write them in devinfo.
    
    \param dev AHB2APB Plugn'Play register corresponding to the device.
    \param devinfo The device information structure to be populated.
*/
void apbgetdeviceinfofromdevptr(const struct apbPnPreg* dev,struct apbdevinfo* devinfo);



/*! \fn void apbprintdeviceinfo(struct apbdevinfo devinfo);
    \brief Print given device informations in stdout.
    
    \param devinfo The device information structure to be printed.
*/
void apbprintdeviceinfo(struct apbdevinfo devinfo);



/*! \fn void apbprintdeviceslist();
    \brief Print APB devices informations in stdout.
    
        This function list all devices on APB bus and print theirs informations.
    
*/
void apbprintdeviceslist();



#endif // LPP_APB_FUNCTIONS_H

