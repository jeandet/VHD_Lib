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
-------------------------------------------------------------------------------
--                      Author : Martin Morlot
--                     Mail : martin.morlot@lpp.polytechnique.fr
-----------------------------------------------------------------------------*/
#ifndef APB_FIFO_DRIVER_H
#define APB_FIFO_DRIVER_H

/*! \file apb_fifo_Driver.h
    \brief LPP FIFO driver.

    This library is written to work with LPP_APB_FIFO VHDL module from LPP's FreeVHDLIB. It represents a standard FIFO working,
    used in many type of application.

    \todo Check "DEVICE1 => count = 2" function Open
    \author Martin Morlot  martin.morlot@lpp.polytechnique.fr
*/
#define FIFO_Ctrl 0
#define FIFO_RWdata 1

#define FIFO_Full 0x00010000
#define FIFO_Empty 0x00000001
#define FIFO_ReUse 0x00000002

#define Mask_2hex 0x000000FF
#define Mask_4hex 0x0000FFFF


/*===================================================
        T Y P E S     D E F
====================================================*/

/*! \struct APB_FIFO_REG
    \brief Sturcture representing the fifo registers
*/
struct APB_FIFO_REG
{
    volatile int IDreg;
    volatile int FIFOreg[2*8];
};

typedef volatile struct APB_FIFO_REG FIFO_Device;

/*===================================================
        F U N C T I O N S
====================================================*/

/*! \fn APB_FIFO_Device* apbfifoOpen(int count);
    \brief Return count FIFO.

    This Function scans APB devices table and returns count FIFO.

    \param count The number of the FIFO you whant to get. For example if you have 3 FIFOS on your SOC you want
    to use FIFO1 so count = 1.
    \return The pointer to the device.
*/
FIFO_Device* openFIFO(int count);
int FillFifo(FIFO_Device* dev,int ID,int Tbl[],int count);

#endif
