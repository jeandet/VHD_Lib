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

    \author Martin Morlot  martin.morlot@lpp.polytechnique.fr
*/
#define FIFO_Empty 0x00000100 /**< Show that the FIFO is Empty */
#define FIFO_Full  0x00001000 /**< Show that the FIFO is Full */
#define Boucle     0x00110000 /**< Configuration for reused the same value of the FIFO */
#define NoBoucle   0xFFEEFFFF /**< Unlock the previous configuration */


/*===================================================
        T Y P E S     D E F
====================================================*/

/*! \struct APB_FIFO_REG
    \brief Sturcture representing the fifo registers
*/
struct APB_FIFO_REG
{
    int rwdata;  /**< \brief Data register Write/Read */
    int raddr;   /**< \brief Address register for the reading operation */
    int cfgreg;  /**< \brief Configuration register composed of Read enable Flag [HEX 0]
                                                                Write enable Flag [HEX 1]
                                                                Empty Flag [HEX 2]
                                                                Full Flag [HEX 3]
                                                                ReUse Flag [HEX 4]
                                                                Lock Flag [HEX 5]
                                                                Dummy "C" [HEX 6/7] */
    int dummy0;  /**< \brief Unused register, aesthetic interest */
    int dummy1;  /**< \brief Unused register, aesthetic interest */
    int waddr;   /**< \brief Address register for the writing operation */
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

/*! \fn int FillFifo(FIFO_Device* dev,int Tbl[],int A);
    \brief a Fill in FIFO function.

    This Function fill in the FIFO with a table data.

    \param dev The FFT pointer.
    \param Tbl[] The data table.
    \param A The data table size.
*/
int FillFifo(FIFO_Device* dev,int Tbl[],int A);

#endif
