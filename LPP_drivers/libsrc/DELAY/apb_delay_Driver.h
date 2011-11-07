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
#ifndef APB_DELAY_DRIVER_H
#define APB_DELAY_DRIVER_H

/*! \file apb_delay_Driver.h
    \brief LPP Interupt driver.

    This library is written to work with LPP_APB_DELAY VHDL module from LPP's FreeVHDLIB.

    \author Martin Morlot  martin.morlot@lpp.polytechnique.fr
*/

#define Delay_End 0x00001000 /**< Used to know when the VHDL delay counter stoped counting  */

/*===================================================
        T Y P E S     D E F
====================================================*/
/*! \struct DELAY_REG
    \brief Sturcture representing the Delay registers
*/
struct DELAY_REG
{
    int Cfg; /**< \brief Configuration register composed of Reset function      [HEX 0]
                                                            Start Flag          [HEX 1]
                                                            End Flag Received   [HEX 2]
                                                            End Flag            [HEX 3] */
    int Fboard; /**< \brief Board Frequency register */
    int Timer;  /**< \brief Delay duration register */
};

typedef volatile struct DELAY_REG DELAY_Device;

/*===================================================
        F U N C T I O N S
====================================================*/
/*! \fn DELAY_Device* openDELAY(int count);
    \brief Return count Delay.

    This Function scans APB devices table and returns count Delay.

    \param count The number of the Delay you whant to get. For example if you have 3 Delays on your SOC you want
    to use Delay1 so count = 1.
    \return The pointer to the device.
*/
DELAY_Device* openDELAY(int count);

/*! \fn int Setup(DELAY_Device* dev,int X);
    \brief Setup the device

    This function setup the device, reset and Board frequency.

    \param dev The Delay pointer.
    \param X the Board frequency.
*/
int Setup(DELAY_Device* dev,int X);

/*! \fn int Delay_us(DELAY_Device* dev,int T);
    \brief Generate delay

    This function genrate a delay in microsecond.

    \param dev The Delay pointer.
    \param T the Delay duration in us.
*/
int Delay_us(DELAY_Device* dev,int T);

/*! \fn int Delay_ms(DELAY_Device* dev,int T);
    \brief Generate delay

    This function genrate a delay in milisecond.

    \param dev The Delay pointer.
    \param T the Delay duration in ms.
*/
int Delay_ms(DELAY_Device* dev,int T);

/*! \fn int Delay_s(DELAY_Device* dev,int T);
    \brief Generate delay

    This function genrate a delay in second.

    \param dev The Delay pointer.
    \param T the Delay duration in s.
*/
int Delay_s(DELAY_Device* dev,int T);







#endif
